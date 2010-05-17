
kernel:     file format elf32-i386

Disassembly of section .text:

00100000 <brelse>:
}

// Release the buffer buf.
void
brelse(struct buf *b)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 04             	sub    $0x4,%esp
  100007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10000a:	f6 03 01             	testb  $0x1,(%ebx)
  10000d:	74 58                	je     100067 <brelse+0x67>
    panic("brelse");

  acquire(&buf_table_lock);
  10000f:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100016:	e8 d5 3d 00 00       	call   103df0 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 53 10             	mov    0x10(%ebx),%edx
  10001e:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  100021:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  if((b->flags & B_BUSY) == 0)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  100024:	89 42 0c             	mov    %eax,0xc(%edx)
  b->prev->next = b->next;
  100027:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bufhead.next;
  b->prev = &bufhead;
  10002a:	c7 43 0c 60 78 10 00 	movl   $0x107860,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bufhead.next;
  100034:	a1 70 78 10 00       	mov    0x107870,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 70 78 10 00       	mov    0x107870,%eax
  bufhead.next = b;
  100041:	89 1d 70 78 10 00    	mov    %ebx,0x107870

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 80 7a 10 00 	movl   $0x107a80,(%esp)
  100051:	e8 3a 31 00 00       	call   103190 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 80 8f 10 00 	movl   $0x108f80,0x8(%ebp)
}
  10005d:	83 c4 04             	add    $0x4,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 49 3d 00 00       	jmp    103db0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 a0 5e 10 00 	movl   $0x105ea0,(%esp)
  10006e:	e8 2d 08 00 00       	call   1008a0 <panic>
  100073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100079:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00100080 <bwrite>:
}

// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  100080:	55                   	push   %ebp
  100081:	89 e5                	mov    %esp,%ebp
  100083:	83 ec 08             	sub    $0x8,%esp
  100086:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
  100089:	8b 02                	mov    (%edx),%eax
  10008b:	a8 01                	test   $0x1,%al
  10008d:	74 0e                	je     10009d <bwrite+0x1d>
    panic("bwrite");
  b->flags |= B_DIRTY;
  10008f:	83 c8 04             	or     $0x4,%eax
  100092:	89 02                	mov    %eax,(%edx)
  ide_rw(b);
  100094:	89 55 08             	mov    %edx,0x8(%ebp)
}
  100097:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  ide_rw(b);
  100098:	e9 83 1e 00 00       	jmp    101f20 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10009d:	c7 04 24 a7 5e 10 00 	movl   $0x105ea7,(%esp)
  1000a4:	e8 f7 07 00 00       	call   1008a0 <panic>
  1000a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001000b0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  1000b0:	55                   	push   %ebp
  1000b1:	89 e5                	mov    %esp,%ebp
  1000b3:	57                   	push   %edi
  1000b4:	56                   	push   %esi
  1000b5:	53                   	push   %ebx
  1000b6:	83 ec 0c             	sub    $0xc,%esp
  1000b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&buf_table_lock);
  1000bf:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  1000c6:	e8 25 3d 00 00       	call   103df0 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  1000cb:	8b 1d 70 78 10 00    	mov    0x107870,%ebx
  1000d1:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 3d                	jmp    100118 <bread+0x68>
  1000db:	90                   	nop    
  1000dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  1000e9:	74 2d                	je     100118 <bread+0x68>
    if((b->flags & (B_BUSY|B_VALID)) &&
  1000eb:	8b 03                	mov    (%ebx),%eax
  1000ed:	a8 03                	test   $0x3,%al
  1000ef:	74 ef                	je     1000e0 <bread+0x30>
  1000f1:	3b 73 04             	cmp    0x4(%ebx),%esi
  1000f4:	75 ea                	jne    1000e0 <bread+0x30>
  1000f6:	3b 7b 08             	cmp    0x8(%ebx),%edi
  1000f9:	75 e5                	jne    1000e0 <bread+0x30>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
  1000fb:	a8 01                	test   $0x1,%al
  1000fd:	8d 76 00             	lea    0x0(%esi),%esi
  100100:	74 7b                	je     10017d <bread+0xcd>
        sleep(buf, &buf_table_lock);
  100102:	c7 44 24 04 80 8f 10 	movl   $0x108f80,0x4(%esp)
  100109:	00 
  10010a:	c7 04 24 80 7a 10 00 	movl   $0x107a80,(%esp)
  100111:	e8 aa 32 00 00       	call   1033c0 <sleep>
  100116:	eb b3                	jmp    1000cb <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100118:	8b 1d 6c 78 10 00    	mov    0x10786c,%ebx
  10011e:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  100124:	75 0d                	jne    100133 <bread+0x83>
  100126:	eb 49                	jmp    100171 <bread+0xc1>
  100128:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10012b:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  100131:	74 3e                	je     100171 <bread+0xc1>
    if((b->flags & B_BUSY) == 0){
  100133:	f6 03 01             	testb  $0x1,(%ebx)
  100136:	75 f0                	jne    100128 <bread+0x78>
      b->flags = B_BUSY;
  100138:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      b->dev = dev;
  10013e:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  100141:	89 7b 08             	mov    %edi,0x8(%ebx)
      release(&buf_table_lock);
  100144:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  10014b:	e8 60 3c 00 00       	call   103db0 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  100150:	f6 03 02             	testb  $0x2,(%ebx)
  100153:	74 0a                	je     10015f <bread+0xaf>
    ide_rw(b);
  return b;
}
  100155:	83 c4 0c             	add    $0xc,%esp
  100158:	89 d8                	mov    %ebx,%eax
  10015a:	5b                   	pop    %ebx
  10015b:	5e                   	pop    %esi
  10015c:	5f                   	pop    %edi
  10015d:	5d                   	pop    %ebp
  10015e:	c3                   	ret    
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
    ide_rw(b);
  10015f:	89 1c 24             	mov    %ebx,(%esp)
  100162:	e8 b9 1d 00 00       	call   101f20 <ide_rw>
  return b;
}
  100167:	83 c4 0c             	add    $0xc,%esp
  10016a:	89 d8                	mov    %ebx,%eax
  10016c:	5b                   	pop    %ebx
  10016d:	5e                   	pop    %esi
  10016e:	5f                   	pop    %edi
  10016f:	5d                   	pop    %ebp
  100170:	c3                   	ret    
      b->sector = sector;
      release(&buf_table_lock);
      return b;
    }
  }
  panic("bget: no buffers");
  100171:	c7 04 24 ae 5e 10 00 	movl   $0x105eae,(%esp)
  100178:	e8 23 07 00 00       	call   1008a0 <panic>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
        sleep(buf, &buf_table_lock);
        goto loop;
      }
      b->flags |= B_BUSY;
  10017d:	83 c8 01             	or     $0x1,%eax
  100180:	89 03                	mov    %eax,(%ebx)
      release(&buf_table_lock);
  100182:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100189:	e8 22 3c 00 00       	call   103db0 <release>
  10018e:	eb c0                	jmp    100150 <bread+0xa0>

00100190 <binit>:
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
{
  100190:	55                   	push   %ebp
  100191:	89 e5                	mov    %esp,%ebp
  100193:	83 ec 08             	sub    $0x8,%esp
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");
  100196:	c7 44 24 04 bf 5e 10 	movl   $0x105ebf,0x4(%esp)
  10019d:	00 
  10019e:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  1001a5:	e8 86 3a 00 00       	call   103c30 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  1001aa:	ba 80 7a 10 00       	mov    $0x107a80,%edx
  1001af:	b9 60 78 10 00       	mov    $0x107860,%ecx
  1001b4:	c7 05 6c 78 10 00 60 	movl   $0x107860,0x10786c
  1001bb:	78 10 00 
  1001be:	eb 04                	jmp    1001c4 <binit+0x34>
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001c0:	89 d1                	mov    %edx,%ecx
  1001c2:	89 c2                	mov    %eax,%edx
  1001c4:	8d 82 18 02 00 00    	lea    0x218(%edx),%eax
  1001ca:	3d 70 8f 10 00       	cmp    $0x108f70,%eax
    b->next = bufhead.next;
    b->prev = &bufhead;
  1001cf:	c7 42 0c 60 78 10 00 	movl   $0x107860,0xc(%edx)

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  1001d6:	89 4a 10             	mov    %ecx,0x10(%edx)
    b->prev = &bufhead;
    bufhead.next->prev = b;
  1001d9:	89 51 0c             	mov    %edx,0xc(%ecx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001dc:	75 e2                	jne    1001c0 <binit+0x30>
  1001de:	c7 05 70 78 10 00 58 	movl   $0x108d58,0x107870
  1001e5:	8d 10 00 
    b->next = bufhead.next;
    b->prev = &bufhead;
    bufhead.next->prev = b;
    bufhead.next = b;
  }
}
  1001e8:	c9                   	leave  
  1001e9:	c3                   	ret    
  1001ea:	90                   	nop    
  1001eb:	90                   	nop    
  1001ec:	90                   	nop    
  1001ed:	90                   	nop    
  1001ee:	90                   	nop    
  1001ef:	90                   	nop    

001001f0 <console_init>:
  return target - n;
}

void
console_init(void)
{
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 08             	sub    $0x8,%esp
  initlock(&console_lock, "console");
  1001f6:	c7 44 24 04 c9 5e 10 	movl   $0x105ec9,0x4(%esp)
  1001fd:	00 
  1001fe:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100205:	e8 26 3a 00 00       	call   103c30 <initlock>
  initlock(&input.lock, "console input");
  10020a:	c7 44 24 04 d1 5e 10 	movl   $0x105ed1,0x4(%esp)
  100211:	00 
  100212:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100219:	e8 12 3a 00 00       	call   103c30 <initlock>

  devsw[CONSOLE].write = console_write;
  devsw[CONSOLE].read = console_read;
  use_console_lock = 1;

  pic_enable(IRQ_KBD);
  10021e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
console_init(void)
{
  initlock(&console_lock, "console");
  initlock(&input.lock, "console input");

  devsw[CONSOLE].write = console_write;
  100225:	c7 05 2c 9a 10 00 10 	movl   $0x100610,0x109a2c
  10022c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10022f:	c7 05 28 9a 10 00 60 	movl   $0x100260,0x109a28
  100236:	02 10 00 
  use_console_lock = 1;
  100239:	c7 05 a4 77 10 00 01 	movl   $0x1,0x1077a4
  100240:	00 00 00 

  pic_enable(IRQ_KBD);
  100243:	e8 b8 29 00 00       	call   102c00 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  100248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10024f:	00 
  100250:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100257:	e8 b4 1e 00 00       	call   102110 <ioapic_enable>
}
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    
  10025e:	66 90                	xchg   %ax,%ax

00100260 <console_read>:
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  100260:	55                   	push   %ebp
  100261:	89 e5                	mov    %esp,%ebp
  100263:	57                   	push   %edi
  100264:	56                   	push   %esi
  100265:	53                   	push   %ebx
  100266:	83 ec 0c             	sub    $0xc,%esp
  100269:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
  10026c:	8b 45 08             	mov    0x8(%ebp),%eax
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  10026f:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  target = n;
  100272:	89 df                	mov    %ebx,%edi
console_read(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  100274:	89 04 24             	mov    %eax,(%esp)
  100277:	e8 94 18 00 00       	call   101b10 <iunlock>
  target = n;
  acquire(&input.lock);
  10027c:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100283:	e8 68 3b 00 00       	call   103df0 <acquire>
  while(n > 0){
  100288:	85 db                	test   %ebx,%ebx
  10028a:	7f 25                	jg     1002b1 <console_read+0x51>
  10028c:	e9 af 00 00 00       	jmp    100340 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100291:	e8 2a 2f 00 00       	call   1031c0 <curproc>
  100296:	8b 40 1c             	mov    0x1c(%eax),%eax
  100299:	85 c0                	test   %eax,%eax
  10029b:	75 4e                	jne    1002eb <console_read+0x8b>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10029d:	c7 44 24 04 c0 8f 10 	movl   $0x108fc0,0x4(%esp)
  1002a4:	00 
  1002a5:	c7 04 24 74 90 10 00 	movl   $0x109074,(%esp)
  1002ac:	e8 0f 31 00 00       	call   1033c0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1002b1:	8b 15 74 90 10 00    	mov    0x109074,%edx
  1002b7:	3b 15 78 90 10 00    	cmp    0x109078,%edx
  1002bd:	74 d2                	je     100291 <console_read+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  1002bf:	89 d0                	mov    %edx,%eax
  1002c1:	83 e0 7f             	and    $0x7f,%eax
  1002c4:	0f b6 88 f4 8f 10 00 	movzbl 0x108ff4(%eax),%ecx
  1002cb:	8d 42 01             	lea    0x1(%edx),%eax
  1002ce:	a3 74 90 10 00       	mov    %eax,0x109074
    if(c == C('D')){  // EOF
  1002d3:	80 f9 04             	cmp    $0x4,%cl
  1002d6:	74 39                	je     100311 <console_read+0xb1>
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
  1002d8:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  1002db:	80 f9 0a             	cmp    $0xa,%cl
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1002de:	88 0e                	mov    %cl,(%esi)
    --n;
    if(c == '\n')
  1002e0:	74 39                	je     10031b <console_read+0xbb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  1002e2:	85 db                	test   %ebx,%ebx
  1002e4:	74 37                	je     10031d <console_read+0xbd>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1002e6:	83 c6 01             	add    $0x1,%esi
  1002e9:	eb c6                	jmp    1002b1 <console_read+0x51>
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  1002eb:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
        ilock(ip);
  1002f2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  1002f7:	e8 b4 3a 00 00       	call   103db0 <release>
        ilock(ip);
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	89 04 24             	mov    %eax,(%esp)
  100302:	e8 79 18 00 00       	call   101b80 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  100307:	83 c4 0c             	add    $0xc,%esp
  10030a:	89 d8                	mov    %ebx,%eax
  10030c:	5b                   	pop    %ebx
  10030d:	5e                   	pop    %esi
  10030e:	5f                   	pop    %edi
  10030f:	5d                   	pop    %ebp
  100310:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  100311:	39 df                	cmp    %ebx,%edi
  100313:	76 06                	jbe    10031b <console_read+0xbb>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  100315:	89 15 74 90 10 00    	mov    %edx,0x109074
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
  10031b:	29 df                	sub    %ebx,%edi
  10031d:	89 fb                	mov    %edi,%ebx
      break;
  }
  release(&input.lock);
  10031f:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100326:	e8 85 3a 00 00       	call   103db0 <release>
  ilock(ip);
  10032b:	8b 45 08             	mov    0x8(%ebp),%eax
  10032e:	89 04 24             	mov    %eax,(%esp)
  100331:	e8 4a 18 00 00       	call   101b80 <ilock>

  return target - n;
}
  100336:	83 c4 0c             	add    $0xc,%esp
  100339:	89 d8                	mov    %ebx,%eax
  10033b:	5b                   	pop    %ebx
  10033c:	5e                   	pop    %esi
  10033d:	5f                   	pop    %edi
  10033e:	5d                   	pop    %ebp
  10033f:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100340:	31 db                	xor    %ebx,%ebx
  100342:	eb db                	jmp    10031f <console_read+0xbf>
  100344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10034a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100350 <cons_putc>:
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  100350:	55                   	push   %ebp
  100351:	89 e5                	mov    %esp,%ebp
  100353:	57                   	push   %edi
  100354:	56                   	push   %esi
  100355:	53                   	push   %ebx
  100356:	83 ec 0c             	sub    $0xc,%esp
  if(panicked){
  100359:	8b 15 a0 77 10 00    	mov    0x1077a0,%edx
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  10035f:	8b 75 08             	mov    0x8(%ebp),%esi
  if(panicked){
  100362:	85 d2                	test   %edx,%edx
  100364:	0f 85 d9 00 00 00    	jne    100443 <cons_putc+0xf3>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10036a:	ba 79 03 00 00       	mov    $0x379,%edx
  10036f:	ec                   	in     (%dx),%al
    cli();
    for(;;)
      ;
  100370:	31 c9                	xor    %ecx,%ecx
static void
lpt_putc(int c)
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
  100372:	84 c0                	test   %al,%al
  100374:	79 0d                	jns    100383 <cons_putc+0x33>
  100376:	eb 15                	jmp    10038d <cons_putc+0x3d>
  100378:	83 c1 01             	add    $0x1,%ecx
  10037b:	81 f9 00 32 00 00    	cmp    $0x3200,%ecx
  100381:	74 0a                	je     10038d <cons_putc+0x3d>
  100383:	ba 79 03 00 00       	mov    $0x379,%edx
  100388:	ec                   	in     (%dx),%al
  100389:	84 c0                	test   %al,%al
  10038b:	79 eb                	jns    100378 <cons_putc+0x28>
    ;
  if(c == BACKSPACE)
  10038d:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  100393:	b8 08 00 00 00       	mov    $0x8,%eax
  100398:	74 02                	je     10039c <cons_putc+0x4c>
  10039a:	89 f0                	mov    %esi,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10039c:	ba 78 03 00 00       	mov    $0x378,%edx
  1003a1:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003a2:	b8 0d 00 00 00       	mov    $0xd,%eax
  1003a7:	b2 7a                	mov    $0x7a,%dl
  1003a9:	ee                   	out    %al,(%dx)
  1003aa:	b8 08 00 00 00       	mov    $0x8,%eax
  1003af:	ee                   	out    %al,(%dx)
  1003b0:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  1003b5:	b8 0e 00 00 00       	mov    $0xe,%eax
  1003ba:	89 ca                	mov    %ecx,%edx
  1003bc:	ee                   	out    %al,(%dx)
  1003bd:	bf d5 03 00 00       	mov    $0x3d5,%edi
  1003c2:	89 fa                	mov    %edi,%edx
  1003c4:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  1003c5:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1003c8:	89 ca                	mov    %ecx,%edx
  1003ca:	c1 e3 08             	shl    $0x8,%ebx
  1003cd:	b8 0f 00 00 00       	mov    $0xf,%eax
  1003d2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003d3:	89 fa                	mov    %edi,%edx
  1003d5:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  1003d6:	0f b6 c0             	movzbl %al,%eax
  1003d9:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  1003db:	83 fe 0a             	cmp    $0xa,%esi
  1003de:	74 66                	je     100446 <cons_putc+0xf6>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  1003e0:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  1003e6:	0f 84 b9 00 00 00    	je     1004a5 <cons_putc+0x155>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  1003ec:	89 f0                	mov    %esi,%eax
  1003ee:	66 25 ff 00          	and    $0xff,%ax
  1003f2:	80 cc 07             	or     $0x7,%ah
  1003f5:	66 89 84 1b 00 80 0b 	mov    %ax,0xb8000(%ebx,%ebx,1)
  1003fc:	00 
  1003fd:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  100400:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  100406:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
  10040d:	7f 4e                	jg     10045d <cons_putc+0x10d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10040f:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  100414:	b8 0e 00 00 00       	mov    $0xe,%eax
  100419:	89 ca                	mov    %ecx,%edx
  10041b:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  10041c:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100421:	89 d8                	mov    %ebx,%eax
  100423:	c1 f8 08             	sar    $0x8,%eax
  100426:	89 fa                	mov    %edi,%edx
  100428:	ee                   	out    %al,(%dx)
  100429:	b8 0f 00 00 00       	mov    $0xf,%eax
  10042e:	89 ca                	mov    %ecx,%edx
  100430:	ee                   	out    %al,(%dx)
  100431:	89 d8                	mov    %ebx,%eax
  100433:	89 fa                	mov    %edi,%edx
  100435:	ee                   	out    %al,(%dx)
  100436:	66 c7 06 20 07       	movw   $0x720,(%esi)
      ;
  }

  lpt_putc(c);
  cga_putc(c);
}
  10043b:	83 c4 0c             	add    $0xc,%esp
  10043e:	5b                   	pop    %ebx
  10043f:	5e                   	pop    %esi
  100440:	5f                   	pop    %edi
  100441:	5d                   	pop    %ebp
  100442:	c3                   	ret    
}

static inline void
cli(void)
{
  asm volatile("cli");
  100443:	fa                   	cli    
  100444:	eb fe                	jmp    100444 <cons_putc+0xf4>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  100446:	89 d8                	mov    %ebx,%eax
  100448:	ba 67 66 66 66       	mov    $0x66666667,%edx
  10044d:	f7 ea                	imul   %edx
  10044f:	c1 ea 05             	shr    $0x5,%edx
  100452:	8d 14 92             	lea    (%edx,%edx,4),%edx
  100455:	c1 e2 04             	shl    $0x4,%edx
  100458:	8d 5a 50             	lea    0x50(%edx),%ebx
  10045b:	eb a3                	jmp    100400 <cons_putc+0xb0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  10045d:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  100460:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  100467:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100468:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  10046f:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  100476:	00 
  100477:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  10047e:	e8 7d 3a 00 00       	call   103f00 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100483:	b8 80 07 00 00       	mov    $0x780,%eax
  100488:	29 d8                	sub    %ebx,%eax
  10048a:	01 c0                	add    %eax,%eax
  10048c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100490:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100497:	00 
  100498:	89 34 24             	mov    %esi,(%esp)
  10049b:	e8 b0 39 00 00       	call   103e50 <memset>
  1004a0:	e9 6a ff ff ff       	jmp    10040f <cons_putc+0xbf>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  1004a5:	85 db                	test   %ebx,%ebx
  1004a7:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
  1004ae:	0f 8e 5b ff ff ff    	jle    10040f <cons_putc+0xbf>
      crt[--pos] = ' ' | 0x0700;
  1004b4:	83 eb 01             	sub    $0x1,%ebx
  1004b7:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  1004be:	00 20 07 
  1004c1:	e9 3a ff ff ff       	jmp    100400 <cons_putc+0xb0>
  1004c6:	8d 76 00             	lea    0x0(%esi),%esi
  1004c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001004d0 <console_intr>:

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  1004d0:	55                   	push   %ebp
  1004d1:	89 e5                	mov    %esp,%ebp
  1004d3:	56                   	push   %esi
  1004d4:	53                   	push   %ebx
  1004d5:	83 ec 10             	sub    $0x10,%esp
  1004d8:	8b 75 08             	mov    0x8(%ebp),%esi
  int c;

  acquire(&input.lock);
  1004db:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  1004e2:	e8 09 39 00 00       	call   103df0 <acquire>
  while((c = getc()) >= 0){
  1004e7:	ff d6                	call   *%esi
  1004e9:	85 c0                	test   %eax,%eax
  1004eb:	89 c3                	mov    %eax,%ebx
  1004ed:	0f 88 90 00 00 00    	js     100583 <console_intr+0xb3>
    switch(c){
  1004f3:	83 fb 10             	cmp    $0x10,%ebx
  1004f6:	0f 84 d4 00 00 00    	je     1005d0 <console_intr+0x100>
  1004fc:	83 fb 15             	cmp    $0x15,%ebx
  1004ff:	90                   	nop    
  100500:	0f 84 b6 00 00 00    	je     1005bc <console_intr+0xec>
  100506:	83 fb 08             	cmp    $0x8,%ebx
  100509:	0f 84 cb 00 00 00    	je     1005da <console_intr+0x10a>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  10050f:	85 db                	test   %ebx,%ebx
  100511:	74 d4                	je     1004e7 <console_intr+0x17>
  100513:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	2b 05 74 90 10 00    	sub    0x109074,%eax
  100521:	83 f8 7f             	cmp    $0x7f,%eax
  100524:	77 c1                	ja     1004e7 <console_intr+0x17>
        input.buf[input.e++ % INPUT_BUF] = c;
  100526:	89 d0                	mov    %edx,%eax
  100528:	83 e0 7f             	and    $0x7f,%eax
  10052b:	88 98 f4 8f 10 00    	mov    %bl,0x108ff4(%eax)
  100531:	8d 42 01             	lea    0x1(%edx),%eax
  100534:	a3 7c 90 10 00       	mov    %eax,0x10907c
        cons_putc(c);
  100539:	89 1c 24             	mov    %ebx,(%esp)
  10053c:	e8 0f fe ff ff       	call   100350 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100541:	83 fb 0a             	cmp    $0xa,%ebx
  100544:	0f 84 ba 00 00 00    	je     100604 <console_intr+0x134>
  10054a:	83 fb 04             	cmp    $0x4,%ebx
  10054d:	0f 84 b1 00 00 00    	je     100604 <console_intr+0x134>
  100553:	a1 74 90 10 00       	mov    0x109074,%eax
  100558:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
  10055e:	83 e8 80             	sub    $0xffffff80,%eax
  100561:	39 c2                	cmp    %eax,%edx
  100563:	75 82                	jne    1004e7 <console_intr+0x17>
          input.w = input.e;
  100565:	89 15 78 90 10 00    	mov    %edx,0x109078
          wakeup(&input.r);
  10056b:	c7 04 24 74 90 10 00 	movl   $0x109074,(%esp)
  100572:	e8 19 2c 00 00       	call   103190 <wakeup>
console_intr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  100577:	ff d6                	call   *%esi
  100579:	85 c0                	test   %eax,%eax
  10057b:	89 c3                	mov    %eax,%ebx
  10057d:	0f 89 70 ff ff ff    	jns    1004f3 <console_intr+0x23>
        }
      }
      break;
    }
  }
  release(&input.lock);
  100583:	c7 45 08 c0 8f 10 00 	movl   $0x108fc0,0x8(%ebp)
}
  10058a:	83 c4 10             	add    $0x10,%esp
  10058d:	5b                   	pop    %ebx
  10058e:	5e                   	pop    %esi
  10058f:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  100590:	e9 1b 38 00 00       	jmp    103db0 <release>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	89 d0                	mov    %edx,%eax
  10059a:	83 e0 7f             	and    $0x7f,%eax
  10059d:	80 b8 f4 8f 10 00 0a 	cmpb   $0xa,0x108ff4(%eax)
  1005a4:	0f 84 3d ff ff ff    	je     1004e7 <console_intr+0x17>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1005aa:	89 15 7c 90 10 00    	mov    %edx,0x10907c
        cons_putc(BACKSPACE);
  1005b0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1005b7:	e8 94 fd ff ff       	call   100350 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1005bc:	a1 7c 90 10 00       	mov    0x10907c,%eax
  1005c1:	3b 05 78 90 10 00    	cmp    0x109078,%eax
  1005c7:	75 cc                	jne    100595 <console_intr+0xc5>
  1005c9:	e9 19 ff ff ff       	jmp    1004e7 <console_intr+0x17>
  1005ce:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  1005d0:	e8 7b 2a 00 00       	call   103050 <procdump>
  1005d5:	e9 0d ff ff ff       	jmp    1004e7 <console_intr+0x17>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  1005da:	a1 7c 90 10 00       	mov    0x10907c,%eax
  1005df:	3b 05 78 90 10 00    	cmp    0x109078,%eax
  1005e5:	0f 84 fc fe ff ff    	je     1004e7 <console_intr+0x17>
        input.e--;
  1005eb:	83 e8 01             	sub    $0x1,%eax
  1005ee:	a3 7c 90 10 00       	mov    %eax,0x10907c
        cons_putc(BACKSPACE);
  1005f3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1005fa:	e8 51 fd ff ff       	call   100350 <cons_putc>
  1005ff:	e9 e3 fe ff ff       	jmp    1004e7 <console_intr+0x17>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        cons_putc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100604:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
  10060a:	e9 56 ff ff ff       	jmp    100565 <console_intr+0x95>
  10060f:	90                   	nop    

00100610 <console_write>:
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  100610:	55                   	push   %ebp
  100611:	89 e5                	mov    %esp,%ebp
  100613:	57                   	push   %edi
  100614:	56                   	push   %esi
  100615:	53                   	push   %ebx
  100616:	83 ec 0c             	sub    $0xc,%esp
  int i;

  iunlock(ip);
  100619:	8b 45 08             	mov    0x8(%ebp),%eax
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  10061c:	8b 75 10             	mov    0x10(%ebp),%esi
  10061f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  100622:	89 04 24             	mov    %eax,(%esp)
  100625:	e8 e6 14 00 00       	call   101b10 <iunlock>
  acquire(&console_lock);
  10062a:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100631:	e8 ba 37 00 00       	call   103df0 <acquire>
  for(i = 0; i < n; i++)
  100636:	85 f6                	test   %esi,%esi
  100638:	7e 19                	jle    100653 <console_write+0x43>
  10063a:	31 db                	xor    %ebx,%ebx
  10063c:	8d 74 26 00          	lea    0x0(%esi),%esi
    cons_putc(buf[i] & 0xff);
  100640:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  100644:	83 c3 01             	add    $0x1,%ebx
    cons_putc(buf[i] & 0xff);
  100647:	89 04 24             	mov    %eax,(%esp)
  10064a:	e8 01 fd ff ff       	call   100350 <cons_putc>
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  10064f:	39 f3                	cmp    %esi,%ebx
  100651:	75 ed                	jne    100640 <console_write+0x30>
    cons_putc(buf[i] & 0xff);
  release(&console_lock);
  100653:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  10065a:	e8 51 37 00 00       	call   103db0 <release>
  ilock(ip);
  10065f:	8b 45 08             	mov    0x8(%ebp),%eax
  100662:	89 04 24             	mov    %eax,(%esp)
  100665:	e8 16 15 00 00       	call   101b80 <ilock>

  return n;
}
  10066a:	83 c4 0c             	add    $0xc,%esp
  10066d:	89 f0                	mov    %esi,%eax
  10066f:	5b                   	pop    %ebx
  100670:	5e                   	pop    %esi
  100671:	5f                   	pop    %edi
  100672:	5d                   	pop    %ebp
  100673:	c3                   	ret    
  100674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10067a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100680 <printint>:
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  100680:	55                   	push   %ebp
  100681:	89 e5                	mov    %esp,%ebp
  100683:	57                   	push   %edi
  100684:	56                   	push   %esi
  100685:	53                   	push   %ebx
  100686:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100689:	8b 5d 10             	mov    0x10(%ebp),%ebx
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  10068c:	8b 45 08             	mov    0x8(%ebp),%eax
  10068f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100692:	85 db                	test   %ebx,%ebx
  100694:	74 04                	je     10069a <printint+0x1a>
  100696:	85 c0                	test   %eax,%eax
  100698:	78 52                	js     1006ec <printint+0x6c>
    neg = 1;
    x = 0 - xx;
  } else {
    x = xx;
  10069a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1006a1:	31 db                	xor    %ebx,%ebx
  1006a3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  }

  do{
    buf[i++] = digits[x % base];
  1006a6:	31 d2                	xor    %edx,%edx
  1006a8:	f7 f7                	div    %edi
  1006aa:	89 c1                	mov    %eax,%ecx
  1006ac:	0f b6 82 f9 5e 10 00 	movzbl 0x105ef9(%edx),%eax
  1006b3:	88 04 33             	mov    %al,(%ebx,%esi,1)
  1006b6:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
  1006b9:	85 c9                	test   %ecx,%ecx
  1006bb:	89 c8                	mov    %ecx,%eax
  1006bd:	75 e7                	jne    1006a6 <printint+0x26>
  if(neg)
  1006bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1006c2:	85 c9                	test   %ecx,%ecx
  1006c4:	74 08                	je     1006ce <printint+0x4e>
    buf[i++] = '-';
  1006c6:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
  1006cb:	83 c3 01             	add    $0x1,%ebx
  1006ce:	8d 1c 1e             	lea    (%esi,%ebx,1),%ebx

  while(--i >= 0)
    cons_putc(buf[i]);
  1006d1:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  1006d5:	83 eb 01             	sub    $0x1,%ebx
  1006d8:	89 04 24             	mov    %eax,(%esp)
  1006db:	e8 70 fc ff ff       	call   100350 <cons_putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  1006e0:	39 f3                	cmp    %esi,%ebx
  1006e2:	75 ed                	jne    1006d1 <printint+0x51>
    cons_putc(buf[i]);
}
  1006e4:	83 c4 1c             	add    $0x1c,%esp
  1006e7:	5b                   	pop    %ebx
  1006e8:	5e                   	pop    %esi
  1006e9:	5f                   	pop    %edi
  1006ea:	5d                   	pop    %ebp
  1006eb:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  1006ec:	f7 d8                	neg    %eax
  1006ee:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1006f5:	eb aa                	jmp    1006a1 <printint+0x21>
  1006f7:	89 f6                	mov    %esi,%esi
  1006f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00100700 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  100700:	55                   	push   %ebp
  100701:	89 e5                	mov    %esp,%ebp
  100703:	57                   	push   %edi
  100704:	56                   	push   %esi
  100705:	53                   	push   %ebx
  100706:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100709:	a1 a4 77 10 00       	mov    0x1077a4,%eax
  if(locking)
  10070e:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100710:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
  100713:	0f 85 6c 01 00 00    	jne    100885 <cprintf+0x185>
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100719:	8b 55 08             	mov    0x8(%ebp),%edx
  10071c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10071f:	0f b6 02             	movzbl (%edx),%eax
  100722:	84 c0                	test   %al,%al
  100724:	74 43                	je     100769 <cprintf+0x69>

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  100726:	8d 55 0c             	lea    0xc(%ebp),%edx
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  100729:	0f b6 d8             	movzbl %al,%ebx

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  10072c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  10072f:	31 ff                	xor    %edi,%edi
    switch(state){
    case 0:
      if(c == '%')
  100731:	83 fb 25             	cmp    $0x25,%ebx
  100734:	0f 85 87 00 00 00    	jne    1007c1 <cprintf+0xc1>
  10073a:	ba 25 00 00 00       	mov    $0x25,%edx
  10073f:	8b 75 e8             	mov    -0x18(%ebp),%esi
  100742:	01 fe                	add    %edi,%esi
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100744:	83 c7 01             	add    $0x1,%edi
  100747:	0f b6 46 01          	movzbl 0x1(%esi),%eax
  10074b:	84 c0                	test   %al,%al
  10074d:	74 1a                	je     100769 <cprintf+0x69>
    c = fmt[i] & 0xff;
    switch(state){
  10074f:	85 d2                	test   %edx,%edx
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  100751:	0f b6 d8             	movzbl %al,%ebx
    switch(state){
  100754:	74 db                	je     100731 <cprintf+0x31>
  100756:	83 fa 25             	cmp    $0x25,%edx
  100759:	74 29                	je     100784 <cprintf+0x84>
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  10075b:	83 c6 01             	add    $0x1,%esi
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  10075e:	83 c7 01             	add    $0x1,%edi
  100761:	0f b6 46 01          	movzbl 0x1(%esi),%eax
  100765:	84 c0                	test   %al,%al
  100767:	75 e6                	jne    10074f <cprintf+0x4f>
      state = 0;
      break;
    }
  }

  if(locking)
  100769:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10076c:	85 f6                	test   %esi,%esi
  10076e:	74 0c                	je     10077c <cprintf+0x7c>
    release(&console_lock);
  100770:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100777:	e8 34 36 00 00       	call   103db0 <release>
}
  10077c:	83 c4 1c             	add    $0x1c,%esp
  10077f:	5b                   	pop    %ebx
  100780:	5e                   	pop    %esi
  100781:	5f                   	pop    %edi
  100782:	5d                   	pop    %ebp
  100783:	c3                   	ret    
      else
        cons_putc(c);
      break;
    
    case '%':
      switch(c){
  100784:	83 fb 70             	cmp    $0x70,%ebx
  100787:	74 57                	je     1007e0 <cprintf+0xe0>
  100789:	7f 45                	jg     1007d0 <cprintf+0xd0>
  10078b:	83 fb 25             	cmp    $0x25,%ebx
  10078e:	66 90                	xchg   %ax,%ax
  100790:	0f 84 d8 00 00 00    	je     10086e <cprintf+0x16e>
  100796:	83 fb 64             	cmp    $0x64,%ebx
  100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1007a0:	0f 84 9e 00 00 00    	je     100844 <cprintf+0x144>
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  1007a6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1007ad:	8d 76 00             	lea    0x0(%esi),%esi
  1007b0:	e8 9b fb ff ff       	call   100350 <cons_putc>
        cons_putc(c);
  1007b5:	89 1c 24             	mov    %ebx,(%esp)
  1007b8:	e8 93 fb ff ff       	call   100350 <cons_putc>
  1007bd:	31 d2                	xor    %edx,%edx
  1007bf:	eb 9a                	jmp    10075b <cprintf+0x5b>
    switch(state){
    case 0:
      if(c == '%')
        state = '%';
      else
        cons_putc(c);
  1007c1:	89 1c 24             	mov    %ebx,(%esp)
  1007c4:	e8 87 fb ff ff       	call   100350 <cons_putc>
  1007c9:	31 d2                	xor    %edx,%edx
  1007cb:	e9 6f ff ff ff       	jmp    10073f <cprintf+0x3f>
      break;
    
    case '%':
      switch(c){
  1007d0:	83 fb 73             	cmp    $0x73,%ebx
  1007d3:	74 35                	je     10080a <cprintf+0x10a>
  1007d5:	83 fb 78             	cmp    $0x78,%ebx
  1007d8:	75 cc                	jne    1007a6 <cprintf+0xa6>
  1007da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      case 'd':
        printint(*argp++, 10, 1);
        break;
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
  1007e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1007e3:	8b 02                	mov    (%edx),%eax
  1007e5:	83 c2 04             	add    $0x4,%edx
  1007e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1007eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1007f2:	00 
  1007f3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1007fa:	00 
  1007fb:	89 04 24             	mov    %eax,(%esp)
  1007fe:	e8 7d fe ff ff       	call   100680 <printint>
  100803:	31 d2                	xor    %edx,%edx
  100805:	e9 51 ff ff ff       	jmp    10075b <cprintf+0x5b>
        break;
      case 's':
        s = (char*)*argp++;
  10080a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10080d:	8b 02                	mov    (%edx),%eax
  10080f:	83 c2 04             	add    $0x4,%edx
  100812:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
  100815:	ba df 5e 10 00       	mov    $0x105edf,%edx
  10081a:	85 c0                	test   %eax,%eax
  10081c:	75 63                	jne    100881 <cprintf+0x181>
          s = "(null)";
        for(; *s; s++)
  10081e:	0f b6 02             	movzbl (%edx),%eax
  100821:	84 c0                	test   %al,%al
  100823:	74 18                	je     10083d <cprintf+0x13d>
  100825:	89 d3                	mov    %edx,%ebx
          cons_putc(*s);
  100827:	0f be c0             	movsbl %al,%eax
  10082a:	89 04 24             	mov    %eax,(%esp)
  10082d:	e8 1e fb ff ff       	call   100350 <cons_putc>
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  100832:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  100836:	83 c3 01             	add    $0x1,%ebx
  100839:	84 c0                	test   %al,%al
  10083b:	75 ea                	jne    100827 <cprintf+0x127>
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  10083d:	31 d2                	xor    %edx,%edx
  10083f:	e9 17 ff ff ff       	jmp    10075b <cprintf+0x5b>
      break;
    
    case '%':
      switch(c){
      case 'd':
        printint(*argp++, 10, 1);
  100844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100847:	8b 02                	mov    (%edx),%eax
  100849:	83 c2 04             	add    $0x4,%edx
  10084c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10084f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  100856:	00 
  100857:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  10085e:	00 
  10085f:	89 04 24             	mov    %eax,(%esp)
  100862:	e8 19 fe ff ff       	call   100680 <printint>
  100867:	31 d2                	xor    %edx,%edx
  100869:	e9 ed fe ff ff       	jmp    10075b <cprintf+0x5b>
          s = "(null)";
        for(; *s; s++)
          cons_putc(*s);
        break;
      case '%':
        cons_putc('%');
  10086e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100875:	e8 d6 fa ff ff       	call   100350 <cons_putc>
  10087a:	31 d2                	xor    %edx,%edx
  10087c:	e9 da fe ff ff       	jmp    10075b <cprintf+0x5b>
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
  100881:	89 c2                	mov    %eax,%edx
  100883:	eb 99                	jmp    10081e <cprintf+0x11e>
  uint *argp;
  char *s;

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);
  100885:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  10088c:	e8 5f 35 00 00       	call   103df0 <acquire>
  100891:	e9 83 fe ff ff       	jmp    100719 <cprintf+0x19>
  100896:	8d 76 00             	lea    0x0(%esi),%esi
  100899:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001008a0 <panic>:
  ioapic_enable(IRQ_KBD, 0);
}

void
panic(char *s)
{
  1008a0:	55                   	push   %ebp
  1008a1:	89 e5                	mov    %esp,%ebp
  1008a3:	56                   	push   %esi
  1008a4:	53                   	push   %ebx
  1008a5:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  1008a8:	fa                   	cli    
  use_console_lock = 0;
  1008a9:	c7 05 a4 77 10 00 00 	movl   $0x0,0x1077a4
  1008b0:	00 00 00 
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  1008b3:	8d 75 d0             	lea    -0x30(%ebp),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1008b6:	bb 02 00 00 00       	mov    $0x2,%ebx
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  1008bb:	e8 a0 1d 00 00       	call   102660 <cpu>
  1008c0:	c7 04 24 e6 5e 10 00 	movl   $0x105ee6,(%esp)
  1008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008cb:	e8 30 fe ff ff       	call   100700 <cprintf>
  cprintf(s);
  1008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1008d3:	89 04 24             	mov    %eax,(%esp)
  1008d6:	e8 25 fe ff ff       	call   100700 <cprintf>
  cprintf("\n");
  1008db:	c7 04 24 73 63 10 00 	movl   $0x106373,(%esp)
  1008e2:	e8 19 fe ff ff       	call   100700 <cprintf>
  getcallerpcs(&s, pcs);
  1008e7:	8d 45 08             	lea    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  1008f1:	e8 5a 33 00 00       	call   103c50 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1008f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008f9:	c7 04 24 f5 5e 10 00 	movl   $0x105ef5,(%esp)
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	e8 f7 fd ff ff       	call   100700 <cprintf>
  100909:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10090d:	83 c3 01             	add    $0x1,%ebx
  100910:	c7 04 24 f5 5e 10 00 	movl   $0x105ef5,(%esp)
  100917:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091b:	e8 e0 fd ff ff       	call   100700 <cprintf>
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  100920:	83 fb 0b             	cmp    $0xb,%ebx
  100923:	75 e4                	jne    100909 <panic+0x69>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  100925:	c7 05 a0 77 10 00 01 	movl   $0x1,0x1077a0
  10092c:	00 00 00 
  10092f:	eb fe                	jmp    10092f <panic+0x8f>
  100931:	90                   	nop    
  100932:	90                   	nop    
  100933:	90                   	nop    
  100934:	90                   	nop    
  100935:	90                   	nop    
  100936:	90                   	nop    
  100937:	90                   	nop    
  100938:	90                   	nop    
  100939:	90                   	nop    
  10093a:	90                   	nop    
  10093b:	90                   	nop    
  10093c:	90                   	nop    
  10093d:	90                   	nop    
  10093e:	90                   	nop    
  10093f:	90                   	nop    

00100940 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  100940:	55                   	push   %ebp
  100941:	89 e5                	mov    %esp,%ebp
  100943:	57                   	push   %edi
  100944:	56                   	push   %esi
  100945:	53                   	push   %ebx
  100946:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  uint sz, sp, argp;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;

  if((ip = namei(path)) == 0)
  10094c:	8b 45 08             	mov    0x8(%ebp),%eax
  10094f:	89 04 24             	mov    %eax,(%esp)
  100952:	e8 b9 14 00 00       	call   101e10 <namei>
  100957:	89 c6                	mov    %eax,%esi
  100959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10095e:	85 f6                	test   %esi,%esi
  100960:	74 42                	je     1009a4 <exec+0x64>
    return -1;
  ilock(ip);
  100962:	89 34 24             	mov    %esi,(%esp)
  100965:	e8 16 12 00 00       	call   101b80 <ilock>
  // Compute memory size of new process.
  mem = 0;
  sz = 0;

  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  10096a:	8d 45 a0             	lea    -0x60(%ebp),%eax
  10096d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100974:	00 
  100975:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10097c:	00 
  10097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100981:	89 34 24             	mov    %esi,(%esp)
  100984:	e8 97 0b 00 00       	call   101520 <readi>
  100989:	83 f8 33             	cmp    $0x33,%eax
  10098c:	76 09                	jbe    100997 <exec+0x57>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  10098e:	81 7d a0 7f 45 4c 46 	cmpl   $0x464c457f,-0x60(%ebp)
  100995:	74 18                	je     1009af <exec+0x6f>
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100997:	89 34 24             	mov    %esi,(%esp)
  10099a:	e8 c1 11 00 00       	call   101b60 <iunlockput>
  10099f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1009a4:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1009aa:	5b                   	pop    %ebx
  1009ab:	5e                   	pop    %esi
  1009ac:	5f                   	pop    %edi
  1009ad:	5d                   	pop    %ebp
  1009ae:	c3                   	ret    
  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  1009af:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  1009b4:	8b 7d bc             	mov    -0x44(%ebp),%edi
  1009b7:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  1009be:	00 00 00 
  1009c1:	74 4c                	je     100a0f <exec+0xcf>
  1009c3:	31 db                	xor    %ebx,%ebx
  1009c5:	eb 0b                	jmp    1009d2 <exec+0x92>
  1009c7:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  1009cb:	83 c3 01             	add    $0x1,%ebx
  1009ce:	39 d8                	cmp    %ebx,%eax
  1009d0:	7e 3d                	jle    100a0f <exec+0xcf>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  1009d2:	89 d8                	mov    %ebx,%eax
  1009d4:	c1 e0 05             	shl    $0x5,%eax
  1009d7:	01 f8                	add    %edi,%eax
  1009d9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1009dc:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  1009e3:	00 
  1009e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1009ec:	89 34 24             	mov    %esi,(%esp)
  1009ef:	e8 2c 0b 00 00       	call   101520 <readi>
  1009f4:	83 f8 20             	cmp    $0x20,%eax
  1009f7:	75 9e                	jne    100997 <exec+0x57>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  1009f9:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  1009fd:	75 c8                	jne    1009c7 <exec+0x87>
      continue;
    if(ph.memsz < ph.filesz)
  1009ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100a05:	72 90                	jb     100997 <exec+0x57>
      goto bad;
    sz += ph.memsz;
  100a07:	01 85 7c ff ff ff    	add    %eax,-0x84(%ebp)
  100a0d:	eb b8                	jmp    1009c7 <exec+0x87>
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100a12:	31 db                	xor    %ebx,%ebx
  100a14:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  100a1b:	00 00 00 
  100a1e:	8b 11                	mov    (%ecx),%edx
  100a20:	85 d2                	test   %edx,%edx
  100a22:	0f 84 a1 02 00 00    	je     100cc9 <exec+0x389>
    arglen += strlen(argv[argc]) + 1;
  100a28:	89 14 24             	mov    %edx,(%esp)
  100a2b:	e8 20 36 00 00       	call   104050 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100a33:	83 85 78 ff ff ff 01 	addl   $0x1,-0x88(%ebp)
  100a3a:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100a40:	8b 14 b9             	mov    (%ecx,%edi,4),%edx
    arglen += strlen(argv[argc]) + 1;
  100a43:	01 d8                	add    %ebx,%eax
  100a45:	8d 58 01             	lea    0x1(%eax),%ebx
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a48:	89 bd 70 ff ff ff    	mov    %edi,-0x90(%ebp)
  100a4e:	85 d2                	test   %edx,%edx
  100a50:	75 d6                	jne    100a28 <exec+0xe8>
  100a52:	83 c0 04             	add    $0x4,%eax
  100a55:	83 e0 fc             	and    $0xfffffffc,%eax
  100a58:	8d 3c bd 04 00 00 00 	lea    0x4(,%edi,4),%edi
  100a5f:	89 45 84             	mov    %eax,-0x7c(%ebp)
  100a62:	89 f8                	mov    %edi,%eax
  100a64:	03 45 84             	add    -0x7c(%ebp),%eax
  100a67:	89 7d 8c             	mov    %edi,-0x74(%ebp)

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100a6a:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  100a70:	8d 84 10 ff 1f 00 00 	lea    0x1fff(%eax,%edx,1),%eax
  100a77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100a7c:	89 45 90             	mov    %eax,-0x70(%ebp)
  mem = kalloc(sz);
  100a7f:	89 04 24             	mov    %eax,(%esp)
  100a82:	e8 69 17 00 00       	call   1021f0 <kalloc>
  if(mem == 0)
  100a87:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100a89:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  if(mem == 0)
  100a8f:	0f 84 02 ff ff ff    	je     100997 <exec+0x57>
    goto bad;
  memset(mem, 0, sz);
  100a95:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100a98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100a9f:	00 
  100aa0:	89 04 24             	mov    %eax,(%esp)
  100aa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100aa7:	e8 a4 33 00 00       	call   103e50 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100aac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  100aaf:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100ab4:	0f 84 b7 00 00 00    	je     100b71 <exec+0x231>
  100aba:	89 c3                	mov    %eax,%ebx
  100abc:	31 ff                	xor    %edi,%edi
  100abe:	eb 12                	jmp    100ad2 <exec+0x192>
  100ac0:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100ac4:	83 c7 01             	add    $0x1,%edi
  100ac7:	39 f8                	cmp    %edi,%eax
  100ac9:	0f 8e a2 00 00 00    	jle    100b71 <exec+0x231>
  100acf:	83 c3 20             	add    $0x20,%ebx
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100ad2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100ad5:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100adc:	00 
  100add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  100ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae5:	89 34 24             	mov    %esi,(%esp)
  100ae8:	e8 33 0a 00 00       	call   101520 <readi>
  100aed:	83 f8 20             	cmp    $0x20,%eax
  100af0:	75 65                	jne    100b57 <exec+0x217>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100af2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100af6:	75 c8                	jne    100ac0 <exec+0x180>
      continue;
    if(ph.va + ph.memsz > sz)
  100af8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100afb:	89 d0                	mov    %edx,%eax
  100afd:	03 45 e8             	add    -0x18(%ebp),%eax
  100b00:	39 45 90             	cmp    %eax,-0x70(%ebp)
  100b03:	72 52                	jb     100b57 <exec+0x217>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b08:	89 34 24             	mov    %esi,(%esp)
  100b0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100b12:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b16:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100b1c:	01 d0                	add    %edx,%eax
  100b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b22:	e8 f9 09 00 00       	call   101520 <readi>
  100b27:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100b2a:	89 c2                	mov    %eax,%edx
  100b2c:	75 29                	jne    100b57 <exec+0x217>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b38:	00 
  100b39:	29 d0                	sub    %edx,%eax
  100b3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b3f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100b45:	03 45 dc             	add    -0x24(%ebp),%eax
  100b48:	01 d0                	add    %edx,%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 fe 32 00 00       	call   103e50 <memset>
  100b52:	e9 69 ff ff ff       	jmp    100ac0 <exec+0x180>
  setupsegs(cp);
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100b57:	8b 7d 90             	mov    -0x70(%ebp),%edi
  100b5a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100b60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100b64:	89 04 24             	mov    %eax,(%esp)
  100b67:	e8 34 17 00 00       	call   1022a0 <kfree>
  100b6c:	e9 26 fe ff ff       	jmp    100997 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100b71:	89 34 24             	mov    %esi,(%esp)
  100b74:	e8 e7 0f 00 00       	call   101b60 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100b79:	8b 55 90             	mov    -0x70(%ebp),%edx
  100b7c:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
  100b7f:	2b 55 84             	sub    -0x7c(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b82:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  for(i=argc-1; i>=0; i--){
  100b88:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100b8e:	29 ca                	sub    %ecx,%edx
  100b90:	89 55 80             	mov    %edx,-0x80(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100b93:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100b99:	03 55 80             	add    -0x80(%ebp),%edx
  100b9c:	c1 e0 02             	shl    $0x2,%eax
  for(i=argc-1; i>=0; i--){
  100b9f:	83 ef 01             	sub    $0x1,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100ba2:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
  for(i=argc-1; i>=0; i--){
  100ba9:	78 53                	js     100bfe <exec+0x2be>
  100bab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bae:	01 c2                	add    %eax,%edx
  100bb0:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100bb6:	8b 5d 90             	mov    -0x70(%ebp),%ebx
  100bb9:	89 55 88             	mov    %edx,-0x78(%ebp)
  100bbc:	8d 34 08             	lea    (%eax,%ecx,1),%esi
    len = strlen(argv[i]) + 1;
  100bbf:	8b 46 fc             	mov    -0x4(%esi),%eax
  100bc2:	89 04 24             	mov    %eax,(%esp)
  100bc5:	e8 86 34 00 00       	call   104050 <strlen>
    sp -= len;
  100bca:	83 c0 01             	add    $0x1,%eax
  100bcd:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100bd3:	8b 46 fc             	mov    -0x4(%esi),%eax
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100bd6:	83 ee 04             	sub    $0x4,%esi
  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100be3:	01 d8                	add    %ebx,%eax
  100be5:	89 04 24             	mov    %eax,(%esp)
  100be8:	e8 13 33 00 00       	call   103f00 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100bed:	8b 45 88             	mov    -0x78(%ebp),%eax
  100bf0:	89 58 fc             	mov    %ebx,-0x4(%eax)
  100bf3:	83 e8 04             	sub    $0x4,%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bf6:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100bf9:	89 45 88             	mov    %eax,-0x78(%ebp)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bfc:	75 c1                	jne    100bbf <exec+0x27f>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100bfe:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c01:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c07:	8b 45 08             	mov    0x8(%ebp),%eax
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c0a:	8b bd 70 ff ff ff    	mov    -0x90(%ebp),%edi
  sp -= 4;
  100c10:	89 d6                	mov    %edx,%esi
  100c12:	83 ee 0c             	sub    $0xc,%esi
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100c15:	89 54 0a fc          	mov    %edx,-0x4(%edx,%ecx,1)
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c19:	89 c3                	mov    %eax,%ebx
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c1b:	89 7c 0a f8          	mov    %edi,-0x8(%edx,%ecx,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100c1f:	c7 04 31 ff ff ff ff 	movl   $0xffffffff,(%ecx,%esi,1)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c26:	0f b6 10             	movzbl (%eax),%edx
  100c29:	84 d2                	test   %dl,%dl
  100c2b:	74 18                	je     100c45 <exec+0x305>
  100c2d:	83 c0 01             	add    $0x1,%eax
  100c30:	eb 0a                	jmp    100c3c <exec+0x2fc>
  100c32:	0f b6 10             	movzbl (%eax),%edx
  100c35:	83 c0 01             	add    $0x1,%eax
  100c38:	84 d2                	test   %dl,%dl
  100c3a:	74 09                	je     100c45 <exec+0x305>
    if(*s == '/')
  100c3c:	80 fa 2f             	cmp    $0x2f,%dl
  100c3f:	75 f1                	jne    100c32 <exec+0x2f2>
  100c41:	89 c3                	mov    %eax,%ebx
  100c43:	eb ed                	jmp    100c32 <exec+0x2f2>
      last = s+1;
  safestrcpy(cp->name, last, sizeof(cp->name));
  100c45:	e8 76 25 00 00       	call   1031c0 <curproc>
  100c4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c4e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100c55:	00 
  100c56:	05 88 00 00 00       	add    $0x88,%eax
  100c5b:	89 04 24             	mov    %eax,(%esp)
  100c5e:	e8 ad 33 00 00       	call   104010 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100c63:	e8 58 25 00 00       	call   1031c0 <curproc>
  100c68:	8b 58 04             	mov    0x4(%eax),%ebx
  100c6b:	e8 50 25 00 00       	call   1031c0 <curproc>
  100c70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c74:	8b 00                	mov    (%eax),%eax
  100c76:	89 04 24             	mov    %eax,(%esp)
  100c79:	e8 22 16 00 00       	call   1022a0 <kfree>
  cp->mem = mem;
  100c7e:	e8 3d 25 00 00       	call   1031c0 <curproc>
  100c83:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100c89:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100c8b:	e8 30 25 00 00       	call   1031c0 <curproc>
  100c90:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100c93:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100c96:	e8 25 25 00 00       	call   1031c0 <curproc>
  100c9b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100ca1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100ca4:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100ca7:	e8 14 25 00 00       	call   1031c0 <curproc>
  100cac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100cb2:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100cb5:	e8 06 25 00 00       	call   1031c0 <curproc>
  100cba:	89 04 24             	mov    %eax,(%esp)
  100cbd:	e8 1e 29 00 00       	call   1035e0 <setupsegs>
  100cc2:	31 c0                	xor    %eax,%eax
  100cc4:	e9 db fc ff ff       	jmp    1009a4 <exec+0x64>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cc9:	b8 04 00 00 00       	mov    $0x4,%eax
  100cce:	c7 85 70 ff ff ff 00 	movl   $0x0,-0x90(%ebp)
  100cd5:	00 00 00 
  100cd8:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100cdf:	c7 45 8c 04 00 00 00 	movl   $0x4,-0x74(%ebp)
  100ce6:	e9 7f fd ff ff       	jmp    100a6a <exec+0x12a>
  100ceb:	90                   	nop    
  100cec:	90                   	nop    
  100ced:	90                   	nop    
  100cee:	90                   	nop    
  100cef:	90                   	nop    

00100cf0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100cf0:	55                   	push   %ebp
  100cf1:	89 e5                	mov    %esp,%ebp
  100cf3:	83 ec 28             	sub    $0x28,%esp
  100cf6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100cfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100cff:	8b 75 10             	mov    0x10(%ebp),%esi
  100d02:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100d05:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->writable == 0)
  100d08:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100d0c:	74 54                	je     100d62 <filewrite+0x72>
    return -1;
  if(f->type == FD_PIPE)
  100d0e:	8b 03                	mov    (%ebx),%eax
  100d10:	83 f8 02             	cmp    $0x2,%eax
  100d13:	74 54                	je     100d69 <filewrite+0x79>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100d15:	83 f8 03             	cmp    $0x3,%eax
  100d18:	75 66                	jne    100d80 <filewrite+0x90>
    ilock(f->ip);
  100d1a:	8b 43 10             	mov    0x10(%ebx),%eax
  100d1d:	89 04 24             	mov    %eax,(%esp)
  100d20:	e8 5b 0e 00 00       	call   101b80 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100d25:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100d29:	8b 43 14             	mov    0x14(%ebx),%eax
  100d2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d30:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d34:	8b 43 10             	mov    0x10(%ebx),%eax
  100d37:	89 04 24             	mov    %eax,(%esp)
  100d3a:	e8 b1 06 00 00       	call   1013f0 <writei>
  100d3f:	85 c0                	test   %eax,%eax
  100d41:	89 c6                	mov    %eax,%esi
  100d43:	7e 03                	jle    100d48 <filewrite+0x58>
      f->off += r;
  100d45:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100d48:	8b 43 10             	mov    0x10(%ebx),%eax
  100d4b:	89 04 24             	mov    %eax,(%esp)
  100d4e:	e8 bd 0d 00 00       	call   101b10 <iunlock>
    return r;
  }
  panic("filewrite");
}
  100d53:	89 f0                	mov    %esi,%eax
  100d55:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100d58:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100d5b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100d5e:	89 ec                	mov    %ebp,%esp
  100d60:	5d                   	pop    %ebp
  100d61:	c3                   	ret    
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d62:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100d67:	eb ea                	jmp    100d53 <filewrite+0x63>
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d69:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100d6c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100d72:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d75:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100d78:	89 ec                	mov    %ebp,%esp
  100d7a:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100d7b:	e9 20 20 00 00       	jmp    102da0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d80:	c7 04 24 0a 5f 10 00 	movl   $0x105f0a,(%esp)
  100d87:	e8 14 fb ff ff       	call   1008a0 <panic>
  100d8c:	8d 74 26 00          	lea    0x0(%esi),%esi

00100d90 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100d90:	55                   	push   %ebp
  100d91:	89 e5                	mov    %esp,%ebp
  100d93:	83 ec 28             	sub    $0x28,%esp
  100d96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100d9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100d9f:	8b 75 10             	mov    0x10(%ebp),%esi
  100da2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100da5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->readable == 0)
  100da8:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100dac:	74 54                	je     100e02 <fileread+0x72>
    return -1;
  if(f->type == FD_PIPE)
  100dae:	8b 03                	mov    (%ebx),%eax
  100db0:	83 f8 02             	cmp    $0x2,%eax
  100db3:	74 54                	je     100e09 <fileread+0x79>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100db5:	83 f8 03             	cmp    $0x3,%eax
  100db8:	75 66                	jne    100e20 <fileread+0x90>
    ilock(f->ip);
  100dba:	8b 43 10             	mov    0x10(%ebx),%eax
  100dbd:	89 04 24             	mov    %eax,(%esp)
  100dc0:	e8 bb 0d 00 00       	call   101b80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100dc5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100dc9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dcc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100dd0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100dd4:	8b 43 10             	mov    0x10(%ebx),%eax
  100dd7:	89 04 24             	mov    %eax,(%esp)
  100dda:	e8 41 07 00 00       	call   101520 <readi>
  100ddf:	85 c0                	test   %eax,%eax
  100de1:	89 c6                	mov    %eax,%esi
  100de3:	7e 03                	jle    100de8 <fileread+0x58>
      f->off += r;
  100de5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100de8:	8b 43 10             	mov    0x10(%ebx),%eax
  100deb:	89 04 24             	mov    %eax,(%esp)
  100dee:	e8 1d 0d 00 00       	call   101b10 <iunlock>
    return r;
  }
  panic("fileread");
}
  100df3:	89 f0                	mov    %esi,%eax
  100df5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100df8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100dfb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100dfe:	89 ec                	mov    %ebp,%esp
  100e00:	5d                   	pop    %ebp
  100e01:	c3                   	ret    
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e02:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100e07:	eb ea                	jmp    100df3 <fileread+0x63>
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e09:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e0c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e0f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e12:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e15:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e18:	89 ec                	mov    %ebp,%esp
  100e1a:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e1b:	e9 b0 1e 00 00       	jmp    102cd0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e20:	c7 04 24 14 5f 10 00 	movl   $0x105f14,(%esp)
  100e27:	e8 74 fa ff ff       	call   1008a0 <panic>
  100e2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00100e30 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100e30:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100e36:	89 e5                	mov    %esp,%ebp
  100e38:	53                   	push   %ebx
  100e39:	83 ec 14             	sub    $0x14,%esp
  100e3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100e3f:	83 3b 03             	cmpl   $0x3,(%ebx)
  100e42:	74 0c                	je     100e50 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100e44:	83 c4 14             	add    $0x14,%esp
  100e47:	5b                   	pop    %ebx
  100e48:	5d                   	pop    %ebp
  100e49:	c3                   	ret    
  100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100e50:	8b 43 10             	mov    0x10(%ebx),%eax
  100e53:	89 04 24             	mov    %eax,(%esp)
  100e56:	e8 25 0d 00 00       	call   101b80 <ilock>
    stati(f->ip, st);
  100e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e62:	8b 43 10             	mov    0x10(%ebx),%eax
  100e65:	89 04 24             	mov    %eax,(%esp)
  100e68:	e8 e3 01 00 00       	call   101050 <stati>
    iunlock(f->ip);
  100e6d:	8b 43 10             	mov    0x10(%ebx),%eax
  100e70:	89 04 24             	mov    %eax,(%esp)
  100e73:	e8 98 0c 00 00       	call   101b10 <iunlock>
    return 0;
  }
  return -1;
}
  100e78:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  100e7b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  100e7d:	5b                   	pop    %ebx
  100e7e:	5d                   	pop    %ebp
  100e7f:	c3                   	ret    

00100e80 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  100e80:	55                   	push   %ebp
  100e81:	89 e5                	mov    %esp,%ebp
  100e83:	53                   	push   %ebx
  100e84:	83 ec 04             	sub    $0x4,%esp
  100e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&file_table_lock);
  100e8a:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100e91:	e8 5a 2f 00 00       	call   103df0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100e96:	8b 43 04             	mov    0x4(%ebx),%eax
  100e99:	85 c0                	test   %eax,%eax
  100e9b:	7e 06                	jle    100ea3 <filedup+0x23>
  100e9d:	8b 13                	mov    (%ebx),%edx
  100e9f:	85 d2                	test   %edx,%edx
  100ea1:	75 0d                	jne    100eb0 <filedup+0x30>
    panic("filedup");
  100ea3:	c7 04 24 1d 5f 10 00 	movl   $0x105f1d,(%esp)
  100eaa:	e8 f1 f9 ff ff       	call   1008a0 <panic>
  100eaf:	90                   	nop    
  f->ref++;
  100eb0:	83 c0 01             	add    $0x1,%eax
  100eb3:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100eb6:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100ebd:	e8 ee 2e 00 00       	call   103db0 <release>
  return f;
}
  100ec2:	89 d8                	mov    %ebx,%eax
  100ec4:	83 c4 04             	add    $0x4,%esp
  100ec7:	5b                   	pop    %ebx
  100ec8:	5d                   	pop    %ebp
  100ec9:	c3                   	ret    
  100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100ed0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  100ed0:	55                   	push   %ebp
  100ed1:	89 e5                	mov    %esp,%ebp
  100ed3:	53                   	push   %ebx
  100ed4:	83 ec 04             	sub    $0x4,%esp
  int i;

  acquire(&file_table_lock);
  100ed7:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100ede:	e8 0d 2f 00 00       	call   103df0 <acquire>
  100ee3:	31 d2                	xor    %edx,%edx
  100ee5:	31 c0                	xor    %eax,%eax
  100ee7:	eb 12                	jmp    100efb <filealloc+0x2b>
  100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  for(i = 0; i < NFILE; i++){
  100ef0:	83 c2 01             	add    $0x1,%edx
  100ef3:	83 c0 18             	add    $0x18,%eax
  100ef6:	83 fa 64             	cmp    $0x64,%edx
  100ef9:	74 42                	je     100f3d <filealloc+0x6d>
    if(file[i].type == FD_CLOSED){
  100efb:	8b 88 80 90 10 00    	mov    0x109080(%eax),%ecx
  100f01:	85 c9                	test   %ecx,%ecx
  100f03:	75 eb                	jne    100ef0 <filealloc+0x20>
      file[i].type = FD_NONE;
  100f05:	8d 04 52             	lea    (%edx,%edx,2),%eax
  100f08:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100f0f:	c7 04 c5 80 90 10 00 	movl   $0x1,0x109080(,%eax,8)
  100f16:	01 00 00 00 
      file[i].ref = 1;
  100f1a:	c7 04 c5 84 90 10 00 	movl   $0x1,0x109084(,%eax,8)
  100f21:	01 00 00 00 
      release(&file_table_lock);
  100f25:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f2c:	e8 7f 2e 00 00       	call   103db0 <release>
      return file + i;
  100f31:	8d 83 80 90 10 00    	lea    0x109080(%ebx),%eax
    }
  }
  release(&file_table_lock);
  return 0;
}
  100f37:	83 c4 04             	add    $0x4,%esp
  100f3a:	5b                   	pop    %ebx
  100f3b:	5d                   	pop    %ebp
  100f3c:	c3                   	ret    
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  100f3d:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f44:	e8 67 2e 00 00       	call   103db0 <release>
  return 0;
}
  100f49:	83 c4 04             	add    $0x4,%esp
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  100f4c:	31 c0                	xor    %eax,%eax
  return 0;
}
  100f4e:	5b                   	pop    %ebx
  100f4f:	5d                   	pop    %ebp
  100f50:	c3                   	ret    
  100f51:	eb 0d                	jmp    100f60 <fileclose>
  100f53:	90                   	nop    
  100f54:	90                   	nop    
  100f55:	90                   	nop    
  100f56:	90                   	nop    
  100f57:	90                   	nop    
  100f58:	90                   	nop    
  100f59:	90                   	nop    
  100f5a:	90                   	nop    
  100f5b:	90                   	nop    
  100f5c:	90                   	nop    
  100f5d:	90                   	nop    
  100f5e:	90                   	nop    
  100f5f:	90                   	nop    

00100f60 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  100f60:	55                   	push   %ebp
  100f61:	89 e5                	mov    %esp,%ebp
  100f63:	83 ec 28             	sub    $0x28,%esp
  100f66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100f6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&file_table_lock);
  100f72:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f79:	e8 72 2e 00 00       	call   103df0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f7e:	8b 43 04             	mov    0x4(%ebx),%eax
  100f81:	85 c0                	test   %eax,%eax
  100f83:	7e 2b                	jle    100fb0 <fileclose+0x50>
  100f85:	8b 33                	mov    (%ebx),%esi
  100f87:	85 f6                	test   %esi,%esi
  100f89:	74 25                	je     100fb0 <fileclose+0x50>
    panic("fileclose");
  if(--f->ref > 0){
  100f8b:	83 e8 01             	sub    $0x1,%eax
  100f8e:	85 c0                	test   %eax,%eax
  100f90:	89 43 04             	mov    %eax,0x4(%ebx)
  100f93:	74 2b                	je     100fc0 <fileclose+0x60>
    release(&file_table_lock);
  100f95:	c7 45 08 e0 99 10 00 	movl   $0x1099e0,0x8(%ebp)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  100f9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f9f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100fa2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100fa5:	89 ec                	mov    %ebp,%esp
  100fa7:	5d                   	pop    %ebp

  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
  100fa8:	e9 03 2e 00 00       	jmp    103db0 <release>
  100fad:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  100fb0:	c7 04 24 25 5f 10 00 	movl   $0x105f25,(%esp)
  100fb7:	e8 e4 f8 ff ff       	call   1008a0 <panic>
  100fbc:	8d 74 26 00          	lea    0x0(%esi),%esi
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
  100fc3:	8b 33                	mov    (%ebx),%esi
  100fc5:	8b 7b 10             	mov    0x10(%ebx),%edi
  f->ref = 0;
  100fc8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  100fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100fd2:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_CLOSED;
  100fd6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  100fdc:	88 45 f3             	mov    %al,-0xd(%ebp)
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  100fdf:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100fe6:	e8 c5 2d 00 00       	call   103db0 <release>
  
  if(ff.type == FD_PIPE)
  100feb:	83 fe 02             	cmp    $0x2,%esi
  100fee:	74 19                	je     101009 <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  100ff0:	83 fe 03             	cmp    $0x3,%esi
  100ff3:	75 bb                	jne    100fb0 <fileclose+0x50>
    iput(ff.ip);
  100ff5:	89 7d 08             	mov    %edi,0x8(%ebp)
  else
    panic("fileclose");
}
  100ff8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ffb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100ffe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101001:	89 ec                	mov    %ebp,%esp
  101003:	5d                   	pop    %ebp
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  101004:	e9 d7 08 00 00       	jmp    1018e0 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  101009:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  10100d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101014:	89 04 24             	mov    %eax,(%esp)
  101017:	e8 64 1e 00 00       	call   102e80 <pipeclose>
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  10101c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10101f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101022:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101025:	89 ec                	mov    %ebp,%esp
  101027:	5d                   	pop    %ebp
  101028:	c3                   	ret    
  101029:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101030 <fileinit>:
struct spinlock file_table_lock;
struct file file[NFILE];

void
fileinit(void)
{
  101030:	55                   	push   %ebp
  101031:	89 e5                	mov    %esp,%ebp
  101033:	83 ec 08             	sub    $0x8,%esp
  initlock(&file_table_lock, "file_table");
  101036:	c7 44 24 04 2f 5f 10 	movl   $0x105f2f,0x4(%esp)
  10103d:	00 
  10103e:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101045:	e8 e6 2b 00 00       	call   103c30 <initlock>
}
  10104a:	c9                   	leave  
  10104b:	c3                   	ret    
  10104c:	90                   	nop    
  10104d:	90                   	nop    
  10104e:	90                   	nop    
  10104f:	90                   	nop    

00101050 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  101050:	55                   	push   %ebp
  101051:	89 e5                	mov    %esp,%ebp
  101053:	8b 55 08             	mov    0x8(%ebp),%edx
  101056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  st->dev = ip->dev;
  101059:	8b 02                	mov    (%edx),%eax
  10105b:	89 01                	mov    %eax,(%ecx)
  st->ino = ip->inum;
  10105d:	8b 42 04             	mov    0x4(%edx),%eax
  101060:	89 41 04             	mov    %eax,0x4(%ecx)
  st->type = ip->type;
  101063:	0f b7 42 10          	movzwl 0x10(%edx),%eax
  101067:	66 89 41 08          	mov    %ax,0x8(%ecx)
  st->nlink = ip->nlink;
  10106b:	0f b7 42 16          	movzwl 0x16(%edx),%eax
  10106f:	66 89 41 0a          	mov    %ax,0xa(%ecx)
  st->size = ip->size;
  101073:	8b 42 18             	mov    0x18(%edx),%eax
  101076:	89 41 0c             	mov    %eax,0xc(%ecx)
}
  101079:	5d                   	pop    %ebp
  10107a:	c3                   	ret    
  10107b:	90                   	nop    
  10107c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101080 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101080:	55                   	push   %ebp
  101081:	89 e5                	mov    %esp,%ebp
  101083:	53                   	push   %ebx
  101084:	83 ec 04             	sub    $0x4,%esp
  101087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10108a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101091:	e8 5a 2d 00 00       	call   103df0 <acquire>
  ip->ref++;
  101096:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10109a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1010a1:	e8 0a 2d 00 00       	call   103db0 <release>
  return ip;
}
  1010a6:	89 d8                	mov    %ebx,%eax
  1010a8:	83 c4 04             	add    $0x4,%esp
  1010ab:	5b                   	pop    %ebx
  1010ac:	5d                   	pop    %ebp
  1010ad:	c3                   	ret    
  1010ae:	66 90                	xchg   %ax,%ax

001010b0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010b0:	55                   	push   %ebp
  1010b1:	89 e5                	mov    %esp,%ebp
  1010b3:	57                   	push   %edi
  1010b4:	89 c7                	mov    %eax,%edi
  1010b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010b7:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010b9:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010ba:	bb b4 9a 10 00       	mov    $0x109ab4,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010bf:	83 ec 0c             	sub    $0xc,%esp
  1010c2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010c5:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1010cc:	e8 1f 2d 00 00       	call   103df0 <acquire>
  1010d1:	eb 0f                	jmp    1010e2 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1010d3:	85 f6                	test   %esi,%esi
  1010d5:	74 3a                	je     101111 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1010d7:	83 c3 50             	add    $0x50,%ebx
  1010da:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  1010e0:	74 40                	je     101122 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1010e2:	8b 43 08             	mov    0x8(%ebx),%eax
  1010e5:	85 c0                	test   %eax,%eax
  1010e7:	7e ea                	jle    1010d3 <iget+0x23>
  1010e9:	39 3b                	cmp    %edi,(%ebx)
  1010eb:	75 e6                	jne    1010d3 <iget+0x23>
  1010ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1010f0:	39 53 04             	cmp    %edx,0x4(%ebx)
  1010f3:	75 de                	jne    1010d3 <iget+0x23>
      ip->ref++;
  1010f5:	83 c0 01             	add    $0x1,%eax
  1010f8:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  1010fb:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101102:	e8 a9 2c 00 00       	call   103db0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  101107:	83 c4 0c             	add    $0xc,%esp
  10110a:	89 d8                	mov    %ebx,%eax
  10110c:	5b                   	pop    %ebx
  10110d:	5e                   	pop    %esi
  10110e:	5f                   	pop    %edi
  10110f:	5d                   	pop    %ebp
  101110:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101111:	85 c0                	test   %eax,%eax
  101113:	75 c2                	jne    1010d7 <iget+0x27>
  101115:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101117:	83 c3 50             	add    $0x50,%ebx
  10111a:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  101120:	75 c0                	jne    1010e2 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101122:	85 f6                	test   %esi,%esi
  101124:	74 2e                	je     101154 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101129:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  10112b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  10112d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101134:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  10113b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  10113e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101145:	e8 66 2c 00 00       	call   103db0 <release>

  return ip;
}
  10114a:	83 c4 0c             	add    $0xc,%esp
  10114d:	89 d8                	mov    %ebx,%eax
  10114f:	5b                   	pop    %ebx
  101150:	5e                   	pop    %esi
  101151:	5f                   	pop    %edi
  101152:	5d                   	pop    %ebp
  101153:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101154:	c7 04 24 3a 5f 10 00 	movl   $0x105f3a,(%esp)
  10115b:	e8 40 f7 ff ff       	call   1008a0 <panic>

00101160 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101160:	55                   	push   %ebp
  101161:	89 e5                	mov    %esp,%ebp
  101163:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101166:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10116d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10116e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101171:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101174:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101176:	89 04 24             	mov    %eax,(%esp)
  101179:	e8 32 ef ff ff       	call   1000b0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10117e:	89 34 24             	mov    %esi,(%esp)
  101181:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101188:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101189:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10118b:	8d 40 18             	lea    0x18(%eax),%eax
  10118e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101192:	e8 69 2d 00 00       	call   103f00 <memmove>
  brelse(bp);
  101197:	89 1c 24             	mov    %ebx,(%esp)
  10119a:	e8 61 ee ff ff       	call   100000 <brelse>
}
  10119f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1011a2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1011a5:	89 ec                	mov    %ebp,%esp
  1011a7:	5d                   	pop    %ebp
  1011a8:	c3                   	ret    
  1011a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001011b0 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  1011b0:	55                   	push   %ebp
  1011b1:	89 e5                	mov    %esp,%ebp
  1011b3:	56                   	push   %esi
  1011b4:	53                   	push   %ebx
  1011b5:	83 ec 10             	sub    $0x10,%esp
  1011b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  1011bb:	8b 43 04             	mov    0x4(%ebx),%eax
  1011be:	c1 e8 03             	shr    $0x3,%eax
  1011c1:	83 c0 02             	add    $0x2,%eax
  1011c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1011c8:	8b 03                	mov    (%ebx),%eax
  1011ca:	89 04 24             	mov    %eax,(%esp)
  1011cd:	e8 de ee ff ff       	call   1000b0 <bread>
  1011d2:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  1011d4:	8b 43 04             	mov    0x4(%ebx),%eax
  1011d7:	83 e0 07             	and    $0x7,%eax
  1011da:	c1 e0 06             	shl    $0x6,%eax
  1011dd:	8d 54 06 18          	lea    0x18(%esi,%eax,1),%edx
  dip->type = ip->type;
  1011e1:	0f b7 43 10          	movzwl 0x10(%ebx),%eax
  1011e5:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
  1011e8:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  1011ec:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
  1011f0:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
  1011f4:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
  1011f8:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
  1011fc:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
  101200:	8b 43 18             	mov    0x18(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101203:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101206:	89 42 08             	mov    %eax,0x8(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101209:	83 c2 0c             	add    $0xc,%edx
  10120c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101210:	89 14 24             	mov    %edx,(%esp)
  101213:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  10121a:	00 
  10121b:	e8 e0 2c 00 00       	call   103f00 <memmove>
  bwrite(bp);
  101220:	89 34 24             	mov    %esi,(%esp)
  101223:	e8 58 ee ff ff       	call   100080 <bwrite>
  brelse(bp);
  101228:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10122b:	83 c4 10             	add    $0x10,%esp
  10122e:	5b                   	pop    %ebx
  10122f:	5e                   	pop    %esi
  101230:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  101231:	e9 ca ed ff ff       	jmp    100000 <brelse>
  101236:	8d 76 00             	lea    0x0(%esi),%esi
  101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101240 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101240:	55                   	push   %ebp
  101241:	89 e5                	mov    %esp,%ebp
  101243:	57                   	push   %edi
  101244:	56                   	push   %esi
  101245:	53                   	push   %ebx
  101246:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101249:	8d 55 e8             	lea    -0x18(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  10124c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  10124f:	e8 0c ff ff ff       	call   101160 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101257:	85 c0                	test   %eax,%eax
  101259:	0f 84 a6 00 00 00    	je     101305 <balloc+0xc5>
  10125f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101266:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101269:	31 f6                	xor    %esi,%esi
  10126b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10126e:	c1 f8 1f             	sar    $0x1f,%eax
  101271:	c1 e8 14             	shr    $0x14,%eax
  101274:	03 45 e0             	add    -0x20(%ebp),%eax
  101277:	c1 ea 03             	shr    $0x3,%edx
  10127a:	c1 f8 0c             	sar    $0xc,%eax
  10127d:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  101281:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101284:	89 54 24 04          	mov    %edx,0x4(%esp)
  101288:	89 04 24             	mov    %eax,(%esp)
  10128b:	e8 20 ee ff ff       	call   1000b0 <bread>
  101290:	89 c7                	mov    %eax,%edi
  101292:	eb 0b                	jmp    10129f <balloc+0x5f>
    for(bi = 0; bi < BPB; bi++){
  101294:	83 c6 01             	add    $0x1,%esi
  101297:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  10129d:	74 4b                	je     1012ea <balloc+0xaa>
      m = 1 << (bi % 8);
  10129f:	89 f0                	mov    %esi,%eax
  1012a1:	bb 01 00 00 00       	mov    $0x1,%ebx
  1012a6:	c1 f8 1f             	sar    $0x1f,%eax
  1012a9:	c1 e8 1d             	shr    $0x1d,%eax
  1012ac:	8d 14 06             	lea    (%esi,%eax,1),%edx
  1012af:	89 d1                	mov    %edx,%ecx
  1012b1:	83 e1 07             	and    $0x7,%ecx
  1012b4:	29 c1                	sub    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012b6:	c1 fa 03             	sar    $0x3,%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1012b9:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012bb:	0f b6 4c 17 18       	movzbl 0x18(%edi,%edx,1),%ecx
  1012c0:	0f b6 c1             	movzbl %cl,%eax
  1012c3:	85 d8                	test   %ebx,%eax
  1012c5:	75 cd                	jne    101294 <balloc+0x54>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1012c7:	09 d9                	or     %ebx,%ecx
  1012c9:	88 4c 17 18          	mov    %cl,0x18(%edi,%edx,1)
        bwrite(bp);
  1012cd:	89 3c 24             	mov    %edi,(%esp)
  1012d0:	e8 ab ed ff ff       	call   100080 <bwrite>
        brelse(bp);
  1012d5:	89 3c 24             	mov    %edi,(%esp)
  1012d8:	e8 23 ed ff ff       	call   100000 <brelse>
  1012dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012e0:	83 c4 2c             	add    $0x2c,%esp
  1012e3:	5b                   	pop    %ebx
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1012e4:	01 f0                	add    %esi,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012e6:	5e                   	pop    %esi
  1012e7:	5f                   	pop    %edi
  1012e8:	5d                   	pop    %ebp
  1012e9:	c3                   	ret    
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1012ea:	89 3c 24             	mov    %edi,(%esp)
  1012ed:	e8 0e ed ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1012f2:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  1012f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1012fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1012ff:	0f 87 61 ff ff ff    	ja     101266 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  101305:	c7 04 24 4a 5f 10 00 	movl   $0x105f4a,(%esp)
  10130c:	e8 8f f5 ff ff       	call   1008a0 <panic>
  101311:	eb 0d                	jmp    101320 <bmap>
  101313:	90                   	nop    
  101314:	90                   	nop    
  101315:	90                   	nop    
  101316:	90                   	nop    
  101317:	90                   	nop    
  101318:	90                   	nop    
  101319:	90                   	nop    
  10131a:	90                   	nop    
  10131b:	90                   	nop    
  10131c:	90                   	nop    
  10131d:	90                   	nop    
  10131e:	90                   	nop    
  10131f:	90                   	nop    

00101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101320:	55                   	push   %ebp
  101321:	89 e5                	mov    %esp,%ebp
  101323:	83 ec 28             	sub    $0x28,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101326:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101329:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10132c:	89 d6                	mov    %edx,%esi
  10132e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101331:	89 c7                	mov    %eax,%edi
  101333:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101336:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101339:	77 28                	ja     101363 <bmap+0x43>
    if((addr = ip->addrs[bn]) == 0){
  10133b:	8b 5c 90 1c          	mov    0x1c(%eax,%edx,4),%ebx
  10133f:	85 db                	test   %ebx,%ebx
  101341:	75 11                	jne    101354 <bmap+0x34>
      if(!alloc)
  101343:	85 c9                	test   %ecx,%ecx
  101345:	74 32                	je     101379 <bmap+0x59>
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101347:	8b 00                	mov    (%eax),%eax
  101349:	e8 f2 fe ff ff       	call   101240 <balloc>
  10134e:	89 c3                	mov    %eax,%ebx
  101350:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  101354:	89 d8                	mov    %ebx,%eax
  101356:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101359:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10135c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10135f:	89 ec                	mov    %ebp,%esp
  101361:	5d                   	pop    %ebp
  101362:	c3                   	ret    
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101363:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
  101366:	83 fb 7f             	cmp    $0x7f,%ebx
  101369:	77 75                	ja     1013e0 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  10136b:	8b 40 4c             	mov    0x4c(%eax),%eax
  10136e:	85 c0                	test   %eax,%eax
  101370:	75 18                	jne    10138a <bmap+0x6a>
      if(!alloc)
  101372:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  101375:	85 c9                	test   %ecx,%ecx
  101377:	75 07                	jne    101380 <bmap+0x60>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  101379:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10137e:	eb d4                	jmp    101354 <bmap+0x34>
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101380:	8b 07                	mov    (%edi),%eax
  101382:	e8 b9 fe ff ff       	call   101240 <balloc>
  101387:	89 47 4c             	mov    %eax,0x4c(%edi)
    }
    bp = bread(ip->dev, addr);
  10138a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10138e:	8b 07                	mov    (%edi),%eax
  101390:	89 04 24             	mov    %eax,(%esp)
  101393:	e8 18 ed ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101398:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  10139c:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  10139e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  1013a1:	8b 1b                	mov    (%ebx),%ebx
  1013a3:	85 db                	test   %ebx,%ebx
  1013a5:	75 2c                	jne    1013d3 <bmap+0xb3>
      if(!alloc){
  1013a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1013aa:	85 d2                	test   %edx,%edx
  1013ac:	75 0f                	jne    1013bd <bmap+0x9d>
        brelse(bp);
  1013ae:	89 34 24             	mov    %esi,(%esp)
  1013b1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1013b6:	e8 45 ec ff ff       	call   100000 <brelse>
  1013bb:	eb 97                	jmp    101354 <bmap+0x34>
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  1013bd:	8b 07                	mov    (%edi),%eax
  1013bf:	e8 7c fe ff ff       	call   101240 <balloc>
  1013c4:	89 c3                	mov    %eax,%ebx
  1013c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013c9:	89 18                	mov    %ebx,(%eax)
      bwrite(bp);
  1013cb:	89 34 24             	mov    %esi,(%esp)
  1013ce:	e8 ad ec ff ff       	call   100080 <bwrite>
    }
    brelse(bp);
  1013d3:	89 34 24             	mov    %esi,(%esp)
  1013d6:	e8 25 ec ff ff       	call   100000 <brelse>
  1013db:	e9 74 ff ff ff       	jmp    101354 <bmap+0x34>
    return addr;
  }

  panic("bmap: out of range");
  1013e0:	c7 04 24 60 5f 10 00 	movl   $0x105f60,(%esp)
  1013e7:	e8 b4 f4 ff ff       	call   1008a0 <panic>
  1013ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001013f0 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1013f0:	55                   	push   %ebp
  1013f1:	89 e5                	mov    %esp,%ebp
  1013f3:	57                   	push   %edi
  1013f4:	56                   	push   %esi
  1013f5:	53                   	push   %ebx
  1013f6:	83 ec 1c             	sub    $0x1c,%esp
  1013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1013ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  101402:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101405:	8b 45 14             	mov    0x14(%ebp),%eax
  101408:	89 55 e8             	mov    %edx,-0x18(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10140b:	8b 55 ec             	mov    -0x14(%ebp),%edx
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  10140e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101411:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  101416:	0f 84 c9 00 00 00    	je     1014e5 <writei+0xf5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  10141c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10141f:	01 f8                	add    %edi,%eax
  101421:	39 c7                	cmp    %eax,%edi
  101423:	0f 87 c6 00 00 00    	ja     1014ef <writei+0xff>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101429:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10142e:	76 0a                	jbe    10143a <writei+0x4a>
    n = MAXFILE*BSIZE - off;
  101430:	c7 45 e4 00 18 01 00 	movl   $0x11800,-0x1c(%ebp)
  101437:	29 7d e4             	sub    %edi,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10143a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10143d:	85 db                	test   %ebx,%ebx
  10143f:	0f 84 95 00 00 00    	je     1014da <writei+0xea>
  101445:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10144c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101453:	89 fa                	mov    %edi,%edx
  101455:	b9 01 00 00 00       	mov    $0x1,%ecx
  10145a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10145d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101462:	e8 b9 fe ff ff       	call   101320 <bmap>
  101467:	89 44 24 04          	mov    %eax,0x4(%esp)
  10146b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10146e:	8b 02                	mov    (%edx),%eax
  101470:	89 04 24             	mov    %eax,(%esp)
  101473:	e8 38 ec ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101478:	89 fa                	mov    %edi,%edx
  10147a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101480:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101482:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  101484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101487:	2b 45 f0             	sub    -0x10(%ebp),%eax
  10148a:	39 c3                	cmp    %eax,%ebx
  10148c:	76 02                	jbe    101490 <writei+0xa0>
  10148e:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  101490:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101497:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101499:	89 44 24 04          	mov    %eax,0x4(%esp)
  10149d:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  1014a1:	89 04 24             	mov    %eax,(%esp)
  1014a4:	e8 57 2a 00 00       	call   103f00 <memmove>
    bwrite(bp);
  1014a9:	89 34 24             	mov    %esi,(%esp)
  1014ac:	e8 cf eb ff ff       	call   100080 <bwrite>
    brelse(bp);
  1014b1:	89 34 24             	mov    %esi,(%esp)
  1014b4:	e8 47 eb ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1014b9:	01 5d f0             	add    %ebx,-0x10(%ebp)
  1014bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1014bf:	01 5d e8             	add    %ebx,-0x18(%ebp)
  1014c2:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  1014c5:	77 89                	ja     101450 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  1014c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014ca:	39 78 18             	cmp    %edi,0x18(%eax)
  1014cd:	73 0b                	jae    1014da <writei+0xea>
    ip->size = off;
  1014cf:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  1014d2:	89 04 24             	mov    %eax,(%esp)
  1014d5:	e8 d6 fc ff ff       	call   1011b0 <iupdate>
  }
  return n;
  1014da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  1014dd:	83 c4 1c             	add    $0x1c,%esp
  1014e0:	5b                   	pop    %ebx
  1014e1:	5e                   	pop    %esi
  1014e2:	5f                   	pop    %edi
  1014e3:	5d                   	pop    %ebp
  1014e4:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1014e5:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  1014e9:	66 83 f8 09          	cmp    $0x9,%ax
  1014ed:	76 0d                	jbe    1014fc <writei+0x10c>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1014ef:	83 c4 1c             	add    $0x1c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1014f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1014f7:	5b                   	pop    %ebx
  1014f8:	5e                   	pop    %esi
  1014f9:	5f                   	pop    %edi
  1014fa:	5d                   	pop    %ebp
  1014fb:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1014fc:	98                   	cwtl   
  1014fd:	8b 0c c5 24 9a 10 00 	mov    0x109a24(,%eax,8),%ecx
  101504:	85 c9                	test   %ecx,%ecx
  101506:	74 e7                	je     1014ef <writei+0xff>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10150b:	89 45 10             	mov    %eax,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10150e:	83 c4 1c             	add    $0x1c,%esp
  101511:	5b                   	pop    %ebx
  101512:	5e                   	pop    %esi
  101513:	5f                   	pop    %edi
  101514:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101515:	ff e1                	jmp    *%ecx
  101517:	89 f6                	mov    %esi,%esi
  101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101520 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	83 ec 28             	sub    $0x28,%esp
  101526:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101529:	8b 7d 08             	mov    0x8(%ebp),%edi
  10152c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10152f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101532:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101535:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101538:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10153b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101540:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101543:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101546:	74 19                	je     101561 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101548:	8b 47 18             	mov    0x18(%edi),%eax
  10154b:	39 d8                	cmp    %ebx,%eax
  10154d:	73 3c                	jae    10158b <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10154f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101554:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101557:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10155a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10155d:	89 ec                	mov    %ebp,%esp
  10155f:	5d                   	pop    %ebp
  101560:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101561:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  101565:	66 83 f8 09          	cmp    $0x9,%ax
  101569:	77 e4                	ja     10154f <readi+0x2f>
  10156b:	98                   	cwtl   
  10156c:	8b 0c c5 20 9a 10 00 	mov    0x109a20(,%eax,8),%ecx
  101573:	85 c9                	test   %ecx,%ecx
  101575:	74 d8                	je     10154f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  10157a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10157d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101580:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101583:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101586:	89 ec                	mov    %ebp,%esp
  101588:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101589:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  10158b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10158e:	01 da                	add    %ebx,%edx
  101590:	39 d3                	cmp    %edx,%ebx
  101592:	77 bb                	ja     10154f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  101594:	39 d0                	cmp    %edx,%eax
  101596:	73 05                	jae    10159d <readi+0x7d>
    n = ip->size - off;
  101598:	29 d8                	sub    %ebx,%eax
  10159a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  10159d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  1015a0:	85 f6                	test   %esi,%esi
  1015a2:	74 7b                	je     10161f <readi+0xff>
  1015a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1015ab:	90                   	nop    
  1015ac:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015b0:	89 da                	mov    %ebx,%edx
  1015b2:	31 c9                	xor    %ecx,%ecx
  1015b4:	c1 ea 09             	shr    $0x9,%edx
  1015b7:	89 f8                	mov    %edi,%eax
  1015b9:	e8 62 fd ff ff       	call   101320 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015be:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015c7:	8b 07                	mov    (%edi),%eax
  1015c9:	89 04 24             	mov    %eax,(%esp)
  1015cc:	e8 df ea ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015d1:	89 da                	mov    %ebx,%edx
  1015d3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1015d9:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  1015de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1015e4:	39 c6                	cmp    %eax,%esi
  1015e6:	76 02                	jbe    1015ea <readi+0xca>
  1015e8:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  1015ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  1015ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015f1:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1015f3:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  1015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1015fe:	89 04 24             	mov    %eax,(%esp)
  101601:	e8 fa 28 00 00       	call   103f00 <memmove>
    brelse(bp);
  101606:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101609:	89 0c 24             	mov    %ecx,(%esp)
  10160c:	e8 ef e9 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101611:	01 75 ec             	add    %esi,-0x14(%ebp)
  101614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101617:	01 75 e8             	add    %esi,-0x18(%ebp)
  10161a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10161d:	77 91                	ja     1015b0 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10161f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101622:	e9 2d ff ff ff       	jmp    101554 <readi+0x34>
  101627:	89 f6                	mov    %esi,%esi
  101629:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101630 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101636:	8b 45 0c             	mov    0xc(%ebp),%eax
  101639:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101640:	00 
  101641:	89 44 24 04          	mov    %eax,0x4(%esp)
  101645:	8b 45 08             	mov    0x8(%ebp),%eax
  101648:	89 04 24             	mov    %eax,(%esp)
  10164b:	e8 10 29 00 00       	call   103f60 <strncmp>
}
  101650:	c9                   	leave  
  101651:	c3                   	ret    
  101652:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101660 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101660:	55                   	push   %ebp
  101661:	89 e5                	mov    %esp,%ebp
  101663:	57                   	push   %edi
  101664:	56                   	push   %esi
  101665:	53                   	push   %ebx
  101666:	83 ec 1c             	sub    $0x1c,%esp
  101669:	8b 45 08             	mov    0x8(%ebp),%eax
  10166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101672:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101677:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10167a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10167d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101680:	0f 85 cd 00 00 00    	jne    101753 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101686:	8b 40 18             	mov    0x18(%eax),%eax
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101689:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  101690:	85 c0                	test   %eax,%eax
  101692:	0f 84 b1 00 00 00    	je     101749 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10169b:	31 c9                	xor    %ecx,%ecx
  10169d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1016a0:	c1 ea 09             	shr    $0x9,%edx
  1016a3:	e8 78 fc ff ff       	call   101320 <bmap>
  1016a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1016af:	8b 02                	mov    (%edx),%eax
  1016b1:	89 04 24             	mov    %eax,(%esp)
  1016b4:	e8 f7 e9 ff ff       	call   1000b0 <bread>
    for(de = (struct dirent*)bp->data;
  1016b9:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1016bc:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1016be:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1016c4:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  1016c6:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1016c8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  1016cb:	72 0a                	jb     1016d7 <dirlookup+0x77>
  1016cd:	eb 5c                	jmp    10172b <dirlookup+0xcb>
  1016cf:	90                   	nop    
        de++){
  1016d0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1016d3:	39 f3                	cmp    %esi,%ebx
  1016d5:	73 54                	jae    10172b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  1016d7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1016db:	90                   	nop    
  1016dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1016e0:	74 ee                	je     1016d0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  1016e2:	8d 43 02             	lea    0x2(%ebx),%eax
  1016e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016ec:	89 04 24             	mov    %eax,(%esp)
  1016ef:	e8 3c ff ff ff       	call   101630 <namecmp>
  1016f4:	85 c0                	test   %eax,%eax
  1016f6:	75 d8                	jne    1016d0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1016f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1016fb:	85 c0                	test   %eax,%eax
  1016fd:	74 0e                	je     10170d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  1016ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101702:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101705:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101708:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10170b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  10170d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101710:	89 3c 24             	mov    %edi,(%esp)
  101713:	e8 e8 e8 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  101718:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10171b:	89 da                	mov    %ebx,%edx
  10171d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  10171f:	83 c4 1c             	add    $0x1c,%esp
  101722:	5b                   	pop    %ebx
  101723:	5e                   	pop    %esi
  101724:	5f                   	pop    %edi
  101725:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101726:	e9 85 f9 ff ff       	jmp    1010b0 <iget>
      }
    }
    brelse(bp);
  10172b:	89 3c 24             	mov    %edi,(%esp)
  10172e:	e8 cd e8 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101736:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  10173d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101740:	39 50 18             	cmp    %edx,0x18(%eax)
  101743:	0f 87 4f ff ff ff    	ja     101698 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101749:	83 c4 1c             	add    $0x1c,%esp
  10174c:	31 c0                	xor    %eax,%eax
  10174e:	5b                   	pop    %ebx
  10174f:	5e                   	pop    %esi
  101750:	5f                   	pop    %edi
  101751:	5d                   	pop    %ebp
  101752:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101753:	c7 04 24 73 5f 10 00 	movl   $0x105f73,(%esp)
  10175a:	e8 41 f1 ff ff       	call   1008a0 <panic>
  10175f:	90                   	nop    

00101760 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101760:	55                   	push   %ebp
  101761:	89 e5                	mov    %esp,%ebp
  101763:	57                   	push   %edi
  101764:	56                   	push   %esi
  101765:	53                   	push   %ebx
  101766:	83 ec 2c             	sub    $0x2c,%esp
  101769:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10176d:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101770:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101774:	8b 45 08             	mov    0x8(%ebp),%eax
  101777:	e8 e4 f9 ff ff       	call   101160 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10177c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101780:	0f 86 8e 00 00 00    	jbe    101814 <ialloc+0xb4>
  101786:	bf 01 00 00 00       	mov    $0x1,%edi
  10178b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101792:	eb 14                	jmp    1017a8 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101794:	89 34 24             	mov    %esi,(%esp)
  101797:	e8 64 e8 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10179c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1017a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1017a3:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  1017a6:	76 6c                	jbe    101814 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  1017a8:	89 f8                	mov    %edi,%eax
  1017aa:	c1 e8 03             	shr    $0x3,%eax
  1017ad:	83 c0 02             	add    $0x2,%eax
  1017b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1017b7:	89 04 24             	mov    %eax,(%esp)
  1017ba:	e8 f1 e8 ff ff       	call   1000b0 <bread>
  1017bf:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  1017c1:	89 f8                	mov    %edi,%eax
  1017c3:	83 e0 07             	and    $0x7,%eax
  1017c6:	c1 e0 06             	shl    $0x6,%eax
  1017c9:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  1017cd:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1017d1:	75 c1                	jne    101794 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  1017d3:	89 1c 24             	mov    %ebx,(%esp)
  1017d6:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  1017dd:	00 
  1017de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1017e5:	00 
  1017e6:	e8 65 26 00 00       	call   103e50 <memset>
      dip->type = type;
  1017eb:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  1017ef:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  1017f2:	89 34 24             	mov    %esi,(%esp)
  1017f5:	e8 86 e8 ff ff       	call   100080 <bwrite>
      brelse(bp);
  1017fa:	89 34 24             	mov    %esi,(%esp)
  1017fd:	e8 fe e7 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101802:	8b 45 08             	mov    0x8(%ebp),%eax
  101805:	89 fa                	mov    %edi,%edx
  101807:	e8 a4 f8 ff ff       	call   1010b0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  10180c:	83 c4 2c             	add    $0x2c,%esp
  10180f:	5b                   	pop    %ebx
  101810:	5e                   	pop    %esi
  101811:	5f                   	pop    %edi
  101812:	5d                   	pop    %ebp
  101813:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101814:	c7 04 24 85 5f 10 00 	movl   $0x105f85,(%esp)
  10181b:	e8 80 f0 ff ff       	call   1008a0 <panic>

00101820 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101820:	55                   	push   %ebp
  101821:	89 e5                	mov    %esp,%ebp
  101823:	57                   	push   %edi
  101824:	89 d7                	mov    %edx,%edi
  101826:	56                   	push   %esi
  101827:	89 c6                	mov    %eax,%esi
  101829:	53                   	push   %ebx
  10182a:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  10182d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101831:	89 04 24             	mov    %eax,(%esp)
  101834:	e8 77 e8 ff ff       	call   1000b0 <bread>
  memset(bp->data, 0, BSIZE);
  101839:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101840:	00 
  101841:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101848:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101849:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  10184b:	8d 40 18             	lea    0x18(%eax),%eax
  10184e:	89 04 24             	mov    %eax,(%esp)
  101851:	e8 fa 25 00 00       	call   103e50 <memset>
  bwrite(bp);
  101856:	89 1c 24             	mov    %ebx,(%esp)
  101859:	e8 22 e8 ff ff       	call   100080 <bwrite>
  brelse(bp);
  10185e:	89 1c 24             	mov    %ebx,(%esp)
  101861:	e8 9a e7 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101866:	89 f0                	mov    %esi,%eax
  101868:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10186b:	e8 f0 f8 ff ff       	call   101160 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101873:	89 fa                	mov    %edi,%edx
  101875:	c1 ea 0c             	shr    $0xc,%edx
  101878:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  10187b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101880:	c1 e8 03             	shr    $0x3,%eax
  101883:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101887:	89 44 24 04          	mov    %eax,0x4(%esp)
  10188b:	e8 20 e8 ff ff       	call   1000b0 <bread>
  101890:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  101892:	89 f8                	mov    %edi,%eax
  101894:	25 ff 0f 00 00       	and    $0xfff,%eax
  101899:	89 c1                	mov    %eax,%ecx
  10189b:	83 e1 07             	and    $0x7,%ecx
  10189e:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  1018a0:	89 c1                	mov    %eax,%ecx
  1018a2:	c1 f9 03             	sar    $0x3,%ecx
  1018a5:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  1018aa:	0f b6 c2             	movzbl %dl,%eax
  1018ad:	85 f0                	test   %esi,%eax
  1018af:	74 22                	je     1018d3 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  1018b1:	89 f0                	mov    %esi,%eax
  1018b3:	f7 d0                	not    %eax
  1018b5:	21 d0                	and    %edx,%eax
  1018b7:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  1018bb:	89 1c 24             	mov    %ebx,(%esp)
  1018be:	e8 bd e7 ff ff       	call   100080 <bwrite>
  brelse(bp);
  1018c3:	89 1c 24             	mov    %ebx,(%esp)
  1018c6:	e8 35 e7 ff ff       	call   100000 <brelse>
}
  1018cb:	83 c4 1c             	add    $0x1c,%esp
  1018ce:	5b                   	pop    %ebx
  1018cf:	5e                   	pop    %esi
  1018d0:	5f                   	pop    %edi
  1018d1:	5d                   	pop    %ebp
  1018d2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  1018d3:	c7 04 24 97 5f 10 00 	movl   $0x105f97,(%esp)
  1018da:	e8 c1 ef ff ff       	call   1008a0 <panic>
  1018df:	90                   	nop    

001018e0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  1018e0:	55                   	push   %ebp
  1018e1:	89 e5                	mov    %esp,%ebp
  1018e3:	57                   	push   %edi
  1018e4:	56                   	push   %esi
  1018e5:	53                   	push   %ebx
  1018e6:	83 ec 0c             	sub    $0xc,%esp
  1018e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  1018ec:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1018f3:	e8 f8 24 00 00       	call   103df0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  1018f8:	83 7e 08 01          	cmpl   $0x1,0x8(%esi)
  1018fc:	0f 85 9e 00 00 00    	jne    1019a0 <iput+0xc0>
  101902:	8b 46 0c             	mov    0xc(%esi),%eax
  101905:	a8 02                	test   $0x2,%al
  101907:	0f 84 93 00 00 00    	je     1019a0 <iput+0xc0>
  10190d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101912:	0f 85 88 00 00 00    	jne    1019a0 <iput+0xc0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101918:	a8 01                	test   $0x1,%al
  10191a:	0f 85 e9 00 00 00    	jne    101a09 <iput+0x129>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101920:	83 c8 01             	or     $0x1,%eax
    release(&icache.lock);
  101923:	31 db                	xor    %ebx,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101925:	89 46 0c             	mov    %eax,0xc(%esi)
    release(&icache.lock);
  101928:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  10192f:	e8 7c 24 00 00       	call   103db0 <release>
  101934:	eb 08                	jmp    10193e <iput+0x5e>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101936:	83 c3 01             	add    $0x1,%ebx
  101939:	83 fb 0c             	cmp    $0xc,%ebx
  10193c:	74 1f                	je     10195d <iput+0x7d>
    if(ip->addrs[i]){
  10193e:	8b 54 9e 1c          	mov    0x1c(%esi,%ebx,4),%edx
  101942:	85 d2                	test   %edx,%edx
  101944:	74 f0                	je     101936 <iput+0x56>
      bfree(ip->dev, ip->addrs[i]);
  101946:	8b 06                	mov    (%esi),%eax
  101948:	e8 d3 fe ff ff       	call   101820 <bfree>
      ip->addrs[i] = 0;
  10194d:	c7 44 9e 1c 00 00 00 	movl   $0x0,0x1c(%esi,%ebx,4)
  101954:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101955:	83 c3 01             	add    $0x1,%ebx
  101958:	83 fb 0c             	cmp    $0xc,%ebx
  10195b:	75 e1                	jne    10193e <iput+0x5e>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  10195d:	8b 46 4c             	mov    0x4c(%esi),%eax
  101960:	85 c0                	test   %eax,%eax
  101962:	75 53                	jne    1019b7 <iput+0xd7>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101964:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  10196b:	89 34 24             	mov    %esi,(%esp)
  10196e:	e8 3d f8 ff ff       	call   1011b0 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101973:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101979:	89 34 24             	mov    %esi,(%esp)
  10197c:	e8 2f f8 ff ff       	call   1011b0 <iupdate>
    acquire(&icache.lock);
  101981:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101988:	e8 63 24 00 00       	call   103df0 <acquire>
    ip->flags &= ~I_BUSY;
  10198d:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101991:	89 34 24             	mov    %esi,(%esp)
  101994:	e8 f7 17 00 00       	call   103190 <wakeup>
  101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  ip->ref--;
  1019a0:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
  1019a4:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  1019ab:	83 c4 0c             	add    $0xc,%esp
  1019ae:	5b                   	pop    %ebx
  1019af:	5e                   	pop    %esi
  1019b0:	5f                   	pop    %edi
  1019b1:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  1019b2:	e9 f9 23 00 00       	jmp    103db0 <release>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  1019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019bb:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  1019bd:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  1019bf:	89 04 24             	mov    %eax,(%esp)
  1019c2:	e8 e9 e6 ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
  1019c7:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  1019c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  1019cc:	83 c7 18             	add    $0x18,%edi
  1019cf:	31 c0                	xor    %eax,%eax
  1019d1:	eb 0d                	jmp    1019e0 <iput+0x100>
    for(j = 0; j < NINDIRECT; j++){
  1019d3:	83 c3 01             	add    $0x1,%ebx
  1019d6:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  1019dc:	89 d8                	mov    %ebx,%eax
  1019de:	74 12                	je     1019f2 <iput+0x112>
      if(a[j])
  1019e0:	8b 14 87             	mov    (%edi,%eax,4),%edx
  1019e3:	85 d2                	test   %edx,%edx
  1019e5:	74 ec                	je     1019d3 <iput+0xf3>
        bfree(ip->dev, a[j]);
  1019e7:	8b 06                	mov    (%esi),%eax
  1019e9:	e8 32 fe ff ff       	call   101820 <bfree>
  1019ee:	66 90                	xchg   %ax,%ax
  1019f0:	eb e1                	jmp    1019d3 <iput+0xf3>
    }
    brelse(bp);
  1019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019f5:	89 04 24             	mov    %eax,(%esp)
  1019f8:	e8 03 e6 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  1019fd:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101a04:	e9 5b ff ff ff       	jmp    101964 <iput+0x84>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101a09:	c7 04 24 aa 5f 10 00 	movl   $0x105faa,(%esp)
  101a10:	e8 8b ee ff ff       	call   1008a0 <panic>
  101a15:	8d 74 26 00          	lea    0x0(%esi),%esi
  101a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101a20 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101a20:	55                   	push   %ebp
  101a21:	89 e5                	mov    %esp,%ebp
  101a23:	57                   	push   %edi
  101a24:	56                   	push   %esi
  101a25:	53                   	push   %ebx
  101a26:	83 ec 2c             	sub    $0x2c,%esp
  101a29:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101a36:	00 
  101a37:	89 34 24             	mov    %esi,(%esp)
  101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3e:	e8 1d fc ff ff       	call   101660 <dirlookup>
  101a43:	85 c0                	test   %eax,%eax
  101a45:	0f 85 98 00 00 00    	jne    101ae3 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a4b:	8b 46 18             	mov    0x18(%esi),%eax
  101a4e:	85 c0                	test   %eax,%eax
  101a50:	0f 84 9c 00 00 00    	je     101af2 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101a56:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101a59:	31 db                	xor    %ebx,%ebx
  101a5b:	eb 0b                	jmp    101a68 <dirlink+0x48>
  101a5d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101a60:	83 c3 10             	add    $0x10,%ebx
  101a63:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101a66:	76 24                	jbe    101a8c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101a68:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101a6f:	00 
  101a70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101a74:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101a78:	89 34 24             	mov    %esi,(%esp)
  101a7b:	e8 a0 fa ff ff       	call   101520 <readi>
  101a80:	83 f8 10             	cmp    $0x10,%eax
  101a83:	75 52                	jne    101ad7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101a85:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101a8a:	75 d4                	jne    101a60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a8f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101a96:	00 
  101a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101a9e:	89 04 24             	mov    %eax,(%esp)
  101aa1:	e8 1a 25 00 00       	call   103fc0 <strncpy>
  de.inum = ino;
  101aa6:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101aaa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101ab1:	00 
  101ab2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101ab6:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101aba:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101abe:	89 34 24             	mov    %esi,(%esp)
  101ac1:	e8 2a f9 ff ff       	call   1013f0 <writei>
    panic("dirlink");
  101ac6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101ac8:	83 f8 10             	cmp    $0x10,%eax
  101acb:	75 2c                	jne    101af9 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101acd:	83 c4 2c             	add    $0x2c,%esp
  101ad0:	89 d0                	mov    %edx,%eax
  101ad2:	5b                   	pop    %ebx
  101ad3:	5e                   	pop    %esi
  101ad4:	5f                   	pop    %edi
  101ad5:	5d                   	pop    %ebp
  101ad6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101ad7:	c7 04 24 b4 5f 10 00 	movl   $0x105fb4,(%esp)
  101ade:	e8 bd ed ff ff       	call   1008a0 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ae3:	89 04 24             	mov    %eax,(%esp)
  101ae6:	e8 f5 fd ff ff       	call   1018e0 <iput>
  101aeb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101af0:	eb db                	jmp    101acd <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101af2:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101af5:	31 db                	xor    %ebx,%ebx
  101af7:	eb 93                	jmp    101a8c <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101af9:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  101b00:	e8 9b ed ff ff       	call   1008a0 <panic>
  101b05:	8d 74 26 00          	lea    0x0(%esi),%esi
  101b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101b10 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101b10:	55                   	push   %ebp
  101b11:	89 e5                	mov    %esp,%ebp
  101b13:	53                   	push   %ebx
  101b14:	83 ec 04             	sub    $0x4,%esp
  101b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101b1a:	85 db                	test   %ebx,%ebx
  101b1c:	74 36                	je     101b54 <iunlock+0x44>
  101b1e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101b22:	74 30                	je     101b54 <iunlock+0x44>
  101b24:	8b 43 08             	mov    0x8(%ebx),%eax
  101b27:	85 c0                	test   %eax,%eax
  101b29:	7e 29                	jle    101b54 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101b2b:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101b32:	e8 b9 22 00 00       	call   103df0 <acquire>
  ip->flags &= ~I_BUSY;
  101b37:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101b3b:	89 1c 24             	mov    %ebx,(%esp)
  101b3e:	e8 4d 16 00 00       	call   103190 <wakeup>
  release(&icache.lock);
  101b43:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101b4a:	83 c4 04             	add    $0x4,%esp
  101b4d:	5b                   	pop    %ebx
  101b4e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101b4f:	e9 5c 22 00 00       	jmp    103db0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101b54:	c7 04 24 c9 5f 10 00 	movl   $0x105fc9,(%esp)
  101b5b:	e8 40 ed ff ff       	call   1008a0 <panic>

00101b60 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101b60:	55                   	push   %ebp
  101b61:	89 e5                	mov    %esp,%ebp
  101b63:	53                   	push   %ebx
  101b64:	83 ec 04             	sub    $0x4,%esp
  101b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101b6a:	89 1c 24             	mov    %ebx,(%esp)
  101b6d:	e8 9e ff ff ff       	call   101b10 <iunlock>
  iput(ip);
  101b72:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101b75:	83 c4 04             	add    $0x4,%esp
  101b78:	5b                   	pop    %ebx
  101b79:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101b7a:	e9 61 fd ff ff       	jmp    1018e0 <iput>
  101b7f:	90                   	nop    

00101b80 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101b80:	55                   	push   %ebp
  101b81:	89 e5                	mov    %esp,%ebp
  101b83:	56                   	push   %esi
  101b84:	53                   	push   %ebx
  101b85:	83 ec 10             	sub    $0x10,%esp
  101b88:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101b8b:	85 f6                	test   %esi,%esi
  101b8d:	0f 84 dd 00 00 00    	je     101c70 <ilock+0xf0>
  101b93:	8b 46 08             	mov    0x8(%esi),%eax
  101b96:	85 c0                	test   %eax,%eax
  101b98:	0f 8e d2 00 00 00    	jle    101c70 <ilock+0xf0>
    panic("ilock");

  acquire(&icache.lock);
  101b9e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101ba5:	e8 46 22 00 00       	call   103df0 <acquire>
  while(ip->flags & I_BUSY)
  101baa:	8b 46 0c             	mov    0xc(%esi),%eax
  101bad:	a8 01                	test   $0x1,%al
  101baf:	74 17                	je     101bc8 <ilock+0x48>
    sleep(ip, &icache.lock);
  101bb1:	c7 44 24 04 80 9a 10 	movl   $0x109a80,0x4(%esp)
  101bb8:	00 
  101bb9:	89 34 24             	mov    %esi,(%esp)
  101bbc:	e8 ff 17 00 00       	call   1033c0 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101bc1:	8b 46 0c             	mov    0xc(%esi),%eax
  101bc4:	a8 01                	test   $0x1,%al
  101bc6:	75 e9                	jne    101bb1 <ilock+0x31>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101bc8:	83 c8 01             	or     $0x1,%eax
  101bcb:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101bce:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101bd5:	e8 d6 21 00 00       	call   103db0 <release>

  if(!(ip->flags & I_VALID)){
  101bda:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101bde:	74 07                	je     101be7 <ilock+0x67>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101be0:	83 c4 10             	add    $0x10,%esp
  101be3:	5b                   	pop    %ebx
  101be4:	5e                   	pop    %esi
  101be5:	5d                   	pop    %ebp
  101be6:	c3                   	ret    
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101be7:	8b 46 04             	mov    0x4(%esi),%eax
  101bea:	c1 e8 03             	shr    $0x3,%eax
  101bed:	83 c0 02             	add    $0x2,%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	8b 06                	mov    (%esi),%eax
  101bf6:	89 04 24             	mov    %eax,(%esp)
  101bf9:	e8 b2 e4 ff ff       	call   1000b0 <bread>
  101bfe:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101c00:	8b 46 04             	mov    0x4(%esi),%eax
  101c03:	83 e0 07             	and    $0x7,%eax
  101c06:	c1 e0 06             	shl    $0x6,%eax
  101c09:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101c0d:	0f b7 10             	movzwl (%eax),%edx
  101c10:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101c14:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101c18:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101c1c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101c20:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101c24:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101c28:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101c2c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101c2f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101c32:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	8d 46 1c             	lea    0x1c(%esi),%eax
  101c3c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101c43:	00 
  101c44:	89 04 24             	mov    %eax,(%esp)
  101c47:	e8 b4 22 00 00       	call   103f00 <memmove>
    brelse(bp);
  101c4c:	89 1c 24             	mov    %ebx,(%esp)
  101c4f:	e8 ac e3 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101c54:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101c58:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101c5d:	75 81                	jne    101be0 <ilock+0x60>
      panic("ilock: no type");
  101c5f:	c7 04 24 d7 5f 10 00 	movl   $0x105fd7,(%esp)
  101c66:	e8 35 ec ff ff       	call   1008a0 <panic>
  101c6b:	90                   	nop    
  101c6c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101c70:	c7 04 24 d1 5f 10 00 	movl   $0x105fd1,(%esp)
  101c77:	e8 24 ec ff ff       	call   1008a0 <panic>
  101c7c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101c80 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101c80:	55                   	push   %ebp
  101c81:	89 e5                	mov    %esp,%ebp
  101c83:	57                   	push   %edi
  101c84:	56                   	push   %esi
  101c85:	89 c6                	mov    %eax,%esi
  101c87:	53                   	push   %ebx
  101c88:	83 ec 1c             	sub    $0x1c,%esp
  101c8b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  101c8e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101c91:	80 38 2f             	cmpb   $0x2f,(%eax)
  101c94:	0f 84 12 01 00 00    	je     101dac <_namei+0x12c>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101c9a:	e8 21 15 00 00       	call   1031c0 <curproc>
  101c9f:	8b 40 60             	mov    0x60(%eax),%eax
  101ca2:	89 04 24             	mov    %eax,(%esp)
  101ca5:	e8 d6 f3 ff ff       	call   101080 <idup>
  101caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101cad:	eb 04                	jmp    101cb3 <_namei+0x33>
  101caf:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101cb0:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101cb3:	0f b6 06             	movzbl (%esi),%eax
  101cb6:	3c 2f                	cmp    $0x2f,%al
  101cb8:	74 f6                	je     101cb0 <_namei+0x30>
    path++;
  if(*path == 0)
  101cba:	84 c0                	test   %al,%al
  101cbc:	0f 84 bb 00 00 00    	je     101d7d <_namei+0xfd>
  101cc2:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101cc4:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101cc7:	0f b6 03             	movzbl (%ebx),%eax
  101cca:	3c 2f                	cmp    $0x2f,%al
  101ccc:	74 04                	je     101cd2 <_namei+0x52>
  101cce:	84 c0                	test   %al,%al
  101cd0:	75 f2                	jne    101cc4 <_namei+0x44>
    path++;
  len = path - s;
  101cd2:	89 df                	mov    %ebx,%edi
  101cd4:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  101cd6:	83 ff 0d             	cmp    $0xd,%edi
  101cd9:	0f 8e 7f 00 00 00    	jle    101d5e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  101cdf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101ce6:	00 
  101ce7:	89 74 24 04          	mov    %esi,0x4(%esp)
  101ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101cee:	89 04 24             	mov    %eax,(%esp)
  101cf1:	e8 0a 22 00 00       	call   103f00 <memmove>
  101cf6:	eb 03                	jmp    101cfb <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101cf8:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101cfb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  101cfe:	74 f8                	je     101cf8 <_namei+0x78>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101d00:	85 db                	test   %ebx,%ebx
  101d02:	74 79                	je     101d7d <_namei+0xfd>
    ilock(ip);
  101d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d07:	89 04 24             	mov    %eax,(%esp)
  101d0a:	e8 71 fe ff ff       	call   101b80 <ilock>
    if(ip->type != T_DIR){
  101d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d12:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  101d17:	75 79                	jne    101d92 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101d19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101d1c:	85 d2                	test   %edx,%edx
  101d1e:	74 09                	je     101d29 <_namei+0xa9>
  101d20:	80 3b 00             	cmpb   $0x0,(%ebx)
  101d23:	0f 84 9a 00 00 00    	je     101dc3 <_namei+0x143>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101d29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101d30:	00 
  101d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d3b:	89 04 24             	mov    %eax,(%esp)
  101d3e:	e8 1d f9 ff ff       	call   101660 <dirlookup>
  101d43:	85 c0                	test   %eax,%eax
  101d45:	89 c6                	mov    %eax,%esi
  101d47:	74 46                	je     101d8f <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d4c:	89 04 24             	mov    %eax,(%esp)
  101d4f:	e8 0c fe ff ff       	call   101b60 <iunlockput>
  101d54:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101d57:	89 de                	mov    %ebx,%esi
  101d59:	e9 55 ff ff ff       	jmp    101cb3 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101d5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101d62:	89 74 24 04          	mov    %esi,0x4(%esp)
  101d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d69:	89 04 24             	mov    %eax,(%esp)
  101d6c:	e8 8f 21 00 00       	call   103f00 <memmove>
    name[len] = 0;
  101d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101d74:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  101d78:	e9 7e ff ff ff       	jmp    101cfb <_namei+0x7b>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  101d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101d80:	85 c0                	test   %eax,%eax
  101d82:	75 55                	jne    101dd9 <_namei+0x159>
    iput(ip);
    return 0;
  }
  return ip;
}
  101d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d87:	83 c4 1c             	add    $0x1c,%esp
  101d8a:	5b                   	pop    %ebx
  101d8b:	5e                   	pop    %esi
  101d8c:	5f                   	pop    %edi
  101d8d:	5d                   	pop    %ebp
  101d8e:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d92:	89 04 24             	mov    %eax,(%esp)
  101d95:	e8 c6 fd ff ff       	call   101b60 <iunlockput>
  101d9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101da4:	83 c4 1c             	add    $0x1c,%esp
  101da7:	5b                   	pop    %ebx
  101da8:	5e                   	pop    %esi
  101da9:	5f                   	pop    %edi
  101daa:	5d                   	pop    %ebp
  101dab:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  101dac:	ba 01 00 00 00       	mov    $0x1,%edx
  101db1:	b8 01 00 00 00       	mov    $0x1,%eax
  101db6:	e8 f5 f2 ff ff       	call   1010b0 <iget>
  101dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101dbe:	e9 f0 fe ff ff       	jmp    101cb3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101dc6:	89 04 24             	mov    %eax,(%esp)
  101dc9:	e8 42 fd ff ff       	call   101b10 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101dd1:	83 c4 1c             	add    $0x1c,%esp
  101dd4:	5b                   	pop    %ebx
  101dd5:	5e                   	pop    %esi
  101dd6:	5f                   	pop    %edi
  101dd7:	5d                   	pop    %ebp
  101dd8:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  101dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ddc:	89 04 24             	mov    %eax,(%esp)
  101ddf:	e8 fc fa ff ff       	call   1018e0 <iput>
  101de4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  101deb:	eb 97                	jmp    101d84 <_namei+0x104>
  101ded:	8d 76 00             	lea    0x0(%esi),%esi

00101df0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101df0:	55                   	push   %ebp
  return _namei(path, 1, name);
  101df1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101df6:	89 e5                	mov    %esp,%ebp
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  101dfe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  101dff:	e9 7c fe ff ff       	jmp    101c80 <_namei>
  101e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101e10 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  101e10:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101e11:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  101e13:	89 e5                	mov    %esp,%ebp
  101e15:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101e18:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  101e1e:	e8 5d fe ff ff       	call   101c80 <_namei>
}
  101e23:	c9                   	leave  
  101e24:	c3                   	ret    
  101e25:	8d 74 26 00          	lea    0x0(%esi),%esi
  101e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101e30 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  101e30:	55                   	push   %ebp
  101e31:	89 e5                	mov    %esp,%ebp
  101e33:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache.lock");
  101e36:	c7 44 24 04 e6 5f 10 	movl   $0x105fe6,0x4(%esp)
  101e3d:	00 
  101e3e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101e45:	e8 e6 1d 00 00       	call   103c30 <initlock>
}
  101e4a:	c9                   	leave  
  101e4b:	c3                   	ret    
  101e4c:	90                   	nop    
  101e4d:	90                   	nop    
  101e4e:	90                   	nop    
  101e4f:	90                   	nop    

00101e50 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  101e50:	55                   	push   %ebp
  101e51:	89 c1                	mov    %eax,%ecx
  101e53:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101e55:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101e5a:	ec                   	in     (%dx),%al
  return data;
  101e5b:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  101e5e:	84 c0                	test   %al,%al
  101e60:	78 f3                	js     101e55 <ide_wait_ready+0x5>
  101e62:	a8 40                	test   $0x40,%al
  101e64:	74 ef                	je     101e55 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  101e66:	85 c9                	test   %ecx,%ecx
  101e68:	74 09                	je     101e73 <ide_wait_ready+0x23>
  101e6a:	a8 21                	test   $0x21,%al
  101e6c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101e71:	75 02                	jne    101e75 <ide_wait_ready+0x25>
  101e73:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  101e75:	5d                   	pop    %ebp
  101e76:	89 d0                	mov    %edx,%eax
  101e78:	c3                   	ret    
  101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101e80 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  101e80:	55                   	push   %ebp
  101e81:	89 e5                	mov    %esp,%ebp
  101e83:	56                   	push   %esi
  101e84:	89 c6                	mov    %eax,%esi
  101e86:	53                   	push   %ebx
  101e87:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  101e8a:	85 c0                	test   %eax,%eax
  101e8c:	0f 84 81 00 00 00    	je     101f13 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  101e92:	31 c0                	xor    %eax,%eax
  101e94:	e8 b7 ff ff ff       	call   101e50 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101e99:	31 c0                	xor    %eax,%eax
  101e9b:	ba f6 03 00 00       	mov    $0x3f6,%edx
  101ea0:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  101ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  101ea6:	ba f2 01 00 00       	mov    $0x1f2,%edx
  101eab:	ee                   	out    %al,(%dx)
  101eac:	8b 46 08             	mov    0x8(%esi),%eax
  101eaf:	b2 f3                	mov    $0xf3,%dl
  101eb1:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  101eb2:	c1 e8 08             	shr    $0x8,%eax
  101eb5:	b2 f4                	mov    $0xf4,%dl
  101eb7:	ee                   	out    %al,(%dx)
  101eb8:	c1 e8 08             	shr    $0x8,%eax
  101ebb:	b2 f5                	mov    $0xf5,%dl
  101ebd:	ee                   	out    %al,(%dx)
  101ebe:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  101ec2:	c1 e8 08             	shr    $0x8,%eax
  101ec5:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  101eca:	83 e0 0f             	and    $0xf,%eax
  101ecd:	89 da                	mov    %ebx,%edx
  101ecf:	83 e1 01             	and    $0x1,%ecx
  101ed2:	c1 e1 04             	shl    $0x4,%ecx
  101ed5:	09 c1                	or     %eax,%ecx
  101ed7:	83 c9 e0             	or     $0xffffffe0,%ecx
  101eda:	89 c8                	mov    %ecx,%eax
  101edc:	ee                   	out    %al,(%dx)
  101edd:	f6 06 04             	testb  $0x4,(%esi)
  101ee0:	75 12                	jne    101ef4 <ide_start_request+0x74>
  101ee2:	b8 20 00 00 00       	mov    $0x20,%eax
  101ee7:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101eec:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  101eed:	83 c4 10             	add    $0x10,%esp
  101ef0:	5b                   	pop    %ebx
  101ef1:	5e                   	pop    %esi
  101ef2:	5d                   	pop    %ebp
  101ef3:	c3                   	ret    
  101ef4:	b8 30 00 00 00       	mov    $0x30,%eax
  101ef9:	b2 f7                	mov    $0xf7,%dl
  101efb:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  101efc:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101f01:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  101f04:	b9 80 00 00 00       	mov    $0x80,%ecx
  101f09:	fc                   	cld    
  101f0a:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  101f0c:	83 c4 10             	add    $0x10,%esp
  101f0f:	5b                   	pop    %ebx
  101f10:	5e                   	pop    %esi
  101f11:	5d                   	pop    %ebp
  101f12:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  101f13:	c7 04 24 f2 5f 10 00 	movl   $0x105ff2,(%esp)
  101f1a:	e8 81 e9 ff ff       	call   1008a0 <panic>
  101f1f:	90                   	nop    

00101f20 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  101f20:	55                   	push   %ebp
  101f21:	89 e5                	mov    %esp,%ebp
  101f23:	53                   	push   %ebx
  101f24:	83 ec 14             	sub    $0x14,%esp
  101f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  101f2a:	8b 03                	mov    (%ebx),%eax
  101f2c:	a8 01                	test   $0x1,%al
  101f2e:	0f 84 90 00 00 00    	je     101fc4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  101f34:	83 e0 06             	and    $0x6,%eax
  101f37:	83 f8 02             	cmp    $0x2,%eax
  101f3a:	0f 84 90 00 00 00    	je     101fd0 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  101f40:	8b 53 04             	mov    0x4(%ebx),%edx
  101f43:	85 d2                	test   %edx,%edx
  101f45:	74 0d                	je     101f54 <ide_rw+0x34>
  101f47:	a1 38 78 10 00       	mov    0x107838,%eax
  101f4c:	85 c0                	test   %eax,%eax
  101f4e:	0f 84 88 00 00 00    	je     101fdc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  101f54:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  101f5b:	e8 90 1e 00 00       	call   103df0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  101f60:	a1 34 78 10 00       	mov    0x107834,%eax
  101f65:	ba 34 78 10 00       	mov    $0x107834,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  101f6a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  101f71:	85 c0                	test   %eax,%eax
  101f73:	74 0a                	je     101f7f <ide_rw+0x5f>
  101f75:	8d 50 14             	lea    0x14(%eax),%edx
  101f78:	8b 40 14             	mov    0x14(%eax),%eax
  101f7b:	85 c0                	test   %eax,%eax
  101f7d:	75 f6                	jne    101f75 <ide_rw+0x55>
    ;
  *pp = b;
  101f7f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  101f81:	39 1d 34 78 10 00    	cmp    %ebx,0x107834
  101f87:	75 17                	jne    101fa0 <ide_rw+0x80>
  101f89:	eb 30                	jmp    101fbb <ide_rw+0x9b>
  101f8b:	90                   	nop    
  101f8c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  101f90:	c7 44 24 04 00 78 10 	movl   $0x107800,0x4(%esp)
  101f97:	00 
  101f98:	89 1c 24             	mov    %ebx,(%esp)
  101f9b:	e8 20 14 00 00       	call   1033c0 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  101fa0:	8b 03                	mov    (%ebx),%eax
  101fa2:	83 e0 06             	and    $0x6,%eax
  101fa5:	83 f8 02             	cmp    $0x2,%eax
  101fa8:	75 e6                	jne    101f90 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  101faa:	c7 45 08 00 78 10 00 	movl   $0x107800,0x8(%ebp)
}
  101fb1:	83 c4 14             	add    $0x14,%esp
  101fb4:	5b                   	pop    %ebx
  101fb5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  101fb6:	e9 f5 1d 00 00       	jmp    103db0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  101fbb:	89 d8                	mov    %ebx,%eax
  101fbd:	e8 be fe ff ff       	call   101e80 <ide_start_request>
  101fc2:	eb dc                	jmp    101fa0 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  101fc4:	c7 04 24 04 60 10 00 	movl   $0x106004,(%esp)
  101fcb:	e8 d0 e8 ff ff       	call   1008a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  101fd0:	c7 04 24 19 60 10 00 	movl   $0x106019,(%esp)
  101fd7:	e8 c4 e8 ff ff       	call   1008a0 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  101fdc:	c7 04 24 2f 60 10 00 	movl   $0x10602f,(%esp)
  101fe3:	e8 b8 e8 ff ff       	call   1008a0 <panic>
  101fe8:	90                   	nop    
  101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101ff0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  101ff0:	55                   	push   %ebp
  101ff1:	89 e5                	mov    %esp,%ebp
  101ff3:	57                   	push   %edi
  101ff4:	53                   	push   %ebx
  101ff5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  101ff8:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  101fff:	e8 ec 1d 00 00       	call   103df0 <acquire>
  if((b = ide_queue) == 0){
  102004:	8b 1d 34 78 10 00    	mov    0x107834,%ebx
  10200a:	85 db                	test   %ebx,%ebx
  10200c:	74 28                	je     102036 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  10200e:	f6 03 04             	testb  $0x4,(%ebx)
  102011:	74 3d                	je     102050 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  102013:	8b 03                	mov    (%ebx),%eax
  102015:	83 c8 02             	or     $0x2,%eax
  102018:	83 e0 fb             	and    $0xfffffffb,%eax
  10201b:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  10201d:	89 1c 24             	mov    %ebx,(%esp)
  102020:	e8 6b 11 00 00       	call   103190 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102025:	8b 43 14             	mov    0x14(%ebx),%eax
  102028:	85 c0                	test   %eax,%eax
  10202a:	a3 34 78 10 00       	mov    %eax,0x107834
  10202f:	74 05                	je     102036 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102031:	e8 4a fe ff ff       	call   101e80 <ide_start_request>

  release(&ide_lock);
  102036:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10203d:	e8 6e 1d 00 00       	call   103db0 <release>
}
  102042:	83 c4 10             	add    $0x10,%esp
  102045:	5b                   	pop    %ebx
  102046:	5f                   	pop    %edi
  102047:	5d                   	pop    %ebp
  102048:	c3                   	ret    
  102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  102050:	b8 01 00 00 00       	mov    $0x1,%eax
  102055:	e8 f6 fd ff ff       	call   101e50 <ide_wait_ready>
  10205a:	85 c0                	test   %eax,%eax
  10205c:	78 b5                	js     102013 <ide_intr+0x23>
  10205e:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102061:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102066:	b9 80 00 00 00       	mov    $0x80,%ecx
  10206b:	fc                   	cld    
  10206c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10206e:	eb a3                	jmp    102013 <ide_intr+0x23>

00102070 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102070:	55                   	push   %ebp
  102071:	89 e5                	mov    %esp,%ebp
  102073:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  102076:	c7 44 24 04 46 60 10 	movl   $0x106046,0x4(%esp)
  10207d:	00 
  10207e:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  102085:	e8 a6 1b 00 00       	call   103c30 <initlock>
  pic_enable(IRQ_IDE);
  10208a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102091:	e8 6a 0b 00 00       	call   102c00 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102096:	a1 20 b1 10 00       	mov    0x10b120,%eax
  10209b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1020a2:	83 e8 01             	sub    $0x1,%eax
  1020a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1020a9:	e8 62 00 00 00       	call   102110 <ioapic_enable>
  ide_wait_ready(0);
  1020ae:	31 c0                	xor    %eax,%eax
  1020b0:	e8 9b fd ff ff       	call   101e50 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1020b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1020ba:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1020bf:	ee                   	out    %al,(%dx)
  1020c0:	31 c9                	xor    %ecx,%ecx
  1020c2:	eb 0b                	jmp    1020cf <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1020c4:	83 c1 01             	add    $0x1,%ecx
  1020c7:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1020cd:	74 14                	je     1020e3 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1020cf:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1020d4:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1020d5:	84 c0                	test   %al,%al
  1020d7:	74 eb                	je     1020c4 <ide_init+0x54>
      disk_1_present = 1;
  1020d9:	c7 05 38 78 10 00 01 	movl   $0x1,0x107838
  1020e0:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1020e3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1020e8:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1020ed:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1020ee:	c9                   	leave  
  1020ef:	c3                   	ret    

001020f0 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1020f0:	8b 15 54 aa 10 00    	mov    0x10aa54,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  1020f6:	55                   	push   %ebp
  1020f7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1020f9:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  1020fb:	8b 42 10             	mov    0x10(%edx),%eax
}
  1020fe:	5d                   	pop    %ebp
  1020ff:	c3                   	ret    

00102100 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102100:	8b 0d 54 aa 10 00    	mov    0x10aa54,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  102106:	55                   	push   %ebp
  102107:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  102109:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  10210b:	89 51 10             	mov    %edx,0x10(%ecx)
}
  10210e:	5d                   	pop    %ebp
  10210f:	c3                   	ret    

00102110 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102110:	55                   	push   %ebp
  102111:	89 e5                	mov    %esp,%ebp
  102113:	83 ec 08             	sub    $0x8,%esp
  102116:	89 1c 24             	mov    %ebx,(%esp)
  102119:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  10211d:	8b 15 a0 aa 10 00    	mov    0x10aaa0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102123:	8b 45 08             	mov    0x8(%ebp),%eax
  102126:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  102129:	85 d2                	test   %edx,%edx
  10212b:	75 0b                	jne    102138 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10212d:	8b 1c 24             	mov    (%esp),%ebx
  102130:	8b 74 24 04          	mov    0x4(%esp),%esi
  102134:	89 ec                	mov    %ebp,%esp
  102136:	5d                   	pop    %ebp
  102137:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102138:	8d 34 00             	lea    (%eax,%eax,1),%esi
  10213b:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  10213e:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102141:	8d 46 10             	lea    0x10(%esi),%eax
  102144:	e8 b7 ff ff ff       	call   102100 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102149:	8d 46 11             	lea    0x11(%esi),%eax
  10214c:	89 da                	mov    %ebx,%edx
}
  10214e:	8b 74 24 04          	mov    0x4(%esp),%esi
  102152:	8b 1c 24             	mov    (%esp),%ebx
  102155:	89 ec                	mov    %ebp,%esp
  102157:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102158:	eb a6                	jmp    102100 <ioapic_write>
  10215a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102160 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102160:	55                   	push   %ebp
  102161:	89 e5                	mov    %esp,%ebp
  102163:	57                   	push   %edi
  102164:	56                   	push   %esi
  102165:	53                   	push   %ebx
  102166:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  102169:	8b 0d a0 aa 10 00    	mov    0x10aaa0,%ecx
  10216f:	85 c9                	test   %ecx,%ecx
  102171:	75 0d                	jne    102180 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  102173:	83 c4 0c             	add    $0xc,%esp
  102176:	5b                   	pop    %ebx
  102177:	5e                   	pop    %esi
  102178:	5f                   	pop    %edi
  102179:	5d                   	pop    %ebp
  10217a:	c3                   	ret    
  10217b:	90                   	nop    
  10217c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102180:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102185:	c7 05 54 aa 10 00 00 	movl   $0xfec00000,0x10aa54
  10218c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10218f:	e8 5c ff ff ff       	call   1020f0 <ioapic_read>
  102194:	c1 e8 10             	shr    $0x10,%eax
  102197:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10219a:	31 c0                	xor    %eax,%eax
  10219c:	e8 4f ff ff ff       	call   1020f0 <ioapic_read>
  if(id != ioapic_id)
  1021a1:	0f b6 15 a4 aa 10 00 	movzbl 0x10aaa4,%edx
  1021a8:	c1 e8 18             	shr    $0x18,%eax
  1021ab:	39 c2                	cmp    %eax,%edx
  1021ad:	74 0c                	je     1021bb <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1021af:	c7 04 24 4c 60 10 00 	movl   $0x10604c,(%esp)
  1021b6:	e8 45 e5 ff ff       	call   100700 <cprintf>
  1021bb:	31 f6                	xor    %esi,%esi
  1021bd:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1021c2:	8d 56 20             	lea    0x20(%esi),%edx
  1021c5:	89 d8                	mov    %ebx,%eax
  1021c7:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1021cd:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1021d0:	e8 2b ff ff ff       	call   102100 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  1021d5:	8d 43 01             	lea    0x1(%ebx),%eax
  1021d8:	31 d2                	xor    %edx,%edx
  1021da:	e8 21 ff ff ff       	call   102100 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1021df:	83 c3 02             	add    $0x2,%ebx
  1021e2:	39 f7                	cmp    %esi,%edi
  1021e4:	7d dc                	jge    1021c2 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1021e6:	83 c4 0c             	add    $0xc,%esp
  1021e9:	5b                   	pop    %ebx
  1021ea:	5e                   	pop    %esi
  1021eb:	5f                   	pop    %edi
  1021ec:	5d                   	pop    %ebp
  1021ed:	c3                   	ret    
  1021ee:	90                   	nop    
  1021ef:	90                   	nop    

001021f0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1021f0:	55                   	push   %ebp
  1021f1:	89 e5                	mov    %esp,%ebp
  1021f3:	56                   	push   %esi
  1021f4:	53                   	push   %ebx
  1021f5:	83 ec 10             	sub    $0x10,%esp
  1021f8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n <= 7)
  1021fb:	83 fe 07             	cmp    $0x7,%esi
  1021fe:	0f 8e 90 00 00 00    	jle    102294 <kalloc+0xa4>
    panic("kalloc must alloc at least 8bytes");

  acquire(&kalloc_lock);
  102204:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10220b:	e8 e0 1b 00 00       	call   103df0 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102210:	8b 1d 94 aa 10 00    	mov    0x10aa94,%ebx
  102216:	85 db                	test   %ebx,%ebx
  102218:	74 3e                	je     102258 <kalloc+0x68>
    if(r->len == n){
  10221a:	8b 43 04             	mov    0x4(%ebx),%eax
  10221d:	ba 94 aa 10 00       	mov    $0x10aa94,%edx
  102222:	39 f0                	cmp    %esi,%eax
  102224:	75 11                	jne    102237 <kalloc+0x47>
  102226:	eb 53                	jmp    10227b <kalloc+0x8b>

  if(n <= 7)
    panic("kalloc must alloc at least 8bytes");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102228:	89 da                	mov    %ebx,%edx
  10222a:	8b 1b                	mov    (%ebx),%ebx
  10222c:	85 db                	test   %ebx,%ebx
  10222e:	74 28                	je     102258 <kalloc+0x68>
    if(r->len == n){
  102230:	8b 43 04             	mov    0x4(%ebx),%eax
  102233:	39 f0                	cmp    %esi,%eax
  102235:	74 44                	je     10227b <kalloc+0x8b>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102237:	39 c6                	cmp    %eax,%esi
  102239:	7d ed                	jge    102228 <kalloc+0x38>
      r->len -= n;
  10223b:	29 f0                	sub    %esi,%eax
  10223d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102240:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  102243:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10224a:	e8 61 1b 00 00       	call   103db0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10224f:	83 c4 10             	add    $0x10,%esp
  102252:	89 d8                	mov    %ebx,%eax
  102254:	5b                   	pop    %ebx
  102255:	5e                   	pop    %esi
  102256:	5d                   	pop    %ebp
  102257:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102258:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)

  cprintf("kalloc: out of memory\n");
  10225f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102261:	e8 4a 1b 00 00       	call   103db0 <release>

  cprintf("kalloc: out of memory\n");
  102266:	c7 04 24 a2 60 10 00 	movl   $0x1060a2,(%esp)
  10226d:	e8 8e e4 ff ff       	call   100700 <cprintf>
  return 0;
}
  102272:	83 c4 10             	add    $0x10,%esp
  102275:	89 d8                	mov    %ebx,%eax
  102277:	5b                   	pop    %ebx
  102278:	5e                   	pop    %esi
  102279:	5d                   	pop    %ebp
  10227a:	c3                   	ret    
    panic("kalloc must alloc at least 8bytes");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10227b:	8b 03                	mov    (%ebx),%eax
  10227d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10227f:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  102286:	e8 25 1b 00 00       	call   103db0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10228b:	83 c4 10             	add    $0x10,%esp
  10228e:	89 d8                	mov    %ebx,%eax
  102290:	5b                   	pop    %ebx
  102291:	5e                   	pop    %esi
  102292:	5d                   	pop    %ebp
  102293:	c3                   	ret    
{
  char *p;
  struct run *r, **rp;

  if(n <= 7)
    panic("kalloc must alloc at least 8bytes");
  102294:	c7 04 24 80 60 10 00 	movl   $0x106080,(%esp)
  10229b:	e8 00 e6 ff ff       	call   1008a0 <panic>

001022a0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1022a0:	55                   	push   %ebp
  1022a1:	89 e5                	mov    %esp,%ebp
  1022a3:	57                   	push   %edi
  1022a4:	56                   	push   %esi
  1022a5:	53                   	push   %ebx
  1022a6:	83 ec 1c             	sub    $0x1c,%esp
  1022a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1022ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 7)
  1022af:	83 ff 07             	cmp    $0x7,%edi
  1022b2:	0f 8e ca 00 00 00    	jle    102382 <kfree+0xe2>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1022b8:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1022bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1022c3:	00 
  1022c4:	89 1c 24             	mov    %ebx,(%esp)
  1022c7:	e8 84 1b 00 00       	call   103e50 <memset>

  acquire(&kalloc_lock);
  1022cc:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1022d3:	e8 18 1b 00 00       	call   103df0 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1022d8:	8b 15 94 aa 10 00    	mov    0x10aa94,%edx
  1022de:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  1022e5:	85 d2                	test   %edx,%edx
  1022e7:	74 72                	je     10235b <kfree+0xbb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1022e9:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1022ec:	39 d6                	cmp    %edx,%esi
  1022ee:	72 6b                	jb     10235b <kfree+0xbb>
    rend = (struct run*)((char*)r + r->len);
  1022f0:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1022f3:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1022f5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  1022f8:	76 5b                	jbe    102355 <kfree+0xb5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1022fa:	39 d6                	cmp    %edx,%esi
  1022fc:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102303:	74 2f                	je     102334 <kfree+0x94>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102305:	39 d9                	cmp    %ebx,%ecx
  102307:	74 5e                	je     102367 <kfree+0xc7>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102309:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10230c:	8b 12                	mov    (%edx),%edx
  10230e:	85 d2                	test   %edx,%edx
  102310:	74 49                	je     10235b <kfree+0xbb>
  102312:	39 d6                	cmp    %edx,%esi
  102314:	72 45                	jb     10235b <kfree+0xbb>
    rend = (struct run*)((char*)r + r->len);
  102316:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102319:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  10231b:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  10231e:	77 10                	ja     102330 <kfree+0x90>
  102320:	39 cb                	cmp    %ecx,%ebx
  102322:	73 0c                	jae    102330 <kfree+0x90>
      panic("freeing free page");
  102324:	c7 04 24 bf 60 10 00 	movl   $0x1060bf,(%esp)
  10232b:	e8 70 e5 ff ff       	call   1008a0 <panic>
    if(pend == r){  // p next to r: replace r with p
  102330:	39 d6                	cmp    %edx,%esi
  102332:	75 d1                	jne    102305 <kfree+0x65>
      p->len = len + r->len;
  102334:	01 f8                	add    %edi,%eax
  102336:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  102339:	8b 06                	mov    (%esi),%eax
  10233b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102340:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102342:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
}
  102349:	83 c4 1c             	add    $0x1c,%esp
  10234c:	5b                   	pop    %ebx
  10234d:	5e                   	pop    %esi
  10234e:	5f                   	pop    %edi
  10234f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102350:	e9 5b 1a 00 00       	jmp    103db0 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102355:	39 cb                	cmp    %ecx,%ebx
  102357:	72 cb                	jb     102324 <kfree+0x84>
  102359:	eb 9f                	jmp    1022fa <kfree+0x5a>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10235e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102360:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  102363:	89 18                	mov    %ebx,(%eax)
  102365:	eb db                	jmp    102342 <kfree+0xa2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102367:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102369:	01 f8                	add    %edi,%eax
  10236b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10236e:	85 c9                	test   %ecx,%ecx
  102370:	74 d0                	je     102342 <kfree+0xa2>
  102372:	39 ce                	cmp    %ecx,%esi
  102374:	75 cc                	jne    102342 <kfree+0xa2>
        r->len += r->next->len;
  102376:	03 46 04             	add    0x4(%esi),%eax
  102379:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  10237c:	8b 06                	mov    (%esi),%eax
  10237e:	89 02                	mov    %eax,(%edx)
  102380:	eb c0                	jmp    102342 <kfree+0xa2>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 7)
    panic("kfree");
  102382:	c7 04 24 b9 60 10 00 	movl   $0x1060b9,(%esp)
  102389:	e8 12 e5 ff ff       	call   1008a0 <panic>
  10238e:	66 90                	xchg   %ax,%ax

00102390 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102390:	55                   	push   %ebp
  102391:	89 e5                	mov    %esp,%ebp
  102393:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  102394:	bb c4 ef 10 00       	mov    $0x10efc4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102399:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  10239c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1023a2:	c7 44 24 04 d1 60 10 	movl   $0x1060d1,0x4(%esp)
  1023a9:	00 
  1023aa:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1023b1:	e8 7a 18 00 00       	call   103c30 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1023b6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1023bd:	00 
  1023be:	c7 04 24 d8 60 10 00 	movl   $0x1060d8,(%esp)
  1023c5:	e8 36 e3 ff ff       	call   100700 <cprintf>
  kfree(start, mem * PAGE);
  1023ca:	89 1c 24             	mov    %ebx,(%esp)
  1023cd:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1023d4:	00 
  1023d5:	e8 c6 fe ff ff       	call   1022a0 <kfree>
}
  1023da:	83 c4 14             	add    $0x14,%esp
  1023dd:	5b                   	pop    %ebx
  1023de:	5d                   	pop    %ebp
  1023df:	c3                   	ret    

001023e0 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  1023e0:	55                   	push   %ebp
  1023e1:	89 e5                	mov    %esp,%ebp
  1023e3:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  1023e6:	c7 04 24 00 24 10 00 	movl   $0x102400,(%esp)
  1023ed:	e8 de e0 ff ff       	call   1004d0 <console_intr>
}
  1023f2:	c9                   	leave  
  1023f3:	c3                   	ret    
  1023f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1023fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102400 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102400:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102401:	ba 64 00 00 00       	mov    $0x64,%edx
  102406:	89 e5                	mov    %esp,%ebp
  102408:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  102409:	a8 01                	test   $0x1,%al
  10240b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102410:	74 3e                	je     102450 <kbd_getc+0x50>
  102412:	ba 60 00 00 00       	mov    $0x60,%edx
  102417:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  102418:	3c e0                	cmp    $0xe0,%al
  10241a:	0f 84 84 00 00 00    	je     1024a4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  102420:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102423:	84 c9                	test   %cl,%cl
  102425:	79 2d                	jns    102454 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102427:	8b 15 3c 78 10 00    	mov    0x10783c,%edx
  10242d:	f6 c2 40             	test   $0x40,%dl
  102430:	75 03                	jne    102435 <kbd_getc+0x35>
  102432:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  102435:	0f b6 81 00 61 10 00 	movzbl 0x106100(%ecx),%eax
  10243c:	83 c8 40             	or     $0x40,%eax
  10243f:	0f b6 c0             	movzbl %al,%eax
  102442:	f7 d0                	not    %eax
  102444:	21 d0                	and    %edx,%eax
  102446:	31 d2                	xor    %edx,%edx
  102448:	a3 3c 78 10 00       	mov    %eax,0x10783c
  10244d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102450:	5d                   	pop    %ebp
  102451:	89 d0                	mov    %edx,%eax
  102453:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102454:	a1 3c 78 10 00       	mov    0x10783c,%eax
  102459:	a8 40                	test   $0x40,%al
  10245b:	74 0b                	je     102468 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10245d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102460:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  102463:	a3 3c 78 10 00       	mov    %eax,0x10783c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102468:	0f b6 91 00 62 10 00 	movzbl 0x106200(%ecx),%edx
  10246f:	0f b6 81 00 61 10 00 	movzbl 0x106100(%ecx),%eax
  102476:	0b 05 3c 78 10 00    	or     0x10783c,%eax
  10247c:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  10247e:	89 c2                	mov    %eax,%edx
  102480:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  102483:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  102485:	8b 14 95 00 63 10 00 	mov    0x106300(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  10248c:	a3 3c 78 10 00       	mov    %eax,0x10783c
  c = charcode[shift & (CTL | SHIFT)][data];
  102491:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  102495:	74 b9                	je     102450 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  102497:	8d 42 9f             	lea    -0x61(%edx),%eax
  10249a:	83 f8 19             	cmp    $0x19,%eax
  10249d:	77 12                	ja     1024b1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  10249f:	83 ea 20             	sub    $0x20,%edx
  1024a2:	eb ac                	jmp    102450 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1024a4:	83 0d 3c 78 10 00 40 	orl    $0x40,0x10783c
  1024ab:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1024ad:	5d                   	pop    %ebp
  1024ae:	89 d0                	mov    %edx,%eax
  1024b0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1024b1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1024b4:	83 f8 19             	cmp    $0x19,%eax
  1024b7:	77 97                	ja     102450 <kbd_getc+0x50>
      c += 'a' - 'A';
  1024b9:	83 c2 20             	add    $0x20,%edx
  1024bc:	eb 92                	jmp    102450 <kbd_getc+0x50>
  1024be:	90                   	nop    
  1024bf:	90                   	nop    

001024c0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1024c0:	8b 0d 98 aa 10 00    	mov    0x10aa98,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1024c6:	55                   	push   %ebp
  1024c7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1024c9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1024cc:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1024ce:	8b 41 20             	mov    0x20(%ecx),%eax
}
  1024d1:	5d                   	pop    %ebp
  1024d2:	c3                   	ret    
  1024d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001024e0 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  1024e0:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1024e5:	55                   	push   %ebp
  1024e6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1024e8:	85 c0                	test   %eax,%eax
  1024ea:	0f 84 ea 00 00 00    	je     1025da <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  1024f0:	ba 3f 01 00 00       	mov    $0x13f,%edx
  1024f5:	b8 3c 00 00 00       	mov    $0x3c,%eax
  1024fa:	e8 c1 ff ff ff       	call   1024c0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  1024ff:	ba 0b 00 00 00       	mov    $0xb,%edx
  102504:	b8 f8 00 00 00       	mov    $0xf8,%eax
  102509:	e8 b2 ff ff ff       	call   1024c0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10250e:	ba 20 00 02 00       	mov    $0x20020,%edx
  102513:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102518:	e8 a3 ff ff ff       	call   1024c0 <lapicw>
  lapicw(TICR, 10000000); 
  10251d:	ba 80 96 98 00       	mov    $0x989680,%edx
  102522:	b8 e0 00 00 00       	mov    $0xe0,%eax
  102527:	e8 94 ff ff ff       	call   1024c0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10252c:	ba 00 00 01 00       	mov    $0x10000,%edx
  102531:	b8 d4 00 00 00       	mov    $0xd4,%eax
  102536:	e8 85 ff ff ff       	call   1024c0 <lapicw>
  lapicw(LINT1, MASKED);
  10253b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  102540:	ba 00 00 01 00       	mov    $0x10000,%edx
  102545:	e8 76 ff ff ff       	call   1024c0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10254a:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  10254f:	83 c0 30             	add    $0x30,%eax
  102552:	8b 00                	mov    (%eax),%eax
  102554:	c1 e8 10             	shr    $0x10,%eax
  102557:	3c 03                	cmp    $0x3,%al
  102559:	77 6e                	ja     1025c9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10255b:	ba 33 00 00 00       	mov    $0x33,%edx
  102560:	b8 dc 00 00 00       	mov    $0xdc,%eax
  102565:	e8 56 ff ff ff       	call   1024c0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10256a:	31 d2                	xor    %edx,%edx
  10256c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  102571:	e8 4a ff ff ff       	call   1024c0 <lapicw>
  lapicw(ESR, 0);
  102576:	31 d2                	xor    %edx,%edx
  102578:	b8 a0 00 00 00       	mov    $0xa0,%eax
  10257d:	e8 3e ff ff ff       	call   1024c0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  102582:	31 d2                	xor    %edx,%edx
  102584:	b8 2c 00 00 00       	mov    $0x2c,%eax
  102589:	e8 32 ff ff ff       	call   1024c0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  10258e:	31 d2                	xor    %edx,%edx
  102590:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102595:	e8 26 ff ff ff       	call   1024c0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  10259a:	ba 00 85 08 00       	mov    $0x88500,%edx
  10259f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1025a4:	e8 17 ff ff ff       	call   1024c0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1025a9:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1025af:	81 c2 00 03 00 00    	add    $0x300,%edx
  1025b5:	8b 02                	mov    (%edx),%eax
  1025b7:	f6 c4 10             	test   $0x10,%ah
  1025ba:	75 f9                	jne    1025b5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1025bc:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1025bd:	31 d2                	xor    %edx,%edx
  1025bf:	b8 20 00 00 00       	mov    $0x20,%eax
  1025c4:	e9 f7 fe ff ff       	jmp    1024c0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1025c9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1025ce:	b8 d0 00 00 00       	mov    $0xd0,%eax
  1025d3:	e8 e8 fe ff ff       	call   1024c0 <lapicw>
  1025d8:	eb 81                	jmp    10255b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1025da:	5d                   	pop    %ebp
  1025db:	c3                   	ret    
  1025dc:	8d 74 26 00          	lea    0x0(%esi),%esi

001025e0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1025e0:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1025e6:	55                   	push   %ebp
  1025e7:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1025e9:	85 d2                	test   %edx,%edx
  1025eb:	74 13                	je     102600 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  1025ed:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  1025ee:	31 d2                	xor    %edx,%edx
  1025f0:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1025f5:	e9 c6 fe ff ff       	jmp    1024c0 <lapicw>
  1025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  102600:	5d                   	pop    %ebp
  102601:	c3                   	ret    
  102602:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102610 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102610:	55                   	push   %ebp
  volatile int j = 0;
  102611:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102613:	89 e5                	mov    %esp,%ebp
  102615:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  102618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10261f:	eb 14                	jmp    102635 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10262b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102630:	7e 0e                	jle    102640 <microdelay+0x30>
  102632:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102635:	85 d2                	test   %edx,%edx
  102637:	7f e8                	jg     102621 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  102639:	c9                   	leave  
  10263a:	c3                   	ret    
  10263b:	90                   	nop    
  10263c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102643:	83 c0 01             	add    $0x1,%eax
  102646:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102649:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10264c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102651:	7f df                	jg     102632 <microdelay+0x22>
  102653:	eb eb                	jmp    102640 <microdelay+0x30>
  102655:	8d 74 26 00          	lea    0x0(%esi),%esi
  102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102660 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102660:	55                   	push   %ebp
  102661:	89 e5                	mov    %esp,%ebp
  102663:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102666:	9c                   	pushf  
  102667:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102668:	f6 c4 02             	test   $0x2,%ah
  10266b:	74 12                	je     10267f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10266d:	a1 40 78 10 00       	mov    0x107840,%eax
  102672:	83 c0 01             	add    $0x1,%eax
  102675:	a3 40 78 10 00       	mov    %eax,0x107840
  10267a:	83 e8 01             	sub    $0x1,%eax
  10267d:	74 14                	je     102693 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10267f:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  102685:	31 c0                	xor    %eax,%eax
  102687:	85 d2                	test   %edx,%edx
  102689:	74 06                	je     102691 <cpu+0x31>
    return lapic[ID]>>24;
  10268b:	8b 42 20             	mov    0x20(%edx),%eax
  10268e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102691:	c9                   	leave  
  102692:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  102693:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102695:	8b 40 04             	mov    0x4(%eax),%eax
  102698:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  10269f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1026a3:	e8 58 e0 ff ff       	call   100700 <cprintf>
  1026a8:	eb d5                	jmp    10267f <cpu+0x1f>
  1026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001026b0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1026b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1026b1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1026b6:	89 e5                	mov    %esp,%ebp
  1026b8:	ba 70 00 00 00       	mov    $0x70,%edx
  1026bd:	56                   	push   %esi
  1026be:	53                   	push   %ebx
  1026bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  1026c2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1026c6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1026c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1026cc:	b2 71                	mov    $0x71,%dl
  1026ce:	ee                   	out    %al,(%dx)
  1026cf:	c1 e3 18             	shl    $0x18,%ebx
  1026d2:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1026d7:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  1026d9:	c1 ee 04             	shr    $0x4,%esi
  1026dc:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1026e3:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  1026e6:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  1026ed:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1026ef:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1026f5:	e8 c6 fd ff ff       	call   1024c0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  1026fa:	ba 00 c5 00 00       	mov    $0xc500,%edx
  1026ff:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102704:	e8 b7 fd ff ff       	call   1024c0 <lapicw>
  microdelay(200);
  102709:	b8 c8 00 00 00       	mov    $0xc8,%eax
  10270e:	e8 fd fe ff ff       	call   102610 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  102713:	ba 00 85 00 00       	mov    $0x8500,%edx
  102718:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10271d:	e8 9e fd ff ff       	call   1024c0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102722:	b8 64 00 00 00       	mov    $0x64,%eax
  102727:	e8 e4 fe ff ff       	call   102610 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10272c:	89 da                	mov    %ebx,%edx
  10272e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102733:	e8 88 fd ff ff       	call   1024c0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102738:	89 f2                	mov    %esi,%edx
  10273a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10273f:	e8 7c fd ff ff       	call   1024c0 <lapicw>
    microdelay(200);
  102744:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102749:	e8 c2 fe ff ff       	call   102610 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10274e:	89 da                	mov    %ebx,%edx
  102750:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102755:	e8 66 fd ff ff       	call   1024c0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  10275a:	89 f2                	mov    %esi,%edx
  10275c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102761:	e8 5a fd ff ff       	call   1024c0 <lapicw>
    microdelay(200);
  102766:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  10276b:	5b                   	pop    %ebx
  10276c:	5e                   	pop    %esi
  10276d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  10276e:	e9 9d fe ff ff       	jmp    102610 <microdelay>
  102773:	90                   	nop    
  102774:	90                   	nop    
  102775:	90                   	nop    
  102776:	90                   	nop    
  102777:	90                   	nop    
  102778:	90                   	nop    
  102779:	90                   	nop    
  10277a:	90                   	nop    
  10277b:	90                   	nop    
  10277c:	90                   	nop    
  10277d:	90                   	nop    
  10277e:	90                   	nop    
  10277f:	90                   	nop    

00102780 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102780:	55                   	push   %ebp
  102781:	89 e5                	mov    %esp,%ebp
  102783:	53                   	push   %ebx
  102784:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102787:	e8 d4 fe ff ff       	call   102660 <cpu>
  10278c:	c7 04 24 3c 63 10 00 	movl   $0x10633c,(%esp)
  102793:	89 44 24 04          	mov    %eax,0x4(%esp)
  102797:	e8 64 df ff ff       	call   100700 <cprintf>
  idtinit();
  10279c:	e8 7f 29 00 00       	call   105120 <idtinit>
  if(cpu() != mp_bcpu())
  1027a1:	e8 ba fe ff ff       	call   102660 <cpu>
  1027a6:	89 c3                	mov    %eax,%ebx
  1027a8:	e8 c3 01 00 00       	call   102970 <mp_bcpu>
  1027ad:	39 c3                	cmp    %eax,%ebx
  1027af:	74 0d                	je     1027be <mpmain+0x3e>
    lapic_init(cpu());
  1027b1:	e8 aa fe ff ff       	call   102660 <cpu>
  1027b6:	89 04 24             	mov    %eax,(%esp)
  1027b9:	e8 22 fd ff ff       	call   1024e0 <lapic_init>
  setupsegs(0);
  1027be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1027c5:	e8 16 0e 00 00       	call   1035e0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  1027ca:	e8 91 fe ff ff       	call   102660 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1027cf:	ba 01 00 00 00       	mov    $0x1,%edx
  1027d4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1027da:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  1027e0:	89 d0                	mov    %edx,%eax
  1027e2:	f0 87 81 c0 aa 10 00 	lock xchg %eax,0x10aac0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  1027e9:	e8 72 fe ff ff       	call   102660 <cpu>
  1027ee:	c7 04 24 4b 63 10 00 	movl   $0x10634b,(%esp)
  1027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027f9:	e8 02 df ff ff       	call   100700 <cprintf>
  scheduler();
  1027fe:	e8 0d 10 00 00       	call   103810 <scheduler>
  102803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102810 <main>:


// Bootstrap processor starts running C code here.
int
main(void)
{
  102810:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102814:	83 e4 f0             	and    $0xfffffff0,%esp
  102817:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10281a:	b8 c4 df 10 00       	mov    $0x10dfc4,%eax
  10281f:	2d 8e 77 10 00       	sub    $0x10778e,%eax


// Bootstrap processor starts running C code here.
int
main(void)
{
  102824:	55                   	push   %ebp
  102825:	89 e5                	mov    %esp,%ebp
  102827:	53                   	push   %ebx
  102828:	51                   	push   %ecx
  102829:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10282c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102830:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102837:	00 
  102838:	c7 04 24 8e 77 10 00 	movl   $0x10778e,(%esp)
  10283f:	e8 0c 16 00 00       	call   103e50 <memset>

  mp_init(); // collect info about this machine
  102844:	e8 d7 01 00 00       	call   102a20 <mp_init>
  lapic_init(mp_bcpu());
  102849:	e8 22 01 00 00       	call   102970 <mp_bcpu>
  10284e:	89 04 24             	mov    %eax,(%esp)
  102851:	e8 8a fc ff ff       	call   1024e0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102856:	e8 05 fe ff ff       	call   102660 <cpu>
  10285b:	c7 04 24 5e 63 10 00 	movl   $0x10635e,(%esp)
  102862:	89 44 24 04          	mov    %eax,0x4(%esp)
  102866:	e8 95 de ff ff       	call   100700 <cprintf>

  pinit();         // process table
  10286b:	e8 a0 13 00 00       	call   103c10 <pinit>
  binit();         // buffer cache
  102870:	e8 1b d9 ff ff       	call   100190 <binit>
  pic_init();      // interrupt controller
  102875:	e8 a6 03 00 00       	call   102c20 <pic_init>
  ioapic_init();   // another interrupt controller
  10287a:	e8 e1 f8 ff ff       	call   102160 <ioapic_init>
  10287f:	90                   	nop    
  kinit();         // physical memory allocator
  102880:	e8 0b fb ff ff       	call   102390 <kinit>
  tvinit();        // trap vectors
  102885:	e8 06 2b 00 00       	call   105390 <tvinit>
  fileinit();      // file table
  10288a:	e8 a1 e7 ff ff       	call   101030 <fileinit>
  10288f:	90                   	nop    
  iinit();         // inode cache
  102890:	e8 9b f5 ff ff       	call   101e30 <iinit>
  console_init();  // I/O devices & their interrupts
  102895:	e8 56 d9 ff ff       	call   1001f0 <console_init>
  ide_init();      // disk
  10289a:	e8 d1 f7 ff ff       	call   102070 <ide_init>
  if(!ismp)
  10289f:	a1 a0 aa 10 00       	mov    0x10aaa0,%eax
  1028a4:	85 c0                	test   %eax,%eax
  1028a6:	0f 84 ac 00 00 00    	je     102958 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  1028ac:	e8 6f 12 00 00       	call   103b20 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  1028b1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  1028b8:	00 
  1028b9:	c7 44 24 04 34 77 10 	movl   $0x107734,0x4(%esp)
  1028c0:	00 
  1028c1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  1028c8:	e8 33 16 00 00       	call   103f00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  1028cd:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  1028d4:	00 00 00 
  1028d7:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  1028dc:	3d c0 aa 10 00       	cmp    $0x10aac0,%eax
  1028e1:	76 70                	jbe    102953 <main+0x143>
  1028e3:	bb c0 aa 10 00       	mov    $0x10aac0,%ebx
    if(c == cpus+cpu())  // We've started already.
  1028e8:	e8 73 fd ff ff       	call   102660 <cpu>
  1028ed:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1028f3:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  1028f8:	39 d8                	cmp    %ebx,%eax
  1028fa:	74 3e                	je     10293a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  1028fc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102903:	e8 e8 f8 ff ff       	call   1021f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102908:	c7 05 f8 6f 00 00 80 	movl   $0x102780,0x6ff8
  10290f:	27 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102912:	05 00 10 00 00       	add    $0x1000,%eax
  102917:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  10291c:	0f b6 03             	movzbl (%ebx),%eax
  10291f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102926:	00 
  102927:	89 04 24             	mov    %eax,(%esp)
  10292a:	e8 81 fd ff ff       	call   1026b0 <lapic_startap>
  10292f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102930:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102936:	85 c0                	test   %eax,%eax
  102938:	74 f6                	je     102930 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  10293a:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102941:	00 00 00 
  102944:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  10294a:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  10294f:	39 d8                	cmp    %ebx,%eax
  102951:	77 95                	ja     1028e8 <main+0xd8>
  userinit();      // first user process
  bootothers();    // start other processors
  
 // kalloctest();    //test kalloc(bytes)
  // Finish setting up this processor in mpmain.
  mpmain();
  102953:	e8 28 fe ff ff       	call   102780 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102958:	e8 63 27 00 00       	call   1050c0 <timer_init>
  10295d:	8d 76 00             	lea    0x0(%esi),%esi
  102960:	e9 47 ff ff ff       	jmp    1028ac <main+0x9c>
  102965:	90                   	nop    
  102966:	90                   	nop    
  102967:	90                   	nop    
  102968:	90                   	nop    
  102969:	90                   	nop    
  10296a:	90                   	nop    
  10296b:	90                   	nop    
  10296c:	90                   	nop    
  10296d:	90                   	nop    
  10296e:	90                   	nop    
  10296f:	90                   	nop    

00102970 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102970:	a1 44 78 10 00       	mov    0x107844,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102975:	55                   	push   %ebp
  102976:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102978:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102979:	2d c0 aa 10 00       	sub    $0x10aac0,%eax
  10297e:	c1 f8 02             	sar    $0x2,%eax
  102981:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  102987:	c3                   	ret    
  102988:	90                   	nop    
  102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102990 <sum>:

static uchar
sum(uchar *addr, int len)
{
  102990:	55                   	push   %ebp
  102991:	89 e5                	mov    %esp,%ebp
  102993:	56                   	push   %esi
  102994:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102996:	31 c0                	xor    %eax,%eax
  102998:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  10299a:	53                   	push   %ebx
  10299b:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  10299d:	7e 14                	jle    1029b3 <sum+0x23>
  10299f:	31 c9                	xor    %ecx,%ecx
  1029a1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  1029a3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029a7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  1029aa:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029ac:	39 d9                	cmp    %ebx,%ecx
  1029ae:	75 f3                	jne    1029a3 <sum+0x13>
  1029b0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  1029b3:	5b                   	pop    %ebx
  1029b4:	5e                   	pop    %esi
  1029b5:	5d                   	pop    %ebp
  1029b6:	c3                   	ret    
  1029b7:	89 f6                	mov    %esi,%esi
  1029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001029c0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  1029c0:	55                   	push   %ebp
  1029c1:	89 e5                	mov    %esp,%ebp
  1029c3:	56                   	push   %esi
  1029c4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  1029c5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  1029c8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  1029cb:	39 f0                	cmp    %esi,%eax
  1029cd:	73 40                	jae    102a0f <mp_search1+0x4f>
  1029cf:	89 c3                	mov    %eax,%ebx
  1029d1:	eb 07                	jmp    1029da <mp_search1+0x1a>
  1029d3:	83 c3 10             	add    $0x10,%ebx
  1029d6:	39 de                	cmp    %ebx,%esi
  1029d8:	76 35                	jbe    102a0f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1029da:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  1029e1:	00 
  1029e2:	c7 44 24 04 75 63 10 	movl   $0x106375,0x4(%esp)
  1029e9:	00 
  1029ea:	89 1c 24             	mov    %ebx,(%esp)
  1029ed:	e8 8e 14 00 00       	call   103e80 <memcmp>
  1029f2:	85 c0                	test   %eax,%eax
  1029f4:	75 dd                	jne    1029d3 <mp_search1+0x13>
  1029f6:	ba 10 00 00 00       	mov    $0x10,%edx
  1029fb:	89 d8                	mov    %ebx,%eax
  1029fd:	e8 8e ff ff ff       	call   102990 <sum>
  102a02:	84 c0                	test   %al,%al
  102a04:	75 cd                	jne    1029d3 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  102a06:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102a09:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102a0b:	5b                   	pop    %ebx
  102a0c:	5e                   	pop    %esi
  102a0d:	5d                   	pop    %ebp
  102a0e:	c3                   	ret    
  102a0f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a12:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102a14:	5b                   	pop    %ebx
  102a15:	5e                   	pop    %esi
  102a16:	5d                   	pop    %ebp
  102a17:	c3                   	ret    
  102a18:	90                   	nop    
  102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102a20 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102a20:	55                   	push   %ebp
  102a21:	89 e5                	mov    %esp,%ebp
  102a23:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102a26:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102a2d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  102a30:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102a33:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102a36:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102a39:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102a40:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102a45:	a3 44 78 10 00       	mov    %eax,0x107844
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102a4a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102a51:	c1 e1 08             	shl    $0x8,%ecx
  102a54:	09 c1                	or     %eax,%ecx
  102a56:	c1 e1 04             	shl    $0x4,%ecx
  102a59:	85 c9                	test   %ecx,%ecx
  102a5b:	74 53                	je     102ab0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  102a5d:	ba 00 04 00 00       	mov    $0x400,%edx
  102a62:	89 c8                	mov    %ecx,%eax
  102a64:	e8 57 ff ff ff       	call   1029c0 <mp_search1>
  102a69:	85 c0                	test   %eax,%eax
  102a6b:	89 c6                	mov    %eax,%esi
  102a6d:	74 6c                	je     102adb <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102a6f:	8b 5e 04             	mov    0x4(%esi),%ebx
  102a72:	85 db                	test   %ebx,%ebx
  102a74:	74 2a                	je     102aa0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102a76:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102a7d:	00 
  102a7e:	c7 44 24 04 7a 63 10 	movl   $0x10637a,0x4(%esp)
  102a85:	00 
  102a86:	89 1c 24             	mov    %ebx,(%esp)
  102a89:	e8 f2 13 00 00       	call   103e80 <memcmp>
  102a8e:	85 c0                	test   %eax,%eax
  102a90:	75 0e                	jne    102aa0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102a92:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102a96:	3c 01                	cmp    $0x1,%al
  102a98:	74 5c                	je     102af6 <mp_init+0xd6>
  102a9a:	3c 04                	cmp    $0x4,%al
  102a9c:	74 58                	je     102af6 <mp_init+0xd6>
  102a9e:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102aa0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102aa3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102aa6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102aa9:	89 ec                	mov    %ebp,%esp
  102aab:	5d                   	pop    %ebp
  102aac:	c3                   	ret    
  102aad:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102ab0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102ab7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102abe:	c1 e0 08             	shl    $0x8,%eax
  102ac1:	09 d0                	or     %edx,%eax
  102ac3:	ba 00 04 00 00       	mov    $0x400,%edx
  102ac8:	c1 e0 0a             	shl    $0xa,%eax
  102acb:	2d 00 04 00 00       	sub    $0x400,%eax
  102ad0:	e8 eb fe ff ff       	call   1029c0 <mp_search1>
  102ad5:	85 c0                	test   %eax,%eax
  102ad7:	89 c6                	mov    %eax,%esi
  102ad9:	75 94                	jne    102a6f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102adb:	ba 00 00 01 00       	mov    $0x10000,%edx
  102ae0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102ae5:	e8 d6 fe ff ff       	call   1029c0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102aea:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102aec:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102aee:	0f 85 7b ff ff ff    	jne    102a6f <mp_init+0x4f>
  102af4:	eb aa                	jmp    102aa0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102af6:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102afa:	89 d8                	mov    %ebx,%eax
  102afc:	e8 8f fe ff ff       	call   102990 <sum>
  102b01:	84 c0                	test   %al,%al
  102b03:	75 9b                	jne    102aa0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102b05:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b08:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102b0b:	c7 05 a0 aa 10 00 01 	movl   $0x1,0x10aaa0
  102b12:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102b15:	a3 98 aa 10 00       	mov    %eax,0x10aa98

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b1a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102b1e:	01 c3                	add    %eax,%ebx
  102b20:	39 da                	cmp    %ebx,%edx
  102b22:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102b25:	73 57                	jae    102b7e <mp_init+0x15e>
  102b27:	8b 3d 44 78 10 00    	mov    0x107844,%edi
  102b2d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  102b30:	0f b6 02             	movzbl (%edx),%eax
  102b33:	3c 04                	cmp    $0x4,%al
  102b35:	0f b6 c8             	movzbl %al,%ecx
  102b38:	76 26                	jbe    102b60 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102b3a:	89 3d 44 78 10 00    	mov    %edi,0x107844
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102b40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102b44:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102b4b:	e8 b0 db ff ff       	call   100700 <cprintf>
      panic("mp_init");
  102b50:	c7 04 24 7f 63 10 00 	movl   $0x10637f,(%esp)
  102b57:	e8 44 dd ff ff       	call   1008a0 <panic>
  102b5c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102b60:	ff 24 8d ac 63 10 00 	jmp    *0x1063ac(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102b67:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102b6b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102b6e:	a2 a4 aa 10 00       	mov    %al,0x10aaa4
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b73:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  102b76:	72 b8                	jb     102b30 <mp_init+0x110>
  102b78:	89 3d 44 78 10 00    	mov    %edi,0x107844
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102b7e:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102b82:	0f 84 18 ff ff ff    	je     102aa0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102b88:	b8 70 00 00 00       	mov    $0x70,%eax
  102b8d:	ba 22 00 00 00       	mov    $0x22,%edx
  102b92:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102b93:	b2 23                	mov    $0x23,%dl
  102b95:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102b96:	83 c8 01             	or     $0x1,%eax
  102b99:	ee                   	out    %al,(%dx)
  102b9a:	e9 01 ff ff ff       	jmp    102aa0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102b9f:	83 c2 08             	add    $0x8,%edx
  102ba2:	eb cf                	jmp    102b73 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102ba4:	8b 1d 20 b1 10 00    	mov    0x10b120,%ebx
  102baa:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102bae:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102bb4:	88 81 c0 aa 10 00    	mov    %al,0x10aac0(%ecx)
      if(proc->flags & MPBOOT)
  102bba:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102bbe:	74 06                	je     102bc6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  102bc0:	8d b9 c0 aa 10 00    	lea    0x10aac0(%ecx),%edi
      ncpu++;
  102bc6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  102bc9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102bcc:	a3 20 b1 10 00       	mov    %eax,0x10b120
  102bd1:	eb a0                	jmp    102b73 <mp_init+0x153>
  102bd3:	90                   	nop    
  102bd4:	90                   	nop    
  102bd5:	90                   	nop    
  102bd6:	90                   	nop    
  102bd7:	90                   	nop    
  102bd8:	90                   	nop    
  102bd9:	90                   	nop    
  102bda:	90                   	nop    
  102bdb:	90                   	nop    
  102bdc:	90                   	nop    
  102bdd:	90                   	nop    
  102bde:	90                   	nop    
  102bdf:	90                   	nop    

00102be0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  102be0:	55                   	push   %ebp
  102be1:	89 c1                	mov    %eax,%ecx
  102be3:	89 e5                	mov    %esp,%ebp
  102be5:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  102bea:	66 a3 00 73 10 00    	mov    %ax,0x107300
  102bf0:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  102bf1:	66 c1 e9 08          	shr    $0x8,%cx
  102bf5:	b2 a1                	mov    $0xa1,%dl
  102bf7:	89 c8                	mov    %ecx,%eax
  102bf9:	ee                   	out    %al,(%dx)
  102bfa:	5d                   	pop    %ebp
  102bfb:	c3                   	ret    
  102bfc:	8d 74 26 00          	lea    0x0(%esi),%esi

00102c00 <pic_enable>:

void
pic_enable(int irq)
{
  102c00:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102c01:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102c06:	89 e5                	mov    %esp,%ebp
  102c08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  102c0b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  102c0c:	d3 c0                	rol    %cl,%eax
  102c0e:	66 23 05 00 73 10 00 	and    0x107300,%ax
  102c15:	0f b7 c0             	movzwl %ax,%eax
  102c18:	eb c6                	jmp    102be0 <pic_setmask>
  102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102c20 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102c20:	55                   	push   %ebp
  102c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102c26:	89 e5                	mov    %esp,%ebp
  102c28:	83 ec 0c             	sub    $0xc,%esp
  102c2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102c2f:	be 21 00 00 00       	mov    $0x21,%esi
  102c34:	89 1c 24             	mov    %ebx,(%esp)
  102c37:	89 f2                	mov    %esi,%edx
  102c39:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102c3d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102c3e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  102c43:	89 ca                	mov    %ecx,%edx
  102c45:	ee                   	out    %al,(%dx)
  102c46:	bf 11 00 00 00       	mov    $0x11,%edi
  102c4b:	b2 20                	mov    $0x20,%dl
  102c4d:	89 f8                	mov    %edi,%eax
  102c4f:	ee                   	out    %al,(%dx)
  102c50:	b8 20 00 00 00       	mov    $0x20,%eax
  102c55:	89 f2                	mov    %esi,%edx
  102c57:	ee                   	out    %al,(%dx)
  102c58:	b8 04 00 00 00       	mov    $0x4,%eax
  102c5d:	ee                   	out    %al,(%dx)
  102c5e:	bb 03 00 00 00       	mov    $0x3,%ebx
  102c63:	89 d8                	mov    %ebx,%eax
  102c65:	ee                   	out    %al,(%dx)
  102c66:	be a0 00 00 00       	mov    $0xa0,%esi
  102c6b:	89 f8                	mov    %edi,%eax
  102c6d:	89 f2                	mov    %esi,%edx
  102c6f:	ee                   	out    %al,(%dx)
  102c70:	b8 28 00 00 00       	mov    $0x28,%eax
  102c75:	89 ca                	mov    %ecx,%edx
  102c77:	ee                   	out    %al,(%dx)
  102c78:	b8 02 00 00 00       	mov    $0x2,%eax
  102c7d:	ee                   	out    %al,(%dx)
  102c7e:	89 d8                	mov    %ebx,%eax
  102c80:	ee                   	out    %al,(%dx)
  102c81:	b9 68 00 00 00       	mov    $0x68,%ecx
  102c86:	b2 20                	mov    $0x20,%dl
  102c88:	89 c8                	mov    %ecx,%eax
  102c8a:	ee                   	out    %al,(%dx)
  102c8b:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102c90:	89 d8                	mov    %ebx,%eax
  102c92:	ee                   	out    %al,(%dx)
  102c93:	89 c8                	mov    %ecx,%eax
  102c95:	89 f2                	mov    %esi,%edx
  102c97:	ee                   	out    %al,(%dx)
  102c98:	89 d8                	mov    %ebx,%eax
  102c9a:	ee                   	out    %al,(%dx)
  102c9b:	0f b7 05 00 73 10 00 	movzwl 0x107300,%eax
  102ca2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102ca6:	74 18                	je     102cc0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  102ca8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102cab:	0f b7 c0             	movzwl %ax,%eax
}
  102cae:	8b 74 24 04          	mov    0x4(%esp),%esi
  102cb2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102cb6:	89 ec                	mov    %ebp,%esp
  102cb8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102cb9:	e9 22 ff ff ff       	jmp    102be0 <pic_setmask>
  102cbe:	66 90                	xchg   %ax,%ax
}
  102cc0:	8b 1c 24             	mov    (%esp),%ebx
  102cc3:	8b 74 24 04          	mov    0x4(%esp),%esi
  102cc7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102ccb:	89 ec                	mov    %ebp,%esp
  102ccd:	5d                   	pop    %ebp
  102cce:	c3                   	ret    
  102ccf:	90                   	nop    

00102cd0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102cd0:	55                   	push   %ebp
  102cd1:	89 e5                	mov    %esp,%ebp
  102cd3:	57                   	push   %edi
  102cd4:	56                   	push   %esi
  102cd5:	53                   	push   %ebx
  102cd6:	83 ec 0c             	sub    $0xc,%esp
  102cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102cdc:	8d 7b 10             	lea    0x10(%ebx),%edi
  102cdf:	89 3c 24             	mov    %edi,(%esp)
  102ce2:	e8 09 11 00 00       	call   103df0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102ce7:	8b 43 0c             	mov    0xc(%ebx),%eax
  102cea:	3b 43 08             	cmp    0x8(%ebx),%eax
  102ced:	75 4f                	jne    102d3e <piperead+0x6e>
  102cef:	8b 53 04             	mov    0x4(%ebx),%edx
  102cf2:	85 d2                	test   %edx,%edx
  102cf4:	74 48                	je     102d3e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102cf6:	8d 73 0c             	lea    0xc(%ebx),%esi
  102cf9:	eb 20                	jmp    102d1b <piperead+0x4b>
  102cfb:	90                   	nop    
  102cfc:	8d 74 26 00          	lea    0x0(%esi),%esi
  102d00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102d04:	89 34 24             	mov    %esi,(%esp)
  102d07:	e8 b4 06 00 00       	call   1033c0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102d0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  102d0f:	3b 43 08             	cmp    0x8(%ebx),%eax
  102d12:	75 2a                	jne    102d3e <piperead+0x6e>
  102d14:	8b 53 04             	mov    0x4(%ebx),%edx
  102d17:	85 d2                	test   %edx,%edx
  102d19:	74 23                	je     102d3e <piperead+0x6e>
    if(cp->killed){
  102d1b:	e8 a0 04 00 00       	call   1031c0 <curproc>
  102d20:	8b 40 1c             	mov    0x1c(%eax),%eax
  102d23:	85 c0                	test   %eax,%eax
  102d25:	74 d9                	je     102d00 <piperead+0x30>
      release(&p->lock);
  102d27:	89 3c 24             	mov    %edi,(%esp)
  102d2a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  102d2f:	e8 7c 10 00 00       	call   103db0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102d34:	83 c4 0c             	add    $0xc,%esp
  102d37:	89 f0                	mov    %esi,%eax
  102d39:	5b                   	pop    %ebx
  102d3a:	5e                   	pop    %esi
  102d3b:	5f                   	pop    %edi
  102d3c:	5d                   	pop    %ebp
  102d3d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102d41:	85 c9                	test   %ecx,%ecx
  102d43:	7e 4d                	jle    102d92 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  102d45:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  102d47:	89 c2                	mov    %eax,%edx
  102d49:	3b 43 08             	cmp    0x8(%ebx),%eax
  102d4c:	75 07                	jne    102d55 <piperead+0x85>
  102d4e:	eb 42                	jmp    102d92 <piperead+0xc2>
  102d50:	39 53 08             	cmp    %edx,0x8(%ebx)
  102d53:	74 20                	je     102d75 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102d55:	89 d0                	mov    %edx,%eax
  102d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102d5a:	83 c2 01             	add    $0x1,%edx
  102d5d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102d62:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102d67:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d6a:	83 c6 01             	add    $0x1,%esi
  102d6d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102d70:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d73:	75 db                	jne    102d50 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102d75:	8d 43 08             	lea    0x8(%ebx),%eax
  102d78:	89 04 24             	mov    %eax,(%esp)
  102d7b:	e8 10 04 00 00       	call   103190 <wakeup>
  release(&p->lock);
  102d80:	89 3c 24             	mov    %edi,(%esp)
  102d83:	e8 28 10 00 00       	call   103db0 <release>
  return i;
}
  102d88:	83 c4 0c             	add    $0xc,%esp
  102d8b:	89 f0                	mov    %esi,%eax
  102d8d:	5b                   	pop    %ebx
  102d8e:	5e                   	pop    %esi
  102d8f:	5f                   	pop    %edi
  102d90:	5d                   	pop    %ebp
  102d91:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d92:	31 f6                	xor    %esi,%esi
  102d94:	eb df                	jmp    102d75 <piperead+0xa5>
  102d96:	8d 76 00             	lea    0x0(%esi),%esi
  102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102da0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102da0:	55                   	push   %ebp
  102da1:	89 e5                	mov    %esp,%ebp
  102da3:	57                   	push   %edi
  102da4:	56                   	push   %esi
  102da5:	53                   	push   %ebx
  102da6:	83 ec 1c             	sub    $0x1c,%esp
  102da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102dac:	8d 73 10             	lea    0x10(%ebx),%esi
  102daf:	89 34 24             	mov    %esi,(%esp)
  102db2:	e8 39 10 00 00       	call   103df0 <acquire>
  for(i = 0; i < n; i++){
  102db7:	8b 45 10             	mov    0x10(%ebp),%eax
  102dba:	85 c0                	test   %eax,%eax
  102dbc:	0f 8e a8 00 00 00    	jle    102e6a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102dc2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  102dc5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102dc8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102dcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102dd2:	eb 29                	jmp    102dfd <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102dd4:	8b 03                	mov    (%ebx),%eax
  102dd6:	85 c0                	test   %eax,%eax
  102dd8:	74 76                	je     102e50 <pipewrite+0xb0>
  102dda:	e8 e1 03 00 00       	call   1031c0 <curproc>
  102ddf:	8b 48 1c             	mov    0x1c(%eax),%ecx
  102de2:	85 c9                	test   %ecx,%ecx
  102de4:	75 6a                	jne    102e50 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102de6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102de9:	89 14 24             	mov    %edx,(%esp)
  102dec:	e8 9f 03 00 00       	call   103190 <wakeup>
      sleep(&p->writep, &p->lock);
  102df1:	89 74 24 04          	mov    %esi,0x4(%esp)
  102df5:	89 3c 24             	mov    %edi,(%esp)
  102df8:	e8 c3 05 00 00       	call   1033c0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  102dfd:	8b 43 0c             	mov    0xc(%ebx),%eax
  102e00:	8b 4b 08             	mov    0x8(%ebx),%ecx
  102e03:	05 00 02 00 00       	add    $0x200,%eax
  102e08:	39 c1                	cmp    %eax,%ecx
  102e0a:	74 c8                	je     102dd4 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e0c:	89 c8                	mov    %ecx,%eax
  102e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e11:	25 ff 01 00 00       	and    $0x1ff,%eax
  102e16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  102e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e23:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e27:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e2a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e2d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102e31:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e34:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e37:	75 c4                	jne    102dfd <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  102e39:	8d 43 0c             	lea    0xc(%ebx),%eax
  102e3c:	89 04 24             	mov    %eax,(%esp)
  102e3f:	e8 4c 03 00 00       	call   103190 <wakeup>
  release(&p->lock);
  102e44:	89 34 24             	mov    %esi,(%esp)
  102e47:	e8 64 0f 00 00       	call   103db0 <release>
  102e4c:	eb 11                	jmp    102e5f <pipewrite+0xbf>
  102e4e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  102e50:	89 34 24             	mov    %esi,(%esp)
  102e53:	e8 58 0f 00 00       	call   103db0 <release>
  102e58:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  102e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e62:	83 c4 1c             	add    $0x1c,%esp
  102e65:	5b                   	pop    %ebx
  102e66:	5e                   	pop    %esi
  102e67:	5f                   	pop    %edi
  102e68:	5d                   	pop    %ebp
  102e69:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102e6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102e71:	eb c6                	jmp    102e39 <pipewrite+0x99>
  102e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102e80 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102e80:	55                   	push   %ebp
  102e81:	89 e5                	mov    %esp,%ebp
  102e83:	83 ec 18             	sub    $0x18,%esp
  102e86:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102e89:	8b 75 08             	mov    0x8(%ebp),%esi
  102e8c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102e8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  102e92:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  102e95:	8d 7e 10             	lea    0x10(%esi),%edi
  102e98:	89 3c 24             	mov    %edi,(%esp)
  102e9b:	e8 50 0f 00 00       	call   103df0 <acquire>
  if(writable){
  102ea0:	85 db                	test   %ebx,%ebx
  102ea2:	74 34                	je     102ed8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  102ea4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102ea7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  102eae:	89 04 24             	mov    %eax,(%esp)
  102eb1:	e8 da 02 00 00       	call   103190 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  102eb6:	89 3c 24             	mov    %edi,(%esp)
  102eb9:	e8 f2 0e 00 00       	call   103db0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  102ebe:	8b 06                	mov    (%esi),%eax
  102ec0:	85 c0                	test   %eax,%eax
  102ec2:	75 07                	jne    102ecb <pipeclose+0x4b>
  102ec4:	8b 46 04             	mov    0x4(%esi),%eax
  102ec7:	85 c0                	test   %eax,%eax
  102ec9:	74 25                	je     102ef0 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  102ecb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102ece:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102ed1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102ed4:	89 ec                	mov    %ebp,%esp
  102ed6:	5d                   	pop    %ebp
  102ed7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  102ed8:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  102edb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  102ee1:	89 04 24             	mov    %eax,(%esp)
  102ee4:	e8 a7 02 00 00       	call   103190 <wakeup>
  102ee9:	eb cb                	jmp    102eb6 <pipeclose+0x36>
  102eeb:	90                   	nop    
  102eec:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102ef0:	89 75 08             	mov    %esi,0x8(%ebp)
}
  102ef3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102ef6:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  102efd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102f00:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102f03:	89 ec                	mov    %ebp,%esp
  102f05:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102f06:	e9 95 f3 ff ff       	jmp    1022a0 <kfree>
  102f0b:	90                   	nop    
  102f0c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102f10 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  102f10:	55                   	push   %ebp
  102f11:	89 e5                	mov    %esp,%ebp
  102f13:	83 ec 18             	sub    $0x18,%esp
  102f16:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102f19:	8b 75 08             	mov    0x8(%ebp),%esi
  102f1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  102f1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  102f22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  102f25:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  102f2b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  102f31:	e8 9a df ff ff       	call   100ed0 <filealloc>
  102f36:	85 c0                	test   %eax,%eax
  102f38:	89 06                	mov    %eax,(%esi)
  102f3a:	0f 84 96 00 00 00    	je     102fd6 <pipealloc+0xc6>
  102f40:	e8 8b df ff ff       	call   100ed0 <filealloc>
  102f45:	85 c0                	test   %eax,%eax
  102f47:	89 07                	mov    %eax,(%edi)
  102f49:	74 75                	je     102fc0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  102f4b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102f52:	e8 99 f2 ff ff       	call   1021f0 <kalloc>
  102f57:	85 c0                	test   %eax,%eax
  102f59:	89 c3                	mov    %eax,%ebx
  102f5b:	74 63                	je     102fc0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  102f5d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  102f63:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  102f6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  102f71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  102f78:	8d 40 10             	lea    0x10(%eax),%eax
  102f7b:	89 04 24             	mov    %eax,(%esp)
  102f7e:	c7 44 24 04 c0 63 10 	movl   $0x1063c0,0x4(%esp)
  102f85:	00 
  102f86:	e8 a5 0c 00 00       	call   103c30 <initlock>
  (*f0)->type = FD_PIPE;
  102f8b:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  102f8d:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  102f8f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  102f93:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  102f99:	8b 06                	mov    (%esi),%eax
  102f9b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  102f9f:	8b 06                	mov    (%esi),%eax
  102fa1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  102fa4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  102fa6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  102faa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  102fb0:	8b 07                	mov    (%edi),%eax
  102fb2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  102fb6:	8b 07                	mov    (%edi),%eax
  102fb8:	89 58 0c             	mov    %ebx,0xc(%eax)
  102fbb:	eb 24                	jmp    102fe1 <pipealloc+0xd1>
  102fbd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  102fc0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  102fc2:	85 c0                	test   %eax,%eax
  102fc4:	74 10                	je     102fd6 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  102fc6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  102fcc:	8b 06                	mov    (%esi),%eax
  102fce:	89 04 24             	mov    %eax,(%esp)
  102fd1:	e8 8a df ff ff       	call   100f60 <fileclose>
  }
  if(*f1){
  102fd6:	8b 07                	mov    (%edi),%eax
  102fd8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102fdd:	85 c0                	test   %eax,%eax
  102fdf:	75 0f                	jne    102ff0 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  102fe1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102fe4:	89 d0                	mov    %edx,%eax
  102fe6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102fe9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102fec:	89 ec                	mov    %ebp,%esp
  102fee:	5d                   	pop    %ebp
  102fef:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  102ff0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  102ff6:	89 04 24             	mov    %eax,(%esp)
  102ff9:	e8 62 df ff ff       	call   100f60 <fileclose>
  102ffe:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103003:	eb dc                	jmp    102fe1 <pipealloc+0xd1>
  103005:	90                   	nop    
  103006:	90                   	nop    
  103007:	90                   	nop    
  103008:	90                   	nop    
  103009:	90                   	nop    
  10300a:	90                   	nop    
  10300b:	90                   	nop    
  10300c:	90                   	nop    
  10300d:	90                   	nop    
  10300e:	90                   	nop    
  10300f:	90                   	nop    

00103010 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  103010:	55                   	push   %ebp
  103011:	31 d2                	xor    %edx,%edx
  103013:	89 e5                	mov    %esp,%ebp
  103015:	eb 0e                	jmp    103025 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  103017:	81 c2 98 00 00 00    	add    $0x98,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10301d:	81 fa 00 26 00 00    	cmp    $0x2600,%edx
  103023:	74 29                	je     10304e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  103025:	83 ba 4c b1 10 00 02 	cmpl   $0x2,0x10b14c(%edx)
  10302c:	75 e9                	jne    103017 <wakeup1+0x7>
  10302e:	39 82 58 b1 10 00    	cmp    %eax,0x10b158(%edx)
  103034:	75 e1                	jne    103017 <wakeup1+0x7>
      p->state = RUNNABLE;
  103036:	c7 82 4c b1 10 00 03 	movl   $0x3,0x10b14c(%edx)
  10303d:	00 00 00 
  103040:	81 c2 98 00 00 00    	add    $0x98,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103046:	81 fa 00 26 00 00    	cmp    $0x2600,%edx
  10304c:	75 d7                	jne    103025 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10304e:	5d                   	pop    %ebp
  10304f:	c3                   	ret    

00103050 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	57                   	push   %edi
  103054:	56                   	push   %esi
  103055:	53                   	push   %ebx
  103056:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  10305b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10305e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103061:	eb 4a                	jmp    1030ad <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103063:	8b 14 95 90 64 10 00 	mov    0x106490(,%edx,4),%edx
  10306a:	85 d2                	test   %edx,%edx
  10306c:	74 4d                	je     1030bb <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  10306e:	05 88 00 00 00       	add    $0x88,%eax
  103073:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103077:	8b 43 04             	mov    0x4(%ebx),%eax
  10307a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10307e:	c7 04 24 c9 63 10 00 	movl   $0x1063c9,(%esp)
  103085:	89 44 24 04          	mov    %eax,0x4(%esp)
  103089:	e8 72 d6 ff ff       	call   100700 <cprintf>
    if(p->state == SLEEPING){
  10308e:	83 3b 02             	cmpl   $0x2,(%ebx)
  103091:	74 2f                	je     1030c2 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103093:	c7 04 24 73 63 10 00 	movl   $0x106373,(%esp)
  10309a:	e8 61 d6 ff ff       	call   100700 <cprintf>
  10309f:	81 c3 98 00 00 00    	add    $0x98,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1030a5:	81 fb 4c d7 10 00    	cmp    $0x10d74c,%ebx
  1030ab:	74 55                	je     103102 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1030ad:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1030af:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1030b2:	85 d2                	test   %edx,%edx
  1030b4:	74 e9                	je     10309f <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1030b6:	83 fa 05             	cmp    $0x5,%edx
  1030b9:	76 a8                	jbe    103063 <procdump+0x13>
  1030bb:	ba c5 63 10 00       	mov    $0x1063c5,%edx
  1030c0:	eb ac                	jmp    10306e <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1030c2:	8b 43 74             	mov    0x74(%ebx),%eax
  1030c5:	be 01 00 00 00       	mov    $0x1,%esi
  1030ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1030ce:	83 c0 08             	add    $0x8,%eax
  1030d1:	89 04 24             	mov    %eax,(%esp)
  1030d4:	e8 77 0b 00 00       	call   103c50 <getcallerpcs>
  1030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1030e0:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  1030e4:	85 c0                	test   %eax,%eax
  1030e6:	74 ab                	je     103093 <procdump+0x43>
        cprintf(" %p", pc[j]);
  1030e8:	83 c6 01             	add    $0x1,%esi
  1030eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030ef:	c7 04 24 f5 5e 10 00 	movl   $0x105ef5,(%esp)
  1030f6:	e8 05 d6 ff ff       	call   100700 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  1030fb:	83 fe 0b             	cmp    $0xb,%esi
  1030fe:	75 e0                	jne    1030e0 <procdump+0x90>
  103100:	eb 91                	jmp    103093 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103102:	83 c4 4c             	add    $0x4c,%esp
  103105:	5b                   	pop    %ebx
  103106:	5e                   	pop    %esi
  103107:	5f                   	pop    %edi
  103108:	5d                   	pop    %ebp
  103109:	c3                   	ret    
  10310a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103110 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103110:	55                   	push   %ebp
  103111:	89 e5                	mov    %esp,%ebp
  103113:	53                   	push   %ebx
  103114:	83 ec 04             	sub    $0x4,%esp
  103117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10311a:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103121:	e8 ca 0c 00 00       	call   103df0 <acquire>
  103126:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  10312b:	eb 0f                	jmp    10313c <kill+0x2c>
  10312d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  103130:	05 98 00 00 00       	add    $0x98,%eax
  103135:	3d 40 d7 10 00       	cmp    $0x10d740,%eax
  10313a:	74 26                	je     103162 <kill+0x52>
    if(p->pid == pid){
  10313c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10313f:	75 ef                	jne    103130 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103141:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103145:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10314c:	74 2b                	je     103179 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10314e:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103155:	e8 56 0c 00 00       	call   103db0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10315a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10315d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10315f:	5b                   	pop    %ebx
  103160:	5d                   	pop    %ebp
  103161:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103162:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103169:	e8 42 0c 00 00       	call   103db0 <release>
  return -1;
}
  10316e:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  103176:	5b                   	pop    %ebx
  103177:	5d                   	pop    %ebp
  103178:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103179:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103180:	eb cc                	jmp    10314e <kill+0x3e>
  103182:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103190 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  103190:	55                   	push   %ebp
  103191:	89 e5                	mov    %esp,%ebp
  103193:	53                   	push   %ebx
  103194:	83 ec 04             	sub    $0x4,%esp
  103197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10319a:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1031a1:	e8 4a 0c 00 00       	call   103df0 <acquire>
  wakeup1(chan);
  1031a6:	89 d8                	mov    %ebx,%eax
  1031a8:	e8 63 fe ff ff       	call   103010 <wakeup1>
  release(&proc_table_lock);
  1031ad:	c7 45 08 40 d7 10 00 	movl   $0x10d740,0x8(%ebp)
}
  1031b4:	83 c4 04             	add    $0x4,%esp
  1031b7:	5b                   	pop    %ebx
  1031b8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1031b9:	e9 f2 0b 00 00       	jmp    103db0 <release>
  1031be:	66 90                	xchg   %ax,%ax

001031c0 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
  1031c3:	53                   	push   %ebx
  1031c4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  1031c7:	e8 54 0b 00 00       	call   103d20 <pushcli>
  p = cpus[cpu()].curproc;
  1031cc:	e8 8f f4 ff ff       	call   102660 <cpu>
  1031d1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1031d7:	8b 98 c4 aa 10 00    	mov    0x10aac4(%eax),%ebx
  popcli();
  1031dd:	e8 be 0a 00 00       	call   103ca0 <popcli>
  return p;
}
  1031e2:	83 c4 04             	add    $0x4,%esp
  1031e5:	89 d8                	mov    %ebx,%eax
  1031e7:	5b                   	pop    %ebx
  1031e8:	5d                   	pop    %ebp
  1031e9:	c3                   	ret    
  1031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001031f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  1031f0:	55                   	push   %ebp
  1031f1:	89 e5                	mov    %esp,%ebp
  1031f3:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  1031f6:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1031fd:	e8 ae 0b 00 00       	call   103db0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103202:	e8 b9 ff ff ff       	call   1031c0 <curproc>
  103207:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10320d:	89 04 24             	mov    %eax,(%esp)
  103210:	e8 f7 1e 00 00       	call   10510c <forkret1>
}
  103215:	c9                   	leave  
  103216:	c3                   	ret    
  103217:	89 f6                	mov    %esi,%esi
  103219:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103220 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103220:	55                   	push   %ebp
  103221:	89 e5                	mov    %esp,%ebp
  103223:	53                   	push   %ebx
  103224:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103227:	9c                   	pushf  
  103228:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103229:	f6 c4 02             	test   $0x2,%ah
  10322c:	75 5c                	jne    10328a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10322e:	e8 8d ff ff ff       	call   1031c0 <curproc>
  103233:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103237:	74 5d                	je     103296 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103239:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103240:	e8 3b 0b 00 00       	call   103d80 <holding>
  103245:	85 c0                	test   %eax,%eax
  103247:	74 59                	je     1032a2 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103249:	e8 12 f4 ff ff       	call   102660 <cpu>
  10324e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103254:	83 b8 84 ab 10 00 01 	cmpl   $0x1,0x10ab84(%eax)
  10325b:	75 51                	jne    1032ae <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10325d:	e8 fe f3 ff ff       	call   102660 <cpu>
  103262:	89 c3                	mov    %eax,%ebx
  103264:	e8 57 ff ff ff       	call   1031c0 <curproc>
  103269:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  10326f:	81 c2 c8 aa 10 00    	add    $0x10aac8,%edx
  103275:	89 54 24 04          	mov    %edx,0x4(%esp)
  103279:	83 c0 64             	add    $0x64,%eax
  10327c:	89 04 24             	mov    %eax,(%esp)
  10327f:	e8 e8 0d 00 00       	call   10406c <swtch>
}
  103284:	83 c4 14             	add    $0x14,%esp
  103287:	5b                   	pop    %ebx
  103288:	5d                   	pop    %ebp
  103289:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10328a:	c7 04 24 d2 63 10 00 	movl   $0x1063d2,(%esp)
  103291:	e8 0a d6 ff ff       	call   1008a0 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  103296:	c7 04 24 e6 63 10 00 	movl   $0x1063e6,(%esp)
  10329d:	e8 fe d5 ff ff       	call   1008a0 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  1032a2:	c7 04 24 f4 63 10 00 	movl   $0x1063f4,(%esp)
  1032a9:	e8 f2 d5 ff ff       	call   1008a0 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  1032ae:	c7 04 24 0a 64 10 00 	movl   $0x10640a,(%esp)
  1032b5:	e8 e6 d5 ff ff       	call   1008a0 <panic>
  1032ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001032c0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1032c0:	55                   	push   %ebp
  1032c1:	89 e5                	mov    %esp,%ebp
  1032c3:	83 ec 18             	sub    $0x18,%esp
  1032c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1032c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  1032cc:	e8 ef fe ff ff       	call   1031c0 <curproc>
  1032d1:	3b 05 48 78 10 00    	cmp    0x107848,%eax
  1032d7:	75 0c                	jne    1032e5 <exit+0x25>
    panic("init exiting");
  1032d9:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  1032e0:	e8 bb d5 ff ff       	call   1008a0 <panic>
  1032e5:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1032e7:	e8 d4 fe ff ff       	call   1031c0 <curproc>
  1032ec:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  1032f0:	85 c0                	test   %eax,%eax
  1032f2:	74 1e                	je     103312 <exit+0x52>
      fileclose(cp->ofile[fd]);
  1032f4:	e8 c7 fe ff ff       	call   1031c0 <curproc>
  1032f9:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  1032fd:	89 04 24             	mov    %eax,(%esp)
  103300:	e8 5b dc ff ff       	call   100f60 <fileclose>
      cp->ofile[fd] = 0;
  103305:	e8 b6 fe ff ff       	call   1031c0 <curproc>
  10330a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  103311:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103312:	83 c3 01             	add    $0x1,%ebx
  103315:	83 fb 10             	cmp    $0x10,%ebx
  103318:	75 cd                	jne    1032e7 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  10331a:	e8 a1 fe ff ff       	call   1031c0 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10331f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103321:	8b 40 60             	mov    0x60(%eax),%eax
  103324:	89 04 24             	mov    %eax,(%esp)
  103327:	e8 b4 e5 ff ff       	call   1018e0 <iput>
  cp->cwd = 0;
  10332c:	e8 8f fe ff ff       	call   1031c0 <curproc>
  103331:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  103338:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  10333f:	e8 ac 0a 00 00       	call   103df0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  103344:	e8 77 fe ff ff       	call   1031c0 <curproc>
  103349:	8b 40 14             	mov    0x14(%eax),%eax
  10334c:	e8 bf fc ff ff       	call   103010 <wakeup1>
  103351:	eb 0f                	jmp    103362 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  103353:	81 c6 98 00 00 00    	add    $0x98,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103359:	81 fe 00 26 00 00    	cmp    $0x2600,%esi
  10335f:	90                   	nop    
  103360:	74 2a                	je     10338c <exit+0xcc>
    if(p->parent == cp){
  103362:	8b 9e 54 b1 10 00    	mov    0x10b154(%esi),%ebx
  103368:	e8 53 fe ff ff       	call   1031c0 <curproc>
  10336d:	39 c3                	cmp    %eax,%ebx
  10336f:	75 e2                	jne    103353 <exit+0x93>
      p->parent = initproc;
  103371:	a1 48 78 10 00       	mov    0x107848,%eax
      if(p->state == ZOMBIE)
  103376:	83 be 4c b1 10 00 05 	cmpl   $0x5,0x10b14c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10337d:	89 86 54 b1 10 00    	mov    %eax,0x10b154(%esi)
      if(p->state == ZOMBIE)
  103383:	75 ce                	jne    103353 <exit+0x93>
        wakeup1(initproc);
  103385:	e8 86 fc ff ff       	call   103010 <wakeup1>
  10338a:	eb c7                	jmp    103353 <exit+0x93>
  10338c:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103390:	e8 2b fe ff ff       	call   1031c0 <curproc>
  103395:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  10339c:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  1033a0:	e8 1b fe ff ff       	call   1031c0 <curproc>
  1033a5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  1033ac:	e8 6f fe ff ff       	call   103220 <sched>
  panic("zombie exit");
  1033b1:	c7 04 24 23 64 10 00 	movl   $0x106423,(%esp)
  1033b8:	e8 e3 d4 ff ff       	call   1008a0 <panic>
  1033bd:	8d 76 00             	lea    0x0(%esi),%esi

001033c0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1033c0:	55                   	push   %ebp
  1033c1:	89 e5                	mov    %esp,%ebp
  1033c3:	56                   	push   %esi
  1033c4:	53                   	push   %ebx
  1033c5:	83 ec 10             	sub    $0x10,%esp
  1033c8:	8b 75 08             	mov    0x8(%ebp),%esi
  1033cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1033ce:	e8 ed fd ff ff       	call   1031c0 <curproc>
  1033d3:	85 c0                	test   %eax,%eax
  1033d5:	0f 84 91 00 00 00    	je     10346c <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  1033db:	85 db                	test   %ebx,%ebx
  1033dd:	0f 84 95 00 00 00    	je     103478 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  1033e3:	81 fb 40 d7 10 00    	cmp    $0x10d740,%ebx
  1033e9:	74 55                	je     103440 <sleep+0x80>
    acquire(&proc_table_lock);
  1033eb:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1033f2:	e8 f9 09 00 00       	call   103df0 <acquire>
    release(lk);
  1033f7:	89 1c 24             	mov    %ebx,(%esp)
  1033fa:	e8 b1 09 00 00       	call   103db0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  1033ff:	e8 bc fd ff ff       	call   1031c0 <curproc>
  103404:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103407:	e8 b4 fd ff ff       	call   1031c0 <curproc>
  10340c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103413:	e8 08 fe ff ff       	call   103220 <sched>

  // Tidy up.
  cp->chan = 0;
  103418:	e8 a3 fd ff ff       	call   1031c0 <curproc>
  10341d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103424:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  10342b:	e8 80 09 00 00       	call   103db0 <release>
    acquire(lk);
  103430:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103433:	83 c4 10             	add    $0x10,%esp
  103436:	5b                   	pop    %ebx
  103437:	5e                   	pop    %esi
  103438:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103439:	e9 b2 09 00 00       	jmp    103df0 <acquire>
  10343e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103440:	e8 7b fd ff ff       	call   1031c0 <curproc>
  103445:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103448:	e8 73 fd ff ff       	call   1031c0 <curproc>
  10344d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103454:	e8 c7 fd ff ff       	call   103220 <sched>

  // Tidy up.
  cp->chan = 0;
  103459:	e8 62 fd ff ff       	call   1031c0 <curproc>
  10345e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103465:	83 c4 10             	add    $0x10,%esp
  103468:	5b                   	pop    %ebx
  103469:	5e                   	pop    %esi
  10346a:	5d                   	pop    %ebp
  10346b:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  10346c:	c7 04 24 2f 64 10 00 	movl   $0x10642f,(%esp)
  103473:	e8 28 d4 ff ff       	call   1008a0 <panic>

  if(lk == 0)
    panic("sleep without lk");
  103478:	c7 04 24 35 64 10 00 	movl   $0x106435,(%esp)
  10347f:	e8 1c d4 ff ff       	call   1008a0 <panic>
  103484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10348a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103490 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103494:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103496:	56                   	push   %esi
  103497:	53                   	push   %ebx
  103498:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10349b:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1034a2:	e8 49 09 00 00       	call   103df0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1034a7:	83 ff 3f             	cmp    $0x3f,%edi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1034aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1034b1:	7e 31                	jle    1034e4 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1034b3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034b6:	85 c9                	test   %ecx,%ecx
  1034b8:	74 68                	je     103522 <wait+0x92>
  1034ba:	e8 01 fd ff ff       	call   1031c0 <curproc>
  1034bf:	8b 50 1c             	mov    0x1c(%eax),%edx
  1034c2:	85 d2                	test   %edx,%edx
  1034c4:	75 5c                	jne    103522 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1034c6:	e8 f5 fc ff ff       	call   1031c0 <curproc>
  1034cb:	31 ff                	xor    %edi,%edi
  1034cd:	c7 44 24 04 40 d7 10 	movl   $0x10d740,0x4(%esp)
  1034d4:	00 
  1034d5:	89 04 24             	mov    %eax,(%esp)
  1034d8:	e8 e3 fe ff ff       	call   1033c0 <sleep>
  1034dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1034e4:	69 df 98 00 00 00    	imul   $0x98,%edi,%ebx
  1034ea:	8d b3 40 b1 10 00    	lea    0x10b140(%ebx),%esi
      if(p->state == UNUSED)
  1034f0:	8b 46 0c             	mov    0xc(%esi),%eax
  1034f3:	85 c0                	test   %eax,%eax
  1034f5:	75 0a                	jne    103501 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1034f7:	83 c7 01             	add    $0x1,%edi
  1034fa:	83 ff 3f             	cmp    $0x3f,%edi
  1034fd:	7e e5                	jle    1034e4 <wait+0x54>
  1034ff:	eb b2                	jmp    1034b3 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103501:	8b 46 14             	mov    0x14(%esi),%eax
  103504:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103507:	e8 b4 fc ff ff       	call   1031c0 <curproc>
  10350c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10350f:	90                   	nop    
  103510:	75 e5                	jne    1034f7 <wait+0x67>
        if(p->state == ZOMBIE){
  103512:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103516:	74 25                	je     10353d <wait+0xad>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103518:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10351f:	90                   	nop    
  103520:	eb d5                	jmp    1034f7 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103522:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103529:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10352e:	e8 7d 08 00 00       	call   103db0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103533:	83 c4 1c             	add    $0x1c,%esp
  103536:	89 d8                	mov    %ebx,%eax
  103538:	5b                   	pop    %ebx
  103539:	5e                   	pop    %esi
  10353a:	5f                   	pop    %edi
  10353b:	5d                   	pop    %ebp
  10353c:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  10353d:	8b 46 04             	mov    0x4(%esi),%eax
  103540:	89 44 24 04          	mov    %eax,0x4(%esp)
  103544:	8b 83 40 b1 10 00    	mov    0x10b140(%ebx),%eax
  10354a:	89 04 24             	mov    %eax,(%esp)
  10354d:	e8 4e ed ff ff       	call   1022a0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103552:	8b 46 08             	mov    0x8(%esi),%eax
  103555:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10355c:	00 
  10355d:	89 04 24             	mov    %eax,(%esp)
  103560:	e8 3b ed ff ff       	call   1022a0 <kfree>
          pid = p->pid;
  103565:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103568:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  10356f:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103576:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  10357d:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103584:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  10358b:	e8 20 08 00 00       	call   103db0 <release>
  103590:	eb a1                	jmp    103533 <wait+0xa3>
  103592:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001035a0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1035a0:	55                   	push   %ebp
  1035a1:	89 e5                	mov    %esp,%ebp
  1035a3:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  1035a6:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1035ad:	e8 3e 08 00 00       	call   103df0 <acquire>
  cp->state = RUNNABLE;
  1035b2:	e8 09 fc ff ff       	call   1031c0 <curproc>
  1035b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1035be:	e8 5d fc ff ff       	call   103220 <sched>
  release(&proc_table_lock);
  1035c3:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1035ca:	e8 e1 07 00 00       	call   103db0 <release>
}
  1035cf:	c9                   	leave  
  1035d0:	c3                   	ret    
  1035d1:	eb 0d                	jmp    1035e0 <setupsegs>
  1035d3:	90                   	nop    
  1035d4:	90                   	nop    
  1035d5:	90                   	nop    
  1035d6:	90                   	nop    
  1035d7:	90                   	nop    
  1035d8:	90                   	nop    
  1035d9:	90                   	nop    
  1035da:	90                   	nop    
  1035db:	90                   	nop    
  1035dc:	90                   	nop    
  1035dd:	90                   	nop    
  1035de:	90                   	nop    
  1035df:	90                   	nop    

001035e0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1035e0:	55                   	push   %ebp
  1035e1:	89 e5                	mov    %esp,%ebp
  1035e3:	57                   	push   %edi
  1035e4:	56                   	push   %esi
  1035e5:	53                   	push   %ebx
  1035e6:	83 ec 1c             	sub    $0x1c,%esp
  1035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  1035ec:	e8 2f 07 00 00       	call   103d20 <pushcli>
  c = &cpus[cpu()];
  1035f1:	e8 6a f0 ff ff       	call   102660 <cpu>
  1035f6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1035fc:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  1035fe:	8d b8 c0 aa 10 00    	lea    0x10aac0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  103604:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  10360a:	0f 84 85 01 00 00    	je     103795 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103610:	8b 43 08             	mov    0x8(%ebx),%eax
  103613:	05 00 10 00 00       	add    $0x1000,%eax
  103618:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10361b:	8d 47 28             	lea    0x28(%edi),%eax
  10361e:	89 c2                	mov    %eax,%edx
  103620:	c1 ea 18             	shr    $0x18,%edx
  103623:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  103629:	89 c2                	mov    %eax,%edx
  10362b:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  10362e:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103630:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  103637:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  10363e:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  103645:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  10364c:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  103653:	00 00 
  103655:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  10365c:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  10365e:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  103665:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10366c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  103673:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10367a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  103681:	00 00 
  103683:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10368a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10368c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  103693:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10369a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  1036a1:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  1036a8:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  1036af:	00 00 
  1036b1:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  1036b8:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1036ba:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  1036c1:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  1036c7:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  1036ce:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  1036d5:	67 00 
  c->gdt[SEG_TSS].s = 0;
  1036d7:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  1036de:	0f 84 bd 00 00 00    	je     1037a1 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036e4:	8b 53 04             	mov    0x4(%ebx),%edx
  1036e7:	8b 0b                	mov    (%ebx),%ecx
  1036e9:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1036f0:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036f7:	83 ea 01             	sub    $0x1,%edx
  1036fa:	89 d0                	mov    %edx,%eax
  1036fc:	89 ce                	mov    %ecx,%esi
  1036fe:	c1 e8 0c             	shr    $0xc,%eax
  103701:	89 cb                	mov    %ecx,%ebx
  103703:	c1 ea 1c             	shr    $0x1c,%edx
  103706:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103709:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  10370b:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10370e:	c1 ee 10             	shr    $0x10,%esi
  103711:	83 c8 c0             	or     $0xffffffc0,%eax
  103714:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  10371a:	89 f0                	mov    %esi,%eax
  10371c:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  103722:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103726:	c1 eb 18             	shr    $0x18,%ebx
  103729:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  10372f:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103736:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10373c:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103743:	89 f0                	mov    %esi,%eax
  103745:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  10374b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  10374f:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  103755:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  10375c:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  103763:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103769:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  10376f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  103773:	c1 e8 10             	shr    $0x10,%eax
  103776:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10377a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  10377d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103780:	b8 28 00 00 00       	mov    $0x28,%eax
  103785:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  103788:	e8 13 05 00 00       	call   103ca0 <popcli>
}
  10378d:	83 c4 1c             	add    $0x1c,%esp
  103790:	5b                   	pop    %ebx
  103791:	5e                   	pop    %esi
  103792:	5f                   	pop    %edi
  103793:	5d                   	pop    %ebp
  103794:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103795:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10379c:	e9 7a fe ff ff       	jmp    10361b <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  1037a1:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  1037a8:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  1037af:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  1037b6:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  1037bd:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  1037c4:	00 00 
  1037c6:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  1037cd:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  1037cf:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  1037d6:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  1037dd:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  1037e4:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  1037eb:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  1037f2:	00 00 
  1037f4:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  1037fb:	00 00 
  1037fd:	e9 61 ff ff ff       	jmp    103763 <setupsegs+0x183>
  103802:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103810 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103810:	55                   	push   %ebp
  103811:	89 e5                	mov    %esp,%ebp
  103813:	57                   	push   %edi
  103814:	56                   	push   %esi
  103815:	53                   	push   %ebx
  103816:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c;
  int i;

  c = &cpus[cpu()];
  103819:	e8 42 ee ff ff       	call   102660 <cpu>
  10381e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103824:	8d b0 c0 aa 10 00    	lea    0x10aac0(%eax),%esi
  10382a:	8d 7e 08             	lea    0x8(%esi),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
  10382d:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  10382e:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103835:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  10383a:	e8 b1 05 00 00       	call   103df0 <acquire>
  10383f:	eb 0e                	jmp    10384f <scheduler+0x3f>
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  103841:	81 c3 98 00 00 00    	add    $0x98,%ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  103847:	81 fb 4c d7 10 00    	cmp    $0x10d74c,%ebx
  10384d:	74 49                	je     103898 <scheduler+0x88>
      p = &proc[i];
      if(p->state != RUNNABLE)
  10384f:	83 3b 03             	cmpl   $0x3,(%ebx)
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103852:	8d 43 f4             	lea    -0xc(%ebx),%eax
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
      if(p->state != RUNNABLE)
  103855:	75 ea                	jne    103841 <scheduler+0x31>

      // Switch to chosen process.  It is the process's job
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      //cprintf("scheduling\n");
      c->curproc = p;
  103857:	89 46 04             	mov    %eax,0x4(%esi)
      setupsegs(p);
  10385a:	89 04 24             	mov    %eax,(%esp)
  10385d:	e8 7e fd ff ff       	call   1035e0 <setupsegs>
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103862:	8d 43 58             	lea    0x58(%ebx),%eax
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      //cprintf("scheduling\n");
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
  103865:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  10386b:	81 c3 98 00 00 00    	add    $0x98,%ebx
      // before jumping back to us.
      //cprintf("scheduling\n");
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103871:	89 44 24 04          	mov    %eax,0x4(%esp)
  103875:	89 3c 24             	mov    %edi,(%esp)
  103878:	e8 ef 07 00 00       	call   10406c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  10387d:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
      setupsegs(0);
  103884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10388b:	e8 50 fd ff ff       	call   1035e0 <setupsegs>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  103890:	81 fb 4c d7 10 00    	cmp    $0x10d74c,%ebx
  103896:	75 b7                	jne    10384f <scheduler+0x3f>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
    }
    release(&proc_table_lock);
  103898:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  10389f:	e8 0c 05 00 00       	call   103db0 <release>
  1038a4:	eb 87                	jmp    10382d <scheduler+0x1d>
  1038a6:	8d 76 00             	lea    0x0(%esi),%esi
  1038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001038b0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  1038b0:	55                   	push   %ebp
  1038b1:	89 e5                	mov    %esp,%ebp
  1038b3:	57                   	push   %edi
  1038b4:	56                   	push   %esi
  1038b5:	53                   	push   %ebx
  1038b6:	83 ec 0c             	sub    $0xc,%esp
  1038b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  1038bc:	e8 ff f8 ff ff       	call   1031c0 <curproc>
  1038c1:	8b 50 04             	mov    0x4(%eax),%edx
  1038c4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  1038c7:	89 04 24             	mov    %eax,(%esp)
  1038ca:	e8 21 e9 ff ff       	call   1021f0 <kalloc>
  1038cf:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  1038d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1038d6:	85 f6                	test   %esi,%esi
  1038d8:	74 7f                	je     103959 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  1038da:	e8 e1 f8 ff ff       	call   1031c0 <curproc>
  1038df:	8b 58 04             	mov    0x4(%eax),%ebx
  1038e2:	e8 d9 f8 ff ff       	call   1031c0 <curproc>
  1038e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1038eb:	8b 00                	mov    (%eax),%eax
  1038ed:	89 34 24             	mov    %esi,(%esp)
  1038f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038f4:	e8 07 06 00 00       	call   103f00 <memmove>
  memset(newmem + cp->sz, 0, n);
  1038f9:	e8 c2 f8 ff ff       	call   1031c0 <curproc>
  1038fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103902:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103909:	00 
  10390a:	8b 50 04             	mov    0x4(%eax),%edx
  10390d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103910:	89 04 24             	mov    %eax,(%esp)
  103913:	e8 38 05 00 00       	call   103e50 <memset>
  kfree(cp->mem, cp->sz);
  103918:	e8 a3 f8 ff ff       	call   1031c0 <curproc>
  10391d:	8b 58 04             	mov    0x4(%eax),%ebx
  103920:	e8 9b f8 ff ff       	call   1031c0 <curproc>
  103925:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103929:	8b 00                	mov    (%eax),%eax
  10392b:	89 04 24             	mov    %eax,(%esp)
  10392e:	e8 6d e9 ff ff       	call   1022a0 <kfree>
  cp->mem = newmem;
  103933:	e8 88 f8 ff ff       	call   1031c0 <curproc>
  103938:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  10393a:	e8 81 f8 ff ff       	call   1031c0 <curproc>
  10393f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  103942:	e8 79 f8 ff ff       	call   1031c0 <curproc>
  103947:	89 04 24             	mov    %eax,(%esp)
  10394a:	e8 91 fc ff ff       	call   1035e0 <setupsegs>
  return cp->sz - n;
  10394f:	e8 6c f8 ff ff       	call   1031c0 <curproc>
  103954:	8b 40 04             	mov    0x4(%eax),%eax
  103957:	29 f8                	sub    %edi,%eax
}
  103959:	83 c4 0c             	add    $0xc,%esp
  10395c:	5b                   	pop    %ebx
  10395d:	5e                   	pop    %esi
  10395e:	5f                   	pop    %edi
  10395f:	5d                   	pop    %ebp
  103960:	c3                   	ret    
  103961:	eb 0d                	jmp    103970 <copyproc>
  103963:	90                   	nop    
  103964:	90                   	nop    
  103965:	90                   	nop    
  103966:	90                   	nop    
  103967:	90                   	nop    
  103968:	90                   	nop    
  103969:	90                   	nop    
  10396a:	90                   	nop    
  10396b:	90                   	nop    
  10396c:	90                   	nop    
  10396d:	90                   	nop    
  10396e:	90                   	nop    
  10396f:	90                   	nop    

00103970 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  103970:	55                   	push   %ebp
  103971:	89 e5                	mov    %esp,%ebp
  103973:	57                   	push   %edi
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103974:	bf 40 b1 10 00       	mov    $0x10b140,%edi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  103979:	56                   	push   %esi
  10397a:	53                   	push   %ebx
  10397b:	83 ec 0c             	sub    $0xc,%esp
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10397e:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103985:	e8 66 04 00 00       	call   103df0 <acquire>
  10398a:	eb 16                	jmp    1039a2 <copyproc+0x32>
  10398c:	8d 74 26 00          	lea    0x0(%esi),%esi
  // Allocate process.
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103990:	8d bf 98 00 00 00    	lea    0x98(%edi),%edi
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103996:	81 ff 40 d7 10 00    	cmp    $0x10d740,%edi
  10399c:	0f 84 20 01 00 00    	je     103ac2 <copyproc+0x152>
    p = &proc[i];
    if(p->state == UNUSED){
  1039a2:	8b 47 0c             	mov    0xc(%edi),%eax
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1039a5:	89 fe                	mov    %edi,%esi
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  1039a7:	85 c0                	test   %eax,%eax
  1039a9:	75 e5                	jne    103990 <copyproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  1039ab:	a1 04 73 10 00       	mov    0x107304,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  1039b0:	c7 47 0c 01 00 00 00 	movl   $0x1,0xc(%edi)
      p->pid = nextpid++;
  1039b7:	89 47 10             	mov    %eax,0x10(%edi)
  1039ba:	83 c0 01             	add    $0x1,%eax
  1039bd:	a3 04 73 10 00       	mov    %eax,0x107304
      release(&proc_table_lock);
  1039c2:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  1039c9:	e8 e2 03 00 00       	call   103db0 <release>
  // Allocate process.
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1039ce:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1039d5:	e8 16 e8 ff ff       	call   1021f0 <kalloc>
  1039da:	85 c0                	test   %eax,%eax
  1039dc:	89 47 08             	mov    %eax,0x8(%edi)
  1039df:	0f 84 f5 00 00 00    	je     103ada <copyproc+0x16a>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1039e5:	8d 90 bc 0f 00 00    	lea    0xfbc(%eax),%edx

  if(p){  // Copy process state from p.
  1039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1039ee:	89 97 84 00 00 00    	mov    %edx,0x84(%edi)

  if(p){  // Copy process state from p.
  1039f4:	85 c0                	test   %eax,%eax
  1039f6:	0f 84 8a 00 00 00    	je     103a86 <copyproc+0x116>
    np->parent = p;
  1039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ff:	89 47 14             	mov    %eax,0x14(%edi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103a02:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103a09:	00 
  103a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103a0d:	8b 81 84 00 00 00    	mov    0x84(%ecx),%eax
  103a13:	89 14 24             	mov    %edx,(%esp)
  103a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a1a:	e8 e1 04 00 00       	call   103f00 <memmove>
  
    np->sz = p->sz;
  103a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  103a22:	8b 42 04             	mov    0x4(%edx),%eax
  103a25:	89 47 04             	mov    %eax,0x4(%edi)
    if((np->mem = kalloc(np->sz)) == 0){
  103a28:	89 04 24             	mov    %eax,(%esp)
  103a2b:	e8 c0 e7 ff ff       	call   1021f0 <kalloc>
  103a30:	85 c0                	test   %eax,%eax
  103a32:	89 c2                	mov    %eax,%edx
  103a34:	89 06                	mov    %eax,(%esi)
  103a36:	0f 84 a9 00 00 00    	je     103ae5 <copyproc+0x175>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103a3c:	8b 47 04             	mov    0x4(%edi),%eax
  103a3f:	31 db                	xor    %ebx,%ebx
  103a41:	89 44 24 08          	mov    %eax,0x8(%esp)
  103a45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103a48:	8b 01                	mov    (%ecx),%eax
  103a4a:	89 14 24             	mov    %edx,(%esp)
  103a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a51:	e8 aa 04 00 00       	call   103f00 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103a56:	8b 55 08             	mov    0x8(%ebp),%edx
  103a59:	8b 44 9a 20          	mov    0x20(%edx,%ebx,4),%eax
  103a5d:	85 c0                	test   %eax,%eax
  103a5f:	74 0c                	je     103a6d <copyproc+0xfd>
        np->ofile[i] = filedup(p->ofile[i]);
  103a61:	89 04 24             	mov    %eax,(%esp)
  103a64:	e8 17 d4 ff ff       	call   100e80 <filedup>
  103a69:	89 44 9f 20          	mov    %eax,0x20(%edi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103a6d:	83 c3 01             	add    $0x1,%ebx
  103a70:	83 fb 10             	cmp    $0x10,%ebx
  103a73:	75 e1                	jne    103a56 <copyproc+0xe6>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103a75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103a78:	8b 41 60             	mov    0x60(%ecx),%eax
  103a7b:	89 04 24             	mov    %eax,(%esp)
  103a7e:	e8 fd d5 ff ff       	call   101080 <idup>
  103a83:	89 47 60             	mov    %eax,0x60(%edi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103a86:	8d 47 64             	lea    0x64(%edi),%eax
  103a89:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103a90:	00 
  103a91:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a98:	00 
  103a99:	89 04 24             	mov    %eax,(%esp)
  103a9c:	e8 af 03 00 00       	call   103e50 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103aa1:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103aa7:	c7 47 64 f0 31 10 00 	movl   $0x1031f0,0x64(%edi)
  np->context.esp = (uint)np->tf;
  103aae:	89 47 68             	mov    %eax,0x68(%edi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103ab1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103ab8:	83 c4 0c             	add    $0xc,%esp
  103abb:	89 f0                	mov    %esi,%eax
  103abd:	5b                   	pop    %ebx
  103abe:	5e                   	pop    %esi
  103abf:	5f                   	pop    %edi
  103ac0:	5d                   	pop    %ebp
  103ac1:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103ac2:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103ac9:	31 f6                	xor    %esi,%esi
  103acb:	e8 e0 02 00 00       	call   103db0 <release>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  return np;
}
  103ad0:	83 c4 0c             	add    $0xc,%esp
  103ad3:	89 f0                	mov    %esi,%eax
  103ad5:	5b                   	pop    %ebx
  103ad6:	5e                   	pop    %esi
  103ad7:	5f                   	pop    %edi
  103ad8:	5d                   	pop    %ebp
  103ad9:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103ada:	31 f6                	xor    %esi,%esi
  103adc:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
  103ae3:	eb d3                	jmp    103ab8 <copyproc+0x148>
    np->parent = p;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103ae5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103aec:	00 
  103aed:	8b 47 08             	mov    0x8(%edi),%eax
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
  103af0:	31 f6                	xor    %esi,%esi
    np->parent = p;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103af2:	89 04 24             	mov    %eax,(%esp)
  103af5:	e8 a6 e7 ff ff       	call   1022a0 <kfree>
      np->kstack = 0;
  103afa:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
      np->state = UNUSED;
  103b01:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
      np->parent = 0;
  103b08:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  103b0f:	eb a7                	jmp    103ab8 <copyproc+0x148>
  103b11:	eb 0d                	jmp    103b20 <userinit>
  103b13:	90                   	nop    
  103b14:	90                   	nop    
  103b15:	90                   	nop    
  103b16:	90                   	nop    
  103b17:	90                   	nop    
  103b18:	90                   	nop    
  103b19:	90                   	nop    
  103b1a:	90                   	nop    
  103b1b:	90                   	nop    
  103b1c:	90                   	nop    
  103b1d:	90                   	nop    
  103b1e:	90                   	nop    
  103b1f:	90                   	nop    

00103b20 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103b20:	55                   	push   %ebp
  103b21:	89 e5                	mov    %esp,%ebp
  103b23:	53                   	push   %ebx
  103b24:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  cprintf("userinit\n");
  103b27:	c7 04 24 46 64 10 00 	movl   $0x106446,(%esp)
  103b2e:	e8 cd cb ff ff       	call   100700 <cprintf>
  p = copyproc(0);
  103b33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103b3a:	e8 31 fe ff ff       	call   103970 <copyproc>
  p->sz = PAGE;
  103b3f:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  cprintf("userinit\n");
  p = copyproc(0);
  103b46:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  103b48:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103b4f:	e8 9c e6 ff ff       	call   1021f0 <kalloc>
  103b54:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  103b56:	c7 04 24 50 64 10 00 	movl   $0x106450,(%esp)
  103b5d:	e8 ae e2 ff ff       	call   101e10 <namei>
  103b62:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  103b65:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103b6c:	00 
  103b6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b74:	00 
  103b75:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  103b7b:	89 04 24             	mov    %eax,(%esp)
  103b7e:	e8 cd 02 00 00       	call   103e50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103b83:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103b89:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  103b8b:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  103b92:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103b95:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  103b9b:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  103ba1:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  103ba7:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  103baa:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103bae:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  103bb1:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103bb7:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  103bbe:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  103bc5:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103bcc:	00 
  103bcd:	c7 44 24 04 08 77 10 	movl   $0x107708,0x4(%esp)
  103bd4:	00 
  103bd5:	8b 03                	mov    (%ebx),%eax
  103bd7:	89 04 24             	mov    %eax,(%esp)
  103bda:	e8 21 03 00 00       	call   103f00 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  103bdf:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  103be5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103bec:	00 
  103bed:	c7 44 24 04 52 64 10 	movl   $0x106452,0x4(%esp)
  103bf4:	00 
  103bf5:	89 04 24             	mov    %eax,(%esp)
  103bf8:	e8 13 04 00 00       	call   104010 <safestrcpy>
  p->state = RUNNABLE;
  103bfd:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  103c04:	89 1d 48 78 10 00    	mov    %ebx,0x107848
}
  103c0a:	83 c4 14             	add    $0x14,%esp
  103c0d:	5b                   	pop    %ebx
  103c0e:	5d                   	pop    %ebp
  103c0f:	c3                   	ret    

00103c10 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  103c10:	55                   	push   %ebp
  103c11:	89 e5                	mov    %esp,%ebp
  103c13:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  103c16:	c7 44 24 04 5b 64 10 	movl   $0x10645b,0x4(%esp)
  103c1d:	00 
  103c1e:	c7 04 24 40 d7 10 00 	movl   $0x10d740,(%esp)
  103c25:	e8 06 00 00 00       	call   103c30 <initlock>
}
  103c2a:	c9                   	leave  
  103c2b:	c3                   	ret    
  103c2c:	90                   	nop    
  103c2d:	90                   	nop    
  103c2e:	90                   	nop    
  103c2f:	90                   	nop    

00103c30 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  103c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  103c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  103c3f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  103c42:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  103c49:	5d                   	pop    %ebp
  103c4a:	c3                   	ret    
  103c4b:	90                   	nop    
  103c4c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103c50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103c50:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103c51:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103c53:	89 e5                	mov    %esp,%ebp
  103c55:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103c56:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103c59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103c5c:	83 ea 08             	sub    $0x8,%edx
  103c5f:	eb 02                	jmp    103c63 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103c61:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  103c63:	8d 42 ff             	lea    -0x1(%edx),%eax
  103c66:	83 f8 fd             	cmp    $0xfffffffd,%eax
  103c69:	77 13                	ja     103c7e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103c6b:	8b 42 04             	mov    0x4(%edx),%eax
  103c6e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103c71:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103c74:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103c76:	83 f9 0a             	cmp    $0xa,%ecx
  103c79:	75 e6                	jne    103c61 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103c7b:	5b                   	pop    %ebx
  103c7c:	5d                   	pop    %ebp
  103c7d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103c7e:	83 f9 09             	cmp    $0x9,%ecx
  103c81:	7f f8                	jg     103c7b <getcallerpcs+0x2b>
  103c83:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  103c86:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  103c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103c8f:	83 c0 04             	add    $0x4,%eax
  103c92:	83 f9 0a             	cmp    $0xa,%ecx
  103c95:	75 ef                	jne    103c86 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  103c97:	5b                   	pop    %ebx
  103c98:	5d                   	pop    %ebp
  103c99:	c3                   	ret    
  103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103ca0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  103ca0:	55                   	push   %ebp
  103ca1:	89 e5                	mov    %esp,%ebp
  103ca3:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103ca6:	9c                   	pushf  
  103ca7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103ca8:	f6 c4 02             	test   $0x2,%ah
  103cab:	75 52                	jne    103cff <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  103cad:	e8 ae e9 ff ff       	call   102660 <cpu>
  103cb2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103cb8:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  103cbd:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  103cc3:	83 ea 01             	sub    $0x1,%edx
  103cc6:	85 d2                	test   %edx,%edx
  103cc8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  103cce:	78 3b                	js     103d0b <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  103cd0:	e8 8b e9 ff ff       	call   102660 <cpu>
  103cd5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103cdb:	8b 90 84 ab 10 00    	mov    0x10ab84(%eax),%edx
  103ce1:	85 d2                	test   %edx,%edx
  103ce3:	74 02                	je     103ce7 <popcli+0x47>
    sti();
}
  103ce5:	c9                   	leave  
  103ce6:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  103ce7:	e8 74 e9 ff ff       	call   102660 <cpu>
  103cec:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103cf2:	8b 80 88 ab 10 00    	mov    0x10ab88(%eax),%eax
  103cf8:	85 c0                	test   %eax,%eax
  103cfa:	74 e9                	je     103ce5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  103cfc:	fb                   	sti    
    sti();
}
  103cfd:	c9                   	leave  
  103cfe:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  103cff:	c7 04 24 a8 64 10 00 	movl   $0x1064a8,(%esp)
  103d06:	e8 95 cb ff ff       	call   1008a0 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  103d0b:	c7 04 24 bf 64 10 00 	movl   $0x1064bf,(%esp)
  103d12:	e8 89 cb ff ff       	call   1008a0 <panic>
  103d17:	89 f6                	mov    %esi,%esi
  103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103d20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103d20:	55                   	push   %ebp
  103d21:	89 e5                	mov    %esp,%ebp
  103d23:	53                   	push   %ebx
  103d24:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103d27:	9c                   	pushf  
  103d28:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103d29:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  103d2a:	e8 31 e9 ff ff       	call   102660 <cpu>
  103d2f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103d35:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  103d3a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  103d40:	83 c2 01             	add    $0x1,%edx
  103d43:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  103d49:	83 ea 01             	sub    $0x1,%edx
  103d4c:	74 06                	je     103d54 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  103d4e:	83 c4 04             	add    $0x4,%esp
  103d51:	5b                   	pop    %ebx
  103d52:	5d                   	pop    %ebp
  103d53:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  103d54:	e8 07 e9 ff ff       	call   102660 <cpu>
  103d59:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103d5f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103d65:	89 98 88 ab 10 00    	mov    %ebx,0x10ab88(%eax)
}
  103d6b:	83 c4 04             	add    $0x4,%esp
  103d6e:	5b                   	pop    %ebx
  103d6f:	5d                   	pop    %ebp
  103d70:	c3                   	ret    
  103d71:	eb 0d                	jmp    103d80 <holding>
  103d73:	90                   	nop    
  103d74:	90                   	nop    
  103d75:	90                   	nop    
  103d76:	90                   	nop    
  103d77:	90                   	nop    
  103d78:	90                   	nop    
  103d79:	90                   	nop    
  103d7a:	90                   	nop    
  103d7b:	90                   	nop    
  103d7c:	90                   	nop    
  103d7d:	90                   	nop    
  103d7e:	90                   	nop    
  103d7f:	90                   	nop    

00103d80 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103d80:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  103d81:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103d83:	89 e5                	mov    %esp,%ebp
  103d85:	53                   	push   %ebx
  103d86:	83 ec 04             	sub    $0x4,%esp
  103d89:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  103d8c:	8b 0a                	mov    (%edx),%ecx
  103d8e:	85 c9                	test   %ecx,%ecx
  103d90:	74 13                	je     103da5 <holding+0x25>
  103d92:	8b 5a 08             	mov    0x8(%edx),%ebx
  103d95:	e8 c6 e8 ff ff       	call   102660 <cpu>
  103d9a:	83 c0 0a             	add    $0xa,%eax
  103d9d:	39 c3                	cmp    %eax,%ebx
  103d9f:	0f 94 c0             	sete   %al
  103da2:	0f b6 c0             	movzbl %al,%eax
}
  103da5:	83 c4 04             	add    $0x4,%esp
  103da8:	5b                   	pop    %ebx
  103da9:	5d                   	pop    %ebp
  103daa:	c3                   	ret    
  103dab:	90                   	nop    
  103dac:	8d 74 26 00          	lea    0x0(%esi),%esi

00103db0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  103db0:	55                   	push   %ebp
  103db1:	89 e5                	mov    %esp,%ebp
  103db3:	53                   	push   %ebx
  103db4:	83 ec 04             	sub    $0x4,%esp
  103db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  103dba:	89 1c 24             	mov    %ebx,(%esp)
  103dbd:	e8 be ff ff ff       	call   103d80 <holding>
  103dc2:	85 c0                	test   %eax,%eax
  103dc4:	74 1d                	je     103de3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  103dc6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103dcd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  103dcf:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  103dd6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  103dd9:	83 c4 04             	add    $0x4,%esp
  103ddc:	5b                   	pop    %ebx
  103ddd:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  103dde:	e9 bd fe ff ff       	jmp    103ca0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  103de3:	c7 04 24 c6 64 10 00 	movl   $0x1064c6,(%esp)
  103dea:	e8 b1 ca ff ff       	call   1008a0 <panic>
  103def:	90                   	nop    

00103df0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  103df0:	55                   	push   %ebp
  103df1:	89 e5                	mov    %esp,%ebp
  103df3:	53                   	push   %ebx
  103df4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  103df7:	e8 24 ff ff ff       	call   103d20 <pushcli>
  if(holding(lock))
  103dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  103dff:	89 04 24             	mov    %eax,(%esp)
  103e02:	e8 79 ff ff ff       	call   103d80 <holding>
  103e07:	85 c0                	test   %eax,%eax
  103e09:	75 38                	jne    103e43 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  103e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  103e0e:	66 90                	xchg   %ax,%ax
  103e10:	b8 01 00 00 00       	mov    $0x1,%eax
  103e15:	f0 87 03             	lock xchg %eax,(%ebx)
  103e18:	83 e8 01             	sub    $0x1,%eax
  103e1b:	74 f3                	je     103e10 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  103e1d:	e8 3e e8 ff ff       	call   102660 <cpu>
  103e22:	83 c0 0a             	add    $0xa,%eax
  103e25:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  103e28:	8b 45 08             	mov    0x8(%ebp),%eax
  103e2b:	83 c0 0c             	add    $0xc,%eax
  103e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e32:	8d 45 08             	lea    0x8(%ebp),%eax
  103e35:	89 04 24             	mov    %eax,(%esp)
  103e38:	e8 13 fe ff ff       	call   103c50 <getcallerpcs>
}
  103e3d:	83 c4 14             	add    $0x14,%esp
  103e40:	5b                   	pop    %ebx
  103e41:	5d                   	pop    %ebp
  103e42:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  103e43:	c7 04 24 ce 64 10 00 	movl   $0x1064ce,(%esp)
  103e4a:	e8 51 ca ff ff       	call   1008a0 <panic>
  103e4f:	90                   	nop    

00103e50 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  103e50:	55                   	push   %ebp
  103e51:	89 e5                	mov    %esp,%ebp
  103e53:	8b 45 10             	mov    0x10(%ebp),%eax
  103e56:	53                   	push   %ebx
  103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  103e5a:	85 c0                	test   %eax,%eax
  103e5c:	74 10                	je     103e6e <memset+0x1e>
  103e5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  103e62:	31 d2                	xor    %edx,%edx
    *d++ = c;
  103e64:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  103e67:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  103e6a:	39 c2                	cmp    %eax,%edx
  103e6c:	75 f6                	jne    103e64 <memset+0x14>
    *d++ = c;

  return dst;
}
  103e6e:	89 d8                	mov    %ebx,%eax
  103e70:	5b                   	pop    %ebx
  103e71:	5d                   	pop    %ebp
  103e72:	c3                   	ret    
  103e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103e80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  103e80:	55                   	push   %ebp
  103e81:	89 e5                	mov    %esp,%ebp
  103e83:	57                   	push   %edi
  103e84:	56                   	push   %esi
  103e85:	53                   	push   %ebx
  103e86:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103e89:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  103e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  103e8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103e92:	83 e8 01             	sub    $0x1,%eax
  103e95:	83 f8 ff             	cmp    $0xffffffff,%eax
  103e98:	74 36                	je     103ed0 <memcmp+0x50>
    if(*s1 != *s2)
  103e9a:	0f b6 32             	movzbl (%edx),%esi
  103e9d:	0f b6 0f             	movzbl (%edi),%ecx
  103ea0:	89 f3                	mov    %esi,%ebx
  103ea2:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  103ea5:	89 d1                	mov    %edx,%ecx
  103ea7:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  103ea9:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  103eac:	74 1a                	je     103ec8 <memcmp+0x48>
  103eae:	eb 2c                	jmp    103edc <memcmp+0x5c>
  103eb0:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  103eb4:	83 c1 01             	add    $0x1,%ecx
  103eb7:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  103ebb:	83 c2 01             	add    $0x1,%edx
  103ebe:	88 5d f3             	mov    %bl,-0xd(%ebp)
  103ec1:	89 f3                	mov    %esi,%ebx
  103ec3:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  103ec6:	75 14                	jne    103edc <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103ec8:	83 e8 01             	sub    $0x1,%eax
  103ecb:	83 f8 ff             	cmp    $0xffffffff,%eax
  103ece:	75 e0                	jne    103eb0 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  103ed0:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  103ed3:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  103ed5:	5b                   	pop    %ebx
  103ed6:	89 d0                	mov    %edx,%eax
  103ed8:	5e                   	pop    %esi
  103ed9:	5f                   	pop    %edi
  103eda:	5d                   	pop    %ebp
  103edb:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  103edc:	89 f0                	mov    %esi,%eax
  103ede:	0f b6 d0             	movzbl %al,%edx
  103ee1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  103ee5:	83 c4 04             	add    $0x4,%esp
  103ee8:	5b                   	pop    %ebx
  103ee9:	5e                   	pop    %esi
  103eea:	5f                   	pop    %edi
  103eeb:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  103eec:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  103eee:	89 d0                	mov    %edx,%eax
  103ef0:	c3                   	ret    
  103ef1:	eb 0d                	jmp    103f00 <memmove>
  103ef3:	90                   	nop    
  103ef4:	90                   	nop    
  103ef5:	90                   	nop    
  103ef6:	90                   	nop    
  103ef7:	90                   	nop    
  103ef8:	90                   	nop    
  103ef9:	90                   	nop    
  103efa:	90                   	nop    
  103efb:	90                   	nop    
  103efc:	90                   	nop    
  103efd:	90                   	nop    
  103efe:	90                   	nop    
  103eff:	90                   	nop    

00103f00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  103f00:	55                   	push   %ebp
  103f01:	89 e5                	mov    %esp,%ebp
  103f03:	56                   	push   %esi
  103f04:	53                   	push   %ebx
  103f05:	8b 75 08             	mov    0x8(%ebp),%esi
  103f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103f0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  103f0e:	39 f1                	cmp    %esi,%ecx
  103f10:	73 2e                	jae    103f40 <memmove+0x40>
  103f12:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  103f15:	39 c6                	cmp    %eax,%esi
  103f17:	73 27                	jae    103f40 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  103f19:	85 db                	test   %ebx,%ebx
  103f1b:	74 1a                	je     103f37 <memmove+0x37>
  103f1d:	89 c2                	mov    %eax,%edx
  103f1f:	29 d8                	sub    %ebx,%eax
  103f21:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  103f24:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  103f26:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  103f2a:	83 ea 01             	sub    $0x1,%edx
  103f2d:	88 41 ff             	mov    %al,-0x1(%ecx)
  103f30:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  103f33:	39 da                	cmp    %ebx,%edx
  103f35:	75 ef                	jne    103f26 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  103f37:	89 f0                	mov    %esi,%eax
  103f39:	5b                   	pop    %ebx
  103f3a:	5e                   	pop    %esi
  103f3b:	5d                   	pop    %ebp
  103f3c:	c3                   	ret    
  103f3d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  103f40:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  103f42:	85 db                	test   %ebx,%ebx
  103f44:	74 f1                	je     103f37 <memmove+0x37>
      *d++ = *s++;
  103f46:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  103f4a:	88 04 32             	mov    %al,(%edx,%esi,1)
  103f4d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  103f50:	39 da                	cmp    %ebx,%edx
  103f52:	75 f2                	jne    103f46 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  103f54:	89 f0                	mov    %esi,%eax
  103f56:	5b                   	pop    %ebx
  103f57:	5e                   	pop    %esi
  103f58:	5d                   	pop    %ebp
  103f59:	c3                   	ret    
  103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f60 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  103f60:	55                   	push   %ebp
  103f61:	89 e5                	mov    %esp,%ebp
  103f63:	56                   	push   %esi
  103f64:	53                   	push   %ebx
  103f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  103f68:	8b 55 08             	mov    0x8(%ebp),%edx
  103f6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  103f6e:	85 db                	test   %ebx,%ebx
  103f70:	74 2a                	je     103f9c <strncmp+0x3c>
  103f72:	0f b6 02             	movzbl (%edx),%eax
  103f75:	84 c0                	test   %al,%al
  103f77:	74 2b                	je     103fa4 <strncmp+0x44>
  103f79:	0f b6 0e             	movzbl (%esi),%ecx
  103f7c:	38 c8                	cmp    %cl,%al
  103f7e:	74 17                	je     103f97 <strncmp+0x37>
  103f80:	eb 25                	jmp    103fa7 <strncmp+0x47>
  103f82:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  103f86:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  103f89:	84 c0                	test   %al,%al
  103f8b:	74 17                	je     103fa4 <strncmp+0x44>
  103f8d:	0f b6 0e             	movzbl (%esi),%ecx
  103f90:	83 c2 01             	add    $0x1,%edx
  103f93:	38 c8                	cmp    %cl,%al
  103f95:	75 10                	jne    103fa7 <strncmp+0x47>
  103f97:	83 eb 01             	sub    $0x1,%ebx
  103f9a:	75 e6                	jne    103f82 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  103f9c:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  103f9d:	31 d2                	xor    %edx,%edx
}
  103f9f:	5e                   	pop    %esi
  103fa0:	89 d0                	mov    %edx,%eax
  103fa2:	5d                   	pop    %ebp
  103fa3:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  103fa4:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  103fa7:	0f b6 d0             	movzbl %al,%edx
  103faa:	0f b6 c1             	movzbl %cl,%eax
}
  103fad:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  103fae:	29 c2                	sub    %eax,%edx
}
  103fb0:	5e                   	pop    %esi
  103fb1:	89 d0                	mov    %edx,%eax
  103fb3:	5d                   	pop    %ebp
  103fb4:	c3                   	ret    
  103fb5:	8d 74 26 00          	lea    0x0(%esi),%esi
  103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103fc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  103fc0:	55                   	push   %ebp
  103fc1:	89 e5                	mov    %esp,%ebp
  103fc3:	56                   	push   %esi
  103fc4:	8b 75 08             	mov    0x8(%ebp),%esi
  103fc7:	53                   	push   %ebx
  103fc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103fcb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  103fce:	89 f2                	mov    %esi,%edx
  103fd0:	eb 03                	jmp    103fd5 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  103fd2:	83 c3 01             	add    $0x1,%ebx
  103fd5:	83 e9 01             	sub    $0x1,%ecx
  103fd8:	8d 41 01             	lea    0x1(%ecx),%eax
  103fdb:	85 c0                	test   %eax,%eax
  103fdd:	7e 0c                	jle    103feb <strncpy+0x2b>
  103fdf:	0f b6 03             	movzbl (%ebx),%eax
  103fe2:	88 02                	mov    %al,(%edx)
  103fe4:	83 c2 01             	add    $0x1,%edx
  103fe7:	84 c0                	test   %al,%al
  103fe9:	75 e7                	jne    103fd2 <strncpy+0x12>
    ;
  while(n-- > 0)
  103feb:	85 c9                	test   %ecx,%ecx
  103fed:	7e 0d                	jle    103ffc <strncpy+0x3c>
  103fef:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  103ff2:	c6 02 00             	movb   $0x0,(%edx)
  103ff5:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  103ff8:	39 c2                	cmp    %eax,%edx
  103ffa:	75 f6                	jne    103ff2 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  103ffc:	89 f0                	mov    %esi,%eax
  103ffe:	5b                   	pop    %ebx
  103fff:	5e                   	pop    %esi
  104000:	5d                   	pop    %ebp
  104001:	c3                   	ret    
  104002:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104010 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104010:	55                   	push   %ebp
  104011:	89 e5                	mov    %esp,%ebp
  104013:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104016:	56                   	push   %esi
  104017:	8b 75 08             	mov    0x8(%ebp),%esi
  10401a:	53                   	push   %ebx
  10401b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  10401e:	85 c9                	test   %ecx,%ecx
  104020:	7e 1b                	jle    10403d <safestrcpy+0x2d>
  104022:	89 f2                	mov    %esi,%edx
  104024:	eb 03                	jmp    104029 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104026:	83 c3 01             	add    $0x1,%ebx
  104029:	83 e9 01             	sub    $0x1,%ecx
  10402c:	74 0c                	je     10403a <safestrcpy+0x2a>
  10402e:	0f b6 03             	movzbl (%ebx),%eax
  104031:	88 02                	mov    %al,(%edx)
  104033:	83 c2 01             	add    $0x1,%edx
  104036:	84 c0                	test   %al,%al
  104038:	75 ec                	jne    104026 <safestrcpy+0x16>
    ;
  *s = 0;
  10403a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10403d:	89 f0                	mov    %esi,%eax
  10403f:	5b                   	pop    %ebx
  104040:	5e                   	pop    %esi
  104041:	5d                   	pop    %ebp
  104042:	c3                   	ret    
  104043:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104050 <strlen>:

int
strlen(const char *s)
{
  104050:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104051:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104053:	89 e5                	mov    %esp,%ebp
  104055:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104058:	80 3a 00             	cmpb   $0x0,(%edx)
  10405b:	74 0c                	je     104069 <strlen+0x19>
  10405d:	8d 76 00             	lea    0x0(%esi),%esi
  104060:	83 c0 01             	add    $0x1,%eax
  104063:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  104067:	75 f7                	jne    104060 <strlen+0x10>
    ;
  return n;
}
  104069:	5d                   	pop    %ebp
  10406a:	c3                   	ret    
  10406b:	90                   	nop    

0010406c <swtch>:
  10406c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104070:	8f 00                	popl   (%eax)
  104072:	89 60 04             	mov    %esp,0x4(%eax)
  104075:	89 58 08             	mov    %ebx,0x8(%eax)
  104078:	89 48 0c             	mov    %ecx,0xc(%eax)
  10407b:	89 50 10             	mov    %edx,0x10(%eax)
  10407e:	89 70 14             	mov    %esi,0x14(%eax)
  104081:	89 78 18             	mov    %edi,0x18(%eax)
  104084:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104087:	8b 44 24 04          	mov    0x4(%esp),%eax
  10408b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10408e:	8b 78 18             	mov    0x18(%eax),%edi
  104091:	8b 70 14             	mov    0x14(%eax),%esi
  104094:	8b 50 10             	mov    0x10(%eax),%edx
  104097:	8b 48 0c             	mov    0xc(%eax),%ecx
  10409a:	8b 58 08             	mov    0x8(%eax),%ebx
  10409d:	8b 60 04             	mov    0x4(%eax),%esp
  1040a0:	ff 30                	pushl  (%eax)
  1040a2:	c3                   	ret    
  1040a3:	90                   	nop    
  1040a4:	90                   	nop    
  1040a5:	90                   	nop    
  1040a6:	90                   	nop    
  1040a7:	90                   	nop    
  1040a8:	90                   	nop    
  1040a9:	90                   	nop    
  1040aa:	90                   	nop    
  1040ab:	90                   	nop    
  1040ac:	90                   	nop    
  1040ad:	90                   	nop    
  1040ae:	90                   	nop    
  1040af:	90                   	nop    

001040b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1040b0:	55                   	push   %ebp
  1040b1:	89 e5                	mov    %esp,%ebp
  1040b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  1040b6:	8b 51 04             	mov    0x4(%ecx),%edx
  1040b9:	3b 55 0c             	cmp    0xc(%ebp),%edx
  1040bc:	77 07                	ja     1040c5 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  1040be:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1040bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1040c4:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1040c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040c8:	83 c0 04             	add    $0x4,%eax
  1040cb:	39 c2                	cmp    %eax,%edx
  1040cd:	72 ef                	jb     1040be <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1040cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040d2:	8b 01                	mov    (%ecx),%eax
  1040d4:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1040d7:	8b 55 10             	mov    0x10(%ebp),%edx
  1040da:	89 02                	mov    %eax,(%edx)
  1040dc:	31 c0                	xor    %eax,%eax
  return 0;
}
  1040de:	5d                   	pop    %ebp
  1040df:	c3                   	ret    

001040e0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1040e0:	55                   	push   %ebp
  1040e1:	89 e5                	mov    %esp,%ebp
  1040e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1040e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  1040e9:	39 50 04             	cmp    %edx,0x4(%eax)
  1040ec:	77 07                	ja     1040f5 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1040ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1040f3:	5d                   	pop    %ebp
  1040f4:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1040f5:	89 d1                	mov    %edx,%ecx
  1040f7:	8b 55 10             	mov    0x10(%ebp),%edx
  1040fa:	03 08                	add    (%eax),%ecx
  1040fc:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  1040fe:	8b 50 04             	mov    0x4(%eax),%edx
  104101:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  104103:	39 d1                	cmp    %edx,%ecx
  104105:	73 e7                	jae    1040ee <fetchstr+0xe>
    if(*s == 0)
  104107:	31 c0                	xor    %eax,%eax
  104109:	80 39 00             	cmpb   $0x0,(%ecx)
  10410c:	74 e5                	je     1040f3 <fetchstr+0x13>
  10410e:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104110:	83 c0 01             	add    $0x1,%eax
  104113:	39 d0                	cmp    %edx,%eax
  104115:	74 d7                	je     1040ee <fetchstr+0xe>
    if(*s == 0)
  104117:	80 38 00             	cmpb   $0x0,(%eax)
  10411a:	75 f4                	jne    104110 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  10411c:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10411d:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  10411f:	c3                   	ret    

00104120 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104120:	55                   	push   %ebp
  104121:	89 e5                	mov    %esp,%ebp
  104123:	53                   	push   %ebx
  104124:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104127:	e8 94 f0 ff ff       	call   1031c0 <curproc>
  10412c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10412f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104135:	8b 40 3c             	mov    0x3c(%eax),%eax
  104138:	83 c0 04             	add    $0x4,%eax
  10413b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  10413e:	e8 7d f0 ff ff       	call   1031c0 <curproc>
  104143:	8b 55 0c             	mov    0xc(%ebp),%edx
  104146:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10414a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10414e:	89 04 24             	mov    %eax,(%esp)
  104151:	e8 5a ff ff ff       	call   1040b0 <fetchint>
}
  104156:	83 c4 14             	add    $0x14,%esp
  104159:	5b                   	pop    %ebx
  10415a:	5d                   	pop    %ebp
  10415b:	c3                   	ret    
  10415c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104160 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104160:	55                   	push   %ebp
  104161:	89 e5                	mov    %esp,%ebp
  104163:	53                   	push   %ebx
  104164:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104167:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10416a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10416e:	8b 45 08             	mov    0x8(%ebp),%eax
  104171:	89 04 24             	mov    %eax,(%esp)
  104174:	e8 a7 ff ff ff       	call   104120 <argint>
  104179:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10417e:	85 c0                	test   %eax,%eax
  104180:	78 1d                	js     10419f <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  104182:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104185:	e8 36 f0 ff ff       	call   1031c0 <curproc>
  10418a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10418d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104191:	89 54 24 08          	mov    %edx,0x8(%esp)
  104195:	89 04 24             	mov    %eax,(%esp)
  104198:	e8 43 ff ff ff       	call   1040e0 <fetchstr>
  10419d:	89 c2                	mov    %eax,%edx
}
  10419f:	83 c4 24             	add    $0x24,%esp
  1041a2:	89 d0                	mov    %edx,%eax
  1041a4:	5b                   	pop    %ebx
  1041a5:	5d                   	pop    %ebp
  1041a6:	c3                   	ret    
  1041a7:	89 f6                	mov    %esi,%esi
  1041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001041b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	53                   	push   %ebx
  1041b4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1041b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1041ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1041be:	8b 45 08             	mov    0x8(%ebp),%eax
  1041c1:	89 04 24             	mov    %eax,(%esp)
  1041c4:	e8 57 ff ff ff       	call   104120 <argint>
  1041c9:	85 c0                	test   %eax,%eax
  1041cb:	79 0b                	jns    1041d8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1041cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1041d2:	83 c4 24             	add    $0x24,%esp
  1041d5:	5b                   	pop    %ebx
  1041d6:	5d                   	pop    %ebp
  1041d7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1041d8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1041db:	e8 e0 ef ff ff       	call   1031c0 <curproc>
  1041e0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1041e3:	73 e8                	jae    1041cd <argptr+0x1d>
  1041e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041e8:	01 45 10             	add    %eax,0x10(%ebp)
  1041eb:	e8 d0 ef ff ff       	call   1031c0 <curproc>
  1041f0:	8b 55 10             	mov    0x10(%ebp),%edx
  1041f3:	3b 50 04             	cmp    0x4(%eax),%edx
  1041f6:	73 d5                	jae    1041cd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1041f8:	e8 c3 ef ff ff       	call   1031c0 <curproc>
  1041fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  104200:	03 10                	add    (%eax),%edx
  104202:	8b 45 0c             	mov    0xc(%ebp),%eax
  104205:	89 10                	mov    %edx,(%eax)
  104207:	31 c0                	xor    %eax,%eax
  104209:	eb c7                	jmp    1041d2 <argptr+0x22>
  10420b:	90                   	nop    
  10420c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104210 <syscall>:
[SYS_kalloctest] sys_kalloctest,
};

void
syscall(void)
{
  104210:	55                   	push   %ebp
  104211:	89 e5                	mov    %esp,%ebp
  104213:	83 ec 18             	sub    $0x18,%esp
  104216:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104219:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  10421c:	e8 9f ef ff ff       	call   1031c0 <curproc>
  104221:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104227:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  10422a:	83 fb 15             	cmp    $0x15,%ebx
  10422d:	77 25                	ja     104254 <syscall+0x44>
  10422f:	8b 34 9d 00 65 10 00 	mov    0x106500(,%ebx,4),%esi
  104236:	85 f6                	test   %esi,%esi
  104238:	74 1a                	je     104254 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  10423a:	e8 81 ef ff ff       	call   1031c0 <curproc>
  10423f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104245:	ff d6                	call   *%esi
  104247:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10424a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10424d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104250:	89 ec                	mov    %ebp,%esp
  104252:	5d                   	pop    %ebp
  104253:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104254:	e8 67 ef ff ff       	call   1031c0 <curproc>
  104259:	89 c6                	mov    %eax,%esi
  10425b:	e8 60 ef ff ff       	call   1031c0 <curproc>
  104260:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  104266:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10426a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10426e:	8b 40 10             	mov    0x10(%eax),%eax
  104271:	c7 04 24 d6 64 10 00 	movl   $0x1064d6,(%esp)
  104278:	89 44 24 04          	mov    %eax,0x4(%esp)
  10427c:	e8 7f c4 ff ff       	call   100700 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104281:	e8 3a ef ff ff       	call   1031c0 <curproc>
  104286:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10428c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104293:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104296:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104299:	89 ec                	mov    %ebp,%esp
  10429b:	5d                   	pop    %ebp
  10429c:	c3                   	ret    
  10429d:	90                   	nop    
  10429e:	90                   	nop    
  10429f:	90                   	nop    

001042a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  1042a0:	55                   	push   %ebp
  1042a1:	89 e5                	mov    %esp,%ebp
  1042a3:	56                   	push   %esi
  1042a4:	89 c6                	mov    %eax,%esi
  1042a6:	53                   	push   %ebx
  1042a7:	31 db                	xor    %ebx,%ebx
  1042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  1042b0:	e8 0b ef ff ff       	call   1031c0 <curproc>
  1042b5:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  1042b9:	85 c0                	test   %eax,%eax
  1042bb:	74 13                	je     1042d0 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1042bd:	83 c3 01             	add    $0x1,%ebx
  1042c0:	83 fb 10             	cmp    $0x10,%ebx
  1042c3:	75 eb                	jne    1042b0 <fdalloc+0x10>
  1042c5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  1042ca:	89 d8                	mov    %ebx,%eax
  1042cc:	5b                   	pop    %ebx
  1042cd:	5e                   	pop    %esi
  1042ce:	5d                   	pop    %ebp
  1042cf:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  1042d0:	e8 eb ee ff ff       	call   1031c0 <curproc>
  1042d5:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  1042d9:	89 d8                	mov    %ebx,%eax
  1042db:	5b                   	pop    %ebx
  1042dc:	5e                   	pop    %esi
  1042dd:	5d                   	pop    %ebp
  1042de:	c3                   	ret    
  1042df:	90                   	nop    

001042e0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  1042e0:	55                   	push   %ebp
  1042e1:	89 e5                	mov    %esp,%ebp
  1042e3:	53                   	push   %ebx
  1042e4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  1042e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1042ea:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1042f1:	00 
  1042f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1042fd:	e8 ae fe ff ff       	call   1041b0 <argptr>
  104302:	85 c0                	test   %eax,%eax
  104304:	79 0b                	jns    104311 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10430b:	83 c4 24             	add    $0x24,%esp
  10430e:	5b                   	pop    %ebx
  10430f:	5d                   	pop    %ebp
  104310:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104314:	89 44 24 04          	mov    %eax,0x4(%esp)
  104318:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10431b:	89 04 24             	mov    %eax,(%esp)
  10431e:	e8 ed eb ff ff       	call   102f10 <pipealloc>
  104323:	85 c0                	test   %eax,%eax
  104325:	78 df                	js     104306 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10432a:	e8 71 ff ff ff       	call   1042a0 <fdalloc>
  10432f:	85 c0                	test   %eax,%eax
  104331:	89 c3                	mov    %eax,%ebx
  104333:	78 27                	js     10435c <sys_pipe+0x7c>
  104335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104338:	e8 63 ff ff ff       	call   1042a0 <fdalloc>
  10433d:	85 c0                	test   %eax,%eax
  10433f:	89 c2                	mov    %eax,%edx
  104341:	78 0c                	js     10434f <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104346:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  104348:	89 50 04             	mov    %edx,0x4(%eax)
  10434b:	31 c0                	xor    %eax,%eax
  10434d:	eb bc                	jmp    10430b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  10434f:	e8 6c ee ff ff       	call   1031c0 <curproc>
  104354:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  10435b:	00 
    fileclose(rf);
  10435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10435f:	89 04 24             	mov    %eax,(%esp)
  104362:	e8 f9 cb ff ff       	call   100f60 <fileclose>
    fileclose(wf);
  104367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10436a:	89 04 24             	mov    %eax,(%esp)
  10436d:	e8 ee cb ff ff       	call   100f60 <fileclose>
  104372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104377:	eb 92                	jmp    10430b <sys_pipe+0x2b>
  104379:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104380 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104380:	55                   	push   %ebp
  104381:	89 e5                	mov    %esp,%ebp
  104383:	83 ec 28             	sub    $0x28,%esp
  104386:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104389:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10438b:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  10438e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104391:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104393:	89 54 24 04          	mov    %edx,0x4(%esp)
  104397:	89 04 24             	mov    %eax,(%esp)
  10439a:	e8 81 fd ff ff       	call   104120 <argint>
  10439f:	85 c0                	test   %eax,%eax
  1043a1:	79 0f                	jns    1043b2 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  1043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  1043a8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1043ab:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1043ae:	89 ec                	mov    %ebp,%esp
  1043b0:	5d                   	pop    %ebp
  1043b1:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  1043b2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  1043b6:	77 eb                	ja     1043a3 <argfd+0x23>
  1043b8:	e8 03 ee ff ff       	call   1031c0 <curproc>
  1043bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1043c0:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  1043c4:	85 c9                	test   %ecx,%ecx
  1043c6:	74 db                	je     1043a3 <argfd+0x23>
    return -1;
  if(pfd)
  1043c8:	85 db                	test   %ebx,%ebx
  1043ca:	74 02                	je     1043ce <argfd+0x4e>
    *pfd = fd;
  1043cc:	89 13                	mov    %edx,(%ebx)
  if(pf)
  1043ce:	31 c0                	xor    %eax,%eax
  1043d0:	85 f6                	test   %esi,%esi
  1043d2:	74 d4                	je     1043a8 <argfd+0x28>
    *pf = f;
  1043d4:	89 0e                	mov    %ecx,(%esi)
  1043d6:	eb d0                	jmp    1043a8 <argfd+0x28>
  1043d8:	90                   	nop    
  1043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001043e0 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  1043e0:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1043e1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  1043e3:	89 e5                	mov    %esp,%ebp
  1043e5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1043e8:	8d 55 fc             	lea    -0x4(%ebp),%edx
  1043eb:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  1043ee:	e8 8d ff ff ff       	call   104380 <argfd>
  1043f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1043f8:	85 c0                	test   %eax,%eax
  1043fa:	78 1d                	js     104419 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  1043fc:	e8 bf ed ff ff       	call   1031c0 <curproc>
  104401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104404:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10440b:	00 
  fileclose(f);
  10440c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10440f:	89 04 24             	mov    %eax,(%esp)
  104412:	e8 49 cb ff ff       	call   100f60 <fileclose>
  104417:	31 d2                	xor    %edx,%edx
  return 0;
}
  104419:	c9                   	leave  
  10441a:	89 d0                	mov    %edx,%eax
  10441c:	c3                   	ret    
  10441d:	8d 76 00             	lea    0x0(%esi),%esi

00104420 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104420:	55                   	push   %ebp
  104421:	89 e5                	mov    %esp,%ebp
  104423:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104426:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104429:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10442c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10442f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104432:	89 44 24 04          	mov    %eax,0x4(%esp)
  104436:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10443d:	e8 1e fd ff ff       	call   104160 <argstr>
  104442:	85 c0                	test   %eax,%eax
  104444:	79 12                	jns    104458 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  10444b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10444e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104451:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104454:	89 ec                	mov    %ebp,%esp
  104456:	5d                   	pop    %ebp
  104457:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104458:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10445b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10445f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104466:	e8 b5 fc ff ff       	call   104120 <argint>
  10446b:	85 c0                	test   %eax,%eax
  10446d:	78 d7                	js     104446 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  10446f:	8d 45 98             	lea    -0x68(%ebp),%eax
  104472:	31 f6                	xor    %esi,%esi
  104474:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  10447b:	00 
  10447c:	31 ff                	xor    %edi,%edi
  10447e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104485:	00 
  104486:	89 04 24             	mov    %eax,(%esp)
  104489:	e8 c2 f9 ff ff       	call   103e50 <memset>
  10448e:	eb 27                	jmp    1044b7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104490:	e8 2b ed ff ff       	call   1031c0 <curproc>
  104495:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104499:	89 54 24 08          	mov    %edx,0x8(%esp)
  10449d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1044a1:	89 04 24             	mov    %eax,(%esp)
  1044a4:	e8 37 fc ff ff       	call   1040e0 <fetchstr>
  1044a9:	85 c0                	test   %eax,%eax
  1044ab:	78 99                	js     104446 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1044ad:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  1044b0:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1044b3:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  1044b5:	74 8f                	je     104446 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  1044b7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  1044be:	03 5d ec             	add    -0x14(%ebp),%ebx
  1044c1:	e8 fa ec ff ff       	call   1031c0 <curproc>
  1044c6:	8d 55 e8             	lea    -0x18(%ebp),%edx
  1044c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1044cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1044d1:	89 04 24             	mov    %eax,(%esp)
  1044d4:	e8 d7 fb ff ff       	call   1040b0 <fetchint>
  1044d9:	85 c0                	test   %eax,%eax
  1044db:	0f 88 65 ff ff ff    	js     104446 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  1044e1:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1044e4:	85 db                	test   %ebx,%ebx
  1044e6:	75 a8                	jne    104490 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1044e8:	8d 45 98             	lea    -0x68(%ebp),%eax
  1044eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  1044f2:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  1044f9:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1044fa:	89 04 24             	mov    %eax,(%esp)
  1044fd:	e8 3e c4 ff ff       	call   100940 <exec>
  104502:	e9 44 ff ff ff       	jmp    10444b <sys_exec+0x2b>
  104507:	89 f6                	mov    %esi,%esi
  104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104510 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	53                   	push   %ebx
  104514:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104517:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10451a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10451e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104525:	e8 36 fc ff ff       	call   104160 <argstr>
  10452a:	85 c0                	test   %eax,%eax
  10452c:	79 0b                	jns    104539 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  10452e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104533:	83 c4 24             	add    $0x24,%esp
  104536:	5b                   	pop    %ebx
  104537:	5d                   	pop    %ebp
  104538:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10453c:	89 04 24             	mov    %eax,(%esp)
  10453f:	e8 cc d8 ff ff       	call   101e10 <namei>
  104544:	85 c0                	test   %eax,%eax
  104546:	89 c3                	mov    %eax,%ebx
  104548:	74 e4                	je     10452e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  10454a:	89 04 24             	mov    %eax,(%esp)
  10454d:	e8 2e d6 ff ff       	call   101b80 <ilock>
  if(ip->type != T_DIR){
  104552:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104557:	75 24                	jne    10457d <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104559:	89 1c 24             	mov    %ebx,(%esp)
  10455c:	e8 af d5 ff ff       	call   101b10 <iunlock>
  iput(cp->cwd);
  104561:	e8 5a ec ff ff       	call   1031c0 <curproc>
  104566:	8b 40 60             	mov    0x60(%eax),%eax
  104569:	89 04 24             	mov    %eax,(%esp)
  10456c:	e8 6f d3 ff ff       	call   1018e0 <iput>
  cp->cwd = ip;
  104571:	e8 4a ec ff ff       	call   1031c0 <curproc>
  104576:	89 58 60             	mov    %ebx,0x60(%eax)
  104579:	31 c0                	xor    %eax,%eax
  10457b:	eb b6                	jmp    104533 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  10457d:	89 1c 24             	mov    %ebx,(%esp)
  104580:	e8 db d5 ff ff       	call   101b60 <iunlockput>
  104585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10458a:	eb a7                	jmp    104533 <sys_chdir+0x23>
  10458c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104590 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104596:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104599:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10459c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10459f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1045a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1045ad:	e8 ae fb ff ff       	call   104160 <argstr>
  1045b2:	85 c0                	test   %eax,%eax
  1045b4:	79 12                	jns    1045c8 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  1045b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1045bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1045be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1045c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1045c4:	89 ec                	mov    %ebp,%esp
  1045c6:	5d                   	pop    %ebp
  1045c7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1045c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1045cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045d6:	e8 85 fb ff ff       	call   104160 <argstr>
  1045db:	85 c0                	test   %eax,%eax
  1045dd:	78 d7                	js     1045b6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  1045df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045e2:	89 04 24             	mov    %eax,(%esp)
  1045e5:	e8 26 d8 ff ff       	call   101e10 <namei>
  1045ea:	85 c0                	test   %eax,%eax
  1045ec:	89 c3                	mov    %eax,%ebx
  1045ee:	74 c6                	je     1045b6 <sys_link+0x26>
    return -1;
  ilock(ip);
  1045f0:	89 04 24             	mov    %eax,(%esp)
  1045f3:	e8 88 d5 ff ff       	call   101b80 <ilock>
  if(ip->type == T_DIR){
  1045f8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1045fd:	74 58                	je     104657 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  1045ff:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104604:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104607:	89 1c 24             	mov    %ebx,(%esp)
  10460a:	e8 a1 cb ff ff       	call   1011b0 <iupdate>
  iunlock(ip);
  10460f:	89 1c 24             	mov    %ebx,(%esp)
  104612:	e8 f9 d4 ff ff       	call   101b10 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10461a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10461e:	89 04 24             	mov    %eax,(%esp)
  104621:	e8 ca d7 ff ff       	call   101df0 <nameiparent>
  104626:	85 c0                	test   %eax,%eax
  104628:	89 c6                	mov    %eax,%esi
  10462a:	74 16                	je     104642 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  10462c:	89 04 24             	mov    %eax,(%esp)
  10462f:	e8 4c d5 ff ff       	call   101b80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104634:	8b 06                	mov    (%esi),%eax
  104636:	3b 03                	cmp    (%ebx),%eax
  104638:	74 2a                	je     104664 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  10463a:	89 34 24             	mov    %esi,(%esp)
  10463d:	e8 1e d5 ff ff       	call   101b60 <iunlockput>
  ilock(ip);
  104642:	89 1c 24             	mov    %ebx,(%esp)
  104645:	e8 36 d5 ff ff       	call   101b80 <ilock>
  ip->nlink--;
  10464a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  10464f:	89 1c 24             	mov    %ebx,(%esp)
  104652:	e8 59 cb ff ff       	call   1011b0 <iupdate>
  iunlockput(ip);
  104657:	89 1c 24             	mov    %ebx,(%esp)
  10465a:	e8 01 d5 ff ff       	call   101b60 <iunlockput>
  10465f:	e9 52 ff ff ff       	jmp    1045b6 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104664:	8b 43 04             	mov    0x4(%ebx),%eax
  104667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10466b:	89 34 24             	mov    %esi,(%esp)
  10466e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104672:	e8 a9 d3 ff ff       	call   101a20 <dirlink>
  104677:	85 c0                	test   %eax,%eax
  104679:	78 bf                	js     10463a <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  10467b:	89 34 24             	mov    %esi,(%esp)
  10467e:	e8 dd d4 ff ff       	call   101b60 <iunlockput>
  iput(ip);
  104683:	89 1c 24             	mov    %ebx,(%esp)
  104686:	e8 55 d2 ff ff       	call   1018e0 <iput>
  10468b:	31 c0                	xor    %eax,%eax
  10468d:	e9 29 ff ff ff       	jmp    1045bb <sys_link+0x2b>
  104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001046a0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  1046a0:	55                   	push   %ebp
  1046a1:	89 e5                	mov    %esp,%ebp
  1046a3:	57                   	push   %edi
  1046a4:	89 d7                	mov    %edx,%edi
  1046a6:	56                   	push   %esi
  1046a7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046a8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  1046aa:	83 ec 3c             	sub    $0x3c,%esp
  1046ad:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  1046b1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  1046b5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  1046b9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  1046bd:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046c1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  1046c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046c8:	89 04 24             	mov    %eax,(%esp)
  1046cb:	e8 20 d7 ff ff       	call   101df0 <nameiparent>
  1046d0:	85 c0                	test   %eax,%eax
  1046d2:	89 c6                	mov    %eax,%esi
  1046d4:	74 5a                	je     104730 <create+0x90>
    return 0;
  ilock(dp);
  1046d6:	89 04 24             	mov    %eax,(%esp)
  1046d9:	e8 a2 d4 ff ff       	call   101b80 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  1046de:	85 ff                	test   %edi,%edi
  1046e0:	74 5e                	je     104740 <create+0xa0>
  1046e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1046e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046e9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1046ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046f0:	89 34 24             	mov    %esi,(%esp)
  1046f3:	e8 68 cf ff ff       	call   101660 <dirlookup>
  1046f8:	85 c0                	test   %eax,%eax
  1046fa:	89 c3                	mov    %eax,%ebx
  1046fc:	74 42                	je     104740 <create+0xa0>
    iunlockput(dp);
  1046fe:	89 34 24             	mov    %esi,(%esp)
  104701:	e8 5a d4 ff ff       	call   101b60 <iunlockput>
    ilock(ip);
  104706:	89 1c 24             	mov    %ebx,(%esp)
  104709:	e8 72 d4 ff ff       	call   101b80 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  10470e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104712:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104716:	75 0e                	jne    104726 <create+0x86>
  104718:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  10471c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104720:	0f 84 da 00 00 00    	je     104800 <create+0x160>
      iunlockput(ip);
  104726:	89 1c 24             	mov    %ebx,(%esp)
  104729:	31 db                	xor    %ebx,%ebx
  10472b:	e8 30 d4 ff ff       	call   101b60 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104730:	83 c4 3c             	add    $0x3c,%esp
  104733:	89 d8                	mov    %ebx,%eax
  104735:	5b                   	pop    %ebx
  104736:	5e                   	pop    %esi
  104737:	5f                   	pop    %edi
  104738:	5d                   	pop    %ebp
  104739:	c3                   	ret    
  10473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104740:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104744:	89 44 24 04          	mov    %eax,0x4(%esp)
  104748:	8b 06                	mov    (%esi),%eax
  10474a:	89 04 24             	mov    %eax,(%esp)
  10474d:	e8 0e d0 ff ff       	call   101760 <ialloc>
  104752:	85 c0                	test   %eax,%eax
  104754:	89 c3                	mov    %eax,%ebx
  104756:	74 47                	je     10479f <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104758:	89 04 24             	mov    %eax,(%esp)
  10475b:	e8 20 d4 ff ff       	call   101b80 <ilock>
  ip->major = major;
  104760:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  104764:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  104768:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  10476e:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104772:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104776:	89 1c 24             	mov    %ebx,(%esp)
  104779:	e8 32 ca ff ff       	call   1011b0 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  10477e:	8b 43 04             	mov    0x4(%ebx),%eax
  104781:	89 34 24             	mov    %esi,(%esp)
  104784:	89 44 24 08          	mov    %eax,0x8(%esp)
  104788:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  10478b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10478f:	e8 8c d2 ff ff       	call   101a20 <dirlink>
  104794:	85 c0                	test   %eax,%eax
  104796:	78 7b                	js     104813 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104798:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  10479d:	74 12                	je     1047b1 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  10479f:	89 34 24             	mov    %esi,(%esp)
  1047a2:	e8 b9 d3 ff ff       	call   101b60 <iunlockput>
  return ip;
}
  1047a7:	83 c4 3c             	add    $0x3c,%esp
  1047aa:	89 d8                	mov    %ebx,%eax
  1047ac:	5b                   	pop    %ebx
  1047ad:	5e                   	pop    %esi
  1047ae:	5f                   	pop    %edi
  1047af:	5d                   	pop    %ebp
  1047b0:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1047b1:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  1047b6:	89 34 24             	mov    %esi,(%esp)
  1047b9:	e8 f2 c9 ff ff       	call   1011b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1047be:	8b 43 04             	mov    0x4(%ebx),%eax
  1047c1:	c7 44 24 04 59 65 10 	movl   $0x106559,0x4(%esp)
  1047c8:	00 
  1047c9:	89 1c 24             	mov    %ebx,(%esp)
  1047cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047d0:	e8 4b d2 ff ff       	call   101a20 <dirlink>
  1047d5:	85 c0                	test   %eax,%eax
  1047d7:	78 1b                	js     1047f4 <create+0x154>
  1047d9:	8b 46 04             	mov    0x4(%esi),%eax
  1047dc:	c7 44 24 04 58 65 10 	movl   $0x106558,0x4(%esp)
  1047e3:	00 
  1047e4:	89 1c 24             	mov    %ebx,(%esp)
  1047e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047eb:	e8 30 d2 ff ff       	call   101a20 <dirlink>
  1047f0:	85 c0                	test   %eax,%eax
  1047f2:	79 ab                	jns    10479f <create+0xff>
      panic("create dots");
  1047f4:	c7 04 24 5b 65 10 00 	movl   $0x10655b,(%esp)
  1047fb:	e8 a0 c0 ff ff       	call   1008a0 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104800:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104804:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104808:	0f 85 18 ff ff ff    	jne    104726 <create+0x86>
  10480e:	e9 1d ff ff ff       	jmp    104730 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104813:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104819:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10481c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10481e:	e8 3d d3 ff ff       	call   101b60 <iunlockput>
    iunlockput(dp);
  104823:	89 34 24             	mov    %esi,(%esp)
  104826:	e8 35 d3 ff ff       	call   101b60 <iunlockput>
  10482b:	e9 00 ff ff ff       	jmp    104730 <create+0x90>

00104830 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104830:	55                   	push   %ebp
  104831:	89 e5                	mov    %esp,%ebp
  104833:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104836:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104839:	89 44 24 04          	mov    %eax,0x4(%esp)
  10483d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104844:	e8 17 f9 ff ff       	call   104160 <argstr>
  104849:	85 c0                	test   %eax,%eax
  10484b:	79 07                	jns    104854 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  10484d:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10484e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104853:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104857:	31 d2                	xor    %edx,%edx
  104859:	b9 01 00 00 00       	mov    $0x1,%ecx
  10485e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104865:	00 
  104866:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10486d:	e8 2e fe ff ff       	call   1046a0 <create>
  104872:	85 c0                	test   %eax,%eax
  104874:	74 d7                	je     10484d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104876:	89 04 24             	mov    %eax,(%esp)
  104879:	e8 e2 d2 ff ff       	call   101b60 <iunlockput>
  10487e:	31 c0                	xor    %eax,%eax
  return 0;
}
  104880:	c9                   	leave  
  104881:	c3                   	ret    
  104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104890 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  104890:	55                   	push   %ebp
  104891:	89 e5                	mov    %esp,%ebp
  104893:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104896:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104899:	89 44 24 04          	mov    %eax,0x4(%esp)
  10489d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048a4:	e8 b7 f8 ff ff       	call   104160 <argstr>
  1048a9:	85 c0                	test   %eax,%eax
  1048ab:	79 07                	jns    1048b4 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  1048ad:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1048ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048b3:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1048b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1048b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048c2:	e8 59 f8 ff ff       	call   104120 <argint>
  1048c7:	85 c0                	test   %eax,%eax
  1048c9:	78 e2                	js     1048ad <sys_mknod+0x1d>
  1048cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1048ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048d2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1048d9:	e8 42 f8 ff ff       	call   104120 <argint>
  1048de:	85 c0                	test   %eax,%eax
  1048e0:	78 cb                	js     1048ad <sys_mknod+0x1d>
  1048e2:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  1048e6:	b9 03 00 00 00       	mov    $0x3,%ecx
  1048eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1048ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048f2:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  1048f6:	89 14 24             	mov    %edx,(%esp)
  1048f9:	31 d2                	xor    %edx,%edx
  1048fb:	e8 a0 fd ff ff       	call   1046a0 <create>
  104900:	85 c0                	test   %eax,%eax
  104902:	74 a9                	je     1048ad <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104904:	89 04 24             	mov    %eax,(%esp)
  104907:	e8 54 d2 ff ff       	call   101b60 <iunlockput>
  10490c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10490e:	c9                   	leave  
  10490f:	90                   	nop    
  104910:	c3                   	ret    
  104911:	eb 0d                	jmp    104920 <sys_open>
  104913:	90                   	nop    
  104914:	90                   	nop    
  104915:	90                   	nop    
  104916:	90                   	nop    
  104917:	90                   	nop    
  104918:	90                   	nop    
  104919:	90                   	nop    
  10491a:	90                   	nop    
  10491b:	90                   	nop    
  10491c:	90                   	nop    
  10491d:	90                   	nop    
  10491e:	90                   	nop    
  10491f:	90                   	nop    

00104920 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104920:	55                   	push   %ebp
  104921:	89 e5                	mov    %esp,%ebp
  104923:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104926:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104929:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10492c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10492f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104932:	89 44 24 04          	mov    %eax,0x4(%esp)
  104936:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10493d:	e8 1e f8 ff ff       	call   104160 <argstr>
  104942:	85 c0                	test   %eax,%eax
  104944:	79 14                	jns    10495a <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  104946:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10494b:	89 d8                	mov    %ebx,%eax
  10494d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104950:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104953:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104956:	89 ec                	mov    %ebp,%esp
  104958:	5d                   	pop    %ebp
  104959:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10495a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10495d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104961:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104968:	e8 b3 f7 ff ff       	call   104120 <argint>
  10496d:	85 c0                	test   %eax,%eax
  10496f:	78 d5                	js     104946 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  104971:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  104975:	75 6c                	jne    1049e3 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10497a:	89 04 24             	mov    %eax,(%esp)
  10497d:	e8 8e d4 ff ff       	call   101e10 <namei>
  104982:	85 c0                	test   %eax,%eax
  104984:	89 c7                	mov    %eax,%edi
  104986:	74 be                	je     104946 <sys_open+0x26>
      return -1;
    ilock(ip);
  104988:	89 04 24             	mov    %eax,(%esp)
  10498b:	e8 f0 d1 ff ff       	call   101b80 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  104990:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  104995:	0f 84 8e 00 00 00    	je     104a29 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  10499b:	e8 30 c5 ff ff       	call   100ed0 <filealloc>
  1049a0:	85 c0                	test   %eax,%eax
  1049a2:	89 c6                	mov    %eax,%esi
  1049a4:	74 71                	je     104a17 <sys_open+0xf7>
  1049a6:	e8 f5 f8 ff ff       	call   1042a0 <fdalloc>
  1049ab:	85 c0                	test   %eax,%eax
  1049ad:	89 c3                	mov    %eax,%ebx
  1049af:	78 5e                	js     104a0f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1049b1:	89 3c 24             	mov    %edi,(%esp)
  1049b4:	e8 57 d1 ff ff       	call   101b10 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1049b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  1049bc:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  1049c2:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  1049c5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  1049cc:	89 d0                	mov    %edx,%eax
  1049ce:	83 f0 01             	xor    $0x1,%eax
  1049d1:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1049d4:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1049d7:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1049da:	0f 95 46 09          	setne  0x9(%esi)
  1049de:	e9 68 ff ff ff       	jmp    10494b <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  1049e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049e6:	b9 02 00 00 00       	mov    $0x2,%ecx
  1049eb:	ba 01 00 00 00       	mov    $0x1,%edx
  1049f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049f7:	00 
  1049f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1049ff:	e8 9c fc ff ff       	call   1046a0 <create>
  104a04:	85 c0                	test   %eax,%eax
  104a06:	89 c7                	mov    %eax,%edi
  104a08:	75 91                	jne    10499b <sys_open+0x7b>
  104a0a:	e9 37 ff ff ff       	jmp    104946 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104a0f:	89 34 24             	mov    %esi,(%esp)
  104a12:	e8 49 c5 ff ff       	call   100f60 <fileclose>
    iunlockput(ip);
  104a17:	89 3c 24             	mov    %edi,(%esp)
  104a1a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104a1f:	e8 3c d1 ff ff       	call   101b60 <iunlockput>
  104a24:	e9 22 ff ff ff       	jmp    10494b <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  104a29:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  104a2d:	0f 84 68 ff ff ff    	je     10499b <sys_open+0x7b>
  104a33:	eb e2                	jmp    104a17 <sys_open+0xf7>
  104a35:	8d 74 26 00          	lea    0x0(%esi),%esi
  104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104a40 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104a40:	55                   	push   %ebp
  104a41:	89 e5                	mov    %esp,%ebp
  104a43:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104a46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104a49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104a4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104a4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a5d:	e8 fe f6 ff ff       	call   104160 <argstr>
  104a62:	85 c0                	test   %eax,%eax
  104a64:	79 12                	jns    104a78 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104a66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104a6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104a6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104a71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104a74:	89 ec                	mov    %ebp,%esp
  104a76:	5d                   	pop    %ebp
  104a77:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a7b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  104a7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104a82:	89 04 24             	mov    %eax,(%esp)
  104a85:	e8 66 d3 ff ff       	call   101df0 <nameiparent>
  104a8a:	85 c0                	test   %eax,%eax
  104a8c:	89 c7                	mov    %eax,%edi
  104a8e:	74 d6                	je     104a66 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104a90:	89 04 24             	mov    %eax,(%esp)
  104a93:	e8 e8 d0 ff ff       	call   101b80 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104a98:	c7 44 24 04 59 65 10 	movl   $0x106559,0x4(%esp)
  104a9f:	00 
  104aa0:	89 1c 24             	mov    %ebx,(%esp)
  104aa3:	e8 88 cb ff ff       	call   101630 <namecmp>
  104aa8:	85 c0                	test   %eax,%eax
  104aaa:	74 14                	je     104ac0 <sys_unlink+0x80>
  104aac:	c7 44 24 04 58 65 10 	movl   $0x106558,0x4(%esp)
  104ab3:	00 
  104ab4:	89 1c 24             	mov    %ebx,(%esp)
  104ab7:	e8 74 cb ff ff       	call   101630 <namecmp>
  104abc:	85 c0                	test   %eax,%eax
  104abe:	75 0f                	jne    104acf <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  104ac0:	89 3c 24             	mov    %edi,(%esp)
  104ac3:	e8 98 d0 ff ff       	call   101b60 <iunlockput>
  104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104acd:	eb 9c                	jmp    104a6b <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104acf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104ad2:	89 44 24 08          	mov    %eax,0x8(%esp)
  104ad6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104ada:	89 3c 24             	mov    %edi,(%esp)
  104add:	e8 7e cb ff ff       	call   101660 <dirlookup>
  104ae2:	85 c0                	test   %eax,%eax
  104ae4:	89 c6                	mov    %eax,%esi
  104ae6:	74 d8                	je     104ac0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104ae8:	89 04 24             	mov    %eax,(%esp)
  104aeb:	e8 90 d0 ff ff       	call   101b80 <ilock>

  if(ip->nlink < 1)
  104af0:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104af5:	0f 8e be 00 00 00    	jle    104bb9 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104afb:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104b00:	75 4c                	jne    104b4e <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104b02:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104b06:	76 46                	jbe    104b4e <sys_unlink+0x10e>
  104b08:	bb 20 00 00 00       	mov    $0x20,%ebx
  104b0d:	8d 76 00             	lea    0x0(%esi),%esi
  104b10:	eb 08                	jmp    104b1a <sys_unlink+0xda>
  104b12:	83 c3 10             	add    $0x10,%ebx
  104b15:	39 5e 18             	cmp    %ebx,0x18(%esi)
  104b18:	76 34                	jbe    104b4e <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104b1a:	8d 45 be             	lea    -0x42(%ebp),%eax
  104b1d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104b24:	00 
  104b25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b2d:	89 34 24             	mov    %esi,(%esp)
  104b30:	e8 eb c9 ff ff       	call   101520 <readi>
  104b35:	83 f8 10             	cmp    $0x10,%eax
  104b38:	75 73                	jne    104bad <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104b3a:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  104b3f:	74 d1                	je     104b12 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104b41:	89 34 24             	mov    %esi,(%esp)
  104b44:	e8 17 d0 ff ff       	call   101b60 <iunlockput>
  104b49:	e9 72 ff ff ff       	jmp    104ac0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  104b4e:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  104b51:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104b58:	00 
  104b59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b60:	00 
  104b61:	89 1c 24             	mov    %ebx,(%esp)
  104b64:	e8 e7 f2 ff ff       	call   103e50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b6c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104b73:	00 
  104b74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104b78:	89 3c 24             	mov    %edi,(%esp)
  104b7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  104b7f:	e8 6c c8 ff ff       	call   1013f0 <writei>
  104b84:	83 f8 10             	cmp    $0x10,%eax
  104b87:	75 3c                	jne    104bc5 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  104b89:	89 3c 24             	mov    %edi,(%esp)
  104b8c:	e8 cf cf ff ff       	call   101b60 <iunlockput>

  ip->nlink--;
  104b91:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104b96:	89 34 24             	mov    %esi,(%esp)
  104b99:	e8 12 c6 ff ff       	call   1011b0 <iupdate>
  iunlockput(ip);
  104b9e:	89 34 24             	mov    %esi,(%esp)
  104ba1:	e8 ba cf ff ff       	call   101b60 <iunlockput>
  104ba6:	31 c0                	xor    %eax,%eax
  104ba8:	e9 be fe ff ff       	jmp    104a6b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104bad:	c7 04 24 79 65 10 00 	movl   $0x106579,(%esp)
  104bb4:	e8 e7 bc ff ff       	call   1008a0 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104bb9:	c7 04 24 67 65 10 00 	movl   $0x106567,(%esp)
  104bc0:	e8 db bc ff ff       	call   1008a0 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104bc5:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  104bcc:	e8 cf bc ff ff       	call   1008a0 <panic>
  104bd1:	eb 0d                	jmp    104be0 <sys_fstat>
  104bd3:	90                   	nop    
  104bd4:	90                   	nop    
  104bd5:	90                   	nop    
  104bd6:	90                   	nop    
  104bd7:	90                   	nop    
  104bd8:	90                   	nop    
  104bd9:	90                   	nop    
  104bda:	90                   	nop    
  104bdb:	90                   	nop    
  104bdc:	90                   	nop    
  104bdd:	90                   	nop    
  104bde:	90                   	nop    
  104bdf:	90                   	nop    

00104be0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  104be0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104be1:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  104be3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104be5:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  104be7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104bea:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104bed:	e8 8e f7 ff ff       	call   104380 <argfd>
  104bf2:	85 c0                	test   %eax,%eax
  104bf4:	79 07                	jns    104bfd <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  104bf6:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  104bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104bfc:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104bfd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c00:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104c07:	00 
  104c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c13:	e8 98 f5 ff ff       	call   1041b0 <argptr>
  104c18:	85 c0                	test   %eax,%eax
  104c1a:	78 da                	js     104bf6 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  104c1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104c26:	89 04 24             	mov    %eax,(%esp)
  104c29:	e8 02 c2 ff ff       	call   100e30 <filestat>
}
  104c2e:	c9                   	leave  
  104c2f:	c3                   	ret    

00104c30 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  104c30:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104c31:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  104c33:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104c35:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  104c37:	53                   	push   %ebx
  104c38:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104c3b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104c3e:	e8 3d f7 ff ff       	call   104380 <argfd>
  104c43:	85 c0                	test   %eax,%eax
  104c45:	79 0d                	jns    104c54 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  104c47:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  104c4c:	89 d8                	mov    %ebx,%eax
  104c4e:	83 c4 14             	add    $0x14,%esp
  104c51:	5b                   	pop    %ebx
  104c52:	5d                   	pop    %ebp
  104c53:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104c54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c57:	e8 44 f6 ff ff       	call   1042a0 <fdalloc>
  104c5c:	85 c0                	test   %eax,%eax
  104c5e:	89 c3                	mov    %eax,%ebx
  104c60:	78 e5                	js     104c47 <sys_dup+0x17>
    return -1;
  filedup(f);
  104c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c65:	89 04 24             	mov    %eax,(%esp)
  104c68:	e8 13 c2 ff ff       	call   100e80 <filedup>
  104c6d:	eb dd                	jmp    104c4c <sys_dup+0x1c>
  104c6f:	90                   	nop    

00104c70 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104c70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104c71:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104c73:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104c75:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104c77:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104c7a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104c7d:	e8 fe f6 ff ff       	call   104380 <argfd>
  104c82:	85 c0                	test   %eax,%eax
  104c84:	79 07                	jns    104c8d <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  104c86:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  104c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c8c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104c8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c94:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104c9b:	e8 80 f4 ff ff       	call   104120 <argint>
  104ca0:	85 c0                	test   %eax,%eax
  104ca2:	78 e2                	js     104c86 <sys_write+0x16>
  104ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104ca7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cae:	89 44 24 08          	mov    %eax,0x8(%esp)
  104cb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cb9:	e8 f2 f4 ff ff       	call   1041b0 <argptr>
  104cbe:	85 c0                	test   %eax,%eax
  104cc0:	78 c4                	js     104c86 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  104cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  104cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104cd3:	89 04 24             	mov    %eax,(%esp)
  104cd6:	e8 15 c0 ff ff       	call   100cf0 <filewrite>
}
  104cdb:	c9                   	leave  
  104cdc:	c3                   	ret    
  104cdd:	8d 76 00             	lea    0x0(%esi),%esi

00104ce0 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  104ce0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104ce1:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  104ce3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104ce5:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  104ce7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104cea:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104ced:	e8 8e f6 ff ff       	call   104380 <argfd>
  104cf2:	85 c0                	test   %eax,%eax
  104cf4:	79 07                	jns    104cfd <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  104cf6:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  104cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104cfc:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104cfd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d04:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104d0b:	e8 10 f4 ff ff       	call   104120 <argint>
  104d10:	85 c0                	test   %eax,%eax
  104d12:	78 e2                	js     104cf6 <sys_read+0x16>
  104d14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d29:	e8 82 f4 ff ff       	call   1041b0 <argptr>
  104d2e:	85 c0                	test   %eax,%eax
  104d30:	78 c4                	js     104cf6 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  104d32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d35:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104d43:	89 04 24             	mov    %eax,(%esp)
  104d46:	e8 45 c0 ff ff       	call   100d90 <fileread>
}
  104d4b:	c9                   	leave  
  104d4c:	c3                   	ret    
  104d4d:	90                   	nop    
  104d4e:	90                   	nop    
  104d4f:	90                   	nop    

00104d50 <sys_kalloctest>:
		struct ktest * nextk;
};

int
sys_kalloctest(void)
{
  104d50:	55                   	push   %ebp
  104d51:	89 e5                	mov    %esp,%ebp
  104d53:	57                   	push   %edi
  104d54:	56                   	push   %esi
  104d55:	53                   	push   %ebx
   cprintf("address ret %x\n", test);
   int k;
   for(k = 0; k < 16; k++)
{
	test[k] = 'a';
	cprintf("contents of test at %d: %s \n", k,test);
  104d56:	bb 01 00 00 00       	mov    $0x1,%ebx
		struct ktest * nextk;
};

int
sys_kalloctest(void)
{
  104d5b:	83 ec 1c             	sub    $0x1c,%esp
  sz1 = 15;
  sz2 = 27;
  sz3 = 45;
  sz4 = 8898970;
  
   cprintf("Kallocing test %d\n", sz1);
  104d5e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  104d65:	00 
  104d66:	c7 04 24 9a 65 10 00 	movl   $0x10659a,(%esp)
  104d6d:	e8 8e b9 ff ff       	call   100700 <cprintf>
   char * test = kalloc(sz1);
  104d72:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
  104d79:	e8 72 d4 ff ff       	call   1021f0 <kalloc>
   memset(test,0, sz1);
  104d7e:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
  104d85:	00 
  104d86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d8d:	00 
  sz2 = 27;
  sz3 = 45;
  sz4 = 8898970;
  
   cprintf("Kallocing test %d\n", sz1);
   char * test = kalloc(sz1);
  104d8e:	89 c7                	mov    %eax,%edi
   memset(test,0, sz1);
  104d90:	89 04 24             	mov    %eax,(%esp)
  104d93:	e8 b8 f0 ff ff       	call   103e50 <memset>
   cprintf("address ret %x\n", test);
  104d98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d9c:	c7 04 24 ad 65 10 00 	movl   $0x1065ad,(%esp)
  104da3:	e8 58 b9 ff ff       	call   100700 <cprintf>
   int k;
   for(k = 0; k < 16; k++)
{
	test[k] = 'a';
  104da8:	c6 07 61             	movb   $0x61,(%edi)
	cprintf("contents of test at %d: %s \n", k,test);
  104dab:	89 7c 24 08          	mov    %edi,0x8(%esp)
  104daf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104db6:	00 
  104db7:	c7 04 24 bd 65 10 00 	movl   $0x1065bd,(%esp)
  104dbe:	e8 3d b9 ff ff       	call   100700 <cprintf>
   memset(test,0, sz1);
   cprintf("address ret %x\n", test);
   int k;
   for(k = 0; k < 16; k++)
{
	test[k] = 'a';
  104dc3:	c6 04 3b 61          	movb   $0x61,(%ebx,%edi,1)
	cprintf("contents of test at %d: %s \n", k,test);
  104dc7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
   cprintf("Kallocing test %d\n", sz1);
   char * test = kalloc(sz1);
   memset(test,0, sz1);
   cprintf("address ret %x\n", test);
   int k;
   for(k = 0; k < 16; k++)
  104dcb:	83 c3 01             	add    $0x1,%ebx
{
	test[k] = 'a';
	cprintf("contents of test at %d: %s \n", k,test);
  104dce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  104dd2:	c7 04 24 bd 65 10 00 	movl   $0x1065bd,(%esp)
  104dd9:	e8 22 b9 ff ff       	call   100700 <cprintf>
   cprintf("Kallocing test %d\n", sz1);
   char * test = kalloc(sz1);
   memset(test,0, sz1);
   cprintf("address ret %x\n", test);
   int k;
   for(k = 0; k < 16; k++)
  104dde:	83 fb 10             	cmp    $0x10,%ebx
  104de1:	75 e0                	jne    104dc3 <sys_kalloctest+0x73>
{
	test[k] = 'a';
	cprintf("contents of test at %d: %s \n", k,test);
}

cprintf("Kallocing space for 3 ktest structs: %d bytes\n", sizeof(struct ktest)*3);
  104de3:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  104dea:	00 
  104deb:	c7 04 24 34 66 10 00 	movl   $0x106634,(%esp)
  104df2:	e8 09 b9 ff ff       	call   100700 <cprintf>

ktst = kalloc(sizeof(struct ktest));
  104df7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  104dfe:	e8 ed d3 ff ff       	call   1021f0 <kalloc>
ktst1 = kalloc(sizeof(struct ktest));
  104e03:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	cprintf("contents of test at %d: %s \n", k,test);
}

cprintf("Kallocing space for 3 ktest structs: %d bytes\n", sizeof(struct ktest)*3);

ktst = kalloc(sizeof(struct ktest));
  104e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
ktst1 = kalloc(sizeof(struct ktest));
  104e0d:	e8 de d3 ff ff       	call   1021f0 <kalloc>
ktst2 = kalloc(sizeof(struct ktest));
  104e12:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
}

cprintf("Kallocing space for 3 ktest structs: %d bytes\n", sizeof(struct ktest)*3);

ktst = kalloc(sizeof(struct ktest));
ktst1 = kalloc(sizeof(struct ktest));
  104e19:	89 c3                	mov    %eax,%ebx
ktst2 = kalloc(sizeof(struct ktest));
  104e1b:	e8 d0 d3 ff ff       	call   1021f0 <kalloc>
  104e20:	89 c6                	mov    %eax,%esi

ktst->number = sz2;
  104e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
ktst1->number = sz3;
ktst2->number = sz4;
ktst->nextk = ktst1;
  104e25:	89 58 04             	mov    %ebx,0x4(%eax)

ktst = kalloc(sizeof(struct ktest));
ktst1 = kalloc(sizeof(struct ktest));
ktst2 = kalloc(sizeof(struct ktest));

ktst->number = sz2;
  104e28:	c7 00 1b 00 00 00    	movl   $0x1b,(%eax)
ktst1->number = sz3;
ktst2->number = sz4;
ktst->nextk = ktst1;
ktst1->nextk = ktst2;
  104e2e:	89 73 04             	mov    %esi,0x4(%ebx)
ktst = kalloc(sizeof(struct ktest));
ktst1 = kalloc(sizeof(struct ktest));
ktst2 = kalloc(sizeof(struct ktest));

ktst->number = sz2;
ktst1->number = sz3;
  104e31:	c7 03 2d 00 00 00    	movl   $0x2d,(%ebx)
ktst2->number = sz4;
ktst->nextk = ktst1;
ktst1->nextk = ktst2;
ktst2->nextk = ktst;
  104e37:	89 46 04             	mov    %eax,0x4(%esi)
ktst1 = kalloc(sizeof(struct ktest));
ktst2 = kalloc(sizeof(struct ktest));

ktst->number = sz2;
ktst1->number = sz3;
ktst2->number = sz4;
  104e3a:	c7 06 9a c9 87 00    	movl   $0x87c99a,(%esi)
ktst->nextk = ktst1;
ktst1->nextk = ktst2;
ktst2->nextk = ktst;

cprintf("addresses: ktst - %x, ktst1 - %x, ktst2 - %x\n", ktst, ktst1, ktst2);
  104e40:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104e44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e4c:	c7 04 24 64 66 10 00 	movl   $0x106664,(%esp)
  104e53:	e8 a8 b8 ff ff       	call   100700 <cprintf>
cprintf("ktst data: num - %d, ptr - %x\n",ktst->number, ktst->nextk);
  104e58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104e5b:	8b 42 04             	mov    0x4(%edx),%eax
  104e5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e62:	8b 02                	mov    (%edx),%eax
  104e64:	c7 04 24 94 66 10 00 	movl   $0x106694,(%esp)
  104e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e6f:	e8 8c b8 ff ff       	call   100700 <cprintf>
cprintf("ktst1 data: num - %d, ptr - %x\n",ktst1->number, ktst1->nextk);
  104e74:	8b 43 04             	mov    0x4(%ebx),%eax
  104e77:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e7b:	8b 03                	mov    (%ebx),%eax
  104e7d:	c7 04 24 b4 66 10 00 	movl   $0x1066b4,(%esp)
  104e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e88:	e8 73 b8 ff ff       	call   100700 <cprintf>
cprintf("ktst2 data: num - %d, ptr - %x\n",ktst2->number, ktst2->nextk);
  104e8d:	8b 46 04             	mov    0x4(%esi),%eax
  104e90:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e94:	8b 06                	mov    (%esi),%eax
  104e96:	c7 04 24 d4 66 10 00 	movl   $0x1066d4,(%esp)
  104e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ea1:	e8 5a b8 ff ff       	call   100700 <cprintf>

cprintf("freeing everything\n");
  104ea6:	c7 04 24 da 65 10 00 	movl   $0x1065da,(%esp)
  104ead:	e8 4e b8 ff ff       	call   100700 <cprintf>
cprintf("kfree test\n");
  104eb2:	c7 04 24 ee 65 10 00 	movl   $0x1065ee,(%esp)
  104eb9:	e8 42 b8 ff ff       	call   100700 <cprintf>
kfree(test, sz1);
  104ebe:	89 3c 24             	mov    %edi,(%esp)
  104ec1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  104ec8:	00 
  104ec9:	e8 d2 d3 ff ff       	call   1022a0 <kfree>
cprintf("kfree ktst1\n");
  104ece:	c7 04 24 fa 65 10 00 	movl   $0x1065fa,(%esp)
  104ed5:	e8 26 b8 ff ff       	call   100700 <cprintf>
kfree(ktst1, sizeof(struct ktest));
  104eda:	89 1c 24             	mov    %ebx,(%esp)
  104edd:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  104ee4:	00 
  104ee5:	e8 b6 d3 ff ff       	call   1022a0 <kfree>
cprintf("kfree ktst2\n");
  104eea:	c7 04 24 07 66 10 00 	movl   $0x106607,(%esp)
  104ef1:	e8 0a b8 ff ff       	call   100700 <cprintf>
kfree(ktst2, sizeof(struct ktest));
  104ef6:	89 34 24             	mov    %esi,(%esp)
  104ef9:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  104f00:	00 
  104f01:	e8 9a d3 ff ff       	call   1022a0 <kfree>
cprintf("kfree ktst\n");
  104f06:	c7 04 24 14 66 10 00 	movl   $0x106614,(%esp)
  104f0d:	e8 ee b7 ff ff       	call   100700 <cprintf>
kfree(ktst, sizeof(struct ktest));
  104f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f15:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  104f1c:	00 
  104f1d:	89 04 24             	mov    %eax,(%esp)
  104f20:	e8 7b d3 ff ff       	call   1022a0 <kfree>

cprintf("THAT'S ALL FOLKS!\n");
  104f25:	c7 04 24 20 66 10 00 	movl   $0x106620,(%esp)
  104f2c:	e8 cf b7 ff ff       	call   100700 <cprintf>
return 0;
}
  104f31:	83 c4 1c             	add    $0x1c,%esp
  104f34:	31 c0                	xor    %eax,%eax
  104f36:	5b                   	pop    %ebx
  104f37:	5e                   	pop    %esi
  104f38:	5f                   	pop    %edi
  104f39:	5d                   	pop    %ebp
  104f3a:	c3                   	ret    
  104f3b:	90                   	nop    
  104f3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104f40 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  104f40:	55                   	push   %ebp
  104f41:	89 e5                	mov    %esp,%ebp
  104f43:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  104f46:	e8 75 e2 ff ff       	call   1031c0 <curproc>
  104f4b:	8b 40 10             	mov    0x10(%eax),%eax
}
  104f4e:	c9                   	leave  
  104f4f:	c3                   	ret    

00104f50 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  104f50:	55                   	push   %ebp
  104f51:	89 e5                	mov    %esp,%ebp
  104f53:	53                   	push   %ebx
  104f54:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  104f57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f65:	e8 b6 f1 ff ff       	call   104120 <argint>
  104f6a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104f6f:	85 c0                	test   %eax,%eax
  104f71:	78 5a                	js     104fcd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  104f73:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
  104f7a:	e8 71 ee ff ff       	call   103df0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104f7f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  104f82:	8b 1d c0 df 10 00    	mov    0x10dfc0,%ebx
  while(ticks - ticks0 < n){
  104f88:	85 d2                	test   %edx,%edx
  104f8a:	7f 24                	jg     104fb0 <sys_sleep+0x60>
  104f8c:	eb 47                	jmp    104fd5 <sys_sleep+0x85>
  104f8e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  104f90:	c7 44 24 04 80 d7 10 	movl   $0x10d780,0x4(%esp)
  104f97:	00 
  104f98:	c7 04 24 c0 df 10 00 	movl   $0x10dfc0,(%esp)
  104f9f:	e8 1c e4 ff ff       	call   1033c0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104fa4:	a1 c0 df 10 00       	mov    0x10dfc0,%eax
  104fa9:	29 d8                	sub    %ebx,%eax
  104fab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  104fae:	7d 25                	jge    104fd5 <sys_sleep+0x85>
    if(cp->killed){
  104fb0:	e8 0b e2 ff ff       	call   1031c0 <curproc>
  104fb5:	8b 40 1c             	mov    0x1c(%eax),%eax
  104fb8:	85 c0                	test   %eax,%eax
  104fba:	74 d4                	je     104f90 <sys_sleep+0x40>
      release(&tickslock);
  104fbc:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
  104fc3:	e8 e8 ed ff ff       	call   103db0 <release>
  104fc8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  104fcd:	83 c4 24             	add    $0x24,%esp
  104fd0:	89 d0                	mov    %edx,%eax
  104fd2:	5b                   	pop    %ebx
  104fd3:	5d                   	pop    %ebp
  104fd4:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  104fd5:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
  104fdc:	e8 cf ed ff ff       	call   103db0 <release>
  return 0;
}
  104fe1:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  104fe4:	31 d2                	xor    %edx,%edx
  return 0;
}
  104fe6:	5b                   	pop    %ebx
  104fe7:	89 d0                	mov    %edx,%eax
  104fe9:	5d                   	pop    %ebp
  104fea:	c3                   	ret    
  104feb:	90                   	nop    
  104fec:	8d 74 26 00          	lea    0x0(%esi),%esi

00104ff0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  104ff3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  104ff6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ffd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105004:	e8 17 f1 ff ff       	call   104120 <argint>
  105009:	85 c0                	test   %eax,%eax
  10500b:	79 07                	jns    105014 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  10500d:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  10500e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105013:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105017:	89 04 24             	mov    %eax,(%esp)
  10501a:	e8 91 e8 ff ff       	call   1038b0 <growproc>
  10501f:	85 c0                	test   %eax,%eax
  105021:	78 ea                	js     10500d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105023:	c9                   	leave  
  105024:	c3                   	ret    
  105025:	8d 74 26 00          	lea    0x0(%esi),%esi
  105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105030 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105030:	55                   	push   %ebp
  105031:	89 e5                	mov    %esp,%ebp
  105033:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105036:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105039:	89 44 24 04          	mov    %eax,0x4(%esp)
  10503d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105044:	e8 d7 f0 ff ff       	call   104120 <argint>
  105049:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10504e:	85 c0                	test   %eax,%eax
  105050:	78 0d                	js     10505f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105055:	89 04 24             	mov    %eax,(%esp)
  105058:	e8 b3 e0 ff ff       	call   103110 <kill>
  10505d:	89 c2                	mov    %eax,%edx
}
  10505f:	c9                   	leave  
  105060:	89 d0                	mov    %edx,%eax
  105062:	c3                   	ret    
  105063:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105070 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  105070:	55                   	push   %ebp
  105071:	89 e5                	mov    %esp,%ebp
  return wait();
}
  105073:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  105074:	e9 17 e4 ff ff       	jmp    103490 <wait>
  105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105080 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105080:	55                   	push   %ebp
  105081:	89 e5                	mov    %esp,%ebp
  105083:	83 ec 08             	sub    $0x8,%esp
  exit();
  105086:	e8 35 e2 ff ff       	call   1032c0 <exit>
  return 0;  // not reached
}
  10508b:	31 c0                	xor    %eax,%eax
  10508d:	c9                   	leave  
  10508e:	c3                   	ret    
  10508f:	90                   	nop    

00105090 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105090:	55                   	push   %ebp
  105091:	89 e5                	mov    %esp,%ebp
  105093:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105096:	e8 25 e1 ff ff       	call   1031c0 <curproc>
  10509b:	89 04 24             	mov    %eax,(%esp)
  10509e:	e8 cd e8 ff ff       	call   103970 <copyproc>
  1050a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1050a8:	85 c0                	test   %eax,%eax
  1050aa:	74 0a                	je     1050b6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1050ac:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1050af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1050b6:	c9                   	leave  
  1050b7:	89 d0                	mov    %edx,%eax
  1050b9:	c3                   	ret    
  1050ba:	90                   	nop    
  1050bb:	90                   	nop    
  1050bc:	90                   	nop    
  1050bd:	90                   	nop    
  1050be:	90                   	nop    
  1050bf:	90                   	nop    

001050c0 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  1050c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1050c1:	b8 34 00 00 00       	mov    $0x34,%eax
  1050c6:	89 e5                	mov    %esp,%ebp
  1050c8:	ba 43 00 00 00       	mov    $0x43,%edx
  1050cd:	83 ec 08             	sub    $0x8,%esp
  1050d0:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  1050d1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  1050d6:	b2 40                	mov    $0x40,%dl
  1050d8:	ee                   	out    %al,(%dx)
  1050d9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  1050de:	ee                   	out    %al,(%dx)
  1050df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050e6:	e8 15 db ff ff       	call   102c00 <pic_enable>
}
  1050eb:	c9                   	leave  
  1050ec:	c3                   	ret    
  1050ed:	90                   	nop    
  1050ee:	90                   	nop    
  1050ef:	90                   	nop    

001050f0 <alltraps>:
  1050f0:	1e                   	push   %ds
  1050f1:	06                   	push   %es
  1050f2:	60                   	pusha  
  1050f3:	b8 10 00 00 00       	mov    $0x10,%eax
  1050f8:	8e d8                	mov    %eax,%ds
  1050fa:	8e c0                	mov    %eax,%es
  1050fc:	54                   	push   %esp
  1050fd:	e8 4e 00 00 00       	call   105150 <trap>
  105102:	83 c4 04             	add    $0x4,%esp

00105105 <trapret>:
  105105:	61                   	popa   
  105106:	07                   	pop    %es
  105107:	1f                   	pop    %ds
  105108:	83 c4 08             	add    $0x8,%esp
  10510b:	cf                   	iret   

0010510c <forkret1>:
  10510c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105110:	e9 f0 ff ff ff       	jmp    105105 <trapret>
  105115:	90                   	nop    
  105116:	90                   	nop    
  105117:	90                   	nop    
  105118:	90                   	nop    
  105119:	90                   	nop    
  10511a:	90                   	nop    
  10511b:	90                   	nop    
  10511c:	90                   	nop    
  10511d:	90                   	nop    
  10511e:	90                   	nop    
  10511f:	90                   	nop    

00105120 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105120:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105121:	b8 c0 d7 10 00       	mov    $0x10d7c0,%eax
  105126:	89 e5                	mov    %esp,%ebp
  105128:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10512b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105131:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105135:	c1 e8 10             	shr    $0x10,%eax
  105138:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10513c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10513f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105142:	c9                   	leave  
  105143:	c3                   	ret    
  105144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10514a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105150 <trap>:

void
trap(struct trapframe *tf)
{
  105150:	55                   	push   %ebp
  105151:	89 e5                	mov    %esp,%ebp
  105153:	83 ec 38             	sub    $0x38,%esp
  105156:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105159:	8b 7d 08             	mov    0x8(%ebp),%edi
  10515c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10515f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  105162:	8b 47 28             	mov    0x28(%edi),%eax
  105165:	83 f8 30             	cmp    $0x30,%eax
  105168:	0f 84 52 01 00 00    	je     1052c0 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10516e:	83 f8 21             	cmp    $0x21,%eax
  105171:	0f 84 39 01 00 00    	je     1052b0 <trap+0x160>
  105177:	0f 86 8b 00 00 00    	jbe    105208 <trap+0xb8>
  10517d:	83 f8 2e             	cmp    $0x2e,%eax
  105180:	0f 84 e1 00 00 00    	je     105267 <trap+0x117>
  105186:	83 f8 3f             	cmp    $0x3f,%eax
  105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105190:	75 7b                	jne    10520d <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105192:	8b 5f 30             	mov    0x30(%edi),%ebx
  105195:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  105199:	e8 c2 d4 ff ff       	call   102660 <cpu>
  10519e:	c7 04 24 f4 66 10 00 	movl   $0x1066f4,(%esp)
  1051a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051a9:	89 74 24 08          	mov    %esi,0x8(%esp)
  1051ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051b1:	e8 4a b5 ff ff       	call   100700 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  1051b6:	e8 25 d4 ff ff       	call   1025e0 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  1051bb:	e8 00 e0 ff ff       	call   1031c0 <curproc>
  1051c0:	85 c0                	test   %eax,%eax
  1051c2:	74 1e                	je     1051e2 <trap+0x92>
  1051c4:	e8 f7 df ff ff       	call   1031c0 <curproc>
  1051c9:	8b 40 1c             	mov    0x1c(%eax),%eax
  1051cc:	85 c0                	test   %eax,%eax
  1051ce:	66 90                	xchg   %ax,%ax
  1051d0:	74 10                	je     1051e2 <trap+0x92>
  1051d2:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  1051d6:	83 e0 03             	and    $0x3,%eax
  1051d9:	83 f8 03             	cmp    $0x3,%eax
  1051dc:	0f 84 98 01 00 00    	je     10537a <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  1051e2:	e8 d9 df ff ff       	call   1031c0 <curproc>
  1051e7:	85 c0                	test   %eax,%eax
  1051e9:	74 10                	je     1051fb <trap+0xab>
  1051eb:	90                   	nop    
  1051ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  1051f0:	e8 cb df ff ff       	call   1031c0 <curproc>
  1051f5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1051f9:	74 55                	je     105250 <trap+0x100>
    yield();
}
  1051fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1051fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105201:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105204:	89 ec                	mov    %ebp,%esp
  105206:	5d                   	pop    %ebp
  105207:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105208:	83 f8 20             	cmp    $0x20,%eax
  10520b:	74 64                	je     105271 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  10520d:	e8 ae df ff ff       	call   1031c0 <curproc>
  105212:	85 c0                	test   %eax,%eax
  105214:	74 0a                	je     105220 <trap+0xd0>
  105216:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  10521a:	0f 85 e1 00 00 00    	jne    105301 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105220:	8b 5f 30             	mov    0x30(%edi),%ebx
  105223:	e8 38 d4 ff ff       	call   102660 <cpu>
  105228:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10522c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105230:	8b 47 28             	mov    0x28(%edi),%eax
  105233:	c7 04 24 18 67 10 00 	movl   $0x106718,(%esp)
  10523a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10523e:	e8 bd b4 ff ff       	call   100700 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105243:	c7 04 24 7c 67 10 00 	movl   $0x10677c,(%esp)
  10524a:	e8 51 b6 ff ff       	call   1008a0 <panic>
  10524f:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105250:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  105254:	75 a5                	jne    1051fb <trap+0xab>
    yield();
}
  105256:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105259:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10525c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10525f:	89 ec                	mov    %ebp,%esp
  105261:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105262:	e9 39 e3 ff ff       	jmp    1035a0 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105267:	e8 84 cd ff ff       	call   101ff0 <ide_intr>
  10526c:	e9 45 ff ff ff       	jmp    1051b6 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105271:	e8 ea d3 ff ff       	call   102660 <cpu>
  105276:	85 c0                	test   %eax,%eax
  105278:	0f 85 38 ff ff ff    	jne    1051b6 <trap+0x66>
      acquire(&tickslock);
  10527e:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
  105285:	e8 66 eb ff ff       	call   103df0 <acquire>
      ticks++;
  10528a:	83 05 c0 df 10 00 01 	addl   $0x1,0x10dfc0
      wakeup(&ticks);
  105291:	c7 04 24 c0 df 10 00 	movl   $0x10dfc0,(%esp)
  105298:	e8 f3 de ff ff       	call   103190 <wakeup>
      release(&tickslock);
  10529d:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
  1052a4:	e8 07 eb ff ff       	call   103db0 <release>
  1052a9:	e9 08 ff ff ff       	jmp    1051b6 <trap+0x66>
  1052ae:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  1052b0:	e8 2b d1 ff ff       	call   1023e0 <kbd_intr>
    lapic_eoi();
  1052b5:	e8 26 d3 ff ff       	call   1025e0 <lapic_eoi>
  1052ba:	e9 fc fe ff ff       	jmp    1051bb <trap+0x6b>
  1052bf:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  1052c0:	e8 fb de ff ff       	call   1031c0 <curproc>
  1052c5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1052c8:	85 c9                	test   %ecx,%ecx
  1052ca:	0f 85 9b 00 00 00    	jne    10536b <trap+0x21b>
      exit();
    cp->tf = tf;
  1052d0:	e8 eb de ff ff       	call   1031c0 <curproc>
  1052d5:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  1052db:	e8 30 ef ff ff       	call   104210 <syscall>
    if(cp->killed)
  1052e0:	e8 db de ff ff       	call   1031c0 <curproc>
  1052e5:	8b 50 1c             	mov    0x1c(%eax),%edx
  1052e8:	85 d2                	test   %edx,%edx
  1052ea:	0f 84 0b ff ff ff    	je     1051fb <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  1052f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1052f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1052f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1052f9:	89 ec                	mov    %ebp,%esp
  1052fb:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  1052fc:	e9 bf df ff ff       	jmp    1032c0 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105301:	8b 47 30             	mov    0x30(%edi),%eax
  105304:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105307:	e8 54 d3 ff ff       	call   102660 <cpu>
  10530c:	8b 57 28             	mov    0x28(%edi),%edx
  10530f:	8b 77 2c             	mov    0x2c(%edi),%esi
  105312:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105315:	89 c3                	mov    %eax,%ebx
  105317:	e8 a4 de ff ff       	call   1031c0 <curproc>
  10531c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10531f:	e8 9c de ff ff       	call   1031c0 <curproc>
  105324:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105327:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  10532b:	89 74 24 10          	mov    %esi,0x10(%esp)
  10532f:	89 54 24 18          	mov    %edx,0x18(%esp)
  105333:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105336:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10533a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10533d:	81 c2 88 00 00 00    	add    $0x88,%edx
  105343:	89 54 24 08          	mov    %edx,0x8(%esp)
  105347:	8b 40 10             	mov    0x10(%eax),%eax
  10534a:	c7 04 24 40 67 10 00 	movl   $0x106740,(%esp)
  105351:	89 44 24 04          	mov    %eax,0x4(%esp)
  105355:	e8 a6 b3 ff ff       	call   100700 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  10535a:	e8 61 de ff ff       	call   1031c0 <curproc>
  10535f:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105366:	e9 50 fe ff ff       	jmp    1051bb <trap+0x6b>
  10536b:	90                   	nop    
  10536c:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105370:	e8 4b df ff ff       	call   1032c0 <exit>
  105375:	e9 56 ff ff ff       	jmp    1052d0 <trap+0x180>
  10537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105380:	e8 3b df ff ff       	call   1032c0 <exit>
  105385:	e9 58 fe ff ff       	jmp    1051e2 <trap+0x92>
  10538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105390 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105390:	55                   	push   %ebp
  105391:	31 d2                	xor    %edx,%edx
  105393:	89 e5                	mov    %esp,%ebp
  105395:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105398:	8b 04 95 08 73 10 00 	mov    0x107308(,%edx,4),%eax
  10539f:	66 c7 04 d5 c2 d7 10 	movw   $0x8,0x10d7c2(,%edx,8)
  1053a6:	00 08 00 
  1053a9:	c6 04 d5 c4 d7 10 00 	movb   $0x0,0x10d7c4(,%edx,8)
  1053b0:	00 
  1053b1:	c6 04 d5 c5 d7 10 00 	movb   $0x8e,0x10d7c5(,%edx,8)
  1053b8:	8e 
  1053b9:	66 89 04 d5 c0 d7 10 	mov    %ax,0x10d7c0(,%edx,8)
  1053c0:	00 
  1053c1:	c1 e8 10             	shr    $0x10,%eax
  1053c4:	66 89 04 d5 c6 d7 10 	mov    %ax,0x10d7c6(,%edx,8)
  1053cb:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  1053cc:	83 c2 01             	add    $0x1,%edx
  1053cf:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  1053d5:	75 c1                	jne    105398 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1053d7:	a1 c8 73 10 00       	mov    0x1073c8,%eax
  
  initlock(&tickslock, "time");
  1053dc:	c7 44 24 04 81 67 10 	movl   $0x106781,0x4(%esp)
  1053e3:	00 
  1053e4:	c7 04 24 80 d7 10 00 	movl   $0x10d780,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1053eb:	66 c7 05 42 d9 10 00 	movw   $0x8,0x10d942
  1053f2:	08 00 
  1053f4:	66 a3 40 d9 10 00    	mov    %ax,0x10d940
  1053fa:	c1 e8 10             	shr    $0x10,%eax
  1053fd:	c6 05 44 d9 10 00 00 	movb   $0x0,0x10d944
  105404:	c6 05 45 d9 10 00 ef 	movb   $0xef,0x10d945
  10540b:	66 a3 46 d9 10 00    	mov    %ax,0x10d946
  
  initlock(&tickslock, "time");
  105411:	e8 1a e8 ff ff       	call   103c30 <initlock>
}
  105416:	c9                   	leave  
  105417:	c3                   	ret    

00105418 <vector0>:
  105418:	6a 00                	push   $0x0
  10541a:	6a 00                	push   $0x0
  10541c:	e9 cf fc ff ff       	jmp    1050f0 <alltraps>

00105421 <vector1>:
  105421:	6a 00                	push   $0x0
  105423:	6a 01                	push   $0x1
  105425:	e9 c6 fc ff ff       	jmp    1050f0 <alltraps>

0010542a <vector2>:
  10542a:	6a 00                	push   $0x0
  10542c:	6a 02                	push   $0x2
  10542e:	e9 bd fc ff ff       	jmp    1050f0 <alltraps>

00105433 <vector3>:
  105433:	6a 00                	push   $0x0
  105435:	6a 03                	push   $0x3
  105437:	e9 b4 fc ff ff       	jmp    1050f0 <alltraps>

0010543c <vector4>:
  10543c:	6a 00                	push   $0x0
  10543e:	6a 04                	push   $0x4
  105440:	e9 ab fc ff ff       	jmp    1050f0 <alltraps>

00105445 <vector5>:
  105445:	6a 00                	push   $0x0
  105447:	6a 05                	push   $0x5
  105449:	e9 a2 fc ff ff       	jmp    1050f0 <alltraps>

0010544e <vector6>:
  10544e:	6a 00                	push   $0x0
  105450:	6a 06                	push   $0x6
  105452:	e9 99 fc ff ff       	jmp    1050f0 <alltraps>

00105457 <vector7>:
  105457:	6a 00                	push   $0x0
  105459:	6a 07                	push   $0x7
  10545b:	e9 90 fc ff ff       	jmp    1050f0 <alltraps>

00105460 <vector8>:
  105460:	6a 08                	push   $0x8
  105462:	e9 89 fc ff ff       	jmp    1050f0 <alltraps>

00105467 <vector9>:
  105467:	6a 09                	push   $0x9
  105469:	e9 82 fc ff ff       	jmp    1050f0 <alltraps>

0010546e <vector10>:
  10546e:	6a 0a                	push   $0xa
  105470:	e9 7b fc ff ff       	jmp    1050f0 <alltraps>

00105475 <vector11>:
  105475:	6a 0b                	push   $0xb
  105477:	e9 74 fc ff ff       	jmp    1050f0 <alltraps>

0010547c <vector12>:
  10547c:	6a 0c                	push   $0xc
  10547e:	e9 6d fc ff ff       	jmp    1050f0 <alltraps>

00105483 <vector13>:
  105483:	6a 0d                	push   $0xd
  105485:	e9 66 fc ff ff       	jmp    1050f0 <alltraps>

0010548a <vector14>:
  10548a:	6a 0e                	push   $0xe
  10548c:	e9 5f fc ff ff       	jmp    1050f0 <alltraps>

00105491 <vector15>:
  105491:	6a 00                	push   $0x0
  105493:	6a 0f                	push   $0xf
  105495:	e9 56 fc ff ff       	jmp    1050f0 <alltraps>

0010549a <vector16>:
  10549a:	6a 00                	push   $0x0
  10549c:	6a 10                	push   $0x10
  10549e:	e9 4d fc ff ff       	jmp    1050f0 <alltraps>

001054a3 <vector17>:
  1054a3:	6a 11                	push   $0x11
  1054a5:	e9 46 fc ff ff       	jmp    1050f0 <alltraps>

001054aa <vector18>:
  1054aa:	6a 00                	push   $0x0
  1054ac:	6a 12                	push   $0x12
  1054ae:	e9 3d fc ff ff       	jmp    1050f0 <alltraps>

001054b3 <vector19>:
  1054b3:	6a 00                	push   $0x0
  1054b5:	6a 13                	push   $0x13
  1054b7:	e9 34 fc ff ff       	jmp    1050f0 <alltraps>

001054bc <vector20>:
  1054bc:	6a 00                	push   $0x0
  1054be:	6a 14                	push   $0x14
  1054c0:	e9 2b fc ff ff       	jmp    1050f0 <alltraps>

001054c5 <vector21>:
  1054c5:	6a 00                	push   $0x0
  1054c7:	6a 15                	push   $0x15
  1054c9:	e9 22 fc ff ff       	jmp    1050f0 <alltraps>

001054ce <vector22>:
  1054ce:	6a 00                	push   $0x0
  1054d0:	6a 16                	push   $0x16
  1054d2:	e9 19 fc ff ff       	jmp    1050f0 <alltraps>

001054d7 <vector23>:
  1054d7:	6a 00                	push   $0x0
  1054d9:	6a 17                	push   $0x17
  1054db:	e9 10 fc ff ff       	jmp    1050f0 <alltraps>

001054e0 <vector24>:
  1054e0:	6a 00                	push   $0x0
  1054e2:	6a 18                	push   $0x18
  1054e4:	e9 07 fc ff ff       	jmp    1050f0 <alltraps>

001054e9 <vector25>:
  1054e9:	6a 00                	push   $0x0
  1054eb:	6a 19                	push   $0x19
  1054ed:	e9 fe fb ff ff       	jmp    1050f0 <alltraps>

001054f2 <vector26>:
  1054f2:	6a 00                	push   $0x0
  1054f4:	6a 1a                	push   $0x1a
  1054f6:	e9 f5 fb ff ff       	jmp    1050f0 <alltraps>

001054fb <vector27>:
  1054fb:	6a 00                	push   $0x0
  1054fd:	6a 1b                	push   $0x1b
  1054ff:	e9 ec fb ff ff       	jmp    1050f0 <alltraps>

00105504 <vector28>:
  105504:	6a 00                	push   $0x0
  105506:	6a 1c                	push   $0x1c
  105508:	e9 e3 fb ff ff       	jmp    1050f0 <alltraps>

0010550d <vector29>:
  10550d:	6a 00                	push   $0x0
  10550f:	6a 1d                	push   $0x1d
  105511:	e9 da fb ff ff       	jmp    1050f0 <alltraps>

00105516 <vector30>:
  105516:	6a 00                	push   $0x0
  105518:	6a 1e                	push   $0x1e
  10551a:	e9 d1 fb ff ff       	jmp    1050f0 <alltraps>

0010551f <vector31>:
  10551f:	6a 00                	push   $0x0
  105521:	6a 1f                	push   $0x1f
  105523:	e9 c8 fb ff ff       	jmp    1050f0 <alltraps>

00105528 <vector32>:
  105528:	6a 00                	push   $0x0
  10552a:	6a 20                	push   $0x20
  10552c:	e9 bf fb ff ff       	jmp    1050f0 <alltraps>

00105531 <vector33>:
  105531:	6a 00                	push   $0x0
  105533:	6a 21                	push   $0x21
  105535:	e9 b6 fb ff ff       	jmp    1050f0 <alltraps>

0010553a <vector34>:
  10553a:	6a 00                	push   $0x0
  10553c:	6a 22                	push   $0x22
  10553e:	e9 ad fb ff ff       	jmp    1050f0 <alltraps>

00105543 <vector35>:
  105543:	6a 00                	push   $0x0
  105545:	6a 23                	push   $0x23
  105547:	e9 a4 fb ff ff       	jmp    1050f0 <alltraps>

0010554c <vector36>:
  10554c:	6a 00                	push   $0x0
  10554e:	6a 24                	push   $0x24
  105550:	e9 9b fb ff ff       	jmp    1050f0 <alltraps>

00105555 <vector37>:
  105555:	6a 00                	push   $0x0
  105557:	6a 25                	push   $0x25
  105559:	e9 92 fb ff ff       	jmp    1050f0 <alltraps>

0010555e <vector38>:
  10555e:	6a 00                	push   $0x0
  105560:	6a 26                	push   $0x26
  105562:	e9 89 fb ff ff       	jmp    1050f0 <alltraps>

00105567 <vector39>:
  105567:	6a 00                	push   $0x0
  105569:	6a 27                	push   $0x27
  10556b:	e9 80 fb ff ff       	jmp    1050f0 <alltraps>

00105570 <vector40>:
  105570:	6a 00                	push   $0x0
  105572:	6a 28                	push   $0x28
  105574:	e9 77 fb ff ff       	jmp    1050f0 <alltraps>

00105579 <vector41>:
  105579:	6a 00                	push   $0x0
  10557b:	6a 29                	push   $0x29
  10557d:	e9 6e fb ff ff       	jmp    1050f0 <alltraps>

00105582 <vector42>:
  105582:	6a 00                	push   $0x0
  105584:	6a 2a                	push   $0x2a
  105586:	e9 65 fb ff ff       	jmp    1050f0 <alltraps>

0010558b <vector43>:
  10558b:	6a 00                	push   $0x0
  10558d:	6a 2b                	push   $0x2b
  10558f:	e9 5c fb ff ff       	jmp    1050f0 <alltraps>

00105594 <vector44>:
  105594:	6a 00                	push   $0x0
  105596:	6a 2c                	push   $0x2c
  105598:	e9 53 fb ff ff       	jmp    1050f0 <alltraps>

0010559d <vector45>:
  10559d:	6a 00                	push   $0x0
  10559f:	6a 2d                	push   $0x2d
  1055a1:	e9 4a fb ff ff       	jmp    1050f0 <alltraps>

001055a6 <vector46>:
  1055a6:	6a 00                	push   $0x0
  1055a8:	6a 2e                	push   $0x2e
  1055aa:	e9 41 fb ff ff       	jmp    1050f0 <alltraps>

001055af <vector47>:
  1055af:	6a 00                	push   $0x0
  1055b1:	6a 2f                	push   $0x2f
  1055b3:	e9 38 fb ff ff       	jmp    1050f0 <alltraps>

001055b8 <vector48>:
  1055b8:	6a 00                	push   $0x0
  1055ba:	6a 30                	push   $0x30
  1055bc:	e9 2f fb ff ff       	jmp    1050f0 <alltraps>

001055c1 <vector49>:
  1055c1:	6a 00                	push   $0x0
  1055c3:	6a 31                	push   $0x31
  1055c5:	e9 26 fb ff ff       	jmp    1050f0 <alltraps>

001055ca <vector50>:
  1055ca:	6a 00                	push   $0x0
  1055cc:	6a 32                	push   $0x32
  1055ce:	e9 1d fb ff ff       	jmp    1050f0 <alltraps>

001055d3 <vector51>:
  1055d3:	6a 00                	push   $0x0
  1055d5:	6a 33                	push   $0x33
  1055d7:	e9 14 fb ff ff       	jmp    1050f0 <alltraps>

001055dc <vector52>:
  1055dc:	6a 00                	push   $0x0
  1055de:	6a 34                	push   $0x34
  1055e0:	e9 0b fb ff ff       	jmp    1050f0 <alltraps>

001055e5 <vector53>:
  1055e5:	6a 00                	push   $0x0
  1055e7:	6a 35                	push   $0x35
  1055e9:	e9 02 fb ff ff       	jmp    1050f0 <alltraps>

001055ee <vector54>:
  1055ee:	6a 00                	push   $0x0
  1055f0:	6a 36                	push   $0x36
  1055f2:	e9 f9 fa ff ff       	jmp    1050f0 <alltraps>

001055f7 <vector55>:
  1055f7:	6a 00                	push   $0x0
  1055f9:	6a 37                	push   $0x37
  1055fb:	e9 f0 fa ff ff       	jmp    1050f0 <alltraps>

00105600 <vector56>:
  105600:	6a 00                	push   $0x0
  105602:	6a 38                	push   $0x38
  105604:	e9 e7 fa ff ff       	jmp    1050f0 <alltraps>

00105609 <vector57>:
  105609:	6a 00                	push   $0x0
  10560b:	6a 39                	push   $0x39
  10560d:	e9 de fa ff ff       	jmp    1050f0 <alltraps>

00105612 <vector58>:
  105612:	6a 00                	push   $0x0
  105614:	6a 3a                	push   $0x3a
  105616:	e9 d5 fa ff ff       	jmp    1050f0 <alltraps>

0010561b <vector59>:
  10561b:	6a 00                	push   $0x0
  10561d:	6a 3b                	push   $0x3b
  10561f:	e9 cc fa ff ff       	jmp    1050f0 <alltraps>

00105624 <vector60>:
  105624:	6a 00                	push   $0x0
  105626:	6a 3c                	push   $0x3c
  105628:	e9 c3 fa ff ff       	jmp    1050f0 <alltraps>

0010562d <vector61>:
  10562d:	6a 00                	push   $0x0
  10562f:	6a 3d                	push   $0x3d
  105631:	e9 ba fa ff ff       	jmp    1050f0 <alltraps>

00105636 <vector62>:
  105636:	6a 00                	push   $0x0
  105638:	6a 3e                	push   $0x3e
  10563a:	e9 b1 fa ff ff       	jmp    1050f0 <alltraps>

0010563f <vector63>:
  10563f:	6a 00                	push   $0x0
  105641:	6a 3f                	push   $0x3f
  105643:	e9 a8 fa ff ff       	jmp    1050f0 <alltraps>

00105648 <vector64>:
  105648:	6a 00                	push   $0x0
  10564a:	6a 40                	push   $0x40
  10564c:	e9 9f fa ff ff       	jmp    1050f0 <alltraps>

00105651 <vector65>:
  105651:	6a 00                	push   $0x0
  105653:	6a 41                	push   $0x41
  105655:	e9 96 fa ff ff       	jmp    1050f0 <alltraps>

0010565a <vector66>:
  10565a:	6a 00                	push   $0x0
  10565c:	6a 42                	push   $0x42
  10565e:	e9 8d fa ff ff       	jmp    1050f0 <alltraps>

00105663 <vector67>:
  105663:	6a 00                	push   $0x0
  105665:	6a 43                	push   $0x43
  105667:	e9 84 fa ff ff       	jmp    1050f0 <alltraps>

0010566c <vector68>:
  10566c:	6a 00                	push   $0x0
  10566e:	6a 44                	push   $0x44
  105670:	e9 7b fa ff ff       	jmp    1050f0 <alltraps>

00105675 <vector69>:
  105675:	6a 00                	push   $0x0
  105677:	6a 45                	push   $0x45
  105679:	e9 72 fa ff ff       	jmp    1050f0 <alltraps>

0010567e <vector70>:
  10567e:	6a 00                	push   $0x0
  105680:	6a 46                	push   $0x46
  105682:	e9 69 fa ff ff       	jmp    1050f0 <alltraps>

00105687 <vector71>:
  105687:	6a 00                	push   $0x0
  105689:	6a 47                	push   $0x47
  10568b:	e9 60 fa ff ff       	jmp    1050f0 <alltraps>

00105690 <vector72>:
  105690:	6a 00                	push   $0x0
  105692:	6a 48                	push   $0x48
  105694:	e9 57 fa ff ff       	jmp    1050f0 <alltraps>

00105699 <vector73>:
  105699:	6a 00                	push   $0x0
  10569b:	6a 49                	push   $0x49
  10569d:	e9 4e fa ff ff       	jmp    1050f0 <alltraps>

001056a2 <vector74>:
  1056a2:	6a 00                	push   $0x0
  1056a4:	6a 4a                	push   $0x4a
  1056a6:	e9 45 fa ff ff       	jmp    1050f0 <alltraps>

001056ab <vector75>:
  1056ab:	6a 00                	push   $0x0
  1056ad:	6a 4b                	push   $0x4b
  1056af:	e9 3c fa ff ff       	jmp    1050f0 <alltraps>

001056b4 <vector76>:
  1056b4:	6a 00                	push   $0x0
  1056b6:	6a 4c                	push   $0x4c
  1056b8:	e9 33 fa ff ff       	jmp    1050f0 <alltraps>

001056bd <vector77>:
  1056bd:	6a 00                	push   $0x0
  1056bf:	6a 4d                	push   $0x4d
  1056c1:	e9 2a fa ff ff       	jmp    1050f0 <alltraps>

001056c6 <vector78>:
  1056c6:	6a 00                	push   $0x0
  1056c8:	6a 4e                	push   $0x4e
  1056ca:	e9 21 fa ff ff       	jmp    1050f0 <alltraps>

001056cf <vector79>:
  1056cf:	6a 00                	push   $0x0
  1056d1:	6a 4f                	push   $0x4f
  1056d3:	e9 18 fa ff ff       	jmp    1050f0 <alltraps>

001056d8 <vector80>:
  1056d8:	6a 00                	push   $0x0
  1056da:	6a 50                	push   $0x50
  1056dc:	e9 0f fa ff ff       	jmp    1050f0 <alltraps>

001056e1 <vector81>:
  1056e1:	6a 00                	push   $0x0
  1056e3:	6a 51                	push   $0x51
  1056e5:	e9 06 fa ff ff       	jmp    1050f0 <alltraps>

001056ea <vector82>:
  1056ea:	6a 00                	push   $0x0
  1056ec:	6a 52                	push   $0x52
  1056ee:	e9 fd f9 ff ff       	jmp    1050f0 <alltraps>

001056f3 <vector83>:
  1056f3:	6a 00                	push   $0x0
  1056f5:	6a 53                	push   $0x53
  1056f7:	e9 f4 f9 ff ff       	jmp    1050f0 <alltraps>

001056fc <vector84>:
  1056fc:	6a 00                	push   $0x0
  1056fe:	6a 54                	push   $0x54
  105700:	e9 eb f9 ff ff       	jmp    1050f0 <alltraps>

00105705 <vector85>:
  105705:	6a 00                	push   $0x0
  105707:	6a 55                	push   $0x55
  105709:	e9 e2 f9 ff ff       	jmp    1050f0 <alltraps>

0010570e <vector86>:
  10570e:	6a 00                	push   $0x0
  105710:	6a 56                	push   $0x56
  105712:	e9 d9 f9 ff ff       	jmp    1050f0 <alltraps>

00105717 <vector87>:
  105717:	6a 00                	push   $0x0
  105719:	6a 57                	push   $0x57
  10571b:	e9 d0 f9 ff ff       	jmp    1050f0 <alltraps>

00105720 <vector88>:
  105720:	6a 00                	push   $0x0
  105722:	6a 58                	push   $0x58
  105724:	e9 c7 f9 ff ff       	jmp    1050f0 <alltraps>

00105729 <vector89>:
  105729:	6a 00                	push   $0x0
  10572b:	6a 59                	push   $0x59
  10572d:	e9 be f9 ff ff       	jmp    1050f0 <alltraps>

00105732 <vector90>:
  105732:	6a 00                	push   $0x0
  105734:	6a 5a                	push   $0x5a
  105736:	e9 b5 f9 ff ff       	jmp    1050f0 <alltraps>

0010573b <vector91>:
  10573b:	6a 00                	push   $0x0
  10573d:	6a 5b                	push   $0x5b
  10573f:	e9 ac f9 ff ff       	jmp    1050f0 <alltraps>

00105744 <vector92>:
  105744:	6a 00                	push   $0x0
  105746:	6a 5c                	push   $0x5c
  105748:	e9 a3 f9 ff ff       	jmp    1050f0 <alltraps>

0010574d <vector93>:
  10574d:	6a 00                	push   $0x0
  10574f:	6a 5d                	push   $0x5d
  105751:	e9 9a f9 ff ff       	jmp    1050f0 <alltraps>

00105756 <vector94>:
  105756:	6a 00                	push   $0x0
  105758:	6a 5e                	push   $0x5e
  10575a:	e9 91 f9 ff ff       	jmp    1050f0 <alltraps>

0010575f <vector95>:
  10575f:	6a 00                	push   $0x0
  105761:	6a 5f                	push   $0x5f
  105763:	e9 88 f9 ff ff       	jmp    1050f0 <alltraps>

00105768 <vector96>:
  105768:	6a 00                	push   $0x0
  10576a:	6a 60                	push   $0x60
  10576c:	e9 7f f9 ff ff       	jmp    1050f0 <alltraps>

00105771 <vector97>:
  105771:	6a 00                	push   $0x0
  105773:	6a 61                	push   $0x61
  105775:	e9 76 f9 ff ff       	jmp    1050f0 <alltraps>

0010577a <vector98>:
  10577a:	6a 00                	push   $0x0
  10577c:	6a 62                	push   $0x62
  10577e:	e9 6d f9 ff ff       	jmp    1050f0 <alltraps>

00105783 <vector99>:
  105783:	6a 00                	push   $0x0
  105785:	6a 63                	push   $0x63
  105787:	e9 64 f9 ff ff       	jmp    1050f0 <alltraps>

0010578c <vector100>:
  10578c:	6a 00                	push   $0x0
  10578e:	6a 64                	push   $0x64
  105790:	e9 5b f9 ff ff       	jmp    1050f0 <alltraps>

00105795 <vector101>:
  105795:	6a 00                	push   $0x0
  105797:	6a 65                	push   $0x65
  105799:	e9 52 f9 ff ff       	jmp    1050f0 <alltraps>

0010579e <vector102>:
  10579e:	6a 00                	push   $0x0
  1057a0:	6a 66                	push   $0x66
  1057a2:	e9 49 f9 ff ff       	jmp    1050f0 <alltraps>

001057a7 <vector103>:
  1057a7:	6a 00                	push   $0x0
  1057a9:	6a 67                	push   $0x67
  1057ab:	e9 40 f9 ff ff       	jmp    1050f0 <alltraps>

001057b0 <vector104>:
  1057b0:	6a 00                	push   $0x0
  1057b2:	6a 68                	push   $0x68
  1057b4:	e9 37 f9 ff ff       	jmp    1050f0 <alltraps>

001057b9 <vector105>:
  1057b9:	6a 00                	push   $0x0
  1057bb:	6a 69                	push   $0x69
  1057bd:	e9 2e f9 ff ff       	jmp    1050f0 <alltraps>

001057c2 <vector106>:
  1057c2:	6a 00                	push   $0x0
  1057c4:	6a 6a                	push   $0x6a
  1057c6:	e9 25 f9 ff ff       	jmp    1050f0 <alltraps>

001057cb <vector107>:
  1057cb:	6a 00                	push   $0x0
  1057cd:	6a 6b                	push   $0x6b
  1057cf:	e9 1c f9 ff ff       	jmp    1050f0 <alltraps>

001057d4 <vector108>:
  1057d4:	6a 00                	push   $0x0
  1057d6:	6a 6c                	push   $0x6c
  1057d8:	e9 13 f9 ff ff       	jmp    1050f0 <alltraps>

001057dd <vector109>:
  1057dd:	6a 00                	push   $0x0
  1057df:	6a 6d                	push   $0x6d
  1057e1:	e9 0a f9 ff ff       	jmp    1050f0 <alltraps>

001057e6 <vector110>:
  1057e6:	6a 00                	push   $0x0
  1057e8:	6a 6e                	push   $0x6e
  1057ea:	e9 01 f9 ff ff       	jmp    1050f0 <alltraps>

001057ef <vector111>:
  1057ef:	6a 00                	push   $0x0
  1057f1:	6a 6f                	push   $0x6f
  1057f3:	e9 f8 f8 ff ff       	jmp    1050f0 <alltraps>

001057f8 <vector112>:
  1057f8:	6a 00                	push   $0x0
  1057fa:	6a 70                	push   $0x70
  1057fc:	e9 ef f8 ff ff       	jmp    1050f0 <alltraps>

00105801 <vector113>:
  105801:	6a 00                	push   $0x0
  105803:	6a 71                	push   $0x71
  105805:	e9 e6 f8 ff ff       	jmp    1050f0 <alltraps>

0010580a <vector114>:
  10580a:	6a 00                	push   $0x0
  10580c:	6a 72                	push   $0x72
  10580e:	e9 dd f8 ff ff       	jmp    1050f0 <alltraps>

00105813 <vector115>:
  105813:	6a 00                	push   $0x0
  105815:	6a 73                	push   $0x73
  105817:	e9 d4 f8 ff ff       	jmp    1050f0 <alltraps>

0010581c <vector116>:
  10581c:	6a 00                	push   $0x0
  10581e:	6a 74                	push   $0x74
  105820:	e9 cb f8 ff ff       	jmp    1050f0 <alltraps>

00105825 <vector117>:
  105825:	6a 00                	push   $0x0
  105827:	6a 75                	push   $0x75
  105829:	e9 c2 f8 ff ff       	jmp    1050f0 <alltraps>

0010582e <vector118>:
  10582e:	6a 00                	push   $0x0
  105830:	6a 76                	push   $0x76
  105832:	e9 b9 f8 ff ff       	jmp    1050f0 <alltraps>

00105837 <vector119>:
  105837:	6a 00                	push   $0x0
  105839:	6a 77                	push   $0x77
  10583b:	e9 b0 f8 ff ff       	jmp    1050f0 <alltraps>

00105840 <vector120>:
  105840:	6a 00                	push   $0x0
  105842:	6a 78                	push   $0x78
  105844:	e9 a7 f8 ff ff       	jmp    1050f0 <alltraps>

00105849 <vector121>:
  105849:	6a 00                	push   $0x0
  10584b:	6a 79                	push   $0x79
  10584d:	e9 9e f8 ff ff       	jmp    1050f0 <alltraps>

00105852 <vector122>:
  105852:	6a 00                	push   $0x0
  105854:	6a 7a                	push   $0x7a
  105856:	e9 95 f8 ff ff       	jmp    1050f0 <alltraps>

0010585b <vector123>:
  10585b:	6a 00                	push   $0x0
  10585d:	6a 7b                	push   $0x7b
  10585f:	e9 8c f8 ff ff       	jmp    1050f0 <alltraps>

00105864 <vector124>:
  105864:	6a 00                	push   $0x0
  105866:	6a 7c                	push   $0x7c
  105868:	e9 83 f8 ff ff       	jmp    1050f0 <alltraps>

0010586d <vector125>:
  10586d:	6a 00                	push   $0x0
  10586f:	6a 7d                	push   $0x7d
  105871:	e9 7a f8 ff ff       	jmp    1050f0 <alltraps>

00105876 <vector126>:
  105876:	6a 00                	push   $0x0
  105878:	6a 7e                	push   $0x7e
  10587a:	e9 71 f8 ff ff       	jmp    1050f0 <alltraps>

0010587f <vector127>:
  10587f:	6a 00                	push   $0x0
  105881:	6a 7f                	push   $0x7f
  105883:	e9 68 f8 ff ff       	jmp    1050f0 <alltraps>

00105888 <vector128>:
  105888:	6a 00                	push   $0x0
  10588a:	68 80 00 00 00       	push   $0x80
  10588f:	e9 5c f8 ff ff       	jmp    1050f0 <alltraps>

00105894 <vector129>:
  105894:	6a 00                	push   $0x0
  105896:	68 81 00 00 00       	push   $0x81
  10589b:	e9 50 f8 ff ff       	jmp    1050f0 <alltraps>

001058a0 <vector130>:
  1058a0:	6a 00                	push   $0x0
  1058a2:	68 82 00 00 00       	push   $0x82
  1058a7:	e9 44 f8 ff ff       	jmp    1050f0 <alltraps>

001058ac <vector131>:
  1058ac:	6a 00                	push   $0x0
  1058ae:	68 83 00 00 00       	push   $0x83
  1058b3:	e9 38 f8 ff ff       	jmp    1050f0 <alltraps>

001058b8 <vector132>:
  1058b8:	6a 00                	push   $0x0
  1058ba:	68 84 00 00 00       	push   $0x84
  1058bf:	e9 2c f8 ff ff       	jmp    1050f0 <alltraps>

001058c4 <vector133>:
  1058c4:	6a 00                	push   $0x0
  1058c6:	68 85 00 00 00       	push   $0x85
  1058cb:	e9 20 f8 ff ff       	jmp    1050f0 <alltraps>

001058d0 <vector134>:
  1058d0:	6a 00                	push   $0x0
  1058d2:	68 86 00 00 00       	push   $0x86
  1058d7:	e9 14 f8 ff ff       	jmp    1050f0 <alltraps>

001058dc <vector135>:
  1058dc:	6a 00                	push   $0x0
  1058de:	68 87 00 00 00       	push   $0x87
  1058e3:	e9 08 f8 ff ff       	jmp    1050f0 <alltraps>

001058e8 <vector136>:
  1058e8:	6a 00                	push   $0x0
  1058ea:	68 88 00 00 00       	push   $0x88
  1058ef:	e9 fc f7 ff ff       	jmp    1050f0 <alltraps>

001058f4 <vector137>:
  1058f4:	6a 00                	push   $0x0
  1058f6:	68 89 00 00 00       	push   $0x89
  1058fb:	e9 f0 f7 ff ff       	jmp    1050f0 <alltraps>

00105900 <vector138>:
  105900:	6a 00                	push   $0x0
  105902:	68 8a 00 00 00       	push   $0x8a
  105907:	e9 e4 f7 ff ff       	jmp    1050f0 <alltraps>

0010590c <vector139>:
  10590c:	6a 00                	push   $0x0
  10590e:	68 8b 00 00 00       	push   $0x8b
  105913:	e9 d8 f7 ff ff       	jmp    1050f0 <alltraps>

00105918 <vector140>:
  105918:	6a 00                	push   $0x0
  10591a:	68 8c 00 00 00       	push   $0x8c
  10591f:	e9 cc f7 ff ff       	jmp    1050f0 <alltraps>

00105924 <vector141>:
  105924:	6a 00                	push   $0x0
  105926:	68 8d 00 00 00       	push   $0x8d
  10592b:	e9 c0 f7 ff ff       	jmp    1050f0 <alltraps>

00105930 <vector142>:
  105930:	6a 00                	push   $0x0
  105932:	68 8e 00 00 00       	push   $0x8e
  105937:	e9 b4 f7 ff ff       	jmp    1050f0 <alltraps>

0010593c <vector143>:
  10593c:	6a 00                	push   $0x0
  10593e:	68 8f 00 00 00       	push   $0x8f
  105943:	e9 a8 f7 ff ff       	jmp    1050f0 <alltraps>

00105948 <vector144>:
  105948:	6a 00                	push   $0x0
  10594a:	68 90 00 00 00       	push   $0x90
  10594f:	e9 9c f7 ff ff       	jmp    1050f0 <alltraps>

00105954 <vector145>:
  105954:	6a 00                	push   $0x0
  105956:	68 91 00 00 00       	push   $0x91
  10595b:	e9 90 f7 ff ff       	jmp    1050f0 <alltraps>

00105960 <vector146>:
  105960:	6a 00                	push   $0x0
  105962:	68 92 00 00 00       	push   $0x92
  105967:	e9 84 f7 ff ff       	jmp    1050f0 <alltraps>

0010596c <vector147>:
  10596c:	6a 00                	push   $0x0
  10596e:	68 93 00 00 00       	push   $0x93
  105973:	e9 78 f7 ff ff       	jmp    1050f0 <alltraps>

00105978 <vector148>:
  105978:	6a 00                	push   $0x0
  10597a:	68 94 00 00 00       	push   $0x94
  10597f:	e9 6c f7 ff ff       	jmp    1050f0 <alltraps>

00105984 <vector149>:
  105984:	6a 00                	push   $0x0
  105986:	68 95 00 00 00       	push   $0x95
  10598b:	e9 60 f7 ff ff       	jmp    1050f0 <alltraps>

00105990 <vector150>:
  105990:	6a 00                	push   $0x0
  105992:	68 96 00 00 00       	push   $0x96
  105997:	e9 54 f7 ff ff       	jmp    1050f0 <alltraps>

0010599c <vector151>:
  10599c:	6a 00                	push   $0x0
  10599e:	68 97 00 00 00       	push   $0x97
  1059a3:	e9 48 f7 ff ff       	jmp    1050f0 <alltraps>

001059a8 <vector152>:
  1059a8:	6a 00                	push   $0x0
  1059aa:	68 98 00 00 00       	push   $0x98
  1059af:	e9 3c f7 ff ff       	jmp    1050f0 <alltraps>

001059b4 <vector153>:
  1059b4:	6a 00                	push   $0x0
  1059b6:	68 99 00 00 00       	push   $0x99
  1059bb:	e9 30 f7 ff ff       	jmp    1050f0 <alltraps>

001059c0 <vector154>:
  1059c0:	6a 00                	push   $0x0
  1059c2:	68 9a 00 00 00       	push   $0x9a
  1059c7:	e9 24 f7 ff ff       	jmp    1050f0 <alltraps>

001059cc <vector155>:
  1059cc:	6a 00                	push   $0x0
  1059ce:	68 9b 00 00 00       	push   $0x9b
  1059d3:	e9 18 f7 ff ff       	jmp    1050f0 <alltraps>

001059d8 <vector156>:
  1059d8:	6a 00                	push   $0x0
  1059da:	68 9c 00 00 00       	push   $0x9c
  1059df:	e9 0c f7 ff ff       	jmp    1050f0 <alltraps>

001059e4 <vector157>:
  1059e4:	6a 00                	push   $0x0
  1059e6:	68 9d 00 00 00       	push   $0x9d
  1059eb:	e9 00 f7 ff ff       	jmp    1050f0 <alltraps>

001059f0 <vector158>:
  1059f0:	6a 00                	push   $0x0
  1059f2:	68 9e 00 00 00       	push   $0x9e
  1059f7:	e9 f4 f6 ff ff       	jmp    1050f0 <alltraps>

001059fc <vector159>:
  1059fc:	6a 00                	push   $0x0
  1059fe:	68 9f 00 00 00       	push   $0x9f
  105a03:	e9 e8 f6 ff ff       	jmp    1050f0 <alltraps>

00105a08 <vector160>:
  105a08:	6a 00                	push   $0x0
  105a0a:	68 a0 00 00 00       	push   $0xa0
  105a0f:	e9 dc f6 ff ff       	jmp    1050f0 <alltraps>

00105a14 <vector161>:
  105a14:	6a 00                	push   $0x0
  105a16:	68 a1 00 00 00       	push   $0xa1
  105a1b:	e9 d0 f6 ff ff       	jmp    1050f0 <alltraps>

00105a20 <vector162>:
  105a20:	6a 00                	push   $0x0
  105a22:	68 a2 00 00 00       	push   $0xa2
  105a27:	e9 c4 f6 ff ff       	jmp    1050f0 <alltraps>

00105a2c <vector163>:
  105a2c:	6a 00                	push   $0x0
  105a2e:	68 a3 00 00 00       	push   $0xa3
  105a33:	e9 b8 f6 ff ff       	jmp    1050f0 <alltraps>

00105a38 <vector164>:
  105a38:	6a 00                	push   $0x0
  105a3a:	68 a4 00 00 00       	push   $0xa4
  105a3f:	e9 ac f6 ff ff       	jmp    1050f0 <alltraps>

00105a44 <vector165>:
  105a44:	6a 00                	push   $0x0
  105a46:	68 a5 00 00 00       	push   $0xa5
  105a4b:	e9 a0 f6 ff ff       	jmp    1050f0 <alltraps>

00105a50 <vector166>:
  105a50:	6a 00                	push   $0x0
  105a52:	68 a6 00 00 00       	push   $0xa6
  105a57:	e9 94 f6 ff ff       	jmp    1050f0 <alltraps>

00105a5c <vector167>:
  105a5c:	6a 00                	push   $0x0
  105a5e:	68 a7 00 00 00       	push   $0xa7
  105a63:	e9 88 f6 ff ff       	jmp    1050f0 <alltraps>

00105a68 <vector168>:
  105a68:	6a 00                	push   $0x0
  105a6a:	68 a8 00 00 00       	push   $0xa8
  105a6f:	e9 7c f6 ff ff       	jmp    1050f0 <alltraps>

00105a74 <vector169>:
  105a74:	6a 00                	push   $0x0
  105a76:	68 a9 00 00 00       	push   $0xa9
  105a7b:	e9 70 f6 ff ff       	jmp    1050f0 <alltraps>

00105a80 <vector170>:
  105a80:	6a 00                	push   $0x0
  105a82:	68 aa 00 00 00       	push   $0xaa
  105a87:	e9 64 f6 ff ff       	jmp    1050f0 <alltraps>

00105a8c <vector171>:
  105a8c:	6a 00                	push   $0x0
  105a8e:	68 ab 00 00 00       	push   $0xab
  105a93:	e9 58 f6 ff ff       	jmp    1050f0 <alltraps>

00105a98 <vector172>:
  105a98:	6a 00                	push   $0x0
  105a9a:	68 ac 00 00 00       	push   $0xac
  105a9f:	e9 4c f6 ff ff       	jmp    1050f0 <alltraps>

00105aa4 <vector173>:
  105aa4:	6a 00                	push   $0x0
  105aa6:	68 ad 00 00 00       	push   $0xad
  105aab:	e9 40 f6 ff ff       	jmp    1050f0 <alltraps>

00105ab0 <vector174>:
  105ab0:	6a 00                	push   $0x0
  105ab2:	68 ae 00 00 00       	push   $0xae
  105ab7:	e9 34 f6 ff ff       	jmp    1050f0 <alltraps>

00105abc <vector175>:
  105abc:	6a 00                	push   $0x0
  105abe:	68 af 00 00 00       	push   $0xaf
  105ac3:	e9 28 f6 ff ff       	jmp    1050f0 <alltraps>

00105ac8 <vector176>:
  105ac8:	6a 00                	push   $0x0
  105aca:	68 b0 00 00 00       	push   $0xb0
  105acf:	e9 1c f6 ff ff       	jmp    1050f0 <alltraps>

00105ad4 <vector177>:
  105ad4:	6a 00                	push   $0x0
  105ad6:	68 b1 00 00 00       	push   $0xb1
  105adb:	e9 10 f6 ff ff       	jmp    1050f0 <alltraps>

00105ae0 <vector178>:
  105ae0:	6a 00                	push   $0x0
  105ae2:	68 b2 00 00 00       	push   $0xb2
  105ae7:	e9 04 f6 ff ff       	jmp    1050f0 <alltraps>

00105aec <vector179>:
  105aec:	6a 00                	push   $0x0
  105aee:	68 b3 00 00 00       	push   $0xb3
  105af3:	e9 f8 f5 ff ff       	jmp    1050f0 <alltraps>

00105af8 <vector180>:
  105af8:	6a 00                	push   $0x0
  105afa:	68 b4 00 00 00       	push   $0xb4
  105aff:	e9 ec f5 ff ff       	jmp    1050f0 <alltraps>

00105b04 <vector181>:
  105b04:	6a 00                	push   $0x0
  105b06:	68 b5 00 00 00       	push   $0xb5
  105b0b:	e9 e0 f5 ff ff       	jmp    1050f0 <alltraps>

00105b10 <vector182>:
  105b10:	6a 00                	push   $0x0
  105b12:	68 b6 00 00 00       	push   $0xb6
  105b17:	e9 d4 f5 ff ff       	jmp    1050f0 <alltraps>

00105b1c <vector183>:
  105b1c:	6a 00                	push   $0x0
  105b1e:	68 b7 00 00 00       	push   $0xb7
  105b23:	e9 c8 f5 ff ff       	jmp    1050f0 <alltraps>

00105b28 <vector184>:
  105b28:	6a 00                	push   $0x0
  105b2a:	68 b8 00 00 00       	push   $0xb8
  105b2f:	e9 bc f5 ff ff       	jmp    1050f0 <alltraps>

00105b34 <vector185>:
  105b34:	6a 00                	push   $0x0
  105b36:	68 b9 00 00 00       	push   $0xb9
  105b3b:	e9 b0 f5 ff ff       	jmp    1050f0 <alltraps>

00105b40 <vector186>:
  105b40:	6a 00                	push   $0x0
  105b42:	68 ba 00 00 00       	push   $0xba
  105b47:	e9 a4 f5 ff ff       	jmp    1050f0 <alltraps>

00105b4c <vector187>:
  105b4c:	6a 00                	push   $0x0
  105b4e:	68 bb 00 00 00       	push   $0xbb
  105b53:	e9 98 f5 ff ff       	jmp    1050f0 <alltraps>

00105b58 <vector188>:
  105b58:	6a 00                	push   $0x0
  105b5a:	68 bc 00 00 00       	push   $0xbc
  105b5f:	e9 8c f5 ff ff       	jmp    1050f0 <alltraps>

00105b64 <vector189>:
  105b64:	6a 00                	push   $0x0
  105b66:	68 bd 00 00 00       	push   $0xbd
  105b6b:	e9 80 f5 ff ff       	jmp    1050f0 <alltraps>

00105b70 <vector190>:
  105b70:	6a 00                	push   $0x0
  105b72:	68 be 00 00 00       	push   $0xbe
  105b77:	e9 74 f5 ff ff       	jmp    1050f0 <alltraps>

00105b7c <vector191>:
  105b7c:	6a 00                	push   $0x0
  105b7e:	68 bf 00 00 00       	push   $0xbf
  105b83:	e9 68 f5 ff ff       	jmp    1050f0 <alltraps>

00105b88 <vector192>:
  105b88:	6a 00                	push   $0x0
  105b8a:	68 c0 00 00 00       	push   $0xc0
  105b8f:	e9 5c f5 ff ff       	jmp    1050f0 <alltraps>

00105b94 <vector193>:
  105b94:	6a 00                	push   $0x0
  105b96:	68 c1 00 00 00       	push   $0xc1
  105b9b:	e9 50 f5 ff ff       	jmp    1050f0 <alltraps>

00105ba0 <vector194>:
  105ba0:	6a 00                	push   $0x0
  105ba2:	68 c2 00 00 00       	push   $0xc2
  105ba7:	e9 44 f5 ff ff       	jmp    1050f0 <alltraps>

00105bac <vector195>:
  105bac:	6a 00                	push   $0x0
  105bae:	68 c3 00 00 00       	push   $0xc3
  105bb3:	e9 38 f5 ff ff       	jmp    1050f0 <alltraps>

00105bb8 <vector196>:
  105bb8:	6a 00                	push   $0x0
  105bba:	68 c4 00 00 00       	push   $0xc4
  105bbf:	e9 2c f5 ff ff       	jmp    1050f0 <alltraps>

00105bc4 <vector197>:
  105bc4:	6a 00                	push   $0x0
  105bc6:	68 c5 00 00 00       	push   $0xc5
  105bcb:	e9 20 f5 ff ff       	jmp    1050f0 <alltraps>

00105bd0 <vector198>:
  105bd0:	6a 00                	push   $0x0
  105bd2:	68 c6 00 00 00       	push   $0xc6
  105bd7:	e9 14 f5 ff ff       	jmp    1050f0 <alltraps>

00105bdc <vector199>:
  105bdc:	6a 00                	push   $0x0
  105bde:	68 c7 00 00 00       	push   $0xc7
  105be3:	e9 08 f5 ff ff       	jmp    1050f0 <alltraps>

00105be8 <vector200>:
  105be8:	6a 00                	push   $0x0
  105bea:	68 c8 00 00 00       	push   $0xc8
  105bef:	e9 fc f4 ff ff       	jmp    1050f0 <alltraps>

00105bf4 <vector201>:
  105bf4:	6a 00                	push   $0x0
  105bf6:	68 c9 00 00 00       	push   $0xc9
  105bfb:	e9 f0 f4 ff ff       	jmp    1050f0 <alltraps>

00105c00 <vector202>:
  105c00:	6a 00                	push   $0x0
  105c02:	68 ca 00 00 00       	push   $0xca
  105c07:	e9 e4 f4 ff ff       	jmp    1050f0 <alltraps>

00105c0c <vector203>:
  105c0c:	6a 00                	push   $0x0
  105c0e:	68 cb 00 00 00       	push   $0xcb
  105c13:	e9 d8 f4 ff ff       	jmp    1050f0 <alltraps>

00105c18 <vector204>:
  105c18:	6a 00                	push   $0x0
  105c1a:	68 cc 00 00 00       	push   $0xcc
  105c1f:	e9 cc f4 ff ff       	jmp    1050f0 <alltraps>

00105c24 <vector205>:
  105c24:	6a 00                	push   $0x0
  105c26:	68 cd 00 00 00       	push   $0xcd
  105c2b:	e9 c0 f4 ff ff       	jmp    1050f0 <alltraps>

00105c30 <vector206>:
  105c30:	6a 00                	push   $0x0
  105c32:	68 ce 00 00 00       	push   $0xce
  105c37:	e9 b4 f4 ff ff       	jmp    1050f0 <alltraps>

00105c3c <vector207>:
  105c3c:	6a 00                	push   $0x0
  105c3e:	68 cf 00 00 00       	push   $0xcf
  105c43:	e9 a8 f4 ff ff       	jmp    1050f0 <alltraps>

00105c48 <vector208>:
  105c48:	6a 00                	push   $0x0
  105c4a:	68 d0 00 00 00       	push   $0xd0
  105c4f:	e9 9c f4 ff ff       	jmp    1050f0 <alltraps>

00105c54 <vector209>:
  105c54:	6a 00                	push   $0x0
  105c56:	68 d1 00 00 00       	push   $0xd1
  105c5b:	e9 90 f4 ff ff       	jmp    1050f0 <alltraps>

00105c60 <vector210>:
  105c60:	6a 00                	push   $0x0
  105c62:	68 d2 00 00 00       	push   $0xd2
  105c67:	e9 84 f4 ff ff       	jmp    1050f0 <alltraps>

00105c6c <vector211>:
  105c6c:	6a 00                	push   $0x0
  105c6e:	68 d3 00 00 00       	push   $0xd3
  105c73:	e9 78 f4 ff ff       	jmp    1050f0 <alltraps>

00105c78 <vector212>:
  105c78:	6a 00                	push   $0x0
  105c7a:	68 d4 00 00 00       	push   $0xd4
  105c7f:	e9 6c f4 ff ff       	jmp    1050f0 <alltraps>

00105c84 <vector213>:
  105c84:	6a 00                	push   $0x0
  105c86:	68 d5 00 00 00       	push   $0xd5
  105c8b:	e9 60 f4 ff ff       	jmp    1050f0 <alltraps>

00105c90 <vector214>:
  105c90:	6a 00                	push   $0x0
  105c92:	68 d6 00 00 00       	push   $0xd6
  105c97:	e9 54 f4 ff ff       	jmp    1050f0 <alltraps>

00105c9c <vector215>:
  105c9c:	6a 00                	push   $0x0
  105c9e:	68 d7 00 00 00       	push   $0xd7
  105ca3:	e9 48 f4 ff ff       	jmp    1050f0 <alltraps>

00105ca8 <vector216>:
  105ca8:	6a 00                	push   $0x0
  105caa:	68 d8 00 00 00       	push   $0xd8
  105caf:	e9 3c f4 ff ff       	jmp    1050f0 <alltraps>

00105cb4 <vector217>:
  105cb4:	6a 00                	push   $0x0
  105cb6:	68 d9 00 00 00       	push   $0xd9
  105cbb:	e9 30 f4 ff ff       	jmp    1050f0 <alltraps>

00105cc0 <vector218>:
  105cc0:	6a 00                	push   $0x0
  105cc2:	68 da 00 00 00       	push   $0xda
  105cc7:	e9 24 f4 ff ff       	jmp    1050f0 <alltraps>

00105ccc <vector219>:
  105ccc:	6a 00                	push   $0x0
  105cce:	68 db 00 00 00       	push   $0xdb
  105cd3:	e9 18 f4 ff ff       	jmp    1050f0 <alltraps>

00105cd8 <vector220>:
  105cd8:	6a 00                	push   $0x0
  105cda:	68 dc 00 00 00       	push   $0xdc
  105cdf:	e9 0c f4 ff ff       	jmp    1050f0 <alltraps>

00105ce4 <vector221>:
  105ce4:	6a 00                	push   $0x0
  105ce6:	68 dd 00 00 00       	push   $0xdd
  105ceb:	e9 00 f4 ff ff       	jmp    1050f0 <alltraps>

00105cf0 <vector222>:
  105cf0:	6a 00                	push   $0x0
  105cf2:	68 de 00 00 00       	push   $0xde
  105cf7:	e9 f4 f3 ff ff       	jmp    1050f0 <alltraps>

00105cfc <vector223>:
  105cfc:	6a 00                	push   $0x0
  105cfe:	68 df 00 00 00       	push   $0xdf
  105d03:	e9 e8 f3 ff ff       	jmp    1050f0 <alltraps>

00105d08 <vector224>:
  105d08:	6a 00                	push   $0x0
  105d0a:	68 e0 00 00 00       	push   $0xe0
  105d0f:	e9 dc f3 ff ff       	jmp    1050f0 <alltraps>

00105d14 <vector225>:
  105d14:	6a 00                	push   $0x0
  105d16:	68 e1 00 00 00       	push   $0xe1
  105d1b:	e9 d0 f3 ff ff       	jmp    1050f0 <alltraps>

00105d20 <vector226>:
  105d20:	6a 00                	push   $0x0
  105d22:	68 e2 00 00 00       	push   $0xe2
  105d27:	e9 c4 f3 ff ff       	jmp    1050f0 <alltraps>

00105d2c <vector227>:
  105d2c:	6a 00                	push   $0x0
  105d2e:	68 e3 00 00 00       	push   $0xe3
  105d33:	e9 b8 f3 ff ff       	jmp    1050f0 <alltraps>

00105d38 <vector228>:
  105d38:	6a 00                	push   $0x0
  105d3a:	68 e4 00 00 00       	push   $0xe4
  105d3f:	e9 ac f3 ff ff       	jmp    1050f0 <alltraps>

00105d44 <vector229>:
  105d44:	6a 00                	push   $0x0
  105d46:	68 e5 00 00 00       	push   $0xe5
  105d4b:	e9 a0 f3 ff ff       	jmp    1050f0 <alltraps>

00105d50 <vector230>:
  105d50:	6a 00                	push   $0x0
  105d52:	68 e6 00 00 00       	push   $0xe6
  105d57:	e9 94 f3 ff ff       	jmp    1050f0 <alltraps>

00105d5c <vector231>:
  105d5c:	6a 00                	push   $0x0
  105d5e:	68 e7 00 00 00       	push   $0xe7
  105d63:	e9 88 f3 ff ff       	jmp    1050f0 <alltraps>

00105d68 <vector232>:
  105d68:	6a 00                	push   $0x0
  105d6a:	68 e8 00 00 00       	push   $0xe8
  105d6f:	e9 7c f3 ff ff       	jmp    1050f0 <alltraps>

00105d74 <vector233>:
  105d74:	6a 00                	push   $0x0
  105d76:	68 e9 00 00 00       	push   $0xe9
  105d7b:	e9 70 f3 ff ff       	jmp    1050f0 <alltraps>

00105d80 <vector234>:
  105d80:	6a 00                	push   $0x0
  105d82:	68 ea 00 00 00       	push   $0xea
  105d87:	e9 64 f3 ff ff       	jmp    1050f0 <alltraps>

00105d8c <vector235>:
  105d8c:	6a 00                	push   $0x0
  105d8e:	68 eb 00 00 00       	push   $0xeb
  105d93:	e9 58 f3 ff ff       	jmp    1050f0 <alltraps>

00105d98 <vector236>:
  105d98:	6a 00                	push   $0x0
  105d9a:	68 ec 00 00 00       	push   $0xec
  105d9f:	e9 4c f3 ff ff       	jmp    1050f0 <alltraps>

00105da4 <vector237>:
  105da4:	6a 00                	push   $0x0
  105da6:	68 ed 00 00 00       	push   $0xed
  105dab:	e9 40 f3 ff ff       	jmp    1050f0 <alltraps>

00105db0 <vector238>:
  105db0:	6a 00                	push   $0x0
  105db2:	68 ee 00 00 00       	push   $0xee
  105db7:	e9 34 f3 ff ff       	jmp    1050f0 <alltraps>

00105dbc <vector239>:
  105dbc:	6a 00                	push   $0x0
  105dbe:	68 ef 00 00 00       	push   $0xef
  105dc3:	e9 28 f3 ff ff       	jmp    1050f0 <alltraps>

00105dc8 <vector240>:
  105dc8:	6a 00                	push   $0x0
  105dca:	68 f0 00 00 00       	push   $0xf0
  105dcf:	e9 1c f3 ff ff       	jmp    1050f0 <alltraps>

00105dd4 <vector241>:
  105dd4:	6a 00                	push   $0x0
  105dd6:	68 f1 00 00 00       	push   $0xf1
  105ddb:	e9 10 f3 ff ff       	jmp    1050f0 <alltraps>

00105de0 <vector242>:
  105de0:	6a 00                	push   $0x0
  105de2:	68 f2 00 00 00       	push   $0xf2
  105de7:	e9 04 f3 ff ff       	jmp    1050f0 <alltraps>

00105dec <vector243>:
  105dec:	6a 00                	push   $0x0
  105dee:	68 f3 00 00 00       	push   $0xf3
  105df3:	e9 f8 f2 ff ff       	jmp    1050f0 <alltraps>

00105df8 <vector244>:
  105df8:	6a 00                	push   $0x0
  105dfa:	68 f4 00 00 00       	push   $0xf4
  105dff:	e9 ec f2 ff ff       	jmp    1050f0 <alltraps>

00105e04 <vector245>:
  105e04:	6a 00                	push   $0x0
  105e06:	68 f5 00 00 00       	push   $0xf5
  105e0b:	e9 e0 f2 ff ff       	jmp    1050f0 <alltraps>

00105e10 <vector246>:
  105e10:	6a 00                	push   $0x0
  105e12:	68 f6 00 00 00       	push   $0xf6
  105e17:	e9 d4 f2 ff ff       	jmp    1050f0 <alltraps>

00105e1c <vector247>:
  105e1c:	6a 00                	push   $0x0
  105e1e:	68 f7 00 00 00       	push   $0xf7
  105e23:	e9 c8 f2 ff ff       	jmp    1050f0 <alltraps>

00105e28 <vector248>:
  105e28:	6a 00                	push   $0x0
  105e2a:	68 f8 00 00 00       	push   $0xf8
  105e2f:	e9 bc f2 ff ff       	jmp    1050f0 <alltraps>

00105e34 <vector249>:
  105e34:	6a 00                	push   $0x0
  105e36:	68 f9 00 00 00       	push   $0xf9
  105e3b:	e9 b0 f2 ff ff       	jmp    1050f0 <alltraps>

00105e40 <vector250>:
  105e40:	6a 00                	push   $0x0
  105e42:	68 fa 00 00 00       	push   $0xfa
  105e47:	e9 a4 f2 ff ff       	jmp    1050f0 <alltraps>

00105e4c <vector251>:
  105e4c:	6a 00                	push   $0x0
  105e4e:	68 fb 00 00 00       	push   $0xfb
  105e53:	e9 98 f2 ff ff       	jmp    1050f0 <alltraps>

00105e58 <vector252>:
  105e58:	6a 00                	push   $0x0
  105e5a:	68 fc 00 00 00       	push   $0xfc
  105e5f:	e9 8c f2 ff ff       	jmp    1050f0 <alltraps>

00105e64 <vector253>:
  105e64:	6a 00                	push   $0x0
  105e66:	68 fd 00 00 00       	push   $0xfd
  105e6b:	e9 80 f2 ff ff       	jmp    1050f0 <alltraps>

00105e70 <vector254>:
  105e70:	6a 00                	push   $0x0
  105e72:	68 fe 00 00 00       	push   $0xfe
  105e77:	e9 74 f2 ff ff       	jmp    1050f0 <alltraps>

00105e7c <vector255>:
  105e7c:	6a 00                	push   $0x0
  105e7e:	68 ff 00 00 00       	push   $0xff
  105e83:	e9 68 f2 ff ff       	jmp    1050f0 <alltraps>
