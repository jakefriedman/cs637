
_init:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:

char *sh_args[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
printf(1,"in init.c");
  12:	c7 44 24 04 85 07 00 	movl   $0x785,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 9a 04 00 00       	call   4c0 <printf>
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  26:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 8f 07 00 00 	movl   $0x78f,(%esp)
  35:	e8 3e 03 00 00       	call   378 <open>
  3a:	85 c0                	test   %eax,%eax
  3c:	0f 88 a7 00 00 00    	js     e9 <main+0xe9>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  49:	e8 62 03 00 00       	call   3b0 <dup>
  dup(0);  // stderr
  4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  55:	e8 56 03 00 00       	call   3b0 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  5a:	c7 44 24 04 97 07 00 	movl   $0x797,0x4(%esp)
  61:	00 
  62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  69:	e8 52 04 00 00       	call   4c0 <printf>
    pid = fork();
  6e:	e8 bd 02 00 00       	call   330 <fork>
    if(pid < 0){
  73:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  76:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  78:	7c 29                	jl     a3 <main+0xa3>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  7a:	74 40                	je     bc <main+0xbc>
  7c:	8d 74 26 00          	lea    0x0(%esi),%esi
      exec("sh", sh_args);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  80:	e8 bb 02 00 00       	call   340 <wait>
  85:	85 c0                	test   %eax,%eax
  87:	78 d1                	js     5a <main+0x5a>
  89:	39 c3                	cmp    %eax,%ebx
  8b:	74 cd                	je     5a <main+0x5a>
      printf(1, "zombie!\n");
  8d:	c7 44 24 04 d6 07 00 	movl   $0x7d6,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 1f 04 00 00       	call   4c0 <printf>
  a1:	eb dd                	jmp    80 <main+0x80>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  a3:	c7 44 24 04 aa 07 00 	movl   $0x7aa,0x4(%esp)
  aa:	00 
  ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b2:	e8 09 04 00 00       	call   4c0 <printf>
      exit();
  b7:	e8 7c 02 00 00       	call   338 <exit>
    }
    if(pid == 0){
      exec("sh", sh_args);
  bc:	c7 44 24 04 f8 07 00 	movl   $0x7f8,0x4(%esp)
  c3:	00 
  c4:	c7 04 24 bd 07 00 00 	movl   $0x7bd,(%esp)
  cb:	e8 a0 02 00 00       	call   370 <exec>
      printf(1, "init: exec sh failed\n");
  d0:	c7 44 24 04 c0 07 00 	movl   $0x7c0,0x4(%esp)
  d7:	00 
  d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  df:	e8 dc 03 00 00       	call   4c0 <printf>
      exit();
  e4:	e8 4f 02 00 00       	call   338 <exit>
{
printf(1,"in init.c");
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  f0:	00 
  f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  f8:	00 
  f9:	c7 04 24 8f 07 00 00 	movl   $0x78f,(%esp)
 100:	e8 7b 02 00 00       	call   380 <mknod>
    open("console", O_RDWR);
 105:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 10c:	00 
 10d:	c7 04 24 8f 07 00 00 	movl   $0x78f,(%esp)
 114:	e8 5f 02 00 00       	call   378 <open>
 119:	e9 24 ff ff ff       	jmp    42 <main+0x42>
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

000003d0 <tick>:
 3d0:	b8 15 00 00 00       	mov    $0x15,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <fork_tickets>:
 3d8:	b8 16 00 00 00       	mov    $0x16,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <fork_thread>:
 3e0:	b8 17 00 00 00       	mov    $0x17,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <wait_thread>:
 3e8:	b8 18 00 00 00       	mov    $0x18,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <sleep_cond>:
 3f0:	b8 19 00 00 00       	mov    $0x19,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <wake_cond>:
 3f8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <xchng>:
 400:	b8 1b 00 00 00       	mov    $0x1b,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <check>:
 408:	b8 1c 00 00 00       	mov    $0x1c,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 18             	sub    $0x18,%esp
 416:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 419:	8d 55 fc             	lea    -0x4(%ebp),%edx
 41c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 423:	00 
 424:	89 54 24 04          	mov    %edx,0x4(%esp)
 428:	89 04 24             	mov    %eax,(%esp)
 42b:	e8 28 ff ff ff       	call   358 <write>
}
 430:	c9                   	leave  
 431:	c3                   	ret    
 432:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	89 ce                	mov    %ecx,%esi
 447:	53                   	push   %ebx
 448:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 44e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 451:	85 c9                	test   %ecx,%ecx
 453:	74 04                	je     459 <printint+0x19>
 455:	85 d2                	test   %edx,%edx
 457:	78 54                	js     4ad <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 459:	89 d0                	mov    %edx,%eax
 45b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 462:	31 db                	xor    %ebx,%ebx
 464:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 467:	31 d2                	xor    %edx,%edx
 469:	f7 f6                	div    %esi
 46b:	89 c1                	mov    %eax,%ecx
 46d:	0f b6 82 e6 07 00 00 	movzbl 0x7e6(%edx),%eax
 474:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 477:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 47a:	85 c9                	test   %ecx,%ecx
 47c:	89 c8                	mov    %ecx,%eax
 47e:	75 e7                	jne    467 <printint+0x27>
  if(neg)
 480:	8b 45 e0             	mov    -0x20(%ebp),%eax
 483:	85 c0                	test   %eax,%eax
 485:	74 08                	je     48f <printint+0x4f>
    buf[i++] = '-';
 487:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 48c:	83 c3 01             	add    $0x1,%ebx
 48f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 492:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 496:	83 eb 01             	sub    $0x1,%ebx
 499:	8b 45 dc             	mov    -0x24(%ebp),%eax
 49c:	e8 6f ff ff ff       	call   410 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a1:	39 fb                	cmp    %edi,%ebx
 4a3:	75 ed                	jne    492 <printint+0x52>
    putc(fd, buf[i]);
}
 4a5:	83 c4 1c             	add    $0x1c,%esp
 4a8:	5b                   	pop    %ebx
 4a9:	5e                   	pop    %esi
 4aa:	5f                   	pop    %edi
 4ab:	5d                   	pop    %ebp
 4ac:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ad:	89 d0                	mov    %edx,%eax
 4af:	f7 d8                	neg    %eax
 4b1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 4b8:	eb a8                	jmp    462 <printint+0x22>
 4ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cc:	0f b6 02             	movzbl (%edx),%eax
 4cf:	84 c0                	test   %al,%al
 4d1:	0f 84 84 00 00 00    	je     55b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4d7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4da:	89 d7                	mov    %edx,%edi
 4dc:	31 f6                	xor    %esi,%esi
 4de:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 4e1:	eb 18                	jmp    4fb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4e3:	83 fb 25             	cmp    $0x25,%ebx
 4e6:	75 7b                	jne    563 <printf+0xa3>
 4e8:	66 be 25 00          	mov    $0x25,%si
 4ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4f4:	83 c7 01             	add    $0x1,%edi
 4f7:	84 c0                	test   %al,%al
 4f9:	74 60                	je     55b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 4fb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4fd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 500:	74 e1                	je     4e3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 502:	83 fe 25             	cmp    $0x25,%esi
 505:	75 e9                	jne    4f0 <printf+0x30>
      if(c == 'd'){
 507:	83 fb 64             	cmp    $0x64,%ebx
 50a:	0f 84 db 00 00 00    	je     5eb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 510:	83 fb 78             	cmp    $0x78,%ebx
 513:	74 5b                	je     570 <printf+0xb0>
 515:	83 fb 70             	cmp    $0x70,%ebx
 518:	74 56                	je     570 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 51a:	83 fb 73             	cmp    $0x73,%ebx
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	74 72                	je     594 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 522:	83 fb 63             	cmp    $0x63,%ebx
 525:	0f 84 a7 00 00 00    	je     5d2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 52b:	83 fb 25             	cmp    $0x25,%ebx
 52e:	66 90                	xchg   %ax,%ax
 530:	0f 84 da 00 00 00    	je     610 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 53e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 540:	e8 cb fe ff ff       	call   410 <putc>
        putc(fd, c);
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	0f be d3             	movsbl %bl,%edx
 54b:	e8 c0 fe ff ff       	call   410 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 550:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 554:	83 c7 01             	add    $0x1,%edi
 557:	84 c0                	test   %al,%al
 559:	75 a0                	jne    4fb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 55b:	83 c4 0c             	add    $0xc,%esp
 55e:	5b                   	pop    %ebx
 55f:	5e                   	pop    %esi
 560:	5f                   	pop    %edi
 561:	5d                   	pop    %ebp
 562:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	0f be d3             	movsbl %bl,%edx
 569:	e8 a2 fe ff ff       	call   410 <putc>
 56e:	eb 80                	jmp    4f0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 570:	8b 45 f0             	mov    -0x10(%ebp),%eax
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 578:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 57a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 581:	8b 10                	mov    (%eax),%edx
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	e8 b5 fe ff ff       	call   440 <printint>
        ap++;
 58b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 58f:	e9 5c ff ff ff       	jmp    4f0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 594:	8b 55 f0             	mov    -0x10(%ebp),%edx
 597:	8b 02                	mov    (%edx),%eax
        ap++;
 599:	83 c2 04             	add    $0x4,%edx
 59c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 59f:	ba df 07 00 00       	mov    $0x7df,%edx
 5a4:	85 c0                	test   %eax,%eax
 5a6:	75 26                	jne    5ce <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 5a8:	0f b6 02             	movzbl (%edx),%eax
 5ab:	84 c0                	test   %al,%al
 5ad:	74 18                	je     5c7 <printf+0x107>
 5af:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 5b1:	0f be d0             	movsbl %al,%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	e8 54 fe ff ff       	call   410 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5bc:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 5c0:	83 c3 01             	add    $0x1,%ebx
 5c3:	84 c0                	test   %al,%al
 5c5:	75 ea                	jne    5b1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5c7:	31 f6                	xor    %esi,%esi
 5c9:	e9 22 ff ff ff       	jmp    4f0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5ce:	89 c2                	mov    %eax,%edx
 5d0:	eb d6                	jmp    5a8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 5d5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	0f be 11             	movsbl (%ecx),%edx
 5dd:	e8 2e fe ff ff       	call   410 <putc>
        ap++;
 5e2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5e6:	e9 05 ff ff ff       	jmp    4f0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5f3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5fd:	8b 10                	mov    (%eax),%edx
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	e8 39 fe ff ff       	call   440 <printint>
        ap++;
 607:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 60b:	e9 e0 fe ff ff       	jmp    4f0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	ba 25 00 00 00       	mov    $0x25,%edx
 618:	31 f6                	xor    %esi,%esi
 61a:	e8 f1 fd ff ff       	call   410 <putc>
 61f:	e9 cc fe ff ff       	jmp    4f0 <printf+0x30>
 624:	90                   	nop    
 625:	90                   	nop    
 626:	90                   	nop    
 627:	90                   	nop    
 628:	90                   	nop    
 629:	90                   	nop    
 62a:	90                   	nop    
 62b:	90                   	nop    
 62c:	90                   	nop    
 62d:	90                   	nop    
 62e:	90                   	nop    
 62f:	90                   	nop    

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	8b 0d 08 08 00 00    	mov    0x808,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 637:	89 e5                	mov    %esp,%ebp
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 63e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	39 d9                	cmp    %ebx,%ecx
 643:	73 18                	jae    65d <free+0x2d>
 645:	8b 11                	mov    (%ecx),%edx
 647:	39 d3                	cmp    %edx,%ebx
 649:	72 17                	jb     662 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64b:	39 d1                	cmp    %edx,%ecx
 64d:	72 08                	jb     657 <free+0x27>
 64f:	39 d9                	cmp    %ebx,%ecx
 651:	72 0f                	jb     662 <free+0x32>
 653:	39 d3                	cmp    %edx,%ebx
 655:	72 0b                	jb     662 <free+0x32>
 657:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 659:	39 d9                	cmp    %ebx,%ecx
 65b:	72 e8                	jb     645 <free+0x15>
 65d:	8b 11                	mov    (%ecx),%edx
 65f:	90                   	nop    
 660:	eb e9                	jmp    64b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 662:	8b 73 04             	mov    0x4(%ebx),%esi
 665:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 668:	39 d0                	cmp    %edx,%eax
 66a:	74 18                	je     684 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 66e:	8b 51 04             	mov    0x4(%ecx),%edx
 671:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 674:	39 d8                	cmp    %ebx,%eax
 676:	74 20                	je     698 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 678:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 67a:	5b                   	pop    %ebx
 67b:	5e                   	pop    %esi
 67c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 67d:	89 0d 08 08 00 00    	mov    %ecx,0x808
}
 683:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 684:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 687:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 689:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 68c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 68f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 691:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 694:	39 d8                	cmp    %ebx,%eax
 696:	75 e0                	jne    678 <free+0x48>
    p->s.size += bp->s.size;
 698:	03 53 04             	add    0x4(%ebx),%edx
 69b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 69e:	8b 13                	mov    (%ebx),%edx
 6a0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6a2:	5b                   	pop    %ebx
 6a3:	5e                   	pop    %esi
 6a4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6a5:	89 0d 08 08 00 00    	mov    %ecx,0x808
}
 6ab:	c3                   	ret    
 6ac:	8d 74 26 00          	lea    0x0(%esi),%esi

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 15 08 08 00 00    	mov    0x808,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	83 c0 07             	add    $0x7,%eax
 6c5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6c8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ca:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6cd:	0f 84 8a 00 00 00    	je     75d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6d5:	8b 41 04             	mov    0x4(%ecx),%eax
 6d8:	39 c3                	cmp    %eax,%ebx
 6da:	76 1a                	jbe    6f6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6dc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 6e3:	3b 0d 08 08 00 00    	cmp    0x808,%ecx
 6e9:	89 ca                	mov    %ecx,%edx
 6eb:	74 29                	je     716 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ed:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6ef:	8b 41 04             	mov    0x4(%ecx),%eax
 6f2:	39 c3                	cmp    %eax,%ebx
 6f4:	77 ed                	ja     6e3 <malloc+0x33>
      if(p->s.size == nunits)
 6f6:	39 c3                	cmp    %eax,%ebx
 6f8:	74 5d                	je     757 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6fa:	29 d8                	sub    %ebx,%eax
 6fc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6ff:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 702:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 705:	89 15 08 08 00 00    	mov    %edx,0x808
      return (void*) (p + 1);
 70b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 70e:	83 c4 0c             	add    $0xc,%esp
 711:	5b                   	pop    %ebx
 712:	5e                   	pop    %esi
 713:	5f                   	pop    %edi
 714:	5d                   	pop    %ebp
 715:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 716:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 71c:	89 de                	mov    %ebx,%esi
 71e:	89 f8                	mov    %edi,%eax
 720:	76 29                	jbe    74b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 96 fc ff ff       	call   3c0 <sbrk>
  if(p == (char*) -1)
 72a:	83 f8 ff             	cmp    $0xffffffff,%eax
 72d:	74 18                	je     747 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 72f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 732:	83 c0 08             	add    $0x8,%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 f3 fe ff ff       	call   630 <free>
  return freep;
 73d:	8b 15 08 08 00 00    	mov    0x808,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 743:	85 d2                	test   %edx,%edx
 745:	75 a6                	jne    6ed <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 747:	31 c0                	xor    %eax,%eax
 749:	eb c3                	jmp    70e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 74b:	be 00 10 00 00       	mov    $0x1000,%esi
 750:	b8 00 80 00 00       	mov    $0x8000,%eax
 755:	eb cb                	jmp    722 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 757:	8b 01                	mov    (%ecx),%eax
 759:	89 02                	mov    %eax,(%edx)
 75b:	eb a8                	jmp    705 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 75d:	ba 00 08 00 00       	mov    $0x800,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 762:	c7 05 08 08 00 00 00 	movl   $0x800,0x808
 769:	08 00 00 
 76c:	c7 05 00 08 00 00 00 	movl   $0x800,0x800
 773:	08 00 00 
    base.s.size = 0;
 776:	c7 05 04 08 00 00 00 	movl   $0x0,0x804
 77d:	00 00 00 
 780:	e9 4e ff ff ff       	jmp    6d3 <malloc+0x23>
