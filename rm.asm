
_rm:     file format elf32-i386

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
   d:	83 ec 28             	sub    $0x28,%esp
  10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  13:	8b 19                	mov    (%ecx),%ebx
  15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1e:	8b 41 04             	mov    0x4(%ecx),%eax
  int i;

  if(argc < 2){
  21:	83 fb 01             	cmp    $0x1,%ebx
  24:	7f 19                	jg     3f <main+0x3f>
    printf(2, "Usage: rm files...\n");
  26:	c7 44 24 04 b5 06 00 	movl   $0x6b5,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  35:	e8 b6 03 00 00       	call   3f0 <printf>
    exit();
  3a:	e8 59 02 00 00       	call   298 <exit>
  3f:	8d 70 04             	lea    0x4(%eax),%esi
  42:	bf 01 00 00 00       	mov    $0x1,%edi
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  47:	8b 06                	mov    (%esi),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 97 02 00 00       	call   2e8 <unlink>
  51:	85 c0                	test   %eax,%eax
  53:	78 0f                	js     64 <main+0x64>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  55:	83 c7 01             	add    $0x1,%edi
  58:	83 c6 04             	add    $0x4,%esi
  5b:	39 df                	cmp    %ebx,%edi
  5d:	75 e8                	jne    47 <main+0x47>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  5f:	e8 34 02 00 00       	call   298 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
      printf(2, "rm: %s failed to delete\n", argv[i]);
  64:	8b 06                	mov    (%esi),%eax
  66:	c7 44 24 04 c9 06 00 	movl   $0x6c9,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	89 44 24 08          	mov    %eax,0x8(%esp)
  79:	e8 72 03 00 00       	call   3f0 <printf>
  7e:	eb df                	jmp    5f <main+0x5f>

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

00000330 <kalloctest>:
 330:	b8 15 00 00 00       	mov    $0x15,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    
 338:	90                   	nop    
 339:	90                   	nop    
 33a:	90                   	nop    
 33b:	90                   	nop    
 33c:	90                   	nop    
 33d:	90                   	nop    
 33e:	90                   	nop    
 33f:	90                   	nop    

00000340 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 18             	sub    $0x18,%esp
 346:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 349:	8d 55 fc             	lea    -0x4(%ebp),%edx
 34c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 353:	00 
 354:	89 54 24 04          	mov    %edx,0x4(%esp)
 358:	89 04 24             	mov    %eax,(%esp)
 35b:	e8 58 ff ff ff       	call   2b8 <write>
}
 360:	c9                   	leave  
 361:	c3                   	ret    
 362:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	89 ce                	mov    %ecx,%esi
 377:	53                   	push   %ebx
 378:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 37e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 381:	85 c9                	test   %ecx,%ecx
 383:	74 04                	je     389 <printint+0x19>
 385:	85 d2                	test   %edx,%edx
 387:	78 54                	js     3dd <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 389:	89 d0                	mov    %edx,%eax
 38b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 392:	31 db                	xor    %ebx,%ebx
 394:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 397:	31 d2                	xor    %edx,%edx
 399:	f7 f6                	div    %esi
 39b:	89 c1                	mov    %eax,%ecx
 39d:	0f b6 82 e9 06 00 00 	movzbl 0x6e9(%edx),%eax
 3a4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 3a7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 3aa:	85 c9                	test   %ecx,%ecx
 3ac:	89 c8                	mov    %ecx,%eax
 3ae:	75 e7                	jne    397 <printint+0x27>
  if(neg)
 3b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3b3:	85 c0                	test   %eax,%eax
 3b5:	74 08                	je     3bf <printint+0x4f>
    buf[i++] = '-';
 3b7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 3bc:	83 c3 01             	add    $0x1,%ebx
 3bf:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3c2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 3c6:	83 eb 01             	sub    $0x1,%ebx
 3c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3cc:	e8 6f ff ff ff       	call   340 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3d1:	39 fb                	cmp    %edi,%ebx
 3d3:	75 ed                	jne    3c2 <printint+0x52>
    putc(fd, buf[i]);
}
 3d5:	83 c4 1c             	add    $0x1c,%esp
 3d8:	5b                   	pop    %ebx
 3d9:	5e                   	pop    %esi
 3da:	5f                   	pop    %edi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3dd:	89 d0                	mov    %edx,%eax
 3df:	f7 d8                	neg    %eax
 3e1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 3e8:	eb a8                	jmp    392 <printint+0x22>
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3fc:	0f b6 02             	movzbl (%edx),%eax
 3ff:	84 c0                	test   %al,%al
 401:	0f 84 84 00 00 00    	je     48b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 4d 10             	lea    0x10(%ebp),%ecx
 40a:	89 d7                	mov    %edx,%edi
 40c:	31 f6                	xor    %esi,%esi
 40e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 411:	eb 18                	jmp    42b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 413:	83 fb 25             	cmp    $0x25,%ebx
 416:	75 7b                	jne    493 <printf+0xa3>
 418:	66 be 25 00          	mov    $0x25,%si
 41c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 420:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 424:	83 c7 01             	add    $0x1,%edi
 427:	84 c0                	test   %al,%al
 429:	74 60                	je     48b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 42b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 42d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 430:	74 e1                	je     413 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 432:	83 fe 25             	cmp    $0x25,%esi
 435:	75 e9                	jne    420 <printf+0x30>
      if(c == 'd'){
 437:	83 fb 64             	cmp    $0x64,%ebx
 43a:	0f 84 db 00 00 00    	je     51b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 440:	83 fb 78             	cmp    $0x78,%ebx
 443:	74 5b                	je     4a0 <printf+0xb0>
 445:	83 fb 70             	cmp    $0x70,%ebx
 448:	74 56                	je     4a0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 44a:	83 fb 73             	cmp    $0x73,%ebx
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	74 72                	je     4c4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 452:	83 fb 63             	cmp    $0x63,%ebx
 455:	0f 84 a7 00 00 00    	je     502 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 45b:	83 fb 25             	cmp    $0x25,%ebx
 45e:	66 90                	xchg   %ax,%ax
 460:	0f 84 da 00 00 00    	je     540 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 46e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 470:	e8 cb fe ff ff       	call   340 <putc>
        putc(fd, c);
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	0f be d3             	movsbl %bl,%edx
 47b:	e8 c0 fe ff ff       	call   340 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 480:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 484:	83 c7 01             	add    $0x1,%edi
 487:	84 c0                	test   %al,%al
 489:	75 a0                	jne    42b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 48b:	83 c4 0c             	add    $0xc,%esp
 48e:	5b                   	pop    %ebx
 48f:	5e                   	pop    %esi
 490:	5f                   	pop    %edi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	0f be d3             	movsbl %bl,%edx
 499:	e8 a2 fe ff ff       	call   340 <putc>
 49e:	eb 80                	jmp    420 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4a8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4b1:	8b 10                	mov    (%eax),%edx
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	e8 b5 fe ff ff       	call   370 <printint>
        ap++;
 4bb:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4bf:	e9 5c ff ff ff       	jmp    420 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 4c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 4c7:	8b 02                	mov    (%edx),%eax
        ap++;
 4c9:	83 c2 04             	add    $0x4,%edx
 4cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 4cf:	ba e2 06 00 00       	mov    $0x6e2,%edx
 4d4:	85 c0                	test   %eax,%eax
 4d6:	75 26                	jne    4fe <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 4d8:	0f b6 02             	movzbl (%edx),%eax
 4db:	84 c0                	test   %al,%al
 4dd:	74 18                	je     4f7 <printf+0x107>
 4df:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 4e1:	0f be d0             	movsbl %al,%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	e8 54 fe ff ff       	call   340 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ec:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 4f0:	83 c3 01             	add    $0x1,%ebx
 4f3:	84 c0                	test   %al,%al
 4f5:	75 ea                	jne    4e1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4f7:	31 f6                	xor    %esi,%esi
 4f9:	e9 22 ff ff ff       	jmp    420 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4fe:	89 c2                	mov    %eax,%edx
 500:	eb d6                	jmp    4d8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 502:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 505:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	0f be 11             	movsbl (%ecx),%edx
 50d:	e8 2e fe ff ff       	call   340 <putc>
        ap++;
 512:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 516:	e9 05 ff ff ff       	jmp    420 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 51b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 523:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 526:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 52d:	8b 10                	mov    (%eax),%edx
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	e8 39 fe ff ff       	call   370 <printint>
        ap++;
 537:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 53b:	e9 e0 fe ff ff       	jmp    420 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	ba 25 00 00 00       	mov    $0x25,%edx
 548:	31 f6                	xor    %esi,%esi
 54a:	e8 f1 fd ff ff       	call   340 <putc>
 54f:	e9 cc fe ff ff       	jmp    420 <printf+0x30>
 554:	90                   	nop    
 555:	90                   	nop    
 556:	90                   	nop    
 557:	90                   	nop    
 558:	90                   	nop    
 559:	90                   	nop    
 55a:	90                   	nop    
 55b:	90                   	nop    
 55c:	90                   	nop    
 55d:	90                   	nop    
 55e:	90                   	nop    
 55f:	90                   	nop    

00000560 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 560:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 561:	8b 0d 04 07 00 00    	mov    0x704,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 567:	89 e5                	mov    %esp,%ebp
 569:	56                   	push   %esi
 56a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 56b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 571:	39 d9                	cmp    %ebx,%ecx
 573:	73 18                	jae    58d <free+0x2d>
 575:	8b 11                	mov    (%ecx),%edx
 577:	39 d3                	cmp    %edx,%ebx
 579:	72 17                	jb     592 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57b:	39 d1                	cmp    %edx,%ecx
 57d:	72 08                	jb     587 <free+0x27>
 57f:	39 d9                	cmp    %ebx,%ecx
 581:	72 0f                	jb     592 <free+0x32>
 583:	39 d3                	cmp    %edx,%ebx
 585:	72 0b                	jb     592 <free+0x32>
 587:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 589:	39 d9                	cmp    %ebx,%ecx
 58b:	72 e8                	jb     575 <free+0x15>
 58d:	8b 11                	mov    (%ecx),%edx
 58f:	90                   	nop    
 590:	eb e9                	jmp    57b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 592:	8b 73 04             	mov    0x4(%ebx),%esi
 595:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 598:	39 d0                	cmp    %edx,%eax
 59a:	74 18                	je     5b4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 59e:	8b 51 04             	mov    0x4(%ecx),%edx
 5a1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5a4:	39 d8                	cmp    %ebx,%eax
 5a6:	74 20                	je     5c8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5a8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 5aa:	5b                   	pop    %ebx
 5ab:	5e                   	pop    %esi
 5ac:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5ad:	89 0d 04 07 00 00    	mov    %ecx,0x704
}
 5b3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5b4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 5b7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5b9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5bc:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5bf:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5c1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5c4:	39 d8                	cmp    %ebx,%eax
 5c6:	75 e0                	jne    5a8 <free+0x48>
    p->s.size += bp->s.size;
 5c8:	03 53 04             	add    0x4(%ebx),%edx
 5cb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 5ce:	8b 13                	mov    (%ebx),%edx
 5d0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5d2:	5b                   	pop    %ebx
 5d3:	5e                   	pop    %esi
 5d4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5d5:	89 0d 04 07 00 00    	mov    %ecx,0x704
}
 5db:	c3                   	ret    
 5dc:	8d 74 26 00          	lea    0x0(%esi),%esi

000005e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 5ec:	8b 15 04 07 00 00    	mov    0x704,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f2:	83 c0 07             	add    $0x7,%eax
 5f5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 5f8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5fa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 5fd:	0f 84 8a 00 00 00    	je     68d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 603:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 605:	8b 41 04             	mov    0x4(%ecx),%eax
 608:	39 c3                	cmp    %eax,%ebx
 60a:	76 1a                	jbe    626 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 60c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 613:	3b 0d 04 07 00 00    	cmp    0x704,%ecx
 619:	89 ca                	mov    %ecx,%edx
 61b:	74 29                	je     646 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 61f:	8b 41 04             	mov    0x4(%ecx),%eax
 622:	39 c3                	cmp    %eax,%ebx
 624:	77 ed                	ja     613 <malloc+0x33>
      if(p->s.size == nunits)
 626:	39 c3                	cmp    %eax,%ebx
 628:	74 5d                	je     687 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 62a:	29 d8                	sub    %ebx,%eax
 62c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 62f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 632:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 635:	89 15 04 07 00 00    	mov    %edx,0x704
      return (void*) (p + 1);
 63b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 63e:	83 c4 0c             	add    $0xc,%esp
 641:	5b                   	pop    %ebx
 642:	5e                   	pop    %esi
 643:	5f                   	pop    %edi
 644:	5d                   	pop    %ebp
 645:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 646:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 64c:	89 de                	mov    %ebx,%esi
 64e:	89 f8                	mov    %edi,%eax
 650:	76 29                	jbe    67b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 652:	89 04 24             	mov    %eax,(%esp)
 655:	e8 c6 fc ff ff       	call   320 <sbrk>
  if(p == (char*) -1)
 65a:	83 f8 ff             	cmp    $0xffffffff,%eax
 65d:	74 18                	je     677 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 65f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 662:	83 c0 08             	add    $0x8,%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 f3 fe ff ff       	call   560 <free>
  return freep;
 66d:	8b 15 04 07 00 00    	mov    0x704,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 673:	85 d2                	test   %edx,%edx
 675:	75 a6                	jne    61d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 677:	31 c0                	xor    %eax,%eax
 679:	eb c3                	jmp    63e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 67b:	be 00 10 00 00       	mov    $0x1000,%esi
 680:	b8 00 80 00 00       	mov    $0x8000,%eax
 685:	eb cb                	jmp    652 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 687:	8b 01                	mov    (%ecx),%eax
 689:	89 02                	mov    %eax,(%edx)
 68b:	eb a8                	jmp    635 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 68d:	ba fc 06 00 00       	mov    $0x6fc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 692:	c7 05 04 07 00 00 fc 	movl   $0x6fc,0x704
 699:	06 00 00 
 69c:	c7 05 fc 06 00 00 fc 	movl   $0x6fc,0x6fc
 6a3:	06 00 00 
    base.s.size = 0;
 6a6:	c7 05 00 07 00 00 00 	movl   $0x0,0x700
 6ad:	00 00 00 
 6b0:	e9 4e ff ff ff       	jmp    603 <malloc+0x23>
