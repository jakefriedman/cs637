
_chktest:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	83 ec 48             	sub    $0x48,%esp

char * file1 = "usertests";
int fd1 = open(file1, O_RDONLY);
  10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  17:	00 
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

int main() {
  18:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  21:	89 7d fc             	mov    %edi,-0x4(%ebp)

char * file1 = "usertests";
int fd1 = open(file1, O_RDONLY);
  24:	c7 04 24 68 07 00 00 	movl   $0x768,(%esp)
  2b:	e8 28 03 00 00       	call   358 <open>
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);
  30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  37:	00 
  38:	c7 04 24 72 07 00 00 	movl   $0x772,(%esp)
#include "fcntl.h"

int main() {

char * file1 = "usertests";
int fd1 = open(file1, O_RDONLY);
  3f:	89 c3                	mov    %eax,%ebx
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);
  41:	e8 12 03 00 00       	call   358 <open>

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
  46:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
  4d:	00 
  4e:	89 1c 24             	mov    %ebx,(%esp)
int main() {

char * file1 = "usertests";
int fd1 = open(file1, O_RDONLY);
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);
  51:	89 c7                	mov    %eax,%edi

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
  53:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  56:	89 44 24 04          	mov    %eax,0x4(%esp)
  5a:	e8 d1 02 00 00       	call   330 <read>
int ch1 = check(fd1, 2);
  5f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  66:	00 
  67:	89 1c 24             	mov    %ebx,(%esp)
int fd1 = open(file1, O_RDONLY);
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
  6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
int ch1 = check(fd1, 2);
  6d:	e8 76 03 00 00       	call   3e8 <check>
int ch2 = check(fd2, 2);
  72:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  79:	00 
  7a:	89 3c 24             	mov    %edi,(%esp)
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
int ch1 = check(fd1, 2);
  7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
int ch2 = check(fd2, 2);
  80:	e8 63 03 00 00       	call   3e8 <check>
close(fd1);
  85:	89 1c 24             	mov    %ebx,(%esp)
int fd2 = open (file2, O_RDONLY);

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
int ch1 = check(fd1, 2);
int ch2 = check(fd2, 2);
  88:	89 c6                	mov    %eax,%esi
close(fd1);
  8a:	e8 b1 02 00 00       	call   340 <close>
close(fd2);
  8f:	89 3c 24             	mov    %edi,(%esp)
  92:	e8 a9 02 00 00       	call   340 <close>
printf(1,"check on read file %d, check on unread file %d, read ret %d\n",ch1,ch2,rd1);
  97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  9a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  9e:	c7 44 24 04 a4 07 00 	movl   $0x7a4,0x4(%esp)
  a5:	00 
  a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  b8:	e8 e3 03 00 00       	call   4a0 <printf>
printf(1, "fd1: %d, fd2 (unread): %d \n", fd1,fd2);
  bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  c5:	c7 44 24 04 7b 07 00 	movl   $0x77b,0x4(%esp)
  cc:	00 
  cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d4:	e8 c7 03 00 00       	call   4a0 <printf>
printf(1, "%s :buffer\n", &buffer);
  d9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  e0:	c7 44 24 04 97 07 00 	movl   $0x797,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	e8 ac 03 00 00       	call   4a0 <printf>
exit();
  f4:	e8 1f 02 00 00       	call   318 <exit>
  f9:	90                   	nop    
  fa:	90                   	nop    
  fb:	90                   	nop    
  fc:	90                   	nop    
  fd:	90                   	nop    
  fe:	90                   	nop    
  ff:	90                   	nop    

00000100 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 5d 08             	mov    0x8(%ebp),%ebx
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 10a:	89 da                	mov    %ebx,%edx
 10c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	0f b6 01             	movzbl (%ecx),%eax
 113:	83 c1 01             	add    $0x1,%ecx
 116:	88 02                	mov    %al,(%edx)
 118:	83 c2 01             	add    $0x1,%edx
 11b:	84 c0                	test   %al,%al
 11d:	75 f1                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 11f:	89 d8                	mov    %ebx,%eax
 121:	5b                   	pop    %ebx
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    
 124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 12a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
 136:	53                   	push   %ebx
 137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 13a:	0f b6 01             	movzbl (%ecx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	74 24                	je     165 <strcmp+0x35>
 141:	0f b6 13             	movzbl (%ebx),%edx
 144:	38 d0                	cmp    %dl,%al
 146:	74 12                	je     15a <strcmp+0x2a>
 148:	eb 1e                	jmp    168 <strcmp+0x38>
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 150:	0f b6 13             	movzbl (%ebx),%edx
 153:	83 c1 01             	add    $0x1,%ecx
 156:	38 d0                	cmp    %dl,%al
 158:	75 0e                	jne    168 <strcmp+0x38>
 15a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 15e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	84 c0                	test   %al,%al
 163:	75 eb                	jne    150 <strcmp+0x20>
 165:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 168:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 169:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 16c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16d:	0f b6 d2             	movzbl %dl,%edx
 170:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000180 <strlen>:

uint
strlen(char *s)
{
 180:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 181:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 183:	89 e5                	mov    %esp,%ebp
 185:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 188:	80 39 00             	cmpb   $0x0,(%ecx)
 18b:	74 0e                	je     19b <strlen+0x1b>
 18d:	31 d2                	xor    %edx,%edx
 18f:	90                   	nop    
 190:	83 c2 01             	add    $0x1,%edx
 193:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 197:	89 d0                	mov    %edx,%eax
 199:	75 f5                	jne    190 <strlen+0x10>
    ;
  return n;
}
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 45 10             	mov    0x10(%ebp),%eax
 1a6:	53                   	push   %ebx
 1a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 1aa:	85 c0                	test   %eax,%eax
 1ac:	74 10                	je     1be <memset+0x1e>
 1ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 1b2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 1b4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 1b7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ba:	39 c2                	cmp    %eax,%edx
 1bc:	75 f6                	jne    1b4 <memset+0x14>
    *d++ = c;
  return dst;
}
 1be:	89 d8                	mov    %ebx,%eax
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 0c                	jne    1ed <strchr+0x1d>
 1e1:	eb 11                	jmp    1f4 <strchr+0x24>
 1e3:	83 c0 01             	add    $0x1,%eax
 1e6:	0f b6 10             	movzbl (%eax),%edx
 1e9:	84 d2                	test   %dl,%dl
 1eb:	74 07                	je     1f4 <strchr+0x24>
    if(*s == c)
 1ed:	38 ca                	cmp    %cl,%dl
 1ef:	90                   	nop    
 1f0:	75 f1                	jne    1e3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    
 1f4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 1f7:	c3                   	ret    
 1f8:	90                   	nop    
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000200 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 4d 08             	mov    0x8(%ebp),%ecx
 206:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	31 db                	xor    %ebx,%ebx
 209:	0f b6 11             	movzbl (%ecx),%edx
 20c:	8d 42 d0             	lea    -0x30(%edx),%eax
 20f:	3c 09                	cmp    $0x9,%al
 211:	77 18                	ja     22b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 213:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 216:	0f be d2             	movsbl %dl,%edx
 219:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 221:	83 c1 01             	add    $0x1,%ecx
 224:	8d 42 d0             	lea    -0x30(%edx),%eax
 227:	3c 09                	cmp    $0x9,%al
 229:	76 e8                	jbe    213 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 22b:	89 d8                	mov    %ebx,%eax
 22d:	5b                   	pop    %ebx
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    

00000230 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 10             	mov    0x10(%ebp),%ecx
 236:	56                   	push   %esi
 237:	8b 75 08             	mov    0x8(%ebp),%esi
 23a:	53                   	push   %ebx
 23b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	85 c9                	test   %ecx,%ecx
 240:	7e 10                	jle    252 <memmove+0x22>
 242:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 244:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 248:	88 04 32             	mov    %al,(%edx,%esi,1)
 24b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	39 ca                	cmp    %ecx,%edx
 250:	75 f2                	jne    244 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 252:	89 f0                	mov    %esi,%eax
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    
 258:	90                   	nop    
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000260 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 269:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 26c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 26f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 27b:	00 
 27c:	89 04 24             	mov    %eax,(%esp)
 27f:	e8 d4 00 00 00       	call   358 <open>
  if(fd < 0)
 284:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 288:	78 19                	js     2a3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	89 1c 24             	mov    %ebx,(%esp)
 290:	89 44 24 04          	mov    %eax,0x4(%esp)
 294:	e8 d7 00 00 00       	call   370 <fstat>
  close(fd);
 299:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 29c:	89 c6                	mov    %eax,%esi
  close(fd);
 29e:	e8 9d 00 00 00       	call   340 <close>
  return r;
}
 2a3:	89 f0                	mov    %esi,%eax
 2a5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2ab:	89 ec                	mov    %ebp,%esp
 2ad:	5d                   	pop    %ebp
 2ae:	c3                   	ret    
 2af:	90                   	nop    

000002b0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	31 f6                	xor    %esi,%esi
 2b7:	53                   	push   %ebx
 2b8:	83 ec 1c             	sub    $0x1c,%esp
 2bb:	8b 7d 08             	mov    0x8(%ebp),%edi
 2be:	eb 06                	jmp    2c6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c0:	3c 0d                	cmp    $0xd,%al
 2c2:	74 39                	je     2fd <gets+0x4d>
 2c4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2c9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2cc:	7d 31                	jge    2ff <gets+0x4f>
    cc = read(0, &c, 1);
 2ce:	8d 45 f3             	lea    -0xd(%ebp),%eax
 2d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2d8:	00 
 2d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2e4:	e8 47 00 00 00       	call   330 <read>
    if(cc < 1)
 2e9:	85 c0                	test   %eax,%eax
 2eb:	7e 12                	jle    2ff <gets+0x4f>
      break;
    buf[i++] = c;
 2ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2f1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 2f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2f9:	3c 0a                	cmp    $0xa,%al
 2fb:	75 c3                	jne    2c0 <gets+0x10>
 2fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2ff:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 303:	89 f8                	mov    %edi,%eax
 305:	83 c4 1c             	add    $0x1c,%esp
 308:	5b                   	pop    %ebx
 309:	5e                   	pop    %esi
 30a:	5f                   	pop    %edi
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
 30d:	90                   	nop    
 30e:	90                   	nop    
 30f:	90                   	nop    

00000310 <fork>:
 310:	b8 01 00 00 00       	mov    $0x1,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <exit>:
 318:	b8 02 00 00 00       	mov    $0x2,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <wait>:
 320:	b8 03 00 00 00       	mov    $0x3,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <pipe>:
 328:	b8 04 00 00 00       	mov    $0x4,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <read>:
 330:	b8 06 00 00 00       	mov    $0x6,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <write>:
 338:	b8 05 00 00 00       	mov    $0x5,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <close>:
 340:	b8 07 00 00 00       	mov    $0x7,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <kill>:
 348:	b8 08 00 00 00       	mov    $0x8,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <exec>:
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <open>:
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <mknod>:
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <unlink>:
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <fstat>:
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <link>:
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <mkdir>:
 380:	b8 0f 00 00 00       	mov    $0xf,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <chdir>:
 388:	b8 10 00 00 00       	mov    $0x10,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <dup>:
 390:	b8 11 00 00 00       	mov    $0x11,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <getpid>:
 398:	b8 12 00 00 00       	mov    $0x12,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <sbrk>:
 3a0:	b8 13 00 00 00       	mov    $0x13,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <sleep>:
 3a8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <tick>:
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <fork_tickets>:
 3b8:	b8 16 00 00 00       	mov    $0x16,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <fork_thread>:
 3c0:	b8 17 00 00 00       	mov    $0x17,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <wait_thread>:
 3c8:	b8 18 00 00 00       	mov    $0x18,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <sleep_cond>:
 3d0:	b8 19 00 00 00       	mov    $0x19,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <wake_cond>:
 3d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <xchng>:
 3e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <check>:
 3e8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 18             	sub    $0x18,%esp
 3f6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 3f9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 3fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 403:	00 
 404:	89 54 24 04          	mov    %edx,0x4(%esp)
 408:	89 04 24             	mov    %eax,(%esp)
 40b:	e8 28 ff ff ff       	call   338 <write>
}
 410:	c9                   	leave  
 411:	c3                   	ret    
 412:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000420 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	89 ce                	mov    %ecx,%esi
 427:	53                   	push   %ebx
 428:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 431:	85 c9                	test   %ecx,%ecx
 433:	74 04                	je     439 <printint+0x19>
 435:	85 d2                	test   %edx,%edx
 437:	78 54                	js     48d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 439:	89 d0                	mov    %edx,%eax
 43b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 442:	31 db                	xor    %ebx,%ebx
 444:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 447:	31 d2                	xor    %edx,%edx
 449:	f7 f6                	div    %esi
 44b:	89 c1                	mov    %eax,%ecx
 44d:	0f b6 82 eb 07 00 00 	movzbl 0x7eb(%edx),%eax
 454:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 457:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 45a:	85 c9                	test   %ecx,%ecx
 45c:	89 c8                	mov    %ecx,%eax
 45e:	75 e7                	jne    447 <printint+0x27>
  if(neg)
 460:	8b 45 e0             	mov    -0x20(%ebp),%eax
 463:	85 c0                	test   %eax,%eax
 465:	74 08                	je     46f <printint+0x4f>
    buf[i++] = '-';
 467:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 46c:	83 c3 01             	add    $0x1,%ebx
 46f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 472:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 476:	83 eb 01             	sub    $0x1,%ebx
 479:	8b 45 dc             	mov    -0x24(%ebp),%eax
 47c:	e8 6f ff ff ff       	call   3f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 481:	39 fb                	cmp    %edi,%ebx
 483:	75 ed                	jne    472 <printint+0x52>
    putc(fd, buf[i]);
}
 485:	83 c4 1c             	add    $0x1c,%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 48d:	89 d0                	mov    %edx,%eax
 48f:	f7 d8                	neg    %eax
 491:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 498:	eb a8                	jmp    442 <printint+0x22>
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ac:	0f b6 02             	movzbl (%edx),%eax
 4af:	84 c0                	test   %al,%al
 4b1:	0f 84 84 00 00 00    	je     53b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ba:	89 d7                	mov    %edx,%edi
 4bc:	31 f6                	xor    %esi,%esi
 4be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 4c1:	eb 18                	jmp    4db <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c3:	83 fb 25             	cmp    $0x25,%ebx
 4c6:	75 7b                	jne    543 <printf+0xa3>
 4c8:	66 be 25 00          	mov    $0x25,%si
 4cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4d4:	83 c7 01             	add    $0x1,%edi
 4d7:	84 c0                	test   %al,%al
 4d9:	74 60                	je     53b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 4db:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4dd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4e0:	74 e1                	je     4c3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e2:	83 fe 25             	cmp    $0x25,%esi
 4e5:	75 e9                	jne    4d0 <printf+0x30>
      if(c == 'd'){
 4e7:	83 fb 64             	cmp    $0x64,%ebx
 4ea:	0f 84 db 00 00 00    	je     5cb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f0:	83 fb 78             	cmp    $0x78,%ebx
 4f3:	74 5b                	je     550 <printf+0xb0>
 4f5:	83 fb 70             	cmp    $0x70,%ebx
 4f8:	74 56                	je     550 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4fa:	83 fb 73             	cmp    $0x73,%ebx
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	74 72                	je     574 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 502:	83 fb 63             	cmp    $0x63,%ebx
 505:	0f 84 a7 00 00 00    	je     5b2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 50b:	83 fb 25             	cmp    $0x25,%ebx
 50e:	66 90                	xchg   %ax,%ax
 510:	0f 84 da 00 00 00    	je     5f0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 516:	8b 45 08             	mov    0x8(%ebp),%eax
 519:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 51e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 520:	e8 cb fe ff ff       	call   3f0 <putc>
        putc(fd, c);
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	0f be d3             	movsbl %bl,%edx
 52b:	e8 c0 fe ff ff       	call   3f0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 530:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 534:	83 c7 01             	add    $0x1,%edi
 537:	84 c0                	test   %al,%al
 539:	75 a0                	jne    4db <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 53b:	83 c4 0c             	add    $0xc,%esp
 53e:	5b                   	pop    %ebx
 53f:	5e                   	pop    %esi
 540:	5f                   	pop    %edi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f be d3             	movsbl %bl,%edx
 549:	e8 a2 fe ff ff       	call   3f0 <putc>
 54e:	eb 80                	jmp    4d0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 550:	8b 45 f0             	mov    -0x10(%ebp),%eax
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 558:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 55a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 561:	8b 10                	mov    (%eax),%edx
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	e8 b5 fe ff ff       	call   420 <printint>
        ap++;
 56b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 56f:	e9 5c ff ff ff       	jmp    4d0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 574:	8b 55 f0             	mov    -0x10(%ebp),%edx
 577:	8b 02                	mov    (%edx),%eax
        ap++;
 579:	83 c2 04             	add    $0x4,%edx
 57c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 57f:	ba e4 07 00 00       	mov    $0x7e4,%edx
 584:	85 c0                	test   %eax,%eax
 586:	75 26                	jne    5ae <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 588:	0f b6 02             	movzbl (%edx),%eax
 58b:	84 c0                	test   %al,%al
 58d:	74 18                	je     5a7 <printf+0x107>
 58f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 591:	0f be d0             	movsbl %al,%edx
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	e8 54 fe ff ff       	call   3f0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 59c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 5a0:	83 c3 01             	add    $0x1,%ebx
 5a3:	84 c0                	test   %al,%al
 5a5:	75 ea                	jne    591 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5a7:	31 f6                	xor    %esi,%esi
 5a9:	e9 22 ff ff ff       	jmp    4d0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5ae:	89 c2                	mov    %eax,%edx
 5b0:	eb d6                	jmp    588 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 5b5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	0f be 11             	movsbl (%ecx),%edx
 5bd:	e8 2e fe ff ff       	call   3f0 <putc>
        ap++;
 5c2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5c6:	e9 05 ff ff ff       	jmp    4d0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5d3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5dd:	8b 10                	mov    (%eax),%edx
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	e8 39 fe ff ff       	call   420 <printint>
        ap++;
 5e7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5eb:	e9 e0 fe ff ff       	jmp    4d0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	ba 25 00 00 00       	mov    $0x25,%edx
 5f8:	31 f6                	xor    %esi,%esi
 5fa:	e8 f1 fd ff ff       	call   3f0 <putc>
 5ff:	e9 cc fe ff ff       	jmp    4d0 <printf+0x30>
 604:	90                   	nop    
 605:	90                   	nop    
 606:	90                   	nop    
 607:	90                   	nop    
 608:	90                   	nop    
 609:	90                   	nop    
 60a:	90                   	nop    
 60b:	90                   	nop    
 60c:	90                   	nop    
 60d:	90                   	nop    
 60e:	90                   	nop    
 60f:	90                   	nop    

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8b 0d 04 08 00 00    	mov    0x804,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 617:	89 e5                	mov    %esp,%ebp
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 61e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	39 d9                	cmp    %ebx,%ecx
 623:	73 18                	jae    63d <free+0x2d>
 625:	8b 11                	mov    (%ecx),%edx
 627:	39 d3                	cmp    %edx,%ebx
 629:	72 17                	jb     642 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62b:	39 d1                	cmp    %edx,%ecx
 62d:	72 08                	jb     637 <free+0x27>
 62f:	39 d9                	cmp    %ebx,%ecx
 631:	72 0f                	jb     642 <free+0x32>
 633:	39 d3                	cmp    %edx,%ebx
 635:	72 0b                	jb     642 <free+0x32>
 637:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	39 d9                	cmp    %ebx,%ecx
 63b:	72 e8                	jb     625 <free+0x15>
 63d:	8b 11                	mov    (%ecx),%edx
 63f:	90                   	nop    
 640:	eb e9                	jmp    62b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 642:	8b 73 04             	mov    0x4(%ebx),%esi
 645:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 648:	39 d0                	cmp    %edx,%eax
 64a:	74 18                	je     664 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 64e:	8b 51 04             	mov    0x4(%ecx),%edx
 651:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 654:	39 d8                	cmp    %ebx,%eax
 656:	74 20                	je     678 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 658:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 65a:	5b                   	pop    %ebx
 65b:	5e                   	pop    %esi
 65c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 65d:	89 0d 04 08 00 00    	mov    %ecx,0x804
}
 663:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 664:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 667:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 669:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 66c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 66f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 671:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 674:	39 d8                	cmp    %ebx,%eax
 676:	75 e0                	jne    658 <free+0x48>
    p->s.size += bp->s.size;
 678:	03 53 04             	add    0x4(%ebx),%edx
 67b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 67e:	8b 13                	mov    (%ebx),%edx
 680:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 685:	89 0d 04 08 00 00    	mov    %ecx,0x804
}
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 04 08 00 00    	mov    0x804,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	83 c0 07             	add    $0x7,%eax
 6a5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6a8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6aa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6ad:	0f 84 8a 00 00 00    	je     73d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6b5:	8b 41 04             	mov    0x4(%ecx),%eax
 6b8:	39 c3                	cmp    %eax,%ebx
 6ba:	76 1a                	jbe    6d6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6bc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 6c3:	3b 0d 04 08 00 00    	cmp    0x804,%ecx
 6c9:	89 ca                	mov    %ecx,%edx
 6cb:	74 29                	je     6f6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6cd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6cf:	8b 41 04             	mov    0x4(%ecx),%eax
 6d2:	39 c3                	cmp    %eax,%ebx
 6d4:	77 ed                	ja     6c3 <malloc+0x33>
      if(p->s.size == nunits)
 6d6:	39 c3                	cmp    %eax,%ebx
 6d8:	74 5d                	je     737 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6da:	29 d8                	sub    %ebx,%eax
 6dc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6df:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 6e2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 6e5:	89 15 04 08 00 00    	mov    %edx,0x804
      return (void*) (p + 1);
 6eb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ee:	83 c4 0c             	add    $0xc,%esp
 6f1:	5b                   	pop    %ebx
 6f2:	5e                   	pop    %esi
 6f3:	5f                   	pop    %edi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6f6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6fc:	89 de                	mov    %ebx,%esi
 6fe:	89 f8                	mov    %edi,%eax
 700:	76 29                	jbe    72b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 702:	89 04 24             	mov    %eax,(%esp)
 705:	e8 96 fc ff ff       	call   3a0 <sbrk>
  if(p == (char*) -1)
 70a:	83 f8 ff             	cmp    $0xffffffff,%eax
 70d:	74 18                	je     727 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 70f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 712:	83 c0 08             	add    $0x8,%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 f3 fe ff ff       	call   610 <free>
  return freep;
 71d:	8b 15 04 08 00 00    	mov    0x804,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 723:	85 d2                	test   %edx,%edx
 725:	75 a6                	jne    6cd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 727:	31 c0                	xor    %eax,%eax
 729:	eb c3                	jmp    6ee <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 72b:	be 00 10 00 00       	mov    $0x1000,%esi
 730:	b8 00 80 00 00       	mov    $0x8000,%eax
 735:	eb cb                	jmp    702 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 737:	8b 01                	mov    (%ecx),%eax
 739:	89 02                	mov    %eax,(%edx)
 73b:	eb a8                	jmp    6e5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 73d:	ba fc 07 00 00       	mov    $0x7fc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 742:	c7 05 04 08 00 00 fc 	movl   $0x7fc,0x804
 749:	07 00 00 
 74c:	c7 05 fc 07 00 00 fc 	movl   $0x7fc,0x7fc
 753:	07 00 00 
    base.s.size = 0;
 756:	c7 05 00 08 00 00 00 	movl   $0x0,0x800
 75d:	00 00 00 
 760:	e9 4e ff ff ff       	jmp    6b3 <malloc+0x23>
