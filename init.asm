
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
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  12:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  19:	00 
  1a:	c7 04 24 75 07 00 00 	movl   $0x775,(%esp)
  21:	e8 42 03 00 00       	call   368 <open>
  26:	85 c0                	test   %eax,%eax
  28:	0f 88 a4 00 00 00    	js     d2 <main+0xd2>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  35:	e8 66 03 00 00       	call   3a0 <dup>
  dup(0);  // stderr
  3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  41:	e8 5a 03 00 00       	call   3a0 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  46:	c7 44 24 04 7d 07 00 	movl   $0x77d,0x4(%esp)
  4d:	00 
  4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  55:	e8 56 04 00 00       	call   4b0 <printf>
    pid = fork();
  5a:	e8 c1 02 00 00       	call   320 <fork>
    if(pid < 0){
  5f:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  62:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  64:	7c 26                	jl     8c <main+0x8c>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  66:	74 3d                	je     a5 <main+0xa5>
      exec("sh", sh_args);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  68:	e8 c3 02 00 00       	call   330 <wait>
  6d:	85 c0                	test   %eax,%eax
  6f:	90                   	nop    
  70:	78 d4                	js     46 <main+0x46>
  72:	39 c3                	cmp    %eax,%ebx
  74:	74 d0                	je     46 <main+0x46>
      printf(1, "zombie!\n");
  76:	c7 44 24 04 bc 07 00 	movl   $0x7bc,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 26 04 00 00       	call   4b0 <printf>
  8a:	eb dc                	jmp    68 <main+0x68>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  8c:	c7 44 24 04 90 07 00 	movl   $0x790,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 10 04 00 00       	call   4b0 <printf>
      exit();
  a0:	e8 83 02 00 00       	call   328 <exit>
    }
    if(pid == 0){
      exec("sh", sh_args);
  a5:	c7 44 24 04 e0 07 00 	movl   $0x7e0,0x4(%esp)
  ac:	00 
  ad:	c7 04 24 a3 07 00 00 	movl   $0x7a3,(%esp)
  b4:	e8 a7 02 00 00       	call   360 <exec>
      printf(1, "init: exec sh failed\n");
  b9:	c7 44 24 04 a6 07 00 	movl   $0x7a6,0x4(%esp)
  c0:	00 
  c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c8:	e8 e3 03 00 00       	call   4b0 <printf>
      exit();
  cd:	e8 56 02 00 00       	call   328 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  d9:	00 
  da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  e1:	00 
  e2:	c7 04 24 75 07 00 00 	movl   $0x775,(%esp)
  e9:	e8 82 02 00 00       	call   370 <mknod>
    open("console", O_RDWR);
  ee:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 75 07 00 00 	movl   $0x775,(%esp)
  fd:	e8 66 02 00 00       	call   368 <open>
 102:	e9 27 ff ff ff       	jmp    2e <main+0x2e>
 107:	90                   	nop    
 108:	90                   	nop    
 109:	90                   	nop    
 10a:	90                   	nop    
 10b:	90                   	nop    
 10c:	90                   	nop    
 10d:	90                   	nop    
 10e:	90                   	nop    
 10f:	90                   	nop    

00000110 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 5d 08             	mov    0x8(%ebp),%ebx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 11a:	89 da                	mov    %ebx,%edx
 11c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 01             	movzbl (%ecx),%eax
 123:	83 c1 01             	add    $0x1,%ecx
 126:	88 02                	mov    %al,(%edx)
 128:	83 c2 01             	add    $0x1,%edx
 12b:	84 c0                	test   %al,%al
 12d:	75 f1                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12f:	89 d8                	mov    %ebx,%eax
 131:	5b                   	pop    %ebx
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
 134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 13a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
 146:	53                   	push   %ebx
 147:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 14a:	0f b6 01             	movzbl (%ecx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	74 24                	je     175 <strcmp+0x35>
 151:	0f b6 13             	movzbl (%ebx),%edx
 154:	38 d0                	cmp    %dl,%al
 156:	74 12                	je     16a <strcmp+0x2a>
 158:	eb 1e                	jmp    178 <strcmp+0x38>
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 160:	0f b6 13             	movzbl (%ebx),%edx
 163:	83 c1 01             	add    $0x1,%ecx
 166:	38 d0                	cmp    %dl,%al
 168:	75 0e                	jne    178 <strcmp+0x38>
 16a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 16e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 171:	84 c0                	test   %al,%al
 173:	75 eb                	jne    160 <strcmp+0x20>
 175:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 178:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 179:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 17c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17d:	0f b6 d2             	movzbl %dl,%edx
 180:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 182:	c3                   	ret    
 183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
 195:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 198:	80 39 00             	cmpb   $0x0,(%ecx)
 19b:	74 0e                	je     1ab <strlen+0x1b>
 19d:	31 d2                	xor    %edx,%edx
 19f:	90                   	nop    
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 10             	mov    0x10(%ebp),%eax
 1b6:	53                   	push   %ebx
 1b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ba:	85 c0                	test   %eax,%eax
 1bc:	74 10                	je     1ce <memset+0x1e>
 1be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 1c2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 1c4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 1c7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ca:	39 c2                	cmp    %eax,%edx
 1cc:	75 f6                	jne    1c4 <memset+0x14>
    *d++ = c;
  return dst;
}
 1ce:	89 d8                	mov    %ebx,%eax
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 0c                	jne    1fd <strchr+0x1d>
 1f1:	eb 11                	jmp    204 <strchr+0x24>
 1f3:	83 c0 01             	add    $0x1,%eax
 1f6:	0f b6 10             	movzbl (%eax),%edx
 1f9:	84 d2                	test   %dl,%dl
 1fb:	74 07                	je     204 <strchr+0x24>
    if(*s == c)
 1fd:	38 ca                	cmp    %cl,%dl
 1ff:	90                   	nop    
 200:	75 f1                	jne    1f3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 205:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 207:	c3                   	ret    
 208:	90                   	nop    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000210 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 4d 08             	mov    0x8(%ebp),%ecx
 216:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	31 db                	xor    %ebx,%ebx
 219:	0f b6 11             	movzbl (%ecx),%edx
 21c:	8d 42 d0             	lea    -0x30(%edx),%eax
 21f:	3c 09                	cmp    $0x9,%al
 221:	77 18                	ja     23b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 223:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 226:	0f be d2             	movsbl %dl,%edx
 229:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 231:	83 c1 01             	add    $0x1,%ecx
 234:	8d 42 d0             	lea    -0x30(%edx),%eax
 237:	3c 09                	cmp    $0x9,%al
 239:	76 e8                	jbe    223 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 23b:	89 d8                	mov    %ebx,%eax
 23d:	5b                   	pop    %ebx
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 4d 10             	mov    0x10(%ebp),%ecx
 246:	56                   	push   %esi
 247:	8b 75 08             	mov    0x8(%ebp),%esi
 24a:	53                   	push   %ebx
 24b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 c9                	test   %ecx,%ecx
 250:	7e 10                	jle    262 <memmove+0x22>
 252:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 254:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 258:	88 04 32             	mov    %al,(%edx,%esi,1)
 25b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	39 ca                	cmp    %ecx,%edx
 260:	75 f2                	jne    254 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 262:	89 f0                	mov    %esi,%eax
 264:	5b                   	pop    %ebx
 265:	5e                   	pop    %esi
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000270 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 279:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 27c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 27f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 284:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 28b:	00 
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 d4 00 00 00       	call   368 <open>
  if(fd < 0)
 294:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 298:	78 19                	js     2b3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 1c 24             	mov    %ebx,(%esp)
 2a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a4:	e8 d7 00 00 00       	call   380 <fstat>
  close(fd);
 2a9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2ac:	89 c6                	mov    %eax,%esi
  close(fd);
 2ae:	e8 9d 00 00 00       	call   350 <close>
  return r;
}
 2b3:	89 f0                	mov    %esi,%eax
 2b5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2b8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2bb:	89 ec                	mov    %ebp,%esp
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    
 2bf:	90                   	nop    

000002c0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
 2c5:	31 f6                	xor    %esi,%esi
 2c7:	53                   	push   %ebx
 2c8:	83 ec 1c             	sub    $0x1c,%esp
 2cb:	8b 7d 08             	mov    0x8(%ebp),%edi
 2ce:	eb 06                	jmp    2d6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d0:	3c 0d                	cmp    $0xd,%al
 2d2:	74 39                	je     30d <gets+0x4d>
 2d4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2d9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2dc:	7d 31                	jge    30f <gets+0x4f>
    cc = read(0, &c, 1);
 2de:	8d 45 f3             	lea    -0xd(%ebp),%eax
 2e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e8:	00 
 2e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f4:	e8 47 00 00 00       	call   340 <read>
    if(cc < 1)
 2f9:	85 c0                	test   %eax,%eax
 2fb:	7e 12                	jle    30f <gets+0x4f>
      break;
    buf[i++] = c;
 2fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 301:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 305:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 309:	3c 0a                	cmp    $0xa,%al
 30b:	75 c3                	jne    2d0 <gets+0x10>
 30d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 30f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 313:	89 f8                	mov    %edi,%eax
 315:	83 c4 1c             	add    $0x1c,%esp
 318:	5b                   	pop    %ebx
 319:	5e                   	pop    %esi
 31a:	5f                   	pop    %edi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    
 31d:	90                   	nop    
 31e:	90                   	nop    
 31f:	90                   	nop    

00000320 <fork>:
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <exit>:
 328:	b8 02 00 00 00       	mov    $0x2,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <wait>:
 330:	b8 03 00 00 00       	mov    $0x3,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <pipe>:
 338:	b8 04 00 00 00       	mov    $0x4,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <read>:
 340:	b8 06 00 00 00       	mov    $0x6,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <write>:
 348:	b8 05 00 00 00       	mov    $0x5,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <close>:
 350:	b8 07 00 00 00       	mov    $0x7,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <kill>:
 358:	b8 08 00 00 00       	mov    $0x8,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <exec>:
 360:	b8 09 00 00 00       	mov    $0x9,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <open>:
 368:	b8 0a 00 00 00       	mov    $0xa,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <mknod>:
 370:	b8 0b 00 00 00       	mov    $0xb,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <unlink>:
 378:	b8 0c 00 00 00       	mov    $0xc,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <fstat>:
 380:	b8 0d 00 00 00       	mov    $0xd,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <link>:
 388:	b8 0e 00 00 00       	mov    $0xe,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <mkdir>:
 390:	b8 0f 00 00 00       	mov    $0xf,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <chdir>:
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <dup>:
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <getpid>:
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <sbrk>:
 3b0:	b8 13 00 00 00       	mov    $0x13,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <sleep>:
 3b8:	b8 14 00 00 00       	mov    $0x14,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <tick>:
 3c0:	b8 15 00 00 00       	mov    $0x15,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <fork_tickets>:
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <fork_thread>:
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <wait_thread>:
 3d8:	b8 18 00 00 00       	mov    $0x18,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <sleep_cond>:
 3e0:	b8 19 00 00 00       	mov    $0x19,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <wake_cond>:
 3e8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <xchng>:
 3f0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    
 3f8:	90                   	nop    
 3f9:	90                   	nop    
 3fa:	90                   	nop    
 3fb:	90                   	nop    
 3fc:	90                   	nop    
 3fd:	90                   	nop    
 3fe:	90                   	nop    
 3ff:	90                   	nop    

00000400 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 18             	sub    $0x18,%esp
 406:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 409:	8d 55 fc             	lea    -0x4(%ebp),%edx
 40c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 413:	00 
 414:	89 54 24 04          	mov    %edx,0x4(%esp)
 418:	89 04 24             	mov    %eax,(%esp)
 41b:	e8 28 ff ff ff       	call   348 <write>
}
 420:	c9                   	leave  
 421:	c3                   	ret    
 422:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	89 ce                	mov    %ecx,%esi
 437:	53                   	push   %ebx
 438:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 441:	85 c9                	test   %ecx,%ecx
 443:	74 04                	je     449 <printint+0x19>
 445:	85 d2                	test   %edx,%edx
 447:	78 54                	js     49d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 449:	89 d0                	mov    %edx,%eax
 44b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 452:	31 db                	xor    %ebx,%ebx
 454:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 457:	31 d2                	xor    %edx,%edx
 459:	f7 f6                	div    %esi
 45b:	89 c1                	mov    %eax,%ecx
 45d:	0f b6 82 cc 07 00 00 	movzbl 0x7cc(%edx),%eax
 464:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 467:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 46a:	85 c9                	test   %ecx,%ecx
 46c:	89 c8                	mov    %ecx,%eax
 46e:	75 e7                	jne    457 <printint+0x27>
  if(neg)
 470:	8b 45 e0             	mov    -0x20(%ebp),%eax
 473:	85 c0                	test   %eax,%eax
 475:	74 08                	je     47f <printint+0x4f>
    buf[i++] = '-';
 477:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 47c:	83 c3 01             	add    $0x1,%ebx
 47f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 482:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 486:	83 eb 01             	sub    $0x1,%ebx
 489:	8b 45 dc             	mov    -0x24(%ebp),%eax
 48c:	e8 6f ff ff ff       	call   400 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 491:	39 fb                	cmp    %edi,%ebx
 493:	75 ed                	jne    482 <printint+0x52>
    putc(fd, buf[i]);
}
 495:	83 c4 1c             	add    $0x1c,%esp
 498:	5b                   	pop    %ebx
 499:	5e                   	pop    %esi
 49a:	5f                   	pop    %edi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 49d:	89 d0                	mov    %edx,%eax
 49f:	f7 d8                	neg    %eax
 4a1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 4a8:	eb a8                	jmp    452 <printint+0x22>
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bc:	0f b6 02             	movzbl (%edx),%eax
 4bf:	84 c0                	test   %al,%al
 4c1:	0f 84 84 00 00 00    	je     54b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4c7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ca:	89 d7                	mov    %edx,%edi
 4cc:	31 f6                	xor    %esi,%esi
 4ce:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 4d1:	eb 18                	jmp    4eb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4d3:	83 fb 25             	cmp    $0x25,%ebx
 4d6:	75 7b                	jne    553 <printf+0xa3>
 4d8:	66 be 25 00          	mov    $0x25,%si
 4dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4e4:	83 c7 01             	add    $0x1,%edi
 4e7:	84 c0                	test   %al,%al
 4e9:	74 60                	je     54b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 4eb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4ed:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4f0:	74 e1                	je     4d3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f2:	83 fe 25             	cmp    $0x25,%esi
 4f5:	75 e9                	jne    4e0 <printf+0x30>
      if(c == 'd'){
 4f7:	83 fb 64             	cmp    $0x64,%ebx
 4fa:	0f 84 db 00 00 00    	je     5db <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 500:	83 fb 78             	cmp    $0x78,%ebx
 503:	74 5b                	je     560 <printf+0xb0>
 505:	83 fb 70             	cmp    $0x70,%ebx
 508:	74 56                	je     560 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 50a:	83 fb 73             	cmp    $0x73,%ebx
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	74 72                	je     584 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 512:	83 fb 63             	cmp    $0x63,%ebx
 515:	0f 84 a7 00 00 00    	je     5c2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 51b:	83 fb 25             	cmp    $0x25,%ebx
 51e:	66 90                	xchg   %ax,%ax
 520:	0f 84 da 00 00 00    	je     600 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 52e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 530:	e8 cb fe ff ff       	call   400 <putc>
        putc(fd, c);
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	0f be d3             	movsbl %bl,%edx
 53b:	e8 c0 fe ff ff       	call   400 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 540:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 544:	83 c7 01             	add    $0x1,%edi
 547:	84 c0                	test   %al,%al
 549:	75 a0                	jne    4eb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 54b:	83 c4 0c             	add    $0xc,%esp
 54e:	5b                   	pop    %ebx
 54f:	5e                   	pop    %esi
 550:	5f                   	pop    %edi
 551:	5d                   	pop    %ebp
 552:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	0f be d3             	movsbl %bl,%edx
 559:	e8 a2 fe ff ff       	call   400 <putc>
 55e:	eb 80                	jmp    4e0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 560:	8b 45 f0             	mov    -0x10(%ebp),%eax
 563:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 568:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 56a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 571:	8b 10                	mov    (%eax),%edx
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	e8 b5 fe ff ff       	call   430 <printint>
        ap++;
 57b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 57f:	e9 5c ff ff ff       	jmp    4e0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 584:	8b 55 f0             	mov    -0x10(%ebp),%edx
 587:	8b 02                	mov    (%edx),%eax
        ap++;
 589:	83 c2 04             	add    $0x4,%edx
 58c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 58f:	ba c5 07 00 00       	mov    $0x7c5,%edx
 594:	85 c0                	test   %eax,%eax
 596:	75 26                	jne    5be <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 598:	0f b6 02             	movzbl (%edx),%eax
 59b:	84 c0                	test   %al,%al
 59d:	74 18                	je     5b7 <printf+0x107>
 59f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 5a1:	0f be d0             	movsbl %al,%edx
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	e8 54 fe ff ff       	call   400 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ac:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 5b0:	83 c3 01             	add    $0x1,%ebx
 5b3:	84 c0                	test   %al,%al
 5b5:	75 ea                	jne    5a1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5b7:	31 f6                	xor    %esi,%esi
 5b9:	e9 22 ff ff ff       	jmp    4e0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5be:	89 c2                	mov    %eax,%edx
 5c0:	eb d6                	jmp    598 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 5c5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	0f be 11             	movsbl (%ecx),%edx
 5cd:	e8 2e fe ff ff       	call   400 <putc>
        ap++;
 5d2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5d6:	e9 05 ff ff ff       	jmp    4e0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5de:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5e3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ed:	8b 10                	mov    (%eax),%edx
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	e8 39 fe ff ff       	call   430 <printint>
        ap++;
 5f7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5fb:	e9 e0 fe ff ff       	jmp    4e0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	ba 25 00 00 00       	mov    $0x25,%edx
 608:	31 f6                	xor    %esi,%esi
 60a:	e8 f1 fd ff ff       	call   400 <putc>
 60f:	e9 cc fe ff ff       	jmp    4e0 <printf+0x30>
 614:	90                   	nop    
 615:	90                   	nop    
 616:	90                   	nop    
 617:	90                   	nop    
 618:	90                   	nop    
 619:	90                   	nop    
 61a:	90                   	nop    
 61b:	90                   	nop    
 61c:	90                   	nop    
 61d:	90                   	nop    
 61e:	90                   	nop    
 61f:	90                   	nop    

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	8b 0d f0 07 00 00    	mov    0x7f0,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 627:	89 e5                	mov    %esp,%ebp
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 62e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	39 d9                	cmp    %ebx,%ecx
 633:	73 18                	jae    64d <free+0x2d>
 635:	8b 11                	mov    (%ecx),%edx
 637:	39 d3                	cmp    %edx,%ebx
 639:	72 17                	jb     652 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63b:	39 d1                	cmp    %edx,%ecx
 63d:	72 08                	jb     647 <free+0x27>
 63f:	39 d9                	cmp    %ebx,%ecx
 641:	72 0f                	jb     652 <free+0x32>
 643:	39 d3                	cmp    %edx,%ebx
 645:	72 0b                	jb     652 <free+0x32>
 647:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 649:	39 d9                	cmp    %ebx,%ecx
 64b:	72 e8                	jb     635 <free+0x15>
 64d:	8b 11                	mov    (%ecx),%edx
 64f:	90                   	nop    
 650:	eb e9                	jmp    63b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 652:	8b 73 04             	mov    0x4(%ebx),%esi
 655:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 658:	39 d0                	cmp    %edx,%eax
 65a:	74 18                	je     674 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 65c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 65e:	8b 51 04             	mov    0x4(%ecx),%edx
 661:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 664:	39 d8                	cmp    %ebx,%eax
 666:	74 20                	je     688 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 668:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 66a:	5b                   	pop    %ebx
 66b:	5e                   	pop    %esi
 66c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 66d:	89 0d f0 07 00 00    	mov    %ecx,0x7f0
}
 673:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 674:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 677:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 679:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 67c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 67f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 681:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 684:	39 d8                	cmp    %ebx,%eax
 686:	75 e0                	jne    668 <free+0x48>
    p->s.size += bp->s.size;
 688:	03 53 04             	add    0x4(%ebx),%edx
 68b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 68e:	8b 13                	mov    (%ebx),%edx
 690:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 692:	5b                   	pop    %ebx
 693:	5e                   	pop    %esi
 694:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 695:	89 0d f0 07 00 00    	mov    %ecx,0x7f0
}
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi),%esi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ac:	8b 15 f0 07 00 00    	mov    0x7f0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	83 c0 07             	add    $0x7,%eax
 6b5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 6b8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ba:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 6bd:	0f 84 8a 00 00 00    	je     74d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6c5:	8b 41 04             	mov    0x4(%ecx),%eax
 6c8:	39 c3                	cmp    %eax,%ebx
 6ca:	76 1a                	jbe    6e6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6cc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 6d3:	3b 0d f0 07 00 00    	cmp    0x7f0,%ecx
 6d9:	89 ca                	mov    %ecx,%edx
 6db:	74 29                	je     706 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6dd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6df:	8b 41 04             	mov    0x4(%ecx),%eax
 6e2:	39 c3                	cmp    %eax,%ebx
 6e4:	77 ed                	ja     6d3 <malloc+0x33>
      if(p->s.size == nunits)
 6e6:	39 c3                	cmp    %eax,%ebx
 6e8:	74 5d                	je     747 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ea:	29 d8                	sub    %ebx,%eax
 6ec:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6ef:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 6f2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 6f5:	89 15 f0 07 00 00    	mov    %edx,0x7f0
      return (void*) (p + 1);
 6fb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6fe:	83 c4 0c             	add    $0xc,%esp
 701:	5b                   	pop    %ebx
 702:	5e                   	pop    %esi
 703:	5f                   	pop    %edi
 704:	5d                   	pop    %ebp
 705:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 706:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 70c:	89 de                	mov    %ebx,%esi
 70e:	89 f8                	mov    %edi,%eax
 710:	76 29                	jbe    73b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 96 fc ff ff       	call   3b0 <sbrk>
  if(p == (char*) -1)
 71a:	83 f8 ff             	cmp    $0xffffffff,%eax
 71d:	74 18                	je     737 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 71f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 722:	83 c0 08             	add    $0x8,%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 f3 fe ff ff       	call   620 <free>
  return freep;
 72d:	8b 15 f0 07 00 00    	mov    0x7f0,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 733:	85 d2                	test   %edx,%edx
 735:	75 a6                	jne    6dd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 737:	31 c0                	xor    %eax,%eax
 739:	eb c3                	jmp    6fe <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 73b:	be 00 10 00 00       	mov    $0x1000,%esi
 740:	b8 00 80 00 00       	mov    $0x8000,%eax
 745:	eb cb                	jmp    712 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 747:	8b 01                	mov    (%ecx),%eax
 749:	89 02                	mov    %eax,(%edx)
 74b:	eb a8                	jmp    6f5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 74d:	ba e8 07 00 00       	mov    $0x7e8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 752:	c7 05 f0 07 00 00 e8 	movl   $0x7e8,0x7f0
 759:	07 00 00 
 75c:	c7 05 e8 07 00 00 e8 	movl   $0x7e8,0x7e8
 763:	07 00 00 
    base.s.size = 0;
 766:	c7 05 ec 07 00 00 00 	movl   $0x0,0x7ec
 76d:	00 00 00 
 770:	e9 4e ff ff ff       	jmp    6c3 <malloc+0x23>
