
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
  25:	c7 44 24 04 a5 06 00 	movl   $0x6a5,0x4(%esp)
  2c:	00 
  2d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  34:	e8 a7 03 00 00       	call   3e0 <printf>
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

00000320 <kalloctest>:
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    
 328:	90                   	nop    
 329:	90                   	nop    
 32a:	90                   	nop    
 32b:	90                   	nop    
 32c:	90                   	nop    
 32d:	90                   	nop    
 32e:	90                   	nop    
 32f:	90                   	nop    

00000330 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 18             	sub    $0x18,%esp
 336:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 339:	8d 55 fc             	lea    -0x4(%ebp),%edx
 33c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 343:	00 
 344:	89 54 24 04          	mov    %edx,0x4(%esp)
 348:	89 04 24             	mov    %eax,(%esp)
 34b:	e8 58 ff ff ff       	call   2a8 <write>
}
 350:	c9                   	leave  
 351:	c3                   	ret    
 352:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000360 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	89 ce                	mov    %ecx,%esi
 367:	53                   	push   %ebx
 368:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 36e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 371:	85 c9                	test   %ecx,%ecx
 373:	74 04                	je     379 <printint+0x19>
 375:	85 d2                	test   %edx,%edx
 377:	78 54                	js     3cd <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 379:	89 d0                	mov    %edx,%eax
 37b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 382:	31 db                	xor    %ebx,%ebx
 384:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 387:	31 d2                	xor    %edx,%edx
 389:	f7 f6                	div    %esi
 38b:	89 c1                	mov    %eax,%ecx
 38d:	0f b6 82 c0 06 00 00 	movzbl 0x6c0(%edx),%eax
 394:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 397:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 39a:	85 c9                	test   %ecx,%ecx
 39c:	89 c8                	mov    %ecx,%eax
 39e:	75 e7                	jne    387 <printint+0x27>
  if(neg)
 3a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3a3:	85 c0                	test   %eax,%eax
 3a5:	74 08                	je     3af <printint+0x4f>
    buf[i++] = '-';
 3a7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 3ac:	83 c3 01             	add    $0x1,%ebx
 3af:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 3b2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 3b6:	83 eb 01             	sub    $0x1,%ebx
 3b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3bc:	e8 6f ff ff ff       	call   330 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3c1:	39 fb                	cmp    %edi,%ebx
 3c3:	75 ed                	jne    3b2 <printint+0x52>
    putc(fd, buf[i]);
}
 3c5:	83 c4 1c             	add    $0x1c,%esp
 3c8:	5b                   	pop    %ebx
 3c9:	5e                   	pop    %esi
 3ca:	5f                   	pop    %edi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3cd:	89 d0                	mov    %edx,%eax
 3cf:	f7 d8                	neg    %eax
 3d1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 3d8:	eb a8                	jmp    382 <printint+0x22>
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3ec:	0f b6 02             	movzbl (%edx),%eax
 3ef:	84 c0                	test   %al,%al
 3f1:	0f 84 84 00 00 00    	je     47b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3fa:	89 d7                	mov    %edx,%edi
 3fc:	31 f6                	xor    %esi,%esi
 3fe:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 401:	eb 18                	jmp    41b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 403:	83 fb 25             	cmp    $0x25,%ebx
 406:	75 7b                	jne    483 <printf+0xa3>
 408:	66 be 25 00          	mov    $0x25,%si
 40c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 410:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 414:	83 c7 01             	add    $0x1,%edi
 417:	84 c0                	test   %al,%al
 419:	74 60                	je     47b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 41b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 41d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 420:	74 e1                	je     403 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 422:	83 fe 25             	cmp    $0x25,%esi
 425:	75 e9                	jne    410 <printf+0x30>
      if(c == 'd'){
 427:	83 fb 64             	cmp    $0x64,%ebx
 42a:	0f 84 db 00 00 00    	je     50b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 430:	83 fb 78             	cmp    $0x78,%ebx
 433:	74 5b                	je     490 <printf+0xb0>
 435:	83 fb 70             	cmp    $0x70,%ebx
 438:	74 56                	je     490 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43a:	83 fb 73             	cmp    $0x73,%ebx
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	74 72                	je     4b4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 442:	83 fb 63             	cmp    $0x63,%ebx
 445:	0f 84 a7 00 00 00    	je     4f2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44b:	83 fb 25             	cmp    $0x25,%ebx
 44e:	66 90                	xchg   %ax,%ax
 450:	0f 84 da 00 00 00    	je     530 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 45e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 460:	e8 cb fe ff ff       	call   330 <putc>
        putc(fd, c);
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	0f be d3             	movsbl %bl,%edx
 46b:	e8 c0 fe ff ff       	call   330 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 470:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 474:	83 c7 01             	add    $0x1,%edi
 477:	84 c0                	test   %al,%al
 479:	75 a0                	jne    41b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 47b:	83 c4 0c             	add    $0xc,%esp
 47e:	5b                   	pop    %ebx
 47f:	5e                   	pop    %esi
 480:	5f                   	pop    %edi
 481:	5d                   	pop    %ebp
 482:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	0f be d3             	movsbl %bl,%edx
 489:	e8 a2 fe ff ff       	call   330 <putc>
 48e:	eb 80                	jmp    410 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 490:	8b 45 f0             	mov    -0x10(%ebp),%eax
 493:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 498:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 49a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a1:	8b 10                	mov    (%eax),%edx
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	e8 b5 fe ff ff       	call   360 <printint>
        ap++;
 4ab:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 4af:	e9 5c ff ff ff       	jmp    410 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 4b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 4b7:	8b 02                	mov    (%edx),%eax
        ap++;
 4b9:	83 c2 04             	add    $0x4,%edx
 4bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 4bf:	ba b9 06 00 00       	mov    $0x6b9,%edx
 4c4:	85 c0                	test   %eax,%eax
 4c6:	75 26                	jne    4ee <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 4c8:	0f b6 02             	movzbl (%edx),%eax
 4cb:	84 c0                	test   %al,%al
 4cd:	74 18                	je     4e7 <printf+0x107>
 4cf:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 4d1:	0f be d0             	movsbl %al,%edx
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
 4d7:	e8 54 fe ff ff       	call   330 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4dc:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 4e0:	83 c3 01             	add    $0x1,%ebx
 4e3:	84 c0                	test   %al,%al
 4e5:	75 ea                	jne    4d1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4e7:	31 f6                	xor    %esi,%esi
 4e9:	e9 22 ff ff ff       	jmp    410 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4ee:	89 c2                	mov    %eax,%edx
 4f0:	eb d6                	jmp    4c8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 4f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 4f5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	0f be 11             	movsbl (%ecx),%edx
 4fd:	e8 2e fe ff ff       	call   330 <putc>
        ap++;
 502:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 506:	e9 05 ff ff ff       	jmp    410 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 50b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 513:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 516:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 51d:	8b 10                	mov    (%eax),%edx
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	e8 39 fe ff ff       	call   360 <printint>
        ap++;
 527:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 52b:	e9 e0 fe ff ff       	jmp    410 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	ba 25 00 00 00       	mov    $0x25,%edx
 538:	31 f6                	xor    %esi,%esi
 53a:	e8 f1 fd ff ff       	call   330 <putc>
 53f:	e9 cc fe ff ff       	jmp    410 <printf+0x30>
 544:	90                   	nop    
 545:	90                   	nop    
 546:	90                   	nop    
 547:	90                   	nop    
 548:	90                   	nop    
 549:	90                   	nop    
 54a:	90                   	nop    
 54b:	90                   	nop    
 54c:	90                   	nop    
 54d:	90                   	nop    
 54e:	90                   	nop    
 54f:	90                   	nop    

00000550 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 550:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 551:	8b 0d dc 06 00 00    	mov    0x6dc,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 557:	89 e5                	mov    %esp,%ebp
 559:	56                   	push   %esi
 55a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 55b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 55e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 561:	39 d9                	cmp    %ebx,%ecx
 563:	73 18                	jae    57d <free+0x2d>
 565:	8b 11                	mov    (%ecx),%edx
 567:	39 d3                	cmp    %edx,%ebx
 569:	72 17                	jb     582 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56b:	39 d1                	cmp    %edx,%ecx
 56d:	72 08                	jb     577 <free+0x27>
 56f:	39 d9                	cmp    %ebx,%ecx
 571:	72 0f                	jb     582 <free+0x32>
 573:	39 d3                	cmp    %edx,%ebx
 575:	72 0b                	jb     582 <free+0x32>
 577:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 579:	39 d9                	cmp    %ebx,%ecx
 57b:	72 e8                	jb     565 <free+0x15>
 57d:	8b 11                	mov    (%ecx),%edx
 57f:	90                   	nop    
 580:	eb e9                	jmp    56b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 582:	8b 73 04             	mov    0x4(%ebx),%esi
 585:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 588:	39 d0                	cmp    %edx,%eax
 58a:	74 18                	je     5a4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 58c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 58e:	8b 51 04             	mov    0x4(%ecx),%edx
 591:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 594:	39 d8                	cmp    %ebx,%eax
 596:	74 20                	je     5b8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 598:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 59a:	5b                   	pop    %ebx
 59b:	5e                   	pop    %esi
 59c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 59d:	89 0d dc 06 00 00    	mov    %ecx,0x6dc
}
 5a3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5a4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 5a7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5a9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5ac:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5af:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5b1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 5b4:	39 d8                	cmp    %ebx,%eax
 5b6:	75 e0                	jne    598 <free+0x48>
    p->s.size += bp->s.size;
 5b8:	03 53 04             	add    0x4(%ebx),%edx
 5bb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 5be:	8b 13                	mov    (%ebx),%edx
 5c0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 5c5:	89 0d dc 06 00 00    	mov    %ecx,0x6dc
}
 5cb:	c3                   	ret    
 5cc:	8d 74 26 00          	lea    0x0(%esi),%esi

000005d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 5dc:	8b 15 dc 06 00 00    	mov    0x6dc,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e2:	83 c0 07             	add    $0x7,%eax
 5e5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 5e8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ea:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 5ed:	0f 84 8a 00 00 00    	je     67d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 5f5:	8b 41 04             	mov    0x4(%ecx),%eax
 5f8:	39 c3                	cmp    %eax,%ebx
 5fa:	76 1a                	jbe    616 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 5fc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 603:	3b 0d dc 06 00 00    	cmp    0x6dc,%ecx
 609:	89 ca                	mov    %ecx,%edx
 60b:	74 29                	je     636 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 60f:	8b 41 04             	mov    0x4(%ecx),%eax
 612:	39 c3                	cmp    %eax,%ebx
 614:	77 ed                	ja     603 <malloc+0x33>
      if(p->s.size == nunits)
 616:	39 c3                	cmp    %eax,%ebx
 618:	74 5d                	je     677 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 61a:	29 d8                	sub    %ebx,%eax
 61c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 61f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 622:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 625:	89 15 dc 06 00 00    	mov    %edx,0x6dc
      return (void*) (p + 1);
 62b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 62e:	83 c4 0c             	add    $0xc,%esp
 631:	5b                   	pop    %ebx
 632:	5e                   	pop    %esi
 633:	5f                   	pop    %edi
 634:	5d                   	pop    %ebp
 635:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 636:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 63c:	89 de                	mov    %ebx,%esi
 63e:	89 f8                	mov    %edi,%eax
 640:	76 29                	jbe    66b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 c6 fc ff ff       	call   310 <sbrk>
  if(p == (char*) -1)
 64a:	83 f8 ff             	cmp    $0xffffffff,%eax
 64d:	74 18                	je     667 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 64f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 652:	83 c0 08             	add    $0x8,%eax
 655:	89 04 24             	mov    %eax,(%esp)
 658:	e8 f3 fe ff ff       	call   550 <free>
  return freep;
 65d:	8b 15 dc 06 00 00    	mov    0x6dc,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 663:	85 d2                	test   %edx,%edx
 665:	75 a6                	jne    60d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 667:	31 c0                	xor    %eax,%eax
 669:	eb c3                	jmp    62e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 66b:	be 00 10 00 00       	mov    $0x1000,%esi
 670:	b8 00 80 00 00       	mov    $0x8000,%eax
 675:	eb cb                	jmp    642 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 677:	8b 01                	mov    (%ecx),%eax
 679:	89 02                	mov    %eax,(%edx)
 67b:	eb a8                	jmp    625 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 67d:	ba d4 06 00 00       	mov    $0x6d4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 682:	c7 05 dc 06 00 00 d4 	movl   $0x6d4,0x6dc
 689:	06 00 00 
 68c:	c7 05 d4 06 00 00 d4 	movl   $0x6d4,0x6d4
 693:	06 00 00 
    base.s.size = 0;
 696:	c7 05 d8 06 00 00 00 	movl   $0x0,0x6d8
 69d:	00 00 00 
 6a0:	e9 4e ff ff ff       	jmp    5f3 <malloc+0x23>
