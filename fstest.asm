
_fstest:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int
main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
char teststring[1024];
int k;
for(k =0 ; k< 1024; k++)
   teststring[k] = 'j';
   a:	b8 02 00 00 00       	mov    $0x2,%eax
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int
main() {
   f:	55                   	push   %ebp
  10:	89 e5                	mov    %esp,%ebp
  12:	57                   	push   %edi
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	81 ec 18 04 00 00    	sub    $0x418,%esp
  1c:	8d bd f0 fb ff ff    	lea    -0x410(%ebp),%edi
char teststring[1024];
int k;
for(k =0 ; k< 1024; k++)
   teststring[k] = 'j';
  22:	c6 85 f0 fb ff ff 6a 	movb   $0x6a,-0x410(%ebp)
  29:	c6 44 38 ff 6a       	movb   $0x6a,-0x1(%eax,%edi,1)
  2e:	83 c0 01             	add    $0x1,%eax

int
main() {
char teststring[1024];
int k;
for(k =0 ; k< 1024; k++)
  31:	3d 01 04 00 00       	cmp    $0x401,%eax
  36:	75 f1                	jne    29 <main+0x29>
   teststring[k] = 'j';
struct stat *a;
int i = 0;
int fd = open("fstestfile", O_CREATE | O_RDWR);
  38:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  3f:	00 
printf(1, "File fstestfile Created\n");
  40:	31 db                	xor    %ebx,%ebx
int k;
for(k =0 ; k< 1024; k++)
   teststring[k] = 'j';
struct stat *a;
int i = 0;
int fd = open("fstestfile", O_CREATE | O_RDWR);
  42:	c7 04 24 38 07 00 00 	movl   $0x738,(%esp)
  49:	e8 da 02 00 00       	call   328 <open>
printf(1, "File fstestfile Created\n");
  4e:	c7 44 24 04 43 07 00 	movl   $0x743,0x4(%esp)
  55:	00 
  56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
int k;
for(k =0 ; k< 1024; k++)
   teststring[k] = 'j';
struct stat *a;
int i = 0;
int fd = open("fstestfile", O_CREATE | O_RDWR);
  5d:	89 c6                	mov    %eax,%esi
printf(1, "File fstestfile Created\n");
  5f:	e8 0c 04 00 00       	call   470 <printf>
while(1) {
if(i % 10 == 0) {
fstat(fd, a);
  64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  68:	89 34 24             	mov    %esi,(%esp)
  6b:	e8 d0 02 00 00       	call   340 <fstat>
printf(1, "Current Test File Size %d bytes\n", a->size);
  70:	8b 43 0c             	mov    0xc(%ebx),%eax
  73:	c7 44 24 04 5c 07 00 	movl   $0x75c,0x4(%esp)
  7a:	00 
  7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  82:	89 44 24 08          	mov    %eax,0x8(%esp)
  86:	e8 e5 03 00 00       	call   470 <printf>
  8b:	90                   	nop    
  8c:	8d 74 26 00          	lea    0x0(%esi),%esi
}
write(fd, &teststring, 1024);
i++;
  90:	83 c3 01             	add    $0x1,%ebx
while(1) {
if(i % 10 == 0) {
fstat(fd, a);
printf(1, "Current Test File Size %d bytes\n", a->size);
}
write(fd, &teststring, 1024);
  93:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  9a:	00 
  9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  9f:	89 34 24             	mov    %esi,(%esp)
  a2:	e8 61 02 00 00       	call   308 <write>
struct stat *a;
int i = 0;
int fd = open("fstestfile", O_CREATE | O_RDWR);
printf(1, "File fstestfile Created\n");
while(1) {
if(i % 10 == 0) {
  a7:	89 d8                	mov    %ebx,%eax
  a9:	ba 67 66 66 66       	mov    $0x66666667,%edx
  ae:	f7 ea                	imul   %edx
  b0:	89 d8                	mov    %ebx,%eax
  b2:	c1 f8 1f             	sar    $0x1f,%eax
  b5:	c1 fa 02             	sar    $0x2,%edx
  b8:	29 c2                	sub    %eax,%edx
  ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
  bd:	01 d2                	add    %edx,%edx
  bf:	39 d3                	cmp    %edx,%ebx
  c1:	75 cd                	jne    90 <main+0x90>
  c3:	eb 9f                	jmp    64 <main+0x64>
  c5:	90                   	nop    
  c6:	90                   	nop    
  c7:	90                   	nop    
  c8:	90                   	nop    
  c9:	90                   	nop    
  ca:	90                   	nop    
  cb:	90                   	nop    
  cc:	90                   	nop    
  cd:	90                   	nop    
  ce:	90                   	nop    
  cf:	90                   	nop    

000000d0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  da:	89 da                	mov    %ebx,%edx
  dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	0f b6 01             	movzbl (%ecx),%eax
  e3:	83 c1 01             	add    $0x1,%ecx
  e6:	88 02                	mov    %al,(%edx)
  e8:	83 c2 01             	add    $0x1,%edx
  eb:	84 c0                	test   %al,%al
  ed:	75 f1                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ef:	89 d8                	mov    %ebx,%eax
  f1:	5b                   	pop    %ebx
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    
  f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 4d 08             	mov    0x8(%ebp),%ecx
 106:	53                   	push   %ebx
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 10a:	0f b6 01             	movzbl (%ecx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	74 24                	je     135 <strcmp+0x35>
 111:	0f b6 13             	movzbl (%ebx),%edx
 114:	38 d0                	cmp    %dl,%al
 116:	74 12                	je     12a <strcmp+0x2a>
 118:	eb 1e                	jmp    138 <strcmp+0x38>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 120:	0f b6 13             	movzbl (%ebx),%edx
 123:	83 c1 01             	add    $0x1,%ecx
 126:	38 d0                	cmp    %dl,%al
 128:	75 0e                	jne    138 <strcmp+0x38>
 12a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 12e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 131:	84 c0                	test   %al,%al
 133:	75 eb                	jne    120 <strcmp+0x20>
 135:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 138:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 13c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13d:	0f b6 d2             	movzbl %dl,%edx
 140:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000150 <strlen>:

uint
strlen(char *s)
{
 150:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 151:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 153:	89 e5                	mov    %esp,%ebp
 155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 158:	80 39 00             	cmpb   $0x0,(%ecx)
 15b:	74 0e                	je     16b <strlen+0x1b>
 15d:	31 d2                	xor    %edx,%edx
 15f:	90                   	nop    
 160:	83 c2 01             	add    $0x1,%edx
 163:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 167:	89 d0                	mov    %edx,%eax
 169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
 16d:	8d 76 00             	lea    0x0(%esi),%esi

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 45 10             	mov    0x10(%ebp),%eax
 176:	53                   	push   %ebx
 177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 17a:	85 c0                	test   %eax,%eax
 17c:	74 10                	je     18e <memset+0x1e>
 17e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 182:	31 d2                	xor    %edx,%edx
    *d++ = c;
 184:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 187:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 18a:	39 c2                	cmp    %eax,%edx
 18c:	75 f6                	jne    184 <memset+0x14>
    *d++ = c;
  return dst;
}
 18e:	89 d8                	mov    %ebx,%eax
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1aa:	0f b6 10             	movzbl (%eax),%edx
 1ad:	84 d2                	test   %dl,%dl
 1af:	75 0c                	jne    1bd <strchr+0x1d>
 1b1:	eb 11                	jmp    1c4 <strchr+0x24>
 1b3:	83 c0 01             	add    $0x1,%eax
 1b6:	0f b6 10             	movzbl (%eax),%edx
 1b9:	84 d2                	test   %dl,%dl
 1bb:	74 07                	je     1c4 <strchr+0x24>
    if(*s == c)
 1bd:	38 ca                	cmp    %cl,%dl
 1bf:	90                   	nop    
 1c0:	75 f1                	jne    1b3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 1c7:	c3                   	ret    
 1c8:	90                   	nop    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000001d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d7:	31 db                	xor    %ebx,%ebx
 1d9:	0f b6 11             	movzbl (%ecx),%edx
 1dc:	8d 42 d0             	lea    -0x30(%edx),%eax
 1df:	3c 09                	cmp    $0x9,%al
 1e1:	77 18                	ja     1fb <atoi+0x2b>
    n = n*10 + *s++ - '0';
 1e3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 1e6:	0f be d2             	movsbl %dl,%edx
 1e9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ed:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 1f1:	83 c1 01             	add    $0x1,%ecx
 1f4:	8d 42 d0             	lea    -0x30(%edx),%eax
 1f7:	3c 09                	cmp    $0x9,%al
 1f9:	76 e8                	jbe    1e3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 1fb:	89 d8                	mov    %ebx,%eax
 1fd:	5b                   	pop    %ebx
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    

00000200 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 4d 10             	mov    0x10(%ebp),%ecx
 206:	56                   	push   %esi
 207:	8b 75 08             	mov    0x8(%ebp),%esi
 20a:	53                   	push   %ebx
 20b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 20e:	85 c9                	test   %ecx,%ecx
 210:	7e 10                	jle    222 <memmove+0x22>
 212:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 214:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 218:	88 04 32             	mov    %al,(%edx,%esi,1)
 21b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	39 ca                	cmp    %ecx,%edx
 220:	75 f2                	jne    214 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 222:	89 f0                	mov    %esi,%eax
 224:	5b                   	pop    %ebx
 225:	5e                   	pop    %esi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
 228:	90                   	nop    
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000230 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 239:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 23c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 23f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 24b:	00 
 24c:	89 04 24             	mov    %eax,(%esp)
 24f:	e8 d4 00 00 00       	call   328 <open>
  if(fd < 0)
 254:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 258:	78 19                	js     273 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 1c 24             	mov    %ebx,(%esp)
 260:	89 44 24 04          	mov    %eax,0x4(%esp)
 264:	e8 d7 00 00 00       	call   340 <fstat>
  close(fd);
 269:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 26c:	89 c6                	mov    %eax,%esi
  close(fd);
 26e:	e8 9d 00 00 00       	call   310 <close>
  return r;
}
 273:	89 f0                	mov    %esi,%eax
 275:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 278:	8b 75 fc             	mov    -0x4(%ebp),%esi
 27b:	89 ec                	mov    %ebp,%esp
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret    
 27f:	90                   	nop    

00000280 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
 285:	31 f6                	xor    %esi,%esi
 287:	53                   	push   %ebx
 288:	83 ec 1c             	sub    $0x1c,%esp
 28b:	8b 7d 08             	mov    0x8(%ebp),%edi
 28e:	eb 06                	jmp    296 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 290:	3c 0d                	cmp    $0xd,%al
 292:	74 39                	je     2cd <gets+0x4d>
 294:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 296:	8d 5e 01             	lea    0x1(%esi),%ebx
 299:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 29c:	7d 31                	jge    2cf <gets+0x4f>
    cc = read(0, &c, 1);
 29e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 2a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2a8:	00 
 2a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2b4:	e8 47 00 00 00       	call   300 <read>
    if(cc < 1)
 2b9:	85 c0                	test   %eax,%eax
 2bb:	7e 12                	jle    2cf <gets+0x4f>
      break;
    buf[i++] = c;
 2bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2c1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 2c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2c9:	3c 0a                	cmp    $0xa,%al
 2cb:	75 c3                	jne    290 <gets+0x10>
 2cd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2cf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2d3:	89 f8                	mov    %edi,%eax
 2d5:	83 c4 1c             	add    $0x1c,%esp
 2d8:	5b                   	pop    %ebx
 2d9:	5e                   	pop    %esi
 2da:	5f                   	pop    %edi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	90                   	nop    
 2de:	90                   	nop    
 2df:	90                   	nop    

000002e0 <fork>:
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    

000002e8 <exit>:
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 30                	int    $0x30
 2ef:	c3                   	ret    

000002f0 <wait>:
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <pipe>:
 2f8:	b8 04 00 00 00       	mov    $0x4,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <read>:
 300:	b8 06 00 00 00       	mov    $0x6,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <write>:
 308:	b8 05 00 00 00       	mov    $0x5,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <close>:
 310:	b8 07 00 00 00       	mov    $0x7,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <kill>:
 318:	b8 08 00 00 00       	mov    $0x8,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <exec>:
 320:	b8 09 00 00 00       	mov    $0x9,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <open>:
 328:	b8 0a 00 00 00       	mov    $0xa,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <mknod>:
 330:	b8 0b 00 00 00       	mov    $0xb,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <unlink>:
 338:	b8 0c 00 00 00       	mov    $0xc,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <fstat>:
 340:	b8 0d 00 00 00       	mov    $0xd,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <link>:
 348:	b8 0e 00 00 00       	mov    $0xe,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <mkdir>:
 350:	b8 0f 00 00 00       	mov    $0xf,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <chdir>:
 358:	b8 10 00 00 00       	mov    $0x10,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <dup>:
 360:	b8 11 00 00 00       	mov    $0x11,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <getpid>:
 368:	b8 12 00 00 00       	mov    $0x12,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <sbrk>:
 370:	b8 13 00 00 00       	mov    $0x13,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <sleep>:
 378:	b8 14 00 00 00       	mov    $0x14,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <tick>:
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <fork_tickets>:
 388:	b8 16 00 00 00       	mov    $0x16,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <fork_thread>:
 390:	b8 17 00 00 00       	mov    $0x17,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <wait_thread>:
 398:	b8 18 00 00 00       	mov    $0x18,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <sleep_cond>:
 3a0:	b8 19 00 00 00       	mov    $0x19,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <wake_cond>:
 3a8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <xchng>:
 3b0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <check>:
 3b8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 18             	sub    $0x18,%esp
 3c6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 3c9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 3cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d3:	00 
 3d4:	89 54 24 04          	mov    %edx,0x4(%esp)
 3d8:	89 04 24             	mov    %eax,(%esp)
 3db:	e8 28 ff ff ff       	call   308 <write>
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    
 3e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000003f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	89 ce                	mov    %ecx,%esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 401:	85 c9                	test   %ecx,%ecx
 403:	74 04                	je     409 <printint+0x19>
 405:	85 d2                	test   %edx,%edx
 407:	78 54                	js     45d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 409:	89 d0                	mov    %edx,%eax
 40b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 412:	31 db                	xor    %ebx,%ebx
 414:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 417:	31 d2                	xor    %edx,%edx
 419:	f7 f6                	div    %esi
 41b:	89 c1                	mov    %eax,%ecx
 41d:	0f b6 82 87 07 00 00 	movzbl 0x787(%edx),%eax
 424:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 427:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 42a:	85 c9                	test   %ecx,%ecx
 42c:	89 c8                	mov    %ecx,%eax
 42e:	75 e7                	jne    417 <printint+0x27>
  if(neg)
 430:	8b 45 e0             	mov    -0x20(%ebp),%eax
 433:	85 c0                	test   %eax,%eax
 435:	74 08                	je     43f <printint+0x4f>
    buf[i++] = '-';
 437:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 43c:	83 c3 01             	add    $0x1,%ebx
 43f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 442:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 446:	83 eb 01             	sub    $0x1,%ebx
 449:	8b 45 dc             	mov    -0x24(%ebp),%eax
 44c:	e8 6f ff ff ff       	call   3c0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	39 fb                	cmp    %edi,%ebx
 453:	75 ed                	jne    442 <printint+0x52>
    putc(fd, buf[i]);
}
 455:	83 c4 1c             	add    $0x1c,%esp
 458:	5b                   	pop    %ebx
 459:	5e                   	pop    %esi
 45a:	5f                   	pop    %edi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 45d:	89 d0                	mov    %edx,%eax
 45f:	f7 d8                	neg    %eax
 461:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 468:	eb a8                	jmp    412 <printint+0x22>
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000470 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 55 0c             	mov    0xc(%ebp),%edx
 47c:	0f b6 02             	movzbl (%edx),%eax
 47f:	84 c0                	test   %al,%al
 481:	0f 84 84 00 00 00    	je     50b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 4d 10             	lea    0x10(%ebp),%ecx
 48a:	89 d7                	mov    %edx,%edi
 48c:	31 f6                	xor    %esi,%esi
 48e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 491:	eb 18                	jmp    4ab <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 493:	83 fb 25             	cmp    $0x25,%ebx
 496:	75 7b                	jne    513 <printf+0xa3>
 498:	66 be 25 00          	mov    $0x25,%si
 49c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4a4:	83 c7 01             	add    $0x1,%edi
 4a7:	84 c0                	test   %al,%al
 4a9:	74 60                	je     50b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 4ab:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4ad:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4b0:	74 e1                	je     493 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b2:	83 fe 25             	cmp    $0x25,%esi
 4b5:	75 e9                	jne    4a0 <printf+0x30>
      if(c == 'd'){
 4b7:	83 fb 64             	cmp    $0x64,%ebx
 4ba:	0f 84 db 00 00 00    	je     59b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c0:	83 fb 78             	cmp    $0x78,%ebx
 4c3:	74 5b                	je     520 <printf+0xb0>
 4c5:	83 fb 70             	cmp    $0x70,%ebx
 4c8:	74 56                	je     520 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ca:	83 fb 73             	cmp    $0x73,%ebx
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	74 72                	je     544 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d2:	83 fb 63             	cmp    $0x63,%ebx
 4d5:	0f 84 a7 00 00 00    	je     582 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4db:	83 fb 25             	cmp    $0x25,%ebx
 4de:	66 90                	xchg   %ax,%ax
 4e0:	0f 84 da 00 00 00    	je     5c0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 4ee:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f0:	e8 cb fe ff ff       	call   3c0 <putc>
        putc(fd, c);
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	0f be d3             	movsbl %bl,%edx
 4fb:	e8 c0 fe ff ff       	call   3c0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 500:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 504:	83 c7 01             	add    $0x1,%edi
 507:	84 c0                	test   %al,%al
 509:	75 a0                	jne    4ab <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 50b:	83 c4 0c             	add    $0xc,%esp
 50e:	5b                   	pop    %ebx
 50f:	5e                   	pop    %esi
 510:	5f                   	pop    %edi
 511:	5d                   	pop    %ebp
 512:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	0f be d3             	movsbl %bl,%edx
 519:	e8 a2 fe ff ff       	call   3c0 <putc>
 51e:	eb 80                	jmp    4a0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 520:	8b 45 f0             	mov    -0x10(%ebp),%eax
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 528:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 52a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 531:	8b 10                	mov    (%eax),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 b5 fe ff ff       	call   3f0 <printint>
        ap++;
 53b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 53f:	e9 5c ff ff ff       	jmp    4a0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 544:	8b 55 f0             	mov    -0x10(%ebp),%edx
 547:	8b 02                	mov    (%edx),%eax
        ap++;
 549:	83 c2 04             	add    $0x4,%edx
 54c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 54f:	ba 80 07 00 00       	mov    $0x780,%edx
 554:	85 c0                	test   %eax,%eax
 556:	75 26                	jne    57e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 558:	0f b6 02             	movzbl (%edx),%eax
 55b:	84 c0                	test   %al,%al
 55d:	74 18                	je     577 <printf+0x107>
 55f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 561:	0f be d0             	movsbl %al,%edx
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	e8 54 fe ff ff       	call   3c0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 570:	83 c3 01             	add    $0x1,%ebx
 573:	84 c0                	test   %al,%al
 575:	75 ea                	jne    561 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 577:	31 f6                	xor    %esi,%esi
 579:	e9 22 ff ff ff       	jmp    4a0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 57e:	89 c2                	mov    %eax,%edx
 580:	eb d6                	jmp    558 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 582:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 585:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	0f be 11             	movsbl (%ecx),%edx
 58d:	e8 2e fe ff ff       	call   3c0 <putc>
        ap++;
 592:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 596:	e9 05 ff ff ff       	jmp    4a0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 59b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5a3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ad:	8b 10                	mov    (%eax),%edx
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	e8 39 fe ff ff       	call   3f0 <printint>
        ap++;
 5b7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5bb:	e9 e0 fe ff ff       	jmp    4a0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	ba 25 00 00 00       	mov    $0x25,%edx
 5c8:	31 f6                	xor    %esi,%esi
 5ca:	e8 f1 fd ff ff       	call   3c0 <putc>
 5cf:	e9 cc fe ff ff       	jmp    4a0 <printf+0x30>
 5d4:	90                   	nop    
 5d5:	90                   	nop    
 5d6:	90                   	nop    
 5d7:	90                   	nop    
 5d8:	90                   	nop    
 5d9:	90                   	nop    
 5da:	90                   	nop    
 5db:	90                   	nop    
 5dc:	90                   	nop    
 5dd:	90                   	nop    
 5de:	90                   	nop    
 5df:	90                   	nop    

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	8b 0d a0 07 00 00    	mov    0x7a0,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e7:	89 e5                	mov    %esp,%ebp
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ee:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	39 d9                	cmp    %ebx,%ecx
 5f3:	73 18                	jae    60d <free+0x2d>
 5f5:	8b 11                	mov    (%ecx),%edx
 5f7:	39 d3                	cmp    %edx,%ebx
 5f9:	72 17                	jb     612 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fb:	39 d1                	cmp    %edx,%ecx
 5fd:	72 08                	jb     607 <free+0x27>
 5ff:	39 d9                	cmp    %ebx,%ecx
 601:	72 0f                	jb     612 <free+0x32>
 603:	39 d3                	cmp    %edx,%ebx
 605:	72 0b                	jb     612 <free+0x32>
 607:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 609:	39 d9                	cmp    %ebx,%ecx
 60b:	72 e8                	jb     5f5 <free+0x15>
 60d:	8b 11                	mov    (%ecx),%edx
 60f:	90                   	nop    
 610:	eb e9                	jmp    5fb <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 612:	8b 73 04             	mov    0x4(%ebx),%esi
 615:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 618:	39 d0                	cmp    %edx,%eax
 61a:	74 18                	je     634 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 61c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 61e:	8b 51 04             	mov    0x4(%ecx),%edx
 621:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 624:	39 d8                	cmp    %ebx,%eax
 626:	74 20                	je     648 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 628:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 62d:	89 0d a0 07 00 00    	mov    %ecx,0x7a0
}
 633:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 634:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 637:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 639:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 63c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 63f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 641:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 644:	39 d8                	cmp    %ebx,%eax
 646:	75 e0                	jne    628 <free+0x48>
    p->s.size += bp->s.size;
 648:	03 53 04             	add    0x4(%ebx),%edx
 64b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 64e:	8b 13                	mov    (%ebx),%edx
 650:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 652:	5b                   	pop    %ebx
 653:	5e                   	pop    %esi
 654:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 655:	89 0d a0 07 00 00    	mov    %ecx,0x7a0
}
 65b:	c3                   	ret    
 65c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 15 a0 07 00 00    	mov    0x7a0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	83 c0 07             	add    $0x7,%eax
 675:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 678:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 67d:	0f 84 8a 00 00 00    	je     70d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 685:	8b 41 04             	mov    0x4(%ecx),%eax
 688:	39 c3                	cmp    %eax,%ebx
 68a:	76 1a                	jbe    6a6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 68c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 693:	3b 0d a0 07 00 00    	cmp    0x7a0,%ecx
 699:	89 ca                	mov    %ecx,%edx
 69b:	74 29                	je     6c6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 69f:	8b 41 04             	mov    0x4(%ecx),%eax
 6a2:	39 c3                	cmp    %eax,%ebx
 6a4:	77 ed                	ja     693 <malloc+0x33>
      if(p->s.size == nunits)
 6a6:	39 c3                	cmp    %eax,%ebx
 6a8:	74 5d                	je     707 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6aa:	29 d8                	sub    %ebx,%eax
 6ac:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6af:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 6b2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 6b5:	89 15 a0 07 00 00    	mov    %edx,0x7a0
      return (void*) (p + 1);
 6bb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6be:	83 c4 0c             	add    $0xc,%esp
 6c1:	5b                   	pop    %ebx
 6c2:	5e                   	pop    %esi
 6c3:	5f                   	pop    %edi
 6c4:	5d                   	pop    %ebp
 6c5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6c6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6cc:	89 de                	mov    %ebx,%esi
 6ce:	89 f8                	mov    %edi,%eax
 6d0:	76 29                	jbe    6fb <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 6d2:	89 04 24             	mov    %eax,(%esp)
 6d5:	e8 96 fc ff ff       	call   370 <sbrk>
  if(p == (char*) -1)
 6da:	83 f8 ff             	cmp    $0xffffffff,%eax
 6dd:	74 18                	je     6f7 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6df:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6e2:	83 c0 08             	add    $0x8,%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 f3 fe ff ff       	call   5e0 <free>
  return freep;
 6ed:	8b 15 a0 07 00 00    	mov    0x7a0,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6f3:	85 d2                	test   %edx,%edx
 6f5:	75 a6                	jne    69d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6f7:	31 c0                	xor    %eax,%eax
 6f9:	eb c3                	jmp    6be <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6fb:	be 00 10 00 00       	mov    $0x1000,%esi
 700:	b8 00 80 00 00       	mov    $0x8000,%eax
 705:	eb cb                	jmp    6d2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 707:	8b 01                	mov    (%ecx),%eax
 709:	89 02                	mov    %eax,(%edx)
 70b:	eb a8                	jmp    6b5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 70d:	ba 98 07 00 00       	mov    $0x798,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 712:	c7 05 a0 07 00 00 98 	movl   $0x798,0x7a0
 719:	07 00 00 
 71c:	c7 05 98 07 00 00 98 	movl   $0x798,0x798
 723:	07 00 00 
    base.s.size = 0;
 726:	c7 05 9c 07 00 00 00 	movl   $0x0,0x79c
 72d:	00 00 00 
 730:	e9 4e ff ff ff       	jmp    683 <malloc+0x23>
