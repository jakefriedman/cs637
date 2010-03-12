
_kill:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	83 ec 18             	sub    $0x18,%esp
  10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  13:	8b 19                	mov    (%ecx),%ebx
  15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1e:	8b 71 04             	mov    0x4(%ecx),%esi
  int i;
	
  if(argc < 1){
  21:	85 db                	test   %ebx,%ebx
  23:	7f 19                	jg     3e <main+0x3e>
    printf(2, "usage: kill pid...\n");
  25:	c7 44 24 04 d5 06 00 	movl   $0x6d5,0x4(%esp)
  2c:	00 
  2d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  34:	e8 d7 03 00 00       	call   410 <printf>
    exit();
  39:	e8 4a 02 00 00       	call   288 <exit>
  }
  for(i=1; i<argc; i++)
  3e:	83 fb 01             	cmp    $0x1,%ebx
{
  int i;
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  41:	bf 01 00 00 00       	mov    $0x1,%edi
  }
  for(i=1; i<argc; i++)
  46:	74 1a                	je     62 <main+0x62>
    kill(atoi(argv[i]));
  48:	8b 04 be             	mov    (%esi,%edi,4),%eax
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4b:	83 c7 01             	add    $0x1,%edi
    kill(atoi(argv[i]));
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 1a 01 00 00       	call   170 <atoi>
  56:	89 04 24             	mov    %eax,(%esp)
  59:	e8 5a 02 00 00       	call   2b8 <kill>
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  5e:	39 df                	cmp    %ebx,%edi
  60:	75 e6                	jne    48 <main+0x48>
    kill(atoi(argv[i]));
  exit();
  62:	e8 21 02 00 00       	call   288 <exit>
  67:	90                   	nop    
  68:	90                   	nop    
  69:	90                   	nop    
  6a:	90                   	nop    
  6b:	90                   	nop    
  6c:	90                   	nop    
  6d:	90                   	nop    
  6e:	90                   	nop    
  6f:	90                   	nop    

00000070 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 5d 08             	mov    0x8(%ebp),%ebx
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  7a:	89 da                	mov    %ebx,%edx
  7c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	0f b6 01             	movzbl (%ecx),%eax
  83:	83 c1 01             	add    $0x1,%ecx
  86:	88 02                	mov    %al,(%edx)
  88:	83 c2 01             	add    $0x1,%edx
  8b:	84 c0                	test   %al,%al
  8d:	75 f1                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8f:	89 d8                	mov    %ebx,%eax
  91:	5b                   	pop    %ebx
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    
  94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a6:	53                   	push   %ebx
  a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  aa:	0f b6 01             	movzbl (%ecx),%eax
  ad:	84 c0                	test   %al,%al
  af:	74 24                	je     d5 <strcmp+0x35>
  b1:	0f b6 13             	movzbl (%ebx),%edx
  b4:	38 d0                	cmp    %dl,%al
  b6:	74 12                	je     ca <strcmp+0x2a>
  b8:	eb 1e                	jmp    d8 <strcmp+0x38>
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c0:	0f b6 13             	movzbl (%ebx),%edx
  c3:	83 c1 01             	add    $0x1,%ecx
  c6:	38 d0                	cmp    %dl,%al
  c8:	75 0e                	jne    d8 <strcmp+0x38>
  ca:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  ce:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d1:	84 c0                	test   %al,%al
  d3:	75 eb                	jne    c0 <strcmp+0x20>
  d5:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d8:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d9:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  dc:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  dd:	0f b6 d2             	movzbl %dl,%edx
  e0:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e2:	c3                   	ret    
  e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000f0 <strlen>:

uint
strlen(char *s)
{
  f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  f1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  f3:	89 e5                	mov    %esp,%ebp
  f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f8:	80 39 00             	cmpb   $0x0,(%ecx)
  fb:	74 0e                	je     10b <strlen+0x1b>
  fd:	31 d2                	xor    %edx,%edx
  ff:	90                   	nop    
 100:	83 c2 01             	add    $0x1,%edx
 103:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 107:	89 d0                	mov    %edx,%eax
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 10             	mov    0x10(%ebp),%eax
 116:	53                   	push   %ebx
 117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 11a:	85 c0                	test   %eax,%eax
 11c:	74 10                	je     12e <memset+0x1e>
 11e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 122:	31 d2                	xor    %edx,%edx
    *d++ = c;
 124:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 127:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 12a:	39 c2                	cmp    %eax,%edx
 12c:	75 f6                	jne    124 <memset+0x14>
    *d++ = c;
  return dst;
}
 12e:	89 d8                	mov    %ebx,%eax
 130:	5b                   	pop    %ebx
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 0c                	jne    15d <strchr+0x1d>
 151:	eb 11                	jmp    164 <strchr+0x24>
 153:	83 c0 01             	add    $0x1,%eax
 156:	0f b6 10             	movzbl (%eax),%edx
 159:	84 d2                	test   %dl,%dl
 15b:	74 07                	je     164 <strchr+0x24>
    if(*s == c)
 15d:	38 ca                	cmp    %cl,%dl
 15f:	90                   	nop    
 160:	75 f1                	jne    153 <strchr+0x13>
      return (char*) s;
  return 0;
}
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
 164:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 165:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 167:	c3                   	ret    
 168:	90                   	nop    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000170 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
 176:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 177:	31 db                	xor    %ebx,%ebx
 179:	0f b6 11             	movzbl (%ecx),%edx
 17c:	8d 42 d0             	lea    -0x30(%edx),%eax
 17f:	3c 09                	cmp    $0x9,%al
 181:	77 18                	ja     19b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 183:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 186:	0f be d2             	movsbl %dl,%edx
 189:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 191:	83 c1 01             	add    $0x1,%ecx
 194:	8d 42 d0             	lea    -0x30(%edx),%eax
 197:	3c 09                	cmp    $0x9,%al
 199:	76 e8                	jbe    183 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 19b:	89 d8                	mov    %ebx,%eax
 19d:	5b                   	pop    %ebx
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret    

000001a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a6:	56                   	push   %esi
 1a7:	8b 75 08             	mov    0x8(%ebp),%esi
 1aa:	53                   	push   %ebx
 1ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ae:	85 c9                	test   %ecx,%ecx
 1b0:	7e 10                	jle    1c2 <memmove+0x22>
 1b2:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 1b4:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 1b8:	88 04 32             	mov    %al,(%edx,%esi,1)
 1bb:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1be:	39 ca                	cmp    %ecx,%edx
 1c0:	75 f2                	jne    1b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 1c2:	89 f0                	mov    %esi,%eax
 1c4:	5b                   	pop    %ebx
 1c5:	5e                   	pop    %esi
 1c6:	5d                   	pop    %ebp
 1c7:	c3                   	ret    
 1c8:	90                   	nop    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000001d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1eb:	00 
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 d4 00 00 00       	call   2c8 <open>
  if(fd < 0)
 1f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1f8:	78 19                	js     213 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 1c 24             	mov    %ebx,(%esp)
 200:	89 44 24 04          	mov    %eax,0x4(%esp)
 204:	e8 d7 00 00 00       	call   2e0 <fstat>
  close(fd);
 209:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 20c:	89 c6                	mov    %eax,%esi
  close(fd);
 20e:	e8 9d 00 00 00       	call   2b0 <close>
  return r;
}
 213:	89 f0                	mov    %esi,%eax
 215:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 218:	8b 75 fc             	mov    -0x4(%ebp),%esi
 21b:	89 ec                	mov    %ebp,%esp
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    
 21f:	90                   	nop    

00000220 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	31 f6                	xor    %esi,%esi
 227:	53                   	push   %ebx
 228:	83 ec 1c             	sub    $0x1c,%esp
 22b:	8b 7d 08             	mov    0x8(%ebp),%edi
 22e:	eb 06                	jmp    236 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 230:	3c 0d                	cmp    $0xd,%al
 232:	74 39                	je     26d <gets+0x4d>
 234:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	8d 5e 01             	lea    0x1(%esi),%ebx
 239:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23c:	7d 31                	jge    26f <gets+0x4f>
    cc = read(0, &c, 1);
 23e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 241:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 248:	00 
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 47 00 00 00       	call   2a0 <read>
    if(cc < 1)
 259:	85 c0                	test   %eax,%eax
 25b:	7e 12                	jle    26f <gets+0x4f>
      break;
    buf[i++] = c;
 25d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 261:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 265:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 269:	3c 0a                	cmp    $0xa,%al
 26b:	75 c3                	jne    230 <gets+0x10>
 26d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 26f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 273:	89 f8                	mov    %edi,%eax
 275:	83 c4 1c             	add    $0x1c,%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
 27a:	5f                   	pop    %edi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	90                   	nop    
 27e:	90                   	nop    
 27f:	90                   	nop    

00000280 <fork>:
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 30                	int    $0x30
 287:	c3                   	ret    

00000288 <exit>:
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 30                	int    $0x30
 28f:	c3                   	ret    

00000290 <wait>:
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 30                	int    $0x30
 297:	c3                   	ret    

00000298 <pipe>:
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 30                	int    $0x30
 29f:	c3                   	ret    

000002a0 <read>:
 2a0:	b8 06 00 00 00       	mov    $0x6,%eax
 2a5:	cd 30                	int    $0x30
 2a7:	c3                   	ret    

000002a8 <write>:
 2a8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ad:	cd 30                	int    $0x30
 2af:	c3                   	ret    

000002b0 <close>:
 2b0:	b8 07 00 00 00       	mov    $0x7,%eax
 2b5:	cd 30                	int    $0x30
 2b7:	c3                   	ret    

000002b8 <kill>:
 2b8:	b8 08 00 00 00       	mov    $0x8,%eax
 2bd:	cd 30                	int    $0x30
 2bf:	c3                   	ret    

000002c0 <exec>:
 2c0:	b8 09 00 00 00       	mov    $0x9,%eax
 2c5:	cd 30                	int    $0x30
 2c7:	c3                   	ret    

000002c8 <open>:
 2c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2cd:	cd 30                	int    $0x30
 2cf:	c3                   	ret    

000002d0 <mknod>:
 2d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d5:	cd 30                	int    $0x30
 2d7:	c3                   	ret    

000002d8 <unlink>:
 2d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2dd:	cd 30                	int    $0x30
 2df:	c3                   	ret    

000002e0 <fstat>:
 2e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    

000002e8 <link>:
 2e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ed:	cd 30                	int    $0x30
 2ef:	c3                   	ret    

000002f0 <mkdir>:
 2f0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <chdir>:
 2f8:	b8 10 00 00 00       	mov    $0x10,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <dup>:
 300:	b8 11 00 00 00       	mov    $0x11,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <getpid>:
 308:	b8 12 00 00 00       	mov    $0x12,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <sbrk>:
 310:	b8 13 00 00 00       	mov    $0x13,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <sleep>:
 318:	b8 14 00 00 00       	mov    $0x14,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <tick>:
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <fork_tickets>:
 328:	b8 16 00 00 00       	mov    $0x16,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <fork_thread>:
 330:	b8 17 00 00 00       	mov    $0x17,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <wait_thread>:
 338:	b8 18 00 00 00       	mov    $0x18,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <sleep_cond>:
 340:	b8 19 00 00 00       	mov    $0x19,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <wake_cond>:
 348:	b8 1a 00 00 00       	mov    $0x1a,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <xchng>:
 350:	b8 1b 00 00 00       	mov    $0x1b,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <check>:
 358:	b8 1c 00 00 00       	mov    $0x1c,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 18             	sub    $0x18,%esp
 366:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 369:	8d 55 fc             	lea    -0x4(%ebp),%edx
 36c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 373:	00 
 374:	89 54 24 04          	mov    %edx,0x4(%esp)
 378:	89 04 24             	mov    %eax,(%esp)
 37b:	e8 28 ff ff ff       	call   2a8 <write>
}
 380:	c9                   	leave  
 381:	c3                   	ret    
 382:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	89 ce                	mov    %ecx,%esi
 397:	53                   	push   %ebx
 398:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a1:	85 c9                	test   %ecx,%ecx
 3a3:	74 04                	je     3a9 <printint+0x19>
 3a5:	85 d2                	test   %edx,%edx
 3a7:	78 54                	js     3fd <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 3b2:	31 db                	xor    %ebx,%ebx
 3b4:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3b7:	31 d2                	xor    %edx,%edx
 3b9:	f7 f6                	div    %esi
 3bb:	89 c1                	mov    %eax,%ecx
 3bd:	0f b6 82 f0 06 00 00 	movzbl 0x6f0(%edx),%eax
 3c4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 3c7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 3ca:	85 c9                	test   %ecx,%ecx
 3cc:	89 c8                	mov    %ecx,%eax
 3ce:	75 e7                	jne    3b7 <printint+0x27>
  if(neg)
 3d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3d3:	85 c0                	test   %eax,%eax
 3d5:	74 08                	je     3df <printint+0x4f>
    buf[i++] = '-';
 3d7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 3dc:	83 c3 01             	add    $0x1,%ebx
 3df:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3e2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 3e6:	83 eb 01             	sub    $0x1,%ebx
 3e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3ec:	e8 6f ff ff ff       	call   360 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f1:	39 fb                	cmp    %edi,%ebx
 3f3:	75 ed                	jne    3e2 <printint+0x52>
    putc(fd, buf[i]);
}
 3f5:	83 c4 1c             	add    $0x1c,%esp
 3f8:	5b                   	pop    %ebx
 3f9:	5e                   	pop    %esi
 3fa:	5f                   	pop    %edi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3fd:	89 d0                	mov    %edx,%eax
 3ff:	f7 d8                	neg    %eax
 401:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 408:	eb a8                	jmp    3b2 <printint+0x22>
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000410 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 55 0c             	mov    0xc(%ebp),%edx
 41c:	0f b6 02             	movzbl (%edx),%eax
 41f:	84 c0                	test   %al,%al
 421:	0f 84 84 00 00 00    	je     4ab <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 4d 10             	lea    0x10(%ebp),%ecx
 42a:	89 d7                	mov    %edx,%edi
 42c:	31 f6                	xor    %esi,%esi
 42e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 431:	eb 18                	jmp    44b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 433:	83 fb 25             	cmp    $0x25,%ebx
 436:	75 7b                	jne    4b3 <printf+0xa3>
 438:	66 be 25 00          	mov    $0x25,%si
 43c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 440:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 444:	83 c7 01             	add    $0x1,%edi
 447:	84 c0                	test   %al,%al
 449:	74 60                	je     4ab <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 44b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 44d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 450:	74 e1                	je     433 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 452:	83 fe 25             	cmp    $0x25,%esi
 455:	75 e9                	jne    440 <printf+0x30>
      if(c == 'd'){
 457:	83 fb 64             	cmp    $0x64,%ebx
 45a:	0f 84 db 00 00 00    	je     53b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 460:	83 fb 78             	cmp    $0x78,%ebx
 463:	74 5b                	je     4c0 <printf+0xb0>
 465:	83 fb 70             	cmp    $0x70,%ebx
 468:	74 56                	je     4c0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46a:	83 fb 73             	cmp    $0x73,%ebx
 46d:	8d 76 00             	lea    0x0(%esi),%esi
 470:	74 72                	je     4e4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 472:	83 fb 63             	cmp    $0x63,%ebx
 475:	0f 84 a7 00 00 00    	je     522 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47b:	83 fb 25             	cmp    $0x25,%ebx
 47e:	66 90                	xchg   %ax,%ax
 480:	0f 84 da 00 00 00    	je     560 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 48e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 490:	e8 cb fe ff ff       	call   360 <putc>
        putc(fd, c);
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	0f be d3             	movsbl %bl,%edx
 49b:	e8 c0 fe ff ff       	call   360 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4a4:	83 c7 01             	add    $0x1,%edi
 4a7:	84 c0                	test   %al,%al
 4a9:	75 a0                	jne    44b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4ab:	83 c4 0c             	add    $0xc,%esp
 4ae:	5b                   	pop    %ebx
 4af:	5e                   	pop    %esi
 4b0:	5f                   	pop    %edi
 4b1:	5d                   	pop    %ebp
 4b2:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	0f be d3             	movsbl %bl,%edx
 4b9:	e8 a2 fe ff ff       	call   360 <putc>
 4be:	eb 80                	jmp    440 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4c8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4d1:	8b 10                	mov    (%eax),%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	e8 b5 fe ff ff       	call   390 <printint>
        ap++;
 4db:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4df:	e9 5c ff ff ff       	jmp    440 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 4e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 4e7:	8b 02                	mov    (%edx),%eax
        ap++;
 4e9:	83 c2 04             	add    $0x4,%edx
 4ec:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 4ef:	ba e9 06 00 00       	mov    $0x6e9,%edx
 4f4:	85 c0                	test   %eax,%eax
 4f6:	75 26                	jne    51e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 4f8:	0f b6 02             	movzbl (%edx),%eax
 4fb:	84 c0                	test   %al,%al
 4fd:	74 18                	je     517 <printf+0x107>
 4ff:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 501:	0f be d0             	movsbl %al,%edx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	e8 54 fe ff ff       	call   360 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 50c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 510:	83 c3 01             	add    $0x1,%ebx
 513:	84 c0                	test   %al,%al
 515:	75 ea                	jne    501 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 517:	31 f6                	xor    %esi,%esi
 519:	e9 22 ff ff ff       	jmp    440 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 51e:	89 c2                	mov    %eax,%edx
 520:	eb d6                	jmp    4f8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 522:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 525:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	0f be 11             	movsbl (%ecx),%edx
 52d:	e8 2e fe ff ff       	call   360 <putc>
        ap++;
 532:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 536:	e9 05 ff ff ff       	jmp    440 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 53b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 53e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 543:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 546:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 54d:	8b 10                	mov    (%eax),%edx
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	e8 39 fe ff ff       	call   390 <printint>
        ap++;
 557:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 55b:	e9 e0 fe ff ff       	jmp    440 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	ba 25 00 00 00       	mov    $0x25,%edx
 568:	31 f6                	xor    %esi,%esi
 56a:	e8 f1 fd ff ff       	call   360 <putc>
 56f:	e9 cc fe ff ff       	jmp    440 <printf+0x30>
 574:	90                   	nop    
 575:	90                   	nop    
 576:	90                   	nop    
 577:	90                   	nop    
 578:	90                   	nop    
 579:	90                   	nop    
 57a:	90                   	nop    
 57b:	90                   	nop    
 57c:	90                   	nop    
 57d:	90                   	nop    
 57e:	90                   	nop    
 57f:	90                   	nop    

00000580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	8b 0d 0c 07 00 00    	mov    0x70c,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 587:	89 e5                	mov    %esp,%ebp
 589:	56                   	push   %esi
 58a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 58e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	39 d9                	cmp    %ebx,%ecx
 593:	73 18                	jae    5ad <free+0x2d>
 595:	8b 11                	mov    (%ecx),%edx
 597:	39 d3                	cmp    %edx,%ebx
 599:	72 17                	jb     5b2 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59b:	39 d1                	cmp    %edx,%ecx
 59d:	72 08                	jb     5a7 <free+0x27>
 59f:	39 d9                	cmp    %ebx,%ecx
 5a1:	72 0f                	jb     5b2 <free+0x32>
 5a3:	39 d3                	cmp    %edx,%ebx
 5a5:	72 0b                	jb     5b2 <free+0x32>
 5a7:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a9:	39 d9                	cmp    %ebx,%ecx
 5ab:	72 e8                	jb     595 <free+0x15>
 5ad:	8b 11                	mov    (%ecx),%edx
 5af:	90                   	nop    
 5b0:	eb e9                	jmp    59b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b2:	8b 73 04             	mov    0x4(%ebx),%esi
 5b5:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 5b8:	39 d0                	cmp    %edx,%eax
 5ba:	74 18                	je     5d4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5bc:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 5be:	8b 51 04             	mov    0x4(%ecx),%edx
 5c1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5c4:	39 d8                	cmp    %ebx,%eax
 5c6:	74 20                	je     5e8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5c8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5cd:	89 0d 0c 07 00 00    	mov    %ecx,0x70c
}
 5d3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5d4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 5d7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5d9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5dc:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5df:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5e1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5e4:	39 d8                	cmp    %ebx,%eax
 5e6:	75 e0                	jne    5c8 <free+0x48>
    p->s.size += bp->s.size;
 5e8:	03 53 04             	add    0x4(%ebx),%edx
 5eb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 5ee:	8b 13                	mov    (%ebx),%edx
 5f0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5f2:	5b                   	pop    %ebx
 5f3:	5e                   	pop    %esi
 5f4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5f5:	89 0d 0c 07 00 00    	mov    %ecx,0x70c
}
 5fb:	c3                   	ret    
 5fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00000600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 609:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 60c:	8b 15 0c 07 00 00    	mov    0x70c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 612:	83 c0 07             	add    $0x7,%eax
 615:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 618:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 61a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 61d:	0f 84 8a 00 00 00    	je     6ad <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 623:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 625:	8b 41 04             	mov    0x4(%ecx),%eax
 628:	39 c3                	cmp    %eax,%ebx
 62a:	76 1a                	jbe    646 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 62c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 633:	3b 0d 0c 07 00 00    	cmp    0x70c,%ecx
 639:	89 ca                	mov    %ecx,%edx
 63b:	74 29                	je     666 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 63f:	8b 41 04             	mov    0x4(%ecx),%eax
 642:	39 c3                	cmp    %eax,%ebx
 644:	77 ed                	ja     633 <malloc+0x33>
      if(p->s.size == nunits)
 646:	39 c3                	cmp    %eax,%ebx
 648:	74 5d                	je     6a7 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64a:	29 d8                	sub    %ebx,%eax
 64c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 64f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 652:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 655:	89 15 0c 07 00 00    	mov    %edx,0x70c
      return (void*) (p + 1);
 65b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 65e:	83 c4 0c             	add    $0xc,%esp
 661:	5b                   	pop    %ebx
 662:	5e                   	pop    %esi
 663:	5f                   	pop    %edi
 664:	5d                   	pop    %ebp
 665:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 666:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 66c:	89 de                	mov    %ebx,%esi
 66e:	89 f8                	mov    %edi,%eax
 670:	76 29                	jbe    69b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 96 fc ff ff       	call   310 <sbrk>
  if(p == (char*) -1)
 67a:	83 f8 ff             	cmp    $0xffffffff,%eax
 67d:	74 18                	je     697 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 67f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 682:	83 c0 08             	add    $0x8,%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 f3 fe ff ff       	call   580 <free>
  return freep;
 68d:	8b 15 0c 07 00 00    	mov    0x70c,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 693:	85 d2                	test   %edx,%edx
 695:	75 a6                	jne    63d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 697:	31 c0                	xor    %eax,%eax
 699:	eb c3                	jmp    65e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 69b:	be 00 10 00 00       	mov    $0x1000,%esi
 6a0:	b8 00 80 00 00       	mov    $0x8000,%eax
 6a5:	eb cb                	jmp    672 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6a7:	8b 01                	mov    (%ecx),%eax
 6a9:	89 02                	mov    %eax,(%edx)
 6ab:	eb a8                	jmp    655 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 6ad:	ba 04 07 00 00       	mov    $0x704,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6b2:	c7 05 0c 07 00 00 04 	movl   $0x704,0x70c
 6b9:	07 00 00 
 6bc:	c7 05 04 07 00 00 04 	movl   $0x704,0x704
 6c3:	07 00 00 
    base.s.size = 0;
 6c6:	c7 05 08 07 00 00 00 	movl   $0x0,0x708
 6cd:	00 00 00 
 6d0:	e9 4e ff ff ff       	jmp    623 <malloc+0x23>
