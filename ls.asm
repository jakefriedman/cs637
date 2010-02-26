
_ls:     file format elf32-i386

Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	89 1c 24             	mov    %ebx,(%esp)
   e:	e8 bd 03 00 00       	call   3d0 <strlen>
  13:	01 d8                	add    %ebx,%eax
  15:	39 c3                	cmp    %eax,%ebx
  17:	76 0e                	jbe    27 <fmtname+0x27>
  19:	eb 11                	jmp    2c <fmtname+0x2c>
  1b:	90                   	nop    
  1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  20:	83 e8 01             	sub    $0x1,%eax
  23:	39 c3                	cmp    %eax,%ebx
  25:	77 05                	ja     2c <fmtname+0x2c>
  27:	80 38 2f             	cmpb   $0x2f,(%eax)
  2a:	75 f4                	jne    20 <fmtname+0x20>
    ;
  p++;
  2c:	8d 70 01             	lea    0x1(%eax),%esi
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2f:	89 34 24             	mov    %esi,(%esp)
  32:	e8 99 03 00 00       	call   3d0 <strlen>
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	77 53                	ja     8f <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  3c:	89 34 24             	mov    %esi,(%esp)
  3f:	e8 8c 03 00 00       	call   3d0 <strlen>
  44:	89 74 24 04          	mov    %esi,0x4(%esp)
  48:	c7 04 24 18 0a 00 00 	movl   $0xa18,(%esp)
  4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  53:	e8 28 04 00 00       	call   480 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  58:	89 34 24             	mov    %esi,(%esp)
  5b:	e8 70 03 00 00       	call   3d0 <strlen>
  60:	89 34 24             	mov    %esi,(%esp)
  63:	be 18 0a 00 00       	mov    $0xa18,%esi
  68:	89 c3                	mov    %eax,%ebx
  6a:	e8 61 03 00 00       	call   3d0 <strlen>
  6f:	ba 0e 00 00 00       	mov    $0xe,%edx
  74:	29 da                	sub    %ebx,%edx
  76:	89 54 24 08          	mov    %edx,0x8(%esp)
  7a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  81:	00 
  82:	05 18 0a 00 00       	add    $0xa18,%eax
  87:	89 04 24             	mov    %eax,(%esp)
  8a:	e8 61 03 00 00       	call   3f0 <memset>
  return buf;
}
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 f0                	mov    %esi,%eax
  94:	5b                   	pop    %ebx
  95:	5e                   	pop    %esi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    
  98:	90                   	nop    
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000000a0 <ls>:

void
ls(char *path)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	81 ec 4c 02 00 00    	sub    $0x24c,%esp
  ac:	8b 75 08             	mov    0x8(%ebp),%esi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 34 24             	mov    %esi,(%esp)
  ba:	e8 e9 04 00 00       	call   5a8 <open>
  bf:	85 c0                	test   %eax,%eax
  c1:	89 c7                	mov    %eax,%edi
  c3:	0f 88 9b 01 00 00    	js     264 <ls+0x1c4>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
  c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  d0:	89 3c 24             	mov    %edi,(%esp)
  d3:	e8 e8 04 00 00       	call   5c0 <fstat>
  d8:	85 c0                	test   %eax,%eax
  da:	0f 88 c0 01 00 00    	js     2a0 <ls+0x200>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  e0:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
  e4:	66 83 f8 01          	cmp    $0x1,%ax
  e8:	74 66                	je     150 <ls+0xb0>
  ea:	66 83 f8 02          	cmp    $0x2,%ax
  ee:	66 90                	xchg   %ax,%ax
  f0:	74 13                	je     105 <ls+0x65>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
  f2:	89 3c 24             	mov    %edi,(%esp)
  f5:	e8 96 04 00 00       	call   590 <close>
}
  fa:	81 c4 4c 02 00 00    	add    $0x24c,%esp
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
    return;
  }
  
  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 105:	8b 55 d8             	mov    -0x28(%ebp),%edx
 108:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 10b:	89 95 c8 fd ff ff    	mov    %edx,-0x238(%ebp)
 111:	89 34 24             	mov    %esi,(%esp)
 114:	e8 e7 fe ff ff       	call   0 <fmtname>
 119:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 11d:	8b 95 c8 fd ff ff    	mov    -0x238(%ebp),%edx
 123:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 12a:	00 
 12b:	c7 44 24 04 dd 09 00 	movl   $0x9dd,0x4(%esp)
 132:	00 
 133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13a:	89 54 24 10          	mov    %edx,0x10(%esp)
 13e:	89 44 24 08          	mov    %eax,0x8(%esp)
 142:	e8 a9 05 00 00       	call   6f0 <printf>
 147:	eb a9                	jmp    f2 <ls+0x52>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 150:	89 34 24             	mov    %esi,(%esp)
 153:	e8 78 02 00 00       	call   3d0 <strlen>
 158:	83 c0 10             	add    $0x10,%eax
 15b:	3d 00 02 00 00       	cmp    $0x200,%eax
 160:	0f 87 21 01 00 00    	ja     287 <ls+0x1e7>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 166:	8d 85 d4 fd ff ff    	lea    -0x22c(%ebp),%eax
 16c:	89 74 24 04          	mov    %esi,0x4(%esp)
 170:	89 04 24             	mov    %eax,(%esp)
 173:	e8 d8 01 00 00       	call   350 <strcpy>
    p = buf+strlen(buf);
 178:	8d 95 d4 fd ff ff    	lea    -0x22c(%ebp),%edx
 17e:	89 14 24             	mov    %edx,(%esp)
 181:	e8 4a 02 00 00       	call   3d0 <strlen>
 186:	8d 95 d4 fd ff ff    	lea    -0x22c(%ebp),%edx
 18c:	8d 04 02             	lea    (%edx,%eax,1),%eax
    *p++ = '/';
 18f:	c6 00 2f             	movb   $0x2f,(%eax)
 192:	83 c0 01             	add    $0x1,%eax
 195:	89 85 d0 fd ff ff    	mov    %eax,-0x230(%ebp)
 19b:	90                   	nop    
 19c:	8d 74 26 00          	lea    0x0(%esi),%esi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 1a3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1aa:	00 
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	89 3c 24             	mov    %edi,(%esp)
 1b2:	e8 c9 03 00 00       	call   580 <read>
 1b7:	83 f8 10             	cmp    $0x10,%eax
 1ba:	0f 85 32 ff ff ff    	jne    f2 <ls+0x52>
      if(de.inum == 0)
 1c0:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
 1c5:	74 d9                	je     1a0 <ls+0x100>
        continue;
      memmove(p, de.name, DIRSIZ);
 1c7:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 1ca:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 1d1:	00 
 1d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d6:	8b 95 d0 fd ff ff    	mov    -0x230(%ebp),%edx
 1dc:	89 14 24             	mov    %edx,(%esp)
 1df:	e8 9c 02 00 00       	call   480 <memmove>
      p[DIRSIZ] = 0;
 1e4:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
      if(stat(buf, &st) < 0){
 1ea:	8d 55 d4             	lea    -0x2c(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 1ed:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      if(stat(buf, &st) < 0){
 1f1:	8d 85 d4 fd ff ff    	lea    -0x22c(%ebp),%eax
 1f7:	89 54 24 04          	mov    %edx,0x4(%esp)
 1fb:	89 04 24             	mov    %eax,(%esp)
 1fe:	e8 ad 02 00 00       	call   4b0 <stat>
 203:	85 c0                	test   %eax,%eax
 205:	0f 88 ba 00 00 00    	js     2c5 <ls+0x225>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 20b:	8b 45 d8             	mov    -0x28(%ebp),%eax
 20e:	0f bf 55 dc          	movswl -0x24(%ebp),%edx
 212:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 215:	89 85 cc fd ff ff    	mov    %eax,-0x234(%ebp)
 21b:	8d 85 d4 fd ff ff    	lea    -0x22c(%ebp),%eax
 221:	89 95 c4 fd ff ff    	mov    %edx,-0x23c(%ebp)
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 d1 fd ff ff       	call   0 <fmtname>
 22f:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 233:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 239:	89 54 24 10          	mov    %edx,0x10(%esp)
 23d:	8b 95 c4 fd ff ff    	mov    -0x23c(%ebp),%edx
 243:	89 44 24 08          	mov    %eax,0x8(%esp)
 247:	c7 44 24 04 dd 09 00 	movl   $0x9dd,0x4(%esp)
 24e:	00 
 24f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 256:	89 54 24 0c          	mov    %edx,0xc(%esp)
 25a:	e8 91 04 00 00       	call   6f0 <printf>
 25f:	e9 3c ff ff ff       	jmp    1a0 <ls+0x100>
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 264:	89 74 24 08          	mov    %esi,0x8(%esp)
 268:	c7 44 24 04 b5 09 00 	movl   $0x9b5,0x4(%esp)
 26f:	00 
 270:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 277:	e8 74 04 00 00       	call   6f0 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 27c:	81 c4 4c 02 00 00    	add    $0x24c,%esp
 282:	5b                   	pop    %ebx
 283:	5e                   	pop    %esi
 284:	5f                   	pop    %edi
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 287:	c7 44 24 04 ea 09 00 	movl   $0x9ea,0x4(%esp)
 28e:	00 
 28f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 296:	e8 55 04 00 00       	call   6f0 <printf>
 29b:	e9 52 fe ff ff       	jmp    f2 <ls+0x52>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 2a0:	89 74 24 08          	mov    %esi,0x8(%esp)
 2a4:	c7 44 24 04 c9 09 00 	movl   $0x9c9,0x4(%esp)
 2ab:	00 
 2ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2b3:	e8 38 04 00 00       	call   6f0 <printf>
    close(fd);
 2b8:	89 3c 24             	mov    %edi,(%esp)
 2bb:	e8 d0 02 00 00       	call   590 <close>
 2c0:	e9 35 fe ff ff       	jmp    fa <ls+0x5a>
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 2c5:	8d 95 d4 fd ff ff    	lea    -0x22c(%ebp),%edx
 2cb:	89 54 24 08          	mov    %edx,0x8(%esp)
 2cf:	c7 44 24 04 c9 09 00 	movl   $0x9c9,0x4(%esp)
 2d6:	00 
 2d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2de:	e8 0d 04 00 00       	call   6f0 <printf>
 2e3:	e9 b8 fe ff ff       	jmp    1a0 <ls+0x100>
 2e8:	90                   	nop    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000002f0 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
 2f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2f4:	83 e4 f0             	and    $0xfffffff0,%esp
 2f7:	ff 71 fc             	pushl  -0x4(%ecx)
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 18             	sub    $0x18,%esp
 300:	89 5d f4             	mov    %ebx,-0xc(%ebp)
 303:	8b 19                	mov    (%ecx),%ebx
 305:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 308:	89 75 f8             	mov    %esi,-0x8(%ebp)
 30b:	89 7d fc             	mov    %edi,-0x4(%ebp)
 30e:	8b 71 04             	mov    0x4(%ecx),%esi
  int i;

  if(argc < 2){
 311:	83 fb 01             	cmp    $0x1,%ebx
 314:	7f 11                	jg     327 <main+0x37>
    ls(".");
 316:	c7 04 24 fd 09 00 00 	movl   $0x9fd,(%esp)
 31d:	e8 7e fd ff ff       	call   a0 <ls>
    exit();
 322:	e8 41 02 00 00       	call   568 <exit>
 327:	bf 01 00 00 00       	mov    $0x1,%edi
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 32c:	8b 04 be             	mov    (%esi,%edi,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 32f:	83 c7 01             	add    $0x1,%edi
    ls(argv[i]);
 332:	89 04 24             	mov    %eax,(%esp)
 335:	e8 66 fd ff ff       	call   a0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 33a:	39 df                	cmp    %ebx,%edi
 33c:	75 ee                	jne    32c <main+0x3c>
    ls(argv[i]);
  exit();
 33e:	e8 25 02 00 00       	call   568 <exit>
 343:	90                   	nop    
 344:	90                   	nop    
 345:	90                   	nop    
 346:	90                   	nop    
 347:	90                   	nop    
 348:	90                   	nop    
 349:	90                   	nop    
 34a:	90                   	nop    
 34b:	90                   	nop    
 34c:	90                   	nop    
 34d:	90                   	nop    
 34e:	90                   	nop    
 34f:	90                   	nop    

00000350 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 5d 08             	mov    0x8(%ebp),%ebx
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 35a:	89 da                	mov    %ebx,%edx
 35c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 360:	0f b6 01             	movzbl (%ecx),%eax
 363:	83 c1 01             	add    $0x1,%ecx
 366:	88 02                	mov    %al,(%edx)
 368:	83 c2 01             	add    $0x1,%edx
 36b:	84 c0                	test   %al,%al
 36d:	75 f1                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 36f:	89 d8                	mov    %ebx,%eax
 371:	5b                   	pop    %ebx
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    
 374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 37a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 4d 08             	mov    0x8(%ebp),%ecx
 386:	53                   	push   %ebx
 387:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 38a:	0f b6 01             	movzbl (%ecx),%eax
 38d:	84 c0                	test   %al,%al
 38f:	74 24                	je     3b5 <strcmp+0x35>
 391:	0f b6 13             	movzbl (%ebx),%edx
 394:	38 d0                	cmp    %dl,%al
 396:	74 12                	je     3aa <strcmp+0x2a>
 398:	eb 1e                	jmp    3b8 <strcmp+0x38>
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a0:	0f b6 13             	movzbl (%ebx),%edx
 3a3:	83 c1 01             	add    $0x1,%ecx
 3a6:	38 d0                	cmp    %dl,%al
 3a8:	75 0e                	jne    3b8 <strcmp+0x38>
 3aa:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 3ae:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b1:	84 c0                	test   %al,%al
 3b3:	75 eb                	jne    3a0 <strcmp+0x20>
 3b5:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3b8:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b9:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3bc:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3bd:	0f b6 d2             	movzbl %dl,%edx
 3c0:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3c2:	c3                   	ret    
 3c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000003d0 <strlen>:

uint
strlen(char *s)
{
 3d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3d8:	80 39 00             	cmpb   $0x0,(%ecx)
 3db:	74 0e                	je     3eb <strlen+0x1b>
 3dd:	31 d2                	xor    %edx,%edx
 3df:	90                   	nop    
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi

000003f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 10             	mov    0x10(%ebp),%eax
 3f6:	53                   	push   %ebx
 3f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 3fa:	85 c0                	test   %eax,%eax
 3fc:	74 10                	je     40e <memset+0x1e>
 3fe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 402:	31 d2                	xor    %edx,%edx
    *d++ = c;
 404:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 407:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 40a:	39 c2                	cmp    %eax,%edx
 40c:	75 f6                	jne    404 <memset+0x14>
    *d++ = c;
  return dst;
}
 40e:	89 d8                	mov    %ebx,%eax
 410:	5b                   	pop    %ebx
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    
 413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 0c                	jne    43d <strchr+0x1d>
 431:	eb 11                	jmp    444 <strchr+0x24>
 433:	83 c0 01             	add    $0x1,%eax
 436:	0f b6 10             	movzbl (%eax),%edx
 439:	84 d2                	test   %dl,%dl
 43b:	74 07                	je     444 <strchr+0x24>
    if(*s == c)
 43d:	38 ca                	cmp    %cl,%dl
 43f:	90                   	nop    
 440:	75 f1                	jne    433 <strchr+0x13>
      return (char*) s;
  return 0;
}
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 445:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 447:	c3                   	ret    
 448:	90                   	nop    
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000450 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	8b 4d 08             	mov    0x8(%ebp),%ecx
 456:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	31 db                	xor    %ebx,%ebx
 459:	0f b6 11             	movzbl (%ecx),%edx
 45c:	8d 42 d0             	lea    -0x30(%edx),%eax
 45f:	3c 09                	cmp    $0x9,%al
 461:	77 18                	ja     47b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 463:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 466:	0f be d2             	movsbl %dl,%edx
 469:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 471:	83 c1 01             	add    $0x1,%ecx
 474:	8d 42 d0             	lea    -0x30(%edx),%eax
 477:	3c 09                	cmp    $0x9,%al
 479:	76 e8                	jbe    463 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 47b:	89 d8                	mov    %ebx,%eax
 47d:	5b                   	pop    %ebx
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret    

00000480 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 4d 10             	mov    0x10(%ebp),%ecx
 486:	56                   	push   %esi
 487:	8b 75 08             	mov    0x8(%ebp),%esi
 48a:	53                   	push   %ebx
 48b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c9                	test   %ecx,%ecx
 490:	7e 10                	jle    4a2 <memmove+0x22>
 492:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 494:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 498:	88 04 32             	mov    %al,(%edx,%esi,1)
 49b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	39 ca                	cmp    %ecx,%edx
 4a0:	75 f2                	jne    494 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 4a2:	89 f0                	mov    %esi,%eax
 4a4:	5b                   	pop    %ebx
 4a5:	5e                   	pop    %esi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	90                   	nop    
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000004b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4cb:	00 
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 d4 00 00 00       	call   5a8 <open>
  if(fd < 0)
 4d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 4d8:	78 19                	js     4f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 1c 24             	mov    %ebx,(%esp)
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	e8 d7 00 00 00       	call   5c0 <fstat>
  close(fd);
 4e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 4ec:	89 c6                	mov    %eax,%esi
  close(fd);
 4ee:	e8 9d 00 00 00       	call   590 <close>
  return r;
}
 4f3:	89 f0                	mov    %esi,%eax
 4f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 4f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 4fb:	89 ec                	mov    %ebp,%esp
 4fd:	5d                   	pop    %ebp
 4fe:	c3                   	ret    
 4ff:	90                   	nop    

00000500 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	31 f6                	xor    %esi,%esi
 507:	53                   	push   %ebx
 508:	83 ec 1c             	sub    $0x1c,%esp
 50b:	8b 7d 08             	mov    0x8(%ebp),%edi
 50e:	eb 06                	jmp    516 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 510:	3c 0d                	cmp    $0xd,%al
 512:	74 39                	je     54d <gets+0x4d>
 514:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 516:	8d 5e 01             	lea    0x1(%esi),%ebx
 519:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 51c:	7d 31                	jge    54f <gets+0x4f>
    cc = read(0, &c, 1);
 51e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 534:	e8 47 00 00 00       	call   580 <read>
    if(cc < 1)
 539:	85 c0                	test   %eax,%eax
 53b:	7e 12                	jle    54f <gets+0x4f>
      break;
    buf[i++] = c;
 53d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 541:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 549:	3c 0a                	cmp    $0xa,%al
 54b:	75 c3                	jne    510 <gets+0x10>
 54d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 54f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 553:	89 f8                	mov    %edi,%eax
 555:	83 c4 1c             	add    $0x1c,%esp
 558:	5b                   	pop    %ebx
 559:	5e                   	pop    %esi
 55a:	5f                   	pop    %edi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	90                   	nop    
 55e:	90                   	nop    
 55f:	90                   	nop    

00000560 <fork>:
 560:	b8 01 00 00 00       	mov    $0x1,%eax
 565:	cd 30                	int    $0x30
 567:	c3                   	ret    

00000568 <exit>:
 568:	b8 02 00 00 00       	mov    $0x2,%eax
 56d:	cd 30                	int    $0x30
 56f:	c3                   	ret    

00000570 <wait>:
 570:	b8 03 00 00 00       	mov    $0x3,%eax
 575:	cd 30                	int    $0x30
 577:	c3                   	ret    

00000578 <pipe>:
 578:	b8 04 00 00 00       	mov    $0x4,%eax
 57d:	cd 30                	int    $0x30
 57f:	c3                   	ret    

00000580 <read>:
 580:	b8 06 00 00 00       	mov    $0x6,%eax
 585:	cd 30                	int    $0x30
 587:	c3                   	ret    

00000588 <write>:
 588:	b8 05 00 00 00       	mov    $0x5,%eax
 58d:	cd 30                	int    $0x30
 58f:	c3                   	ret    

00000590 <close>:
 590:	b8 07 00 00 00       	mov    $0x7,%eax
 595:	cd 30                	int    $0x30
 597:	c3                   	ret    

00000598 <kill>:
 598:	b8 08 00 00 00       	mov    $0x8,%eax
 59d:	cd 30                	int    $0x30
 59f:	c3                   	ret    

000005a0 <exec>:
 5a0:	b8 09 00 00 00       	mov    $0x9,%eax
 5a5:	cd 30                	int    $0x30
 5a7:	c3                   	ret    

000005a8 <open>:
 5a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ad:	cd 30                	int    $0x30
 5af:	c3                   	ret    

000005b0 <mknod>:
 5b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b5:	cd 30                	int    $0x30
 5b7:	c3                   	ret    

000005b8 <unlink>:
 5b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5bd:	cd 30                	int    $0x30
 5bf:	c3                   	ret    

000005c0 <fstat>:
 5c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c5:	cd 30                	int    $0x30
 5c7:	c3                   	ret    

000005c8 <link>:
 5c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5cd:	cd 30                	int    $0x30
 5cf:	c3                   	ret    

000005d0 <mkdir>:
 5d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d5:	cd 30                	int    $0x30
 5d7:	c3                   	ret    

000005d8 <chdir>:
 5d8:	b8 10 00 00 00       	mov    $0x10,%eax
 5dd:	cd 30                	int    $0x30
 5df:	c3                   	ret    

000005e0 <dup>:
 5e0:	b8 11 00 00 00       	mov    $0x11,%eax
 5e5:	cd 30                	int    $0x30
 5e7:	c3                   	ret    

000005e8 <getpid>:
 5e8:	b8 12 00 00 00       	mov    $0x12,%eax
 5ed:	cd 30                	int    $0x30
 5ef:	c3                   	ret    

000005f0 <sbrk>:
 5f0:	b8 13 00 00 00       	mov    $0x13,%eax
 5f5:	cd 30                	int    $0x30
 5f7:	c3                   	ret    

000005f8 <sleep>:
 5f8:	b8 14 00 00 00       	mov    $0x14,%eax
 5fd:	cd 30                	int    $0x30
 5ff:	c3                   	ret    

00000600 <tick>:
 600:	b8 15 00 00 00       	mov    $0x15,%eax
 605:	cd 30                	int    $0x30
 607:	c3                   	ret    

00000608 <fork_tickets>:
 608:	b8 16 00 00 00       	mov    $0x16,%eax
 60d:	cd 30                	int    $0x30
 60f:	c3                   	ret    

00000610 <fork_thread>:
 610:	b8 17 00 00 00       	mov    $0x17,%eax
 615:	cd 30                	int    $0x30
 617:	c3                   	ret    

00000618 <wait_thread>:
 618:	b8 18 00 00 00       	mov    $0x18,%eax
 61d:	cd 30                	int    $0x30
 61f:	c3                   	ret    

00000620 <sleep_cond>:
 620:	b8 19 00 00 00       	mov    $0x19,%eax
 625:	cd 30                	int    $0x30
 627:	c3                   	ret    

00000628 <wake_cond>:
 628:	b8 1a 00 00 00       	mov    $0x1a,%eax
 62d:	cd 30                	int    $0x30
 62f:	c3                   	ret    

00000630 <xchng>:
 630:	b8 1b 00 00 00       	mov    $0x1b,%eax
 635:	cd 30                	int    $0x30
 637:	c3                   	ret    
 638:	90                   	nop    
 639:	90                   	nop    
 63a:	90                   	nop    
 63b:	90                   	nop    
 63c:	90                   	nop    
 63d:	90                   	nop    
 63e:	90                   	nop    
 63f:	90                   	nop    

00000640 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	83 ec 18             	sub    $0x18,%esp
 646:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 649:	8d 55 fc             	lea    -0x4(%ebp),%edx
 64c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 653:	00 
 654:	89 54 24 04          	mov    %edx,0x4(%esp)
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 28 ff ff ff       	call   588 <write>
}
 660:	c9                   	leave  
 661:	c3                   	ret    
 662:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000670 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	89 ce                	mov    %ecx,%esi
 677:	53                   	push   %ebx
 678:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 67e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 681:	85 c9                	test   %ecx,%ecx
 683:	74 04                	je     689 <printint+0x19>
 685:	85 d2                	test   %edx,%edx
 687:	78 54                	js     6dd <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 689:	89 d0                	mov    %edx,%eax
 68b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 692:	31 db                	xor    %ebx,%ebx
 694:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 697:	31 d2                	xor    %edx,%edx
 699:	f7 f6                	div    %esi
 69b:	89 c1                	mov    %eax,%ecx
 69d:	0f b6 82 06 0a 00 00 	movzbl 0xa06(%edx),%eax
 6a4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 6a7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 6aa:	85 c9                	test   %ecx,%ecx
 6ac:	89 c8                	mov    %ecx,%eax
 6ae:	75 e7                	jne    697 <printint+0x27>
  if(neg)
 6b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 6b3:	85 c0                	test   %eax,%eax
 6b5:	74 08                	je     6bf <printint+0x4f>
    buf[i++] = '-';
 6b7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 6bc:	83 c3 01             	add    $0x1,%ebx
 6bf:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 6c2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 6c6:	83 eb 01             	sub    $0x1,%ebx
 6c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 6cc:	e8 6f ff ff ff       	call   640 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6d1:	39 fb                	cmp    %edi,%ebx
 6d3:	75 ed                	jne    6c2 <printint+0x52>
    putc(fd, buf[i]);
}
 6d5:	83 c4 1c             	add    $0x1c,%esp
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5f                   	pop    %edi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6dd:	89 d0                	mov    %edx,%eax
 6df:	f7 d8                	neg    %eax
 6e1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 6e8:	eb a8                	jmp    692 <printint+0x22>
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fc:	0f b6 02             	movzbl (%edx),%eax
 6ff:	84 c0                	test   %al,%al
 701:	0f 84 84 00 00 00    	je     78b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 707:	8d 4d 10             	lea    0x10(%ebp),%ecx
 70a:	89 d7                	mov    %edx,%edi
 70c:	31 f6                	xor    %esi,%esi
 70e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 711:	eb 18                	jmp    72b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 713:	83 fb 25             	cmp    $0x25,%ebx
 716:	75 7b                	jne    793 <printf+0xa3>
 718:	66 be 25 00          	mov    $0x25,%si
 71c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 720:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 724:	83 c7 01             	add    $0x1,%edi
 727:	84 c0                	test   %al,%al
 729:	74 60                	je     78b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 72b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 72d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 730:	74 e1                	je     713 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 732:	83 fe 25             	cmp    $0x25,%esi
 735:	75 e9                	jne    720 <printf+0x30>
      if(c == 'd'){
 737:	83 fb 64             	cmp    $0x64,%ebx
 73a:	0f 84 db 00 00 00    	je     81b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 740:	83 fb 78             	cmp    $0x78,%ebx
 743:	74 5b                	je     7a0 <printf+0xb0>
 745:	83 fb 70             	cmp    $0x70,%ebx
 748:	74 56                	je     7a0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 74a:	83 fb 73             	cmp    $0x73,%ebx
 74d:	8d 76 00             	lea    0x0(%esi),%esi
 750:	74 72                	je     7c4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 752:	83 fb 63             	cmp    $0x63,%ebx
 755:	0f 84 a7 00 00 00    	je     802 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 75b:	83 fb 25             	cmp    $0x25,%ebx
 75e:	66 90                	xchg   %ax,%ax
 760:	0f 84 da 00 00 00    	je     840 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 76e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 770:	e8 cb fe ff ff       	call   640 <putc>
        putc(fd, c);
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	0f be d3             	movsbl %bl,%edx
 77b:	e8 c0 fe ff ff       	call   640 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 780:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 784:	83 c7 01             	add    $0x1,%edi
 787:	84 c0                	test   %al,%al
 789:	75 a0                	jne    72b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 78b:	83 c4 0c             	add    $0xc,%esp
 78e:	5b                   	pop    %ebx
 78f:	5e                   	pop    %esi
 790:	5f                   	pop    %edi
 791:	5d                   	pop    %ebp
 792:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	0f be d3             	movsbl %bl,%edx
 799:	e8 a2 fe ff ff       	call   640 <putc>
 79e:	eb 80                	jmp    720 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 7a8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7b1:	8b 10                	mov    (%eax),%edx
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	e8 b5 fe ff ff       	call   670 <printint>
        ap++;
 7bb:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 7bf:	e9 5c ff ff ff       	jmp    720 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 7c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 7c7:	8b 02                	mov    (%edx),%eax
        ap++;
 7c9:	83 c2 04             	add    $0x4,%edx
 7cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 7cf:	ba ff 09 00 00       	mov    $0x9ff,%edx
 7d4:	85 c0                	test   %eax,%eax
 7d6:	75 26                	jne    7fe <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 7d8:	0f b6 02             	movzbl (%edx),%eax
 7db:	84 c0                	test   %al,%al
 7dd:	74 18                	je     7f7 <printf+0x107>
 7df:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 7e1:	0f be d0             	movsbl %al,%edx
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	e8 54 fe ff ff       	call   640 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ec:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 7f0:	83 c3 01             	add    $0x1,%ebx
 7f3:	84 c0                	test   %al,%al
 7f5:	75 ea                	jne    7e1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7f7:	31 f6                	xor    %esi,%esi
 7f9:	e9 22 ff ff ff       	jmp    720 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 7fe:	89 c2                	mov    %eax,%edx
 800:	eb d6                	jmp    7d8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 802:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 805:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	0f be 11             	movsbl (%ecx),%edx
 80d:	e8 2e fe ff ff       	call   640 <putc>
        ap++;
 812:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 816:	e9 05 ff ff ff       	jmp    720 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 823:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 826:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 08             	mov    0x8(%ebp),%eax
 832:	e8 39 fe ff ff       	call   670 <printint>
        ap++;
 837:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 83b:	e9 e0 fe ff ff       	jmp    720 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	ba 25 00 00 00       	mov    $0x25,%edx
 848:	31 f6                	xor    %esi,%esi
 84a:	e8 f1 fd ff ff       	call   640 <putc>
 84f:	e9 cc fe ff ff       	jmp    720 <printf+0x30>
 854:	90                   	nop    
 855:	90                   	nop    
 856:	90                   	nop    
 857:	90                   	nop    
 858:	90                   	nop    
 859:	90                   	nop    
 85a:	90                   	nop    
 85b:	90                   	nop    
 85c:	90                   	nop    
 85d:	90                   	nop    
 85e:	90                   	nop    
 85f:	90                   	nop    

00000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	8b 0d 30 0a 00 00    	mov    0xa30,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 867:	89 e5                	mov    %esp,%ebp
 869:	56                   	push   %esi
 86a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 86b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 86e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 871:	39 d9                	cmp    %ebx,%ecx
 873:	73 18                	jae    88d <free+0x2d>
 875:	8b 11                	mov    (%ecx),%edx
 877:	39 d3                	cmp    %edx,%ebx
 879:	72 17                	jb     892 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87b:	39 d1                	cmp    %edx,%ecx
 87d:	72 08                	jb     887 <free+0x27>
 87f:	39 d9                	cmp    %ebx,%ecx
 881:	72 0f                	jb     892 <free+0x32>
 883:	39 d3                	cmp    %edx,%ebx
 885:	72 0b                	jb     892 <free+0x32>
 887:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 889:	39 d9                	cmp    %ebx,%ecx
 88b:	72 e8                	jb     875 <free+0x15>
 88d:	8b 11                	mov    (%ecx),%edx
 88f:	90                   	nop    
 890:	eb e9                	jmp    87b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 892:	8b 73 04             	mov    0x4(%ebx),%esi
 895:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 898:	39 d0                	cmp    %edx,%eax
 89a:	74 18                	je     8b4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 89c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 89e:	8b 51 04             	mov    0x4(%ecx),%edx
 8a1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 8a4:	39 d8                	cmp    %ebx,%eax
 8a6:	74 20                	je     8c8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8a8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 8aa:	5b                   	pop    %ebx
 8ab:	5e                   	pop    %esi
 8ac:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 8ad:	89 0d 30 0a 00 00    	mov    %ecx,0xa30
}
 8b3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 8b7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8bc:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8bf:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8c1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 8c4:	39 d8                	cmp    %ebx,%eax
 8c6:	75 e0                	jne    8a8 <free+0x48>
    p->s.size += bp->s.size;
 8c8:	03 53 04             	add    0x4(%ebx),%edx
 8cb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 8ce:	8b 13                	mov    (%ebx),%edx
 8d0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8d2:	5b                   	pop    %ebx
 8d3:	5e                   	pop    %esi
 8d4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 8d5:	89 0d 30 0a 00 00    	mov    %ecx,0xa30
}
 8db:	c3                   	ret    
 8dc:	8d 74 26 00          	lea    0x0(%esi),%esi

000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	53                   	push   %ebx
 8e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ec:	8b 15 30 0a 00 00    	mov    0xa30,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	83 c0 07             	add    $0x7,%eax
 8f5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 8f8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 8fd:	0f 84 8a 00 00 00    	je     98d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 903:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 905:	8b 41 04             	mov    0x4(%ecx),%eax
 908:	39 c3                	cmp    %eax,%ebx
 90a:	76 1a                	jbe    926 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 90c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 913:	3b 0d 30 0a 00 00    	cmp    0xa30,%ecx
 919:	89 ca                	mov    %ecx,%edx
 91b:	74 29                	je     946 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 91f:	8b 41 04             	mov    0x4(%ecx),%eax
 922:	39 c3                	cmp    %eax,%ebx
 924:	77 ed                	ja     913 <malloc+0x33>
      if(p->s.size == nunits)
 926:	39 c3                	cmp    %eax,%ebx
 928:	74 5d                	je     987 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 92a:	29 d8                	sub    %ebx,%eax
 92c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 92f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 932:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 935:	89 15 30 0a 00 00    	mov    %edx,0xa30
      return (void*) (p + 1);
 93b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93e:	83 c4 0c             	add    $0xc,%esp
 941:	5b                   	pop    %ebx
 942:	5e                   	pop    %esi
 943:	5f                   	pop    %edi
 944:	5d                   	pop    %ebp
 945:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 946:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 94c:	89 de                	mov    %ebx,%esi
 94e:	89 f8                	mov    %edi,%eax
 950:	76 29                	jbe    97b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 952:	89 04 24             	mov    %eax,(%esp)
 955:	e8 96 fc ff ff       	call   5f0 <sbrk>
  if(p == (char*) -1)
 95a:	83 f8 ff             	cmp    $0xffffffff,%eax
 95d:	74 18                	je     977 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 95f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 962:	83 c0 08             	add    $0x8,%eax
 965:	89 04 24             	mov    %eax,(%esp)
 968:	e8 f3 fe ff ff       	call   860 <free>
  return freep;
 96d:	8b 15 30 0a 00 00    	mov    0xa30,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 973:	85 d2                	test   %edx,%edx
 975:	75 a6                	jne    91d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 977:	31 c0                	xor    %eax,%eax
 979:	eb c3                	jmp    93e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 97b:	be 00 10 00 00       	mov    $0x1000,%esi
 980:	b8 00 80 00 00       	mov    $0x8000,%eax
 985:	eb cb                	jmp    952 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 987:	8b 01                	mov    (%ecx),%eax
 989:	89 02                	mov    %eax,(%edx)
 98b:	eb a8                	jmp    935 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 98d:	ba 28 0a 00 00       	mov    $0xa28,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 992:	c7 05 30 0a 00 00 28 	movl   $0xa28,0xa30
 999:	0a 00 00 
 99c:	c7 05 28 0a 00 00 28 	movl   $0xa28,0xa28
 9a3:	0a 00 00 
    base.s.size = 0;
 9a6:	c7 05 2c 0a 00 00 00 	movl   $0x0,0xa2c
 9ad:	00 00 00 
 9b0:	e9 4e ff ff ff       	jmp    903 <malloc+0x23>
