// File system implementation.  Four layers:
//   + Blocks: allocator for raw disk blocks.
//   + Files: inode allocator, reading, writing, metadata.
//   + Directories: inode with special contents (list of other inodes!)
//   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
//
// Disk layout is: superblock, inodes, block in-use bitmap, data blocks.
//
// This file contains the low-level file system manipulation 
// routines.  The (higher-level) system call implementations
// are in sysfile.c.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "buf.h"
#include "fs.h"
#include "fsvar.h"
#include "dev.h"
#include "xchg.h"

#define min(a, b) ((a) < (b) ? (a) : (b))

struct mutex{
  volatile unsigned int lock;
};


static struct mutex wlock;
static int j_sz = 20;
static int journ = 0;
static struct inode* jp;
uint balloc_s(uint dev, uint sector);
static void itrunc(struct inode*);
uint premap(struct inode *ip, struct buf * indir, uint bn);
void updatecpy(struct inode * cpy, struct buf * indir, uint bn, uint addr);
uint prealloc(uint dev, uint * skip);
uint bmap_j(struct inode *ip, uint bn, int alloc, uint * skip);
uint balloc_j(uint dev, uint * skip);

static struct inode*
fscreate(char *path, int canexist, short type, short major, short minor)
{
cprintf("creating journ\n");
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

cprintf("parent %d\n", dp);
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}

void mutexlock(struct mutex* lock) {
  //printf(1,"locking-%d,value-%d\n", lock, lock->lock);
  while(xchg(lock->lock, 1) == 1){;}
   // printf(1,"spin\n");
  //printf(1,"locked-%d,value-%d\n", lock, lock->lock);
}

void mutexunlock(struct mutex* lock) {
  xchg(lock->lock, 0);
  //printf(1,"unlocked-%d\n", lock);
}

void mutexinit(struct mutex* lock) {
  xchg(lock->lock, 0); //0 is unused
}


// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
}

// Zero a block.
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  memset(bp->data, 0, BSIZE);
  bwrite(bp);
  brelse(bp);
}

// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
cprintf("balloc called\n");
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  bwrite(bp);
  brelse(bp);
}

// Inodes.
//
// An inode is a single, unnamed file in the file system.
// The inode disk structure holds metadata (the type, device numbers,
// and data size) along with a list of blocks where the associated
// data can be found.
//
// The inodes are laid out sequentially on disk immediately after
// the superblock.  The kernel keeps a cache of the in-use
// on-disk structures to provide a place for synchronizing access
// to inodes shared between multiple processes.
// 
// ip->ref counts the number of pointer references to this cached
// inode; references are typically kept in struct file and in cp->cwd.
// When ip->ref falls to zero, the inode is no longer cached.
// It is an error to use an inode without holding a reference to it.
//
// Processes are only allowed to read and write inode
// metadata and contents when holding the inode's lock,
// represented by the I_BUSY flag in the in-memory copy.
// Because inode locks are held during disk accesses, 
// they are implemented using a flag rather than with
// spin locks.  Callers are responsible for locking
// inodes before passing them to routines in this file; leaving
// this responsibility with the caller makes it possible for them
// to create arbitrarily-sized atomic operations.
//
// To give maximum control over locking to the callers, 
// the routines in this file that return inode pointers 
// return pointers to *unlocked* inodes.  It is the callers'
// responsibility to lock them before using them.  A non-zero
// ip->ref keeps these unlocked inodes in the cache.

struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} icache;



void
iinit(void)
{ 
  cprintf("iinit\n");
  initlock(&icache.lock, "icache.lock");
mutexinit(&wlock);
//
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
  ip->ref++;
  release(&icache.lock);
  return ip;
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  //cprintf("%d, %d, %d\n", ip->inum, ip->dev, ip->addrs[0]);
  struct buf *bp;
  struct dinode *dip;
  // cprintf("ilocks\n");
  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  //cprintf("ilocks99\n");
  acquire(&icache.lock);
  //cprintf("ilocks98\n");
  while(ip->flags & I_BUSY){
    // cprintf("looplock\n");
    sleep(ip, &icache.lock);}
  ip->flags |= I_BUSY;
  release(&icache.lock);
  //cprintf("ilocks1\n");
  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->flags |= I_VALID;
    // cprintf("ilocks2\n");
    if(ip->type == 0)
      panic("ilock: no type");
  }
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
    bp = bread(dev, IBLOCK(inum));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
}

// Inode contents
//
// The contents (data) associated with each inode is stored
// in a sequence of blocks on the disk.  The first NDIRECT blocks
// are listed in ip->addrs[].  The next NINDIRECT blocks are 
// listed in the block ip->addrs[INDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
      bwrite(bp);
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}

// Truncate inode (discard contents).
static void
itrunc(struct inode *ip)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  st->size = ip->size;
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}

// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
}

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
      }
    }
    brelse(bp);
  }
  return 0;
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
cprintf("dirlink- %s\n",name);
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  
  return 0;
}

// Paths

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  return path;
}

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/'){cprintf("root\n");
    ip = iget(ROOTDEV, 1);}
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
    //   cprintf("loop\n");
    ilock(ip);
    //cprintf("locked\n");
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  //cprintf("no more effin loop\n");
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}

struct inode*
namei(char *path)
{
  char name[DIRSIZ];
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
}


int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}




// Write data to inode - disk.
int
writed(struct inode *ip, char *src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    //  return devsw[ip->major].write(ip, src, n);
  }
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}


//write to journal, beware of large writes, may need to split into many writes
int
writei(struct inode *ip, char *src, uint off, uint n)
{
cprintf("writei: inum: %d, dev: %d, 1st char: %s  \n", ip->inum, ip->dev, src[0]);
  if(ip->inum == 1 && ip->dev == 1)
     return writed(ip, src, off,n);
  mutexlock(&wlock);
  cprintf("type %d\n", ip->type);
  uint tot, m, sector, sect_cnt;
  uchar data [50][512];
  struct buf *bp, *beginbuf, *ibuf, *indir;
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);

  }
if(journ == 0) {  //allocate in mkfs.c !
  cprintf("allocating journal");
  journ = 1;
    jp = fscreate("/journal", 1, T_FILE, 0, 0);  
journ  = 1;
cprintf("created!\n");
  if(jp == 0)
    cprintf("JP is 0");
}
 cprintf("journ created %d\n", jp);
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  cprintf("journal inode: %d, write inode:%d, src: %d, amount to write: %d, offset: %d\n", jp, ip,src , n, off);

//bread ibuf beginbuf
beginbuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); 
journal_offset += BSIZE;
//cprintf("%d - blcksz\n", sizeof(struct begin_block));
struct begin_block *beginblock = kalloc(PAGE); //alloc struct
uchar* k = beginblock;
beginblock->identifier = 'B';
beginblock->size = n; //plus inode block
beginblock->indirect = 0;
beginblock->nblocks = 0;
cprintf("begin alloced\n");
//create skip array for prealloc
  uint * skip = kalloc(PAGE); 
//create copy of inode for consistent metadata
 cprintf("skip alloced\n");

int i;

for(i = 0; i < 50; i++)
 skip[i] = 0;


//for(i = 0; i < 50; i++)
// cprintf("skip at %d,   %d\n", i, skip[i]);


  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
      beginblock->indirect = 1;
      sector = prealloc(ip->dev, skip);
      cprintf("indir blk prealloc: %d\n", sector);
      ip->addrs[INDIRECT] = sector;
      indir = bread(ip->dev, sector);
      int v = 0;
      for(v = 0; v < 512; v++)
	  indir->data[v] = '0';
    }
  else //one exists, bread it
    {
      cprintf("inode has indirect block, reading into: %d buffer\n", indir);
      indir = bread(ip->dev, ip->addrs[INDIRECT]);
    }

  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);

for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of begin block buffer w/ '0'
beginbuf->data[i] = '0';
} 


bwrite(beginbuf);  //write beginbuf, bwrite guarantees data has been written

 cprintf("begin block written to journal: dev: %d, sector: %d\n", beginbuf->dev,beginbuf->sector);

brelse(beginbuf); 


k = beginblock; //now used as end block
beginblock->identifier = 'E';
beginblock->size = n;
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
 cprintf("beginning to write data to journal\n");
//write data to journal
 for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    //check if sector already exists
    sector = premap(ip, indir, off/BSIZE);
    cprintf("sector returned by premap: %d, offset: %d \n", sector, off);
    if (sector == 0) //doesnt exist, prealloc it, update inode
      {
	sector = prealloc(ip->dev, skip);
	cprintf("data prealloc: %d\n", sector);
	updatecpy(ip, indir, off/BSIZE, sector);
	bp = bread(ip->dev, sector);
	//nothing to read, set bp = 0's
	memset(bp->data, 0, BSIZE);
      }
    else //read in data @ that sector
      {
	bp = bread(ip->dev, sector);
      }
   
    //update buffer
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m); //update buffer with new data
    //store sector
    beginblock->sector[beginblock->nblocks] = sector;
    //store data in memory
    memmove(&data[beginblock->nblocks], &(bp->data), 512);
    // *data[beginblock->nblocks] = *(bp->data);
    bp->dev = jp->dev; //update dev to journal
    bp->sector = bmap_j(jp, journal_offset/BSIZE, 1, skip); //update sector to journal
    
    cprintf("journ off %d, dev %d, sector %d, nblk %d\n", journal_offset, bp->dev, bp->sector, beginblock->nblocks);

    journal_offset += m;
    //write to journal
    bwrite(bp);
    brelse(bp);
    beginblock->nblocks++;
  }
 // for(i = 0 ; i < 50; i++)
 // cprintf("sectors: %d\n", beginblock->sector[i]);

 cprintf("num sectors = %d\n", beginblock->nblocks);
  if(n > 0 && off > ip->size){
    ip->size = off;
//iupdate(ip);
  }

  for(i = 0; i < 50; i++)
    continue;
    // cprintf("skip at %d,   %d\n", i, skip[i]);
  
cprintf("data journaled!\n");
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  journal_offset += BSIZE;
  memmove(&(ibuf->data), &(indir->data), 512);
  //*(ibuf->data) = *(indir->data);

  brelse(indir); //release old buffer, no write though
  bwrite(ibuf); //write indirect block to journal

  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);

  brelse(ibuf);
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
	ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
	ibuf->data[i] = '0';
  }
  beginblock->sector[beginblock->nblocks] = 0;
  beginblock->nblocks++;
  bwrite(ibuf); //write inode to journal
 cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf); 

      //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  journal_offset += BSIZE;
  struct begin_block * skp;
  // char * tmp = skp
  skp->identifier = 'S';
  k = skp;
  int z;
   for (z = 0 ; z < 50 ; z++)
     skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	ibuf->data[i] = k[i];
}
  //  memset(skp,1,PAGE);
for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  ibuf->data[i] = '0';
} 
//wait for writes to finish, write skip
 bwrite(ibuf);
 cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
 brelse(ibuf);
 uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
 ibuf = bread(jp->dev, tmp);
 cprintf("read end blk\n");

k = beginblock;
for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
beginbuf->data[i] = '0';
} 
 cprintf("writing end buf\n");
 bwrite(ibuf);
 brelse(ibuf); //end buffer written

//wait for writes to complete, write stuff to disk, free journal entry
 
 cprintf("everything journaled!, starting allocs\n");

 //allocate everything
 for(i = 0 ; i < 50 ; i++)
   {
     sector = skip[i];
     if(sector != 0) {
       //      cprintf("ballocing %d\n", skip[i]);
       uint n = balloc_s(ip->dev, sector);
       cprintf("balloc ret %d, expected %d \n",n, sector);
       if (n != sector)
	 panic("bad sector alloc");
     }
   }

 cprintf("balloc done, writing data\n");
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
   {
     if(beginblock->sector[i] != 0)
       {
	 ibuf = bread(ip->dev, beginblock->sector[i]);
	 memmove(&(ibuf->data), &data[i], 512);
	 cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
	 bwrite(ibuf);
	 brelse(ibuf);
       }
   }
 cprintf("updating inode\n");
 iupdate(ip); //update inode on disk
 cprintf("deleting journal\n");
 itrunc(jp); //delete journal
 kfree(beginblock, PAGE);
 // cprintf("blah!\n");
 //kfree(skp, PAGE);
 // cprintf("blah3!\n");
 kfree(skip, PAGE);
 //cprintf("/blah3!\n");
 //cprintf("blah3!\n");
 mutexunlock(&wlock);
 cprintf("write done\n");
 //cprintf("blah2!\n");
 return n;
}

uint
premap(struct inode *ip, struct buf * indir, uint bn)
{
  uint addr;
  uint *a;
  //struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
        return 0;
    }
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    a = (uint*)indir->data;
    if((addr = a[bn]) == 0){
      
        return 0;
      }
    return addr;
  }

  panic("premap: out of range");
}


uint
prealloc(uint dev, uint * skip)
{
  int b, bi, m, j, dont;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  dont = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        for(j = 0; j < 50; j++) {
		if (skip[j] == b+bi)
		    {
			dont = 1;
			break;
		    }
		else if (skip[j] == 0)
		  {
		    skip[j] = b+bi;
		    break;
		  }
	}
	if (dont)
		continue;
	else
	  {
	    brelse(bp);
	    return b + bi;
	  }
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

 void updatecpy(struct inode * cpy, struct buf * indir, uint bn, uint addr)
{
	uint * a;
	struct buf * bp;
	if(bn < NDIRECT)
	  {
		cpy->addrs[bn] = addr;
		return;
	  }
	else if (bn < NINDIRECT){
		a = (uint*)indir->data;
		a[bn] = addr;
		return;
	}
}


// Allocate a disk block.
uint
balloc_s(uint dev, uint sector)
{
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if(b+bi == sector) {  // Is block the right one?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  return 0;
}

// Allocate a disk block.
uint
balloc_j(uint dev, uint * skip)
{
  int b, bi, m, j;
int dont;
  struct buf *bp;
  struct superblock sb;
cprintf("balloc_j called\n");
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
	dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?

		for(j = 0; j < 50; j++) {
		cprintf("skip array at %d :  %d\n", j, skip[j]);
		if (skip[j] == b+bi)
		    {
			cprintf("skipping in balloc_j %d\n", b+bi);
			dont = 1;
			break;
		    }
		else if(skip[j] ==0)
			break;
	}

	if (dont)
		continue;
	else
	  {
	    //cprintf("returning from balloc_j\n");

	bp->data[bi/8] |= m;  // Mark block in use on disk.
	//cprintf("returning from balloc_j\n");

        bwrite(bp);
	//cprintf("returning from balloc_j\n");
        brelse(bp);
	//cprintf("returning from balloc_j\n");

        return b + bi;
      }
    }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

uint
bmap_j(struct inode *ip, uint bn, int alloc, uint * skip)
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc_j(ip->dev, skip);
    }
    // cprintf("ret\n");
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc_j(ip->dev,skip);
    }
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc_j(ip->dev, skip);
      bwrite(bp);
    }
    brelse(bp);
    //cprintf("ret\n");
    return addr;
  }

  panic("bmap: out of range");
}

