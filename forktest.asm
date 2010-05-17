
_forktest:     file format elf32-i386

Disassembly of section .text:

00000000 <printf>:
#include "stat.h"
#include "user.h"

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	89 1c 24             	mov    %ebx,(%esp)
   d:	e8 8e 01 00 00       	call   1a0 <strlen>
  12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  16:	89 44 24 08          	mov    %eax,0x8(%esp)
  1a:	8b 45 08             	mov    0x8(%ebp),%eax
  1d:	89 04 24             	mov    %eax,(%esp)
  20:	e8 33 03 00 00       	call   358 <write>
}
  25:	83 c4 14             	add    $0x14,%esp
  28:	5b                   	pop    %ebx
  29:	5d                   	pop    %ebp
  2a:	c3                   	ret    
  2b:	90                   	nop    
  2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000030 <forktest>:

void
forktest(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
  34:	31 db                	xor    %ebx,%ebx
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  36:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
  39:	c7 44 24 04 d8 03 00 	movl   $0x3d8,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 b3 ff ff ff       	call   0 <printf>
  4d:	eb 13                	jmp    62 <forktest+0x32>
  4f:	90                   	nop    

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
  50:	74 68                	je     ba <forktest+0x8a>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
  52:	83 c3 01             	add    $0x1,%ebx
  55:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  5b:	90                   	nop    
  5c:	8d 74 26 00          	lea    0x0(%esi),%esi
  60:	74 5d                	je     bf <forktest+0x8f>
    pid = fork();
  62:	e8 c9 02 00 00       	call   330 <fork>
    if(pid < 0)
  67:	83 f8 00             	cmp    $0x0,%eax
  6a:	7d e4                	jge    50 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
  6c:	85 db                	test   %ebx,%ebx
  6e:	66 90                	xchg   %ax,%ax
  70:	7e 10                	jle    82 <forktest+0x52>
    if(wait() < 0){
  72:	e8 c9 02 00 00       	call   340 <wait>
  77:	85 c0                	test   %eax,%eax
  79:	78 2b                	js     a6 <forktest+0x76>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
  7b:	83 eb 01             	sub    $0x1,%ebx
  7e:	66 90                	xchg   %ax,%ax
  80:	75 f0                	jne    72 <forktest+0x42>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  82:	e8 b9 02 00 00       	call   340 <wait>
  87:	83 c0 01             	add    $0x1,%eax
  8a:	75 4c                	jne    d8 <forktest+0xa8>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
  8c:	c7 44 24 04 0a 04 00 	movl   $0x40a,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 60 ff ff ff       	call   0 <printf>
}
  a0:	83 c4 14             	add    $0x14,%esp
  a3:	5b                   	pop    %ebx
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    
    exit();
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
  a6:	c7 44 24 04 e3 03 00 	movl   $0x3e3,0x4(%esp)
  ad:	00 
  ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b5:	e8 46 ff ff ff       	call   0 <printf>
      exit();
  ba:	e8 79 02 00 00       	call   338 <exit>
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
  bf:	c7 44 24 04 18 04 00 	movl   $0x418,0x4(%esp)
  c6:	00 
  c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ce:	e8 2d ff ff ff       	call   0 <printf>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
  d3:	e8 60 02 00 00       	call   338 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
  d8:	c7 44 24 04 f7 03 00 	movl   $0x3f7,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 14 ff ff ff       	call   0 <printf>
    exit();
  ec:	e8 47 02 00 00       	call   338 <exit>
  f1:	eb 0d                	jmp    100 <main>
  f3:	90                   	nop    
  f4:	90                   	nop    
  f5:	90                   	nop    
  f6:	90                   	nop    
  f7:	90                   	nop    
  f8:	90                   	nop    
  f9:	90                   	nop    
  fa:	90                   	nop    
  fb:	90                   	nop    
  fc:	90                   	nop    
  fd:	90                   	nop    
  fe:	90                   	nop    
  ff:	90                   	nop    

00000100 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
 100:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 104:	83 e4 f0             	and    $0xfffffff0,%esp
 107:	ff 71 fc             	pushl  -0x4(%ecx)
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	51                   	push   %ecx
 10e:	83 ec 04             	sub    $0x4,%esp
  forktest();
 111:	e8 1a ff ff ff       	call   30 <forktest>
  exit();
 116:	e8 1d 02 00 00       	call   338 <exit>
 11b:	90                   	nop    
 11c:	90                   	nop    
 11d:	90                   	nop    
 11e:	90                   	nop    
 11f:	90                   	nop    

00000120 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 5d 08             	mov    0x8(%ebp),%ebx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 12a:	89 da                	mov    %ebx,%edx
 12c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 130:	0f b6 01             	movzbl (%ecx),%eax
 133:	83 c1 01             	add    $0x1,%ecx
 136:	88 02                	mov    %al,(%edx)
 138:	83 c2 01             	add    $0x1,%edx
 13b:	84 c0                	test   %al,%al
 13d:	75 f1                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13f:	89 d8                	mov    %ebx,%eax
 141:	5b                   	pop    %ebx
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    
 144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 14a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
 156:	53                   	push   %ebx
 157:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 15a:	0f b6 01             	movzbl (%ecx),%eax
 15d:	84 c0                	test   %al,%al
 15f:	74 24                	je     185 <strcmp+0x35>
 161:	0f b6 13             	movzbl (%ebx),%edx
 164:	38 d0                	cmp    %dl,%al
 166:	74 12                	je     17a <strcmp+0x2a>
 168:	eb 1e                	jmp    188 <strcmp+0x38>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 170:	0f b6 13             	movzbl (%ebx),%edx
 173:	83 c1 01             	add    $0x1,%ecx
 176:	38 d0                	cmp    %dl,%al
 178:	75 0e                	jne    188 <strcmp+0x38>
 17a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 17e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 181:	84 c0                	test   %al,%al
 183:	75 eb                	jne    170 <strcmp+0x20>
 185:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 188:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 189:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 18c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 18d:	0f b6 d2             	movzbl %dl,%edx
 190:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001a0 <strlen>:

uint
strlen(char *s)
{
 1a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1a1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1a8:	80 39 00             	cmpb   $0x0,(%ecx)
 1ab:	74 0e                	je     1bb <strlen+0x1b>
 1ad:	31 d2                	xor    %edx,%edx
 1af:	90                   	nop    
 1b0:	83 c2 01             	add    $0x1,%edx
 1b3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 1b7:	89 d0                	mov    %edx,%eax
 1b9:	75 f5                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 45 10             	mov    0x10(%ebp),%eax
 1c6:	53                   	push   %ebx
 1c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ca:	85 c0                	test   %eax,%eax
 1cc:	74 10                	je     1de <memset+0x1e>
 1ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 1d2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 1d4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 1d7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 1da:	39 c2                	cmp    %eax,%edx
 1dc:	75 f6                	jne    1d4 <memset+0x14>
    *d++ = c;
  return dst;
}
 1de:	89 d8                	mov    %ebx,%eax
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 0c                	jne    20d <strchr+0x1d>
 201:	eb 11                	jmp    214 <strchr+0x24>
 203:	83 c0 01             	add    $0x1,%eax
 206:	0f b6 10             	movzbl (%eax),%edx
 209:	84 d2                	test   %dl,%dl
 20b:	74 07                	je     214 <strchr+0x24>
    if(*s == c)
 20d:	38 ca                	cmp    %cl,%dl
 20f:	90                   	nop    
 210:	75 f1                	jne    203 <strchr+0x13>
      return (char*) s;
  return 0;
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 215:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 217:	c3                   	ret    
 218:	90                   	nop    
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000220 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
 226:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 227:	31 db                	xor    %ebx,%ebx
 229:	0f b6 11             	movzbl (%ecx),%edx
 22c:	8d 42 d0             	lea    -0x30(%edx),%eax
 22f:	3c 09                	cmp    $0x9,%al
 231:	77 18                	ja     24b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 233:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 236:	0f be d2             	movsbl %dl,%edx
 239:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 241:	83 c1 01             	add    $0x1,%ecx
 244:	8d 42 d0             	lea    -0x30(%edx),%eax
 247:	3c 09                	cmp    $0x9,%al
 249:	76 e8                	jbe    233 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 24b:	89 d8                	mov    %ebx,%eax
 24d:	5b                   	pop    %ebx
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	8b 4d 10             	mov    0x10(%ebp),%ecx
 256:	56                   	push   %esi
 257:	8b 75 08             	mov    0x8(%ebp),%esi
 25a:	53                   	push   %ebx
 25b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 c9                	test   %ecx,%ecx
 260:	7e 10                	jle    272 <memmove+0x22>
 262:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 264:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 268:	88 04 32             	mov    %al,(%edx,%esi,1)
 26b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	39 ca                	cmp    %ecx,%edx
 270:	75 f2                	jne    264 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 272:	89 f0                	mov    %esi,%eax
 274:	5b                   	pop    %ebx
 275:	5e                   	pop    %esi
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop    
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000280 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 289:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 28c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 28f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29b:	00 
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 d4 00 00 00       	call   378 <open>
  if(fd < 0)
 2a4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2a8:	78 19                	js     2c3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 1c 24             	mov    %ebx,(%esp)
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	e8 d7 00 00 00       	call   390 <fstat>
  close(fd);
 2b9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2bc:	89 c6                	mov    %eax,%esi
  close(fd);
 2be:	e8 9d 00 00 00       	call   360 <close>
  return r;
}
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2c8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2cb:	89 ec                	mov    %ebp,%esp
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
 2cf:	90                   	nop    

000002d0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	31 f6                	xor    %esi,%esi
 2d7:	53                   	push   %ebx
 2d8:	83 ec 1c             	sub    $0x1c,%esp
 2db:	8b 7d 08             	mov    0x8(%ebp),%edi
 2de:	eb 06                	jmp    2e6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e0:	3c 0d                	cmp    $0xd,%al
 2e2:	74 39                	je     31d <gets+0x4d>
 2e4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2e9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ec:	7d 31                	jge    31f <gets+0x4f>
    cc = read(0, &c, 1);
 2ee:	8d 45 f3             	lea    -0xd(%ebp),%eax
 2f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f8:	00 
 2f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 304:	e8 47 00 00 00       	call   350 <read>
    if(cc < 1)
 309:	85 c0                	test   %eax,%eax
 30b:	7e 12                	jle    31f <gets+0x4f>
      break;
    buf[i++] = c;
 30d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 311:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 315:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 319:	3c 0a                	cmp    $0xa,%al
 31b:	75 c3                	jne    2e0 <gets+0x10>
 31d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 31f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 323:	89 f8                	mov    %edi,%eax
 325:	83 c4 1c             	add    $0x1c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	90                   	nop    
 32e:	90                   	nop    
 32f:	90                   	nop    

00000330 <fork>:
 330:	b8 01 00 00 00       	mov    $0x1,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <exit>:
 338:	b8 02 00 00 00       	mov    $0x2,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <wait>:
 340:	b8 03 00 00 00       	mov    $0x3,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <pipe>:
 348:	b8 04 00 00 00       	mov    $0x4,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <read>:
 350:	b8 06 00 00 00       	mov    $0x6,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <write>:
 358:	b8 05 00 00 00       	mov    $0x5,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <close>:
 360:	b8 07 00 00 00       	mov    $0x7,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <kill>:
 368:	b8 08 00 00 00       	mov    $0x8,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <exec>:
 370:	b8 09 00 00 00       	mov    $0x9,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <open>:
 378:	b8 0a 00 00 00       	mov    $0xa,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <mknod>:
 380:	b8 0b 00 00 00       	mov    $0xb,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <unlink>:
 388:	b8 0c 00 00 00       	mov    $0xc,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <fstat>:
 390:	b8 0d 00 00 00       	mov    $0xd,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <link>:
 398:	b8 0e 00 00 00       	mov    $0xe,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <mkdir>:
 3a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <chdir>:
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <dup>:
 3b0:	b8 11 00 00 00       	mov    $0x11,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <getpid>:
 3b8:	b8 12 00 00 00       	mov    $0x12,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <sbrk>:
 3c0:	b8 13 00 00 00       	mov    $0x13,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <sleep>:
 3c8:	b8 14 00 00 00       	mov    $0x14,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <kalloctest>:
 3d0:	b8 15 00 00 00       	mov    $0x15,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    
