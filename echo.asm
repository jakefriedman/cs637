
_echo:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 5b                	jle    79 <main+0x79>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 01             	add    $0x1,%ebx
  26:	39 f3                	cmp    %esi,%ebx
  28:	74 2b                	je     55 <main+0x55>
  2a:	c7 44 24 0c e5 06 00 	movl   $0x6e5,0xc(%esp)
  31:	00 
  32:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  36:	83 c3 01             	add    $0x1,%ebx
  39:	c7 44 24 04 e7 06 00 	movl   $0x6e7,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	89 44 24 08          	mov    %eax,0x8(%esp)
  4c:	e8 cf 03 00 00       	call   420 <printf>
  51:	39 f3                	cmp    %esi,%ebx
  53:	75 d5                	jne    2a <main+0x2a>
  55:	c7 44 24 0c ec 06 00 	movl   $0x6ec,0xc(%esp)
  5c:	00 
  5d:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  61:	c7 44 24 04 e7 06 00 	movl   $0x6e7,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	89 44 24 08          	mov    %eax,0x8(%esp)
  74:	e8 a7 03 00 00       	call   420 <printf>
  exit();
  79:	e8 1a 02 00 00       	call   298 <exit>
  7e:	90                   	nop    
  7f:	90                   	nop    

00000080 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	8b 5d 08             	mov    0x8(%ebp),%ebx
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8a:	89 da                	mov    %ebx,%edx
  8c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 01             	movzbl (%ecx),%eax
  93:	83 c1 01             	add    $0x1,%ecx
  96:	88 02                	mov    %al,(%edx)
  98:	83 c2 01             	add    $0x1,%edx
  9b:	84 c0                	test   %al,%al
  9d:	75 f1                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9f:	89 d8                	mov    %ebx,%eax
  a1:	5b                   	pop    %ebx
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    
  a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b6:	53                   	push   %ebx
  b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  ba:	0f b6 01             	movzbl (%ecx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	74 24                	je     e5 <strcmp+0x35>
  c1:	0f b6 13             	movzbl (%ebx),%edx
  c4:	38 d0                	cmp    %dl,%al
  c6:	74 12                	je     da <strcmp+0x2a>
  c8:	eb 1e                	jmp    e8 <strcmp+0x38>
  ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  d0:	0f b6 13             	movzbl (%ebx),%edx
  d3:	83 c1 01             	add    $0x1,%ecx
  d6:	38 d0                	cmp    %dl,%al
  d8:	75 0e                	jne    e8 <strcmp+0x38>
  da:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  de:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e1:	84 c0                	test   %al,%al
  e3:	75 eb                	jne    d0 <strcmp+0x20>
  e5:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e8:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e9:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  ec:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ed:	0f b6 d2             	movzbl %dl,%edx
  f0:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
 105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 108:	80 39 00             	cmpb   $0x0,(%ecx)
 10b:	74 0e                	je     11b <strlen+0x1b>
 10d:	31 d2                	xor    %edx,%edx
 10f:	90                   	nop    
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 10             	mov    0x10(%ebp),%eax
 126:	53                   	push   %ebx
 127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 12a:	85 c0                	test   %eax,%eax
 12c:	74 10                	je     13e <memset+0x1e>
 12e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 132:	31 d2                	xor    %edx,%edx
    *d++ = c;
 134:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 137:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 13a:	39 c2                	cmp    %eax,%edx
 13c:	75 f6                	jne    134 <memset+0x14>
    *d++ = c;
  return dst;
}
 13e:	89 d8                	mov    %ebx,%eax
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 0c                	jne    16d <strchr+0x1d>
 161:	eb 11                	jmp    174 <strchr+0x24>
 163:	83 c0 01             	add    $0x1,%eax
 166:	0f b6 10             	movzbl (%eax),%edx
 169:	84 d2                	test   %dl,%dl
 16b:	74 07                	je     174 <strchr+0x24>
    if(*s == c)
 16d:	38 ca                	cmp    %cl,%dl
 16f:	90                   	nop    
 170:	75 f1                	jne    163 <strchr+0x13>
      return (char*) s;
  return 0;
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 175:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 177:	c3                   	ret    
 178:	90                   	nop    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000180 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 4d 08             	mov    0x8(%ebp),%ecx
 186:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 187:	31 db                	xor    %ebx,%ebx
 189:	0f b6 11             	movzbl (%ecx),%edx
 18c:	8d 42 d0             	lea    -0x30(%edx),%eax
 18f:	3c 09                	cmp    $0x9,%al
 191:	77 18                	ja     1ab <atoi+0x2b>
    n = n*10 + *s++ - '0';
 193:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 196:	0f be d2             	movsbl %dl,%edx
 199:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 1a1:	83 c1 01             	add    $0x1,%ecx
 1a4:	8d 42 d0             	lea    -0x30(%edx),%eax
 1a7:	3c 09                	cmp    $0x9,%al
 1a9:	76 e8                	jbe    193 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 1ab:	89 d8                	mov    %ebx,%eax
 1ad:	5b                   	pop    %ebx
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    

000001b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1b6:	56                   	push   %esi
 1b7:	8b 75 08             	mov    0x8(%ebp),%esi
 1ba:	53                   	push   %ebx
 1bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1be:	85 c9                	test   %ecx,%ecx
 1c0:	7e 10                	jle    1d2 <memmove+0x22>
 1c2:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 1c4:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 1c8:	88 04 32             	mov    %al,(%edx,%esi,1)
 1cb:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ce:	39 ca                	cmp    %ecx,%edx
 1d0:	75 f2                	jne    1c4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 1d2:	89 f0                	mov    %esi,%eax
 1d4:	5b                   	pop    %ebx
 1d5:	5e                   	pop    %esi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    
 1d8:	90                   	nop    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000001e0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fb:	00 
 1fc:	89 04 24             	mov    %eax,(%esp)
 1ff:	e8 d4 00 00 00       	call   2d8 <open>
  if(fd < 0)
 204:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 208:	78 19                	js     223 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 1c 24             	mov    %ebx,(%esp)
 210:	89 44 24 04          	mov    %eax,0x4(%esp)
 214:	e8 d7 00 00 00       	call   2f0 <fstat>
  close(fd);
 219:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 21c:	89 c6                	mov    %eax,%esi
  close(fd);
 21e:	e8 9d 00 00 00       	call   2c0 <close>
  return r;
}
 223:	89 f0                	mov    %esi,%eax
 225:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 228:	8b 75 fc             	mov    -0x4(%ebp),%esi
 22b:	89 ec                	mov    %ebp,%esp
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop    

00000230 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	31 f6                	xor    %esi,%esi
 237:	53                   	push   %ebx
 238:	83 ec 1c             	sub    $0x1c,%esp
 23b:	8b 7d 08             	mov    0x8(%ebp),%edi
 23e:	eb 06                	jmp    246 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 240:	3c 0d                	cmp    $0xd,%al
 242:	74 39                	je     27d <gets+0x4d>
 244:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	8d 5e 01             	lea    0x1(%esi),%ebx
 249:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 24c:	7d 31                	jge    27f <gets+0x4f>
    cc = read(0, &c, 1);
 24e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 251:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 258:	00 
 259:	89 44 24 04          	mov    %eax,0x4(%esp)
 25d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 264:	e8 47 00 00 00       	call   2b0 <read>
    if(cc < 1)
 269:	85 c0                	test   %eax,%eax
 26b:	7e 12                	jle    27f <gets+0x4f>
      break;
    buf[i++] = c;
 26d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 271:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	75 c3                	jne    240 <gets+0x10>
 27d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 27f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 283:	89 f8                	mov    %edi,%eax
 285:	83 c4 1c             	add    $0x1c,%esp
 288:	5b                   	pop    %ebx
 289:	5e                   	pop    %esi
 28a:	5f                   	pop    %edi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	90                   	nop    
 28e:	90                   	nop    
 28f:	90                   	nop    

00000290 <fork>:
 290:	b8 01 00 00 00       	mov    $0x1,%eax
 295:	cd 30                	int    $0x30
 297:	c3                   	ret    

00000298 <exit>:
 298:	b8 02 00 00 00       	mov    $0x2,%eax
 29d:	cd 30                	int    $0x30
 29f:	c3                   	ret    

000002a0 <wait>:
 2a0:	b8 03 00 00 00       	mov    $0x3,%eax
 2a5:	cd 30                	int    $0x30
 2a7:	c3                   	ret    

000002a8 <pipe>:
 2a8:	b8 04 00 00 00       	mov    $0x4,%eax
 2ad:	cd 30                	int    $0x30
 2af:	c3                   	ret    

000002b0 <read>:
 2b0:	b8 06 00 00 00       	mov    $0x6,%eax
 2b5:	cd 30                	int    $0x30
 2b7:	c3                   	ret    

000002b8 <write>:
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 30                	int    $0x30
 2bf:	c3                   	ret    

000002c0 <close>:
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 30                	int    $0x30
 2c7:	c3                   	ret    

000002c8 <kill>:
 2c8:	b8 08 00 00 00       	mov    $0x8,%eax
 2cd:	cd 30                	int    $0x30
 2cf:	c3                   	ret    

000002d0 <exec>:
 2d0:	b8 09 00 00 00       	mov    $0x9,%eax
 2d5:	cd 30                	int    $0x30
 2d7:	c3                   	ret    

000002d8 <open>:
 2d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2dd:	cd 30                	int    $0x30
 2df:	c3                   	ret    

000002e0 <mknod>:
 2e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    

000002e8 <unlink>:
 2e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ed:	cd 30                	int    $0x30
 2ef:	c3                   	ret    

000002f0 <fstat>:
 2f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <link>:
 2f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <mkdir>:
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <chdir>:
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <dup>:
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <getpid>:
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <sbrk>:
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <sleep>:
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <tick>:
 330:	b8 15 00 00 00       	mov    $0x15,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <fork_tickets>:
 338:	b8 16 00 00 00       	mov    $0x16,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <fork_thread>:
 340:	b8 17 00 00 00       	mov    $0x17,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <wait_thread>:
 348:	b8 18 00 00 00       	mov    $0x18,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <sleep_cond>:
 350:	b8 19 00 00 00       	mov    $0x19,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <wake_cond>:
 358:	b8 1a 00 00 00       	mov    $0x1a,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <xchng>:
 360:	b8 1b 00 00 00       	mov    $0x1b,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    
 368:	90                   	nop    
 369:	90                   	nop    
 36a:	90                   	nop    
 36b:	90                   	nop    
 36c:	90                   	nop    
 36d:	90                   	nop    
 36e:	90                   	nop    
 36f:	90                   	nop    

00000370 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 18             	sub    $0x18,%esp
 376:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 379:	8d 55 fc             	lea    -0x4(%ebp),%edx
 37c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 383:	00 
 384:	89 54 24 04          	mov    %edx,0x4(%esp)
 388:	89 04 24             	mov    %eax,(%esp)
 38b:	e8 28 ff ff ff       	call   2b8 <write>
}
 390:	c9                   	leave  
 391:	c3                   	ret    
 392:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000003a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	89 ce                	mov    %ecx,%esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b1:	85 c9                	test   %ecx,%ecx
 3b3:	74 04                	je     3b9 <printint+0x19>
 3b5:	85 d2                	test   %edx,%edx
 3b7:	78 54                	js     40d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b9:	89 d0                	mov    %edx,%eax
 3bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 3c2:	31 db                	xor    %ebx,%ebx
 3c4:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3c7:	31 d2                	xor    %edx,%edx
 3c9:	f7 f6                	div    %esi
 3cb:	89 c1                	mov    %eax,%ecx
 3cd:	0f b6 82 f5 06 00 00 	movzbl 0x6f5(%edx),%eax
 3d4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 3d7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 3da:	85 c9                	test   %ecx,%ecx
 3dc:	89 c8                	mov    %ecx,%eax
 3de:	75 e7                	jne    3c7 <printint+0x27>
  if(neg)
 3e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3e3:	85 c0                	test   %eax,%eax
 3e5:	74 08                	je     3ef <printint+0x4f>
    buf[i++] = '-';
 3e7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 3ec:	83 c3 01             	add    $0x1,%ebx
 3ef:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3f2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 3f6:	83 eb 01             	sub    $0x1,%ebx
 3f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3fc:	e8 6f ff ff ff       	call   370 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 401:	39 fb                	cmp    %edi,%ebx
 403:	75 ed                	jne    3f2 <printint+0x52>
    putc(fd, buf[i]);
}
 405:	83 c4 1c             	add    $0x1c,%esp
 408:	5b                   	pop    %ebx
 409:	5e                   	pop    %esi
 40a:	5f                   	pop    %edi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 40d:	89 d0                	mov    %edx,%eax
 40f:	f7 d8                	neg    %eax
 411:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 418:	eb a8                	jmp    3c2 <printint+0x22>
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000420 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 429:	8b 55 0c             	mov    0xc(%ebp),%edx
 42c:	0f b6 02             	movzbl (%edx),%eax
 42f:	84 c0                	test   %al,%al
 431:	0f 84 84 00 00 00    	je     4bb <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 437:	8d 4d 10             	lea    0x10(%ebp),%ecx
 43a:	89 d7                	mov    %edx,%edi
 43c:	31 f6                	xor    %esi,%esi
 43e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 441:	eb 18                	jmp    45b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 443:	83 fb 25             	cmp    $0x25,%ebx
 446:	75 7b                	jne    4c3 <printf+0xa3>
 448:	66 be 25 00          	mov    $0x25,%si
 44c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 450:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 454:	83 c7 01             	add    $0x1,%edi
 457:	84 c0                	test   %al,%al
 459:	74 60                	je     4bb <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 45b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 45d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 460:	74 e1                	je     443 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 462:	83 fe 25             	cmp    $0x25,%esi
 465:	75 e9                	jne    450 <printf+0x30>
      if(c == 'd'){
 467:	83 fb 64             	cmp    $0x64,%ebx
 46a:	0f 84 db 00 00 00    	je     54b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 470:	83 fb 78             	cmp    $0x78,%ebx
 473:	74 5b                	je     4d0 <printf+0xb0>
 475:	83 fb 70             	cmp    $0x70,%ebx
 478:	74 56                	je     4d0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 47a:	83 fb 73             	cmp    $0x73,%ebx
 47d:	8d 76 00             	lea    0x0(%esi),%esi
 480:	74 72                	je     4f4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 482:	83 fb 63             	cmp    $0x63,%ebx
 485:	0f 84 a7 00 00 00    	je     532 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 48b:	83 fb 25             	cmp    $0x25,%ebx
 48e:	66 90                	xchg   %ax,%ax
 490:	0f 84 da 00 00 00    	je     570 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 49e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4a0:	e8 cb fe ff ff       	call   370 <putc>
        putc(fd, c);
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f be d3             	movsbl %bl,%edx
 4ab:	e8 c0 fe ff ff       	call   370 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4b4:	83 c7 01             	add    $0x1,%edi
 4b7:	84 c0                	test   %al,%al
 4b9:	75 a0                	jne    45b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4bb:	83 c4 0c             	add    $0xc,%esp
 4be:	5b                   	pop    %ebx
 4bf:	5e                   	pop    %esi
 4c0:	5f                   	pop    %edi
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	0f be d3             	movsbl %bl,%edx
 4c9:	e8 a2 fe ff ff       	call   370 <putc>
 4ce:	eb 80                	jmp    450 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4d8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4e1:	8b 10                	mov    (%eax),%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 b5 fe ff ff       	call   3a0 <printint>
        ap++;
 4eb:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4ef:	e9 5c ff ff ff       	jmp    450 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 4f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 4f7:	8b 02                	mov    (%edx),%eax
        ap++;
 4f9:	83 c2 04             	add    $0x4,%edx
 4fc:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 4ff:	ba ee 06 00 00       	mov    $0x6ee,%edx
 504:	85 c0                	test   %eax,%eax
 506:	75 26                	jne    52e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 508:	0f b6 02             	movzbl (%edx),%eax
 50b:	84 c0                	test   %al,%al
 50d:	74 18                	je     527 <printf+0x107>
 50f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 511:	0f be d0             	movsbl %al,%edx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	e8 54 fe ff ff       	call   370 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 51c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 520:	83 c3 01             	add    $0x1,%ebx
 523:	84 c0                	test   %al,%al
 525:	75 ea                	jne    511 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 527:	31 f6                	xor    %esi,%esi
 529:	e9 22 ff ff ff       	jmp    450 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 52e:	89 c2                	mov    %eax,%edx
 530:	eb d6                	jmp    508 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 532:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 535:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	0f be 11             	movsbl (%ecx),%edx
 53d:	e8 2e fe ff ff       	call   370 <putc>
        ap++;
 542:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 546:	e9 05 ff ff ff       	jmp    450 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 54b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 553:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 556:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 55d:	8b 10                	mov    (%eax),%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	e8 39 fe ff ff       	call   3a0 <printint>
        ap++;
 567:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 56b:	e9 e0 fe ff ff       	jmp    450 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	ba 25 00 00 00       	mov    $0x25,%edx
 578:	31 f6                	xor    %esi,%esi
 57a:	e8 f1 fd ff ff       	call   370 <putc>
 57f:	e9 cc fe ff ff       	jmp    450 <printf+0x30>
 584:	90                   	nop    
 585:	90                   	nop    
 586:	90                   	nop    
 587:	90                   	nop    
 588:	90                   	nop    
 589:	90                   	nop    
 58a:	90                   	nop    
 58b:	90                   	nop    
 58c:	90                   	nop    
 58d:	90                   	nop    
 58e:	90                   	nop    
 58f:	90                   	nop    

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	8b 0d 10 07 00 00    	mov    0x710,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 597:	89 e5                	mov    %esp,%ebp
 599:	56                   	push   %esi
 59a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 59e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	39 d9                	cmp    %ebx,%ecx
 5a3:	73 18                	jae    5bd <free+0x2d>
 5a5:	8b 11                	mov    (%ecx),%edx
 5a7:	39 d3                	cmp    %edx,%ebx
 5a9:	72 17                	jb     5c2 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ab:	39 d1                	cmp    %edx,%ecx
 5ad:	72 08                	jb     5b7 <free+0x27>
 5af:	39 d9                	cmp    %ebx,%ecx
 5b1:	72 0f                	jb     5c2 <free+0x32>
 5b3:	39 d3                	cmp    %edx,%ebx
 5b5:	72 0b                	jb     5c2 <free+0x32>
 5b7:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b9:	39 d9                	cmp    %ebx,%ecx
 5bb:	72 e8                	jb     5a5 <free+0x15>
 5bd:	8b 11                	mov    (%ecx),%edx
 5bf:	90                   	nop    
 5c0:	eb e9                	jmp    5ab <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5c2:	8b 73 04             	mov    0x4(%ebx),%esi
 5c5:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 5c8:	39 d0                	cmp    %edx,%eax
 5ca:	74 18                	je     5e4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5cc:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 5ce:	8b 51 04             	mov    0x4(%ecx),%edx
 5d1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5d4:	39 d8                	cmp    %ebx,%eax
 5d6:	74 20                	je     5f8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 5da:	5b                   	pop    %ebx
 5db:	5e                   	pop    %esi
 5dc:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5dd:	89 0d 10 07 00 00    	mov    %ecx,0x710
}
 5e3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5e4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 5e7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5e9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5ec:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5ef:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5f1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5f4:	39 d8                	cmp    %ebx,%eax
 5f6:	75 e0                	jne    5d8 <free+0x48>
    p->s.size += bp->s.size;
 5f8:	03 53 04             	add    0x4(%ebx),%edx
 5fb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 5fe:	8b 13                	mov    (%ebx),%edx
 600:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 602:	5b                   	pop    %ebx
 603:	5e                   	pop    %esi
 604:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 605:	89 0d 10 07 00 00    	mov    %ecx,0x710
}
 60b:	c3                   	ret    
 60c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 61c:	8b 15 10 07 00 00    	mov    0x710,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 622:	83 c0 07             	add    $0x7,%eax
 625:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 628:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 62a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 62d:	0f 84 8a 00 00 00    	je     6bd <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 633:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 635:	8b 41 04             	mov    0x4(%ecx),%eax
 638:	39 c3                	cmp    %eax,%ebx
 63a:	76 1a                	jbe    656 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 63c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 643:	3b 0d 10 07 00 00    	cmp    0x710,%ecx
 649:	89 ca                	mov    %ecx,%edx
 64b:	74 29                	je     676 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 64f:	8b 41 04             	mov    0x4(%ecx),%eax
 652:	39 c3                	cmp    %eax,%ebx
 654:	77 ed                	ja     643 <malloc+0x33>
      if(p->s.size == nunits)
 656:	39 c3                	cmp    %eax,%ebx
 658:	74 5d                	je     6b7 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 65a:	29 d8                	sub    %ebx,%eax
 65c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 65f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 662:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 665:	89 15 10 07 00 00    	mov    %edx,0x710
      return (void*) (p + 1);
 66b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 66e:	83 c4 0c             	add    $0xc,%esp
 671:	5b                   	pop    %ebx
 672:	5e                   	pop    %esi
 673:	5f                   	pop    %edi
 674:	5d                   	pop    %ebp
 675:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 676:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 67c:	89 de                	mov    %ebx,%esi
 67e:	89 f8                	mov    %edi,%eax
 680:	76 29                	jbe    6ab <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 96 fc ff ff       	call   320 <sbrk>
  if(p == (char*) -1)
 68a:	83 f8 ff             	cmp    $0xffffffff,%eax
 68d:	74 18                	je     6a7 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 68f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 692:	83 c0 08             	add    $0x8,%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 f3 fe ff ff       	call   590 <free>
  return freep;
 69d:	8b 15 10 07 00 00    	mov    0x710,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6a3:	85 d2                	test   %edx,%edx
 6a5:	75 a6                	jne    64d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6a7:	31 c0                	xor    %eax,%eax
 6a9:	eb c3                	jmp    66e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6ab:	be 00 10 00 00       	mov    $0x1000,%esi
 6b0:	b8 00 80 00 00       	mov    $0x8000,%eax
 6b5:	eb cb                	jmp    682 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6b7:	8b 01                	mov    (%ecx),%eax
 6b9:	89 02                	mov    %eax,(%edx)
 6bb:	eb a8                	jmp    665 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 6bd:	ba 08 07 00 00       	mov    $0x708,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6c2:	c7 05 10 07 00 00 08 	movl   $0x708,0x710
 6c9:	07 00 00 
 6cc:	c7 05 08 07 00 00 08 	movl   $0x708,0x708
 6d3:	07 00 00 
    base.s.size = 0;
 6d6:	c7 05 0c 07 00 00 00 	movl   $0x0,0x70c
 6dd:	00 00 00 
 6e0:	e9 4e ff ff ff       	jmp    633 <malloc+0x23>
