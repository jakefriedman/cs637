
_fstest2:     file format elf32-i386

Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx

	struct stat *fstats;
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
	printf(2, "Opened test file\n");
	printf(2, "fd is %d\n", fd);
   f:	31 db                	xor    %ebx,%ebx
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
	//Old FS can support files of size: ~71,000 bytes

	struct stat *fstats;
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
  15:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1c:	00 
  1d:	c7 04 24 45 07 00 00 	movl   $0x745,(%esp)
  24:	e8 0f 03 00 00       	call   338 <open>
	printf(2, "Opened test file\n");
  29:	c7 44 24 04 4f 07 00 	movl   $0x74f,0x4(%esp)
  30:	00 
  31:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
{
	//Old FS can support files of size: ~71,000 bytes

	struct stat *fstats;
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
  38:	89 c6                	mov    %eax,%esi
	printf(2, "Opened test file\n");
  3a:	e8 41 04 00 00       	call   480 <printf>
	printf(2, "fd is %d\n", fd);
  3f:	89 74 24 08          	mov    %esi,0x8(%esp)
  43:	c7 44 24 04 61 07 00 	movl   $0x761,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  52:	e8 29 04 00 00       	call   480 <printf>
	for(i = 0; i <= 200000; i++)					//Add 200,000 bytes to a file
	{

		if( i % 1000 == 0)
		{
			fstat(fd, fstats);
  57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  5b:	89 34 24             	mov    %esi,(%esp)
  5e:	e8 ed 02 00 00       	call   350 <fstat>
			printf(2, "Test file size is %d bytes\n", fstats->size);
  63:	8b 43 0c             	mov    0xc(%ebx),%eax
  66:	c7 44 24 04 6b 07 00 	movl   $0x76b,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	89 44 24 08          	mov    %eax,0x8(%esp)
  79:	e8 02 04 00 00       	call   480 <printf>
  7e:	66 90                	xchg   %ax,%ax
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
	printf(2, "Opened test file\n");
	printf(2, "fd is %d\n", fd);

	for(i = 0; i <= 200000; i++)					//Add 200,000 bytes to a file
  80:	83 c3 01             	add    $0x1,%ebx
		if( i % 1000 == 0)
		{
			fstat(fd, fstats);
			printf(2, "Test file size is %d bytes\n", fstats->size);
		}
		printf(fd, "f");
  83:	c7 44 24 04 87 07 00 	movl   $0x787,0x4(%esp)
  8a:	00 
  8b:	89 34 24             	mov    %esi,(%esp)
  8e:	e8 ed 03 00 00       	call   480 <printf>
	int i;
	int fd = open("BIGFSTEST", O_CREATE | O_RDWR);			//Open test file
	printf(2, "Opened test file\n");
	printf(2, "fd is %d\n", fd);

	for(i = 0; i <= 200000; i++)					//Add 200,000 bytes to a file
  93:	81 fb 40 0d 03 00    	cmp    $0x30d40,%ebx
  99:	7f 1f                	jg     ba <main+0xba>
	{

		if( i % 1000 == 0)
  9b:	89 d8                	mov    %ebx,%eax
  9d:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  a2:	f7 ea                	imul   %edx
  a4:	89 d8                	mov    %ebx,%eax
  a6:	c1 f8 1f             	sar    $0x1f,%eax
  a9:	c1 fa 06             	sar    $0x6,%edx
  ac:	29 c2                	sub    %eax,%edx
  ae:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
  b4:	39 d3                	cmp    %edx,%ebx
  b6:	75 c8                	jne    80 <main+0x80>
  b8:	eb 9d                	jmp    57 <main+0x57>
			printf(2, "Test file size is %d bytes\n", fstats->size);
		}
		printf(fd, "f");
	}

	printf(2, "Test Passed\n");
  ba:	c7 44 24 04 89 07 00 	movl   $0x789,0x4(%esp)
  c1:	00 
  c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  c9:	e8 b2 03 00 00       	call   480 <printf>
	close(fd);
  ce:	89 34 24             	mov    %esi,(%esp)
  d1:	e8 4a 02 00 00       	call   320 <close>
	exit();
  d6:	e8 1d 02 00 00       	call   2f8 <exit>
  db:	90                   	nop    
  dc:	90                   	nop    
  dd:	90                   	nop    
  de:	90                   	nop    
  df:	90                   	nop    

000000e0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ea:	89 da                	mov    %ebx,%edx
  ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	0f b6 01             	movzbl (%ecx),%eax
  f3:	83 c1 01             	add    $0x1,%ecx
  f6:	88 02                	mov    %al,(%edx)
  f8:	83 c2 01             	add    $0x1,%edx
  fb:	84 c0                	test   %al,%al
  fd:	75 f1                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
  ff:	89 d8                	mov    %ebx,%eax
 101:	5b                   	pop    %ebx
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
 116:	53                   	push   %ebx
 117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 11a:	0f b6 01             	movzbl (%ecx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	74 24                	je     145 <strcmp+0x35>
 121:	0f b6 13             	movzbl (%ebx),%edx
 124:	38 d0                	cmp    %dl,%al
 126:	74 12                	je     13a <strcmp+0x2a>
 128:	eb 1e                	jmp    148 <strcmp+0x38>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 130:	0f b6 13             	movzbl (%ebx),%edx
 133:	83 c1 01             	add    $0x1,%ecx
 136:	38 d0                	cmp    %dl,%al
 138:	75 0e                	jne    148 <strcmp+0x38>
 13a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 13e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 141:	84 c0                	test   %al,%al
 143:	75 eb                	jne    130 <strcmp+0x20>
 145:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 148:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 149:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 14c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14d:	0f b6 d2             	movzbl %dl,%edx
 150:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 152:	c3                   	ret    
 153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 161:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 168:	80 39 00             	cmpb   $0x0,(%ecx)
 16b:	74 0e                	je     17b <strlen+0x1b>
 16d:	31 d2                	xor    %edx,%edx
 16f:	90                   	nop    
 170:	83 c2 01             	add    $0x1,%edx
 173:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 177:	89 d0                	mov    %edx,%eax
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 10             	mov    0x10(%ebp),%eax
 186:	53                   	push   %ebx
 187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 18a:	85 c0                	test   %eax,%eax
 18c:	74 10                	je     19e <memset+0x1e>
 18e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 192:	31 d2                	xor    %edx,%edx
    *d++ = c;
 194:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 197:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 19a:	39 c2                	cmp    %eax,%edx
 19c:	75 f6                	jne    194 <memset+0x14>
    *d++ = c;
  return dst;
}
 19e:	89 d8                	mov    %ebx,%eax
 1a0:	5b                   	pop    %ebx
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	75 0c                	jne    1cd <strchr+0x1d>
 1c1:	eb 11                	jmp    1d4 <strchr+0x24>
 1c3:	83 c0 01             	add    $0x1,%eax
 1c6:	0f b6 10             	movzbl (%eax),%edx
 1c9:	84 d2                	test   %dl,%dl
 1cb:	74 07                	je     1d4 <strchr+0x24>
    if(*s == c)
 1cd:	38 ca                	cmp    %cl,%dl
 1cf:	90                   	nop    
 1d0:	75 f1                	jne    1c3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 1d7:	c3                   	ret    
 1d8:	90                   	nop    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000001e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	31 db                	xor    %ebx,%ebx
 1e9:	0f b6 11             	movzbl (%ecx),%edx
 1ec:	8d 42 d0             	lea    -0x30(%edx),%eax
 1ef:	3c 09                	cmp    $0x9,%al
 1f1:	77 18                	ja     20b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 1f3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 1f6:	0f be d2             	movsbl %dl,%edx
 1f9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fd:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 201:	83 c1 01             	add    $0x1,%ecx
 204:	8d 42 d0             	lea    -0x30(%edx),%eax
 207:	3c 09                	cmp    $0x9,%al
 209:	76 e8                	jbe    1f3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 20b:	89 d8                	mov    %ebx,%eax
 20d:	5b                   	pop    %ebx
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    

00000210 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 4d 10             	mov    0x10(%ebp),%ecx
 216:	56                   	push   %esi
 217:	8b 75 08             	mov    0x8(%ebp),%esi
 21a:	53                   	push   %ebx
 21b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	85 c9                	test   %ecx,%ecx
 220:	7e 10                	jle    232 <memmove+0x22>
 222:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 224:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 228:	88 04 32             	mov    %al,(%edx,%esi,1)
 22b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22e:	39 ca                	cmp    %ecx,%edx
 230:	75 f2                	jne    224 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 232:	89 f0                	mov    %esi,%eax
 234:	5b                   	pop    %ebx
 235:	5e                   	pop    %esi
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    
 238:	90                   	nop    
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000240 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 249:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 24c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 24f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25b:	00 
 25c:	89 04 24             	mov    %eax,(%esp)
 25f:	e8 d4 00 00 00       	call   338 <open>
  if(fd < 0)
 264:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 268:	78 19                	js     283 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 1c 24             	mov    %ebx,(%esp)
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	e8 d7 00 00 00       	call   350 <fstat>
  close(fd);
 279:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 27c:	89 c6                	mov    %eax,%esi
  close(fd);
 27e:	e8 9d 00 00 00       	call   320 <close>
  return r;
}
 283:	89 f0                	mov    %esi,%eax
 285:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 288:	8b 75 fc             	mov    -0x4(%ebp),%esi
 28b:	89 ec                	mov    %ebp,%esp
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop    

00000290 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
 295:	31 f6                	xor    %esi,%esi
 297:	53                   	push   %ebx
 298:	83 ec 1c             	sub    $0x1c,%esp
 29b:	8b 7d 08             	mov    0x8(%ebp),%edi
 29e:	eb 06                	jmp    2a6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	3c 0d                	cmp    $0xd,%al
 2a2:	74 39                	je     2dd <gets+0x4d>
 2a4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2a9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ac:	7d 31                	jge    2df <gets+0x4f>
    cc = read(0, &c, 1);
 2ae:	8d 45 f3             	lea    -0xd(%ebp),%eax
 2b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2b8:	00 
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2c4:	e8 47 00 00 00       	call   310 <read>
    if(cc < 1)
 2c9:	85 c0                	test   %eax,%eax
 2cb:	7e 12                	jle    2df <gets+0x4f>
      break;
    buf[i++] = c;
 2cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2d1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 2d5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 2d9:	3c 0a                	cmp    $0xa,%al
 2db:	75 c3                	jne    2a0 <gets+0x10>
 2dd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2df:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2e3:	89 f8                	mov    %edi,%eax
 2e5:	83 c4 1c             	add    $0x1c,%esp
 2e8:	5b                   	pop    %ebx
 2e9:	5e                   	pop    %esi
 2ea:	5f                   	pop    %edi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
 2ed:	90                   	nop    
 2ee:	90                   	nop    
 2ef:	90                   	nop    

000002f0 <fork>:
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <exit>:
 2f8:	b8 02 00 00 00       	mov    $0x2,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <wait>:
 300:	b8 03 00 00 00       	mov    $0x3,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <pipe>:
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <read>:
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <write>:
 318:	b8 05 00 00 00       	mov    $0x5,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <close>:
 320:	b8 07 00 00 00       	mov    $0x7,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <kill>:
 328:	b8 08 00 00 00       	mov    $0x8,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <exec>:
 330:	b8 09 00 00 00       	mov    $0x9,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <open>:
 338:	b8 0a 00 00 00       	mov    $0xa,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <mknod>:
 340:	b8 0b 00 00 00       	mov    $0xb,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <unlink>:
 348:	b8 0c 00 00 00       	mov    $0xc,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <fstat>:
 350:	b8 0d 00 00 00       	mov    $0xd,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <link>:
 358:	b8 0e 00 00 00       	mov    $0xe,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <mkdir>:
 360:	b8 0f 00 00 00       	mov    $0xf,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <chdir>:
 368:	b8 10 00 00 00       	mov    $0x10,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <dup>:
 370:	b8 11 00 00 00       	mov    $0x11,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <getpid>:
 378:	b8 12 00 00 00       	mov    $0x12,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <sbrk>:
 380:	b8 13 00 00 00       	mov    $0x13,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <sleep>:
 388:	b8 14 00 00 00       	mov    $0x14,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <tick>:
 390:	b8 15 00 00 00       	mov    $0x15,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <fork_tickets>:
 398:	b8 16 00 00 00       	mov    $0x16,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <fork_thread>:
 3a0:	b8 17 00 00 00       	mov    $0x17,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <wait_thread>:
 3a8:	b8 18 00 00 00       	mov    $0x18,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <sleep_cond>:
 3b0:	b8 19 00 00 00       	mov    $0x19,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <wake_cond>:
 3b8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <xchng>:
 3c0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <check>:
 3c8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	83 ec 18             	sub    $0x18,%esp
 3d6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 3d9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 3dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e3:	00 
 3e4:	89 54 24 04          	mov    %edx,0x4(%esp)
 3e8:	89 04 24             	mov    %eax,(%esp)
 3eb:	e8 28 ff ff ff       	call   318 <write>
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    
 3f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000400 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	89 ce                	mov    %ecx,%esi
 407:	53                   	push   %ebx
 408:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 411:	85 c9                	test   %ecx,%ecx
 413:	74 04                	je     419 <printint+0x19>
 415:	85 d2                	test   %edx,%edx
 417:	78 54                	js     46d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 419:	89 d0                	mov    %edx,%eax
 41b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 422:	31 db                	xor    %ebx,%ebx
 424:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 427:	31 d2                	xor    %edx,%edx
 429:	f7 f6                	div    %esi
 42b:	89 c1                	mov    %eax,%ecx
 42d:	0f b6 82 9d 07 00 00 	movzbl 0x79d(%edx),%eax
 434:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 437:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 43a:	85 c9                	test   %ecx,%ecx
 43c:	89 c8                	mov    %ecx,%eax
 43e:	75 e7                	jne    427 <printint+0x27>
  if(neg)
 440:	8b 45 e0             	mov    -0x20(%ebp),%eax
 443:	85 c0                	test   %eax,%eax
 445:	74 08                	je     44f <printint+0x4f>
    buf[i++] = '-';
 447:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 44c:	83 c3 01             	add    $0x1,%ebx
 44f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 452:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 456:	83 eb 01             	sub    $0x1,%ebx
 459:	8b 45 dc             	mov    -0x24(%ebp),%eax
 45c:	e8 6f ff ff ff       	call   3d0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 461:	39 fb                	cmp    %edi,%ebx
 463:	75 ed                	jne    452 <printint+0x52>
    putc(fd, buf[i]);
}
 465:	83 c4 1c             	add    $0x1c,%esp
 468:	5b                   	pop    %ebx
 469:	5e                   	pop    %esi
 46a:	5f                   	pop    %edi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 46d:	89 d0                	mov    %edx,%eax
 46f:	f7 d8                	neg    %eax
 471:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 478:	eb a8                	jmp    422 <printint+0x22>
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000480 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 55 0c             	mov    0xc(%ebp),%edx
 48c:	0f b6 02             	movzbl (%edx),%eax
 48f:	84 c0                	test   %al,%al
 491:	0f 84 84 00 00 00    	je     51b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 497:	8d 4d 10             	lea    0x10(%ebp),%ecx
 49a:	89 d7                	mov    %edx,%edi
 49c:	31 f6                	xor    %esi,%esi
 49e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 4a1:	eb 18                	jmp    4bb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a3:	83 fb 25             	cmp    $0x25,%ebx
 4a6:	75 7b                	jne    523 <printf+0xa3>
 4a8:	66 be 25 00          	mov    $0x25,%si
 4ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 4b4:	83 c7 01             	add    $0x1,%edi
 4b7:	84 c0                	test   %al,%al
 4b9:	74 60                	je     51b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 4bb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4bd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 4c0:	74 e1                	je     4a3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c2:	83 fe 25             	cmp    $0x25,%esi
 4c5:	75 e9                	jne    4b0 <printf+0x30>
      if(c == 'd'){
 4c7:	83 fb 64             	cmp    $0x64,%ebx
 4ca:	0f 84 db 00 00 00    	je     5ab <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4d0:	83 fb 78             	cmp    $0x78,%ebx
 4d3:	74 5b                	je     530 <printf+0xb0>
 4d5:	83 fb 70             	cmp    $0x70,%ebx
 4d8:	74 56                	je     530 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4da:	83 fb 73             	cmp    $0x73,%ebx
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
 4e0:	74 72                	je     554 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e2:	83 fb 63             	cmp    $0x63,%ebx
 4e5:	0f 84 a7 00 00 00    	je     592 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4eb:	83 fb 25             	cmp    $0x25,%ebx
 4ee:	66 90                	xchg   %ax,%ax
 4f0:	0f 84 da 00 00 00    	je     5d0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
 4f9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 4fe:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 500:	e8 cb fe ff ff       	call   3d0 <putc>
        putc(fd, c);
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	0f be d3             	movsbl %bl,%edx
 50b:	e8 c0 fe ff ff       	call   3d0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 510:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 514:	83 c7 01             	add    $0x1,%edi
 517:	84 c0                	test   %al,%al
 519:	75 a0                	jne    4bb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 51b:	83 c4 0c             	add    $0xc,%esp
 51e:	5b                   	pop    %ebx
 51f:	5e                   	pop    %esi
 520:	5f                   	pop    %edi
 521:	5d                   	pop    %ebp
 522:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	0f be d3             	movsbl %bl,%edx
 529:	e8 a2 fe ff ff       	call   3d0 <putc>
 52e:	eb 80                	jmp    4b0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 530:	8b 45 f0             	mov    -0x10(%ebp),%eax
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 538:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 53a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 541:	8b 10                	mov    (%eax),%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	e8 b5 fe ff ff       	call   400 <printint>
        ap++;
 54b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 54f:	e9 5c ff ff ff       	jmp    4b0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 554:	8b 55 f0             	mov    -0x10(%ebp),%edx
 557:	8b 02                	mov    (%edx),%eax
        ap++;
 559:	83 c2 04             	add    $0x4,%edx
 55c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 55f:	ba 96 07 00 00       	mov    $0x796,%edx
 564:	85 c0                	test   %eax,%eax
 566:	75 26                	jne    58e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 568:	0f b6 02             	movzbl (%edx),%eax
 56b:	84 c0                	test   %al,%al
 56d:	74 18                	je     587 <printf+0x107>
 56f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 571:	0f be d0             	movsbl %al,%edx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 54 fe ff ff       	call   3d0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 57c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 580:	83 c3 01             	add    $0x1,%ebx
 583:	84 c0                	test   %al,%al
 585:	75 ea                	jne    571 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 587:	31 f6                	xor    %esi,%esi
 589:	e9 22 ff ff ff       	jmp    4b0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 58e:	89 c2                	mov    %eax,%edx
 590:	eb d6                	jmp    568 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 592:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 595:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	0f be 11             	movsbl (%ecx),%edx
 59d:	e8 2e fe ff ff       	call   3d0 <putc>
        ap++;
 5a2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5a6:	e9 05 ff ff ff       	jmp    4b0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5b3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5bd:	8b 10                	mov    (%eax),%edx
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	e8 39 fe ff ff       	call   400 <printint>
        ap++;
 5c7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5cb:	e9 e0 fe ff ff       	jmp    4b0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	ba 25 00 00 00       	mov    $0x25,%edx
 5d8:	31 f6                	xor    %esi,%esi
 5da:	e8 f1 fd ff ff       	call   3d0 <putc>
 5df:	e9 cc fe ff ff       	jmp    4b0 <printf+0x30>
 5e4:	90                   	nop    
 5e5:	90                   	nop    
 5e6:	90                   	nop    
 5e7:	90                   	nop    
 5e8:	90                   	nop    
 5e9:	90                   	nop    
 5ea:	90                   	nop    
 5eb:	90                   	nop    
 5ec:	90                   	nop    
 5ed:	90                   	nop    
 5ee:	90                   	nop    
 5ef:	90                   	nop    

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8b 0d b8 07 00 00    	mov    0x7b8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5fe:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	39 d9                	cmp    %ebx,%ecx
 603:	73 18                	jae    61d <free+0x2d>
 605:	8b 11                	mov    (%ecx),%edx
 607:	39 d3                	cmp    %edx,%ebx
 609:	72 17                	jb     622 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60b:	39 d1                	cmp    %edx,%ecx
 60d:	72 08                	jb     617 <free+0x27>
 60f:	39 d9                	cmp    %ebx,%ecx
 611:	72 0f                	jb     622 <free+0x32>
 613:	39 d3                	cmp    %edx,%ebx
 615:	72 0b                	jb     622 <free+0x32>
 617:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	39 d9                	cmp    %ebx,%ecx
 61b:	72 e8                	jb     605 <free+0x15>
 61d:	8b 11                	mov    (%ecx),%edx
 61f:	90                   	nop    
 620:	eb e9                	jmp    60b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 622:	8b 73 04             	mov    0x4(%ebx),%esi
 625:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 628:	39 d0                	cmp    %edx,%eax
 62a:	74 18                	je     644 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 62c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 62e:	8b 51 04             	mov    0x4(%ecx),%edx
 631:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 634:	39 d8                	cmp    %ebx,%eax
 636:	74 20                	je     658 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 638:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 63a:	5b                   	pop    %ebx
 63b:	5e                   	pop    %esi
 63c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 63d:	89 0d b8 07 00 00    	mov    %ecx,0x7b8
}
 643:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 644:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 647:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 649:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 64c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 64f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 651:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 654:	39 d8                	cmp    %ebx,%eax
 656:	75 e0                	jne    638 <free+0x48>
    p->s.size += bp->s.size;
 658:	03 53 04             	add    0x4(%ebx),%edx
 65b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 65e:	8b 13                	mov    (%ebx),%edx
 660:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 662:	5b                   	pop    %ebx
 663:	5e                   	pop    %esi
 664:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 665:	89 0d b8 07 00 00    	mov    %ecx,0x7b8
}
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 15 b8 07 00 00    	mov    0x7b8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	83 c0 07             	add    $0x7,%eax
 685:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 688:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 68a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 68d:	0f 84 8a 00 00 00    	je     71d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 695:	8b 41 04             	mov    0x4(%ecx),%eax
 698:	39 c3                	cmp    %eax,%ebx
 69a:	76 1a                	jbe    6b6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 69c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 6a3:	3b 0d b8 07 00 00    	cmp    0x7b8,%ecx
 6a9:	89 ca                	mov    %ecx,%edx
 6ab:	74 29                	je     6d6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ad:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 6af:	8b 41 04             	mov    0x4(%ecx),%eax
 6b2:	39 c3                	cmp    %eax,%ebx
 6b4:	77 ed                	ja     6a3 <malloc+0x33>
      if(p->s.size == nunits)
 6b6:	39 c3                	cmp    %eax,%ebx
 6b8:	74 5d                	je     717 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ba:	29 d8                	sub    %ebx,%eax
 6bc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 6bf:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 6c2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 6c5:	89 15 b8 07 00 00    	mov    %edx,0x7b8
      return (void*) (p + 1);
 6cb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ce:	83 c4 0c             	add    $0xc,%esp
 6d1:	5b                   	pop    %ebx
 6d2:	5e                   	pop    %esi
 6d3:	5f                   	pop    %edi
 6d4:	5d                   	pop    %ebp
 6d5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6d6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6dc:	89 de                	mov    %ebx,%esi
 6de:	89 f8                	mov    %edi,%eax
 6e0:	76 29                	jbe    70b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 96 fc ff ff       	call   380 <sbrk>
  if(p == (char*) -1)
 6ea:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ed:	74 18                	je     707 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6ef:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6f2:	83 c0 08             	add    $0x8,%eax
 6f5:	89 04 24             	mov    %eax,(%esp)
 6f8:	e8 f3 fe ff ff       	call   5f0 <free>
  return freep;
 6fd:	8b 15 b8 07 00 00    	mov    0x7b8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 703:	85 d2                	test   %edx,%edx
 705:	75 a6                	jne    6ad <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 707:	31 c0                	xor    %eax,%eax
 709:	eb c3                	jmp    6ce <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 70b:	be 00 10 00 00       	mov    $0x1000,%esi
 710:	b8 00 80 00 00       	mov    $0x8000,%eax
 715:	eb cb                	jmp    6e2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 717:	8b 01                	mov    (%ecx),%eax
 719:	89 02                	mov    %eax,(%edx)
 71b:	eb a8                	jmp    6c5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 71d:	ba b0 07 00 00       	mov    $0x7b0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 722:	c7 05 b8 07 00 00 b0 	movl   $0x7b0,0x7b8
 729:	07 00 00 
 72c:	c7 05 b0 07 00 00 b0 	movl   $0x7b0,0x7b0
 733:	07 00 00 
    base.s.size = 0;
 736:	c7 05 b4 07 00 00 00 	movl   $0x0,0x7b4
 73d:	00 00 00 
 740:	e9 4e ff ff ff       	jmp    693 <malloc+0x23>
