
_wc:     file format elf32-i386

Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	31 ff                	xor    %edi,%edi
   6:	56                   	push   %esi
   7:	53                   	push   %ebx
   8:	83 ec 2c             	sub    $0x2c,%esp
   b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	8b 45 08             	mov    0x8(%ebp),%eax
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 60 08 00 	movl   $0x860,0x4(%esp)
  32:	00 
  33:	89 04 24             	mov    %eax,(%esp)
  36:	e8 95 03 00 00       	call   3d0 <read>
  3b:	83 f8 00             	cmp    $0x0,%eax
  3e:	89 c6                	mov    %eax,%esi
  40:	7e 59                	jle    9b <wc+0x9b>
  42:	31 db                	xor    %ebx,%ebx
  44:	eb 0e                	jmp    54 <wc+0x54>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  4d:	83 c3 01             	add    $0x1,%ebx
  50:	39 f3                	cmp    %esi,%ebx
  52:	74 3d                	je     91 <wc+0x91>
      c++;
      if(buf[i] == '\n')
  54:	0f be 83 60 08 00 00 	movsbl 0x860(%ebx),%eax
        l++;
  5b:	31 d2                	xor    %edx,%edx
      if(strchr(" \r\t\n\v", buf[i]))
  5d:	c7 04 24 d5 07 00 00 	movl   $0x7d5,(%esp)
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
  64:	3c 0a                	cmp    $0xa,%al
  66:	0f 94 c2             	sete   %dl
  69:	01 d7                	add    %edx,%edi
      if(strchr(" \r\t\n\v", buf[i]))
  6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  6f:	e8 fc 01 00 00       	call   270 <strchr>
  74:	85 c0                	test   %eax,%eax
  76:	75 ce                	jne    46 <wc+0x46>
        inword = 0;
      else if(!inword){
  78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7b:	85 c0                	test   %eax,%eax
  7d:	75 ce                	jne    4d <wc+0x4d>
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 c3 01             	add    $0x1,%ebx
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
  82:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  86:	39 f3                	cmp    %esi,%ebx
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
  88:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  8f:	75 c3                	jne    54 <wc+0x54>
  91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  94:	01 f0                	add    %esi,%eax
  96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  99:	eb 85                	jmp    20 <wc+0x20>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  9b:	75 35                	jne    d2 <wc+0xd2>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  a4:	c7 44 24 04 eb 07 00 	movl   $0x7eb,0x4(%esp)
  ab:	00 
  ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b3:	89 44 24 14          	mov    %eax,0x14(%esp)
  b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  c5:	e8 46 04 00 00       	call   510 <printf>
}
  ca:	83 c4 2c             	add    $0x2c,%esp
  cd:	5b                   	pop    %ebx
  ce:	5e                   	pop    %esi
  cf:	5f                   	pop    %edi
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    
        inword = 1;
      }
    }
  }
  if(n < 0){
    printf(1, "wc: read error\n");
  d2:	c7 44 24 04 db 07 00 	movl   $0x7db,0x4(%esp)
  d9:	00 
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	e8 2a 04 00 00       	call   510 <printf>
    exit();
  e6:	e8 cd 02 00 00       	call   3b8 <exit>
  eb:	90                   	nop    
  ec:	8d 74 26 00          	lea    0x0(%esi),%esi

000000f0 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
  f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f4:	83 e4 f0             	and    $0xfffffff0,%esp
  f7:	ff 71 fc             	pushl  -0x4(%ecx)
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	57                   	push   %edi
  int fd, i;

  if(argc <= 1){
    wc(0, "");
    exit();
  fe:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	51                   	push   %ecx
 106:	83 ec 18             	sub    $0x18,%esp
 109:	8b 01                	mov    (%ecx),%eax
 10b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 10e:	8b 41 04             	mov    0x4(%ecx),%eax
  int fd, i;

  if(argc <= 1){
 111:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
    wc(0, "");
    exit();
 115:	8d 70 04             	lea    0x4(%eax),%esi
int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
 118:	7f 27                	jg     141 <main+0x51>
 11a:	eb 61                	jmp    17d <main+0x8d>
 11c:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 120:	8b 06                	mov    (%esi),%eax
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 122:	83 c7 01             	add    $0x1,%edi
 125:	83 c6 04             	add    $0x4,%esi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 128:	89 1c 24             	mov    %ebx,(%esp)
 12b:	89 44 24 04          	mov    %eax,0x4(%esp)
 12f:	e8 cc fe ff ff       	call   0 <wc>
    close(fd);
 134:	89 1c 24             	mov    %ebx,(%esp)
 137:	e8 a4 02 00 00       	call   3e0 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 13c:	3b 7d ec             	cmp    -0x14(%ebp),%edi
 13f:	74 37                	je     178 <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
 141:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 148:	00 
 149:	8b 06                	mov    (%esi),%eax
 14b:	89 04 24             	mov    %eax,(%esp)
 14e:	e8 a5 02 00 00       	call   3f8 <open>
 153:	85 c0                	test   %eax,%eax
 155:	89 c3                	mov    %eax,%ebx
 157:	79 c7                	jns    120 <main+0x30>
      printf(1, "cat: cannot open %s\n", argv[i]);
 159:	8b 06                	mov    (%esi),%eax
 15b:	c7 44 24 04 f8 07 00 	movl   $0x7f8,0x4(%esp)
 162:	00 
 163:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16a:	89 44 24 08          	mov    %eax,0x8(%esp)
 16e:	e8 9d 03 00 00       	call   510 <printf>
      exit();
 173:	e8 40 02 00 00       	call   3b8 <exit>
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 178:	e8 3b 02 00 00       	call   3b8 <exit>
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
 17d:	c7 44 24 04 ea 07 00 	movl   $0x7ea,0x4(%esp)
 184:	00 
 185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18c:	e8 6f fe ff ff       	call   0 <wc>
    exit();
 191:	e8 22 02 00 00       	call   3b8 <exit>
 196:	90                   	nop    
 197:	90                   	nop    
 198:	90                   	nop    
 199:	90                   	nop    
 19a:	90                   	nop    
 19b:	90                   	nop    
 19c:	90                   	nop    
 19d:	90                   	nop    
 19e:	90                   	nop    
 19f:	90                   	nop    

000001a0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1aa:	89 da                	mov    %ebx,%edx
 1ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	0f b6 01             	movzbl (%ecx),%eax
 1b3:	83 c1 01             	add    $0x1,%ecx
 1b6:	88 02                	mov    %al,(%edx)
 1b8:	83 c2 01             	add    $0x1,%edx
 1bb:	84 c0                	test   %al,%al
 1bd:	75 f1                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1bf:	89 d8                	mov    %ebx,%eax
 1c1:	5b                   	pop    %ebx
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d6:	53                   	push   %ebx
 1d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 1da:	0f b6 01             	movzbl (%ecx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	74 24                	je     205 <strcmp+0x35>
 1e1:	0f b6 13             	movzbl (%ebx),%edx
 1e4:	38 d0                	cmp    %dl,%al
 1e6:	74 12                	je     1fa <strcmp+0x2a>
 1e8:	eb 1e                	jmp    208 <strcmp+0x38>
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f0:	0f b6 13             	movzbl (%ebx),%edx
 1f3:	83 c1 01             	add    $0x1,%ecx
 1f6:	38 d0                	cmp    %dl,%al
 1f8:	75 0e                	jne    208 <strcmp+0x38>
 1fa:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 1fe:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 201:	84 c0                	test   %al,%al
 203:	75 eb                	jne    1f0 <strcmp+0x20>
 205:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 208:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 209:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 20c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 20d:	0f b6 d2             	movzbl %dl,%edx
 210:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 212:	c3                   	ret    
 213:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000220 <strlen>:

uint
strlen(char *s)
{
 220:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 221:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 223:	89 e5                	mov    %esp,%ebp
 225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 228:	80 39 00             	cmpb   $0x0,(%ecx)
 22b:	74 0e                	je     23b <strlen+0x1b>
 22d:	31 d2                	xor    %edx,%edx
 22f:	90                   	nop    
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 10             	mov    0x10(%ebp),%eax
 246:	53                   	push   %ebx
 247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 24a:	85 c0                	test   %eax,%eax
 24c:	74 10                	je     25e <memset+0x1e>
 24e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 252:	31 d2                	xor    %edx,%edx
    *d++ = c;
 254:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 257:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 25a:	39 c2                	cmp    %eax,%edx
 25c:	75 f6                	jne    254 <memset+0x14>
    *d++ = c;
  return dst;
}
 25e:	89 d8                	mov    %ebx,%eax
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	75 0c                	jne    28d <strchr+0x1d>
 281:	eb 11                	jmp    294 <strchr+0x24>
 283:	83 c0 01             	add    $0x1,%eax
 286:	0f b6 10             	movzbl (%eax),%edx
 289:	84 d2                	test   %dl,%dl
 28b:	74 07                	je     294 <strchr+0x24>
    if(*s == c)
 28d:	38 ca                	cmp    %cl,%dl
 28f:	90                   	nop    
 290:	75 f1                	jne    283 <strchr+0x13>
      return (char*) s;
  return 0;
}
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 295:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 297:	c3                   	ret    
 298:	90                   	nop    
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000002a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a7:	31 db                	xor    %ebx,%ebx
 2a9:	0f b6 11             	movzbl (%ecx),%edx
 2ac:	8d 42 d0             	lea    -0x30(%edx),%eax
 2af:	3c 09                	cmp    $0x9,%al
 2b1:	77 18                	ja     2cb <atoi+0x2b>
    n = n*10 + *s++ - '0';
 2b3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 2b6:	0f be d2             	movsbl %dl,%edx
 2b9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bd:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 2c1:	83 c1 01             	add    $0x1,%ecx
 2c4:	8d 42 d0             	lea    -0x30(%edx),%eax
 2c7:	3c 09                	cmp    $0x9,%al
 2c9:	76 e8                	jbe    2b3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 2cb:	89 d8                	mov    %ebx,%eax
 2cd:	5b                   	pop    %ebx
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2d6:	56                   	push   %esi
 2d7:	8b 75 08             	mov    0x8(%ebp),%esi
 2da:	53                   	push   %ebx
 2db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 c9                	test   %ecx,%ecx
 2e0:	7e 10                	jle    2f2 <memmove+0x22>
 2e2:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 2e4:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 2e8:	88 04 32             	mov    %al,(%edx,%esi,1)
 2eb:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ee:	39 ca                	cmp    %ecx,%edx
 2f0:	75 f2                	jne    2e4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 2f2:	89 f0                	mov    %esi,%eax
 2f4:	5b                   	pop    %ebx
 2f5:	5e                   	pop    %esi
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    
 2f8:	90                   	nop    
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000300 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 306:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 309:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 30c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 30f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 314:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 31b:	00 
 31c:	89 04 24             	mov    %eax,(%esp)
 31f:	e8 d4 00 00 00       	call   3f8 <open>
  if(fd < 0)
 324:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 326:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 328:	78 19                	js     343 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 1c 24             	mov    %ebx,(%esp)
 330:	89 44 24 04          	mov    %eax,0x4(%esp)
 334:	e8 d7 00 00 00       	call   410 <fstat>
  close(fd);
 339:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 33c:	89 c6                	mov    %eax,%esi
  close(fd);
 33e:	e8 9d 00 00 00       	call   3e0 <close>
  return r;
}
 343:	89 f0                	mov    %esi,%eax
 345:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 348:	8b 75 fc             	mov    -0x4(%ebp),%esi
 34b:	89 ec                	mov    %ebp,%esp
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    
 34f:	90                   	nop    

00000350 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	31 f6                	xor    %esi,%esi
 357:	53                   	push   %ebx
 358:	83 ec 1c             	sub    $0x1c,%esp
 35b:	8b 7d 08             	mov    0x8(%ebp),%edi
 35e:	eb 06                	jmp    366 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 360:	3c 0d                	cmp    $0xd,%al
 362:	74 39                	je     39d <gets+0x4d>
 364:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	8d 5e 01             	lea    0x1(%esi),%ebx
 369:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 36c:	7d 31                	jge    39f <gets+0x4f>
    cc = read(0, &c, 1);
 36e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 371:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 378:	00 
 379:	89 44 24 04          	mov    %eax,0x4(%esp)
 37d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 384:	e8 47 00 00 00       	call   3d0 <read>
    if(cc < 1)
 389:	85 c0                	test   %eax,%eax
 38b:	7e 12                	jle    39f <gets+0x4f>
      break;
    buf[i++] = c;
 38d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 391:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 395:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 399:	3c 0a                	cmp    $0xa,%al
 39b:	75 c3                	jne    360 <gets+0x10>
 39d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 39f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3a3:	89 f8                	mov    %edi,%eax
 3a5:	83 c4 1c             	add    $0x1c,%esp
 3a8:	5b                   	pop    %ebx
 3a9:	5e                   	pop    %esi
 3aa:	5f                   	pop    %edi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	90                   	nop    
 3ae:	90                   	nop    
 3af:	90                   	nop    

000003b0 <fork>:
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <exit>:
 3b8:	b8 02 00 00 00       	mov    $0x2,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <wait>:
 3c0:	b8 03 00 00 00       	mov    $0x3,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <pipe>:
 3c8:	b8 04 00 00 00       	mov    $0x4,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <read>:
 3d0:	b8 06 00 00 00       	mov    $0x6,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <write>:
 3d8:	b8 05 00 00 00       	mov    $0x5,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <close>:
 3e0:	b8 07 00 00 00       	mov    $0x7,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <kill>:
 3e8:	b8 08 00 00 00       	mov    $0x8,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <exec>:
 3f0:	b8 09 00 00 00       	mov    $0x9,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <open>:
 3f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <mknod>:
 400:	b8 0b 00 00 00       	mov    $0xb,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <unlink>:
 408:	b8 0c 00 00 00       	mov    $0xc,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <fstat>:
 410:	b8 0d 00 00 00       	mov    $0xd,%eax
 415:	cd 30                	int    $0x30
 417:	c3                   	ret    

00000418 <link>:
 418:	b8 0e 00 00 00       	mov    $0xe,%eax
 41d:	cd 30                	int    $0x30
 41f:	c3                   	ret    

00000420 <mkdir>:
 420:	b8 0f 00 00 00       	mov    $0xf,%eax
 425:	cd 30                	int    $0x30
 427:	c3                   	ret    

00000428 <chdir>:
 428:	b8 10 00 00 00       	mov    $0x10,%eax
 42d:	cd 30                	int    $0x30
 42f:	c3                   	ret    

00000430 <dup>:
 430:	b8 11 00 00 00       	mov    $0x11,%eax
 435:	cd 30                	int    $0x30
 437:	c3                   	ret    

00000438 <getpid>:
 438:	b8 12 00 00 00       	mov    $0x12,%eax
 43d:	cd 30                	int    $0x30
 43f:	c3                   	ret    

00000440 <sbrk>:
 440:	b8 13 00 00 00       	mov    $0x13,%eax
 445:	cd 30                	int    $0x30
 447:	c3                   	ret    

00000448 <sleep>:
 448:	b8 14 00 00 00       	mov    $0x14,%eax
 44d:	cd 30                	int    $0x30
 44f:	c3                   	ret    

00000450 <kalloctest>:
 450:	b8 15 00 00 00       	mov    $0x15,%eax
 455:	cd 30                	int    $0x30
 457:	c3                   	ret    
 458:	90                   	nop    
 459:	90                   	nop    
 45a:	90                   	nop    
 45b:	90                   	nop    
 45c:	90                   	nop    
 45d:	90                   	nop    
 45e:	90                   	nop    
 45f:	90                   	nop    

00000460 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	83 ec 18             	sub    $0x18,%esp
 466:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 469:	8d 55 fc             	lea    -0x4(%ebp),%edx
 46c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 473:	00 
 474:	89 54 24 04          	mov    %edx,0x4(%esp)
 478:	89 04 24             	mov    %eax,(%esp)
 47b:	e8 58 ff ff ff       	call   3d8 <write>
}
 480:	c9                   	leave  
 481:	c3                   	ret    
 482:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	89 ce                	mov    %ecx,%esi
 497:	53                   	push   %ebx
 498:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 49e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a1:	85 c9                	test   %ecx,%ecx
 4a3:	74 04                	je     4a9 <printint+0x19>
 4a5:	85 d2                	test   %edx,%edx
 4a7:	78 54                	js     4fd <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a9:	89 d0                	mov    %edx,%eax
 4ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 4b2:	31 db                	xor    %ebx,%ebx
 4b4:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 4b7:	31 d2                	xor    %edx,%edx
 4b9:	f7 f6                	div    %esi
 4bb:	89 c1                	mov    %eax,%ecx
 4bd:	0f b6 82 14 08 00 00 	movzbl 0x814(%edx),%eax
 4c4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 4c7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 4ca:	85 c9                	test   %ecx,%ecx
 4cc:	89 c8                	mov    %ecx,%eax
 4ce:	75 e7                	jne    4b7 <printint+0x27>
  if(neg)
 4d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4d3:	85 c0                	test   %eax,%eax
 4d5:	74 08                	je     4df <printint+0x4f>
    buf[i++] = '-';
 4d7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 4dc:	83 c3 01             	add    $0x1,%ebx
 4df:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 4e2:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 4e6:	83 eb 01             	sub    $0x1,%ebx
 4e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4ec:	e8 6f ff ff ff       	call   460 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f1:	39 fb                	cmp    %edi,%ebx
 4f3:	75 ed                	jne    4e2 <printint+0x52>
    putc(fd, buf[i]);
}
 4f5:	83 c4 1c             	add    $0x1c,%esp
 4f8:	5b                   	pop    %ebx
 4f9:	5e                   	pop    %esi
 4fa:	5f                   	pop    %edi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4fd:	89 d0                	mov    %edx,%eax
 4ff:	f7 d8                	neg    %eax
 501:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 508:	eb a8                	jmp    4b2 <printint+0x22>
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000510 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 519:	8b 55 0c             	mov    0xc(%ebp),%edx
 51c:	0f b6 02             	movzbl (%edx),%eax
 51f:	84 c0                	test   %al,%al
 521:	0f 84 84 00 00 00    	je     5ab <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 527:	8d 4d 10             	lea    0x10(%ebp),%ecx
 52a:	89 d7                	mov    %edx,%edi
 52c:	31 f6                	xor    %esi,%esi
 52e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 531:	eb 18                	jmp    54b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 533:	83 fb 25             	cmp    $0x25,%ebx
 536:	75 7b                	jne    5b3 <printf+0xa3>
 538:	66 be 25 00          	mov    $0x25,%si
 53c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 540:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 544:	83 c7 01             	add    $0x1,%edi
 547:	84 c0                	test   %al,%al
 549:	74 60                	je     5ab <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 54b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 54d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 550:	74 e1                	je     533 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 552:	83 fe 25             	cmp    $0x25,%esi
 555:	75 e9                	jne    540 <printf+0x30>
      if(c == 'd'){
 557:	83 fb 64             	cmp    $0x64,%ebx
 55a:	0f 84 db 00 00 00    	je     63b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 560:	83 fb 78             	cmp    $0x78,%ebx
 563:	74 5b                	je     5c0 <printf+0xb0>
 565:	83 fb 70             	cmp    $0x70,%ebx
 568:	74 56                	je     5c0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 56a:	83 fb 73             	cmp    $0x73,%ebx
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	74 72                	je     5e4 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 572:	83 fb 63             	cmp    $0x63,%ebx
 575:	0f 84 a7 00 00 00    	je     622 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 57b:	83 fb 25             	cmp    $0x25,%ebx
 57e:	66 90                	xchg   %ax,%ax
 580:	0f 84 da 00 00 00    	je     660 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 58e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 590:	e8 cb fe ff ff       	call   460 <putc>
        putc(fd, c);
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	0f be d3             	movsbl %bl,%edx
 59b:	e8 c0 fe ff ff       	call   460 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 5a4:	83 c7 01             	add    $0x1,%edi
 5a7:	84 c0                	test   %al,%al
 5a9:	75 a0                	jne    54b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ab:	83 c4 0c             	add    $0xc,%esp
 5ae:	5b                   	pop    %ebx
 5af:	5e                   	pop    %esi
 5b0:	5f                   	pop    %edi
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	0f be d3             	movsbl %bl,%edx
 5b9:	e8 a2 fe ff ff       	call   460 <putc>
 5be:	eb 80                	jmp    540 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5c8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	e8 b5 fe ff ff       	call   490 <printint>
        ap++;
 5db:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 5df:	e9 5c ff ff ff       	jmp    540 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 5e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 5e7:	8b 02                	mov    (%edx),%eax
        ap++;
 5e9:	83 c2 04             	add    $0x4,%edx
 5ec:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 5ef:	ba 0d 08 00 00       	mov    $0x80d,%edx
 5f4:	85 c0                	test   %eax,%eax
 5f6:	75 26                	jne    61e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 5f8:	0f b6 02             	movzbl (%edx),%eax
 5fb:	84 c0                	test   %al,%al
 5fd:	74 18                	je     617 <printf+0x107>
 5ff:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 601:	0f be d0             	movsbl %al,%edx
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	e8 54 fe ff ff       	call   460 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 610:	83 c3 01             	add    $0x1,%ebx
 613:	84 c0                	test   %al,%al
 615:	75 ea                	jne    601 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 617:	31 f6                	xor    %esi,%esi
 619:	e9 22 ff ff ff       	jmp    540 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 61e:	89 c2                	mov    %eax,%edx
 620:	eb d6                	jmp    5f8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 622:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 625:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	0f be 11             	movsbl (%ecx),%edx
 62d:	e8 2e fe ff ff       	call   460 <putc>
        ap++;
 632:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 636:	e9 05 ff ff ff       	jmp    540 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 63b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 643:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 646:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 64d:	8b 10                	mov    (%eax),%edx
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	e8 39 fe ff ff       	call   490 <printint>
        ap++;
 657:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 65b:	e9 e0 fe ff ff       	jmp    540 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	ba 25 00 00 00       	mov    $0x25,%edx
 668:	31 f6                	xor    %esi,%esi
 66a:	e8 f1 fd ff ff       	call   460 <putc>
 66f:	e9 cc fe ff ff       	jmp    540 <printf+0x30>
 674:	90                   	nop    
 675:	90                   	nop    
 676:	90                   	nop    
 677:	90                   	nop    
 678:	90                   	nop    
 679:	90                   	nop    
 67a:	90                   	nop    
 67b:	90                   	nop    
 67c:	90                   	nop    
 67d:	90                   	nop    
 67e:	90                   	nop    
 67f:	90                   	nop    

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	8b 0d 48 08 00 00    	mov    0x848,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 687:	89 e5                	mov    %esp,%ebp
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 68e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	39 d9                	cmp    %ebx,%ecx
 693:	73 18                	jae    6ad <free+0x2d>
 695:	8b 11                	mov    (%ecx),%edx
 697:	39 d3                	cmp    %edx,%ebx
 699:	72 17                	jb     6b2 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69b:	39 d1                	cmp    %edx,%ecx
 69d:	72 08                	jb     6a7 <free+0x27>
 69f:	39 d9                	cmp    %ebx,%ecx
 6a1:	72 0f                	jb     6b2 <free+0x32>
 6a3:	39 d3                	cmp    %edx,%ebx
 6a5:	72 0b                	jb     6b2 <free+0x32>
 6a7:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a9:	39 d9                	cmp    %ebx,%ecx
 6ab:	72 e8                	jb     695 <free+0x15>
 6ad:	8b 11                	mov    (%ecx),%edx
 6af:	90                   	nop    
 6b0:	eb e9                	jmp    69b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b2:	8b 73 04             	mov    0x4(%ebx),%esi
 6b5:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 6b8:	39 d0                	cmp    %edx,%eax
 6ba:	74 18                	je     6d4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6bc:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 6be:	8b 51 04             	mov    0x4(%ecx),%edx
 6c1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6c4:	39 d8                	cmp    %ebx,%eax
 6c6:	74 20                	je     6e8 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6c8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 6ca:	5b                   	pop    %ebx
 6cb:	5e                   	pop    %esi
 6cc:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6cd:	89 0d 48 08 00 00    	mov    %ecx,0x848
}
 6d3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 6d7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6dc:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6df:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6e1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 6e4:	39 d8                	cmp    %ebx,%eax
 6e6:	75 e0                	jne    6c8 <free+0x48>
    p->s.size += bp->s.size;
 6e8:	03 53 04             	add    0x4(%ebx),%edx
 6eb:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 6ee:	8b 13                	mov    (%ebx),%edx
 6f0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6f2:	5b                   	pop    %ebx
 6f3:	5e                   	pop    %esi
 6f4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6f5:	89 0d 48 08 00 00    	mov    %ecx,0x848
}
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 70c:	8b 15 48 08 00 00    	mov    0x848,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	83 c0 07             	add    $0x7,%eax
 715:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 718:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 71d:	0f 84 8a 00 00 00    	je     7ad <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 725:	8b 41 04             	mov    0x4(%ecx),%eax
 728:	39 c3                	cmp    %eax,%ebx
 72a:	76 1a                	jbe    746 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 72c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 733:	3b 0d 48 08 00 00    	cmp    0x848,%ecx
 739:	89 ca                	mov    %ecx,%edx
 73b:	74 29                	je     766 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 73f:	8b 41 04             	mov    0x4(%ecx),%eax
 742:	39 c3                	cmp    %eax,%ebx
 744:	77 ed                	ja     733 <malloc+0x33>
      if(p->s.size == nunits)
 746:	39 c3                	cmp    %eax,%ebx
 748:	74 5d                	je     7a7 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 74a:	29 d8                	sub    %ebx,%eax
 74c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 74f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 752:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 755:	89 15 48 08 00 00    	mov    %edx,0x848
      return (void*) (p + 1);
 75b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 75e:	83 c4 0c             	add    $0xc,%esp
 761:	5b                   	pop    %ebx
 762:	5e                   	pop    %esi
 763:	5f                   	pop    %edi
 764:	5d                   	pop    %ebp
 765:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 766:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 76c:	89 de                	mov    %ebx,%esi
 76e:	89 f8                	mov    %edi,%eax
 770:	76 29                	jbe    79b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 c6 fc ff ff       	call   440 <sbrk>
  if(p == (char*) -1)
 77a:	83 f8 ff             	cmp    $0xffffffff,%eax
 77d:	74 18                	je     797 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 77f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 782:	83 c0 08             	add    $0x8,%eax
 785:	89 04 24             	mov    %eax,(%esp)
 788:	e8 f3 fe ff ff       	call   680 <free>
  return freep;
 78d:	8b 15 48 08 00 00    	mov    0x848,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 793:	85 d2                	test   %edx,%edx
 795:	75 a6                	jne    73d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 797:	31 c0                	xor    %eax,%eax
 799:	eb c3                	jmp    75e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 79b:	be 00 10 00 00       	mov    $0x1000,%esi
 7a0:	b8 00 80 00 00       	mov    $0x8000,%eax
 7a5:	eb cb                	jmp    772 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7a7:	8b 01                	mov    (%ecx),%eax
 7a9:	89 02                	mov    %eax,(%edx)
 7ab:	eb a8                	jmp    755 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 7ad:	ba 40 08 00 00       	mov    $0x840,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7b2:	c7 05 48 08 00 00 40 	movl   $0x840,0x848
 7b9:	08 00 00 
 7bc:	c7 05 40 08 00 00 40 	movl   $0x840,0x840
 7c3:	08 00 00 
    base.s.size = 0;
 7c6:	c7 05 44 08 00 00 00 	movl   $0x0,0x844
 7cd:	00 00 00 
 7d0:	e9 4e ff ff ff       	jmp    723 <malloc+0x23>
