
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
  10000f:	c7 04 24 60 9b 10 00 	movl   $0x109b60,(%esp)
  100016:	e8 75 43 00 00       	call   104390 <acquire>

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
  10002a:	c7 43 0c 40 84 10 00 	movl   $0x108440,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bufhead.next;
  100034:	a1 50 84 10 00       	mov    0x108450,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 50 84 10 00       	mov    0x108450,%eax
  bufhead.next = b;
  100041:	89 1d 50 84 10 00    	mov    %ebx,0x108450

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 60 86 10 00 	movl   $0x108660,(%esp)
  100051:	e8 6a 31 00 00       	call   1031c0 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 60 9b 10 00 	movl   $0x109b60,0x8(%ebp)
}
  10005d:	83 c4 04             	add    $0x4,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 e9 42 00 00       	jmp    104350 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
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
  10009d:	c7 04 24 67 64 10 00 	movl   $0x106467,(%esp)
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
  1000bf:	c7 04 24 60 9b 10 00 	movl   $0x109b60,(%esp)
  1000c6:	e8 c5 42 00 00       	call   104390 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  1000cb:	8b 1d 50 84 10 00    	mov    0x108450,%ebx
  1000d1:	81 fb 40 84 10 00    	cmp    $0x108440,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 3d                	jmp    100118 <bread+0x68>
  1000db:	90                   	nop    
  1000dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb 40 84 10 00    	cmp    $0x108440,%ebx
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
  100102:	c7 44 24 04 60 9b 10 	movl   $0x109b60,0x4(%esp)
  100109:	00 
  10010a:	c7 04 24 60 86 10 00 	movl   $0x108660,(%esp)
  100111:	e8 aa 34 00 00       	call   1035c0 <sleep>
  100116:	eb b3                	jmp    1000cb <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100118:	8b 1d 4c 84 10 00    	mov    0x10844c,%ebx
  10011e:	81 fb 40 84 10 00    	cmp    $0x108440,%ebx
  100124:	75 0d                	jne    100133 <bread+0x83>
  100126:	eb 49                	jmp    100171 <bread+0xc1>
  100128:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10012b:	81 fb 40 84 10 00    	cmp    $0x108440,%ebx
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
  100144:	c7 04 24 60 9b 10 00 	movl   $0x109b60,(%esp)
  10014b:	e8 00 42 00 00       	call   104350 <release>
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
  100171:	c7 04 24 6e 64 10 00 	movl   $0x10646e,(%esp)
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
  100182:	c7 04 24 60 9b 10 00 	movl   $0x109b60,(%esp)
  100189:	e8 c2 41 00 00       	call   104350 <release>
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
  100196:	c7 44 24 04 7f 64 10 	movl   $0x10647f,0x4(%esp)
  10019d:	00 
  10019e:	c7 04 24 60 9b 10 00 	movl   $0x109b60,(%esp)
  1001a5:	e8 26 40 00 00       	call   1041d0 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  1001aa:	ba 60 86 10 00       	mov    $0x108660,%edx
  1001af:	b9 40 84 10 00       	mov    $0x108440,%ecx
  1001b4:	c7 05 4c 84 10 00 40 	movl   $0x108440,0x10844c
  1001bb:	84 10 00 
  1001be:	eb 04                	jmp    1001c4 <binit+0x34>
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001c0:	89 d1                	mov    %edx,%ecx
  1001c2:	89 c2                	mov    %eax,%edx
  1001c4:	8d 82 18 02 00 00    	lea    0x218(%edx),%eax
  1001ca:	3d 50 9b 10 00       	cmp    $0x109b50,%eax
    b->next = bufhead.next;
    b->prev = &bufhead;
  1001cf:	c7 42 0c 40 84 10 00 	movl   $0x108440,0xc(%edx)

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
  1001de:	c7 05 50 84 10 00 38 	movl   $0x109938,0x108450
  1001e5:	99 10 00 
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
  1001f6:	c7 44 24 04 89 64 10 	movl   $0x106489,0x4(%esp)
  1001fd:	00 
  1001fe:	c7 04 24 a0 83 10 00 	movl   $0x1083a0,(%esp)
  100205:	e8 c6 3f 00 00       	call   1041d0 <initlock>
  initlock(&input.lock, "console input");
  10020a:	c7 44 24 04 91 64 10 	movl   $0x106491,0x4(%esp)
  100211:	00 
  100212:	c7 04 24 a0 9b 10 00 	movl   $0x109ba0,(%esp)
  100219:	e8 b2 3f 00 00       	call   1041d0 <initlock>

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
  100225:	c7 05 0c a6 10 00 10 	movl   $0x100610,0x10a60c
  10022c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10022f:	c7 05 08 a6 10 00 60 	movl   $0x100260,0x10a608
  100236:	02 10 00 
  use_console_lock = 1;
  100239:	c7 05 84 83 10 00 01 	movl   $0x1,0x108384
  100240:	00 00 00 

  pic_enable(IRQ_KBD);
  100243:	e8 d8 29 00 00       	call   102c20 <pic_enable>
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
  10027c:	c7 04 24 a0 9b 10 00 	movl   $0x109ba0,(%esp)
  100283:	e8 08 41 00 00       	call   104390 <acquire>
  while(n > 0){
  100288:	85 db                	test   %ebx,%ebx
  10028a:	7f 25                	jg     1002b1 <console_read+0x51>
  10028c:	e9 af 00 00 00       	jmp    100340 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100291:	e8 9a 30 00 00       	call   103330 <curproc>
  100296:	8b 40 1c             	mov    0x1c(%eax),%eax
  100299:	85 c0                	test   %eax,%eax
  10029b:	75 4e                	jne    1002eb <console_read+0x8b>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10029d:	c7 44 24 04 a0 9b 10 	movl   $0x109ba0,0x4(%esp)
  1002a4:	00 
  1002a5:	c7 04 24 54 9c 10 00 	movl   $0x109c54,(%esp)
  1002ac:	e8 0f 33 00 00       	call   1035c0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1002b1:	8b 15 54 9c 10 00    	mov    0x109c54,%edx
  1002b7:	3b 15 58 9c 10 00    	cmp    0x109c58,%edx
  1002bd:	74 d2                	je     100291 <console_read+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  1002bf:	89 d0                	mov    %edx,%eax
  1002c1:	83 e0 7f             	and    $0x7f,%eax
  1002c4:	0f b6 88 d4 9b 10 00 	movzbl 0x109bd4(%eax),%ecx
  1002cb:	8d 42 01             	lea    0x1(%edx),%eax
  1002ce:	a3 54 9c 10 00       	mov    %eax,0x109c54
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
  1002eb:	c7 04 24 a0 9b 10 00 	movl   $0x109ba0,(%esp)
        ilock(ip);
  1002f2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  1002f7:	e8 54 40 00 00       	call   104350 <release>
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
  100315:	89 15 54 9c 10 00    	mov    %edx,0x109c54
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
  10031f:	c7 04 24 a0 9b 10 00 	movl   $0x109ba0,(%esp)
  100326:	e8 25 40 00 00       	call   104350 <release>
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
  100359:	8b 15 80 83 10 00    	mov    0x108380,%edx
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
  10047e:	e8 1d 40 00 00       	call   1044a0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100483:	b8 80 07 00 00       	mov    $0x780,%eax
  100488:	29 d8                	sub    %ebx,%eax
  10048a:	01 c0                	add    %eax,%eax
  10048c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100490:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100497:	00 
  100498:	89 34 24             	mov    %esi,(%esp)
  10049b:	e8 50 3f 00 00       	call   1043f0 <memset>
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
  1004db:	c7 04 24 a0 9b 10 00 	movl   $0x109ba0,(%esp)
  1004e2:	e8 a9 3e 00 00       	call   104390 <acquire>
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
  100513:	8b 15 5c 9c 10 00    	mov    0x109c5c,%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	2b 05 54 9c 10 00    	sub    0x109c54,%eax
  100521:	83 f8 7f             	cmp    $0x7f,%eax
  100524:	77 c1                	ja     1004e7 <console_intr+0x17>
        input.buf[input.e++ % INPUT_BUF] = c;
  100526:	89 d0                	mov    %edx,%eax
  100528:	83 e0 7f             	and    $0x7f,%eax
  10052b:	88 98 d4 9b 10 00    	mov    %bl,0x109bd4(%eax)
  100531:	8d 42 01             	lea    0x1(%edx),%eax
  100534:	a3 5c 9c 10 00       	mov    %eax,0x109c5c
        cons_putc(c);
  100539:	89 1c 24             	mov    %ebx,(%esp)
  10053c:	e8 0f fe ff ff       	call   100350 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100541:	83 fb 0a             	cmp    $0xa,%ebx
  100544:	0f 84 ba 00 00 00    	je     100604 <console_intr+0x134>
  10054a:	83 fb 04             	cmp    $0x4,%ebx
  10054d:	0f 84 b1 00 00 00    	je     100604 <console_intr+0x134>
  100553:	a1 54 9c 10 00       	mov    0x109c54,%eax
  100558:	8b 15 5c 9c 10 00    	mov    0x109c5c,%edx
  10055e:	83 e8 80             	sub    $0xffffff80,%eax
  100561:	39 c2                	cmp    %eax,%edx
  100563:	75 82                	jne    1004e7 <console_intr+0x17>
          input.w = input.e;
  100565:	89 15 58 9c 10 00    	mov    %edx,0x109c58
          wakeup(&input.r);
  10056b:	c7 04 24 54 9c 10 00 	movl   $0x109c54,(%esp)
  100572:	e8 49 2c 00 00       	call   1031c0 <wakeup>
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
  100583:	c7 45 08 a0 9b 10 00 	movl   $0x109ba0,0x8(%ebp)
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
  100590:	e9 bb 3d 00 00       	jmp    104350 <release>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	89 d0                	mov    %edx,%eax
  10059a:	83 e0 7f             	and    $0x7f,%eax
  10059d:	80 b8 d4 9b 10 00 0a 	cmpb   $0xa,0x109bd4(%eax)
  1005a4:	0f 84 3d ff ff ff    	je     1004e7 <console_intr+0x17>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1005aa:	89 15 5c 9c 10 00    	mov    %edx,0x109c5c
        cons_putc(BACKSPACE);
  1005b0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1005b7:	e8 94 fd ff ff       	call   100350 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1005bc:	a1 5c 9c 10 00       	mov    0x109c5c,%eax
  1005c1:	3b 05 58 9c 10 00    	cmp    0x109c58,%eax
  1005c7:	75 cc                	jne    100595 <console_intr+0xc5>
  1005c9:	e9 19 ff ff ff       	jmp    1004e7 <console_intr+0x17>
  1005ce:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  1005d0:	e8 9b 2c 00 00       	call   103270 <procdump>
  1005d5:	e9 0d ff ff ff       	jmp    1004e7 <console_intr+0x17>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  1005da:	a1 5c 9c 10 00       	mov    0x109c5c,%eax
  1005df:	3b 05 58 9c 10 00    	cmp    0x109c58,%eax
  1005e5:	0f 84 fc fe ff ff    	je     1004e7 <console_intr+0x17>
        input.e--;
  1005eb:	83 e8 01             	sub    $0x1,%eax
  1005ee:	a3 5c 9c 10 00       	mov    %eax,0x109c5c
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
  100604:	8b 15 5c 9c 10 00    	mov    0x109c5c,%edx
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
  10062a:	c7 04 24 a0 83 10 00 	movl   $0x1083a0,(%esp)
  100631:	e8 5a 3d 00 00       	call   104390 <acquire>
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
  100653:	c7 04 24 a0 83 10 00 	movl   $0x1083a0,(%esp)
  10065a:	e8 f1 3c 00 00       	call   104350 <release>
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
  1006ac:	0f b6 82 b9 64 10 00 	movzbl 0x1064b9(%edx),%eax
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
  100709:	a1 84 83 10 00       	mov    0x108384,%eax
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
  100770:	c7 04 24 a0 83 10 00 	movl   $0x1083a0,(%esp)
  100777:	e8 d4 3b 00 00       	call   104350 <release>
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
  100815:	ba 9f 64 10 00       	mov    $0x10649f,%edx
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
  100885:	c7 04 24 a0 83 10 00 	movl   $0x1083a0,(%esp)
  10088c:	e8 ff 3a 00 00       	call   104390 <acquire>
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
  1008a9:	c7 05 84 83 10 00 00 	movl   $0x0,0x108384
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
  1008bb:	e8 c0 1d 00 00       	call   102680 <cpu>
  1008c0:	c7 04 24 a6 64 10 00 	movl   $0x1064a6,(%esp)
  1008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008cb:	e8 30 fe ff ff       	call   100700 <cprintf>
  cprintf(s);
  1008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1008d3:	89 04 24             	mov    %eax,(%esp)
  1008d6:	e8 25 fe ff ff       	call   100700 <cprintf>
  cprintf("\n");
  1008db:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  1008e2:	e8 19 fe ff ff       	call   100700 <cprintf>
  getcallerpcs(&s, pcs);
  1008e7:	8d 45 08             	lea    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  1008f1:	e8 fa 38 00 00       	call   1041f0 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1008f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008f9:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	e8 f7 fd ff ff       	call   100700 <cprintf>
  100909:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10090d:	83 c3 01             	add    $0x1,%ebx
  100910:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
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
  100925:	c7 05 80 83 10 00 01 	movl   $0x1,0x108380
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
  100a2b:	e8 c0 3b 00 00       	call   1045f0 <strlen>
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
  100aa7:	e8 44 39 00 00       	call   1043f0 <memset>

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
  100b4d:	e8 9e 38 00 00       	call   1043f0 <memset>
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
  100b67:	e8 44 17 00 00       	call   1022b0 <kfree>
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
  100bc5:	e8 26 3a 00 00       	call   1045f0 <strlen>
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
  100be8:	e8 b3 38 00 00       	call   1044a0 <memmove>
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
  100c45:	e8 e6 26 00 00       	call   103330 <curproc>
  100c4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c4e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100c55:	00 
  100c56:	05 88 00 00 00       	add    $0x88,%eax
  100c5b:	89 04 24             	mov    %eax,(%esp)
  100c5e:	e8 4d 39 00 00       	call   1045b0 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100c63:	e8 c8 26 00 00       	call   103330 <curproc>
  100c68:	8b 58 04             	mov    0x4(%eax),%ebx
  100c6b:	e8 c0 26 00 00       	call   103330 <curproc>
  100c70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c74:	8b 00                	mov    (%eax),%eax
  100c76:	89 04 24             	mov    %eax,(%esp)
  100c79:	e8 32 16 00 00       	call   1022b0 <kfree>
  cp->mem = mem;
  100c7e:	e8 ad 26 00 00       	call   103330 <curproc>
  100c83:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100c89:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100c8b:	e8 a0 26 00 00       	call   103330 <curproc>
  100c90:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100c93:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100c96:	e8 95 26 00 00       	call   103330 <curproc>
  100c9b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100ca1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100ca4:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100ca7:	e8 84 26 00 00       	call   103330 <curproc>
  100cac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100cb2:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100cb5:	e8 76 26 00 00       	call   103330 <curproc>
  100cba:	89 04 24             	mov    %eax,(%esp)
  100cbd:	e8 0e 2c 00 00       	call   1038d0 <setupsegs>
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
  100d7b:	e9 40 20 00 00       	jmp    102dc0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100d80:	c7 04 24 ca 64 10 00 	movl   $0x1064ca,(%esp)
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
  100e1b:	e9 d0 1e 00 00       	jmp    102cf0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e20:	c7 04 24 d4 64 10 00 	movl   $0x1064d4,(%esp)
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
  100e8a:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100e91:	e8 fa 34 00 00       	call   104390 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100e96:	8b 43 04             	mov    0x4(%ebx),%eax
  100e99:	85 c0                	test   %eax,%eax
  100e9b:	7e 06                	jle    100ea3 <filedup+0x23>
  100e9d:	8b 13                	mov    (%ebx),%edx
  100e9f:	85 d2                	test   %edx,%edx
  100ea1:	75 0d                	jne    100eb0 <filedup+0x30>
    panic("filedup");
  100ea3:	c7 04 24 dd 64 10 00 	movl   $0x1064dd,(%esp)
  100eaa:	e8 f1 f9 ff ff       	call   1008a0 <panic>
  100eaf:	90                   	nop    
  f->ref++;
  100eb0:	83 c0 01             	add    $0x1,%eax
  100eb3:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100eb6:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100ebd:	e8 8e 34 00 00       	call   104350 <release>
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
  100ed7:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100ede:	e8 ad 34 00 00       	call   104390 <acquire>
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
  100efb:	8b 88 60 9c 10 00    	mov    0x109c60(%eax),%ecx
  100f01:	85 c9                	test   %ecx,%ecx
  100f03:	75 eb                	jne    100ef0 <filealloc+0x20>
      file[i].type = FD_NONE;
  100f05:	8d 04 52             	lea    (%edx,%edx,2),%eax
  100f08:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100f0f:	c7 04 c5 60 9c 10 00 	movl   $0x1,0x109c60(,%eax,8)
  100f16:	01 00 00 00 
      file[i].ref = 1;
  100f1a:	c7 04 c5 64 9c 10 00 	movl   $0x1,0x109c64(,%eax,8)
  100f21:	01 00 00 00 
      release(&file_table_lock);
  100f25:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100f2c:	e8 1f 34 00 00       	call   104350 <release>
      return file + i;
  100f31:	8d 83 60 9c 10 00    	lea    0x109c60(%ebx),%eax
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
  100f3d:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100f44:	e8 07 34 00 00       	call   104350 <release>
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
  100f72:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100f79:	e8 12 34 00 00       	call   104390 <acquire>
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
  100f95:	c7 45 08 c0 a5 10 00 	movl   $0x10a5c0,0x8(%ebp)
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
  100fa8:	e9 a3 33 00 00       	jmp    104350 <release>
  100fad:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  100fb0:	c7 04 24 e5 64 10 00 	movl   $0x1064e5,(%esp)
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
  100fdf:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  100fe6:	e8 65 33 00 00       	call   104350 <release>
  
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
  101017:	e8 84 1e 00 00       	call   102ea0 <pipeclose>
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
  101036:	c7 44 24 04 ef 64 10 	movl   $0x1064ef,0x4(%esp)
  10103d:	00 
  10103e:	c7 04 24 c0 a5 10 00 	movl   $0x10a5c0,(%esp)
  101045:	e8 86 31 00 00       	call   1041d0 <initlock>
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
  10108a:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101091:	e8 fa 32 00 00       	call   104390 <acquire>
  ip->ref++;
  101096:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10109a:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  1010a1:	e8 aa 32 00 00       	call   104350 <release>
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
  1010ba:	bb 94 a6 10 00       	mov    $0x10a694,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1010bf:	83 ec 0c             	sub    $0xc,%esp
  1010c2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1010c5:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  1010cc:	e8 bf 32 00 00       	call   104390 <acquire>
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
  1010da:	81 fb 34 b6 10 00    	cmp    $0x10b634,%ebx
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
  1010fb:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101102:	e8 49 32 00 00       	call   104350 <release>
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
  10111a:	81 fb 34 b6 10 00    	cmp    $0x10b634,%ebx
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
  10113e:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101145:	e8 06 32 00 00       	call   104350 <release>

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
  101154:	c7 04 24 fa 64 10 00 	movl   $0x1064fa,(%esp)
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
  101192:	e8 09 33 00 00       	call   1044a0 <memmove>
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
  10121b:	e8 80 32 00 00       	call   1044a0 <memmove>
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
  101305:	c7 04 24 0a 65 10 00 	movl   $0x10650a,(%esp)
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
  1013e0:	c7 04 24 20 65 10 00 	movl   $0x106520,(%esp)
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
  1014a4:	e8 f7 2f 00 00       	call   1044a0 <memmove>
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
  1014fd:	8b 0c c5 04 a6 10 00 	mov    0x10a604(,%eax,8),%ecx
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
  10156c:	8b 0c c5 00 a6 10 00 	mov    0x10a600(,%eax,8),%ecx
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
  101601:	e8 9a 2e 00 00       	call   1044a0 <memmove>
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
  10164b:	e8 b0 2e 00 00       	call   104500 <strncmp>
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
  101753:	c7 04 24 33 65 10 00 	movl   $0x106533,(%esp)
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
  1017e6:	e8 05 2c 00 00       	call   1043f0 <memset>
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
  101814:	c7 04 24 45 65 10 00 	movl   $0x106545,(%esp)
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
  101851:	e8 9a 2b 00 00       	call   1043f0 <memset>
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
  1018d3:	c7 04 24 57 65 10 00 	movl   $0x106557,(%esp)
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
  1018ec:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  1018f3:	e8 98 2a 00 00       	call   104390 <acquire>
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
  101928:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  10192f:	e8 1c 2a 00 00       	call   104350 <release>
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
  101981:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101988:	e8 03 2a 00 00       	call   104390 <acquire>
    ip->flags &= ~I_BUSY;
  10198d:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101991:	89 34 24             	mov    %esi,(%esp)
  101994:	e8 27 18 00 00       	call   1031c0 <wakeup>
  101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  ip->ref--;
  1019a0:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
  1019a4:	c7 45 08 60 a6 10 00 	movl   $0x10a660,0x8(%ebp)
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
  1019b2:	e9 99 29 00 00       	jmp    104350 <release>
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
  101a09:	c7 04 24 6a 65 10 00 	movl   $0x10656a,(%esp)
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
  101aa1:	e8 ba 2a 00 00       	call   104560 <strncpy>
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
  101ad7:	c7 04 24 74 65 10 00 	movl   $0x106574,(%esp)
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
  101af9:	c7 04 24 81 65 10 00 	movl   $0x106581,(%esp)
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
  101b2b:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101b32:	e8 59 28 00 00       	call   104390 <acquire>
  ip->flags &= ~I_BUSY;
  101b37:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101b3b:	89 1c 24             	mov    %ebx,(%esp)
  101b3e:	e8 7d 16 00 00       	call   1031c0 <wakeup>
  release(&icache.lock);
  101b43:	c7 45 08 60 a6 10 00 	movl   $0x10a660,0x8(%ebp)
}
  101b4a:	83 c4 04             	add    $0x4,%esp
  101b4d:	5b                   	pop    %ebx
  101b4e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101b4f:	e9 fc 27 00 00       	jmp    104350 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101b54:	c7 04 24 89 65 10 00 	movl   $0x106589,(%esp)
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
  101b9e:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101ba5:	e8 e6 27 00 00       	call   104390 <acquire>
  while(ip->flags & I_BUSY)
  101baa:	8b 46 0c             	mov    0xc(%esi),%eax
  101bad:	a8 01                	test   $0x1,%al
  101baf:	74 17                	je     101bc8 <ilock+0x48>
    sleep(ip, &icache.lock);
  101bb1:	c7 44 24 04 60 a6 10 	movl   $0x10a660,0x4(%esp)
  101bb8:	00 
  101bb9:	89 34 24             	mov    %esi,(%esp)
  101bbc:	e8 ff 19 00 00       	call   1035c0 <sleep>

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
  101bce:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101bd5:	e8 76 27 00 00       	call   104350 <release>

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
  101c47:	e8 54 28 00 00       	call   1044a0 <memmove>
    brelse(bp);
  101c4c:	89 1c 24             	mov    %ebx,(%esp)
  101c4f:	e8 ac e3 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101c54:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101c58:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101c5d:	75 81                	jne    101be0 <ilock+0x60>
      panic("ilock: no type");
  101c5f:	c7 04 24 97 65 10 00 	movl   $0x106597,(%esp)
  101c66:	e8 35 ec ff ff       	call   1008a0 <panic>
  101c6b:	90                   	nop    
  101c6c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101c70:	c7 04 24 91 65 10 00 	movl   $0x106591,(%esp)
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
  101c9a:	e8 91 16 00 00       	call   103330 <curproc>
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
  101cf1:	e8 aa 27 00 00       	call   1044a0 <memmove>
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
  101d6c:	e8 2f 27 00 00       	call   1044a0 <memmove>
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
  101e36:	c7 44 24 04 a6 65 10 	movl   $0x1065a6,0x4(%esp)
  101e3d:	00 
  101e3e:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101e45:	e8 86 23 00 00       	call   1041d0 <initlock>
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
  101f13:	c7 04 24 b2 65 10 00 	movl   $0x1065b2,(%esp)
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
  101f47:	a1 18 84 10 00       	mov    0x108418,%eax
  101f4c:	85 c0                	test   %eax,%eax
  101f4e:	0f 84 88 00 00 00    	je     101fdc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  101f54:	c7 04 24 e0 83 10 00 	movl   $0x1083e0,(%esp)
  101f5b:	e8 30 24 00 00       	call   104390 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  101f60:	a1 14 84 10 00       	mov    0x108414,%eax
  101f65:	ba 14 84 10 00       	mov    $0x108414,%edx
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
  101f81:	39 1d 14 84 10 00    	cmp    %ebx,0x108414
  101f87:	75 17                	jne    101fa0 <ide_rw+0x80>
  101f89:	eb 30                	jmp    101fbb <ide_rw+0x9b>
  101f8b:	90                   	nop    
  101f8c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  101f90:	c7 44 24 04 e0 83 10 	movl   $0x1083e0,0x4(%esp)
  101f97:	00 
  101f98:	89 1c 24             	mov    %ebx,(%esp)
  101f9b:	e8 20 16 00 00       	call   1035c0 <sleep>
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
  101faa:	c7 45 08 e0 83 10 00 	movl   $0x1083e0,0x8(%ebp)
}
  101fb1:	83 c4 14             	add    $0x14,%esp
  101fb4:	5b                   	pop    %ebx
  101fb5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  101fb6:	e9 95 23 00 00       	jmp    104350 <release>
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
  101fc4:	c7 04 24 c4 65 10 00 	movl   $0x1065c4,(%esp)
  101fcb:	e8 d0 e8 ff ff       	call   1008a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  101fd0:	c7 04 24 d9 65 10 00 	movl   $0x1065d9,(%esp)
  101fd7:	e8 c4 e8 ff ff       	call   1008a0 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  101fdc:	c7 04 24 ef 65 10 00 	movl   $0x1065ef,(%esp)
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
  101ff8:	c7 04 24 e0 83 10 00 	movl   $0x1083e0,(%esp)
  101fff:	e8 8c 23 00 00       	call   104390 <acquire>
  if((b = ide_queue) == 0){
  102004:	8b 1d 14 84 10 00    	mov    0x108414,%ebx
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
  102020:	e8 9b 11 00 00       	call   1031c0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102025:	8b 43 14             	mov    0x14(%ebx),%eax
  102028:	85 c0                	test   %eax,%eax
  10202a:	a3 14 84 10 00       	mov    %eax,0x108414
  10202f:	74 05                	je     102036 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102031:	e8 4a fe ff ff       	call   101e80 <ide_start_request>

  release(&ide_lock);
  102036:	c7 04 24 e0 83 10 00 	movl   $0x1083e0,(%esp)
  10203d:	e8 0e 23 00 00       	call   104350 <release>
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
  102076:	c7 44 24 04 06 66 10 	movl   $0x106606,0x4(%esp)
  10207d:	00 
  10207e:	c7 04 24 e0 83 10 00 	movl   $0x1083e0,(%esp)
  102085:	e8 46 21 00 00       	call   1041d0 <initlock>
  pic_enable(IRQ_IDE);
  10208a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102091:	e8 8a 0b 00 00       	call   102c20 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102096:	a1 00 bd 10 00       	mov    0x10bd00,%eax
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
  1020d9:	c7 05 18 84 10 00 01 	movl   $0x1,0x108418
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
  1020f0:	8b 15 34 b6 10 00    	mov    0x10b634,%edx
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
  102100:	8b 0d 34 b6 10 00    	mov    0x10b634,%ecx
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
  10211d:	8b 15 80 b6 10 00    	mov    0x10b680,%edx
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
  102169:	8b 0d 80 b6 10 00    	mov    0x10b680,%ecx
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
  102185:	c7 05 34 b6 10 00 00 	movl   $0xfec00000,0x10b634
  10218c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10218f:	e8 5c ff ff ff       	call   1020f0 <ioapic_read>
  102194:	c1 e8 10             	shr    $0x10,%eax
  102197:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10219a:	31 c0                	xor    %eax,%eax
  10219c:	e8 4f ff ff ff       	call   1020f0 <ioapic_read>
  if(id != ioapic_id)
  1021a1:	0f b6 15 84 b6 10 00 	movzbl 0x10b684,%edx
  1021a8:	c1 e8 18             	shr    $0x18,%eax
  1021ab:	39 c2                	cmp    %eax,%edx
  1021ad:	74 0c                	je     1021bb <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1021af:	c7 04 24 0c 66 10 00 	movl   $0x10660c,(%esp)
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

  if(n % PAGE || n <= 0)
  1021fb:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102201:	74 0d                	je     102210 <kalloc+0x20>
    panic("kalloc");
  102203:	c7 04 24 40 66 10 00 	movl   $0x106640,(%esp)
  10220a:	e8 91 e6 ff ff       	call   1008a0 <panic>
  10220f:	90                   	nop    
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  102210:	85 f6                	test   %esi,%esi
  102212:	7e ef                	jle    102203 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  102214:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)
  10221b:	e8 70 21 00 00       	call   104390 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102220:	8b 1d 74 b6 10 00    	mov    0x10b674,%ebx
  102226:	85 db                	test   %ebx,%ebx
  102228:	74 3e                	je     102268 <kalloc+0x78>
    if(r->len == n){
  10222a:	8b 43 04             	mov    0x4(%ebx),%eax
  10222d:	ba 74 b6 10 00       	mov    $0x10b674,%edx
  102232:	39 f0                	cmp    %esi,%eax
  102234:	75 11                	jne    102247 <kalloc+0x57>
  102236:	eb 53                	jmp    10228b <kalloc+0x9b>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102238:	89 da                	mov    %ebx,%edx
  10223a:	8b 1b                	mov    (%ebx),%ebx
  10223c:	85 db                	test   %ebx,%ebx
  10223e:	74 28                	je     102268 <kalloc+0x78>
    if(r->len == n){
  102240:	8b 43 04             	mov    0x4(%ebx),%eax
  102243:	39 f0                	cmp    %esi,%eax
  102245:	74 44                	je     10228b <kalloc+0x9b>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102247:	39 c6                	cmp    %eax,%esi
  102249:	7d ed                	jge    102238 <kalloc+0x48>
      r->len -= n;
  10224b:	29 f0                	sub    %esi,%eax
  10224d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102250:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  102253:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)
  10225a:	e8 f1 20 00 00       	call   104350 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10225f:	83 c4 10             	add    $0x10,%esp
  102262:	89 d8                	mov    %ebx,%eax
  102264:	5b                   	pop    %ebx
  102265:	5e                   	pop    %esi
  102266:	5d                   	pop    %ebp
  102267:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102268:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)

  cprintf("kalloc: out of memory\n");
  10226f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102271:	e8 da 20 00 00       	call   104350 <release>

  cprintf("kalloc: out of memory\n");
  102276:	c7 04 24 47 66 10 00 	movl   $0x106647,(%esp)
  10227d:	e8 7e e4 ff ff       	call   100700 <cprintf>
  return 0;
}
  102282:	83 c4 10             	add    $0x10,%esp
  102285:	89 d8                	mov    %ebx,%eax
  102287:	5b                   	pop    %ebx
  102288:	5e                   	pop    %esi
  102289:	5d                   	pop    %ebp
  10228a:	c3                   	ret    
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10228b:	8b 03                	mov    (%ebx),%eax
  10228d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10228f:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)
  102296:	e8 b5 20 00 00       	call   104350 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10229b:	83 c4 10             	add    $0x10,%esp
  10229e:	89 d8                	mov    %ebx,%eax
  1022a0:	5b                   	pop    %ebx
  1022a1:	5e                   	pop    %esi
  1022a2:	5d                   	pop    %ebp
  1022a3:	c3                   	ret    
  1022a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1022aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001022b0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1022b0:	55                   	push   %ebp
  1022b1:	89 e5                	mov    %esp,%ebp
  1022b3:	57                   	push   %edi
  1022b4:	56                   	push   %esi
  1022b5:	53                   	push   %ebx
  1022b6:	83 ec 1c             	sub    $0x1c,%esp
  1022b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1022bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1022bf:	85 ff                	test   %edi,%edi
  1022c1:	7e 08                	jle    1022cb <kfree+0x1b>
  1022c3:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  1022c9:	74 0c                	je     1022d7 <kfree+0x27>
    panic("kfree");
  1022cb:	c7 04 24 5e 66 10 00 	movl   $0x10665e,(%esp)
  1022d2:	e8 c9 e5 ff ff       	call   1008a0 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1022d7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1022db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1022e2:	00 
  1022e3:	89 1c 24             	mov    %ebx,(%esp)
  1022e6:	e8 05 21 00 00       	call   1043f0 <memset>

  acquire(&kalloc_lock);
  1022eb:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)
  1022f2:	e8 99 20 00 00       	call   104390 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1022f7:	8b 15 74 b6 10 00    	mov    0x10b674,%edx
  1022fd:	c7 45 f0 74 b6 10 00 	movl   $0x10b674,-0x10(%ebp)
  102304:	85 d2                	test   %edx,%edx
  102306:	74 73                	je     10237b <kfree+0xcb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  102308:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  10230b:	39 f2                	cmp    %esi,%edx
  10230d:	77 6c                	ja     10237b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  10230f:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102312:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  102314:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  102317:	76 5c                	jbe    102375 <kfree+0xc5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102319:	39 d6                	cmp    %edx,%esi
  10231b:	c7 45 f0 74 b6 10 00 	movl   $0x10b674,-0x10(%ebp)
  102322:	74 30                	je     102354 <kfree+0xa4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102324:	39 d9                	cmp    %ebx,%ecx
  102326:	74 5f                	je     102387 <kfree+0xd7>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102328:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10232b:	8b 12                	mov    (%edx),%edx
  10232d:	85 d2                	test   %edx,%edx
  10232f:	74 4a                	je     10237b <kfree+0xcb>
  102331:	39 d6                	cmp    %edx,%esi
  102333:	72 46                	jb     10237b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  102335:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102338:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  10233a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  10233d:	77 11                	ja     102350 <kfree+0xa0>
  10233f:	39 cb                	cmp    %ecx,%ebx
  102341:	73 0d                	jae    102350 <kfree+0xa0>
      panic("freeing free page");
  102343:	c7 04 24 64 66 10 00 	movl   $0x106664,(%esp)
  10234a:	e8 51 e5 ff ff       	call   1008a0 <panic>
  10234f:	90                   	nop    
    if(pend == r){  // p next to r: replace r with p
  102350:	39 d6                	cmp    %edx,%esi
  102352:	75 d0                	jne    102324 <kfree+0x74>
      p->len = len + r->len;
  102354:	01 f8                	add    %edi,%eax
  102356:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  102359:	8b 06                	mov    (%esi),%eax
  10235b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102360:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102362:	c7 45 08 40 b6 10 00 	movl   $0x10b640,0x8(%ebp)
}
  102369:	83 c4 1c             	add    $0x1c,%esp
  10236c:	5b                   	pop    %ebx
  10236d:	5e                   	pop    %esi
  10236e:	5f                   	pop    %edi
  10236f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102370:	e9 db 1f 00 00       	jmp    104350 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102375:	39 cb                	cmp    %ecx,%ebx
  102377:	72 ca                	jb     102343 <kfree+0x93>
  102379:	eb 9e                	jmp    102319 <kfree+0x69>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10237e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102380:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  102383:	89 18                	mov    %ebx,(%eax)
  102385:	eb db                	jmp    102362 <kfree+0xb2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102387:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102389:	01 f8                	add    %edi,%eax
  10238b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10238e:	85 c9                	test   %ecx,%ecx
  102390:	74 d0                	je     102362 <kfree+0xb2>
  102392:	39 ce                	cmp    %ecx,%esi
  102394:	75 cc                	jne    102362 <kfree+0xb2>
        r->len += r->next->len;
  102396:	03 46 04             	add    0x4(%esi),%eax
  102399:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  10239c:	8b 06                	mov    (%esi),%eax
  10239e:	89 02                	mov    %eax,(%edx)
  1023a0:	eb c0                	jmp    102362 <kfree+0xb2>
  1023a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001023b0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1023b0:	55                   	push   %ebp
  1023b1:	89 e5                	mov    %esp,%ebp
  1023b3:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1023b4:	bb a4 fe 10 00       	mov    $0x10fea4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1023b9:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1023bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1023c2:	c7 44 24 04 40 66 10 	movl   $0x106640,0x4(%esp)
  1023c9:	00 
  1023ca:	c7 04 24 40 b6 10 00 	movl   $0x10b640,(%esp)
  1023d1:	e8 fa 1d 00 00       	call   1041d0 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1023d6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1023dd:	00 
  1023de:	c7 04 24 76 66 10 00 	movl   $0x106676,(%esp)
  1023e5:	e8 16 e3 ff ff       	call   100700 <cprintf>
  kfree(start, mem * PAGE);
  1023ea:	89 1c 24             	mov    %ebx,(%esp)
  1023ed:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1023f4:	00 
  1023f5:	e8 b6 fe ff ff       	call   1022b0 <kfree>
}
  1023fa:	83 c4 14             	add    $0x14,%esp
  1023fd:	5b                   	pop    %ebx
  1023fe:	5d                   	pop    %ebp
  1023ff:	c3                   	ret    

00102400 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  102400:	55                   	push   %ebp
  102401:	89 e5                	mov    %esp,%ebp
  102403:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  102406:	c7 04 24 20 24 10 00 	movl   $0x102420,(%esp)
  10240d:	e8 be e0 ff ff       	call   1004d0 <console_intr>
}
  102412:	c9                   	leave  
  102413:	c3                   	ret    
  102414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10241a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102420 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102420:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102421:	ba 64 00 00 00       	mov    $0x64,%edx
  102426:	89 e5                	mov    %esp,%ebp
  102428:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  102429:	a8 01                	test   $0x1,%al
  10242b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102430:	74 3e                	je     102470 <kbd_getc+0x50>
  102432:	ba 60 00 00 00       	mov    $0x60,%edx
  102437:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  102438:	3c e0                	cmp    $0xe0,%al
  10243a:	0f 84 84 00 00 00    	je     1024c4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  102440:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102443:	84 c9                	test   %cl,%cl
  102445:	79 2d                	jns    102474 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102447:	8b 15 1c 84 10 00    	mov    0x10841c,%edx
  10244d:	f6 c2 40             	test   $0x40,%dl
  102450:	75 03                	jne    102455 <kbd_getc+0x35>
  102452:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  102455:	0f b6 81 80 66 10 00 	movzbl 0x106680(%ecx),%eax
  10245c:	83 c8 40             	or     $0x40,%eax
  10245f:	0f b6 c0             	movzbl %al,%eax
  102462:	f7 d0                	not    %eax
  102464:	21 d0                	and    %edx,%eax
  102466:	31 d2                	xor    %edx,%edx
  102468:	a3 1c 84 10 00       	mov    %eax,0x10841c
  10246d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102470:	5d                   	pop    %ebp
  102471:	89 d0                	mov    %edx,%eax
  102473:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102474:	a1 1c 84 10 00       	mov    0x10841c,%eax
  102479:	a8 40                	test   $0x40,%al
  10247b:	74 0b                	je     102488 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10247d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102480:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  102483:	a3 1c 84 10 00       	mov    %eax,0x10841c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102488:	0f b6 91 80 67 10 00 	movzbl 0x106780(%ecx),%edx
  10248f:	0f b6 81 80 66 10 00 	movzbl 0x106680(%ecx),%eax
  102496:	0b 05 1c 84 10 00    	or     0x10841c,%eax
  10249c:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  10249e:	89 c2                	mov    %eax,%edx
  1024a0:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  1024a3:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1024a5:	8b 14 95 80 68 10 00 	mov    0x106880(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1024ac:	a3 1c 84 10 00       	mov    %eax,0x10841c
  c = charcode[shift & (CTL | SHIFT)][data];
  1024b1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  1024b5:	74 b9                	je     102470 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  1024b7:	8d 42 9f             	lea    -0x61(%edx),%eax
  1024ba:	83 f8 19             	cmp    $0x19,%eax
  1024bd:	77 12                	ja     1024d1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  1024bf:	83 ea 20             	sub    $0x20,%edx
  1024c2:	eb ac                	jmp    102470 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1024c4:	83 0d 1c 84 10 00 40 	orl    $0x40,0x10841c
  1024cb:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1024cd:	5d                   	pop    %ebp
  1024ce:	89 d0                	mov    %edx,%eax
  1024d0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1024d1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1024d4:	83 f8 19             	cmp    $0x19,%eax
  1024d7:	77 97                	ja     102470 <kbd_getc+0x50>
      c += 'a' - 'A';
  1024d9:	83 c2 20             	add    $0x20,%edx
  1024dc:	eb 92                	jmp    102470 <kbd_getc+0x50>
  1024de:	90                   	nop    
  1024df:	90                   	nop    

001024e0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1024e0:	8b 0d 78 b6 10 00    	mov    0x10b678,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1024e6:	55                   	push   %ebp
  1024e7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1024e9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1024ec:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1024ee:	8b 41 20             	mov    0x20(%ecx),%eax
}
  1024f1:	5d                   	pop    %ebp
  1024f2:	c3                   	ret    
  1024f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102500 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  102500:	a1 78 b6 10 00       	mov    0x10b678,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  102505:	55                   	push   %ebp
  102506:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  102508:	85 c0                	test   %eax,%eax
  10250a:	0f 84 ea 00 00 00    	je     1025fa <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  102510:	ba 3f 01 00 00       	mov    $0x13f,%edx
  102515:	b8 3c 00 00 00       	mov    $0x3c,%eax
  10251a:	e8 c1 ff ff ff       	call   1024e0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  10251f:	ba 0b 00 00 00       	mov    $0xb,%edx
  102524:	b8 f8 00 00 00       	mov    $0xf8,%eax
  102529:	e8 b2 ff ff ff       	call   1024e0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10252e:	ba 20 00 02 00       	mov    $0x20020,%edx
  102533:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102538:	e8 a3 ff ff ff       	call   1024e0 <lapicw>
  lapicw(TICR, 10000000); 
  10253d:	ba 80 96 98 00       	mov    $0x989680,%edx
  102542:	b8 e0 00 00 00       	mov    $0xe0,%eax
  102547:	e8 94 ff ff ff       	call   1024e0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10254c:	ba 00 00 01 00       	mov    $0x10000,%edx
  102551:	b8 d4 00 00 00       	mov    $0xd4,%eax
  102556:	e8 85 ff ff ff       	call   1024e0 <lapicw>
  lapicw(LINT1, MASKED);
  10255b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  102560:	ba 00 00 01 00       	mov    $0x10000,%edx
  102565:	e8 76 ff ff ff       	call   1024e0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10256a:	a1 78 b6 10 00       	mov    0x10b678,%eax
  10256f:	83 c0 30             	add    $0x30,%eax
  102572:	8b 00                	mov    (%eax),%eax
  102574:	c1 e8 10             	shr    $0x10,%eax
  102577:	3c 03                	cmp    $0x3,%al
  102579:	77 6e                	ja     1025e9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10257b:	ba 33 00 00 00       	mov    $0x33,%edx
  102580:	b8 dc 00 00 00       	mov    $0xdc,%eax
  102585:	e8 56 ff ff ff       	call   1024e0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10258a:	31 d2                	xor    %edx,%edx
  10258c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  102591:	e8 4a ff ff ff       	call   1024e0 <lapicw>
  lapicw(ESR, 0);
  102596:	31 d2                	xor    %edx,%edx
  102598:	b8 a0 00 00 00       	mov    $0xa0,%eax
  10259d:	e8 3e ff ff ff       	call   1024e0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1025a2:	31 d2                	xor    %edx,%edx
  1025a4:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1025a9:	e8 32 ff ff ff       	call   1024e0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1025ae:	31 d2                	xor    %edx,%edx
  1025b0:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1025b5:	e8 26 ff ff ff       	call   1024e0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1025ba:	ba 00 85 08 00       	mov    $0x88500,%edx
  1025bf:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1025c4:	e8 17 ff ff ff       	call   1024e0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1025c9:	8b 15 78 b6 10 00    	mov    0x10b678,%edx
  1025cf:	81 c2 00 03 00 00    	add    $0x300,%edx
  1025d5:	8b 02                	mov    (%edx),%eax
  1025d7:	f6 c4 10             	test   $0x10,%ah
  1025da:	75 f9                	jne    1025d5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1025dc:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1025dd:	31 d2                	xor    %edx,%edx
  1025df:	b8 20 00 00 00       	mov    $0x20,%eax
  1025e4:	e9 f7 fe ff ff       	jmp    1024e0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1025e9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1025ee:	b8 d0 00 00 00       	mov    $0xd0,%eax
  1025f3:	e8 e8 fe ff ff       	call   1024e0 <lapicw>
  1025f8:	eb 81                	jmp    10257b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1025fa:	5d                   	pop    %ebp
  1025fb:	c3                   	ret    
  1025fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00102600 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  102600:	8b 15 78 b6 10 00    	mov    0x10b678,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  102606:	55                   	push   %ebp
  102607:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102609:	85 d2                	test   %edx,%edx
  10260b:	74 13                	je     102620 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  10260d:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  10260e:	31 d2                	xor    %edx,%edx
  102610:	b8 2c 00 00 00       	mov    $0x2c,%eax
  102615:	e9 c6 fe ff ff       	jmp    1024e0 <lapicw>
  10261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  102620:	5d                   	pop    %ebp
  102621:	c3                   	ret    
  102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102630 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102630:	55                   	push   %ebp
  volatile int j = 0;
  102631:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102633:	89 e5                	mov    %esp,%ebp
  102635:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  102638:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10263f:	eb 14                	jmp    102655 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102641:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102648:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10264b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102650:	7e 0e                	jle    102660 <microdelay+0x30>
  102652:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102655:	85 d2                	test   %edx,%edx
  102657:	7f e8                	jg     102641 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  102659:	c9                   	leave  
  10265a:	c3                   	ret    
  10265b:	90                   	nop    
  10265c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102660:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102663:	83 c0 01             	add    $0x1,%eax
  102666:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102669:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10266c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102671:	7f df                	jg     102652 <microdelay+0x22>
  102673:	eb eb                	jmp    102660 <microdelay+0x30>
  102675:	8d 74 26 00          	lea    0x0(%esi),%esi
  102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102680 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102680:	55                   	push   %ebp
  102681:	89 e5                	mov    %esp,%ebp
  102683:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102686:	9c                   	pushf  
  102687:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102688:	f6 c4 02             	test   $0x2,%ah
  10268b:	74 12                	je     10269f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10268d:	a1 20 84 10 00       	mov    0x108420,%eax
  102692:	83 c0 01             	add    $0x1,%eax
  102695:	a3 20 84 10 00       	mov    %eax,0x108420
  10269a:	83 e8 01             	sub    $0x1,%eax
  10269d:	74 14                	je     1026b3 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10269f:	8b 15 78 b6 10 00    	mov    0x10b678,%edx
  1026a5:	31 c0                	xor    %eax,%eax
  1026a7:	85 d2                	test   %edx,%edx
  1026a9:	74 06                	je     1026b1 <cpu+0x31>
    return lapic[ID]>>24;
  1026ab:	8b 42 20             	mov    0x20(%edx),%eax
  1026ae:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1026b1:	c9                   	leave  
  1026b2:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1026b3:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1026b5:	8b 40 04             	mov    0x4(%eax),%eax
  1026b8:	c7 04 24 90 68 10 00 	movl   $0x106890,(%esp)
  1026bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1026c3:	e8 38 e0 ff ff       	call   100700 <cprintf>
  1026c8:	eb d5                	jmp    10269f <cpu+0x1f>
  1026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001026d0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1026d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1026d1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1026d6:	89 e5                	mov    %esp,%ebp
  1026d8:	ba 70 00 00 00       	mov    $0x70,%edx
  1026dd:	56                   	push   %esi
  1026de:	53                   	push   %ebx
  1026df:	8b 75 0c             	mov    0xc(%ebp),%esi
  1026e2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1026e6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1026e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1026ec:	b2 71                	mov    $0x71,%dl
  1026ee:	ee                   	out    %al,(%dx)
  1026ef:	c1 e3 18             	shl    $0x18,%ebx
  1026f2:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1026f7:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  1026f9:	c1 ee 04             	shr    $0x4,%esi
  1026fc:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102703:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102706:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  10270d:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  10270f:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  102715:	e8 c6 fd ff ff       	call   1024e0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  10271a:	ba 00 c5 00 00       	mov    $0xc500,%edx
  10271f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102724:	e8 b7 fd ff ff       	call   1024e0 <lapicw>
  microdelay(200);
  102729:	b8 c8 00 00 00       	mov    $0xc8,%eax
  10272e:	e8 fd fe ff ff       	call   102630 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  102733:	ba 00 85 00 00       	mov    $0x8500,%edx
  102738:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10273d:	e8 9e fd ff ff       	call   1024e0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102742:	b8 64 00 00 00       	mov    $0x64,%eax
  102747:	e8 e4 fe ff ff       	call   102630 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10274c:	89 da                	mov    %ebx,%edx
  10274e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102753:	e8 88 fd ff ff       	call   1024e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102758:	89 f2                	mov    %esi,%edx
  10275a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10275f:	e8 7c fd ff ff       	call   1024e0 <lapicw>
    microdelay(200);
  102764:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102769:	e8 c2 fe ff ff       	call   102630 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10276e:	89 da                	mov    %ebx,%edx
  102770:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102775:	e8 66 fd ff ff       	call   1024e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  10277a:	89 f2                	mov    %esi,%edx
  10277c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102781:	e8 5a fd ff ff       	call   1024e0 <lapicw>
    microdelay(200);
  102786:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  10278b:	5b                   	pop    %ebx
  10278c:	5e                   	pop    %esi
  10278d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  10278e:	e9 9d fe ff ff       	jmp    102630 <microdelay>
  102793:	90                   	nop    
  102794:	90                   	nop    
  102795:	90                   	nop    
  102796:	90                   	nop    
  102797:	90                   	nop    
  102798:	90                   	nop    
  102799:	90                   	nop    
  10279a:	90                   	nop    
  10279b:	90                   	nop    
  10279c:	90                   	nop    
  10279d:	90                   	nop    
  10279e:	90                   	nop    
  10279f:	90                   	nop    

001027a0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  1027a0:	55                   	push   %ebp
  1027a1:	89 e5                	mov    %esp,%ebp
  1027a3:	53                   	push   %ebx
  1027a4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  1027a7:	e8 d4 fe ff ff       	call   102680 <cpu>
  1027ac:	c7 04 24 bc 68 10 00 	movl   $0x1068bc,(%esp)
  1027b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027b7:	e8 44 df ff ff       	call   100700 <cprintf>
  idtinit();
  1027bc:	e8 2f 2f 00 00       	call   1056f0 <idtinit>
  if(cpu() != mp_bcpu())
  1027c1:	e8 ba fe ff ff       	call   102680 <cpu>
  1027c6:	89 c3                	mov    %eax,%ebx
  1027c8:	e8 c3 01 00 00       	call   102990 <mp_bcpu>
  1027cd:	39 c3                	cmp    %eax,%ebx
  1027cf:	74 0d                	je     1027de <mpmain+0x3e>
    lapic_init(cpu());
  1027d1:	e8 aa fe ff ff       	call   102680 <cpu>
  1027d6:	89 04 24             	mov    %eax,(%esp)
  1027d9:	e8 22 fd ff ff       	call   102500 <lapic_init>
  setupsegs(0);
  1027de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1027e5:	e8 e6 10 00 00       	call   1038d0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  1027ea:	e8 91 fe ff ff       	call   102680 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1027ef:	ba 01 00 00 00       	mov    $0x1,%edx
  1027f4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1027fa:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  102800:	89 d0                	mov    %edx,%eax
  102802:	f0 87 81 a0 b6 10 00 	lock xchg %eax,0x10b6a0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  102809:	e8 72 fe ff ff       	call   102680 <cpu>
  10280e:	c7 04 24 cb 68 10 00 	movl   $0x1068cb,(%esp)
  102815:	89 44 24 04          	mov    %eax,0x4(%esp)
  102819:	e8 e2 de ff ff       	call   100700 <cprintf>
  scheduler();
  10281e:	e8 dd 12 00 00       	call   103b00 <scheduler>
  102823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102830 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102830:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102834:	83 e4 f0             	and    $0xfffffff0,%esp
  102837:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10283a:	b8 a4 ee 10 00       	mov    $0x10eea4,%eax
  10283f:	2d 6e 83 10 00       	sub    $0x10836e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102844:	55                   	push   %ebp
  102845:	89 e5                	mov    %esp,%ebp
  102847:	53                   	push   %ebx
  102848:	51                   	push   %ecx
  102849:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10284c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102850:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102857:	00 
  102858:	c7 04 24 6e 83 10 00 	movl   $0x10836e,(%esp)
  10285f:	e8 8c 1b 00 00       	call   1043f0 <memset>

  mp_init(); // collect info about this machine
  102864:	e8 d7 01 00 00       	call   102a40 <mp_init>
  lapic_init(mp_bcpu());
  102869:	e8 22 01 00 00       	call   102990 <mp_bcpu>
  10286e:	89 04 24             	mov    %eax,(%esp)
  102871:	e8 8a fc ff ff       	call   102500 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102876:	e8 05 fe ff ff       	call   102680 <cpu>
  10287b:	c7 04 24 de 68 10 00 	movl   $0x1068de,(%esp)
  102882:	89 44 24 04          	mov    %eax,0x4(%esp)
  102886:	e8 75 de ff ff       	call   100700 <cprintf>

  pinit();         // process table
  10288b:	e8 20 19 00 00       	call   1041b0 <pinit>
  binit();         // buffer cache
  102890:	e8 fb d8 ff ff       	call   100190 <binit>
  pic_init();      // interrupt controller
  102895:	e8 a6 03 00 00       	call   102c40 <pic_init>
  ioapic_init();   // another interrupt controller
  10289a:	e8 c1 f8 ff ff       	call   102160 <ioapic_init>
  10289f:	90                   	nop    
  kinit();         // physical memory allocator
  1028a0:	e8 0b fb ff ff       	call   1023b0 <kinit>
  tvinit();        // trap vectors
  1028a5:	e8 b6 30 00 00       	call   105960 <tvinit>
  fileinit();      // file table
  1028aa:	e8 81 e7 ff ff       	call   101030 <fileinit>
  1028af:	90                   	nop    
  iinit();         // inode cache
  1028b0:	e8 7b f5 ff ff       	call   101e30 <iinit>
  console_init();  // I/O devices & their interrupts
  1028b5:	e8 36 d9 ff ff       	call   1001f0 <console_init>
  ide_init();      // disk
  1028ba:	e8 b1 f7 ff ff       	call   102070 <ide_init>
  if(!ismp)
  1028bf:	a1 80 b6 10 00       	mov    0x10b680,%eax
  1028c4:	85 c0                	test   %eax,%eax
  1028c6:	0f 84 ac 00 00 00    	je     102978 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  1028cc:	e8 ef 17 00 00       	call   1040c0 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  1028d1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  1028d8:	00 
  1028d9:	c7 44 24 04 14 83 10 	movl   $0x108314,0x4(%esp)
  1028e0:	00 
  1028e1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  1028e8:	e8 b3 1b 00 00       	call   1044a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  1028ed:	69 05 00 bd 10 00 cc 	imul   $0xcc,0x10bd00,%eax
  1028f4:	00 00 00 
  1028f7:	05 a0 b6 10 00       	add    $0x10b6a0,%eax
  1028fc:	3d a0 b6 10 00       	cmp    $0x10b6a0,%eax
  102901:	76 70                	jbe    102973 <main+0x143>
  102903:	bb a0 b6 10 00       	mov    $0x10b6a0,%ebx
    if(c == cpus+cpu())  // We've started already.
  102908:	e8 73 fd ff ff       	call   102680 <cpu>
  10290d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102913:	05 a0 b6 10 00       	add    $0x10b6a0,%eax
  102918:	39 d8                	cmp    %ebx,%eax
  10291a:	74 3e                	je     10295a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  10291c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102923:	e8 c8 f8 ff ff       	call   1021f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102928:	c7 05 f8 6f 00 00 a0 	movl   $0x1027a0,0x6ff8
  10292f:	27 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102932:	05 00 10 00 00       	add    $0x1000,%eax
  102937:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  10293c:	0f b6 03             	movzbl (%ebx),%eax
  10293f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102946:	00 
  102947:	89 04 24             	mov    %eax,(%esp)
  10294a:	e8 81 fd ff ff       	call   1026d0 <lapic_startap>
  10294f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102950:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102956:	85 c0                	test   %eax,%eax
  102958:	74 f6                	je     102950 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  10295a:	69 05 00 bd 10 00 cc 	imul   $0xcc,0x10bd00,%eax
  102961:	00 00 00 
  102964:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  10296a:	05 a0 b6 10 00       	add    $0x10b6a0,%eax
  10296f:	39 d8                	cmp    %ebx,%eax
  102971:	77 95                	ja     102908 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102973:	e8 28 fe ff ff       	call   1027a0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102978:	e8 13 2d 00 00       	call   105690 <timer_init>
  10297d:	8d 76 00             	lea    0x0(%esi),%esi
  102980:	e9 47 ff ff ff       	jmp    1028cc <main+0x9c>
  102985:	90                   	nop    
  102986:	90                   	nop    
  102987:	90                   	nop    
  102988:	90                   	nop    
  102989:	90                   	nop    
  10298a:	90                   	nop    
  10298b:	90                   	nop    
  10298c:	90                   	nop    
  10298d:	90                   	nop    
  10298e:	90                   	nop    
  10298f:	90                   	nop    

00102990 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102990:	a1 24 84 10 00       	mov    0x108424,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102995:	55                   	push   %ebp
  102996:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102998:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102999:	2d a0 b6 10 00       	sub    $0x10b6a0,%eax
  10299e:	c1 f8 02             	sar    $0x2,%eax
  1029a1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  1029a7:	c3                   	ret    
  1029a8:	90                   	nop    
  1029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001029b0 <sum>:

static uchar
sum(uchar *addr, int len)
{
  1029b0:	55                   	push   %ebp
  1029b1:	89 e5                	mov    %esp,%ebp
  1029b3:	56                   	push   %esi
  1029b4:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029b6:	31 c0                	xor    %eax,%eax
  1029b8:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  1029ba:	53                   	push   %ebx
  1029bb:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029bd:	7e 14                	jle    1029d3 <sum+0x23>
  1029bf:	31 c9                	xor    %ecx,%ecx
  1029c1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  1029c3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029c7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  1029ca:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1029cc:	39 d9                	cmp    %ebx,%ecx
  1029ce:	75 f3                	jne    1029c3 <sum+0x13>
  1029d0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  1029d3:	5b                   	pop    %ebx
  1029d4:	5e                   	pop    %esi
  1029d5:	5d                   	pop    %ebp
  1029d6:	c3                   	ret    
  1029d7:	89 f6                	mov    %esi,%esi
  1029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001029e0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  1029e0:	55                   	push   %ebp
  1029e1:	89 e5                	mov    %esp,%ebp
  1029e3:	56                   	push   %esi
  1029e4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  1029e5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  1029e8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  1029eb:	39 f0                	cmp    %esi,%eax
  1029ed:	73 40                	jae    102a2f <mp_search1+0x4f>
  1029ef:	89 c3                	mov    %eax,%ebx
  1029f1:	eb 07                	jmp    1029fa <mp_search1+0x1a>
  1029f3:	83 c3 10             	add    $0x10,%ebx
  1029f6:	39 de                	cmp    %ebx,%esi
  1029f8:	76 35                	jbe    102a2f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1029fa:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102a01:	00 
  102a02:	c7 44 24 04 f5 68 10 	movl   $0x1068f5,0x4(%esp)
  102a09:	00 
  102a0a:	89 1c 24             	mov    %ebx,(%esp)
  102a0d:	e8 0e 1a 00 00       	call   104420 <memcmp>
  102a12:	85 c0                	test   %eax,%eax
  102a14:	75 dd                	jne    1029f3 <mp_search1+0x13>
  102a16:	ba 10 00 00 00       	mov    $0x10,%edx
  102a1b:	89 d8                	mov    %ebx,%eax
  102a1d:	e8 8e ff ff ff       	call   1029b0 <sum>
  102a22:	84 c0                	test   %al,%al
  102a24:	75 cd                	jne    1029f3 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  102a26:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102a29:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102a2b:	5b                   	pop    %ebx
  102a2c:	5e                   	pop    %esi
  102a2d:	5d                   	pop    %ebp
  102a2e:	c3                   	ret    
  102a2f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102a32:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102a34:	5b                   	pop    %ebx
  102a35:	5e                   	pop    %esi
  102a36:	5d                   	pop    %ebp
  102a37:	c3                   	ret    
  102a38:	90                   	nop    
  102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102a40 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102a40:	55                   	push   %ebp
  102a41:	89 e5                	mov    %esp,%ebp
  102a43:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102a46:	69 05 00 bd 10 00 cc 	imul   $0xcc,0x10bd00,%eax
  102a4d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  102a50:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102a53:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102a56:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102a59:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102a60:	05 a0 b6 10 00       	add    $0x10b6a0,%eax
  102a65:	a3 24 84 10 00       	mov    %eax,0x108424
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102a6a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102a71:	c1 e1 08             	shl    $0x8,%ecx
  102a74:	09 c1                	or     %eax,%ecx
  102a76:	c1 e1 04             	shl    $0x4,%ecx
  102a79:	85 c9                	test   %ecx,%ecx
  102a7b:	74 53                	je     102ad0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  102a7d:	ba 00 04 00 00       	mov    $0x400,%edx
  102a82:	89 c8                	mov    %ecx,%eax
  102a84:	e8 57 ff ff ff       	call   1029e0 <mp_search1>
  102a89:	85 c0                	test   %eax,%eax
  102a8b:	89 c6                	mov    %eax,%esi
  102a8d:	74 6c                	je     102afb <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102a8f:	8b 5e 04             	mov    0x4(%esi),%ebx
  102a92:	85 db                	test   %ebx,%ebx
  102a94:	74 2a                	je     102ac0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102a96:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102a9d:	00 
  102a9e:	c7 44 24 04 fa 68 10 	movl   $0x1068fa,0x4(%esp)
  102aa5:	00 
  102aa6:	89 1c 24             	mov    %ebx,(%esp)
  102aa9:	e8 72 19 00 00       	call   104420 <memcmp>
  102aae:	85 c0                	test   %eax,%eax
  102ab0:	75 0e                	jne    102ac0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102ab2:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102ab6:	3c 01                	cmp    $0x1,%al
  102ab8:	74 5c                	je     102b16 <mp_init+0xd6>
  102aba:	3c 04                	cmp    $0x4,%al
  102abc:	74 58                	je     102b16 <mp_init+0xd6>
  102abe:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102ac0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102ac3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102ac6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102ac9:	89 ec                	mov    %ebp,%esp
  102acb:	5d                   	pop    %ebp
  102acc:	c3                   	ret    
  102acd:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102ad0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102ad7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102ade:	c1 e0 08             	shl    $0x8,%eax
  102ae1:	09 d0                	or     %edx,%eax
  102ae3:	ba 00 04 00 00       	mov    $0x400,%edx
  102ae8:	c1 e0 0a             	shl    $0xa,%eax
  102aeb:	2d 00 04 00 00       	sub    $0x400,%eax
  102af0:	e8 eb fe ff ff       	call   1029e0 <mp_search1>
  102af5:	85 c0                	test   %eax,%eax
  102af7:	89 c6                	mov    %eax,%esi
  102af9:	75 94                	jne    102a8f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102afb:	ba 00 00 01 00       	mov    $0x10000,%edx
  102b00:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102b05:	e8 d6 fe ff ff       	call   1029e0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102b0a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102b0c:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102b0e:	0f 85 7b ff ff ff    	jne    102a8f <mp_init+0x4f>
  102b14:	eb aa                	jmp    102ac0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102b16:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102b1a:	89 d8                	mov    %ebx,%eax
  102b1c:	e8 8f fe ff ff       	call   1029b0 <sum>
  102b21:	84 c0                	test   %al,%al
  102b23:	75 9b                	jne    102ac0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102b25:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b28:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102b2b:	c7 05 80 b6 10 00 01 	movl   $0x1,0x10b680
  102b32:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102b35:	a3 78 b6 10 00       	mov    %eax,0x10b678

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b3a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102b3e:	01 c3                	add    %eax,%ebx
  102b40:	39 da                	cmp    %ebx,%edx
  102b42:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102b45:	73 57                	jae    102b9e <mp_init+0x15e>
  102b47:	8b 3d 24 84 10 00    	mov    0x108424,%edi
  102b4d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  102b50:	0f b6 02             	movzbl (%edx),%eax
  102b53:	3c 04                	cmp    $0x4,%al
  102b55:	0f b6 c8             	movzbl %al,%ecx
  102b58:	76 26                	jbe    102b80 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102b5a:	89 3d 24 84 10 00    	mov    %edi,0x108424
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102b60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102b64:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  102b6b:	e8 90 db ff ff       	call   100700 <cprintf>
      panic("mp_init");
  102b70:	c7 04 24 ff 68 10 00 	movl   $0x1068ff,(%esp)
  102b77:	e8 24 dd ff ff       	call   1008a0 <panic>
  102b7c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102b80:	ff 24 8d 2c 69 10 00 	jmp    *0x10692c(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102b87:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102b8b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102b8e:	a2 84 b6 10 00       	mov    %al,0x10b684
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102b93:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  102b96:	72 b8                	jb     102b50 <mp_init+0x110>
  102b98:	89 3d 24 84 10 00    	mov    %edi,0x108424
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102b9e:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102ba2:	0f 84 18 ff ff ff    	je     102ac0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102ba8:	b8 70 00 00 00       	mov    $0x70,%eax
  102bad:	ba 22 00 00 00       	mov    $0x22,%edx
  102bb2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102bb3:	b2 23                	mov    $0x23,%dl
  102bb5:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102bb6:	83 c8 01             	or     $0x1,%eax
  102bb9:	ee                   	out    %al,(%dx)
  102bba:	e9 01 ff ff ff       	jmp    102ac0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102bbf:	83 c2 08             	add    $0x8,%edx
  102bc2:	eb cf                	jmp    102b93 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102bc4:	8b 1d 00 bd 10 00    	mov    0x10bd00,%ebx
  102bca:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102bce:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102bd4:	88 81 a0 b6 10 00    	mov    %al,0x10b6a0(%ecx)
      if(proc->flags & MPBOOT)
  102bda:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102bde:	74 06                	je     102be6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  102be0:	8d b9 a0 b6 10 00    	lea    0x10b6a0(%ecx),%edi
      ncpu++;
  102be6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  102be9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102bec:	a3 00 bd 10 00       	mov    %eax,0x10bd00
  102bf1:	eb a0                	jmp    102b93 <mp_init+0x153>
  102bf3:	90                   	nop    
  102bf4:	90                   	nop    
  102bf5:	90                   	nop    
  102bf6:	90                   	nop    
  102bf7:	90                   	nop    
  102bf8:	90                   	nop    
  102bf9:	90                   	nop    
  102bfa:	90                   	nop    
  102bfb:	90                   	nop    
  102bfc:	90                   	nop    
  102bfd:	90                   	nop    
  102bfe:	90                   	nop    
  102bff:	90                   	nop    

00102c00 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  102c00:	55                   	push   %ebp
  102c01:	89 c1                	mov    %eax,%ecx
  102c03:	89 e5                	mov    %esp,%ebp
  102c05:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  102c0a:	66 a3 e0 7e 10 00    	mov    %ax,0x107ee0
  102c10:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  102c11:	66 c1 e9 08          	shr    $0x8,%cx
  102c15:	b2 a1                	mov    $0xa1,%dl
  102c17:	89 c8                	mov    %ecx,%eax
  102c19:	ee                   	out    %al,(%dx)
  102c1a:	5d                   	pop    %ebp
  102c1b:	c3                   	ret    
  102c1c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102c20 <pic_enable>:

void
pic_enable(int irq)
{
  102c20:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102c21:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102c26:	89 e5                	mov    %esp,%ebp
  102c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  102c2b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  102c2c:	d3 c0                	rol    %cl,%eax
  102c2e:	66 23 05 e0 7e 10 00 	and    0x107ee0,%ax
  102c35:	0f b7 c0             	movzwl %ax,%eax
  102c38:	eb c6                	jmp    102c00 <pic_setmask>
  102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102c40 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102c40:	55                   	push   %ebp
  102c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102c46:	89 e5                	mov    %esp,%ebp
  102c48:	83 ec 0c             	sub    $0xc,%esp
  102c4b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102c4f:	be 21 00 00 00       	mov    $0x21,%esi
  102c54:	89 1c 24             	mov    %ebx,(%esp)
  102c57:	89 f2                	mov    %esi,%edx
  102c59:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102c5d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102c5e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  102c63:	89 ca                	mov    %ecx,%edx
  102c65:	ee                   	out    %al,(%dx)
  102c66:	bf 11 00 00 00       	mov    $0x11,%edi
  102c6b:	b2 20                	mov    $0x20,%dl
  102c6d:	89 f8                	mov    %edi,%eax
  102c6f:	ee                   	out    %al,(%dx)
  102c70:	b8 20 00 00 00       	mov    $0x20,%eax
  102c75:	89 f2                	mov    %esi,%edx
  102c77:	ee                   	out    %al,(%dx)
  102c78:	b8 04 00 00 00       	mov    $0x4,%eax
  102c7d:	ee                   	out    %al,(%dx)
  102c7e:	bb 03 00 00 00       	mov    $0x3,%ebx
  102c83:	89 d8                	mov    %ebx,%eax
  102c85:	ee                   	out    %al,(%dx)
  102c86:	be a0 00 00 00       	mov    $0xa0,%esi
  102c8b:	89 f8                	mov    %edi,%eax
  102c8d:	89 f2                	mov    %esi,%edx
  102c8f:	ee                   	out    %al,(%dx)
  102c90:	b8 28 00 00 00       	mov    $0x28,%eax
  102c95:	89 ca                	mov    %ecx,%edx
  102c97:	ee                   	out    %al,(%dx)
  102c98:	b8 02 00 00 00       	mov    $0x2,%eax
  102c9d:	ee                   	out    %al,(%dx)
  102c9e:	89 d8                	mov    %ebx,%eax
  102ca0:	ee                   	out    %al,(%dx)
  102ca1:	b9 68 00 00 00       	mov    $0x68,%ecx
  102ca6:	b2 20                	mov    $0x20,%dl
  102ca8:	89 c8                	mov    %ecx,%eax
  102caa:	ee                   	out    %al,(%dx)
  102cab:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102cb0:	89 d8                	mov    %ebx,%eax
  102cb2:	ee                   	out    %al,(%dx)
  102cb3:	89 c8                	mov    %ecx,%eax
  102cb5:	89 f2                	mov    %esi,%edx
  102cb7:	ee                   	out    %al,(%dx)
  102cb8:	89 d8                	mov    %ebx,%eax
  102cba:	ee                   	out    %al,(%dx)
  102cbb:	0f b7 05 e0 7e 10 00 	movzwl 0x107ee0,%eax
  102cc2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102cc6:	74 18                	je     102ce0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  102cc8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102ccb:	0f b7 c0             	movzwl %ax,%eax
}
  102cce:	8b 74 24 04          	mov    0x4(%esp),%esi
  102cd2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102cd6:	89 ec                	mov    %ebp,%esp
  102cd8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102cd9:	e9 22 ff ff ff       	jmp    102c00 <pic_setmask>
  102cde:	66 90                	xchg   %ax,%ax
}
  102ce0:	8b 1c 24             	mov    (%esp),%ebx
  102ce3:	8b 74 24 04          	mov    0x4(%esp),%esi
  102ce7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102ceb:	89 ec                	mov    %ebp,%esp
  102ced:	5d                   	pop    %ebp
  102cee:	c3                   	ret    
  102cef:	90                   	nop    

00102cf0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102cf0:	55                   	push   %ebp
  102cf1:	89 e5                	mov    %esp,%ebp
  102cf3:	57                   	push   %edi
  102cf4:	56                   	push   %esi
  102cf5:	53                   	push   %ebx
  102cf6:	83 ec 0c             	sub    $0xc,%esp
  102cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102cfc:	8d 7b 10             	lea    0x10(%ebx),%edi
  102cff:	89 3c 24             	mov    %edi,(%esp)
  102d02:	e8 89 16 00 00       	call   104390 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102d07:	8b 43 0c             	mov    0xc(%ebx),%eax
  102d0a:	3b 43 08             	cmp    0x8(%ebx),%eax
  102d0d:	75 4f                	jne    102d5e <piperead+0x6e>
  102d0f:	8b 53 04             	mov    0x4(%ebx),%edx
  102d12:	85 d2                	test   %edx,%edx
  102d14:	74 48                	je     102d5e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102d16:	8d 73 0c             	lea    0xc(%ebx),%esi
  102d19:	eb 20                	jmp    102d3b <piperead+0x4b>
  102d1b:	90                   	nop    
  102d1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  102d20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102d24:	89 34 24             	mov    %esi,(%esp)
  102d27:	e8 94 08 00 00       	call   1035c0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102d2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  102d2f:	3b 43 08             	cmp    0x8(%ebx),%eax
  102d32:	75 2a                	jne    102d5e <piperead+0x6e>
  102d34:	8b 53 04             	mov    0x4(%ebx),%edx
  102d37:	85 d2                	test   %edx,%edx
  102d39:	74 23                	je     102d5e <piperead+0x6e>
    if(cp->killed){
  102d3b:	e8 f0 05 00 00       	call   103330 <curproc>
  102d40:	8b 40 1c             	mov    0x1c(%eax),%eax
  102d43:	85 c0                	test   %eax,%eax
  102d45:	74 d9                	je     102d20 <piperead+0x30>
      release(&p->lock);
  102d47:	89 3c 24             	mov    %edi,(%esp)
  102d4a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  102d4f:	e8 fc 15 00 00       	call   104350 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102d54:	83 c4 0c             	add    $0xc,%esp
  102d57:	89 f0                	mov    %esi,%eax
  102d59:	5b                   	pop    %ebx
  102d5a:	5e                   	pop    %esi
  102d5b:	5f                   	pop    %edi
  102d5c:	5d                   	pop    %ebp
  102d5d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102d61:	85 c9                	test   %ecx,%ecx
  102d63:	7e 4d                	jle    102db2 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  102d65:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  102d67:	89 c2                	mov    %eax,%edx
  102d69:	3b 43 08             	cmp    0x8(%ebx),%eax
  102d6c:	75 07                	jne    102d75 <piperead+0x85>
  102d6e:	eb 42                	jmp    102db2 <piperead+0xc2>
  102d70:	39 53 08             	cmp    %edx,0x8(%ebx)
  102d73:	74 20                	je     102d95 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102d75:	89 d0                	mov    %edx,%eax
  102d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102d7a:	83 c2 01             	add    $0x1,%edx
  102d7d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102d82:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102d87:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d8a:	83 c6 01             	add    $0x1,%esi
  102d8d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102d90:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102d93:	75 db                	jne    102d70 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102d95:	8d 43 08             	lea    0x8(%ebx),%eax
  102d98:	89 04 24             	mov    %eax,(%esp)
  102d9b:	e8 20 04 00 00       	call   1031c0 <wakeup>
  release(&p->lock);
  102da0:	89 3c 24             	mov    %edi,(%esp)
  102da3:	e8 a8 15 00 00       	call   104350 <release>
  return i;
}
  102da8:	83 c4 0c             	add    $0xc,%esp
  102dab:	89 f0                	mov    %esi,%eax
  102dad:	5b                   	pop    %ebx
  102dae:	5e                   	pop    %esi
  102daf:	5f                   	pop    %edi
  102db0:	5d                   	pop    %ebp
  102db1:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102db2:	31 f6                	xor    %esi,%esi
  102db4:	eb df                	jmp    102d95 <piperead+0xa5>
  102db6:	8d 76 00             	lea    0x0(%esi),%esi
  102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102dc0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102dc0:	55                   	push   %ebp
  102dc1:	89 e5                	mov    %esp,%ebp
  102dc3:	57                   	push   %edi
  102dc4:	56                   	push   %esi
  102dc5:	53                   	push   %ebx
  102dc6:	83 ec 1c             	sub    $0x1c,%esp
  102dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102dcc:	8d 73 10             	lea    0x10(%ebx),%esi
  102dcf:	89 34 24             	mov    %esi,(%esp)
  102dd2:	e8 b9 15 00 00       	call   104390 <acquire>
  for(i = 0; i < n; i++){
  102dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  102dda:	85 c0                	test   %eax,%eax
  102ddc:	0f 8e a8 00 00 00    	jle    102e8a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102de2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  102de5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102de8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102def:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102df2:	eb 29                	jmp    102e1d <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102df4:	8b 03                	mov    (%ebx),%eax
  102df6:	85 c0                	test   %eax,%eax
  102df8:	74 76                	je     102e70 <pipewrite+0xb0>
  102dfa:	e8 31 05 00 00       	call   103330 <curproc>
  102dff:	8b 48 1c             	mov    0x1c(%eax),%ecx
  102e02:	85 c9                	test   %ecx,%ecx
  102e04:	75 6a                	jne    102e70 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102e06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e09:	89 14 24             	mov    %edx,(%esp)
  102e0c:	e8 af 03 00 00       	call   1031c0 <wakeup>
      sleep(&p->writep, &p->lock);
  102e11:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e15:	89 3c 24             	mov    %edi,(%esp)
  102e18:	e8 a3 07 00 00       	call   1035c0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  102e1d:	8b 43 0c             	mov    0xc(%ebx),%eax
  102e20:	8b 4b 08             	mov    0x8(%ebx),%ecx
  102e23:	05 00 02 00 00       	add    $0x200,%eax
  102e28:	39 c1                	cmp    %eax,%ecx
  102e2a:	74 c8                	je     102df4 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e2c:	89 c8                	mov    %ecx,%eax
  102e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e31:	25 ff 01 00 00       	and    $0x1ff,%eax
  102e36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  102e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e43:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e47:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e4a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e4d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102e51:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102e54:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102e57:	75 c4                	jne    102e1d <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  102e59:	8d 43 0c             	lea    0xc(%ebx),%eax
  102e5c:	89 04 24             	mov    %eax,(%esp)
  102e5f:	e8 5c 03 00 00       	call   1031c0 <wakeup>
  release(&p->lock);
  102e64:	89 34 24             	mov    %esi,(%esp)
  102e67:	e8 e4 14 00 00       	call   104350 <release>
  102e6c:	eb 11                	jmp    102e7f <pipewrite+0xbf>
  102e6e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  102e70:	89 34 24             	mov    %esi,(%esp)
  102e73:	e8 d8 14 00 00       	call   104350 <release>
  102e78:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  102e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e82:	83 c4 1c             	add    $0x1c,%esp
  102e85:	5b                   	pop    %ebx
  102e86:	5e                   	pop    %esi
  102e87:	5f                   	pop    %edi
  102e88:	5d                   	pop    %ebp
  102e89:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102e8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102e91:	eb c6                	jmp    102e59 <pipewrite+0x99>
  102e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102ea0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102ea0:	55                   	push   %ebp
  102ea1:	89 e5                	mov    %esp,%ebp
  102ea3:	83 ec 18             	sub    $0x18,%esp
  102ea6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  102eac:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102eaf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  102eb2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  102eb5:	8d 7e 10             	lea    0x10(%esi),%edi
  102eb8:	89 3c 24             	mov    %edi,(%esp)
  102ebb:	e8 d0 14 00 00       	call   104390 <acquire>
  if(writable){
  102ec0:	85 db                	test   %ebx,%ebx
  102ec2:	74 34                	je     102ef8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  102ec4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102ec7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  102ece:	89 04 24             	mov    %eax,(%esp)
  102ed1:	e8 ea 02 00 00       	call   1031c0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  102ed6:	89 3c 24             	mov    %edi,(%esp)
  102ed9:	e8 72 14 00 00       	call   104350 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  102ede:	8b 06                	mov    (%esi),%eax
  102ee0:	85 c0                	test   %eax,%eax
  102ee2:	75 07                	jne    102eeb <pipeclose+0x4b>
  102ee4:	8b 46 04             	mov    0x4(%esi),%eax
  102ee7:	85 c0                	test   %eax,%eax
  102ee9:	74 25                	je     102f10 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  102eeb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102eee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102ef1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102ef4:	89 ec                	mov    %ebp,%esp
  102ef6:	5d                   	pop    %ebp
  102ef7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  102ef8:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  102efb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  102f01:	89 04 24             	mov    %eax,(%esp)
  102f04:	e8 b7 02 00 00       	call   1031c0 <wakeup>
  102f09:	eb cb                	jmp    102ed6 <pipeclose+0x36>
  102f0b:	90                   	nop    
  102f0c:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102f10:	89 75 08             	mov    %esi,0x8(%ebp)
}
  102f13:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102f16:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  102f1d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102f20:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102f23:	89 ec                	mov    %ebp,%esp
  102f25:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  102f26:	e9 85 f3 ff ff       	jmp    1022b0 <kfree>
  102f2b:	90                   	nop    
  102f2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102f30 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  102f30:	55                   	push   %ebp
  102f31:	89 e5                	mov    %esp,%ebp
  102f33:	83 ec 18             	sub    $0x18,%esp
  102f36:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102f39:	8b 75 08             	mov    0x8(%ebp),%esi
  102f3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  102f3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  102f42:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  102f45:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  102f4b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  102f51:	e8 7a df ff ff       	call   100ed0 <filealloc>
  102f56:	85 c0                	test   %eax,%eax
  102f58:	89 06                	mov    %eax,(%esi)
  102f5a:	0f 84 96 00 00 00    	je     102ff6 <pipealloc+0xc6>
  102f60:	e8 6b df ff ff       	call   100ed0 <filealloc>
  102f65:	85 c0                	test   %eax,%eax
  102f67:	89 07                	mov    %eax,(%edi)
  102f69:	74 75                	je     102fe0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  102f6b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102f72:	e8 79 f2 ff ff       	call   1021f0 <kalloc>
  102f77:	85 c0                	test   %eax,%eax
  102f79:	89 c3                	mov    %eax,%ebx
  102f7b:	74 63                	je     102fe0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  102f7d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  102f83:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  102f8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  102f91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  102f98:	8d 40 10             	lea    0x10(%eax),%eax
  102f9b:	89 04 24             	mov    %eax,(%esp)
  102f9e:	c7 44 24 04 40 69 10 	movl   $0x106940,0x4(%esp)
  102fa5:	00 
  102fa6:	e8 25 12 00 00       	call   1041d0 <initlock>
  (*f0)->type = FD_PIPE;
  102fab:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  102fad:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  102faf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  102fb3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  102fb9:	8b 06                	mov    (%esi),%eax
  102fbb:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  102fbf:	8b 06                	mov    (%esi),%eax
  102fc1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  102fc4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  102fc6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  102fca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  102fd0:	8b 07                	mov    (%edi),%eax
  102fd2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  102fd6:	8b 07                	mov    (%edi),%eax
  102fd8:	89 58 0c             	mov    %ebx,0xc(%eax)
  102fdb:	eb 24                	jmp    103001 <pipealloc+0xd1>
  102fdd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  102fe0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  102fe2:	85 c0                	test   %eax,%eax
  102fe4:	74 10                	je     102ff6 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  102fe6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  102fec:	8b 06                	mov    (%esi),%eax
  102fee:	89 04 24             	mov    %eax,(%esp)
  102ff1:	e8 6a df ff ff       	call   100f60 <fileclose>
  }
  if(*f1){
  102ff6:	8b 07                	mov    (%edi),%eax
  102ff8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102ffd:	85 c0                	test   %eax,%eax
  102fff:	75 0f                	jne    103010 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  103001:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103004:	89 d0                	mov    %edx,%eax
  103006:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103009:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10300c:	89 ec                	mov    %ebp,%esp
  10300e:	5d                   	pop    %ebp
  10300f:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  103010:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  103016:	89 04 24             	mov    %eax,(%esp)
  103019:	e8 42 df ff ff       	call   100f60 <fileclose>
  10301e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103023:	eb dc                	jmp    103001 <pipealloc+0xd1>
  103025:	90                   	nop    
  103026:	90                   	nop    
  103027:	90                   	nop    
  103028:	90                   	nop    
  103029:	90                   	nop    
  10302a:	90                   	nop    
  10302b:	90                   	nop    
  10302c:	90                   	nop    
  10302d:	90                   	nop    
  10302e:	90                   	nop    
  10302f:	90                   	nop    

00103030 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  103030:	55                   	push   %ebp
  103031:	31 d2                	xor    %edx,%edx
  103033:	89 e5                	mov    %esp,%ebp
  103035:	eb 0e                	jmp    103045 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  103037:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10303d:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  103043:	74 29                	je     10306e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  103045:	83 ba 2c bd 10 00 02 	cmpl   $0x2,0x10bd2c(%edx)
  10304c:	75 e9                	jne    103037 <wakeup1+0x7>
  10304e:	39 82 38 bd 10 00    	cmp    %eax,0x10bd38(%edx)
  103054:	75 e1                	jne    103037 <wakeup1+0x7>
      p->state = RUNNABLE;
  103056:	c7 82 2c bd 10 00 03 	movl   $0x3,0x10bd2c(%edx)
  10305d:	00 00 00 
  103060:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103066:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10306c:	75 d7                	jne    103045 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10306e:	5d                   	pop    %ebp
  10306f:	c3                   	ret    

00103070 <tick>:
  }
}

int
tick(void)
{
  103070:	55                   	push   %ebp
  103071:	a1 a0 ee 10 00       	mov    0x10eea0,%eax
  103076:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103078:	5d                   	pop    %ebp
  103079:	c3                   	ret    
  10307a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103080 <mutex_lock>:
    }
  release(&proc_table_lock);
  return p->pid;
}

void mutex_lock(struct mutex_t* lock) {
  103080:	55                   	push   %ebp
  103081:	89 e5                	mov    %esp,%ebp
  103083:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103086:	b8 01 00 00 00       	mov    $0x1,%eax
  10308b:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lock->lock, 1) == 1);
  10308e:	83 e8 01             	sub    $0x1,%eax
  103091:	74 f3                	je     103086 <mutex_lock+0x6>
}
  103093:	5d                   	pop    %ebp
  103094:	c3                   	ret    
  103095:	8d 74 26 00          	lea    0x0(%esi),%esi
  103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001030a0 <mutex_unlock>:

void mutex_unlock(struct mutex_t* lock) {
  1030a0:	55                   	push   %ebp
  1030a1:	31 d2                	xor    %edx,%edx
  1030a3:	89 e5                	mov    %esp,%ebp
  1030a5:	89 d0                	mov    %edx,%eax
  1030a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1030aa:	f0 87 01             	lock xchg %eax,(%ecx)
  xchg(&lock->lock, 0);
}
  1030ad:	5d                   	pop    %ebp
  1030ae:	c3                   	ret    
  1030af:	90                   	nop    

001030b0 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  1030b0:	55                   	push   %ebp
  1030b1:	89 e5                	mov    %esp,%ebp
  1030b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b9:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  1030bc:	5d                   	pop    %ebp
  1030bd:	c3                   	ret    
  1030be:	66 90                	xchg   %ax,%ax

001030c0 <wakecond>:
  cprintf("hi mom\n");
  release(&proc_table_lock);
}


int wakecond(uint c) {
  1030c0:	55                   	push   %ebp
  1030c1:	89 e5                	mov    %esp,%ebp
  1030c3:	56                   	push   %esi
  1030c4:	53                   	push   %ebx
  acquire(&proc_table_lock);
  1030c5:	bb 20 bd 10 00       	mov    $0x10bd20,%ebx
  cprintf("hi mom\n");
  release(&proc_table_lock);
}


int wakecond(uint c) {
  1030ca:	83 ec 10             	sub    $0x10,%esp
  1030cd:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  1030d0:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1030d7:	e8 b4 12 00 00       	call   104390 <acquire>
  1030dc:	eb 10                	jmp    1030ee <wakecond+0x2e>
  1030de:	66 90                	xchg   %ax,%ax
  struct proc * p;
  for(p = proc; p < &proc[NPROC]; p++)
  1030e0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  1030e6:	81 fb 20 e6 10 00    	cmp    $0x10e620,%ebx
  1030ec:	74 37                	je     103125 <wakecond+0x65>
    {
      if(p->state == SLEEPING && p->cond == c)
  1030ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  1030f2:	75 ec                	jne    1030e0 <wakecond+0x20>
  1030f4:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  1030fa:	75 e4                	jne    1030e0 <wakecond+0x20>
	{
	  p->state = RUNNING;
	  p->cond = 0;
	  struct mutex_t * mut;
	  mut = (struct mutex_t*) p->mutex;
	  mutex_lock(mut);
  1030fc:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
  struct proc * p;
  for(p = proc; p < &proc[NPROC]; p++)
    {
      if(p->state == SLEEPING && p->cond == c)
	{
	  p->state = RUNNING;
  103102:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
	  p->cond = 0;
  103109:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  103110:	00 00 00 
	  struct mutex_t * mut;
	  mut = (struct mutex_t*) p->mutex;
	  mutex_lock(mut);
  103113:	89 04 24             	mov    %eax,(%esp)
  103116:	e8 65 ff ff ff       	call   103080 <mutex_lock>
	  p->mutex = 0;
  10311b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  103122:	00 00 00 
	  break;
	}
    }
  release(&proc_table_lock);
  103125:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10312c:	e8 1f 12 00 00       	call   104350 <release>
  103131:	8b 43 10             	mov    0x10(%ebx),%eax
  return p->pid;
}
  103134:	83 c4 10             	add    $0x10,%esp
  103137:	5b                   	pop    %ebx
  103138:	5e                   	pop    %esi
  103139:	5d                   	pop    %ebp
  10313a:	c3                   	ret    
  10313b:	90                   	nop    
  10313c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103140 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103140:	55                   	push   %ebp
  103141:	89 e5                	mov    %esp,%ebp
  103143:	53                   	push   %ebx
  103144:	83 ec 04             	sub    $0x4,%esp
  103147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10314a:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103151:	e8 3a 12 00 00       	call   104390 <acquire>
  103156:	b8 20 bd 10 00       	mov    $0x10bd20,%eax
  10315b:	eb 0f                	jmp    10316c <kill+0x2c>
  10315d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  103160:	05 a4 00 00 00       	add    $0xa4,%eax
  103165:	3d 20 e6 10 00       	cmp    $0x10e620,%eax
  10316a:	74 26                	je     103192 <kill+0x52>
    if(p->pid == pid){
  10316c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10316f:	75 ef                	jne    103160 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103171:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103175:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10317c:	74 2b                	je     1031a9 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10317e:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103185:	e8 c6 11 00 00       	call   104350 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10318a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10318d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10318f:	5b                   	pop    %ebx
  103190:	5d                   	pop    %ebp
  103191:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103192:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103199:	e8 b2 11 00 00       	call   104350 <release>
  return -1;
}
  10319e:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1031a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1031a6:	5b                   	pop    %ebx
  1031a7:	5d                   	pop    %ebp
  1031a8:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1031a9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1031b0:	eb cc                	jmp    10317e <kill+0x3e>
  1031b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001031c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
  1031c3:	53                   	push   %ebx
  1031c4:	83 ec 04             	sub    $0x4,%esp
  1031c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1031ca:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1031d1:	e8 ba 11 00 00       	call   104390 <acquire>
  wakeup1(chan);
  1031d6:	89 d8                	mov    %ebx,%eax
  1031d8:	e8 53 fe ff ff       	call   103030 <wakeup1>
  release(&proc_table_lock);
  1031dd:	c7 45 08 20 e6 10 00 	movl   $0x10e620,0x8(%ebp)
}
  1031e4:	83 c4 04             	add    $0x4,%esp
  1031e7:	5b                   	pop    %ebx
  1031e8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1031e9:	e9 62 11 00 00       	jmp    104350 <release>
  1031ee:	66 90                	xchg   %ax,%ax

001031f0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1031f0:	55                   	push   %ebp
  1031f1:	89 e5                	mov    %esp,%ebp
  1031f3:	53                   	push   %ebx
  1031f4:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1031f7:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1031fe:	e8 8d 11 00 00       	call   104390 <acquire>
  103203:	b8 20 bd 10 00       	mov    $0x10bd20,%eax
  103208:	eb 13                	jmp    10321d <allocproc+0x2d>
  10320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103210:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103216:	3d 20 e6 10 00       	cmp    $0x10e620,%eax
  10321b:	74 34                	je     103251 <allocproc+0x61>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10321d:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  10321f:	8b 40 0c             	mov    0xc(%eax),%eax
  103222:	85 c0                	test   %eax,%eax
  103224:	75 ea                	jne    103210 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103226:	a1 e4 7e 10 00       	mov    0x107ee4,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10322b:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103232:	89 43 10             	mov    %eax,0x10(%ebx)
  103235:	83 c0 01             	add    $0x1,%eax
  103238:	a3 e4 7e 10 00       	mov    %eax,0x107ee4
      release(&proc_table_lock);
  10323d:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103244:	e8 07 11 00 00       	call   104350 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  103249:	89 d8                	mov    %ebx,%eax
  10324b:	83 c4 04             	add    $0x4,%esp
  10324e:	5b                   	pop    %ebx
  10324f:	5d                   	pop    %ebp
  103250:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103251:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103258:	31 db                	xor    %ebx,%ebx
  10325a:	e8 f1 10 00 00       	call   104350 <release>
  return 0;
}
  10325f:	89 d8                	mov    %ebx,%eax
  103261:	83 c4 04             	add    $0x4,%esp
  103264:	5b                   	pop    %ebx
  103265:	5d                   	pop    %ebp
  103266:	c3                   	ret    
  103267:	89 f6                	mov    %esi,%esi
  103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103270 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103270:	55                   	push   %ebp
  103271:	89 e5                	mov    %esp,%ebp
  103273:	57                   	push   %edi
  103274:	56                   	push   %esi
  103275:	53                   	push   %ebx
  103276:	bb 2c bd 10 00       	mov    $0x10bd2c,%ebx
  10327b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10327e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103281:	eb 4a                	jmp    1032cd <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103283:	8b 14 95 10 6a 10 00 	mov    0x106a10(,%edx,4),%edx
  10328a:	85 d2                	test   %edx,%edx
  10328c:	74 4d                	je     1032db <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  10328e:	05 88 00 00 00       	add    $0x88,%eax
  103293:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103297:	8b 43 04             	mov    0x4(%ebx),%eax
  10329a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10329e:	c7 04 24 49 69 10 00 	movl   $0x106949,(%esp)
  1032a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032a9:	e8 52 d4 ff ff       	call   100700 <cprintf>
    if(p->state == SLEEPING){
  1032ae:	83 3b 02             	cmpl   $0x2,(%ebx)
  1032b1:	74 2f                	je     1032e2 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1032b3:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  1032ba:	e8 41 d4 ff ff       	call   100700 <cprintf>
  1032bf:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1032c5:	81 fb 2c e6 10 00    	cmp    $0x10e62c,%ebx
  1032cb:	74 55                	je     103322 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1032cd:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1032cf:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1032d2:	85 d2                	test   %edx,%edx
  1032d4:	74 e9                	je     1032bf <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1032d6:	83 fa 05             	cmp    $0x5,%edx
  1032d9:	76 a8                	jbe    103283 <procdump+0x13>
  1032db:	ba 45 69 10 00       	mov    $0x106945,%edx
  1032e0:	eb ac                	jmp    10328e <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1032e2:	8b 43 74             	mov    0x74(%ebx),%eax
  1032e5:	be 01 00 00 00       	mov    $0x1,%esi
  1032ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1032ee:	83 c0 08             	add    $0x8,%eax
  1032f1:	89 04 24             	mov    %eax,(%esp)
  1032f4:	e8 f7 0e 00 00       	call   1041f0 <getcallerpcs>
  1032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103300:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  103304:	85 c0                	test   %eax,%eax
  103306:	74 ab                	je     1032b3 <procdump+0x43>
        cprintf(" %p", pc[j]);
  103308:	83 c6 01             	add    $0x1,%esi
  10330b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10330f:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  103316:	e8 e5 d3 ff ff       	call   100700 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10331b:	83 fe 0b             	cmp    $0xb,%esi
  10331e:	75 e0                	jne    103300 <procdump+0x90>
  103320:	eb 91                	jmp    1032b3 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103322:	83 c4 4c             	add    $0x4c,%esp
  103325:	5b                   	pop    %ebx
  103326:	5e                   	pop    %esi
  103327:	5f                   	pop    %edi
  103328:	5d                   	pop    %ebp
  103329:	c3                   	ret    
  10332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103330 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103330:	55                   	push   %ebp
  103331:	89 e5                	mov    %esp,%ebp
  103333:	53                   	push   %ebx
  103334:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103337:	e8 84 0f 00 00       	call   1042c0 <pushcli>
  p = cpus[cpu()].curproc;
  10333c:	e8 3f f3 ff ff       	call   102680 <cpu>
  103341:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103347:	8b 98 a4 b6 10 00    	mov    0x10b6a4(%eax),%ebx
  popcli();
  10334d:	e8 ee 0e 00 00       	call   104240 <popcli>
  return p;
}
  103352:	83 c4 04             	add    $0x4,%esp
  103355:	89 d8                	mov    %ebx,%eax
  103357:	5b                   	pop    %ebx
  103358:	5d                   	pop    %ebp
  103359:	c3                   	ret    
  10335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103360 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103366:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10336d:	e8 de 0f 00 00       	call   104350 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103372:	e8 b9 ff ff ff       	call   103330 <curproc>
  103377:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10337d:	89 04 24             	mov    %eax,(%esp)
  103380:	e8 57 23 00 00       	call   1056dc <forkret1>
}
  103385:	c9                   	leave  
  103386:	c3                   	ret    
  103387:	89 f6                	mov    %esi,%esi
  103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103390 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103390:	55                   	push   %ebp
  103391:	89 e5                	mov    %esp,%ebp
  103393:	53                   	push   %ebx
  103394:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103397:	9c                   	pushf  
  103398:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103399:	f6 c4 02             	test   $0x2,%ah
  10339c:	75 5c                	jne    1033fa <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10339e:	e8 8d ff ff ff       	call   103330 <curproc>
  1033a3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1033a7:	74 5d                	je     103406 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1033a9:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1033b0:	e8 6b 0f 00 00       	call   104320 <holding>
  1033b5:	85 c0                	test   %eax,%eax
  1033b7:	74 59                	je     103412 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  1033b9:	e8 c2 f2 ff ff       	call   102680 <cpu>
  1033be:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1033c4:	83 b8 64 b7 10 00 01 	cmpl   $0x1,0x10b764(%eax)
  1033cb:	75 51                	jne    10341e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  1033cd:	e8 ae f2 ff ff       	call   102680 <cpu>
  1033d2:	89 c3                	mov    %eax,%ebx
  1033d4:	e8 57 ff ff ff       	call   103330 <curproc>
  1033d9:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  1033df:	81 c2 a8 b6 10 00    	add    $0x10b6a8,%edx
  1033e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033e9:	83 c0 64             	add    $0x64,%eax
  1033ec:	89 04 24             	mov    %eax,(%esp)
  1033ef:	e8 18 12 00 00       	call   10460c <swtch>
}
  1033f4:	83 c4 14             	add    $0x14,%esp
  1033f7:	5b                   	pop    %ebx
  1033f8:	5d                   	pop    %ebp
  1033f9:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  1033fa:	c7 04 24 52 69 10 00 	movl   $0x106952,(%esp)
  103401:	e8 9a d4 ff ff       	call   1008a0 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  103406:	c7 04 24 66 69 10 00 	movl   $0x106966,(%esp)
  10340d:	e8 8e d4 ff ff       	call   1008a0 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103412:	c7 04 24 74 69 10 00 	movl   $0x106974,(%esp)
  103419:	e8 82 d4 ff ff       	call   1008a0 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10341e:	c7 04 24 8a 69 10 00 	movl   $0x10698a,(%esp)
  103425:	e8 76 d4 ff ff       	call   1008a0 <panic>
  10342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103430 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  103430:	55                   	push   %ebp
  103431:	89 e5                	mov    %esp,%ebp
  103433:	56                   	push   %esi
  103434:	53                   	push   %ebx
  103435:	83 ec 10             	sub    $0x10,%esp
  103438:	8b 75 08             	mov    0x8(%ebp),%esi
  10343b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10343e:	e8 ed fe ff ff       	call   103330 <curproc>
  103443:	85 c0                	test   %eax,%eax
  103445:	74 5e                	je     1034a5 <sleepcond+0x75>
    panic("sleep");
  acquire(&proc_table_lock);
  103447:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10344e:	e8 3d 0f 00 00       	call   104390 <acquire>
  cp->state = SLEEPING;
  103453:	e8 d8 fe ff ff       	call   103330 <curproc>
  103458:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  10345f:	e8 cc fe ff ff       	call   103330 <curproc>
  103464:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  10346a:	e8 c1 fe ff ff       	call   103330 <curproc>
  10346f:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  103475:	89 1c 24             	mov    %ebx,(%esp)
  103478:	e8 23 fc ff ff       	call   1030a0 <mutex_unlock>
  popcli();
  10347d:	e8 be 0d 00 00       	call   104240 <popcli>
  sched();
  103482:	e8 09 ff ff ff       	call   103390 <sched>
  cprintf("hi mom\n");
  103487:	c7 04 24 9c 69 10 00 	movl   $0x10699c,(%esp)
  10348e:	e8 6d d2 ff ff       	call   100700 <cprintf>
  release(&proc_table_lock);
  103493:	c7 45 08 20 e6 10 00 	movl   $0x10e620,0x8(%ebp)
}
  10349a:	83 c4 10             	add    $0x10,%esp
  10349d:	5b                   	pop    %ebx
  10349e:	5e                   	pop    %esi
  10349f:	5d                   	pop    %ebp
  cp->mutex = (int)m;
  mutex_unlock(m);
  popcli();
  sched();
  cprintf("hi mom\n");
  release(&proc_table_lock);
  1034a0:	e9 ab 0e 00 00       	jmp    104350 <release>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  1034a5:	c7 04 24 96 69 10 00 	movl   $0x106996,(%esp)
  1034ac:	e8 ef d3 ff ff       	call   1008a0 <panic>
  1034b1:	eb 0d                	jmp    1034c0 <exit>
  1034b3:	90                   	nop    
  1034b4:	90                   	nop    
  1034b5:	90                   	nop    
  1034b6:	90                   	nop    
  1034b7:	90                   	nop    
  1034b8:	90                   	nop    
  1034b9:	90                   	nop    
  1034ba:	90                   	nop    
  1034bb:	90                   	nop    
  1034bc:	90                   	nop    
  1034bd:	90                   	nop    
  1034be:	90                   	nop    
  1034bf:	90                   	nop    

001034c0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1034c0:	55                   	push   %ebp
  1034c1:	89 e5                	mov    %esp,%ebp
  1034c3:	83 ec 18             	sub    $0x18,%esp
  1034c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1034c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  1034cc:	e8 5f fe ff ff       	call   103330 <curproc>
  1034d1:	3b 05 28 84 10 00    	cmp    0x108428,%eax
  1034d7:	75 0c                	jne    1034e5 <exit+0x25>
    panic("init exiting");
  1034d9:	c7 04 24 a4 69 10 00 	movl   $0x1069a4,(%esp)
  1034e0:	e8 bb d3 ff ff       	call   1008a0 <panic>
  1034e5:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1034e7:	e8 44 fe ff ff       	call   103330 <curproc>
  1034ec:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  1034f0:	85 d2                	test   %edx,%edx
  1034f2:	74 1e                	je     103512 <exit+0x52>
      fileclose(cp->ofile[fd]);
  1034f4:	e8 37 fe ff ff       	call   103330 <curproc>
  1034f9:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  1034fd:	89 04 24             	mov    %eax,(%esp)
  103500:	e8 5b da ff ff       	call   100f60 <fileclose>
      cp->ofile[fd] = 0;
  103505:	e8 26 fe ff ff       	call   103330 <curproc>
  10350a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  103511:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103512:	83 c3 01             	add    $0x1,%ebx
  103515:	83 fb 10             	cmp    $0x10,%ebx
  103518:	75 cd                	jne    1034e7 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  10351a:	e8 11 fe ff ff       	call   103330 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10351f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103521:	8b 40 60             	mov    0x60(%eax),%eax
  103524:	89 04 24             	mov    %eax,(%esp)
  103527:	e8 b4 e3 ff ff       	call   1018e0 <iput>
  cp->cwd = 0;
  10352c:	e8 ff fd ff ff       	call   103330 <curproc>
  103531:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  103538:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10353f:	e8 4c 0e 00 00       	call   104390 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  103544:	e8 e7 fd ff ff       	call   103330 <curproc>
  103549:	8b 40 14             	mov    0x14(%eax),%eax
  10354c:	e8 df fa ff ff       	call   103030 <wakeup1>
  103551:	eb 0f                	jmp    103562 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  103553:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103559:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  10355f:	90                   	nop    
  103560:	74 2a                	je     10358c <exit+0xcc>
    if(p->parent == cp){
  103562:	8b 9e 34 bd 10 00    	mov    0x10bd34(%esi),%ebx
  103568:	e8 c3 fd ff ff       	call   103330 <curproc>
  10356d:	39 c3                	cmp    %eax,%ebx
  10356f:	75 e2                	jne    103553 <exit+0x93>
      p->parent = initproc;
  103571:	a1 28 84 10 00       	mov    0x108428,%eax
      if(p->state == ZOMBIE)
  103576:	83 be 2c bd 10 00 05 	cmpl   $0x5,0x10bd2c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10357d:	89 86 34 bd 10 00    	mov    %eax,0x10bd34(%esi)
      if(p->state == ZOMBIE)
  103583:	75 ce                	jne    103553 <exit+0x93>
        wakeup1(initproc);
  103585:	e8 a6 fa ff ff       	call   103030 <wakeup1>
  10358a:	eb c7                	jmp    103553 <exit+0x93>
  10358c:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103590:	e8 9b fd ff ff       	call   103330 <curproc>
  103595:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  10359c:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  1035a0:	e8 8b fd ff ff       	call   103330 <curproc>
  1035a5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  1035ac:	e8 df fd ff ff       	call   103390 <sched>
  panic("zombie exit");
  1035b1:	c7 04 24 b1 69 10 00 	movl   $0x1069b1,(%esp)
  1035b8:	e8 e3 d2 ff ff       	call   1008a0 <panic>
  1035bd:	8d 76 00             	lea    0x0(%esi),%esi

001035c0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1035c0:	55                   	push   %ebp
  1035c1:	89 e5                	mov    %esp,%ebp
  1035c3:	56                   	push   %esi
  1035c4:	53                   	push   %ebx
  1035c5:	83 ec 10             	sub    $0x10,%esp
  1035c8:	8b 75 08             	mov    0x8(%ebp),%esi
  1035cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1035ce:	e8 5d fd ff ff       	call   103330 <curproc>
  1035d3:	85 c0                	test   %eax,%eax
  1035d5:	0f 84 91 00 00 00    	je     10366c <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  1035db:	85 db                	test   %ebx,%ebx
  1035dd:	0f 84 95 00 00 00    	je     103678 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  1035e3:	81 fb 20 e6 10 00    	cmp    $0x10e620,%ebx
  1035e9:	74 55                	je     103640 <sleep+0x80>
    acquire(&proc_table_lock);
  1035eb:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1035f2:	e8 99 0d 00 00       	call   104390 <acquire>
    release(lk);
  1035f7:	89 1c 24             	mov    %ebx,(%esp)
  1035fa:	e8 51 0d 00 00       	call   104350 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  1035ff:	e8 2c fd ff ff       	call   103330 <curproc>
  103604:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103607:	e8 24 fd ff ff       	call   103330 <curproc>
  10360c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103613:	e8 78 fd ff ff       	call   103390 <sched>

  // Tidy up.
  cp->chan = 0;
  103618:	e8 13 fd ff ff       	call   103330 <curproc>
  10361d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103624:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10362b:	e8 20 0d 00 00       	call   104350 <release>
    acquire(lk);
  103630:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103633:	83 c4 10             	add    $0x10,%esp
  103636:	5b                   	pop    %ebx
  103637:	5e                   	pop    %esi
  103638:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103639:	e9 52 0d 00 00       	jmp    104390 <acquire>
  10363e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103640:	e8 eb fc ff ff       	call   103330 <curproc>
  103645:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103648:	e8 e3 fc ff ff       	call   103330 <curproc>
  10364d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103654:	e8 37 fd ff ff       	call   103390 <sched>

  // Tidy up.
  cp->chan = 0;
  103659:	e8 d2 fc ff ff       	call   103330 <curproc>
  10365e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103665:	83 c4 10             	add    $0x10,%esp
  103668:	5b                   	pop    %ebx
  103669:	5e                   	pop    %esi
  10366a:	5d                   	pop    %ebp
  10366b:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  10366c:	c7 04 24 96 69 10 00 	movl   $0x106996,(%esp)
  103673:	e8 28 d2 ff ff       	call   1008a0 <panic>

  if(lk == 0)
    panic("sleep without lk");
  103678:	c7 04 24 bd 69 10 00 	movl   $0x1069bd,(%esp)
  10367f:	e8 1c d2 ff ff       	call   1008a0 <panic>
  103684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103690 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103690:	55                   	push   %ebp
  103691:	89 e5                	mov    %esp,%ebp
  103693:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103694:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103696:	56                   	push   %esi
  103697:	53                   	push   %ebx
  103698:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10369b:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1036a2:	e8 e9 0c 00 00       	call   104390 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1036a7:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1036aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1036b1:	7e 31                	jle    1036e4 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1036b3:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1036b6:	85 db                	test   %ebx,%ebx
  1036b8:	74 62                	je     10371c <wait_thread+0x8c>
  1036ba:	e8 71 fc ff ff       	call   103330 <curproc>
  1036bf:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1036c2:	85 c9                	test   %ecx,%ecx
  1036c4:	75 56                	jne    10371c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1036c6:	e8 65 fc ff ff       	call   103330 <curproc>
  1036cb:	31 ff                	xor    %edi,%edi
  1036cd:	c7 44 24 04 20 e6 10 	movl   $0x10e620,0x4(%esp)
  1036d4:	00 
  1036d5:	89 04 24             	mov    %eax,(%esp)
  1036d8:	e8 e3 fe ff ff       	call   1035c0 <sleep>
  1036dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1036e4:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  1036ea:	8d b0 20 bd 10 00    	lea    0x10bd20(%eax),%esi
      if(p->state == UNUSED)
  1036f0:	8b 46 0c             	mov    0xc(%esi),%eax
  1036f3:	85 c0                	test   %eax,%eax
  1036f5:	75 0a                	jne    103701 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1036f7:	83 c7 01             	add    $0x1,%edi
  1036fa:	83 ff 3f             	cmp    $0x3f,%edi
  1036fd:	7e e5                	jle    1036e4 <wait_thread+0x54>
  1036ff:	eb b2                	jmp    1036b3 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103701:	8b 5e 14             	mov    0x14(%esi),%ebx
  103704:	e8 27 fc ff ff       	call   103330 <curproc>
  103709:	39 c3                	cmp    %eax,%ebx
  10370b:	75 ea                	jne    1036f7 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  10370d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103711:	74 24                	je     103737 <wait_thread+0xa7>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103713:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10371a:	eb db                	jmp    1036f7 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  10371c:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103723:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103728:	e8 23 0c 00 00       	call   104350 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  10372d:	83 c4 0c             	add    $0xc,%esp
  103730:	89 d8                	mov    %ebx,%eax
  103732:	5b                   	pop    %ebx
  103733:	5e                   	pop    %esi
  103734:	5f                   	pop    %edi
  103735:	5d                   	pop    %ebp
  103736:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103737:	8b 46 08             	mov    0x8(%esi),%eax
  10373a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103741:	00 
  103742:	89 04 24             	mov    %eax,(%esp)
  103745:	e8 66 eb ff ff       	call   1022b0 <kfree>
          pid = p->pid;
  10374a:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  10374d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103754:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10375b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  103762:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103769:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103770:	e8 db 0b 00 00       	call   104350 <release>
  103775:	eb b6                	jmp    10372d <wait_thread+0x9d>
  103777:	89 f6                	mov    %esi,%esi
  103779:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103780 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103780:	55                   	push   %ebp
  103781:	89 e5                	mov    %esp,%ebp
  103783:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103784:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103786:	56                   	push   %esi
  103787:	53                   	push   %ebx
  103788:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10378b:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103792:	e8 f9 0b 00 00       	call   104390 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103797:	83 ff 3f             	cmp    $0x3f,%edi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10379a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1037a1:	7e 31                	jle    1037d4 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037a6:	85 c0                	test   %eax,%eax
  1037a8:	74 68                	je     103812 <wait+0x92>
  1037aa:	e8 81 fb ff ff       	call   103330 <curproc>
  1037af:	8b 40 1c             	mov    0x1c(%eax),%eax
  1037b2:	85 c0                	test   %eax,%eax
  1037b4:	75 5c                	jne    103812 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1037b6:	e8 75 fb ff ff       	call   103330 <curproc>
  1037bb:	31 ff                	xor    %edi,%edi
  1037bd:	c7 44 24 04 20 e6 10 	movl   $0x10e620,0x4(%esp)
  1037c4:	00 
  1037c5:	89 04 24             	mov    %eax,(%esp)
  1037c8:	e8 f3 fd ff ff       	call   1035c0 <sleep>
  1037cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1037d4:	69 df a4 00 00 00    	imul   $0xa4,%edi,%ebx
  1037da:	8d b3 20 bd 10 00    	lea    0x10bd20(%ebx),%esi
      if(p->state == UNUSED)
  1037e0:	8b 46 0c             	mov    0xc(%esi),%eax
  1037e3:	85 c0                	test   %eax,%eax
  1037e5:	75 0a                	jne    1037f1 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1037e7:	83 c7 01             	add    $0x1,%edi
  1037ea:	83 ff 3f             	cmp    $0x3f,%edi
  1037ed:	7e e5                	jle    1037d4 <wait+0x54>
  1037ef:	eb b2                	jmp    1037a3 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  1037f1:	8b 46 14             	mov    0x14(%esi),%eax
  1037f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037f7:	e8 34 fb ff ff       	call   103330 <curproc>
  1037fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1037ff:	90                   	nop    
  103800:	75 e5                	jne    1037e7 <wait+0x67>
        if(p->state == ZOMBIE){
  103802:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103806:	74 25                	je     10382d <wait+0xad>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103808:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10380f:	90                   	nop    
  103810:	eb d5                	jmp    1037e7 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103812:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103819:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10381e:	e8 2d 0b 00 00       	call   104350 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103823:	83 c4 1c             	add    $0x1c,%esp
  103826:	89 d8                	mov    %ebx,%eax
  103828:	5b                   	pop    %ebx
  103829:	5e                   	pop    %esi
  10382a:	5f                   	pop    %edi
  10382b:	5d                   	pop    %ebp
  10382c:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  10382d:	8b 46 04             	mov    0x4(%esi),%eax
  103830:	89 44 24 04          	mov    %eax,0x4(%esp)
  103834:	8b 83 20 bd 10 00    	mov    0x10bd20(%ebx),%eax
  10383a:	89 04 24             	mov    %eax,(%esp)
  10383d:	e8 6e ea ff ff       	call   1022b0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103842:	8b 46 08             	mov    0x8(%esi),%eax
  103845:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10384c:	00 
  10384d:	89 04 24             	mov    %eax,(%esp)
  103850:	e8 5b ea ff ff       	call   1022b0 <kfree>
          pid = p->pid;
  103855:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103858:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  10385f:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103866:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  10386d:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103874:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10387b:	e8 d0 0a 00 00       	call   104350 <release>
  103880:	eb a1                	jmp    103823 <wait+0xa3>
  103882:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103890 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103890:	55                   	push   %ebp
  103891:	89 e5                	mov    %esp,%ebp
  103893:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  103896:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  10389d:	e8 ee 0a 00 00       	call   104390 <acquire>
  cp->state = RUNNABLE;
  1038a2:	e8 89 fa ff ff       	call   103330 <curproc>
  1038a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1038ae:	e8 dd fa ff ff       	call   103390 <sched>
  release(&proc_table_lock);
  1038b3:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1038ba:	e8 91 0a 00 00       	call   104350 <release>
}
  1038bf:	c9                   	leave  
  1038c0:	c3                   	ret    
  1038c1:	eb 0d                	jmp    1038d0 <setupsegs>
  1038c3:	90                   	nop    
  1038c4:	90                   	nop    
  1038c5:	90                   	nop    
  1038c6:	90                   	nop    
  1038c7:	90                   	nop    
  1038c8:	90                   	nop    
  1038c9:	90                   	nop    
  1038ca:	90                   	nop    
  1038cb:	90                   	nop    
  1038cc:	90                   	nop    
  1038cd:	90                   	nop    
  1038ce:	90                   	nop    
  1038cf:	90                   	nop    

001038d0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1038d0:	55                   	push   %ebp
  1038d1:	89 e5                	mov    %esp,%ebp
  1038d3:	57                   	push   %edi
  1038d4:	56                   	push   %esi
  1038d5:	53                   	push   %ebx
  1038d6:	83 ec 1c             	sub    $0x1c,%esp
  1038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  1038dc:	e8 df 09 00 00       	call   1042c0 <pushcli>
  c = &cpus[cpu()];
  1038e1:	e8 9a ed ff ff       	call   102680 <cpu>
  1038e6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1038ec:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  1038ee:	8d b8 a0 b6 10 00    	lea    0x10b6a0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  1038f4:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  1038fa:	0f 84 85 01 00 00    	je     103a85 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103900:	8b 43 08             	mov    0x8(%ebx),%eax
  103903:	05 00 10 00 00       	add    $0x1000,%eax
  103908:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10390b:	8d 47 28             	lea    0x28(%edi),%eax
  10390e:	89 c2                	mov    %eax,%edx
  103910:	c1 ea 18             	shr    $0x18,%edx
  103913:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  103919:	89 c2                	mov    %eax,%edx
  10391b:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  10391e:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103920:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  103927:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  10392e:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  103935:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  10393c:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  103943:	00 00 
  103945:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  10394c:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  10394e:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  103955:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10395c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  103963:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10396a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  103971:	00 00 
  103973:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10397a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10397c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  103983:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10398a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  103991:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  103998:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10399f:	00 00 
  1039a1:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  1039a8:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1039aa:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  1039b1:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  1039b7:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  1039be:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  1039c5:	67 00 
  c->gdt[SEG_TSS].s = 0;
  1039c7:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  1039ce:	0f 84 bd 00 00 00    	je     103a91 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1039d4:	8b 53 04             	mov    0x4(%ebx),%edx
  1039d7:	8b 0b                	mov    (%ebx),%ecx
  1039d9:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1039e0:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1039e7:	83 ea 01             	sub    $0x1,%edx
  1039ea:	89 d0                	mov    %edx,%eax
  1039ec:	89 ce                	mov    %ecx,%esi
  1039ee:	c1 e8 0c             	shr    $0xc,%eax
  1039f1:	89 cb                	mov    %ecx,%ebx
  1039f3:	c1 ea 1c             	shr    $0x1c,%edx
  1039f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1039f9:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1039fb:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1039fe:	c1 ee 10             	shr    $0x10,%esi
  103a01:	83 c8 c0             	or     $0xffffffc0,%eax
  103a04:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  103a0a:	89 f0                	mov    %esi,%eax
  103a0c:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  103a12:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103a16:	c1 eb 18             	shr    $0x18,%ebx
  103a19:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  103a1f:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103a26:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103a2c:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103a33:	89 f0                	mov    %esi,%eax
  103a35:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  103a3b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103a3f:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  103a45:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  103a4c:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  103a53:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103a59:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  103a5f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  103a63:	c1 e8 10             	shr    $0x10,%eax
  103a66:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103a6a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  103a6d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103a70:	b8 28 00 00 00       	mov    $0x28,%eax
  103a75:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  103a78:	e8 c3 07 00 00       	call   104240 <popcli>
}
  103a7d:	83 c4 1c             	add    $0x1c,%esp
  103a80:	5b                   	pop    %ebx
  103a81:	5e                   	pop    %esi
  103a82:	5f                   	pop    %edi
  103a83:	5d                   	pop    %ebp
  103a84:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103a85:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  103a8c:	e9 7a fe ff ff       	jmp    10390b <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103a91:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  103a98:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  103a9f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  103aa6:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  103aad:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  103ab4:	00 00 
  103ab6:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  103abd:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103abf:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  103ac6:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  103acd:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  103ad4:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  103adb:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  103ae2:	00 00 
  103ae4:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  103aeb:	00 00 
  103aed:	e9 61 ff ff ff       	jmp    103a53 <setupsegs+0x183>
  103af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103b00 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103b00:	55                   	push   %ebp
  103b01:	89 e5                	mov    %esp,%ebp
  103b03:	57                   	push   %edi
  103b04:	56                   	push   %esi
  103b05:	53                   	push   %ebx
  103b06:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103b09:	e8 72 eb ff ff       	call   102680 <cpu>
  103b0e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103b14:	05 a0 b6 10 00       	add    $0x10b6a0,%eax
  103b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b1c:	83 c0 08             	add    $0x8,%eax
  103b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
  103b22:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103b23:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103b2a:	e8 61 08 00 00       	call   104390 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103b2f:	83 3d 30 bd 10 00 01 	cmpl   $0x1,0x10bd30
  103b36:	0f 84 c2 00 00 00    	je     103bfe <scheduler+0xfe>
  103b3c:	31 db                	xor    %ebx,%ebx
  103b3e:	31 c0                	xor    %eax,%eax
  103b40:	eb 0c                	jmp    103b4e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103b42:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103b47:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103b4c:	74 1b                	je     103b69 <scheduler+0x69>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103b4e:	83 b8 2c bd 10 00 03 	cmpl   $0x3,0x10bd2c(%eax)
  103b55:	75 eb                	jne    103b42 <scheduler+0x42>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103b57:	03 98 b8 bd 10 00    	add    0x10bdb8(%eax),%ebx
  103b5d:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103b62:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103b67:	75 e5                	jne    103b4e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103b69:	85 db                	test   %ebx,%ebx
  103b6b:	75 7b                	jne    103be8 <scheduler+0xe8>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103b6d:	bb 2c bd 10 00       	mov    $0x10bd2c,%ebx
  103b72:	31 c0                	xor    %eax,%eax
  103b74:	eb 12                	jmp    103b88 <scheduler+0x88>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103b76:	39 f8                	cmp    %edi,%eax
  103b78:	7f 20                	jg     103b9a <scheduler+0x9a>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103b7a:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103b80:	81 fb 2c e6 10 00    	cmp    $0x10e62c,%ebx
  103b86:	74 4f                	je     103bd7 <scheduler+0xd7>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103b88:	83 3b 03             	cmpl   $0x3,(%ebx)
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103b8b:	8d 73 f4             	lea    -0xc(%ebx),%esi
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103b8e:	75 e6                	jne    103b76 <scheduler+0x76>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103b90:	03 83 8c 00 00 00    	add    0x8c(%ebx),%eax
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103b96:	39 f8                	cmp    %edi,%eax
  103b98:	7e e0                	jle    103b7a <scheduler+0x7a>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b9d:	89 70 04             	mov    %esi,0x4(%eax)
    	  setupsegs(p);
  103ba0:	89 34 24             	mov    %esi,(%esp)
  103ba3:	e8 28 fd ff ff       	call   1038d0 <setupsegs>
    	  p->state = RUNNING;
    	  swtch(&c->context, &p->context);
  103ba8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103bab:	8d 43 58             	lea    0x58(%ebx),%eax
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
    	  setupsegs(p);
    	  p->state = RUNNING;
  103bae:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    	  swtch(&c->context, &p->context);
  103bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bb9:	89 14 24             	mov    %edx,(%esp)
  103bbc:	e8 4b 0a 00 00       	call   10460c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	  setupsegs(0);
  103bcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103bd2:	e8 f9 fc ff ff       	call   1038d0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103bd7:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103bde:	e8 6d 07 00 00       	call   104350 <release>
  103be3:	e9 3a ff ff ff       	jmp    103b22 <scheduler+0x22>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103be8:	e8 83 f4 ff ff       	call   103070 <tick>
  103bed:	c1 e0 08             	shl    $0x8,%eax
  103bf0:	89 c2                	mov    %eax,%edx
  103bf2:	c1 fa 1f             	sar    $0x1f,%edx
  103bf5:	f7 fb                	idiv   %ebx
  103bf7:	89 d7                	mov    %edx,%edi
  103bf9:	e9 6f ff ff ff       	jmp    103b6d <scheduler+0x6d>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103bfe:	83 3d 2c bd 10 00 03 	cmpl   $0x3,0x10bd2c
  103c05:	0f 85 31 ff ff ff    	jne    103b3c <scheduler+0x3c>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103c0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103c0e:	c7 42 04 20 bd 10 00 	movl   $0x10bd20,0x4(%edx)
      setupsegs(p);
  103c15:	c7 04 24 20 bd 10 00 	movl   $0x10bd20,(%esp)
  103c1c:	e8 af fc ff ff       	call   1038d0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c24:	c7 44 24 04 84 bd 10 	movl   $0x10bd84,0x4(%esp)
  103c2b:	00 
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103c2c:	c7 05 b8 bd 10 00 4b 	movl   $0x4b,0x10bdb8
  103c33:	00 00 00 
      p->state = RUNNING;
  103c36:	c7 05 2c bd 10 00 04 	movl   $0x4,0x10bd2c
  103c3d:	00 00 00 
      swtch(&c->context, &p->context);
  103c40:	89 04 24             	mov    %eax,(%esp)
  103c43:	e8 c4 09 00 00       	call   10460c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103c4b:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
      setupsegs(0);
  103c52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103c59:	e8 72 fc ff ff       	call   1038d0 <setupsegs>
      release(&proc_table_lock);
  103c5e:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  103c65:	e8 e6 06 00 00       	call   104350 <release>
  103c6a:	e9 b3 fe ff ff       	jmp    103b22 <scheduler+0x22>
  103c6f:	90                   	nop    

00103c70 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103c70:	55                   	push   %ebp
  103c71:	89 e5                	mov    %esp,%ebp
  103c73:	57                   	push   %edi
  103c74:	56                   	push   %esi
  103c75:	53                   	push   %ebx
  103c76:	83 ec 0c             	sub    $0xc,%esp
  103c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103c7c:	e8 af f6 ff ff       	call   103330 <curproc>
  103c81:	8b 50 04             	mov    0x4(%eax),%edx
  103c84:	8d 04 17             	lea    (%edi,%edx,1),%eax
  103c87:	89 04 24             	mov    %eax,(%esp)
  103c8a:	e8 61 e5 ff ff       	call   1021f0 <kalloc>
  103c8f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103c96:	85 f6                	test   %esi,%esi
  103c98:	74 7f                	je     103d19 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103c9a:	e8 91 f6 ff ff       	call   103330 <curproc>
  103c9f:	8b 58 04             	mov    0x4(%eax),%ebx
  103ca2:	e8 89 f6 ff ff       	call   103330 <curproc>
  103ca7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103cab:	8b 00                	mov    (%eax),%eax
  103cad:	89 34 24             	mov    %esi,(%esp)
  103cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cb4:	e8 e7 07 00 00       	call   1044a0 <memmove>
  memset(newmem + cp->sz, 0, n);
  103cb9:	e8 72 f6 ff ff       	call   103330 <curproc>
  103cbe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103cc2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cc9:	00 
  103cca:	8b 50 04             	mov    0x4(%eax),%edx
  103ccd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103cd0:	89 04 24             	mov    %eax,(%esp)
  103cd3:	e8 18 07 00 00       	call   1043f0 <memset>
  kfree(cp->mem, cp->sz);
  103cd8:	e8 53 f6 ff ff       	call   103330 <curproc>
  103cdd:	8b 58 04             	mov    0x4(%eax),%ebx
  103ce0:	e8 4b f6 ff ff       	call   103330 <curproc>
  103ce5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103ce9:	8b 00                	mov    (%eax),%eax
  103ceb:	89 04 24             	mov    %eax,(%esp)
  103cee:	e8 bd e5 ff ff       	call   1022b0 <kfree>
  cp->mem = newmem;
  103cf3:	e8 38 f6 ff ff       	call   103330 <curproc>
  103cf8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103cfa:	e8 31 f6 ff ff       	call   103330 <curproc>
  103cff:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  103d02:	e8 29 f6 ff ff       	call   103330 <curproc>
  103d07:	89 04 24             	mov    %eax,(%esp)
  103d0a:	e8 c1 fb ff ff       	call   1038d0 <setupsegs>
  return cp->sz - n;
  103d0f:	e8 1c f6 ff ff       	call   103330 <curproc>
  103d14:	8b 40 04             	mov    0x4(%eax),%eax
  103d17:	29 f8                	sub    %edi,%eax
}
  103d19:	83 c4 0c             	add    $0xc,%esp
  103d1c:	5b                   	pop    %ebx
  103d1d:	5e                   	pop    %esi
  103d1e:	5f                   	pop    %edi
  103d1f:	5d                   	pop    %ebp
  103d20:	c3                   	ret    
  103d21:	eb 0d                	jmp    103d30 <copyproc_tix>
  103d23:	90                   	nop    
  103d24:	90                   	nop    
  103d25:	90                   	nop    
  103d26:	90                   	nop    
  103d27:	90                   	nop    
  103d28:	90                   	nop    
  103d29:	90                   	nop    
  103d2a:	90                   	nop    
  103d2b:	90                   	nop    
  103d2c:	90                   	nop    
  103d2d:	90                   	nop    
  103d2e:	90                   	nop    
  103d2f:	90                   	nop    

00103d30 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103d30:	55                   	push   %ebp
  103d31:	89 e5                	mov    %esp,%ebp
  103d33:	57                   	push   %edi
  103d34:	56                   	push   %esi
  103d35:	53                   	push   %ebx
  103d36:	83 ec 0c             	sub    $0xc,%esp
  103d39:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103d3c:	e8 af f4 ff ff       	call   1031f0 <allocproc>
  103d41:	85 c0                	test   %eax,%eax
  103d43:	89 c6                	mov    %eax,%esi
  103d45:	0f 84 e3 00 00 00    	je     103e2e <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103d4b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103d52:	e8 99 e4 ff ff       	call   1021f0 <kalloc>
  103d57:	85 c0                	test   %eax,%eax
  103d59:	89 46 08             	mov    %eax,0x8(%esi)
  103d5c:	0f 84 d6 00 00 00    	je     103e38 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103d62:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103d67:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103d69:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103d6f:	0f 84 87 00 00 00    	je     103dfc <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  103d75:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103d78:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103d7b:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103d81:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103d88:	00 
  103d89:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d93:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  103d99:	89 04 24             	mov    %eax,(%esp)
  103d9c:	e8 ff 06 00 00       	call   1044a0 <memmove>
  
    np->sz = p->sz;
  103da1:	8b 47 04             	mov    0x4(%edi),%eax
  103da4:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103da7:	89 04 24             	mov    %eax,(%esp)
  103daa:	e8 41 e4 ff ff       	call   1021f0 <kalloc>
  103daf:	85 c0                	test   %eax,%eax
  103db1:	89 c2                	mov    %eax,%edx
  103db3:	89 06                	mov    %eax,(%esi)
  103db5:	0f 84 88 00 00 00    	je     103e43 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103dbb:	8b 46 04             	mov    0x4(%esi),%eax
  103dbe:	31 db                	xor    %ebx,%ebx
  103dc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  103dc4:	8b 07                	mov    (%edi),%eax
  103dc6:	89 14 24             	mov    %edx,(%esp)
  103dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  103dcd:	e8 ce 06 00 00       	call   1044a0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103dd2:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103dd6:	85 c0                	test   %eax,%eax
  103dd8:	74 0c                	je     103de6 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  103dda:	89 04 24             	mov    %eax,(%esp)
  103ddd:	e8 9e d0 ff ff       	call   100e80 <filedup>
  103de2:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103de6:	83 c3 01             	add    $0x1,%ebx
  103de9:	83 fb 10             	cmp    $0x10,%ebx
  103dec:	75 e4                	jne    103dd2 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103dee:	8b 47 60             	mov    0x60(%edi),%eax
  103df1:	89 04 24             	mov    %eax,(%esp)
  103df4:	e8 87 d2 ff ff       	call   101080 <idup>
  103df9:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103dfc:	8d 46 64             	lea    0x64(%esi),%eax
  103dff:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103e06:	00 
  103e07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e0e:	00 
  103e0f:	89 04 24             	mov    %eax,(%esp)
  103e12:	e8 d9 05 00 00       	call   1043f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103e17:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103e1d:	c7 46 64 60 33 10 00 	movl   $0x103360,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103e24:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103e27:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103e2e:	83 c4 0c             	add    $0xc,%esp
  103e31:	89 f0                	mov    %esi,%eax
  103e33:	5b                   	pop    %ebx
  103e34:	5e                   	pop    %esi
  103e35:	5f                   	pop    %edi
  103e36:	5d                   	pop    %ebp
  103e37:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103e38:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103e3f:	31 f6                	xor    %esi,%esi
  103e41:	eb eb                	jmp    103e2e <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103e43:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e4a:	00 
  103e4b:	8b 46 08             	mov    0x8(%esi),%eax
  103e4e:	89 04 24             	mov    %eax,(%esp)
  103e51:	e8 5a e4 ff ff       	call   1022b0 <kfree>
      np->kstack = 0;
  103e56:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103e5d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103e64:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103e6b:	31 f6                	xor    %esi,%esi
  103e6d:	eb bf                	jmp    103e2e <copyproc_tix+0xfe>
  103e6f:	90                   	nop    

00103e70 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  103e70:	55                   	push   %ebp
  103e71:	89 e5                	mov    %esp,%ebp
  103e73:	57                   	push   %edi
  103e74:	56                   	push   %esi
  103e75:	53                   	push   %ebx
  103e76:	83 ec 0c             	sub    $0xc,%esp
  103e79:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  103e7c:	e8 6f f3 ff ff       	call   1031f0 <allocproc>
  103e81:	85 c0                	test   %eax,%eax
  103e83:	89 c6                	mov    %eax,%esi
  103e85:	0f 84 da 00 00 00    	je     103f65 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103e8b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103e92:	e8 59 e3 ff ff       	call   1021f0 <kalloc>
  103e97:	85 c0                	test   %eax,%eax
  103e99:	89 46 08             	mov    %eax,0x8(%esi)
  103e9c:	0f 84 cd 00 00 00    	je     103f6f <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103ea2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103ea7:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103ea9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103eaf:	74 69                	je     103f1a <copyproc_threads+0xaa>
    np->parent = p;
  103eb1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  103eb4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  103eb6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  103ebd:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103ec0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103ec7:	00 
  103ec8:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ed2:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  103ed8:	89 04 24             	mov    %eax,(%esp)
  103edb:	e8 c0 05 00 00       	call   1044a0 <memmove>
  
    np->sz = p->sz;
  103ee0:	8b 47 04             	mov    0x4(%edi),%eax
  103ee3:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  103ee6:	8b 07                	mov    (%edi),%eax
  103ee8:	89 06                	mov    %eax,(%esi)
  103eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103ef0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103ef4:	85 c0                	test   %eax,%eax
  103ef6:	74 0c                	je     103f04 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  103ef8:	89 04 24             	mov    %eax,(%esp)
  103efb:	e8 80 cf ff ff       	call   100e80 <filedup>
  103f00:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103f04:	83 c3 01             	add    $0x1,%ebx
  103f07:	83 fb 10             	cmp    $0x10,%ebx
  103f0a:	75 e4                	jne    103ef0 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103f0c:	8b 47 60             	mov    0x60(%edi),%eax
  103f0f:	89 04 24             	mov    %eax,(%esp)
  103f12:	e8 69 d1 ff ff       	call   101080 <idup>
  103f17:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103f1a:	8d 46 64             	lea    0x64(%esi),%eax
  103f1d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103f24:	00 
  103f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103f2c:	00 
  103f2d:	89 04 24             	mov    %eax,(%esp)
  103f30:	e8 bb 04 00 00       	call   1043f0 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103f38:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103f3e:	c7 46 64 60 33 10 00 	movl   $0x103360,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103f45:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103f4b:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103f4e:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103f51:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  103f58:	8b 45 10             	mov    0x10(%ebp),%eax
  103f5b:	03 16                	add    (%esi),%edx
  103f5d:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  103f5f:	8b 45 14             	mov    0x14(%ebp),%eax
  103f62:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  103f65:	83 c4 0c             	add    $0xc,%esp
  103f68:	89 f0                	mov    %esi,%eax
  103f6a:	5b                   	pop    %ebx
  103f6b:	5e                   	pop    %esi
  103f6c:	5f                   	pop    %edi
  103f6d:	5d                   	pop    %ebp
  103f6e:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103f6f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103f76:	31 f6                	xor    %esi,%esi
  103f78:	eb eb                	jmp    103f65 <copyproc_threads+0xf5>
  103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f80 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
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
  103f8c:	e8 5f f2 ff ff       	call   1031f0 <allocproc>
  103f91:	85 c0                	test   %eax,%eax
  103f93:	89 c6                	mov    %eax,%esi
  103f95:	0f 84 e4 00 00 00    	je     10407f <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103f9b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103fa2:	e8 49 e2 ff ff       	call   1021f0 <kalloc>
  103fa7:	85 c0                	test   %eax,%eax
  103fa9:	89 46 08             	mov    %eax,0x8(%esi)
  103fac:	0f 84 d7 00 00 00    	je     104089 <copyproc+0x109>
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
  103fbf:	0f 84 88 00 00 00    	je     10404d <copyproc+0xcd>
    np->parent = p;
  103fc5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  103fc8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  103fcf:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103fd2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103fd9:	00 
  103fda:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fe4:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  103fea:	89 04 24             	mov    %eax,(%esp)
  103fed:	e8 ae 04 00 00       	call   1044a0 <memmove>
  
    np->sz = p->sz;
  103ff2:	8b 47 04             	mov    0x4(%edi),%eax
  103ff5:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103ff8:	89 04 24             	mov    %eax,(%esp)
  103ffb:	e8 f0 e1 ff ff       	call   1021f0 <kalloc>
  104000:	85 c0                	test   %eax,%eax
  104002:	89 c2                	mov    %eax,%edx
  104004:	89 06                	mov    %eax,(%esi)
  104006:	0f 84 88 00 00 00    	je     104094 <copyproc+0x114>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10400c:	8b 46 04             	mov    0x4(%esi),%eax
  10400f:	31 db                	xor    %ebx,%ebx
  104011:	89 44 24 08          	mov    %eax,0x8(%esp)
  104015:	8b 07                	mov    (%edi),%eax
  104017:	89 14 24             	mov    %edx,(%esp)
  10401a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10401e:	e8 7d 04 00 00       	call   1044a0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104023:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104027:	85 c0                	test   %eax,%eax
  104029:	74 0c                	je     104037 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  10402b:	89 04 24             	mov    %eax,(%esp)
  10402e:	e8 4d ce ff ff       	call   100e80 <filedup>
  104033:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104037:	83 c3 01             	add    $0x1,%ebx
  10403a:	83 fb 10             	cmp    $0x10,%ebx
  10403d:	75 e4                	jne    104023 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10403f:	8b 47 60             	mov    0x60(%edi),%eax
  104042:	89 04 24             	mov    %eax,(%esp)
  104045:	e8 36 d0 ff ff       	call   101080 <idup>
  10404a:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10404d:	8d 46 64             	lea    0x64(%esi),%eax
  104050:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104057:	00 
  104058:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10405f:	00 
  104060:	89 04 24             	mov    %eax,(%esp)
  104063:	e8 88 03 00 00       	call   1043f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104068:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10406e:	c7 46 64 60 33 10 00 	movl   $0x103360,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104075:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104078:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10407f:	83 c4 0c             	add    $0xc,%esp
  104082:	89 f0                	mov    %esi,%eax
  104084:	5b                   	pop    %ebx
  104085:	5e                   	pop    %esi
  104086:	5f                   	pop    %edi
  104087:	5d                   	pop    %ebp
  104088:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104089:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  104090:	31 f6                	xor    %esi,%esi
  104092:	eb eb                	jmp    10407f <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104094:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10409b:	00 
  10409c:	8b 46 08             	mov    0x8(%esi),%eax
  10409f:	89 04 24             	mov    %eax,(%esp)
  1040a2:	e8 09 e2 ff ff       	call   1022b0 <kfree>
      np->kstack = 0;
  1040a7:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1040ae:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1040b5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1040bc:	31 f6                	xor    %esi,%esi
  1040be:	eb bf                	jmp    10407f <copyproc+0xff>

001040c0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  1040c0:	55                   	push   %ebp
  1040c1:	89 e5                	mov    %esp,%ebp
  1040c3:	53                   	push   %ebx
  1040c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1040c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1040ce:	e8 ad fe ff ff       	call   103f80 <copyproc>
  p->sz = PAGE;
  1040d3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1040da:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  1040dc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1040e3:	e8 08 e1 ff ff       	call   1021f0 <kalloc>
  1040e8:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  1040ea:	c7 04 24 ce 69 10 00 	movl   $0x1069ce,(%esp)
  1040f1:	e8 1a dd ff ff       	call   101e10 <namei>
  1040f6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  1040f9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104100:	00 
  104101:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104108:	00 
  104109:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10410f:	89 04 24             	mov    %eax,(%esp)
  104112:	e8 d9 02 00 00       	call   1043f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104117:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10411d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10411f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104126:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104129:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10412f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104135:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10413b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10413e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104142:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104145:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10414b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104152:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104159:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104160:	00 
  104161:	c7 44 24 04 e8 82 10 	movl   $0x1082e8,0x4(%esp)
  104168:	00 
  104169:	8b 03                	mov    (%ebx),%eax
  10416b:	89 04 24             	mov    %eax,(%esp)
  10416e:	e8 2d 03 00 00       	call   1044a0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104173:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104179:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104180:	00 
  104181:	c7 44 24 04 d0 69 10 	movl   $0x1069d0,0x4(%esp)
  104188:	00 
  104189:	89 04 24             	mov    %eax,(%esp)
  10418c:	e8 1f 04 00 00       	call   1045b0 <safestrcpy>
  p->state = RUNNABLE;
  104191:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104198:	89 1d 28 84 10 00    	mov    %ebx,0x108428
}
  10419e:	83 c4 14             	add    $0x14,%esp
  1041a1:	5b                   	pop    %ebx
  1041a2:	5d                   	pop    %ebp
  1041a3:	c3                   	ret    
  1041a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1041aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001041b0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  1041b6:	c7 44 24 04 d9 69 10 	movl   $0x1069d9,0x4(%esp)
  1041bd:	00 
  1041be:	c7 04 24 20 e6 10 00 	movl   $0x10e620,(%esp)
  1041c5:	e8 06 00 00 00       	call   1041d0 <initlock>
}
  1041ca:	c9                   	leave  
  1041cb:	c3                   	ret    
  1041cc:	90                   	nop    
  1041cd:	90                   	nop    
  1041ce:	90                   	nop    
  1041cf:	90                   	nop    

001041d0 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  1041d0:	55                   	push   %ebp
  1041d1:	89 e5                	mov    %esp,%ebp
  1041d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  1041d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  1041d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  1041df:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  1041e2:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  1041e9:	5d                   	pop    %ebp
  1041ea:	c3                   	ret    
  1041eb:	90                   	nop    
  1041ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001041f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1041f0:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1041f1:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1041f3:	89 e5                	mov    %esp,%ebp
  1041f5:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1041f6:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1041f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1041fc:	83 ea 08             	sub    $0x8,%edx
  1041ff:	eb 02                	jmp    104203 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104201:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104203:	8d 42 ff             	lea    -0x1(%edx),%eax
  104206:	83 f8 fd             	cmp    $0xfffffffd,%eax
  104209:	77 13                	ja     10421e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10420b:	8b 42 04             	mov    0x4(%edx),%eax
  10420e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104211:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104214:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104216:	83 f9 0a             	cmp    $0xa,%ecx
  104219:	75 e6                	jne    104201 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  10421b:	5b                   	pop    %ebx
  10421c:	5d                   	pop    %ebp
  10421d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10421e:	83 f9 09             	cmp    $0x9,%ecx
  104221:	7f f8                	jg     10421b <getcallerpcs+0x2b>
  104223:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  104226:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  104229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10422f:	83 c0 04             	add    $0x4,%eax
  104232:	83 f9 0a             	cmp    $0xa,%ecx
  104235:	75 ef                	jne    104226 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  104237:	5b                   	pop    %ebx
  104238:	5d                   	pop    %ebp
  104239:	c3                   	ret    
  10423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104240 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  104240:	55                   	push   %ebp
  104241:	89 e5                	mov    %esp,%ebp
  104243:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104246:	9c                   	pushf  
  104247:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104248:	f6 c4 02             	test   $0x2,%ah
  10424b:	75 52                	jne    10429f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10424d:	e8 2e e4 ff ff       	call   102680 <cpu>
  104252:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104258:	05 a4 b6 10 00       	add    $0x10b6a4,%eax
  10425d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104263:	83 ea 01             	sub    $0x1,%edx
  104266:	85 d2                	test   %edx,%edx
  104268:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10426e:	78 3b                	js     1042ab <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104270:	e8 0b e4 ff ff       	call   102680 <cpu>
  104275:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10427b:	8b 90 64 b7 10 00    	mov    0x10b764(%eax),%edx
  104281:	85 d2                	test   %edx,%edx
  104283:	74 02                	je     104287 <popcli+0x47>
    sti();
}
  104285:	c9                   	leave  
  104286:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104287:	e8 f4 e3 ff ff       	call   102680 <cpu>
  10428c:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104292:	8b 80 68 b7 10 00    	mov    0x10b768(%eax),%eax
  104298:	85 c0                	test   %eax,%eax
  10429a:	74 e9                	je     104285 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10429c:	fb                   	sti    
    sti();
}
  10429d:	c9                   	leave  
  10429e:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10429f:	c7 04 24 28 6a 10 00 	movl   $0x106a28,(%esp)
  1042a6:	e8 f5 c5 ff ff       	call   1008a0 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  1042ab:	c7 04 24 3f 6a 10 00 	movl   $0x106a3f,(%esp)
  1042b2:	e8 e9 c5 ff ff       	call   1008a0 <panic>
  1042b7:	89 f6                	mov    %esi,%esi
  1042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001042c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1042c0:	55                   	push   %ebp
  1042c1:	89 e5                	mov    %esp,%ebp
  1042c3:	53                   	push   %ebx
  1042c4:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1042c7:	9c                   	pushf  
  1042c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1042c9:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  1042ca:	e8 b1 e3 ff ff       	call   102680 <cpu>
  1042cf:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1042d5:	05 a4 b6 10 00       	add    $0x10b6a4,%eax
  1042da:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1042e0:	83 c2 01             	add    $0x1,%edx
  1042e3:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1042e9:	83 ea 01             	sub    $0x1,%edx
  1042ec:	74 06                	je     1042f4 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  1042ee:	83 c4 04             	add    $0x4,%esp
  1042f1:	5b                   	pop    %ebx
  1042f2:	5d                   	pop    %ebp
  1042f3:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  1042f4:	e8 87 e3 ff ff       	call   102680 <cpu>
  1042f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1042ff:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104305:	89 98 68 b7 10 00    	mov    %ebx,0x10b768(%eax)
}
  10430b:	83 c4 04             	add    $0x4,%esp
  10430e:	5b                   	pop    %ebx
  10430f:	5d                   	pop    %ebp
  104310:	c3                   	ret    
  104311:	eb 0d                	jmp    104320 <holding>
  104313:	90                   	nop    
  104314:	90                   	nop    
  104315:	90                   	nop    
  104316:	90                   	nop    
  104317:	90                   	nop    
  104318:	90                   	nop    
  104319:	90                   	nop    
  10431a:	90                   	nop    
  10431b:	90                   	nop    
  10431c:	90                   	nop    
  10431d:	90                   	nop    
  10431e:	90                   	nop    
  10431f:	90                   	nop    

00104320 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104320:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104321:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104323:	89 e5                	mov    %esp,%ebp
  104325:	53                   	push   %ebx
  104326:	83 ec 04             	sub    $0x4,%esp
  104329:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10432c:	8b 0a                	mov    (%edx),%ecx
  10432e:	85 c9                	test   %ecx,%ecx
  104330:	74 13                	je     104345 <holding+0x25>
  104332:	8b 5a 08             	mov    0x8(%edx),%ebx
  104335:	e8 46 e3 ff ff       	call   102680 <cpu>
  10433a:	83 c0 0a             	add    $0xa,%eax
  10433d:	39 c3                	cmp    %eax,%ebx
  10433f:	0f 94 c0             	sete   %al
  104342:	0f b6 c0             	movzbl %al,%eax
}
  104345:	83 c4 04             	add    $0x4,%esp
  104348:	5b                   	pop    %ebx
  104349:	5d                   	pop    %ebp
  10434a:	c3                   	ret    
  10434b:	90                   	nop    
  10434c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104350 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  104350:	55                   	push   %ebp
  104351:	89 e5                	mov    %esp,%ebp
  104353:	53                   	push   %ebx
  104354:	83 ec 04             	sub    $0x4,%esp
  104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10435a:	89 1c 24             	mov    %ebx,(%esp)
  10435d:	e8 be ff ff ff       	call   104320 <holding>
  104362:	85 c0                	test   %eax,%eax
  104364:	74 1d                	je     104383 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104366:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10436d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10436f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104376:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104379:	83 c4 04             	add    $0x4,%esp
  10437c:	5b                   	pop    %ebx
  10437d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10437e:	e9 bd fe ff ff       	jmp    104240 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104383:	c7 04 24 46 6a 10 00 	movl   $0x106a46,(%esp)
  10438a:	e8 11 c5 ff ff       	call   1008a0 <panic>
  10438f:	90                   	nop    

00104390 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104390:	55                   	push   %ebp
  104391:	89 e5                	mov    %esp,%ebp
  104393:	53                   	push   %ebx
  104394:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104397:	e8 24 ff ff ff       	call   1042c0 <pushcli>
  if(holding(lock))
  10439c:	8b 45 08             	mov    0x8(%ebp),%eax
  10439f:	89 04 24             	mov    %eax,(%esp)
  1043a2:	e8 79 ff ff ff       	call   104320 <holding>
  1043a7:	85 c0                	test   %eax,%eax
  1043a9:	75 38                	jne    1043e3 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1043ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1043ae:	66 90                	xchg   %ax,%ax
  1043b0:	b8 01 00 00 00       	mov    $0x1,%eax
  1043b5:	f0 87 03             	lock xchg %eax,(%ebx)
  1043b8:	83 e8 01             	sub    $0x1,%eax
  1043bb:	74 f3                	je     1043b0 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1043bd:	e8 be e2 ff ff       	call   102680 <cpu>
  1043c2:	83 c0 0a             	add    $0xa,%eax
  1043c5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  1043c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1043cb:	83 c0 0c             	add    $0xc,%eax
  1043ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043d2:	8d 45 08             	lea    0x8(%ebp),%eax
  1043d5:	89 04 24             	mov    %eax,(%esp)
  1043d8:	e8 13 fe ff ff       	call   1041f0 <getcallerpcs>
}
  1043dd:	83 c4 14             	add    $0x14,%esp
  1043e0:	5b                   	pop    %ebx
  1043e1:	5d                   	pop    %ebp
  1043e2:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  1043e3:	c7 04 24 4e 6a 10 00 	movl   $0x106a4e,(%esp)
  1043ea:	e8 b1 c4 ff ff       	call   1008a0 <panic>
  1043ef:	90                   	nop    

001043f0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  1043f0:	55                   	push   %ebp
  1043f1:	89 e5                	mov    %esp,%ebp
  1043f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1043f6:	53                   	push   %ebx
  1043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1043fa:	85 c0                	test   %eax,%eax
  1043fc:	74 10                	je     10440e <memset+0x1e>
  1043fe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  104402:	31 d2                	xor    %edx,%edx
    *d++ = c;
  104404:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  104407:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10440a:	39 c2                	cmp    %eax,%edx
  10440c:	75 f6                	jne    104404 <memset+0x14>
    *d++ = c;

  return dst;
}
  10440e:	89 d8                	mov    %ebx,%eax
  104410:	5b                   	pop    %ebx
  104411:	5d                   	pop    %ebp
  104412:	c3                   	ret    
  104413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104420 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104420:	55                   	push   %ebp
  104421:	89 e5                	mov    %esp,%ebp
  104423:	57                   	push   %edi
  104424:	56                   	push   %esi
  104425:	53                   	push   %ebx
  104426:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104429:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  10442c:	8b 55 08             	mov    0x8(%ebp),%edx
  10442f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104432:	83 e8 01             	sub    $0x1,%eax
  104435:	83 f8 ff             	cmp    $0xffffffff,%eax
  104438:	74 36                	je     104470 <memcmp+0x50>
    if(*s1 != *s2)
  10443a:	0f b6 32             	movzbl (%edx),%esi
  10443d:	0f b6 0f             	movzbl (%edi),%ecx
  104440:	89 f3                	mov    %esi,%ebx
  104442:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  104445:	89 d1                	mov    %edx,%ecx
  104447:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104449:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  10444c:	74 1a                	je     104468 <memcmp+0x48>
  10444e:	eb 2c                	jmp    10447c <memcmp+0x5c>
  104450:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  104454:	83 c1 01             	add    $0x1,%ecx
  104457:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  10445b:	83 c2 01             	add    $0x1,%edx
  10445e:	88 5d f3             	mov    %bl,-0xd(%ebp)
  104461:	89 f3                	mov    %esi,%ebx
  104463:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  104466:	75 14                	jne    10447c <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104468:	83 e8 01             	sub    $0x1,%eax
  10446b:	83 f8 ff             	cmp    $0xffffffff,%eax
  10446e:	75 e0                	jne    104450 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104470:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104473:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104475:	5b                   	pop    %ebx
  104476:	89 d0                	mov    %edx,%eax
  104478:	5e                   	pop    %esi
  104479:	5f                   	pop    %edi
  10447a:	5d                   	pop    %ebp
  10447b:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  10447c:	89 f0                	mov    %esi,%eax
  10447e:	0f b6 d0             	movzbl %al,%edx
  104481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  104485:	83 c4 04             	add    $0x4,%esp
  104488:	5b                   	pop    %ebx
  104489:	5e                   	pop    %esi
  10448a:	5f                   	pop    %edi
  10448b:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  10448c:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  10448e:	89 d0                	mov    %edx,%eax
  104490:	c3                   	ret    
  104491:	eb 0d                	jmp    1044a0 <memmove>
  104493:	90                   	nop    
  104494:	90                   	nop    
  104495:	90                   	nop    
  104496:	90                   	nop    
  104497:	90                   	nop    
  104498:	90                   	nop    
  104499:	90                   	nop    
  10449a:	90                   	nop    
  10449b:	90                   	nop    
  10449c:	90                   	nop    
  10449d:	90                   	nop    
  10449e:	90                   	nop    
  10449f:	90                   	nop    

001044a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1044a0:	55                   	push   %ebp
  1044a1:	89 e5                	mov    %esp,%ebp
  1044a3:	56                   	push   %esi
  1044a4:	53                   	push   %ebx
  1044a5:	8b 75 08             	mov    0x8(%ebp),%esi
  1044a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1044ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1044ae:	39 f1                	cmp    %esi,%ecx
  1044b0:	73 2e                	jae    1044e0 <memmove+0x40>
  1044b2:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  1044b5:	39 c6                	cmp    %eax,%esi
  1044b7:	73 27                	jae    1044e0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1044b9:	85 db                	test   %ebx,%ebx
  1044bb:	74 1a                	je     1044d7 <memmove+0x37>
  1044bd:	89 c2                	mov    %eax,%edx
  1044bf:	29 d8                	sub    %ebx,%eax
  1044c1:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  1044c4:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  1044c6:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  1044ca:	83 ea 01             	sub    $0x1,%edx
  1044cd:	88 41 ff             	mov    %al,-0x1(%ecx)
  1044d0:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1044d3:	39 da                	cmp    %ebx,%edx
  1044d5:	75 ef                	jne    1044c6 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  1044d7:	89 f0                	mov    %esi,%eax
  1044d9:	5b                   	pop    %ebx
  1044da:	5e                   	pop    %esi
  1044db:	5d                   	pop    %ebp
  1044dc:	c3                   	ret    
  1044dd:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1044e0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  1044e2:	85 db                	test   %ebx,%ebx
  1044e4:	74 f1                	je     1044d7 <memmove+0x37>
      *d++ = *s++;
  1044e6:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  1044ea:	88 04 32             	mov    %al,(%edx,%esi,1)
  1044ed:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  1044f0:	39 da                	cmp    %ebx,%edx
  1044f2:	75 f2                	jne    1044e6 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  1044f4:	89 f0                	mov    %esi,%eax
  1044f6:	5b                   	pop    %ebx
  1044f7:	5e                   	pop    %esi
  1044f8:	5d                   	pop    %ebp
  1044f9:	c3                   	ret    
  1044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104500 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	56                   	push   %esi
  104504:	53                   	push   %ebx
  104505:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104508:	8b 55 08             	mov    0x8(%ebp),%edx
  10450b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10450e:	85 db                	test   %ebx,%ebx
  104510:	74 2a                	je     10453c <strncmp+0x3c>
  104512:	0f b6 02             	movzbl (%edx),%eax
  104515:	84 c0                	test   %al,%al
  104517:	74 2b                	je     104544 <strncmp+0x44>
  104519:	0f b6 0e             	movzbl (%esi),%ecx
  10451c:	38 c8                	cmp    %cl,%al
  10451e:	74 17                	je     104537 <strncmp+0x37>
  104520:	eb 25                	jmp    104547 <strncmp+0x47>
  104522:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  104526:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104529:	84 c0                	test   %al,%al
  10452b:	74 17                	je     104544 <strncmp+0x44>
  10452d:	0f b6 0e             	movzbl (%esi),%ecx
  104530:	83 c2 01             	add    $0x1,%edx
  104533:	38 c8                	cmp    %cl,%al
  104535:	75 10                	jne    104547 <strncmp+0x47>
  104537:	83 eb 01             	sub    $0x1,%ebx
  10453a:	75 e6                	jne    104522 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  10453c:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10453d:	31 d2                	xor    %edx,%edx
}
  10453f:	5e                   	pop    %esi
  104540:	89 d0                	mov    %edx,%eax
  104542:	5d                   	pop    %ebp
  104543:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104544:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  104547:	0f b6 d0             	movzbl %al,%edx
  10454a:	0f b6 c1             	movzbl %cl,%eax
}
  10454d:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10454e:	29 c2                	sub    %eax,%edx
}
  104550:	5e                   	pop    %esi
  104551:	89 d0                	mov    %edx,%eax
  104553:	5d                   	pop    %ebp
  104554:	c3                   	ret    
  104555:	8d 74 26 00          	lea    0x0(%esi),%esi
  104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104560 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  104560:	55                   	push   %ebp
  104561:	89 e5                	mov    %esp,%ebp
  104563:	56                   	push   %esi
  104564:	8b 75 08             	mov    0x8(%ebp),%esi
  104567:	53                   	push   %ebx
  104568:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10456b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10456e:	89 f2                	mov    %esi,%edx
  104570:	eb 03                	jmp    104575 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104572:	83 c3 01             	add    $0x1,%ebx
  104575:	83 e9 01             	sub    $0x1,%ecx
  104578:	8d 41 01             	lea    0x1(%ecx),%eax
  10457b:	85 c0                	test   %eax,%eax
  10457d:	7e 0c                	jle    10458b <strncpy+0x2b>
  10457f:	0f b6 03             	movzbl (%ebx),%eax
  104582:	88 02                	mov    %al,(%edx)
  104584:	83 c2 01             	add    $0x1,%edx
  104587:	84 c0                	test   %al,%al
  104589:	75 e7                	jne    104572 <strncpy+0x12>
    ;
  while(n-- > 0)
  10458b:	85 c9                	test   %ecx,%ecx
  10458d:	7e 0d                	jle    10459c <strncpy+0x3c>
  10458f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  104592:	c6 02 00             	movb   $0x0,(%edx)
  104595:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104598:	39 c2                	cmp    %eax,%edx
  10459a:	75 f6                	jne    104592 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  10459c:	89 f0                	mov    %esi,%eax
  10459e:	5b                   	pop    %ebx
  10459f:	5e                   	pop    %esi
  1045a0:	5d                   	pop    %ebp
  1045a1:	c3                   	ret    
  1045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001045b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1045b0:	55                   	push   %ebp
  1045b1:	89 e5                	mov    %esp,%ebp
  1045b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1045b6:	56                   	push   %esi
  1045b7:	8b 75 08             	mov    0x8(%ebp),%esi
  1045ba:	53                   	push   %ebx
  1045bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  1045be:	85 c9                	test   %ecx,%ecx
  1045c0:	7e 1b                	jle    1045dd <safestrcpy+0x2d>
  1045c2:	89 f2                	mov    %esi,%edx
  1045c4:	eb 03                	jmp    1045c9 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1045c6:	83 c3 01             	add    $0x1,%ebx
  1045c9:	83 e9 01             	sub    $0x1,%ecx
  1045cc:	74 0c                	je     1045da <safestrcpy+0x2a>
  1045ce:	0f b6 03             	movzbl (%ebx),%eax
  1045d1:	88 02                	mov    %al,(%edx)
  1045d3:	83 c2 01             	add    $0x1,%edx
  1045d6:	84 c0                	test   %al,%al
  1045d8:	75 ec                	jne    1045c6 <safestrcpy+0x16>
    ;
  *s = 0;
  1045da:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  1045dd:	89 f0                	mov    %esi,%eax
  1045df:	5b                   	pop    %ebx
  1045e0:	5e                   	pop    %esi
  1045e1:	5d                   	pop    %ebp
  1045e2:	c3                   	ret    
  1045e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001045f0 <strlen>:

int
strlen(const char *s)
{
  1045f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  1045f1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  1045f3:	89 e5                	mov    %esp,%ebp
  1045f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  1045f8:	80 3a 00             	cmpb   $0x0,(%edx)
  1045fb:	74 0c                	je     104609 <strlen+0x19>
  1045fd:	8d 76 00             	lea    0x0(%esi),%esi
  104600:	83 c0 01             	add    $0x1,%eax
  104603:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  104607:	75 f7                	jne    104600 <strlen+0x10>
    ;
  return n;
}
  104609:	5d                   	pop    %ebp
  10460a:	c3                   	ret    
  10460b:	90                   	nop    

0010460c <swtch>:
  10460c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104610:	8f 00                	popl   (%eax)
  104612:	89 60 04             	mov    %esp,0x4(%eax)
  104615:	89 58 08             	mov    %ebx,0x8(%eax)
  104618:	89 48 0c             	mov    %ecx,0xc(%eax)
  10461b:	89 50 10             	mov    %edx,0x10(%eax)
  10461e:	89 70 14             	mov    %esi,0x14(%eax)
  104621:	89 78 18             	mov    %edi,0x18(%eax)
  104624:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104627:	8b 44 24 04          	mov    0x4(%esp),%eax
  10462b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10462e:	8b 78 18             	mov    0x18(%eax),%edi
  104631:	8b 70 14             	mov    0x14(%eax),%esi
  104634:	8b 50 10             	mov    0x10(%eax),%edx
  104637:	8b 48 0c             	mov    0xc(%eax),%ecx
  10463a:	8b 58 08             	mov    0x8(%eax),%ebx
  10463d:	8b 60 04             	mov    0x4(%eax),%esp
  104640:	ff 30                	pushl  (%eax)
  104642:	c3                   	ret    
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

00104650 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104650:	55                   	push   %ebp
  104651:	89 e5                	mov    %esp,%ebp
  104653:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  104656:	8b 51 04             	mov    0x4(%ecx),%edx
  104659:	3b 55 0c             	cmp    0xc(%ebp),%edx
  10465c:	77 07                	ja     104665 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  10465e:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  10465f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104664:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104665:	8b 45 0c             	mov    0xc(%ebp),%eax
  104668:	83 c0 04             	add    $0x4,%eax
  10466b:	39 c2                	cmp    %eax,%edx
  10466d:	72 ef                	jb     10465e <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10466f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104672:	8b 01                	mov    (%ecx),%eax
  104674:	8b 04 10             	mov    (%eax,%edx,1),%eax
  104677:	8b 55 10             	mov    0x10(%ebp),%edx
  10467a:	89 02                	mov    %eax,(%edx)
  10467c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10467e:	5d                   	pop    %ebp
  10467f:	c3                   	ret    

00104680 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	8b 45 08             	mov    0x8(%ebp),%eax
  104686:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  104689:	39 50 04             	cmp    %edx,0x4(%eax)
  10468c:	77 07                	ja     104695 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10468e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104693:	5d                   	pop    %ebp
  104694:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104695:	89 d1                	mov    %edx,%ecx
  104697:	8b 55 10             	mov    0x10(%ebp),%edx
  10469a:	03 08                	add    (%eax),%ecx
  10469c:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  10469e:	8b 50 04             	mov    0x4(%eax),%edx
  1046a1:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  1046a3:	39 d1                	cmp    %edx,%ecx
  1046a5:	73 e7                	jae    10468e <fetchstr+0xe>
    if(*s == 0)
  1046a7:	31 c0                	xor    %eax,%eax
  1046a9:	80 39 00             	cmpb   $0x0,(%ecx)
  1046ac:	74 e5                	je     104693 <fetchstr+0x13>
  1046ae:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1046b0:	83 c0 01             	add    $0x1,%eax
  1046b3:	39 d0                	cmp    %edx,%eax
  1046b5:	74 d7                	je     10468e <fetchstr+0xe>
    if(*s == 0)
  1046b7:	80 38 00             	cmpb   $0x0,(%eax)
  1046ba:	75 f4                	jne    1046b0 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  1046bc:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  1046bd:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  1046bf:	c3                   	ret    

001046c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1046c0:	55                   	push   %ebp
  1046c1:	89 e5                	mov    %esp,%ebp
  1046c3:	53                   	push   %ebx
  1046c4:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1046c7:	e8 64 ec ff ff       	call   103330 <curproc>
  1046cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1046cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1046d5:	8b 40 3c             	mov    0x3c(%eax),%eax
  1046d8:	83 c0 04             	add    $0x4,%eax
  1046db:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  1046de:	e8 4d ec ff ff       	call   103330 <curproc>
  1046e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1046ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1046ee:	89 04 24             	mov    %eax,(%esp)
  1046f1:	e8 5a ff ff ff       	call   104650 <fetchint>
}
  1046f6:	83 c4 14             	add    $0x14,%esp
  1046f9:	5b                   	pop    %ebx
  1046fa:	5d                   	pop    %ebp
  1046fb:	c3                   	ret    
  1046fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00104700 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104700:	55                   	push   %ebp
  104701:	89 e5                	mov    %esp,%ebp
  104703:	53                   	push   %ebx
  104704:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104707:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10470a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10470e:	8b 45 08             	mov    0x8(%ebp),%eax
  104711:	89 04 24             	mov    %eax,(%esp)
  104714:	e8 a7 ff ff ff       	call   1046c0 <argint>
  104719:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10471e:	85 c0                	test   %eax,%eax
  104720:	78 1d                	js     10473f <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  104722:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104725:	e8 06 ec ff ff       	call   103330 <curproc>
  10472a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10472d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104731:	89 54 24 08          	mov    %edx,0x8(%esp)
  104735:	89 04 24             	mov    %eax,(%esp)
  104738:	e8 43 ff ff ff       	call   104680 <fetchstr>
  10473d:	89 c2                	mov    %eax,%edx
}
  10473f:	83 c4 24             	add    $0x24,%esp
  104742:	89 d0                	mov    %edx,%eax
  104744:	5b                   	pop    %ebx
  104745:	5d                   	pop    %ebp
  104746:	c3                   	ret    
  104747:	89 f6                	mov    %esi,%esi
  104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104750 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	53                   	push   %ebx
  104754:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104757:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10475a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10475e:	8b 45 08             	mov    0x8(%ebp),%eax
  104761:	89 04 24             	mov    %eax,(%esp)
  104764:	e8 57 ff ff ff       	call   1046c0 <argint>
  104769:	85 c0                	test   %eax,%eax
  10476b:	79 0b                	jns    104778 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  10476d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104772:	83 c4 24             	add    $0x24,%esp
  104775:	5b                   	pop    %ebx
  104776:	5d                   	pop    %ebp
  104777:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104778:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10477b:	e8 b0 eb ff ff       	call   103330 <curproc>
  104780:	3b 58 04             	cmp    0x4(%eax),%ebx
  104783:	73 e8                	jae    10476d <argptr+0x1d>
  104785:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104788:	01 45 10             	add    %eax,0x10(%ebp)
  10478b:	e8 a0 eb ff ff       	call   103330 <curproc>
  104790:	8b 55 10             	mov    0x10(%ebp),%edx
  104793:	3b 50 04             	cmp    0x4(%eax),%edx
  104796:	73 d5                	jae    10476d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104798:	e8 93 eb ff ff       	call   103330 <curproc>
  10479d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1047a0:	03 10                	add    (%eax),%edx
  1047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a5:	89 10                	mov    %edx,(%eax)
  1047a7:	31 c0                	xor    %eax,%eax
  1047a9:	eb c7                	jmp    104772 <argptr+0x22>
  1047ab:	90                   	nop    
  1047ac:	8d 74 26 00          	lea    0x0(%esi),%esi

001047b0 <syscall>:
[SYS_xchng]		sys_xchng,
};

void
syscall(void)
{
  1047b0:	55                   	push   %ebp
  1047b1:	89 e5                	mov    %esp,%ebp
  1047b3:	83 ec 18             	sub    $0x18,%esp
  1047b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1047b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1047bc:	e8 6f eb ff ff       	call   103330 <curproc>
  1047c1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1047c7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  1047ca:	83 fb 1b             	cmp    $0x1b,%ebx
  1047cd:	77 25                	ja     1047f4 <syscall+0x44>
  1047cf:	8b 34 9d 80 6a 10 00 	mov    0x106a80(,%ebx,4),%esi
  1047d6:	85 f6                	test   %esi,%esi
  1047d8:	74 1a                	je     1047f4 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  1047da:	e8 51 eb ff ff       	call   103330 <curproc>
  1047df:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  1047e5:	ff d6                	call   *%esi
  1047e7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  1047ea:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1047ed:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1047f0:	89 ec                	mov    %ebp,%esp
  1047f2:	5d                   	pop    %ebp
  1047f3:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  1047f4:	e8 37 eb ff ff       	call   103330 <curproc>
  1047f9:	89 c6                	mov    %eax,%esi
  1047fb:	e8 30 eb ff ff       	call   103330 <curproc>
  104800:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  104806:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10480a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10480e:	8b 40 10             	mov    0x10(%eax),%eax
  104811:	c7 04 24 56 6a 10 00 	movl   $0x106a56,(%esp)
  104818:	89 44 24 04          	mov    %eax,0x4(%esp)
  10481c:	e8 df be ff ff       	call   100700 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104821:	e8 0a eb ff ff       	call   103330 <curproc>
  104826:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10482c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104833:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104836:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104839:	89 ec                	mov    %ebp,%esp
  10483b:	5d                   	pop    %ebp
  10483c:	c3                   	ret    
  10483d:	90                   	nop    
  10483e:	90                   	nop    
  10483f:	90                   	nop    

00104840 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104840:	55                   	push   %ebp
  104841:	89 e5                	mov    %esp,%ebp
  104843:	56                   	push   %esi
  104844:	89 c6                	mov    %eax,%esi
  104846:	53                   	push   %ebx
  104847:	31 db                	xor    %ebx,%ebx
  104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104850:	e8 db ea ff ff       	call   103330 <curproc>
  104855:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  104859:	85 c0                	test   %eax,%eax
  10485b:	74 13                	je     104870 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  10485d:	83 c3 01             	add    $0x1,%ebx
  104860:	83 fb 10             	cmp    $0x10,%ebx
  104863:	75 eb                	jne    104850 <fdalloc+0x10>
  104865:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  10486a:	89 d8                	mov    %ebx,%eax
  10486c:	5b                   	pop    %ebx
  10486d:	5e                   	pop    %esi
  10486e:	5d                   	pop    %ebp
  10486f:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104870:	e8 bb ea ff ff       	call   103330 <curproc>
  104875:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  104879:	89 d8                	mov    %ebx,%eax
  10487b:	5b                   	pop    %ebx
  10487c:	5e                   	pop    %esi
  10487d:	5d                   	pop    %ebp
  10487e:	c3                   	ret    
  10487f:	90                   	nop    

00104880 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104880:	55                   	push   %ebp
  104881:	89 e5                	mov    %esp,%ebp
  104883:	53                   	push   %ebx
  104884:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104887:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10488a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104891:	00 
  104892:	89 44 24 04          	mov    %eax,0x4(%esp)
  104896:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10489d:	e8 ae fe ff ff       	call   104750 <argptr>
  1048a2:	85 c0                	test   %eax,%eax
  1048a4:	79 0b                	jns    1048b1 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  1048a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048ab:	83 c4 24             	add    $0x24,%esp
  1048ae:	5b                   	pop    %ebx
  1048af:	5d                   	pop    %ebp
  1048b0:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1048b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1048bb:	89 04 24             	mov    %eax,(%esp)
  1048be:	e8 6d e6 ff ff       	call   102f30 <pipealloc>
  1048c3:	85 c0                	test   %eax,%eax
  1048c5:	78 df                	js     1048a6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1048c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ca:	e8 71 ff ff ff       	call   104840 <fdalloc>
  1048cf:	85 c0                	test   %eax,%eax
  1048d1:	89 c3                	mov    %eax,%ebx
  1048d3:	78 27                	js     1048fc <sys_pipe+0x7c>
  1048d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048d8:	e8 63 ff ff ff       	call   104840 <fdalloc>
  1048dd:	85 c0                	test   %eax,%eax
  1048df:	89 c2                	mov    %eax,%edx
  1048e1:	78 0c                	js     1048ef <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  1048e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048e6:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  1048e8:	89 50 04             	mov    %edx,0x4(%eax)
  1048eb:	31 c0                	xor    %eax,%eax
  1048ed:	eb bc                	jmp    1048ab <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  1048ef:	e8 3c ea ff ff       	call   103330 <curproc>
  1048f4:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  1048fb:	00 
    fileclose(rf);
  1048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ff:	89 04 24             	mov    %eax,(%esp)
  104902:	e8 59 c6 ff ff       	call   100f60 <fileclose>
    fileclose(wf);
  104907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10490a:	89 04 24             	mov    %eax,(%esp)
  10490d:	e8 4e c6 ff ff       	call   100f60 <fileclose>
  104912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104917:	eb 92                	jmp    1048ab <sys_pipe+0x2b>
  104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104920 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104920:	55                   	push   %ebp
  104921:	89 e5                	mov    %esp,%ebp
  104923:	83 ec 28             	sub    $0x28,%esp
  104926:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104929:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10492b:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  10492e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104931:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104933:	89 54 24 04          	mov    %edx,0x4(%esp)
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 81 fd ff ff       	call   1046c0 <argint>
  10493f:	85 c0                	test   %eax,%eax
  104941:	79 0f                	jns    104952 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104948:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10494b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10494e:	89 ec                	mov    %ebp,%esp
  104950:	5d                   	pop    %ebp
  104951:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  104952:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104956:	77 eb                	ja     104943 <argfd+0x23>
  104958:	e8 d3 e9 ff ff       	call   103330 <curproc>
  10495d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104960:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104964:	85 c9                	test   %ecx,%ecx
  104966:	74 db                	je     104943 <argfd+0x23>
    return -1;
  if(pfd)
  104968:	85 db                	test   %ebx,%ebx
  10496a:	74 02                	je     10496e <argfd+0x4e>
    *pfd = fd;
  10496c:	89 13                	mov    %edx,(%ebx)
  if(pf)
  10496e:	31 c0                	xor    %eax,%eax
  104970:	85 f6                	test   %esi,%esi
  104972:	74 d4                	je     104948 <argfd+0x28>
    *pf = f;
  104974:	89 0e                	mov    %ecx,(%esi)
  104976:	eb d0                	jmp    104948 <argfd+0x28>
  104978:	90                   	nop    
  104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104980 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  104980:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104981:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  104983:	89 e5                	mov    %esp,%ebp
  104985:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104988:	8d 55 fc             	lea    -0x4(%ebp),%edx
  10498b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10498e:	e8 8d ff ff ff       	call   104920 <argfd>
  104993:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104998:	85 c0                	test   %eax,%eax
  10499a:	78 1d                	js     1049b9 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10499c:	e8 8f e9 ff ff       	call   103330 <curproc>
  1049a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1049a4:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  1049ab:	00 
  fileclose(f);
  1049ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1049af:	89 04 24             	mov    %eax,(%esp)
  1049b2:	e8 a9 c5 ff ff       	call   100f60 <fileclose>
  1049b7:	31 d2                	xor    %edx,%edx
  return 0;
}
  1049b9:	c9                   	leave  
  1049ba:	89 d0                	mov    %edx,%eax
  1049bc:	c3                   	ret    
  1049bd:	8d 76 00             	lea    0x0(%esi),%esi

001049c0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  1049c0:	55                   	push   %ebp
  1049c1:	89 e5                	mov    %esp,%ebp
  1049c3:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1049c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  1049c9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1049cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1049cf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1049d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1049dd:	e8 1e fd ff ff       	call   104700 <argstr>
  1049e2:	85 c0                	test   %eax,%eax
  1049e4:	79 12                	jns    1049f8 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  1049e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  1049eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1049ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1049f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1049f4:	89 ec                	mov    %ebp,%esp
  1049f6:	5d                   	pop    %ebp
  1049f7:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1049f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1049fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a06:	e8 b5 fc ff ff       	call   1046c0 <argint>
  104a0b:	85 c0                	test   %eax,%eax
  104a0d:	78 d7                	js     1049e6 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  104a0f:	8d 45 98             	lea    -0x68(%ebp),%eax
  104a12:	31 f6                	xor    %esi,%esi
  104a14:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104a1b:	00 
  104a1c:	31 ff                	xor    %edi,%edi
  104a1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a25:	00 
  104a26:	89 04 24             	mov    %eax,(%esp)
  104a29:	e8 c2 f9 ff ff       	call   1043f0 <memset>
  104a2e:	eb 27                	jmp    104a57 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104a30:	e8 fb e8 ff ff       	call   103330 <curproc>
  104a35:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104a39:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a3d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104a41:	89 04 24             	mov    %eax,(%esp)
  104a44:	e8 37 fc ff ff       	call   104680 <fetchstr>
  104a49:	85 c0                	test   %eax,%eax
  104a4b:	78 99                	js     1049e6 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104a4d:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  104a50:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104a53:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  104a55:	74 8f                	je     1049e6 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104a57:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104a5e:	03 5d ec             	add    -0x14(%ebp),%ebx
  104a61:	e8 ca e8 ff ff       	call   103330 <curproc>
  104a66:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104a69:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a6d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104a71:	89 04 24             	mov    %eax,(%esp)
  104a74:	e8 d7 fb ff ff       	call   104650 <fetchint>
  104a79:	85 c0                	test   %eax,%eax
  104a7b:	0f 88 65 ff ff ff    	js     1049e6 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  104a81:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104a84:	85 db                	test   %ebx,%ebx
  104a86:	75 a8                	jne    104a30 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104a88:	8d 45 98             	lea    -0x68(%ebp),%eax
  104a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104a92:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104a99:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104a9a:	89 04 24             	mov    %eax,(%esp)
  104a9d:	e8 9e be ff ff       	call   100940 <exec>
  104aa2:	e9 44 ff ff ff       	jmp    1049eb <sys_exec+0x2b>
  104aa7:	89 f6                	mov    %esi,%esi
  104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104ab0 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104ab0:	55                   	push   %ebp
  104ab1:	89 e5                	mov    %esp,%ebp
  104ab3:	53                   	push   %ebx
  104ab4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104ab7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104aba:	89 44 24 04          	mov    %eax,0x4(%esp)
  104abe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ac5:	e8 36 fc ff ff       	call   104700 <argstr>
  104aca:	85 c0                	test   %eax,%eax
  104acc:	79 0b                	jns    104ad9 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104ace:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ad3:	83 c4 24             	add    $0x24,%esp
  104ad6:	5b                   	pop    %ebx
  104ad7:	5d                   	pop    %ebp
  104ad8:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104ad9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104adc:	89 04 24             	mov    %eax,(%esp)
  104adf:	e8 2c d3 ff ff       	call   101e10 <namei>
  104ae4:	85 c0                	test   %eax,%eax
  104ae6:	89 c3                	mov    %eax,%ebx
  104ae8:	74 e4                	je     104ace <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104aea:	89 04 24             	mov    %eax,(%esp)
  104aed:	e8 8e d0 ff ff       	call   101b80 <ilock>
  if(ip->type != T_DIR){
  104af2:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104af7:	75 24                	jne    104b1d <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104af9:	89 1c 24             	mov    %ebx,(%esp)
  104afc:	e8 0f d0 ff ff       	call   101b10 <iunlock>
  iput(cp->cwd);
  104b01:	e8 2a e8 ff ff       	call   103330 <curproc>
  104b06:	8b 40 60             	mov    0x60(%eax),%eax
  104b09:	89 04 24             	mov    %eax,(%esp)
  104b0c:	e8 cf cd ff ff       	call   1018e0 <iput>
  cp->cwd = ip;
  104b11:	e8 1a e8 ff ff       	call   103330 <curproc>
  104b16:	89 58 60             	mov    %ebx,0x60(%eax)
  104b19:	31 c0                	xor    %eax,%eax
  104b1b:	eb b6                	jmp    104ad3 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104b1d:	89 1c 24             	mov    %ebx,(%esp)
  104b20:	e8 3b d0 ff ff       	call   101b60 <iunlockput>
  104b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104b2a:	eb a7                	jmp    104ad3 <sys_chdir+0x23>
  104b2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104b30 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104b36:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104b39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b4d:	e8 ae fb ff ff       	call   104700 <argstr>
  104b52:	85 c0                	test   %eax,%eax
  104b54:	79 12                	jns    104b68 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  104b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  104b5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b64:	89 ec                	mov    %ebp,%esp
  104b66:	5d                   	pop    %ebp
  104b67:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104b68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b76:	e8 85 fb ff ff       	call   104700 <argstr>
  104b7b:	85 c0                	test   %eax,%eax
  104b7d:	78 d7                	js     104b56 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b82:	89 04 24             	mov    %eax,(%esp)
  104b85:	e8 86 d2 ff ff       	call   101e10 <namei>
  104b8a:	85 c0                	test   %eax,%eax
  104b8c:	89 c3                	mov    %eax,%ebx
  104b8e:	74 c6                	je     104b56 <sys_link+0x26>
    return -1;
  ilock(ip);
  104b90:	89 04 24             	mov    %eax,(%esp)
  104b93:	e8 e8 cf ff ff       	call   101b80 <ilock>
  if(ip->type == T_DIR){
  104b98:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104b9d:	74 58                	je     104bf7 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104b9f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104ba4:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104ba7:	89 1c 24             	mov    %ebx,(%esp)
  104baa:	e8 01 c6 ff ff       	call   1011b0 <iupdate>
  iunlock(ip);
  104baf:	89 1c 24             	mov    %ebx,(%esp)
  104bb2:	e8 59 cf ff ff       	call   101b10 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104bbe:	89 04 24             	mov    %eax,(%esp)
  104bc1:	e8 2a d2 ff ff       	call   101df0 <nameiparent>
  104bc6:	85 c0                	test   %eax,%eax
  104bc8:	89 c6                	mov    %eax,%esi
  104bca:	74 16                	je     104be2 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  104bcc:	89 04 24             	mov    %eax,(%esp)
  104bcf:	e8 ac cf ff ff       	call   101b80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104bd4:	8b 06                	mov    (%esi),%eax
  104bd6:	3b 03                	cmp    (%ebx),%eax
  104bd8:	74 2a                	je     104c04 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  104bda:	89 34 24             	mov    %esi,(%esp)
  104bdd:	e8 7e cf ff ff       	call   101b60 <iunlockput>
  ilock(ip);
  104be2:	89 1c 24             	mov    %ebx,(%esp)
  104be5:	e8 96 cf ff ff       	call   101b80 <ilock>
  ip->nlink--;
  104bea:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104bef:	89 1c 24             	mov    %ebx,(%esp)
  104bf2:	e8 b9 c5 ff ff       	call   1011b0 <iupdate>
  iunlockput(ip);
  104bf7:	89 1c 24             	mov    %ebx,(%esp)
  104bfa:	e8 61 cf ff ff       	call   101b60 <iunlockput>
  104bff:	e9 52 ff ff ff       	jmp    104b56 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104c04:	8b 43 04             	mov    0x4(%ebx),%eax
  104c07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104c0b:	89 34 24             	mov    %esi,(%esp)
  104c0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c12:	e8 09 ce ff ff       	call   101a20 <dirlink>
  104c17:	85 c0                	test   %eax,%eax
  104c19:	78 bf                	js     104bda <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  104c1b:	89 34 24             	mov    %esi,(%esp)
  104c1e:	e8 3d cf ff ff       	call   101b60 <iunlockput>
  iput(ip);
  104c23:	89 1c 24             	mov    %ebx,(%esp)
  104c26:	e8 b5 cc ff ff       	call   1018e0 <iput>
  104c2b:	31 c0                	xor    %eax,%eax
  104c2d:	e9 29 ff ff ff       	jmp    104b5b <sys_link+0x2b>
  104c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104c40 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104c40:	55                   	push   %ebp
  104c41:	89 e5                	mov    %esp,%ebp
  104c43:	57                   	push   %edi
  104c44:	89 d7                	mov    %edx,%edi
  104c46:	56                   	push   %esi
  104c47:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104c48:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104c4a:	83 ec 3c             	sub    $0x3c,%esp
  104c4d:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104c51:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104c55:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104c59:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104c5d:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104c61:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104c64:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c68:	89 04 24             	mov    %eax,(%esp)
  104c6b:	e8 80 d1 ff ff       	call   101df0 <nameiparent>
  104c70:	85 c0                	test   %eax,%eax
  104c72:	89 c6                	mov    %eax,%esi
  104c74:	74 5a                	je     104cd0 <create+0x90>
    return 0;
  ilock(dp);
  104c76:	89 04 24             	mov    %eax,(%esp)
  104c79:	e8 02 cf ff ff       	call   101b80 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104c7e:	85 ff                	test   %edi,%edi
  104c80:	74 5e                	je     104ce0 <create+0xa0>
  104c82:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104c85:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c89:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c90:	89 34 24             	mov    %esi,(%esp)
  104c93:	e8 c8 c9 ff ff       	call   101660 <dirlookup>
  104c98:	85 c0                	test   %eax,%eax
  104c9a:	89 c3                	mov    %eax,%ebx
  104c9c:	74 42                	je     104ce0 <create+0xa0>
    iunlockput(dp);
  104c9e:	89 34 24             	mov    %esi,(%esp)
  104ca1:	e8 ba ce ff ff       	call   101b60 <iunlockput>
    ilock(ip);
  104ca6:	89 1c 24             	mov    %ebx,(%esp)
  104ca9:	e8 d2 ce ff ff       	call   101b80 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104cae:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104cb2:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104cb6:	75 0e                	jne    104cc6 <create+0x86>
  104cb8:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104cbc:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104cc0:	0f 84 da 00 00 00    	je     104da0 <create+0x160>
      iunlockput(ip);
  104cc6:	89 1c 24             	mov    %ebx,(%esp)
  104cc9:	31 db                	xor    %ebx,%ebx
  104ccb:	e8 90 ce ff ff       	call   101b60 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104cd0:	83 c4 3c             	add    $0x3c,%esp
  104cd3:	89 d8                	mov    %ebx,%eax
  104cd5:	5b                   	pop    %ebx
  104cd6:	5e                   	pop    %esi
  104cd7:	5f                   	pop    %edi
  104cd8:	5d                   	pop    %ebp
  104cd9:	c3                   	ret    
  104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104ce0:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ce8:	8b 06                	mov    (%esi),%eax
  104cea:	89 04 24             	mov    %eax,(%esp)
  104ced:	e8 6e ca ff ff       	call   101760 <ialloc>
  104cf2:	85 c0                	test   %eax,%eax
  104cf4:	89 c3                	mov    %eax,%ebx
  104cf6:	74 47                	je     104d3f <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104cf8:	89 04 24             	mov    %eax,(%esp)
  104cfb:	e8 80 ce ff ff       	call   101b80 <ilock>
  ip->major = major;
  104d00:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  104d04:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  104d08:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104d0e:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104d12:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104d16:	89 1c 24             	mov    %ebx,(%esp)
  104d19:	e8 92 c4 ff ff       	call   1011b0 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104d1e:	8b 43 04             	mov    0x4(%ebx),%eax
  104d21:	89 34 24             	mov    %esi,(%esp)
  104d24:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d28:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d2f:	e8 ec cc ff ff       	call   101a20 <dirlink>
  104d34:	85 c0                	test   %eax,%eax
  104d36:	78 7b                	js     104db3 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104d38:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  104d3d:	74 12                	je     104d51 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104d3f:	89 34 24             	mov    %esi,(%esp)
  104d42:	e8 19 ce ff ff       	call   101b60 <iunlockput>
  return ip;
}
  104d47:	83 c4 3c             	add    $0x3c,%esp
  104d4a:	89 d8                	mov    %ebx,%eax
  104d4c:	5b                   	pop    %ebx
  104d4d:	5e                   	pop    %esi
  104d4e:	5f                   	pop    %edi
  104d4f:	5d                   	pop    %ebp
  104d50:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104d51:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  104d56:	89 34 24             	mov    %esi,(%esp)
  104d59:	e8 52 c4 ff ff       	call   1011b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104d5e:	8b 43 04             	mov    0x4(%ebx),%eax
  104d61:	c7 44 24 04 f1 6a 10 	movl   $0x106af1,0x4(%esp)
  104d68:	00 
  104d69:	89 1c 24             	mov    %ebx,(%esp)
  104d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d70:	e8 ab cc ff ff       	call   101a20 <dirlink>
  104d75:	85 c0                	test   %eax,%eax
  104d77:	78 1b                	js     104d94 <create+0x154>
  104d79:	8b 46 04             	mov    0x4(%esi),%eax
  104d7c:	c7 44 24 04 f0 6a 10 	movl   $0x106af0,0x4(%esp)
  104d83:	00 
  104d84:	89 1c 24             	mov    %ebx,(%esp)
  104d87:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d8b:	e8 90 cc ff ff       	call   101a20 <dirlink>
  104d90:	85 c0                	test   %eax,%eax
  104d92:	79 ab                	jns    104d3f <create+0xff>
      panic("create dots");
  104d94:	c7 04 24 f3 6a 10 00 	movl   $0x106af3,(%esp)
  104d9b:	e8 00 bb ff ff       	call   1008a0 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104da0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104da4:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104da8:	0f 85 18 ff ff ff    	jne    104cc6 <create+0x86>
  104dae:	e9 1d ff ff ff       	jmp    104cd0 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104db3:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104db9:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  104dbc:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  104dbe:	e8 9d cd ff ff       	call   101b60 <iunlockput>
    iunlockput(dp);
  104dc3:	89 34 24             	mov    %esi,(%esp)
  104dc6:	e8 95 cd ff ff       	call   101b60 <iunlockput>
  104dcb:	e9 00 ff ff ff       	jmp    104cd0 <create+0x90>

00104dd0 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104dd0:	55                   	push   %ebp
  104dd1:	89 e5                	mov    %esp,%ebp
  104dd3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104dd6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ddd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104de4:	e8 17 f9 ff ff       	call   104700 <argstr>
  104de9:	85 c0                	test   %eax,%eax
  104deb:	79 07                	jns    104df4 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  104ded:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  104dee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104df3:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104df7:	31 d2                	xor    %edx,%edx
  104df9:	b9 01 00 00 00       	mov    $0x1,%ecx
  104dfe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e05:	00 
  104e06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e0d:	e8 2e fe ff ff       	call   104c40 <create>
  104e12:	85 c0                	test   %eax,%eax
  104e14:	74 d7                	je     104ded <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104e16:	89 04 24             	mov    %eax,(%esp)
  104e19:	e8 42 cd ff ff       	call   101b60 <iunlockput>
  104e1e:	31 c0                	xor    %eax,%eax
  return 0;
}
  104e20:	c9                   	leave  
  104e21:	c3                   	ret    
  104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104e30 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  104e30:	55                   	push   %ebp
  104e31:	89 e5                	mov    %esp,%ebp
  104e33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104e36:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104e39:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e44:	e8 b7 f8 ff ff       	call   104700 <argstr>
  104e49:	85 c0                	test   %eax,%eax
  104e4b:	79 07                	jns    104e54 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  104e4d:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  104e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e53:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104e54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e62:	e8 59 f8 ff ff       	call   1046c0 <argint>
  104e67:	85 c0                	test   %eax,%eax
  104e69:	78 e2                	js     104e4d <sys_mknod+0x1d>
  104e6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e72:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104e79:	e8 42 f8 ff ff       	call   1046c0 <argint>
  104e7e:	85 c0                	test   %eax,%eax
  104e80:	78 cb                	js     104e4d <sys_mknod+0x1d>
  104e82:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  104e86:	b9 03 00 00 00       	mov    $0x3,%ecx
  104e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e92:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  104e96:	89 14 24             	mov    %edx,(%esp)
  104e99:	31 d2                	xor    %edx,%edx
  104e9b:	e8 a0 fd ff ff       	call   104c40 <create>
  104ea0:	85 c0                	test   %eax,%eax
  104ea2:	74 a9                	je     104e4d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104ea4:	89 04 24             	mov    %eax,(%esp)
  104ea7:	e8 b4 cc ff ff       	call   101b60 <iunlockput>
  104eac:	31 c0                	xor    %eax,%eax
  return 0;
}
  104eae:	c9                   	leave  
  104eaf:	90                   	nop    
  104eb0:	c3                   	ret    
  104eb1:	eb 0d                	jmp    104ec0 <sys_open>
  104eb3:	90                   	nop    
  104eb4:	90                   	nop    
  104eb5:	90                   	nop    
  104eb6:	90                   	nop    
  104eb7:	90                   	nop    
  104eb8:	90                   	nop    
  104eb9:	90                   	nop    
  104eba:	90                   	nop    
  104ebb:	90                   	nop    
  104ebc:	90                   	nop    
  104ebd:	90                   	nop    
  104ebe:	90                   	nop    
  104ebf:	90                   	nop    

00104ec0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104ec0:	55                   	push   %ebp
  104ec1:	89 e5                	mov    %esp,%ebp
  104ec3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104ec6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104ec9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104ecc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104ecf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ed6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104edd:	e8 1e f8 ff ff       	call   104700 <argstr>
  104ee2:	85 c0                	test   %eax,%eax
  104ee4:	79 14                	jns    104efa <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  104ee6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  104eeb:	89 d8                	mov    %ebx,%eax
  104eed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104ef0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ef3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104ef6:	89 ec                	mov    %ebp,%esp
  104ef8:	5d                   	pop    %ebp
  104ef9:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104efa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104efd:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f08:	e8 b3 f7 ff ff       	call   1046c0 <argint>
  104f0d:	85 c0                	test   %eax,%eax
  104f0f:	78 d5                	js     104ee6 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  104f11:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  104f15:	75 6c                	jne    104f83 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1a:	89 04 24             	mov    %eax,(%esp)
  104f1d:	e8 ee ce ff ff       	call   101e10 <namei>
  104f22:	85 c0                	test   %eax,%eax
  104f24:	89 c7                	mov    %eax,%edi
  104f26:	74 be                	je     104ee6 <sys_open+0x26>
      return -1;
    ilock(ip);
  104f28:	89 04 24             	mov    %eax,(%esp)
  104f2b:	e8 50 cc ff ff       	call   101b80 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  104f30:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  104f35:	0f 84 8e 00 00 00    	je     104fc9 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104f3b:	e8 90 bf ff ff       	call   100ed0 <filealloc>
  104f40:	85 c0                	test   %eax,%eax
  104f42:	89 c6                	mov    %eax,%esi
  104f44:	74 71                	je     104fb7 <sys_open+0xf7>
  104f46:	e8 f5 f8 ff ff       	call   104840 <fdalloc>
  104f4b:	85 c0                	test   %eax,%eax
  104f4d:	89 c3                	mov    %eax,%ebx
  104f4f:	78 5e                	js     104faf <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104f51:	89 3c 24             	mov    %edi,(%esp)
  104f54:	e8 b7 cb ff ff       	call   101b10 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  104f59:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  104f5c:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  104f62:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  104f65:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104f6c:	89 d0                	mov    %edx,%eax
  104f6e:	83 f0 01             	xor    $0x1,%eax
  104f71:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104f74:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  104f77:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104f7a:	0f 95 46 09          	setne  0x9(%esi)
  104f7e:	e9 68 ff ff ff       	jmp    104eeb <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  104f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f86:	b9 02 00 00 00       	mov    $0x2,%ecx
  104f8b:	ba 01 00 00 00       	mov    $0x1,%edx
  104f90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f97:	00 
  104f98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f9f:	e8 9c fc ff ff       	call   104c40 <create>
  104fa4:	85 c0                	test   %eax,%eax
  104fa6:	89 c7                	mov    %eax,%edi
  104fa8:	75 91                	jne    104f3b <sys_open+0x7b>
  104faa:	e9 37 ff ff ff       	jmp    104ee6 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104faf:	89 34 24             	mov    %esi,(%esp)
  104fb2:	e8 a9 bf ff ff       	call   100f60 <fileclose>
    iunlockput(ip);
  104fb7:	89 3c 24             	mov    %edi,(%esp)
  104fba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104fbf:	e8 9c cb ff ff       	call   101b60 <iunlockput>
  104fc4:	e9 22 ff ff ff       	jmp    104eeb <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  104fc9:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  104fcd:	0f 84 68 ff ff ff    	je     104f3b <sys_open+0x7b>
  104fd3:	eb e2                	jmp    104fb7 <sys_open+0xf7>
  104fd5:	8d 74 26 00          	lea    0x0(%esi),%esi
  104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104fe0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104fe0:	55                   	push   %ebp
  104fe1:	89 e5                	mov    %esp,%ebp
  104fe3:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104fe6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104fe9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104fec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104fef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ff6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ffd:	e8 fe f6 ff ff       	call   104700 <argstr>
  105002:	85 c0                	test   %eax,%eax
  105004:	79 12                	jns    105018 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  105006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10500b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10500e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105011:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105014:	89 ec                	mov    %ebp,%esp
  105016:	5d                   	pop    %ebp
  105017:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  105018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10501b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  10501e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105022:	89 04 24             	mov    %eax,(%esp)
  105025:	e8 c6 cd ff ff       	call   101df0 <nameiparent>
  10502a:	85 c0                	test   %eax,%eax
  10502c:	89 c7                	mov    %eax,%edi
  10502e:	74 d6                	je     105006 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  105030:	89 04 24             	mov    %eax,(%esp)
  105033:	e8 48 cb ff ff       	call   101b80 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  105038:	c7 44 24 04 f1 6a 10 	movl   $0x106af1,0x4(%esp)
  10503f:	00 
  105040:	89 1c 24             	mov    %ebx,(%esp)
  105043:	e8 e8 c5 ff ff       	call   101630 <namecmp>
  105048:	85 c0                	test   %eax,%eax
  10504a:	74 14                	je     105060 <sys_unlink+0x80>
  10504c:	c7 44 24 04 f0 6a 10 	movl   $0x106af0,0x4(%esp)
  105053:	00 
  105054:	89 1c 24             	mov    %ebx,(%esp)
  105057:	e8 d4 c5 ff ff       	call   101630 <namecmp>
  10505c:	85 c0                	test   %eax,%eax
  10505e:	75 0f                	jne    10506f <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  105060:	89 3c 24             	mov    %edi,(%esp)
  105063:	e8 f8 ca ff ff       	call   101b60 <iunlockput>
  105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10506d:	eb 9c                	jmp    10500b <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  10506f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105072:	89 44 24 08          	mov    %eax,0x8(%esp)
  105076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10507a:	89 3c 24             	mov    %edi,(%esp)
  10507d:	e8 de c5 ff ff       	call   101660 <dirlookup>
  105082:	85 c0                	test   %eax,%eax
  105084:	89 c6                	mov    %eax,%esi
  105086:	74 d8                	je     105060 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105088:	89 04 24             	mov    %eax,(%esp)
  10508b:	e8 f0 ca ff ff       	call   101b80 <ilock>

  if(ip->nlink < 1)
  105090:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105095:	0f 8e be 00 00 00    	jle    105159 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10509b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  1050a0:	75 4c                	jne    1050ee <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  1050a2:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  1050a6:	76 46                	jbe    1050ee <sys_unlink+0x10e>
  1050a8:	bb 20 00 00 00       	mov    $0x20,%ebx
  1050ad:	8d 76 00             	lea    0x0(%esi),%esi
  1050b0:	eb 08                	jmp    1050ba <sys_unlink+0xda>
  1050b2:	83 c3 10             	add    $0x10,%ebx
  1050b5:	39 5e 18             	cmp    %ebx,0x18(%esi)
  1050b8:	76 34                	jbe    1050ee <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1050ba:	8d 45 be             	lea    -0x42(%ebp),%eax
  1050bd:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1050c4:	00 
  1050c5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1050c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050cd:	89 34 24             	mov    %esi,(%esp)
  1050d0:	e8 4b c4 ff ff       	call   101520 <readi>
  1050d5:	83 f8 10             	cmp    $0x10,%eax
  1050d8:	75 73                	jne    10514d <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  1050da:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  1050df:	74 d1                	je     1050b2 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  1050e1:	89 34 24             	mov    %esi,(%esp)
  1050e4:	e8 77 ca ff ff       	call   101b60 <iunlockput>
  1050e9:	e9 72 ff ff ff       	jmp    105060 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  1050ee:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  1050f1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1050f8:	00 
  1050f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105100:	00 
  105101:	89 1c 24             	mov    %ebx,(%esp)
  105104:	e8 e7 f2 ff ff       	call   1043f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10510c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105113:	00 
  105114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105118:	89 3c 24             	mov    %edi,(%esp)
  10511b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10511f:	e8 cc c2 ff ff       	call   1013f0 <writei>
  105124:	83 f8 10             	cmp    $0x10,%eax
  105127:	75 3c                	jne    105165 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  105129:	89 3c 24             	mov    %edi,(%esp)
  10512c:	e8 2f ca ff ff       	call   101b60 <iunlockput>

  ip->nlink--;
  105131:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  105136:	89 34 24             	mov    %esi,(%esp)
  105139:	e8 72 c0 ff ff       	call   1011b0 <iupdate>
  iunlockput(ip);
  10513e:	89 34 24             	mov    %esi,(%esp)
  105141:	e8 1a ca ff ff       	call   101b60 <iunlockput>
  105146:	31 c0                	xor    %eax,%eax
  105148:	e9 be fe ff ff       	jmp    10500b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  10514d:	c7 04 24 11 6b 10 00 	movl   $0x106b11,(%esp)
  105154:	e8 47 b7 ff ff       	call   1008a0 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105159:	c7 04 24 ff 6a 10 00 	movl   $0x106aff,(%esp)
  105160:	e8 3b b7 ff ff       	call   1008a0 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  105165:	c7 04 24 23 6b 10 00 	movl   $0x106b23,(%esp)
  10516c:	e8 2f b7 ff ff       	call   1008a0 <panic>
  105171:	eb 0d                	jmp    105180 <sys_fstat>
  105173:	90                   	nop    
  105174:	90                   	nop    
  105175:	90                   	nop    
  105176:	90                   	nop    
  105177:	90                   	nop    
  105178:	90                   	nop    
  105179:	90                   	nop    
  10517a:	90                   	nop    
  10517b:	90                   	nop    
  10517c:	90                   	nop    
  10517d:	90                   	nop    
  10517e:	90                   	nop    
  10517f:	90                   	nop    

00105180 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105180:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105181:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  105183:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105185:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105187:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10518a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10518d:	e8 8e f7 ff ff       	call   104920 <argfd>
  105192:	85 c0                	test   %eax,%eax
  105194:	79 07                	jns    10519d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  105196:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  105197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10519c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10519d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1051a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1051a7:	00 
  1051a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051b3:	e8 98 f5 ff ff       	call   104750 <argptr>
  1051b8:	85 c0                	test   %eax,%eax
  1051ba:	78 da                	js     105196 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  1051bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1051bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051c6:	89 04 24             	mov    %eax,(%esp)
  1051c9:	e8 62 bc ff ff       	call   100e30 <filestat>
}
  1051ce:	c9                   	leave  
  1051cf:	c3                   	ret    

001051d0 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1051d0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1051d1:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1051d3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1051d5:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1051d7:	53                   	push   %ebx
  1051d8:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1051db:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  1051de:	e8 3d f7 ff ff       	call   104920 <argfd>
  1051e3:	85 c0                	test   %eax,%eax
  1051e5:	79 0d                	jns    1051f4 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1051e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1051ec:	89 d8                	mov    %ebx,%eax
  1051ee:	83 c4 14             	add    $0x14,%esp
  1051f1:	5b                   	pop    %ebx
  1051f2:	5d                   	pop    %ebp
  1051f3:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1051f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1051f7:	e8 44 f6 ff ff       	call   104840 <fdalloc>
  1051fc:	85 c0                	test   %eax,%eax
  1051fe:	89 c3                	mov    %eax,%ebx
  105200:	78 e5                	js     1051e7 <sys_dup+0x17>
    return -1;
  filedup(f);
  105202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105205:	89 04 24             	mov    %eax,(%esp)
  105208:	e8 73 bc ff ff       	call   100e80 <filedup>
  10520d:	eb dd                	jmp    1051ec <sys_dup+0x1c>
  10520f:	90                   	nop    

00105210 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105210:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105211:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105213:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105215:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105217:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10521a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10521d:	e8 fe f6 ff ff       	call   104920 <argfd>
  105222:	85 c0                	test   %eax,%eax
  105224:	79 07                	jns    10522d <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  105226:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  105227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10522c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10522d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105230:	89 44 24 04          	mov    %eax,0x4(%esp)
  105234:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10523b:	e8 80 f4 ff ff       	call   1046c0 <argint>
  105240:	85 c0                	test   %eax,%eax
  105242:	78 e2                	js     105226 <sys_write+0x16>
  105244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105247:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10524e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105252:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105255:	89 44 24 04          	mov    %eax,0x4(%esp)
  105259:	e8 f2 f4 ff ff       	call   104750 <argptr>
  10525e:	85 c0                	test   %eax,%eax
  105260:	78 c4                	js     105226 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  105262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105265:	89 44 24 08          	mov    %eax,0x8(%esp)
  105269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10526c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105273:	89 04 24             	mov    %eax,(%esp)
  105276:	e8 75 ba ff ff       	call   100cf0 <filewrite>
}
  10527b:	c9                   	leave  
  10527c:	c3                   	ret    
  10527d:	8d 76 00             	lea    0x0(%esi),%esi

00105280 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105280:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105281:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  105283:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105285:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105287:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10528a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10528d:	e8 8e f6 ff ff       	call   104920 <argfd>
  105292:	85 c0                	test   %eax,%eax
  105294:	79 07                	jns    10529d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  105296:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  105297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10529c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10529d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1052a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052a4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1052ab:	e8 10 f4 ff ff       	call   1046c0 <argint>
  1052b0:	85 c0                	test   %eax,%eax
  1052b2:	78 e2                	js     105296 <sys_read+0x16>
  1052b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1052b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1052c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052c9:	e8 82 f4 ff ff       	call   104750 <argptr>
  1052ce:	85 c0                	test   %eax,%eax
  1052d0:	78 c4                	js     105296 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  1052d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1052d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052e3:	89 04 24             	mov    %eax,(%esp)
  1052e6:	e8 a5 ba ff ff       	call   100d90 <fileread>
}
  1052eb:	c9                   	leave  
  1052ec:	c3                   	ret    
  1052ed:	90                   	nop    
  1052ee:	90                   	nop    
  1052ef:	90                   	nop    

001052f0 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  1052f0:	55                   	push   %ebp
  1052f1:	a1 a0 ee 10 00       	mov    0x10eea0,%eax
  1052f6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1052f8:	5d                   	pop    %ebp
  1052f9:	c3                   	ret    
  1052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105300 <sys_xchng>:

uint
sys_xchng(void)
{
  105300:	55                   	push   %ebp
  105301:	89 e5                	mov    %esp,%ebp
  105303:	83 ec 18             	sub    $0x18,%esp
  volatile unsigned int *mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  105306:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105309:	89 44 24 04          	mov    %eax,0x4(%esp)
  10530d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105314:	e8 a7 f3 ff ff       	call   1046c0 <argint>
  105319:	85 c0                	test   %eax,%eax
  10531b:	78 2b                	js     105348 <sys_xchng+0x48>
    return -1;
  if(argint(1, &new) < 0)
  10531d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105320:	89 44 24 04          	mov    %eax,0x4(%esp)
  105324:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10532b:	e8 90 f3 ff ff       	call   1046c0 <argint>
  105330:	85 c0                	test   %eax,%eax
  105332:	78 14                	js     105348 <sys_xchng+0x48>
    return -1;
  return xchnge(mem, new);
  105334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105337:	89 44 24 04          	mov    %eax,0x4(%esp)
  10533b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10533e:	89 04 24             	mov    %eax,(%esp)
  105341:	e8 6a dd ff ff       	call   1030b0 <xchnge>
}
  105346:	c9                   	leave  
  105347:	c3                   	ret    
  105348:	c9                   	leave  
  unsigned int new; 
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  return xchnge(mem, new);
  105349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10534e:	c3                   	ret    
  10534f:	90                   	nop    

00105350 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105350:	55                   	push   %ebp
  105351:	89 e5                	mov    %esp,%ebp
  105353:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105356:	e8 d5 df ff ff       	call   103330 <curproc>
  10535b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10535e:	c9                   	leave  
  10535f:	c3                   	ret    

00105360 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105360:	55                   	push   %ebp
  105361:	89 e5                	mov    %esp,%ebp
  105363:	53                   	push   %ebx
  105364:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105367:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10536a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10536e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105375:	e8 46 f3 ff ff       	call   1046c0 <argint>
  10537a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10537f:	85 c0                	test   %eax,%eax
  105381:	78 5a                	js     1053dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105383:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
  10538a:	e8 01 f0 ff ff       	call   104390 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10538f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105392:	8b 1d a0 ee 10 00    	mov    0x10eea0,%ebx
  while(ticks - ticks0 < n){
  105398:	85 d2                	test   %edx,%edx
  10539a:	7f 24                	jg     1053c0 <sys_sleep+0x60>
  10539c:	eb 47                	jmp    1053e5 <sys_sleep+0x85>
  10539e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  1053a0:	c7 44 24 04 60 e6 10 	movl   $0x10e660,0x4(%esp)
  1053a7:	00 
  1053a8:	c7 04 24 a0 ee 10 00 	movl   $0x10eea0,(%esp)
  1053af:	e8 0c e2 ff ff       	call   1035c0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  1053b4:	a1 a0 ee 10 00       	mov    0x10eea0,%eax
  1053b9:	29 d8                	sub    %ebx,%eax
  1053bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1053be:	7d 25                	jge    1053e5 <sys_sleep+0x85>
    if(cp->killed){
  1053c0:	e8 6b df ff ff       	call   103330 <curproc>
  1053c5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1053c8:	85 c0                	test   %eax,%eax
  1053ca:	74 d4                	je     1053a0 <sys_sleep+0x40>
      release(&tickslock);
  1053cc:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
  1053d3:	e8 78 ef ff ff       	call   104350 <release>
  1053d8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  1053dd:	83 c4 24             	add    $0x24,%esp
  1053e0:	89 d0                	mov    %edx,%eax
  1053e2:	5b                   	pop    %ebx
  1053e3:	5d                   	pop    %ebp
  1053e4:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1053e5:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
  1053ec:	e8 5f ef ff ff       	call   104350 <release>
  return 0;
}
  1053f1:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1053f4:	31 d2                	xor    %edx,%edx
  return 0;
}
  1053f6:	5b                   	pop    %ebx
  1053f7:	89 d0                	mov    %edx,%eax
  1053f9:	5d                   	pop    %ebp
  1053fa:	c3                   	ret    
  1053fb:	90                   	nop    
  1053fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00105400 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105400:	55                   	push   %ebp
  105401:	89 e5                	mov    %esp,%ebp
  105403:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105406:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105409:	89 44 24 04          	mov    %eax,0x4(%esp)
  10540d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105414:	e8 a7 f2 ff ff       	call   1046c0 <argint>
  105419:	85 c0                	test   %eax,%eax
  10541b:	79 07                	jns    105424 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  10541d:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  10541e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105423:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105424:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105427:	89 04 24             	mov    %eax,(%esp)
  10542a:	e8 41 e8 ff ff       	call   103c70 <growproc>
  10542f:	85 c0                	test   %eax,%eax
  105431:	78 ea                	js     10541d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105433:	c9                   	leave  
  105434:	c3                   	ret    
  105435:	8d 74 26 00          	lea    0x0(%esi),%esi
  105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105440 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105440:	55                   	push   %ebp
  105441:	89 e5                	mov    %esp,%ebp
  105443:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105446:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105449:	89 44 24 04          	mov    %eax,0x4(%esp)
  10544d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105454:	e8 67 f2 ff ff       	call   1046c0 <argint>
  105459:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10545e:	85 c0                	test   %eax,%eax
  105460:	78 0d                	js     10546f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105465:	89 04 24             	mov    %eax,(%esp)
  105468:	e8 d3 dc ff ff       	call   103140 <kill>
  10546d:	89 c2                	mov    %eax,%edx
}
  10546f:	c9                   	leave  
  105470:	89 d0                	mov    %edx,%eax
  105472:	c3                   	ret    
  105473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105480 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105480:	55                   	push   %ebp
  105481:	89 e5                	mov    %esp,%ebp
  return wait();
}
  105483:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  105484:	e9 f7 e2 ff ff       	jmp    103780 <wait>
  105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105490 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  105490:	55                   	push   %ebp
  105491:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  105493:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  105494:	e9 f7 e1 ff ff       	jmp    103690 <wait_thread>
  105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001054a0 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  1054a0:	55                   	push   %ebp
  1054a1:	89 e5                	mov    %esp,%ebp
  1054a3:	83 ec 08             	sub    $0x8,%esp
  exit();
  1054a6:	e8 15 e0 ff ff       	call   1034c0 <exit>
}
  1054ab:	c9                   	leave  
  1054ac:	c3                   	ret    
  1054ad:	8d 76 00             	lea    0x0(%esi),%esi

001054b0 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  1054b0:	55                   	push   %ebp
  1054b1:	89 e5                	mov    %esp,%ebp
  1054b3:	53                   	push   %ebx
  1054b4:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  1054b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1054ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054c5:	e8 f6 f1 ff ff       	call   1046c0 <argint>
  1054ca:	85 c0                	test   %eax,%eax
  1054cc:	79 0d                	jns    1054db <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  1054ce:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  1054d3:	83 c4 24             	add    $0x24,%esp
  1054d6:	89 d0                	mov    %edx,%eax
  1054d8:	5b                   	pop    %ebx
  1054d9:	5d                   	pop    %ebp
  1054da:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  1054db:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1054de:	e8 4d de ff ff       	call   103330 <curproc>
  1054e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1054e7:	89 04 24             	mov    %eax,(%esp)
  1054ea:	e8 41 e8 ff ff       	call   103d30 <copyproc_tix>
  1054ef:	85 c0                	test   %eax,%eax
  1054f1:	89 c1                	mov    %eax,%ecx
  1054f3:	74 d9                	je     1054ce <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  1054f5:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1054f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  1054ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105502:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  105508:	eb c9                	jmp    1054d3 <sys_fork_tickets+0x23>
  10550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105510 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  105510:	55                   	push   %ebp
  105511:	89 e5                	mov    %esp,%ebp
  105513:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  105519:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10551c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10551f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105522:	89 44 24 04          	mov    %eax,0x4(%esp)
  105526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10552d:	e8 8e f1 ff ff       	call   1046c0 <argint>
  105532:	85 c0                	test   %eax,%eax
  105534:	79 12                	jns    105548 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10553b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10553e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105541:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105544:	89 ec                	mov    %ebp,%esp
  105546:	5d                   	pop    %ebp
  105547:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105548:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10554b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10554f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105556:	e8 65 f1 ff ff       	call   1046c0 <argint>
  10555b:	85 c0                	test   %eax,%eax
  10555d:	78 d7                	js     105536 <sys_fork_thread+0x26>
  10555f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  105562:	89 44 24 04          	mov    %eax,0x4(%esp)
  105566:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10556d:	e8 4e f1 ff ff       	call   1046c0 <argint>
  105572:	85 c0                	test   %eax,%eax
  105574:	78 c0                	js     105536 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105576:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105579:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10557c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10557f:	e8 ac dd ff ff       	call   103330 <curproc>
  105584:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105588:	89 74 24 08          	mov    %esi,0x8(%esp)
  10558c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105590:	89 04 24             	mov    %eax,(%esp)
  105593:	e8 d8 e8 ff ff       	call   103e70 <copyproc_threads>
  105598:	89 c2                	mov    %eax,%edx
  10559a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10559f:	85 d2                	test   %edx,%edx
  1055a1:	74 98                	je     10553b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  1055a3:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  1055a6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  1055ad:	eb 8c                	jmp    10553b <sys_fork_thread+0x2b>
  1055af:	90                   	nop    

001055b0 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  1055b0:	55                   	push   %ebp
  1055b1:	89 e5                	mov    %esp,%ebp
  1055b3:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  1055b6:	e8 75 dd ff ff       	call   103330 <curproc>
  1055bb:	89 04 24             	mov    %eax,(%esp)
  1055be:	e8 bd e9 ff ff       	call   103f80 <copyproc>
  1055c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1055c8:	85 c0                	test   %eax,%eax
  1055ca:	74 0a                	je     1055d6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1055cc:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1055cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1055d6:	c9                   	leave  
  1055d7:	89 d0                	mov    %edx,%eax
  1055d9:	c3                   	ret    
  1055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001055e0 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  1055e0:	55                   	push   %ebp
  1055e1:	89 e5                	mov    %esp,%ebp
  1055e3:	53                   	push   %ebx
  int c;
  pushcli();
  if(argint(0, &c) < 0)
  1055e4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  1055e9:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  1055ec:	e8 cf ec ff ff       	call   1042c0 <pushcli>
  if(argint(0, &c) < 0)
  1055f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1055f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055ff:	e8 bc f0 ff ff       	call   1046c0 <argint>
  105604:	85 c0                	test   %eax,%eax
  105606:	78 12                	js     10561a <sys_wake_cond+0x3a>
    return -1;

  int pid = wakecond(c);
  105608:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10560b:	89 04 24             	mov    %eax,(%esp)
  10560e:	e8 ad da ff ff       	call   1030c0 <wakecond>
  105613:	89 c3                	mov    %eax,%ebx
  popcli();
  105615:	e8 26 ec ff ff       	call   104240 <popcli>
  return pid;
}
  10561a:	89 d8                	mov    %ebx,%eax
  10561c:	83 c4 24             	add    $0x24,%esp
  10561f:	5b                   	pop    %ebx
  105620:	5d                   	pop    %ebp
  105621:	c3                   	ret    
  105622:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105630 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  105630:	55                   	push   %ebp
  105631:	89 e5                	mov    %esp,%ebp
  105633:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  105636:	e8 85 ec ff ff       	call   1042c0 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  10563b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  10563e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105649:	e8 72 f0 ff ff       	call   1046c0 <argint>
  10564e:	85 c0                	test   %eax,%eax
  105650:	79 07                	jns    105659 <sys_sleep_cond+0x29>
     return -1;
  struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  105652:	c9                   	leave  
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
     return -1;
  struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
  105653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105658:	c3                   	ret    
int
sys_sleep_cond(void) {
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  105659:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10565c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105660:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105667:	e8 54 f0 ff ff       	call   1046c0 <argint>
  10566c:	85 c0                	test   %eax,%eax
  10566e:	78 e2                	js     105652 <sys_sleep_cond+0x22>
     return -1;
  struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  105670:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105673:	89 44 24 04          	mov    %eax,0x4(%esp)
  105677:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10567a:	89 04 24             	mov    %eax,(%esp)
  10567d:	e8 ae dd ff ff       	call   103430 <sleepcond>
  105682:	31 c0                	xor    %eax,%eax
  return 0;
}
  105684:	c9                   	leave  
  105685:	c3                   	ret    
  105686:	90                   	nop    
  105687:	90                   	nop    
  105688:	90                   	nop    
  105689:	90                   	nop    
  10568a:	90                   	nop    
  10568b:	90                   	nop    
  10568c:	90                   	nop    
  10568d:	90                   	nop    
  10568e:	90                   	nop    
  10568f:	90                   	nop    

00105690 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105690:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105691:	b8 34 00 00 00       	mov    $0x34,%eax
  105696:	89 e5                	mov    %esp,%ebp
  105698:	ba 43 00 00 00       	mov    $0x43,%edx
  10569d:	83 ec 08             	sub    $0x8,%esp
  1056a0:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  1056a1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  1056a6:	b2 40                	mov    $0x40,%dl
  1056a8:	ee                   	out    %al,(%dx)
  1056a9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  1056ae:	ee                   	out    %al,(%dx)
  1056af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056b6:	e8 65 d5 ff ff       	call   102c20 <pic_enable>
}
  1056bb:	c9                   	leave  
  1056bc:	c3                   	ret    
  1056bd:	90                   	nop    
  1056be:	90                   	nop    
  1056bf:	90                   	nop    

001056c0 <alltraps>:
  1056c0:	1e                   	push   %ds
  1056c1:	06                   	push   %es
  1056c2:	60                   	pusha  
  1056c3:	b8 10 00 00 00       	mov    $0x10,%eax
  1056c8:	8e d8                	mov    %eax,%ds
  1056ca:	8e c0                	mov    %eax,%es
  1056cc:	54                   	push   %esp
  1056cd:	e8 4e 00 00 00       	call   105720 <trap>
  1056d2:	83 c4 04             	add    $0x4,%esp

001056d5 <trapret>:
  1056d5:	61                   	popa   
  1056d6:	07                   	pop    %es
  1056d7:	1f                   	pop    %ds
  1056d8:	83 c4 08             	add    $0x8,%esp
  1056db:	cf                   	iret   

001056dc <forkret1>:
  1056dc:	8b 64 24 04          	mov    0x4(%esp),%esp
  1056e0:	e9 f0 ff ff ff       	jmp    1056d5 <trapret>
  1056e5:	90                   	nop    
  1056e6:	90                   	nop    
  1056e7:	90                   	nop    
  1056e8:	90                   	nop    
  1056e9:	90                   	nop    
  1056ea:	90                   	nop    
  1056eb:	90                   	nop    
  1056ec:	90                   	nop    
  1056ed:	90                   	nop    
  1056ee:	90                   	nop    
  1056ef:	90                   	nop    

001056f0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1056f0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1056f1:	b8 a0 e6 10 00       	mov    $0x10e6a0,%eax
  1056f6:	89 e5                	mov    %esp,%ebp
  1056f8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1056fb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105701:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105705:	c1 e8 10             	shr    $0x10,%eax
  105708:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10570c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10570f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105712:	c9                   	leave  
  105713:	c3                   	ret    
  105714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10571a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105720 <trap>:

void
trap(struct trapframe *tf)
{
  105720:	55                   	push   %ebp
  105721:	89 e5                	mov    %esp,%ebp
  105723:	83 ec 38             	sub    $0x38,%esp
  105726:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105729:	8b 7d 08             	mov    0x8(%ebp),%edi
  10572c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10572f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  105732:	8b 47 28             	mov    0x28(%edi),%eax
  105735:	83 f8 30             	cmp    $0x30,%eax
  105738:	0f 84 52 01 00 00    	je     105890 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10573e:	83 f8 21             	cmp    $0x21,%eax
  105741:	0f 84 39 01 00 00    	je     105880 <trap+0x160>
  105747:	0f 86 8b 00 00 00    	jbe    1057d8 <trap+0xb8>
  10574d:	83 f8 2e             	cmp    $0x2e,%eax
  105750:	0f 84 e1 00 00 00    	je     105837 <trap+0x117>
  105756:	83 f8 3f             	cmp    $0x3f,%eax
  105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105760:	75 7b                	jne    1057dd <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105762:	8b 5f 30             	mov    0x30(%edi),%ebx
  105765:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  105769:	e8 12 cf ff ff       	call   102680 <cpu>
  10576e:	c7 04 24 34 6b 10 00 	movl   $0x106b34,(%esp)
  105775:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105779:	89 74 24 08          	mov    %esi,0x8(%esp)
  10577d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105781:	e8 7a af ff ff       	call   100700 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105786:	e8 75 ce ff ff       	call   102600 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  10578b:	e8 a0 db ff ff       	call   103330 <curproc>
  105790:	85 c0                	test   %eax,%eax
  105792:	74 1e                	je     1057b2 <trap+0x92>
  105794:	e8 97 db ff ff       	call   103330 <curproc>
  105799:	8b 40 1c             	mov    0x1c(%eax),%eax
  10579c:	85 c0                	test   %eax,%eax
  10579e:	66 90                	xchg   %ax,%ax
  1057a0:	74 10                	je     1057b2 <trap+0x92>
  1057a2:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  1057a6:	83 e0 03             	and    $0x3,%eax
  1057a9:	83 f8 03             	cmp    $0x3,%eax
  1057ac:	0f 84 98 01 00 00    	je     10594a <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  1057b2:	e8 79 db ff ff       	call   103330 <curproc>
  1057b7:	85 c0                	test   %eax,%eax
  1057b9:	74 10                	je     1057cb <trap+0xab>
  1057bb:	90                   	nop    
  1057bc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1057c0:	e8 6b db ff ff       	call   103330 <curproc>
  1057c5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1057c9:	74 55                	je     105820 <trap+0x100>
    yield();
}
  1057cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1057ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1057d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1057d4:	89 ec                	mov    %ebp,%esp
  1057d6:	5d                   	pop    %ebp
  1057d7:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1057d8:	83 f8 20             	cmp    $0x20,%eax
  1057db:	74 64                	je     105841 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  1057dd:	e8 4e db ff ff       	call   103330 <curproc>
  1057e2:	85 c0                	test   %eax,%eax
  1057e4:	74 0a                	je     1057f0 <trap+0xd0>
  1057e6:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  1057ea:	0f 85 e1 00 00 00    	jne    1058d1 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  1057f0:	8b 5f 30             	mov    0x30(%edi),%ebx
  1057f3:	e8 88 ce ff ff       	call   102680 <cpu>
  1057f8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105800:	8b 47 28             	mov    0x28(%edi),%eax
  105803:	c7 04 24 58 6b 10 00 	movl   $0x106b58,(%esp)
  10580a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10580e:	e8 ed ae ff ff       	call   100700 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105813:	c7 04 24 bc 6b 10 00 	movl   $0x106bbc,(%esp)
  10581a:	e8 81 b0 ff ff       	call   1008a0 <panic>
  10581f:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105820:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  105824:	75 a5                	jne    1057cb <trap+0xab>
    yield();
}
  105826:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105829:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10582c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10582f:	89 ec                	mov    %ebp,%esp
  105831:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105832:	e9 59 e0 ff ff       	jmp    103890 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105837:	e8 b4 c7 ff ff       	call   101ff0 <ide_intr>
  10583c:	e9 45 ff ff ff       	jmp    105786 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105841:	e8 3a ce ff ff       	call   102680 <cpu>
  105846:	85 c0                	test   %eax,%eax
  105848:	0f 85 38 ff ff ff    	jne    105786 <trap+0x66>
      acquire(&tickslock);
  10584e:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
  105855:	e8 36 eb ff ff       	call   104390 <acquire>
      ticks++;
  10585a:	83 05 a0 ee 10 00 01 	addl   $0x1,0x10eea0
      wakeup(&ticks);
  105861:	c7 04 24 a0 ee 10 00 	movl   $0x10eea0,(%esp)
  105868:	e8 53 d9 ff ff       	call   1031c0 <wakeup>
      release(&tickslock);
  10586d:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
  105874:	e8 d7 ea ff ff       	call   104350 <release>
  105879:	e9 08 ff ff ff       	jmp    105786 <trap+0x66>
  10587e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105880:	e8 7b cb ff ff       	call   102400 <kbd_intr>
    lapic_eoi();
  105885:	e8 76 cd ff ff       	call   102600 <lapic_eoi>
  10588a:	e9 fc fe ff ff       	jmp    10578b <trap+0x6b>
  10588f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105890:	e8 9b da ff ff       	call   103330 <curproc>
  105895:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105898:	85 c9                	test   %ecx,%ecx
  10589a:	0f 85 9b 00 00 00    	jne    10593b <trap+0x21b>
      exit();
    cp->tf = tf;
  1058a0:	e8 8b da ff ff       	call   103330 <curproc>
  1058a5:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  1058ab:	e8 00 ef ff ff       	call   1047b0 <syscall>
    if(cp->killed)
  1058b0:	e8 7b da ff ff       	call   103330 <curproc>
  1058b5:	8b 50 1c             	mov    0x1c(%eax),%edx
  1058b8:	85 d2                	test   %edx,%edx
  1058ba:	0f 84 0b ff ff ff    	je     1057cb <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  1058c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1058c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1058c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1058c9:	89 ec                	mov    %ebp,%esp
  1058cb:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  1058cc:	e9 ef db ff ff       	jmp    1034c0 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1058d1:	8b 47 30             	mov    0x30(%edi),%eax
  1058d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058d7:	e8 a4 cd ff ff       	call   102680 <cpu>
  1058dc:	8b 57 28             	mov    0x28(%edi),%edx
  1058df:	8b 77 2c             	mov    0x2c(%edi),%esi
  1058e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1058e5:	89 c3                	mov    %eax,%ebx
  1058e7:	e8 44 da ff ff       	call   103330 <curproc>
  1058ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058ef:	e8 3c da ff ff       	call   103330 <curproc>
  1058f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1058f7:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  1058fb:	89 74 24 10          	mov    %esi,0x10(%esp)
  1058ff:	89 54 24 18          	mov    %edx,0x18(%esp)
  105903:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105906:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10590a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10590d:	81 c2 88 00 00 00    	add    $0x88,%edx
  105913:	89 54 24 08          	mov    %edx,0x8(%esp)
  105917:	8b 40 10             	mov    0x10(%eax),%eax
  10591a:	c7 04 24 80 6b 10 00 	movl   $0x106b80,(%esp)
  105921:	89 44 24 04          	mov    %eax,0x4(%esp)
  105925:	e8 d6 ad ff ff       	call   100700 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  10592a:	e8 01 da ff ff       	call   103330 <curproc>
  10592f:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105936:	e9 50 fe ff ff       	jmp    10578b <trap+0x6b>
  10593b:	90                   	nop    
  10593c:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105940:	e8 7b db ff ff       	call   1034c0 <exit>
  105945:	e9 56 ff ff ff       	jmp    1058a0 <trap+0x180>
  10594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105950:	e8 6b db ff ff       	call   1034c0 <exit>
  105955:	e9 58 fe ff ff       	jmp    1057b2 <trap+0x92>
  10595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105960 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105960:	55                   	push   %ebp
  105961:	31 d2                	xor    %edx,%edx
  105963:	89 e5                	mov    %esp,%ebp
  105965:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105968:	8b 04 95 e8 7e 10 00 	mov    0x107ee8(,%edx,4),%eax
  10596f:	66 c7 04 d5 a2 e6 10 	movw   $0x8,0x10e6a2(,%edx,8)
  105976:	00 08 00 
  105979:	c6 04 d5 a4 e6 10 00 	movb   $0x0,0x10e6a4(,%edx,8)
  105980:	00 
  105981:	c6 04 d5 a5 e6 10 00 	movb   $0x8e,0x10e6a5(,%edx,8)
  105988:	8e 
  105989:	66 89 04 d5 a0 e6 10 	mov    %ax,0x10e6a0(,%edx,8)
  105990:	00 
  105991:	c1 e8 10             	shr    $0x10,%eax
  105994:	66 89 04 d5 a6 e6 10 	mov    %ax,0x10e6a6(,%edx,8)
  10599b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  10599c:	83 c2 01             	add    $0x1,%edx
  10599f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  1059a5:	75 c1                	jne    105968 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1059a7:	a1 a8 7f 10 00       	mov    0x107fa8,%eax
  
  initlock(&tickslock, "time");
  1059ac:	c7 44 24 04 c1 6b 10 	movl   $0x106bc1,0x4(%esp)
  1059b3:	00 
  1059b4:	c7 04 24 60 e6 10 00 	movl   $0x10e660,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1059bb:	66 c7 05 22 e8 10 00 	movw   $0x8,0x10e822
  1059c2:	08 00 
  1059c4:	66 a3 20 e8 10 00    	mov    %ax,0x10e820
  1059ca:	c1 e8 10             	shr    $0x10,%eax
  1059cd:	c6 05 24 e8 10 00 00 	movb   $0x0,0x10e824
  1059d4:	c6 05 25 e8 10 00 ef 	movb   $0xef,0x10e825
  1059db:	66 a3 26 e8 10 00    	mov    %ax,0x10e826
  
  initlock(&tickslock, "time");
  1059e1:	e8 ea e7 ff ff       	call   1041d0 <initlock>
}
  1059e6:	c9                   	leave  
  1059e7:	c3                   	ret    

001059e8 <vector0>:
  1059e8:	6a 00                	push   $0x0
  1059ea:	6a 00                	push   $0x0
  1059ec:	e9 cf fc ff ff       	jmp    1056c0 <alltraps>

001059f1 <vector1>:
  1059f1:	6a 00                	push   $0x0
  1059f3:	6a 01                	push   $0x1
  1059f5:	e9 c6 fc ff ff       	jmp    1056c0 <alltraps>

001059fa <vector2>:
  1059fa:	6a 00                	push   $0x0
  1059fc:	6a 02                	push   $0x2
  1059fe:	e9 bd fc ff ff       	jmp    1056c0 <alltraps>

00105a03 <vector3>:
  105a03:	6a 00                	push   $0x0
  105a05:	6a 03                	push   $0x3
  105a07:	e9 b4 fc ff ff       	jmp    1056c0 <alltraps>

00105a0c <vector4>:
  105a0c:	6a 00                	push   $0x0
  105a0e:	6a 04                	push   $0x4
  105a10:	e9 ab fc ff ff       	jmp    1056c0 <alltraps>

00105a15 <vector5>:
  105a15:	6a 00                	push   $0x0
  105a17:	6a 05                	push   $0x5
  105a19:	e9 a2 fc ff ff       	jmp    1056c0 <alltraps>

00105a1e <vector6>:
  105a1e:	6a 00                	push   $0x0
  105a20:	6a 06                	push   $0x6
  105a22:	e9 99 fc ff ff       	jmp    1056c0 <alltraps>

00105a27 <vector7>:
  105a27:	6a 00                	push   $0x0
  105a29:	6a 07                	push   $0x7
  105a2b:	e9 90 fc ff ff       	jmp    1056c0 <alltraps>

00105a30 <vector8>:
  105a30:	6a 08                	push   $0x8
  105a32:	e9 89 fc ff ff       	jmp    1056c0 <alltraps>

00105a37 <vector9>:
  105a37:	6a 09                	push   $0x9
  105a39:	e9 82 fc ff ff       	jmp    1056c0 <alltraps>

00105a3e <vector10>:
  105a3e:	6a 0a                	push   $0xa
  105a40:	e9 7b fc ff ff       	jmp    1056c0 <alltraps>

00105a45 <vector11>:
  105a45:	6a 0b                	push   $0xb
  105a47:	e9 74 fc ff ff       	jmp    1056c0 <alltraps>

00105a4c <vector12>:
  105a4c:	6a 0c                	push   $0xc
  105a4e:	e9 6d fc ff ff       	jmp    1056c0 <alltraps>

00105a53 <vector13>:
  105a53:	6a 0d                	push   $0xd
  105a55:	e9 66 fc ff ff       	jmp    1056c0 <alltraps>

00105a5a <vector14>:
  105a5a:	6a 0e                	push   $0xe
  105a5c:	e9 5f fc ff ff       	jmp    1056c0 <alltraps>

00105a61 <vector15>:
  105a61:	6a 00                	push   $0x0
  105a63:	6a 0f                	push   $0xf
  105a65:	e9 56 fc ff ff       	jmp    1056c0 <alltraps>

00105a6a <vector16>:
  105a6a:	6a 00                	push   $0x0
  105a6c:	6a 10                	push   $0x10
  105a6e:	e9 4d fc ff ff       	jmp    1056c0 <alltraps>

00105a73 <vector17>:
  105a73:	6a 11                	push   $0x11
  105a75:	e9 46 fc ff ff       	jmp    1056c0 <alltraps>

00105a7a <vector18>:
  105a7a:	6a 00                	push   $0x0
  105a7c:	6a 12                	push   $0x12
  105a7e:	e9 3d fc ff ff       	jmp    1056c0 <alltraps>

00105a83 <vector19>:
  105a83:	6a 00                	push   $0x0
  105a85:	6a 13                	push   $0x13
  105a87:	e9 34 fc ff ff       	jmp    1056c0 <alltraps>

00105a8c <vector20>:
  105a8c:	6a 00                	push   $0x0
  105a8e:	6a 14                	push   $0x14
  105a90:	e9 2b fc ff ff       	jmp    1056c0 <alltraps>

00105a95 <vector21>:
  105a95:	6a 00                	push   $0x0
  105a97:	6a 15                	push   $0x15
  105a99:	e9 22 fc ff ff       	jmp    1056c0 <alltraps>

00105a9e <vector22>:
  105a9e:	6a 00                	push   $0x0
  105aa0:	6a 16                	push   $0x16
  105aa2:	e9 19 fc ff ff       	jmp    1056c0 <alltraps>

00105aa7 <vector23>:
  105aa7:	6a 00                	push   $0x0
  105aa9:	6a 17                	push   $0x17
  105aab:	e9 10 fc ff ff       	jmp    1056c0 <alltraps>

00105ab0 <vector24>:
  105ab0:	6a 00                	push   $0x0
  105ab2:	6a 18                	push   $0x18
  105ab4:	e9 07 fc ff ff       	jmp    1056c0 <alltraps>

00105ab9 <vector25>:
  105ab9:	6a 00                	push   $0x0
  105abb:	6a 19                	push   $0x19
  105abd:	e9 fe fb ff ff       	jmp    1056c0 <alltraps>

00105ac2 <vector26>:
  105ac2:	6a 00                	push   $0x0
  105ac4:	6a 1a                	push   $0x1a
  105ac6:	e9 f5 fb ff ff       	jmp    1056c0 <alltraps>

00105acb <vector27>:
  105acb:	6a 00                	push   $0x0
  105acd:	6a 1b                	push   $0x1b
  105acf:	e9 ec fb ff ff       	jmp    1056c0 <alltraps>

00105ad4 <vector28>:
  105ad4:	6a 00                	push   $0x0
  105ad6:	6a 1c                	push   $0x1c
  105ad8:	e9 e3 fb ff ff       	jmp    1056c0 <alltraps>

00105add <vector29>:
  105add:	6a 00                	push   $0x0
  105adf:	6a 1d                	push   $0x1d
  105ae1:	e9 da fb ff ff       	jmp    1056c0 <alltraps>

00105ae6 <vector30>:
  105ae6:	6a 00                	push   $0x0
  105ae8:	6a 1e                	push   $0x1e
  105aea:	e9 d1 fb ff ff       	jmp    1056c0 <alltraps>

00105aef <vector31>:
  105aef:	6a 00                	push   $0x0
  105af1:	6a 1f                	push   $0x1f
  105af3:	e9 c8 fb ff ff       	jmp    1056c0 <alltraps>

00105af8 <vector32>:
  105af8:	6a 00                	push   $0x0
  105afa:	6a 20                	push   $0x20
  105afc:	e9 bf fb ff ff       	jmp    1056c0 <alltraps>

00105b01 <vector33>:
  105b01:	6a 00                	push   $0x0
  105b03:	6a 21                	push   $0x21
  105b05:	e9 b6 fb ff ff       	jmp    1056c0 <alltraps>

00105b0a <vector34>:
  105b0a:	6a 00                	push   $0x0
  105b0c:	6a 22                	push   $0x22
  105b0e:	e9 ad fb ff ff       	jmp    1056c0 <alltraps>

00105b13 <vector35>:
  105b13:	6a 00                	push   $0x0
  105b15:	6a 23                	push   $0x23
  105b17:	e9 a4 fb ff ff       	jmp    1056c0 <alltraps>

00105b1c <vector36>:
  105b1c:	6a 00                	push   $0x0
  105b1e:	6a 24                	push   $0x24
  105b20:	e9 9b fb ff ff       	jmp    1056c0 <alltraps>

00105b25 <vector37>:
  105b25:	6a 00                	push   $0x0
  105b27:	6a 25                	push   $0x25
  105b29:	e9 92 fb ff ff       	jmp    1056c0 <alltraps>

00105b2e <vector38>:
  105b2e:	6a 00                	push   $0x0
  105b30:	6a 26                	push   $0x26
  105b32:	e9 89 fb ff ff       	jmp    1056c0 <alltraps>

00105b37 <vector39>:
  105b37:	6a 00                	push   $0x0
  105b39:	6a 27                	push   $0x27
  105b3b:	e9 80 fb ff ff       	jmp    1056c0 <alltraps>

00105b40 <vector40>:
  105b40:	6a 00                	push   $0x0
  105b42:	6a 28                	push   $0x28
  105b44:	e9 77 fb ff ff       	jmp    1056c0 <alltraps>

00105b49 <vector41>:
  105b49:	6a 00                	push   $0x0
  105b4b:	6a 29                	push   $0x29
  105b4d:	e9 6e fb ff ff       	jmp    1056c0 <alltraps>

00105b52 <vector42>:
  105b52:	6a 00                	push   $0x0
  105b54:	6a 2a                	push   $0x2a
  105b56:	e9 65 fb ff ff       	jmp    1056c0 <alltraps>

00105b5b <vector43>:
  105b5b:	6a 00                	push   $0x0
  105b5d:	6a 2b                	push   $0x2b
  105b5f:	e9 5c fb ff ff       	jmp    1056c0 <alltraps>

00105b64 <vector44>:
  105b64:	6a 00                	push   $0x0
  105b66:	6a 2c                	push   $0x2c
  105b68:	e9 53 fb ff ff       	jmp    1056c0 <alltraps>

00105b6d <vector45>:
  105b6d:	6a 00                	push   $0x0
  105b6f:	6a 2d                	push   $0x2d
  105b71:	e9 4a fb ff ff       	jmp    1056c0 <alltraps>

00105b76 <vector46>:
  105b76:	6a 00                	push   $0x0
  105b78:	6a 2e                	push   $0x2e
  105b7a:	e9 41 fb ff ff       	jmp    1056c0 <alltraps>

00105b7f <vector47>:
  105b7f:	6a 00                	push   $0x0
  105b81:	6a 2f                	push   $0x2f
  105b83:	e9 38 fb ff ff       	jmp    1056c0 <alltraps>

00105b88 <vector48>:
  105b88:	6a 00                	push   $0x0
  105b8a:	6a 30                	push   $0x30
  105b8c:	e9 2f fb ff ff       	jmp    1056c0 <alltraps>

00105b91 <vector49>:
  105b91:	6a 00                	push   $0x0
  105b93:	6a 31                	push   $0x31
  105b95:	e9 26 fb ff ff       	jmp    1056c0 <alltraps>

00105b9a <vector50>:
  105b9a:	6a 00                	push   $0x0
  105b9c:	6a 32                	push   $0x32
  105b9e:	e9 1d fb ff ff       	jmp    1056c0 <alltraps>

00105ba3 <vector51>:
  105ba3:	6a 00                	push   $0x0
  105ba5:	6a 33                	push   $0x33
  105ba7:	e9 14 fb ff ff       	jmp    1056c0 <alltraps>

00105bac <vector52>:
  105bac:	6a 00                	push   $0x0
  105bae:	6a 34                	push   $0x34
  105bb0:	e9 0b fb ff ff       	jmp    1056c0 <alltraps>

00105bb5 <vector53>:
  105bb5:	6a 00                	push   $0x0
  105bb7:	6a 35                	push   $0x35
  105bb9:	e9 02 fb ff ff       	jmp    1056c0 <alltraps>

00105bbe <vector54>:
  105bbe:	6a 00                	push   $0x0
  105bc0:	6a 36                	push   $0x36
  105bc2:	e9 f9 fa ff ff       	jmp    1056c0 <alltraps>

00105bc7 <vector55>:
  105bc7:	6a 00                	push   $0x0
  105bc9:	6a 37                	push   $0x37
  105bcb:	e9 f0 fa ff ff       	jmp    1056c0 <alltraps>

00105bd0 <vector56>:
  105bd0:	6a 00                	push   $0x0
  105bd2:	6a 38                	push   $0x38
  105bd4:	e9 e7 fa ff ff       	jmp    1056c0 <alltraps>

00105bd9 <vector57>:
  105bd9:	6a 00                	push   $0x0
  105bdb:	6a 39                	push   $0x39
  105bdd:	e9 de fa ff ff       	jmp    1056c0 <alltraps>

00105be2 <vector58>:
  105be2:	6a 00                	push   $0x0
  105be4:	6a 3a                	push   $0x3a
  105be6:	e9 d5 fa ff ff       	jmp    1056c0 <alltraps>

00105beb <vector59>:
  105beb:	6a 00                	push   $0x0
  105bed:	6a 3b                	push   $0x3b
  105bef:	e9 cc fa ff ff       	jmp    1056c0 <alltraps>

00105bf4 <vector60>:
  105bf4:	6a 00                	push   $0x0
  105bf6:	6a 3c                	push   $0x3c
  105bf8:	e9 c3 fa ff ff       	jmp    1056c0 <alltraps>

00105bfd <vector61>:
  105bfd:	6a 00                	push   $0x0
  105bff:	6a 3d                	push   $0x3d
  105c01:	e9 ba fa ff ff       	jmp    1056c0 <alltraps>

00105c06 <vector62>:
  105c06:	6a 00                	push   $0x0
  105c08:	6a 3e                	push   $0x3e
  105c0a:	e9 b1 fa ff ff       	jmp    1056c0 <alltraps>

00105c0f <vector63>:
  105c0f:	6a 00                	push   $0x0
  105c11:	6a 3f                	push   $0x3f
  105c13:	e9 a8 fa ff ff       	jmp    1056c0 <alltraps>

00105c18 <vector64>:
  105c18:	6a 00                	push   $0x0
  105c1a:	6a 40                	push   $0x40
  105c1c:	e9 9f fa ff ff       	jmp    1056c0 <alltraps>

00105c21 <vector65>:
  105c21:	6a 00                	push   $0x0
  105c23:	6a 41                	push   $0x41
  105c25:	e9 96 fa ff ff       	jmp    1056c0 <alltraps>

00105c2a <vector66>:
  105c2a:	6a 00                	push   $0x0
  105c2c:	6a 42                	push   $0x42
  105c2e:	e9 8d fa ff ff       	jmp    1056c0 <alltraps>

00105c33 <vector67>:
  105c33:	6a 00                	push   $0x0
  105c35:	6a 43                	push   $0x43
  105c37:	e9 84 fa ff ff       	jmp    1056c0 <alltraps>

00105c3c <vector68>:
  105c3c:	6a 00                	push   $0x0
  105c3e:	6a 44                	push   $0x44
  105c40:	e9 7b fa ff ff       	jmp    1056c0 <alltraps>

00105c45 <vector69>:
  105c45:	6a 00                	push   $0x0
  105c47:	6a 45                	push   $0x45
  105c49:	e9 72 fa ff ff       	jmp    1056c0 <alltraps>

00105c4e <vector70>:
  105c4e:	6a 00                	push   $0x0
  105c50:	6a 46                	push   $0x46
  105c52:	e9 69 fa ff ff       	jmp    1056c0 <alltraps>

00105c57 <vector71>:
  105c57:	6a 00                	push   $0x0
  105c59:	6a 47                	push   $0x47
  105c5b:	e9 60 fa ff ff       	jmp    1056c0 <alltraps>

00105c60 <vector72>:
  105c60:	6a 00                	push   $0x0
  105c62:	6a 48                	push   $0x48
  105c64:	e9 57 fa ff ff       	jmp    1056c0 <alltraps>

00105c69 <vector73>:
  105c69:	6a 00                	push   $0x0
  105c6b:	6a 49                	push   $0x49
  105c6d:	e9 4e fa ff ff       	jmp    1056c0 <alltraps>

00105c72 <vector74>:
  105c72:	6a 00                	push   $0x0
  105c74:	6a 4a                	push   $0x4a
  105c76:	e9 45 fa ff ff       	jmp    1056c0 <alltraps>

00105c7b <vector75>:
  105c7b:	6a 00                	push   $0x0
  105c7d:	6a 4b                	push   $0x4b
  105c7f:	e9 3c fa ff ff       	jmp    1056c0 <alltraps>

00105c84 <vector76>:
  105c84:	6a 00                	push   $0x0
  105c86:	6a 4c                	push   $0x4c
  105c88:	e9 33 fa ff ff       	jmp    1056c0 <alltraps>

00105c8d <vector77>:
  105c8d:	6a 00                	push   $0x0
  105c8f:	6a 4d                	push   $0x4d
  105c91:	e9 2a fa ff ff       	jmp    1056c0 <alltraps>

00105c96 <vector78>:
  105c96:	6a 00                	push   $0x0
  105c98:	6a 4e                	push   $0x4e
  105c9a:	e9 21 fa ff ff       	jmp    1056c0 <alltraps>

00105c9f <vector79>:
  105c9f:	6a 00                	push   $0x0
  105ca1:	6a 4f                	push   $0x4f
  105ca3:	e9 18 fa ff ff       	jmp    1056c0 <alltraps>

00105ca8 <vector80>:
  105ca8:	6a 00                	push   $0x0
  105caa:	6a 50                	push   $0x50
  105cac:	e9 0f fa ff ff       	jmp    1056c0 <alltraps>

00105cb1 <vector81>:
  105cb1:	6a 00                	push   $0x0
  105cb3:	6a 51                	push   $0x51
  105cb5:	e9 06 fa ff ff       	jmp    1056c0 <alltraps>

00105cba <vector82>:
  105cba:	6a 00                	push   $0x0
  105cbc:	6a 52                	push   $0x52
  105cbe:	e9 fd f9 ff ff       	jmp    1056c0 <alltraps>

00105cc3 <vector83>:
  105cc3:	6a 00                	push   $0x0
  105cc5:	6a 53                	push   $0x53
  105cc7:	e9 f4 f9 ff ff       	jmp    1056c0 <alltraps>

00105ccc <vector84>:
  105ccc:	6a 00                	push   $0x0
  105cce:	6a 54                	push   $0x54
  105cd0:	e9 eb f9 ff ff       	jmp    1056c0 <alltraps>

00105cd5 <vector85>:
  105cd5:	6a 00                	push   $0x0
  105cd7:	6a 55                	push   $0x55
  105cd9:	e9 e2 f9 ff ff       	jmp    1056c0 <alltraps>

00105cde <vector86>:
  105cde:	6a 00                	push   $0x0
  105ce0:	6a 56                	push   $0x56
  105ce2:	e9 d9 f9 ff ff       	jmp    1056c0 <alltraps>

00105ce7 <vector87>:
  105ce7:	6a 00                	push   $0x0
  105ce9:	6a 57                	push   $0x57
  105ceb:	e9 d0 f9 ff ff       	jmp    1056c0 <alltraps>

00105cf0 <vector88>:
  105cf0:	6a 00                	push   $0x0
  105cf2:	6a 58                	push   $0x58
  105cf4:	e9 c7 f9 ff ff       	jmp    1056c0 <alltraps>

00105cf9 <vector89>:
  105cf9:	6a 00                	push   $0x0
  105cfb:	6a 59                	push   $0x59
  105cfd:	e9 be f9 ff ff       	jmp    1056c0 <alltraps>

00105d02 <vector90>:
  105d02:	6a 00                	push   $0x0
  105d04:	6a 5a                	push   $0x5a
  105d06:	e9 b5 f9 ff ff       	jmp    1056c0 <alltraps>

00105d0b <vector91>:
  105d0b:	6a 00                	push   $0x0
  105d0d:	6a 5b                	push   $0x5b
  105d0f:	e9 ac f9 ff ff       	jmp    1056c0 <alltraps>

00105d14 <vector92>:
  105d14:	6a 00                	push   $0x0
  105d16:	6a 5c                	push   $0x5c
  105d18:	e9 a3 f9 ff ff       	jmp    1056c0 <alltraps>

00105d1d <vector93>:
  105d1d:	6a 00                	push   $0x0
  105d1f:	6a 5d                	push   $0x5d
  105d21:	e9 9a f9 ff ff       	jmp    1056c0 <alltraps>

00105d26 <vector94>:
  105d26:	6a 00                	push   $0x0
  105d28:	6a 5e                	push   $0x5e
  105d2a:	e9 91 f9 ff ff       	jmp    1056c0 <alltraps>

00105d2f <vector95>:
  105d2f:	6a 00                	push   $0x0
  105d31:	6a 5f                	push   $0x5f
  105d33:	e9 88 f9 ff ff       	jmp    1056c0 <alltraps>

00105d38 <vector96>:
  105d38:	6a 00                	push   $0x0
  105d3a:	6a 60                	push   $0x60
  105d3c:	e9 7f f9 ff ff       	jmp    1056c0 <alltraps>

00105d41 <vector97>:
  105d41:	6a 00                	push   $0x0
  105d43:	6a 61                	push   $0x61
  105d45:	e9 76 f9 ff ff       	jmp    1056c0 <alltraps>

00105d4a <vector98>:
  105d4a:	6a 00                	push   $0x0
  105d4c:	6a 62                	push   $0x62
  105d4e:	e9 6d f9 ff ff       	jmp    1056c0 <alltraps>

00105d53 <vector99>:
  105d53:	6a 00                	push   $0x0
  105d55:	6a 63                	push   $0x63
  105d57:	e9 64 f9 ff ff       	jmp    1056c0 <alltraps>

00105d5c <vector100>:
  105d5c:	6a 00                	push   $0x0
  105d5e:	6a 64                	push   $0x64
  105d60:	e9 5b f9 ff ff       	jmp    1056c0 <alltraps>

00105d65 <vector101>:
  105d65:	6a 00                	push   $0x0
  105d67:	6a 65                	push   $0x65
  105d69:	e9 52 f9 ff ff       	jmp    1056c0 <alltraps>

00105d6e <vector102>:
  105d6e:	6a 00                	push   $0x0
  105d70:	6a 66                	push   $0x66
  105d72:	e9 49 f9 ff ff       	jmp    1056c0 <alltraps>

00105d77 <vector103>:
  105d77:	6a 00                	push   $0x0
  105d79:	6a 67                	push   $0x67
  105d7b:	e9 40 f9 ff ff       	jmp    1056c0 <alltraps>

00105d80 <vector104>:
  105d80:	6a 00                	push   $0x0
  105d82:	6a 68                	push   $0x68
  105d84:	e9 37 f9 ff ff       	jmp    1056c0 <alltraps>

00105d89 <vector105>:
  105d89:	6a 00                	push   $0x0
  105d8b:	6a 69                	push   $0x69
  105d8d:	e9 2e f9 ff ff       	jmp    1056c0 <alltraps>

00105d92 <vector106>:
  105d92:	6a 00                	push   $0x0
  105d94:	6a 6a                	push   $0x6a
  105d96:	e9 25 f9 ff ff       	jmp    1056c0 <alltraps>

00105d9b <vector107>:
  105d9b:	6a 00                	push   $0x0
  105d9d:	6a 6b                	push   $0x6b
  105d9f:	e9 1c f9 ff ff       	jmp    1056c0 <alltraps>

00105da4 <vector108>:
  105da4:	6a 00                	push   $0x0
  105da6:	6a 6c                	push   $0x6c
  105da8:	e9 13 f9 ff ff       	jmp    1056c0 <alltraps>

00105dad <vector109>:
  105dad:	6a 00                	push   $0x0
  105daf:	6a 6d                	push   $0x6d
  105db1:	e9 0a f9 ff ff       	jmp    1056c0 <alltraps>

00105db6 <vector110>:
  105db6:	6a 00                	push   $0x0
  105db8:	6a 6e                	push   $0x6e
  105dba:	e9 01 f9 ff ff       	jmp    1056c0 <alltraps>

00105dbf <vector111>:
  105dbf:	6a 00                	push   $0x0
  105dc1:	6a 6f                	push   $0x6f
  105dc3:	e9 f8 f8 ff ff       	jmp    1056c0 <alltraps>

00105dc8 <vector112>:
  105dc8:	6a 00                	push   $0x0
  105dca:	6a 70                	push   $0x70
  105dcc:	e9 ef f8 ff ff       	jmp    1056c0 <alltraps>

00105dd1 <vector113>:
  105dd1:	6a 00                	push   $0x0
  105dd3:	6a 71                	push   $0x71
  105dd5:	e9 e6 f8 ff ff       	jmp    1056c0 <alltraps>

00105dda <vector114>:
  105dda:	6a 00                	push   $0x0
  105ddc:	6a 72                	push   $0x72
  105dde:	e9 dd f8 ff ff       	jmp    1056c0 <alltraps>

00105de3 <vector115>:
  105de3:	6a 00                	push   $0x0
  105de5:	6a 73                	push   $0x73
  105de7:	e9 d4 f8 ff ff       	jmp    1056c0 <alltraps>

00105dec <vector116>:
  105dec:	6a 00                	push   $0x0
  105dee:	6a 74                	push   $0x74
  105df0:	e9 cb f8 ff ff       	jmp    1056c0 <alltraps>

00105df5 <vector117>:
  105df5:	6a 00                	push   $0x0
  105df7:	6a 75                	push   $0x75
  105df9:	e9 c2 f8 ff ff       	jmp    1056c0 <alltraps>

00105dfe <vector118>:
  105dfe:	6a 00                	push   $0x0
  105e00:	6a 76                	push   $0x76
  105e02:	e9 b9 f8 ff ff       	jmp    1056c0 <alltraps>

00105e07 <vector119>:
  105e07:	6a 00                	push   $0x0
  105e09:	6a 77                	push   $0x77
  105e0b:	e9 b0 f8 ff ff       	jmp    1056c0 <alltraps>

00105e10 <vector120>:
  105e10:	6a 00                	push   $0x0
  105e12:	6a 78                	push   $0x78
  105e14:	e9 a7 f8 ff ff       	jmp    1056c0 <alltraps>

00105e19 <vector121>:
  105e19:	6a 00                	push   $0x0
  105e1b:	6a 79                	push   $0x79
  105e1d:	e9 9e f8 ff ff       	jmp    1056c0 <alltraps>

00105e22 <vector122>:
  105e22:	6a 00                	push   $0x0
  105e24:	6a 7a                	push   $0x7a
  105e26:	e9 95 f8 ff ff       	jmp    1056c0 <alltraps>

00105e2b <vector123>:
  105e2b:	6a 00                	push   $0x0
  105e2d:	6a 7b                	push   $0x7b
  105e2f:	e9 8c f8 ff ff       	jmp    1056c0 <alltraps>

00105e34 <vector124>:
  105e34:	6a 00                	push   $0x0
  105e36:	6a 7c                	push   $0x7c
  105e38:	e9 83 f8 ff ff       	jmp    1056c0 <alltraps>

00105e3d <vector125>:
  105e3d:	6a 00                	push   $0x0
  105e3f:	6a 7d                	push   $0x7d
  105e41:	e9 7a f8 ff ff       	jmp    1056c0 <alltraps>

00105e46 <vector126>:
  105e46:	6a 00                	push   $0x0
  105e48:	6a 7e                	push   $0x7e
  105e4a:	e9 71 f8 ff ff       	jmp    1056c0 <alltraps>

00105e4f <vector127>:
  105e4f:	6a 00                	push   $0x0
  105e51:	6a 7f                	push   $0x7f
  105e53:	e9 68 f8 ff ff       	jmp    1056c0 <alltraps>

00105e58 <vector128>:
  105e58:	6a 00                	push   $0x0
  105e5a:	68 80 00 00 00       	push   $0x80
  105e5f:	e9 5c f8 ff ff       	jmp    1056c0 <alltraps>

00105e64 <vector129>:
  105e64:	6a 00                	push   $0x0
  105e66:	68 81 00 00 00       	push   $0x81
  105e6b:	e9 50 f8 ff ff       	jmp    1056c0 <alltraps>

00105e70 <vector130>:
  105e70:	6a 00                	push   $0x0
  105e72:	68 82 00 00 00       	push   $0x82
  105e77:	e9 44 f8 ff ff       	jmp    1056c0 <alltraps>

00105e7c <vector131>:
  105e7c:	6a 00                	push   $0x0
  105e7e:	68 83 00 00 00       	push   $0x83
  105e83:	e9 38 f8 ff ff       	jmp    1056c0 <alltraps>

00105e88 <vector132>:
  105e88:	6a 00                	push   $0x0
  105e8a:	68 84 00 00 00       	push   $0x84
  105e8f:	e9 2c f8 ff ff       	jmp    1056c0 <alltraps>

00105e94 <vector133>:
  105e94:	6a 00                	push   $0x0
  105e96:	68 85 00 00 00       	push   $0x85
  105e9b:	e9 20 f8 ff ff       	jmp    1056c0 <alltraps>

00105ea0 <vector134>:
  105ea0:	6a 00                	push   $0x0
  105ea2:	68 86 00 00 00       	push   $0x86
  105ea7:	e9 14 f8 ff ff       	jmp    1056c0 <alltraps>

00105eac <vector135>:
  105eac:	6a 00                	push   $0x0
  105eae:	68 87 00 00 00       	push   $0x87
  105eb3:	e9 08 f8 ff ff       	jmp    1056c0 <alltraps>

00105eb8 <vector136>:
  105eb8:	6a 00                	push   $0x0
  105eba:	68 88 00 00 00       	push   $0x88
  105ebf:	e9 fc f7 ff ff       	jmp    1056c0 <alltraps>

00105ec4 <vector137>:
  105ec4:	6a 00                	push   $0x0
  105ec6:	68 89 00 00 00       	push   $0x89
  105ecb:	e9 f0 f7 ff ff       	jmp    1056c0 <alltraps>

00105ed0 <vector138>:
  105ed0:	6a 00                	push   $0x0
  105ed2:	68 8a 00 00 00       	push   $0x8a
  105ed7:	e9 e4 f7 ff ff       	jmp    1056c0 <alltraps>

00105edc <vector139>:
  105edc:	6a 00                	push   $0x0
  105ede:	68 8b 00 00 00       	push   $0x8b
  105ee3:	e9 d8 f7 ff ff       	jmp    1056c0 <alltraps>

00105ee8 <vector140>:
  105ee8:	6a 00                	push   $0x0
  105eea:	68 8c 00 00 00       	push   $0x8c
  105eef:	e9 cc f7 ff ff       	jmp    1056c0 <alltraps>

00105ef4 <vector141>:
  105ef4:	6a 00                	push   $0x0
  105ef6:	68 8d 00 00 00       	push   $0x8d
  105efb:	e9 c0 f7 ff ff       	jmp    1056c0 <alltraps>

00105f00 <vector142>:
  105f00:	6a 00                	push   $0x0
  105f02:	68 8e 00 00 00       	push   $0x8e
  105f07:	e9 b4 f7 ff ff       	jmp    1056c0 <alltraps>

00105f0c <vector143>:
  105f0c:	6a 00                	push   $0x0
  105f0e:	68 8f 00 00 00       	push   $0x8f
  105f13:	e9 a8 f7 ff ff       	jmp    1056c0 <alltraps>

00105f18 <vector144>:
  105f18:	6a 00                	push   $0x0
  105f1a:	68 90 00 00 00       	push   $0x90
  105f1f:	e9 9c f7 ff ff       	jmp    1056c0 <alltraps>

00105f24 <vector145>:
  105f24:	6a 00                	push   $0x0
  105f26:	68 91 00 00 00       	push   $0x91
  105f2b:	e9 90 f7 ff ff       	jmp    1056c0 <alltraps>

00105f30 <vector146>:
  105f30:	6a 00                	push   $0x0
  105f32:	68 92 00 00 00       	push   $0x92
  105f37:	e9 84 f7 ff ff       	jmp    1056c0 <alltraps>

00105f3c <vector147>:
  105f3c:	6a 00                	push   $0x0
  105f3e:	68 93 00 00 00       	push   $0x93
  105f43:	e9 78 f7 ff ff       	jmp    1056c0 <alltraps>

00105f48 <vector148>:
  105f48:	6a 00                	push   $0x0
  105f4a:	68 94 00 00 00       	push   $0x94
  105f4f:	e9 6c f7 ff ff       	jmp    1056c0 <alltraps>

00105f54 <vector149>:
  105f54:	6a 00                	push   $0x0
  105f56:	68 95 00 00 00       	push   $0x95
  105f5b:	e9 60 f7 ff ff       	jmp    1056c0 <alltraps>

00105f60 <vector150>:
  105f60:	6a 00                	push   $0x0
  105f62:	68 96 00 00 00       	push   $0x96
  105f67:	e9 54 f7 ff ff       	jmp    1056c0 <alltraps>

00105f6c <vector151>:
  105f6c:	6a 00                	push   $0x0
  105f6e:	68 97 00 00 00       	push   $0x97
  105f73:	e9 48 f7 ff ff       	jmp    1056c0 <alltraps>

00105f78 <vector152>:
  105f78:	6a 00                	push   $0x0
  105f7a:	68 98 00 00 00       	push   $0x98
  105f7f:	e9 3c f7 ff ff       	jmp    1056c0 <alltraps>

00105f84 <vector153>:
  105f84:	6a 00                	push   $0x0
  105f86:	68 99 00 00 00       	push   $0x99
  105f8b:	e9 30 f7 ff ff       	jmp    1056c0 <alltraps>

00105f90 <vector154>:
  105f90:	6a 00                	push   $0x0
  105f92:	68 9a 00 00 00       	push   $0x9a
  105f97:	e9 24 f7 ff ff       	jmp    1056c0 <alltraps>

00105f9c <vector155>:
  105f9c:	6a 00                	push   $0x0
  105f9e:	68 9b 00 00 00       	push   $0x9b
  105fa3:	e9 18 f7 ff ff       	jmp    1056c0 <alltraps>

00105fa8 <vector156>:
  105fa8:	6a 00                	push   $0x0
  105faa:	68 9c 00 00 00       	push   $0x9c
  105faf:	e9 0c f7 ff ff       	jmp    1056c0 <alltraps>

00105fb4 <vector157>:
  105fb4:	6a 00                	push   $0x0
  105fb6:	68 9d 00 00 00       	push   $0x9d
  105fbb:	e9 00 f7 ff ff       	jmp    1056c0 <alltraps>

00105fc0 <vector158>:
  105fc0:	6a 00                	push   $0x0
  105fc2:	68 9e 00 00 00       	push   $0x9e
  105fc7:	e9 f4 f6 ff ff       	jmp    1056c0 <alltraps>

00105fcc <vector159>:
  105fcc:	6a 00                	push   $0x0
  105fce:	68 9f 00 00 00       	push   $0x9f
  105fd3:	e9 e8 f6 ff ff       	jmp    1056c0 <alltraps>

00105fd8 <vector160>:
  105fd8:	6a 00                	push   $0x0
  105fda:	68 a0 00 00 00       	push   $0xa0
  105fdf:	e9 dc f6 ff ff       	jmp    1056c0 <alltraps>

00105fe4 <vector161>:
  105fe4:	6a 00                	push   $0x0
  105fe6:	68 a1 00 00 00       	push   $0xa1
  105feb:	e9 d0 f6 ff ff       	jmp    1056c0 <alltraps>

00105ff0 <vector162>:
  105ff0:	6a 00                	push   $0x0
  105ff2:	68 a2 00 00 00       	push   $0xa2
  105ff7:	e9 c4 f6 ff ff       	jmp    1056c0 <alltraps>

00105ffc <vector163>:
  105ffc:	6a 00                	push   $0x0
  105ffe:	68 a3 00 00 00       	push   $0xa3
  106003:	e9 b8 f6 ff ff       	jmp    1056c0 <alltraps>

00106008 <vector164>:
  106008:	6a 00                	push   $0x0
  10600a:	68 a4 00 00 00       	push   $0xa4
  10600f:	e9 ac f6 ff ff       	jmp    1056c0 <alltraps>

00106014 <vector165>:
  106014:	6a 00                	push   $0x0
  106016:	68 a5 00 00 00       	push   $0xa5
  10601b:	e9 a0 f6 ff ff       	jmp    1056c0 <alltraps>

00106020 <vector166>:
  106020:	6a 00                	push   $0x0
  106022:	68 a6 00 00 00       	push   $0xa6
  106027:	e9 94 f6 ff ff       	jmp    1056c0 <alltraps>

0010602c <vector167>:
  10602c:	6a 00                	push   $0x0
  10602e:	68 a7 00 00 00       	push   $0xa7
  106033:	e9 88 f6 ff ff       	jmp    1056c0 <alltraps>

00106038 <vector168>:
  106038:	6a 00                	push   $0x0
  10603a:	68 a8 00 00 00       	push   $0xa8
  10603f:	e9 7c f6 ff ff       	jmp    1056c0 <alltraps>

00106044 <vector169>:
  106044:	6a 00                	push   $0x0
  106046:	68 a9 00 00 00       	push   $0xa9
  10604b:	e9 70 f6 ff ff       	jmp    1056c0 <alltraps>

00106050 <vector170>:
  106050:	6a 00                	push   $0x0
  106052:	68 aa 00 00 00       	push   $0xaa
  106057:	e9 64 f6 ff ff       	jmp    1056c0 <alltraps>

0010605c <vector171>:
  10605c:	6a 00                	push   $0x0
  10605e:	68 ab 00 00 00       	push   $0xab
  106063:	e9 58 f6 ff ff       	jmp    1056c0 <alltraps>

00106068 <vector172>:
  106068:	6a 00                	push   $0x0
  10606a:	68 ac 00 00 00       	push   $0xac
  10606f:	e9 4c f6 ff ff       	jmp    1056c0 <alltraps>

00106074 <vector173>:
  106074:	6a 00                	push   $0x0
  106076:	68 ad 00 00 00       	push   $0xad
  10607b:	e9 40 f6 ff ff       	jmp    1056c0 <alltraps>

00106080 <vector174>:
  106080:	6a 00                	push   $0x0
  106082:	68 ae 00 00 00       	push   $0xae
  106087:	e9 34 f6 ff ff       	jmp    1056c0 <alltraps>

0010608c <vector175>:
  10608c:	6a 00                	push   $0x0
  10608e:	68 af 00 00 00       	push   $0xaf
  106093:	e9 28 f6 ff ff       	jmp    1056c0 <alltraps>

00106098 <vector176>:
  106098:	6a 00                	push   $0x0
  10609a:	68 b0 00 00 00       	push   $0xb0
  10609f:	e9 1c f6 ff ff       	jmp    1056c0 <alltraps>

001060a4 <vector177>:
  1060a4:	6a 00                	push   $0x0
  1060a6:	68 b1 00 00 00       	push   $0xb1
  1060ab:	e9 10 f6 ff ff       	jmp    1056c0 <alltraps>

001060b0 <vector178>:
  1060b0:	6a 00                	push   $0x0
  1060b2:	68 b2 00 00 00       	push   $0xb2
  1060b7:	e9 04 f6 ff ff       	jmp    1056c0 <alltraps>

001060bc <vector179>:
  1060bc:	6a 00                	push   $0x0
  1060be:	68 b3 00 00 00       	push   $0xb3
  1060c3:	e9 f8 f5 ff ff       	jmp    1056c0 <alltraps>

001060c8 <vector180>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	68 b4 00 00 00       	push   $0xb4
  1060cf:	e9 ec f5 ff ff       	jmp    1056c0 <alltraps>

001060d4 <vector181>:
  1060d4:	6a 00                	push   $0x0
  1060d6:	68 b5 00 00 00       	push   $0xb5
  1060db:	e9 e0 f5 ff ff       	jmp    1056c0 <alltraps>

001060e0 <vector182>:
  1060e0:	6a 00                	push   $0x0
  1060e2:	68 b6 00 00 00       	push   $0xb6
  1060e7:	e9 d4 f5 ff ff       	jmp    1056c0 <alltraps>

001060ec <vector183>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	68 b7 00 00 00       	push   $0xb7
  1060f3:	e9 c8 f5 ff ff       	jmp    1056c0 <alltraps>

001060f8 <vector184>:
  1060f8:	6a 00                	push   $0x0
  1060fa:	68 b8 00 00 00       	push   $0xb8
  1060ff:	e9 bc f5 ff ff       	jmp    1056c0 <alltraps>

00106104 <vector185>:
  106104:	6a 00                	push   $0x0
  106106:	68 b9 00 00 00       	push   $0xb9
  10610b:	e9 b0 f5 ff ff       	jmp    1056c0 <alltraps>

00106110 <vector186>:
  106110:	6a 00                	push   $0x0
  106112:	68 ba 00 00 00       	push   $0xba
  106117:	e9 a4 f5 ff ff       	jmp    1056c0 <alltraps>

0010611c <vector187>:
  10611c:	6a 00                	push   $0x0
  10611e:	68 bb 00 00 00       	push   $0xbb
  106123:	e9 98 f5 ff ff       	jmp    1056c0 <alltraps>

00106128 <vector188>:
  106128:	6a 00                	push   $0x0
  10612a:	68 bc 00 00 00       	push   $0xbc
  10612f:	e9 8c f5 ff ff       	jmp    1056c0 <alltraps>

00106134 <vector189>:
  106134:	6a 00                	push   $0x0
  106136:	68 bd 00 00 00       	push   $0xbd
  10613b:	e9 80 f5 ff ff       	jmp    1056c0 <alltraps>

00106140 <vector190>:
  106140:	6a 00                	push   $0x0
  106142:	68 be 00 00 00       	push   $0xbe
  106147:	e9 74 f5 ff ff       	jmp    1056c0 <alltraps>

0010614c <vector191>:
  10614c:	6a 00                	push   $0x0
  10614e:	68 bf 00 00 00       	push   $0xbf
  106153:	e9 68 f5 ff ff       	jmp    1056c0 <alltraps>

00106158 <vector192>:
  106158:	6a 00                	push   $0x0
  10615a:	68 c0 00 00 00       	push   $0xc0
  10615f:	e9 5c f5 ff ff       	jmp    1056c0 <alltraps>

00106164 <vector193>:
  106164:	6a 00                	push   $0x0
  106166:	68 c1 00 00 00       	push   $0xc1
  10616b:	e9 50 f5 ff ff       	jmp    1056c0 <alltraps>

00106170 <vector194>:
  106170:	6a 00                	push   $0x0
  106172:	68 c2 00 00 00       	push   $0xc2
  106177:	e9 44 f5 ff ff       	jmp    1056c0 <alltraps>

0010617c <vector195>:
  10617c:	6a 00                	push   $0x0
  10617e:	68 c3 00 00 00       	push   $0xc3
  106183:	e9 38 f5 ff ff       	jmp    1056c0 <alltraps>

00106188 <vector196>:
  106188:	6a 00                	push   $0x0
  10618a:	68 c4 00 00 00       	push   $0xc4
  10618f:	e9 2c f5 ff ff       	jmp    1056c0 <alltraps>

00106194 <vector197>:
  106194:	6a 00                	push   $0x0
  106196:	68 c5 00 00 00       	push   $0xc5
  10619b:	e9 20 f5 ff ff       	jmp    1056c0 <alltraps>

001061a0 <vector198>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	68 c6 00 00 00       	push   $0xc6
  1061a7:	e9 14 f5 ff ff       	jmp    1056c0 <alltraps>

001061ac <vector199>:
  1061ac:	6a 00                	push   $0x0
  1061ae:	68 c7 00 00 00       	push   $0xc7
  1061b3:	e9 08 f5 ff ff       	jmp    1056c0 <alltraps>

001061b8 <vector200>:
  1061b8:	6a 00                	push   $0x0
  1061ba:	68 c8 00 00 00       	push   $0xc8
  1061bf:	e9 fc f4 ff ff       	jmp    1056c0 <alltraps>

001061c4 <vector201>:
  1061c4:	6a 00                	push   $0x0
  1061c6:	68 c9 00 00 00       	push   $0xc9
  1061cb:	e9 f0 f4 ff ff       	jmp    1056c0 <alltraps>

001061d0 <vector202>:
  1061d0:	6a 00                	push   $0x0
  1061d2:	68 ca 00 00 00       	push   $0xca
  1061d7:	e9 e4 f4 ff ff       	jmp    1056c0 <alltraps>

001061dc <vector203>:
  1061dc:	6a 00                	push   $0x0
  1061de:	68 cb 00 00 00       	push   $0xcb
  1061e3:	e9 d8 f4 ff ff       	jmp    1056c0 <alltraps>

001061e8 <vector204>:
  1061e8:	6a 00                	push   $0x0
  1061ea:	68 cc 00 00 00       	push   $0xcc
  1061ef:	e9 cc f4 ff ff       	jmp    1056c0 <alltraps>

001061f4 <vector205>:
  1061f4:	6a 00                	push   $0x0
  1061f6:	68 cd 00 00 00       	push   $0xcd
  1061fb:	e9 c0 f4 ff ff       	jmp    1056c0 <alltraps>

00106200 <vector206>:
  106200:	6a 00                	push   $0x0
  106202:	68 ce 00 00 00       	push   $0xce
  106207:	e9 b4 f4 ff ff       	jmp    1056c0 <alltraps>

0010620c <vector207>:
  10620c:	6a 00                	push   $0x0
  10620e:	68 cf 00 00 00       	push   $0xcf
  106213:	e9 a8 f4 ff ff       	jmp    1056c0 <alltraps>

00106218 <vector208>:
  106218:	6a 00                	push   $0x0
  10621a:	68 d0 00 00 00       	push   $0xd0
  10621f:	e9 9c f4 ff ff       	jmp    1056c0 <alltraps>

00106224 <vector209>:
  106224:	6a 00                	push   $0x0
  106226:	68 d1 00 00 00       	push   $0xd1
  10622b:	e9 90 f4 ff ff       	jmp    1056c0 <alltraps>

00106230 <vector210>:
  106230:	6a 00                	push   $0x0
  106232:	68 d2 00 00 00       	push   $0xd2
  106237:	e9 84 f4 ff ff       	jmp    1056c0 <alltraps>

0010623c <vector211>:
  10623c:	6a 00                	push   $0x0
  10623e:	68 d3 00 00 00       	push   $0xd3
  106243:	e9 78 f4 ff ff       	jmp    1056c0 <alltraps>

00106248 <vector212>:
  106248:	6a 00                	push   $0x0
  10624a:	68 d4 00 00 00       	push   $0xd4
  10624f:	e9 6c f4 ff ff       	jmp    1056c0 <alltraps>

00106254 <vector213>:
  106254:	6a 00                	push   $0x0
  106256:	68 d5 00 00 00       	push   $0xd5
  10625b:	e9 60 f4 ff ff       	jmp    1056c0 <alltraps>

00106260 <vector214>:
  106260:	6a 00                	push   $0x0
  106262:	68 d6 00 00 00       	push   $0xd6
  106267:	e9 54 f4 ff ff       	jmp    1056c0 <alltraps>

0010626c <vector215>:
  10626c:	6a 00                	push   $0x0
  10626e:	68 d7 00 00 00       	push   $0xd7
  106273:	e9 48 f4 ff ff       	jmp    1056c0 <alltraps>

00106278 <vector216>:
  106278:	6a 00                	push   $0x0
  10627a:	68 d8 00 00 00       	push   $0xd8
  10627f:	e9 3c f4 ff ff       	jmp    1056c0 <alltraps>

00106284 <vector217>:
  106284:	6a 00                	push   $0x0
  106286:	68 d9 00 00 00       	push   $0xd9
  10628b:	e9 30 f4 ff ff       	jmp    1056c0 <alltraps>

00106290 <vector218>:
  106290:	6a 00                	push   $0x0
  106292:	68 da 00 00 00       	push   $0xda
  106297:	e9 24 f4 ff ff       	jmp    1056c0 <alltraps>

0010629c <vector219>:
  10629c:	6a 00                	push   $0x0
  10629e:	68 db 00 00 00       	push   $0xdb
  1062a3:	e9 18 f4 ff ff       	jmp    1056c0 <alltraps>

001062a8 <vector220>:
  1062a8:	6a 00                	push   $0x0
  1062aa:	68 dc 00 00 00       	push   $0xdc
  1062af:	e9 0c f4 ff ff       	jmp    1056c0 <alltraps>

001062b4 <vector221>:
  1062b4:	6a 00                	push   $0x0
  1062b6:	68 dd 00 00 00       	push   $0xdd
  1062bb:	e9 00 f4 ff ff       	jmp    1056c0 <alltraps>

001062c0 <vector222>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	68 de 00 00 00       	push   $0xde
  1062c7:	e9 f4 f3 ff ff       	jmp    1056c0 <alltraps>

001062cc <vector223>:
  1062cc:	6a 00                	push   $0x0
  1062ce:	68 df 00 00 00       	push   $0xdf
  1062d3:	e9 e8 f3 ff ff       	jmp    1056c0 <alltraps>

001062d8 <vector224>:
  1062d8:	6a 00                	push   $0x0
  1062da:	68 e0 00 00 00       	push   $0xe0
  1062df:	e9 dc f3 ff ff       	jmp    1056c0 <alltraps>

001062e4 <vector225>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	68 e1 00 00 00       	push   $0xe1
  1062eb:	e9 d0 f3 ff ff       	jmp    1056c0 <alltraps>

001062f0 <vector226>:
  1062f0:	6a 00                	push   $0x0
  1062f2:	68 e2 00 00 00       	push   $0xe2
  1062f7:	e9 c4 f3 ff ff       	jmp    1056c0 <alltraps>

001062fc <vector227>:
  1062fc:	6a 00                	push   $0x0
  1062fe:	68 e3 00 00 00       	push   $0xe3
  106303:	e9 b8 f3 ff ff       	jmp    1056c0 <alltraps>

00106308 <vector228>:
  106308:	6a 00                	push   $0x0
  10630a:	68 e4 00 00 00       	push   $0xe4
  10630f:	e9 ac f3 ff ff       	jmp    1056c0 <alltraps>

00106314 <vector229>:
  106314:	6a 00                	push   $0x0
  106316:	68 e5 00 00 00       	push   $0xe5
  10631b:	e9 a0 f3 ff ff       	jmp    1056c0 <alltraps>

00106320 <vector230>:
  106320:	6a 00                	push   $0x0
  106322:	68 e6 00 00 00       	push   $0xe6
  106327:	e9 94 f3 ff ff       	jmp    1056c0 <alltraps>

0010632c <vector231>:
  10632c:	6a 00                	push   $0x0
  10632e:	68 e7 00 00 00       	push   $0xe7
  106333:	e9 88 f3 ff ff       	jmp    1056c0 <alltraps>

00106338 <vector232>:
  106338:	6a 00                	push   $0x0
  10633a:	68 e8 00 00 00       	push   $0xe8
  10633f:	e9 7c f3 ff ff       	jmp    1056c0 <alltraps>

00106344 <vector233>:
  106344:	6a 00                	push   $0x0
  106346:	68 e9 00 00 00       	push   $0xe9
  10634b:	e9 70 f3 ff ff       	jmp    1056c0 <alltraps>

00106350 <vector234>:
  106350:	6a 00                	push   $0x0
  106352:	68 ea 00 00 00       	push   $0xea
  106357:	e9 64 f3 ff ff       	jmp    1056c0 <alltraps>

0010635c <vector235>:
  10635c:	6a 00                	push   $0x0
  10635e:	68 eb 00 00 00       	push   $0xeb
  106363:	e9 58 f3 ff ff       	jmp    1056c0 <alltraps>

00106368 <vector236>:
  106368:	6a 00                	push   $0x0
  10636a:	68 ec 00 00 00       	push   $0xec
  10636f:	e9 4c f3 ff ff       	jmp    1056c0 <alltraps>

00106374 <vector237>:
  106374:	6a 00                	push   $0x0
  106376:	68 ed 00 00 00       	push   $0xed
  10637b:	e9 40 f3 ff ff       	jmp    1056c0 <alltraps>

00106380 <vector238>:
  106380:	6a 00                	push   $0x0
  106382:	68 ee 00 00 00       	push   $0xee
  106387:	e9 34 f3 ff ff       	jmp    1056c0 <alltraps>

0010638c <vector239>:
  10638c:	6a 00                	push   $0x0
  10638e:	68 ef 00 00 00       	push   $0xef
  106393:	e9 28 f3 ff ff       	jmp    1056c0 <alltraps>

00106398 <vector240>:
  106398:	6a 00                	push   $0x0
  10639a:	68 f0 00 00 00       	push   $0xf0
  10639f:	e9 1c f3 ff ff       	jmp    1056c0 <alltraps>

001063a4 <vector241>:
  1063a4:	6a 00                	push   $0x0
  1063a6:	68 f1 00 00 00       	push   $0xf1
  1063ab:	e9 10 f3 ff ff       	jmp    1056c0 <alltraps>

001063b0 <vector242>:
  1063b0:	6a 00                	push   $0x0
  1063b2:	68 f2 00 00 00       	push   $0xf2
  1063b7:	e9 04 f3 ff ff       	jmp    1056c0 <alltraps>

001063bc <vector243>:
  1063bc:	6a 00                	push   $0x0
  1063be:	68 f3 00 00 00       	push   $0xf3
  1063c3:	e9 f8 f2 ff ff       	jmp    1056c0 <alltraps>

001063c8 <vector244>:
  1063c8:	6a 00                	push   $0x0
  1063ca:	68 f4 00 00 00       	push   $0xf4
  1063cf:	e9 ec f2 ff ff       	jmp    1056c0 <alltraps>

001063d4 <vector245>:
  1063d4:	6a 00                	push   $0x0
  1063d6:	68 f5 00 00 00       	push   $0xf5
  1063db:	e9 e0 f2 ff ff       	jmp    1056c0 <alltraps>

001063e0 <vector246>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	68 f6 00 00 00       	push   $0xf6
  1063e7:	e9 d4 f2 ff ff       	jmp    1056c0 <alltraps>

001063ec <vector247>:
  1063ec:	6a 00                	push   $0x0
  1063ee:	68 f7 00 00 00       	push   $0xf7
  1063f3:	e9 c8 f2 ff ff       	jmp    1056c0 <alltraps>

001063f8 <vector248>:
  1063f8:	6a 00                	push   $0x0
  1063fa:	68 f8 00 00 00       	push   $0xf8
  1063ff:	e9 bc f2 ff ff       	jmp    1056c0 <alltraps>

00106404 <vector249>:
  106404:	6a 00                	push   $0x0
  106406:	68 f9 00 00 00       	push   $0xf9
  10640b:	e9 b0 f2 ff ff       	jmp    1056c0 <alltraps>

00106410 <vector250>:
  106410:	6a 00                	push   $0x0
  106412:	68 fa 00 00 00       	push   $0xfa
  106417:	e9 a4 f2 ff ff       	jmp    1056c0 <alltraps>

0010641c <vector251>:
  10641c:	6a 00                	push   $0x0
  10641e:	68 fb 00 00 00       	push   $0xfb
  106423:	e9 98 f2 ff ff       	jmp    1056c0 <alltraps>

00106428 <vector252>:
  106428:	6a 00                	push   $0x0
  10642a:	68 fc 00 00 00       	push   $0xfc
  10642f:	e9 8c f2 ff ff       	jmp    1056c0 <alltraps>

00106434 <vector253>:
  106434:	6a 00                	push   $0x0
  106436:	68 fd 00 00 00       	push   $0xfd
  10643b:	e9 80 f2 ff ff       	jmp    1056c0 <alltraps>

00106440 <vector254>:
  106440:	6a 00                	push   $0x0
  106442:	68 fe 00 00 00       	push   $0xfe
  106447:	e9 74 f2 ff ff       	jmp    1056c0 <alltraps>

0010644c <vector255>:
  10644c:	6a 00                	push   $0x0
  10644e:	68 ff 00 00 00       	push   $0xff
  106453:	e9 68 f2 ff ff       	jmp    1056c0 <alltraps>
