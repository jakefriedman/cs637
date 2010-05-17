
_zombie:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 2a 02 00 00       	call   240 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0c                	jle    26 <main+0x26>
    sleep(5);  // Let child exit before parent.
  1a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  21:	e8 b2 02 00 00       	call   2d8 <sleep>
  exit();
  26:	e8 1d 02 00 00       	call   248 <exit>
  2b:	90                   	nop    
  2c:	90                   	nop    
  2d:	90                   	nop    
  2e:	90                   	nop    
  2f:	90                   	nop    

00000030 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 5d 08             	mov    0x8(%ebp),%ebx
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  3a:	89 da                	mov    %ebx,%edx
  3c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  40:	0f b6 01             	movzbl (%ecx),%eax
  43:	83 c1 01             	add    $0x1,%ecx
  46:	88 02                	mov    %al,(%edx)
  48:	83 c2 01             	add    $0x1,%edx
  4b:	84 c0                	test   %al,%al
  4d:	75 f1                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4f:	89 d8                	mov    %ebx,%eax
  51:	5b                   	pop    %ebx
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    
  54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  66:	53                   	push   %ebx
  67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  6a:	0f b6 01             	movzbl (%ecx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	74 24                	je     95 <strcmp+0x35>
  71:	0f b6 13             	movzbl (%ebx),%edx
  74:	38 d0                	cmp    %dl,%al
  76:	74 12                	je     8a <strcmp+0x2a>
  78:	eb 1e                	jmp    98 <strcmp+0x38>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	0f b6 13             	movzbl (%ebx),%edx
  83:	83 c1 01             	add    $0x1,%ecx
  86:	38 d0                	cmp    %dl,%al
  88:	75 0e                	jne    98 <strcmp+0x38>
  8a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  8e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  91:	84 c0                	test   %al,%al
  93:	75 eb                	jne    80 <strcmp+0x20>
  95:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  98:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  99:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  9c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9d:	0f b6 d2             	movzbl %dl,%edx
  a0:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  a2:	c3                   	ret    
  a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000b0 <strlen>:

uint
strlen(char *s)
{
  b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  b1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  b3:	89 e5                	mov    %esp,%ebp
  b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b8:	80 39 00             	cmpb   $0x0,(%ecx)
  bb:	74 0e                	je     cb <strlen+0x1b>
  bd:	31 d2                	xor    %edx,%edx
  bf:	90                   	nop    
  c0:	83 c2 01             	add    $0x1,%edx
  c3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
  c7:	89 d0                	mov    %edx,%eax
  c9:	75 f5                	jne    c0 <strlen+0x10>
    ;
  return n;
}
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 10             	mov    0x10(%ebp),%eax
  d6:	53                   	push   %ebx
  d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
  da:	85 c0                	test   %eax,%eax
  dc:	74 10                	je     ee <memset+0x1e>
  de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  e2:	31 d2                	xor    %edx,%edx
    *d++ = c;
  e4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  e7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
  ea:	39 c2                	cmp    %eax,%edx
  ec:	75 f6                	jne    e4 <memset+0x14>
    *d++ = c;
  return dst;
}
  ee:	89 d8                	mov    %ebx,%eax
  f0:	5b                   	pop    %ebx
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	75 0c                	jne    11d <strchr+0x1d>
 111:	eb 11                	jmp    124 <strchr+0x24>
 113:	83 c0 01             	add    $0x1,%eax
 116:	0f b6 10             	movzbl (%eax),%edx
 119:	84 d2                	test   %dl,%dl
 11b:	74 07                	je     124 <strchr+0x24>
    if(*s == c)
 11d:	38 ca                	cmp    %cl,%dl
 11f:	90                   	nop    
 120:	75 f1                	jne    113 <strchr+0x13>
      return (char*) s;
  return 0;
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    
 124:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 125:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 127:	c3                   	ret    
 128:	90                   	nop    
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000130 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
 136:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 137:	31 db                	xor    %ebx,%ebx
 139:	0f b6 11             	movzbl (%ecx),%edx
 13c:	8d 42 d0             	lea    -0x30(%edx),%eax
 13f:	3c 09                	cmp    $0x9,%al
 141:	77 18                	ja     15b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 143:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 146:	0f be d2             	movsbl %dl,%edx
 149:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 14d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 151:	83 c1 01             	add    $0x1,%ecx
 154:	8d 42 d0             	lea    -0x30(%edx),%eax
 157:	3c 09                	cmp    $0x9,%al
 159:	76 e8                	jbe    143 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 15b:	89 d8                	mov    %ebx,%eax
 15d:	5b                   	pop    %ebx
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 10             	mov    0x10(%ebp),%ecx
 166:	56                   	push   %esi
 167:	8b 75 08             	mov    0x8(%ebp),%esi
 16a:	53                   	push   %ebx
 16b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 16e:	85 c9                	test   %ecx,%ecx
 170:	7e 10                	jle    182 <memmove+0x22>
 172:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 174:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 178:	88 04 32             	mov    %al,(%edx,%esi,1)
 17b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 17e:	39 ca                	cmp    %ecx,%edx
 180:	75 f2                	jne    174 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 182:	89 f0                	mov    %esi,%eax
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    
 188:	90                   	nop    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000190 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 199:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 19c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 19f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ab:	00 
 1ac:	89 04 24             	mov    %eax,(%esp)
 1af:	e8 d4 00 00 00       	call   288 <open>
  if(fd < 0)
 1b4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1b8:	78 19                	js     1d3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 1c 24             	mov    %ebx,(%esp)
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	e8 d7 00 00 00       	call   2a0 <fstat>
  close(fd);
 1c9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1cc:	89 c6                	mov    %eax,%esi
  close(fd);
 1ce:	e8 9d 00 00 00       	call   270 <close>
  return r;
}
 1d3:	89 f0                	mov    %esi,%eax
 1d5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 1d8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 1db:	89 ec                	mov    %ebp,%esp
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    
 1df:	90                   	nop    

000001e0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	31 f6                	xor    %esi,%esi
 1e7:	53                   	push   %ebx
 1e8:	83 ec 1c             	sub    $0x1c,%esp
 1eb:	8b 7d 08             	mov    0x8(%ebp),%edi
 1ee:	eb 06                	jmp    1f6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f0:	3c 0d                	cmp    $0xd,%al
 1f2:	74 39                	je     22d <gets+0x4d>
 1f4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	8d 5e 01             	lea    0x1(%esi),%ebx
 1f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1fc:	7d 31                	jge    22f <gets+0x4f>
    cc = read(0, &c, 1);
 1fe:	8d 45 f3             	lea    -0xd(%ebp),%eax
 201:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 208:	00 
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 214:	e8 47 00 00 00       	call   260 <read>
    if(cc < 1)
 219:	85 c0                	test   %eax,%eax
 21b:	7e 12                	jle    22f <gets+0x4f>
      break;
    buf[i++] = c;
 21d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 221:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 225:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 229:	3c 0a                	cmp    $0xa,%al
 22b:	75 c3                	jne    1f0 <gets+0x10>
 22d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 22f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 233:	89 f8                	mov    %edi,%eax
 235:	83 c4 1c             	add    $0x1c,%esp
 238:	5b                   	pop    %ebx
 239:	5e                   	pop    %esi
 23a:	5f                   	pop    %edi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	90                   	nop    
 23e:	90                   	nop    
 23f:	90                   	nop    

00000240 <fork>:
 240:	b8 01 00 00 00       	mov    $0x1,%eax
 245:	cd 30                	int    $0x30
 247:	c3                   	ret    

00000248 <exit>:
 248:	b8 02 00 00 00       	mov    $0x2,%eax
 24d:	cd 30                	int    $0x30
 24f:	c3                   	ret    

00000250 <wait>:
 250:	b8 03 00 00 00       	mov    $0x3,%eax
 255:	cd 30                	int    $0x30
 257:	c3                   	ret    

00000258 <pipe>:
 258:	b8 04 00 00 00       	mov    $0x4,%eax
 25d:	cd 30                	int    $0x30
 25f:	c3                   	ret    

00000260 <read>:
 260:	b8 06 00 00 00       	mov    $0x6,%eax
 265:	cd 30                	int    $0x30
 267:	c3                   	ret    

00000268 <write>:
 268:	b8 05 00 00 00       	mov    $0x5,%eax
 26d:	cd 30                	int    $0x30
 26f:	c3                   	ret    

00000270 <close>:
 270:	b8 07 00 00 00       	mov    $0x7,%eax
 275:	cd 30                	int    $0x30
 277:	c3                   	ret    

00000278 <kill>:
 278:	b8 08 00 00 00       	mov    $0x8,%eax
 27d:	cd 30                	int    $0x30
 27f:	c3                   	ret    

00000280 <exec>:
 280:	b8 09 00 00 00       	mov    $0x9,%eax
 285:	cd 30                	int    $0x30
 287:	c3                   	ret    

00000288 <open>:
 288:	b8 0a 00 00 00       	mov    $0xa,%eax
 28d:	cd 30                	int    $0x30
 28f:	c3                   	ret    

00000290 <mknod>:
 290:	b8 0b 00 00 00       	mov    $0xb,%eax
 295:	cd 30                	int    $0x30
 297:	c3                   	ret    

00000298 <unlink>:
 298:	b8 0c 00 00 00       	mov    $0xc,%eax
 29d:	cd 30                	int    $0x30
 29f:	c3                   	ret    

000002a0 <fstat>:
 2a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a5:	cd 30                	int    $0x30
 2a7:	c3                   	ret    

000002a8 <link>:
 2a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ad:	cd 30                	int    $0x30
 2af:	c3                   	ret    

000002b0 <mkdir>:
 2b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b5:	cd 30                	int    $0x30
 2b7:	c3                   	ret    

000002b8 <chdir>:
 2b8:	b8 10 00 00 00       	mov    $0x10,%eax
 2bd:	cd 30                	int    $0x30
 2bf:	c3                   	ret    

000002c0 <dup>:
 2c0:	b8 11 00 00 00       	mov    $0x11,%eax
 2c5:	cd 30                	int    $0x30
 2c7:	c3                   	ret    

000002c8 <getpid>:
 2c8:	b8 12 00 00 00       	mov    $0x12,%eax
 2cd:	cd 30                	int    $0x30
 2cf:	c3                   	ret    

000002d0 <sbrk>:
 2d0:	b8 13 00 00 00       	mov    $0x13,%eax
 2d5:	cd 30                	int    $0x30
 2d7:	c3                   	ret    

000002d8 <sleep>:
 2d8:	b8 14 00 00 00       	mov    $0x14,%eax
 2dd:	cd 30                	int    $0x30
 2df:	c3                   	ret    

000002e0 <kalloctest>:
 2e0:	b8 15 00 00 00       	mov    $0x15,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    
 2e8:	90                   	nop    
 2e9:	90                   	nop    
 2ea:	90                   	nop    
 2eb:	90                   	nop    
 2ec:	90                   	nop    
 2ed:	90                   	nop    
 2ee:	90                   	nop    
 2ef:	90                   	nop    

000002f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 18             	sub    $0x18,%esp
 2f6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 2f9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 2fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 303:	00 
 304:	89 54 24 04          	mov    %edx,0x4(%esp)
 308:	89 04 24             	mov    %eax,(%esp)
 30b:	e8 58 ff ff ff       	call   268 <write>
}
 310:	c9                   	leave  
 311:	c3                   	ret    
 312:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000320 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	89 ce                	mov    %ecx,%esi
 327:	53                   	push   %ebx
 328:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 32e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 331:	85 c9                	test   %ecx,%ecx
 333:	74 04                	je     339 <printint+0x19>
 335:	85 d2                	test   %edx,%edx
 337:	78 54                	js     38d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 339:	89 d0                	mov    %edx,%eax
 33b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 342:	31 db                	xor    %ebx,%ebx
 344:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 347:	31 d2                	xor    %edx,%edx
 349:	f7 f6                	div    %esi
 34b:	89 c1                	mov    %eax,%ecx
 34d:	0f b6 82 6c 06 00 00 	movzbl 0x66c(%edx),%eax
 354:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 357:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 35a:	85 c9                	test   %ecx,%ecx
 35c:	89 c8                	mov    %ecx,%eax
 35e:	75 e7                	jne    347 <printint+0x27>
  if(neg)
 360:	8b 45 e0             	mov    -0x20(%ebp),%eax
 363:	85 c0                	test   %eax,%eax
 365:	74 08                	je     36f <printint+0x4f>
    buf[i++] = '-';
 367:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 36c:	83 c3 01             	add    $0x1,%ebx
 36f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 372:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 376:	83 eb 01             	sub    $0x1,%ebx
 379:	8b 45 dc             	mov    -0x24(%ebp),%eax
 37c:	e8 6f ff ff ff       	call   2f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 381:	39 fb                	cmp    %edi,%ebx
 383:	75 ed                	jne    372 <printint+0x52>
    putc(fd, buf[i]);
}
 385:	83 c4 1c             	add    $0x1c,%esp
 388:	5b                   	pop    %ebx
 389:	5e                   	pop    %esi
 38a:	5f                   	pop    %edi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 38d:	89 d0                	mov    %edx,%eax
 38f:	f7 d8                	neg    %eax
 391:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 398:	eb a8                	jmp    342 <printint+0x22>
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3ac:	0f b6 02             	movzbl (%edx),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	0f 84 84 00 00 00    	je     43b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ba:	89 d7                	mov    %edx,%edi
 3bc:	31 f6                	xor    %esi,%esi
 3be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 3c1:	eb 18                	jmp    3db <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3c3:	83 fb 25             	cmp    $0x25,%ebx
 3c6:	75 7b                	jne    443 <printf+0xa3>
 3c8:	66 be 25 00          	mov    $0x25,%si
 3cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 3d4:	83 c7 01             	add    $0x1,%edi
 3d7:	84 c0                	test   %al,%al
 3d9:	74 60                	je     43b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 3db:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3dd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 3e0:	74 e1                	je     3c3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3e2:	83 fe 25             	cmp    $0x25,%esi
 3e5:	75 e9                	jne    3d0 <printf+0x30>
      if(c == 'd'){
 3e7:	83 fb 64             	cmp    $0x64,%ebx
 3ea:	0f 84 db 00 00 00    	je     4cb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3f0:	83 fb 78             	cmp    $0x78,%ebx
 3f3:	74 5b                	je     450 <printf+0xb0>
 3f5:	83 fb 70             	cmp    $0x70,%ebx
 3f8:	74 56                	je     450 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3fa:	83 fb 73             	cmp    $0x73,%ebx
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
 400:	74 72                	je     474 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 402:	83 fb 63             	cmp    $0x63,%ebx
 405:	0f 84 a7 00 00 00    	je     4b2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 40b:	83 fb 25             	cmp    $0x25,%ebx
 40e:	66 90                	xchg   %ax,%ax
 410:	0f 84 da 00 00 00    	je     4f0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 41e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 420:	e8 cb fe ff ff       	call   2f0 <putc>
        putc(fd, c);
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	0f be d3             	movsbl %bl,%edx
 42b:	e8 c0 fe ff ff       	call   2f0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 430:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 434:	83 c7 01             	add    $0x1,%edi
 437:	84 c0                	test   %al,%al
 439:	75 a0                	jne    3db <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 43b:	83 c4 0c             	add    $0xc,%esp
 43e:	5b                   	pop    %ebx
 43f:	5e                   	pop    %esi
 440:	5f                   	pop    %edi
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 443:	8b 45 08             	mov    0x8(%ebp),%eax
 446:	0f be d3             	movsbl %bl,%edx
 449:	e8 a2 fe ff ff       	call   2f0 <putc>
 44e:	eb 80                	jmp    3d0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 450:	8b 45 f0             	mov    -0x10(%ebp),%eax
 453:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 458:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 45a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 461:	8b 10                	mov    (%eax),%edx
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	e8 b5 fe ff ff       	call   320 <printint>
        ap++;
 46b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 46f:	e9 5c ff ff ff       	jmp    3d0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 474:	8b 55 f0             	mov    -0x10(%ebp),%edx
 477:	8b 02                	mov    (%edx),%eax
        ap++;
 479:	83 c2 04             	add    $0x4,%edx
 47c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 47f:	ba 65 06 00 00       	mov    $0x665,%edx
 484:	85 c0                	test   %eax,%eax
 486:	75 26                	jne    4ae <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 488:	0f b6 02             	movzbl (%edx),%eax
 48b:	84 c0                	test   %al,%al
 48d:	74 18                	je     4a7 <printf+0x107>
 48f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 491:	0f be d0             	movsbl %al,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 54 fe ff ff       	call   2f0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 49c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 4a0:	83 c3 01             	add    $0x1,%ebx
 4a3:	84 c0                	test   %al,%al
 4a5:	75 ea                	jne    491 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4a7:	31 f6                	xor    %esi,%esi
 4a9:	e9 22 ff ff ff       	jmp    3d0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4ae:	89 c2                	mov    %eax,%edx
 4b0:	eb d6                	jmp    488 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 4b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 4b5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	0f be 11             	movsbl (%ecx),%edx
 4bd:	e8 2e fe ff ff       	call   2f0 <putc>
        ap++;
 4c2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4c6:	e9 05 ff ff ff       	jmp    3d0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 4d3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 4d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4dd:	8b 10                	mov    (%eax),%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	e8 39 fe ff ff       	call   320 <printint>
        ap++;
 4e7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4eb:	e9 e0 fe ff ff       	jmp    3d0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	ba 25 00 00 00       	mov    $0x25,%edx
 4f8:	31 f6                	xor    %esi,%esi
 4fa:	e8 f1 fd ff ff       	call   2f0 <putc>
 4ff:	e9 cc fe ff ff       	jmp    3d0 <printf+0x30>
 504:	90                   	nop    
 505:	90                   	nop    
 506:	90                   	nop    
 507:	90                   	nop    
 508:	90                   	nop    
 509:	90                   	nop    
 50a:	90                   	nop    
 50b:	90                   	nop    
 50c:	90                   	nop    
 50d:	90                   	nop    
 50e:	90                   	nop    
 50f:	90                   	nop    

00000510 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 510:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 511:	8b 0d 88 06 00 00    	mov    0x688,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 517:	89 e5                	mov    %esp,%ebp
 519:	56                   	push   %esi
 51a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 51b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 51e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 521:	39 d9                	cmp    %ebx,%ecx
 523:	73 18                	jae    53d <free+0x2d>
 525:	8b 11                	mov    (%ecx),%edx
 527:	39 d3                	cmp    %edx,%ebx
 529:	72 17                	jb     542 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52b:	39 d1                	cmp    %edx,%ecx
 52d:	72 08                	jb     537 <free+0x27>
 52f:	39 d9                	cmp    %ebx,%ecx
 531:	72 0f                	jb     542 <free+0x32>
 533:	39 d3                	cmp    %edx,%ebx
 535:	72 0b                	jb     542 <free+0x32>
 537:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 539:	39 d9                	cmp    %ebx,%ecx
 53b:	72 e8                	jb     525 <free+0x15>
 53d:	8b 11                	mov    (%ecx),%edx
 53f:	90                   	nop    
 540:	eb e9                	jmp    52b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 542:	8b 73 04             	mov    0x4(%ebx),%esi
 545:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 548:	39 d0                	cmp    %edx,%eax
 54a:	74 18                	je     564 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 54c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 54e:	8b 51 04             	mov    0x4(%ecx),%edx
 551:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 554:	39 d8                	cmp    %ebx,%eax
 556:	74 20                	je     578 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 558:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 55a:	5b                   	pop    %ebx
 55b:	5e                   	pop    %esi
 55c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 55d:	89 0d 88 06 00 00    	mov    %ecx,0x688
}
 563:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 564:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 567:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 569:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 56c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 56f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 571:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 574:	39 d8                	cmp    %ebx,%eax
 576:	75 e0                	jne    558 <free+0x48>
    p->s.size += bp->s.size;
 578:	03 53 04             	add    0x4(%ebx),%edx
 57b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 57e:	8b 13                	mov    (%ebx),%edx
 580:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 582:	5b                   	pop    %ebx
 583:	5e                   	pop    %esi
 584:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 585:	89 0d 88 06 00 00    	mov    %ecx,0x688
}
 58b:	c3                   	ret    
 58c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000590 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 599:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 59c:	8b 15 88 06 00 00    	mov    0x688,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a2:	83 c0 07             	add    $0x7,%eax
 5a5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 5a8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5aa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 5ad:	0f 84 8a 00 00 00    	je     63d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 5b5:	8b 41 04             	mov    0x4(%ecx),%eax
 5b8:	39 c3                	cmp    %eax,%ebx
 5ba:	76 1a                	jbe    5d6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 5bc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 5c3:	3b 0d 88 06 00 00    	cmp    0x688,%ecx
 5c9:	89 ca                	mov    %ecx,%edx
 5cb:	74 29                	je     5f6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5cd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 5cf:	8b 41 04             	mov    0x4(%ecx),%eax
 5d2:	39 c3                	cmp    %eax,%ebx
 5d4:	77 ed                	ja     5c3 <malloc+0x33>
      if(p->s.size == nunits)
 5d6:	39 c3                	cmp    %eax,%ebx
 5d8:	74 5d                	je     637 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5da:	29 d8                	sub    %ebx,%eax
 5dc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 5df:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 5e2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 5e5:	89 15 88 06 00 00    	mov    %edx,0x688
      return (void*) (p + 1);
 5eb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ee:	83 c4 0c             	add    $0xc,%esp
 5f1:	5b                   	pop    %ebx
 5f2:	5e                   	pop    %esi
 5f3:	5f                   	pop    %edi
 5f4:	5d                   	pop    %ebp
 5f5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 5f6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 5fc:	89 de                	mov    %ebx,%esi
 5fe:	89 f8                	mov    %edi,%eax
 600:	76 29                	jbe    62b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 602:	89 04 24             	mov    %eax,(%esp)
 605:	e8 c6 fc ff ff       	call   2d0 <sbrk>
  if(p == (char*) -1)
 60a:	83 f8 ff             	cmp    $0xffffffff,%eax
 60d:	74 18                	je     627 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 60f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 612:	83 c0 08             	add    $0x8,%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 f3 fe ff ff       	call   510 <free>
  return freep;
 61d:	8b 15 88 06 00 00    	mov    0x688,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 623:	85 d2                	test   %edx,%edx
 625:	75 a6                	jne    5cd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 627:	31 c0                	xor    %eax,%eax
 629:	eb c3                	jmp    5ee <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 62b:	be 00 10 00 00       	mov    $0x1000,%esi
 630:	b8 00 80 00 00       	mov    $0x8000,%eax
 635:	eb cb                	jmp    602 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 637:	8b 01                	mov    (%ecx),%eax
 639:	89 02                	mov    %eax,(%edx)
 63b:	eb a8                	jmp    5e5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 63d:	ba 80 06 00 00       	mov    $0x680,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 642:	c7 05 88 06 00 00 80 	movl   $0x680,0x688
 649:	06 00 00 
 64c:	c7 05 80 06 00 00 80 	movl   $0x680,0x680
 653:	06 00 00 
    base.s.size = 0;
 656:	c7 05 84 06 00 00 00 	movl   $0x0,0x684
 65d:	00 00 00 
 660:	e9 4e ff ff ff       	jmp    5b3 <malloc+0x23>
