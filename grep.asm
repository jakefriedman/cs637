
_grep:     file format elf32-i386

Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  16:	89 3c 24             	mov    %edi,(%esp)
  19:	e8 32 00 00 00       	call   50 <matchhere>
  1e:	85 c0                	test   %eax,%eax
  20:	75 20                	jne    42 <matchstar+0x42>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  22:	0f b6 03             	movzbl (%ebx),%eax
  25:	84 c0                	test   %al,%al
  27:	74 0f                	je     38 <matchstar+0x38>
  29:	0f be c0             	movsbl %al,%eax
  2c:	83 c3 01             	add    $0x1,%ebx
  2f:	39 f0                	cmp    %esi,%eax
  31:	74 df                	je     12 <matchstar+0x12>
  33:	83 fe 2e             	cmp    $0x2e,%esi
  36:	74 da                	je     12 <matchstar+0x12>
  return 0;
}
  38:	83 c4 0c             	add    $0xc,%esp
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  3b:	31 c0                	xor    %eax,%eax
  return 0;
}
  3d:	5b                   	pop    %ebx
  3e:	5e                   	pop    %esi
  3f:	5f                   	pop    %edi
  40:	5d                   	pop    %ebp
  41:	c3                   	ret    
  42:	83 c4 0c             	add    $0xc,%esp

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  45:	b8 01 00 00 00       	mov    $0x1,%eax
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
  4a:	5b                   	pop    %ebx
  4b:	5e                   	pop    %esi
  4c:	5f                   	pop    %edi
  4d:	5d                   	pop    %ebp
  4e:	c3                   	ret    
  4f:	90                   	nop    

00000050 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	83 ec 10             	sub    $0x10,%esp
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '\0')
  5e:	0f b6 08             	movzbl (%eax),%ecx
  61:	84 c9                	test   %cl,%cl
  63:	74 55                	je     ba <matchhere+0x6a>
    return 1;
  if(re[1] == '*')
  65:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  69:	8d 58 01             	lea    0x1(%eax),%ebx
  6c:	80 fa 2a             	cmp    $0x2a,%dl
  6f:	75 2d                	jne    9e <matchhere+0x4e>
  71:	eb 55                	jmp    c8 <matchhere+0x78>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  73:	0f b6 06             	movzbl (%esi),%eax
  76:	84 c0                	test   %al,%al
  78:	74 37                	je     b1 <matchhere+0x61>
  7a:	80 f9 2e             	cmp    $0x2e,%cl
  7d:	8d 76 00             	lea    0x0(%esi),%esi
  80:	74 04                	je     86 <matchhere+0x36>
  82:	38 c1                	cmp    %al,%cl
  84:	75 2b                	jne    b1 <matchhere+0x61>
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  86:	0f b6 0b             	movzbl (%ebx),%ecx
  89:	84 c9                	test   %cl,%cl
  8b:	74 2d                	je     ba <matchhere+0x6a>
    return 1;
  if(re[1] == '*')
  8d:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  91:	83 c6 01             	add    $0x1,%esi
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
  94:	8d 43 01             	lea    0x1(%ebx),%eax
  97:	80 fa 2a             	cmp    $0x2a,%dl
  9a:	74 2a                	je     c6 <matchhere+0x76>
    return matchstar(re[0], re+2, text);
  9c:	89 c3                	mov    %eax,%ebx
  if(re[0] == '$' && re[1] == '\0')
  9e:	80 f9 24             	cmp    $0x24,%cl
  a1:	75 d0                	jne    73 <matchhere+0x23>
  a3:	84 d2                	test   %dl,%dl
  a5:	75 cc                	jne    73 <matchhere+0x23>
    return *text == '\0';
  a7:	31 c0                	xor    %eax,%eax
  a9:	80 3e 00             	cmpb   $0x0,(%esi)
  ac:	0f 94 c0             	sete   %al
  af:	eb 02                	jmp    b3 <matchhere+0x63>
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  b1:	31 c0                	xor    %eax,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	5b                   	pop    %ebx
  b7:	5e                   	pop    %esi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    
  ba:	83 c4 10             	add    $0x10,%esp
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  bd:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  c2:	5b                   	pop    %ebx
  c3:	5e                   	pop    %esi
  c4:	5d                   	pop    %ebp
  c5:	c3                   	ret    
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
  c6:	89 d8                	mov    %ebx,%eax
    return matchstar(re[0], re+2, text);
  c8:	83 c0 02             	add    $0x2,%eax
  cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  cf:	0f be c1             	movsbl %cl,%eax
  d2:	89 74 24 08          	mov    %esi,0x8(%esp)
  d6:	89 04 24             	mov    %eax,(%esp)
  d9:	e8 22 ff ff ff       	call   0 <matchstar>
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  de:	83 c4 10             	add    $0x10,%esp
  e1:	5b                   	pop    %ebx
  e2:	5e                   	pop    %esi
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret    
  e5:	8d 74 26 00          	lea    0x0(%esi),%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000f0 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	83 ec 10             	sub    $0x10,%esp
  f8:	8b 75 08             	mov    0x8(%ebp),%esi
  fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  fe:	80 3e 5e             	cmpb   $0x5e,(%esi)
 101:	75 05                	jne    108 <match+0x18>
 103:	eb 1f                	jmp    124 <match+0x34>
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 105:	83 c3 01             	add    $0x1,%ebx
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 108:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 10c:	89 34 24             	mov    %esi,(%esp)
 10f:	e8 3c ff ff ff       	call   50 <matchhere>
 114:	85 c0                	test   %eax,%eax
 116:	75 1d                	jne    135 <match+0x45>
      return 1;
  }while(*text++ != '\0');
 118:	80 3b 00             	cmpb   $0x0,(%ebx)
 11b:	75 e8                	jne    105 <match+0x15>
  return 0;
}
 11d:	83 c4 10             	add    $0x10,%esp
 120:	5b                   	pop    %ebx
 121:	5e                   	pop    %esi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 124:	8d 46 01             	lea    0x1(%esi),%eax
 127:	89 45 08             	mov    %eax,0x8(%ebp)
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	5b                   	pop    %ebx
 12e:	5e                   	pop    %esi
 12f:	5d                   	pop    %ebp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 130:	e9 1b ff ff ff       	jmp    50 <matchhere>
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 135:	83 c4 10             	add    $0x10,%esp
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 138:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
 13d:	5b                   	pop    %ebx
 13e:	5e                   	pop    %esi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	eb 0d                	jmp    150 <grep>
 143:	90                   	nop    
 144:	90                   	nop    
 145:	90                   	nop    
 146:	90                   	nop    
 147:	90                   	nop    
 148:	90                   	nop    
 149:	90                   	nop    
 14a:	90                   	nop    
 14b:	90                   	nop    
 14c:	90                   	nop    
 14d:	90                   	nop    
 14e:	90                   	nop    
 14f:	90                   	nop    

00000150 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	83 ec 1c             	sub    $0x1c,%esp
 159:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
 160:	b8 00 04 00 00       	mov    $0x400,%eax
 165:	2b 45 f0             	sub    -0x10(%ebp),%eax
 168:	89 44 24 08          	mov    %eax,0x8(%esp)
 16c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 16f:	05 00 0a 00 00       	add    $0xa00,%eax
 174:	89 44 24 04          	mov    %eax,0x4(%esp)
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	89 04 24             	mov    %eax,(%esp)
 17e:	e8 bd 03 00 00       	call   540 <read>
 183:	85 c0                	test   %eax,%eax
 185:	89 c7                	mov    %eax,%edi
 187:	0f 8e a2 00 00 00    	jle    22f <grep+0xdf>
 18d:	be 00 0a 00 00       	mov    $0xa00,%esi
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 192:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 199:	00 
 19a:	89 34 24             	mov    %esi,(%esp)
 19d:	e8 3e 02 00 00       	call   3e0 <strchr>
 1a2:	85 c0                	test   %eax,%eax
 1a4:	89 c3                	mov    %eax,%ebx
 1a6:	74 3f                	je     1e7 <grep+0x97>
      *q = 0;
 1a8:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	89 74 24 04          	mov    %esi,0x4(%esp)
 1b2:	89 04 24             	mov    %eax,(%esp)
 1b5:	e8 36 ff ff ff       	call   f0 <match>
 1ba:	85 c0                	test   %eax,%eax
 1bc:	75 07                	jne    1c5 <grep+0x75>
 1be:	83 c3 01             	add    $0x1,%ebx
        *q = '\n';
        write(1, p, q+1 - p);
 1c1:	89 de                	mov    %ebx,%esi
 1c3:	eb cd                	jmp    192 <grep+0x42>
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      if(match(pattern, p)){
        *q = '\n';
 1c5:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 1c8:	83 c3 01             	add    $0x1,%ebx
 1cb:	89 d8                	mov    %ebx,%eax
 1cd:	29 f0                	sub    %esi,%eax
 1cf:	89 74 24 04          	mov    %esi,0x4(%esp)
 1d3:	89 de                	mov    %ebx,%esi
 1d5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e0:	e8 63 03 00 00       	call   548 <write>
 1e5:	eb ab                	jmp    192 <grep+0x42>
      }
      p = q+1;
    }
    if(p == buf)
 1e7:	81 fe 00 0a 00 00    	cmp    $0xa00,%esi
 1ed:	74 34                	je     223 <grep+0xd3>
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
 1ef:	01 7d f0             	add    %edi,-0x10(%ebp)
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f5:	85 c0                	test   %eax,%eax
 1f7:	0f 8e 63 ff ff ff    	jle    160 <grep+0x10>
      m -= p - buf;
 1fd:	89 f0                	mov    %esi,%eax
 1ff:	2d 00 0a 00 00       	sub    $0xa00,%eax
 204:	29 45 f0             	sub    %eax,-0x10(%ebp)
      memmove(buf, p, m);
 207:	8b 45 f0             	mov    -0x10(%ebp),%eax
 20a:	89 74 24 04          	mov    %esi,0x4(%esp)
 20e:	c7 04 24 00 0a 00 00 	movl   $0xa00,(%esp)
 215:	89 44 24 08          	mov    %eax,0x8(%esp)
 219:	e8 22 02 00 00       	call   440 <memmove>
 21e:	e9 3d ff ff ff       	jmp    160 <grep+0x10>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
 223:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 22a:	e9 31 ff ff ff       	jmp    160 <grep+0x10>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 22f:	83 c4 1c             	add    $0x1c,%esp
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5f                   	pop    %edi
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000240 <main>:

int
main(int argc, char *argv[])
{
 240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 244:	83 e4 f0             	and    $0xfffffff0,%esp
 247:	ff 71 fc             	pushl  -0x4(%ecx)
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	57                   	push   %edi
 24e:	56                   	push   %esi
 24f:	53                   	push   %ebx
 250:	51                   	push   %ecx
 251:	83 ec 18             	sub    $0x18,%esp
 254:	8b 01                	mov    (%ecx),%eax
 256:	89 45 e8             	mov    %eax,-0x18(%ebp)
 259:	8b 41 04             	mov    0x4(%ecx),%eax
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 25c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
 260:	0f 8e 8d 00 00 00    	jle    2f3 <main+0xb3>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 266:	8b 50 04             	mov    0x4(%eax),%edx
  
  if(argc <= 2){
    grep(pattern, 0);
    exit();
 269:	8d 70 08             	lea    0x8(%eax),%esi
 26c:	bf 02 00 00 00       	mov    $0x2,%edi
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
 271:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 275:	89 55 ec             	mov    %edx,-0x14(%ebp)
  
  if(argc <= 2){
 278:	75 28                	jne    2a2 <main+0x62>
 27a:	eb 62                	jmp    2de <main+0x9e>
 27c:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 280:	89 44 24 04          	mov    %eax,0x4(%esp)
 284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 287:	83 c7 01             	add    $0x1,%edi
 28a:	83 c6 04             	add    $0x4,%esi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 bb fe ff ff       	call   150 <grep>
    close(fd);
 295:	89 1c 24             	mov    %ebx,(%esp)
 298:	e8 b3 02 00 00       	call   550 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 29d:	3b 7d e8             	cmp    -0x18(%ebp),%edi
 2a0:	74 37                	je     2d9 <main+0x99>
    if((fd = open(argv[i], 0)) < 0){
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	8b 06                	mov    (%esi),%eax
 2ac:	89 04 24             	mov    %eax,(%esp)
 2af:	e8 b4 02 00 00       	call   568 <open>
 2b4:	85 c0                	test   %eax,%eax
 2b6:	89 c3                	mov    %eax,%ebx
 2b8:	79 c6                	jns    280 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
 2ba:	8b 06                	mov    (%esi),%eax
 2bc:	c7 44 24 04 98 09 00 	movl   $0x998,0x4(%esp)
 2c3:	00 
 2c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2cb:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cf:	e8 dc 03 00 00       	call   6b0 <printf>
      exit();
 2d4:	e8 4f 02 00 00       	call   528 <exit>
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 2d9:	e8 4a 02 00 00       	call   528 <exit>
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
    grep(pattern, 0);
 2de:	89 14 24             	mov    %edx,(%esp)
 2e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e8:	00 
 2e9:	e8 62 fe ff ff       	call   150 <grep>
    exit();
 2ee:	e8 35 02 00 00       	call   528 <exit>
{
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
 2f3:	c7 44 24 04 78 09 00 	movl   $0x978,0x4(%esp)
 2fa:	00 
 2fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 302:	e8 a9 03 00 00       	call   6b0 <printf>
    exit();
 307:	e8 1c 02 00 00       	call   528 <exit>
 30c:	90                   	nop    
 30d:	90                   	nop    
 30e:	90                   	nop    
 30f:	90                   	nop    

00000310 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 5d 08             	mov    0x8(%ebp),%ebx
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 31a:	89 da                	mov    %ebx,%edx
 31c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 320:	0f b6 01             	movzbl (%ecx),%eax
 323:	83 c1 01             	add    $0x1,%ecx
 326:	88 02                	mov    %al,(%edx)
 328:	83 c2 01             	add    $0x1,%edx
 32b:	84 c0                	test   %al,%al
 32d:	75 f1                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 32f:	89 d8                	mov    %ebx,%eax
 331:	5b                   	pop    %ebx
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 4d 08             	mov    0x8(%ebp),%ecx
 346:	53                   	push   %ebx
 347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 34a:	0f b6 01             	movzbl (%ecx),%eax
 34d:	84 c0                	test   %al,%al
 34f:	74 24                	je     375 <strcmp+0x35>
 351:	0f b6 13             	movzbl (%ebx),%edx
 354:	38 d0                	cmp    %dl,%al
 356:	74 12                	je     36a <strcmp+0x2a>
 358:	eb 1e                	jmp    378 <strcmp+0x38>
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 360:	0f b6 13             	movzbl (%ebx),%edx
 363:	83 c1 01             	add    $0x1,%ecx
 366:	38 d0                	cmp    %dl,%al
 368:	75 0e                	jne    378 <strcmp+0x38>
 36a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 36e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 371:	84 c0                	test   %al,%al
 373:	75 eb                	jne    360 <strcmp+0x20>
 375:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 378:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 379:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 37c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 37d:	0f b6 d2             	movzbl %dl,%edx
 380:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 382:	c3                   	ret    
 383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000390 <strlen>:

uint
strlen(char *s)
{
 390:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 391:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 393:	89 e5                	mov    %esp,%ebp
 395:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 398:	80 39 00             	cmpb   $0x0,(%ecx)
 39b:	74 0e                	je     3ab <strlen+0x1b>
 39d:	31 d2                	xor    %edx,%edx
 39f:	90                   	nop    
 3a0:	83 c2 01             	add    $0x1,%edx
 3a3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	75 f5                	jne    3a0 <strlen+0x10>
    ;
  return n;
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi

000003b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 45 10             	mov    0x10(%ebp),%eax
 3b6:	53                   	push   %ebx
 3b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 3ba:	85 c0                	test   %eax,%eax
 3bc:	74 10                	je     3ce <memset+0x1e>
 3be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 3c2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 3c4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 3c7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 3ca:	39 c2                	cmp    %eax,%edx
 3cc:	75 f6                	jne    3c4 <memset+0x14>
    *d++ = c;
  return dst;
}
 3ce:	89 d8                	mov    %ebx,%eax
 3d0:	5b                   	pop    %ebx
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret    
 3d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000003e0 <strchr>:

char*
strchr(const char *s, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3ea:	0f b6 10             	movzbl (%eax),%edx
 3ed:	84 d2                	test   %dl,%dl
 3ef:	75 0c                	jne    3fd <strchr+0x1d>
 3f1:	eb 11                	jmp    404 <strchr+0x24>
 3f3:	83 c0 01             	add    $0x1,%eax
 3f6:	0f b6 10             	movzbl (%eax),%edx
 3f9:	84 d2                	test   %dl,%dl
 3fb:	74 07                	je     404 <strchr+0x24>
    if(*s == c)
 3fd:	38 ca                	cmp    %cl,%dl
 3ff:	90                   	nop    
 400:	75 f1                	jne    3f3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    
 404:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 405:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 407:	c3                   	ret    
 408:	90                   	nop    
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000410 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 4d 08             	mov    0x8(%ebp),%ecx
 416:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 417:	31 db                	xor    %ebx,%ebx
 419:	0f b6 11             	movzbl (%ecx),%edx
 41c:	8d 42 d0             	lea    -0x30(%edx),%eax
 41f:	3c 09                	cmp    $0x9,%al
 421:	77 18                	ja     43b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 423:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 426:	0f be d2             	movsbl %dl,%edx
 429:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 431:	83 c1 01             	add    $0x1,%ecx
 434:	8d 42 d0             	lea    -0x30(%edx),%eax
 437:	3c 09                	cmp    $0x9,%al
 439:	76 e8                	jbe    423 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 43b:	89 d8                	mov    %ebx,%eax
 43d:	5b                   	pop    %ebx
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    

00000440 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 4d 10             	mov    0x10(%ebp),%ecx
 446:	56                   	push   %esi
 447:	8b 75 08             	mov    0x8(%ebp),%esi
 44a:	53                   	push   %ebx
 44b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 44e:	85 c9                	test   %ecx,%ecx
 450:	7e 10                	jle    462 <memmove+0x22>
 452:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 454:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 458:	88 04 32             	mov    %al,(%edx,%esi,1)
 45b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45e:	39 ca                	cmp    %ecx,%edx
 460:	75 f2                	jne    454 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 462:	89 f0                	mov    %esi,%eax
 464:	5b                   	pop    %ebx
 465:	5e                   	pop    %esi
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
 468:	90                   	nop    
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000470 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 476:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 479:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 47c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 47f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 484:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 48b:	00 
 48c:	89 04 24             	mov    %eax,(%esp)
 48f:	e8 d4 00 00 00       	call   568 <open>
  if(fd < 0)
 494:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 496:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 498:	78 19                	js     4b3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	89 1c 24             	mov    %ebx,(%esp)
 4a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a4:	e8 d7 00 00 00       	call   580 <fstat>
  close(fd);
 4a9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 4ac:	89 c6                	mov    %eax,%esi
  close(fd);
 4ae:	e8 9d 00 00 00       	call   550 <close>
  return r;
}
 4b3:	89 f0                	mov    %esi,%eax
 4b5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 4b8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 4bb:	89 ec                	mov    %ebp,%esp
 4bd:	5d                   	pop    %ebp
 4be:	c3                   	ret    
 4bf:	90                   	nop    

000004c0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	31 f6                	xor    %esi,%esi
 4c7:	53                   	push   %ebx
 4c8:	83 ec 1c             	sub    $0x1c,%esp
 4cb:	8b 7d 08             	mov    0x8(%ebp),%edi
 4ce:	eb 06                	jmp    4d6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4d0:	3c 0d                	cmp    $0xd,%al
 4d2:	74 39                	je     50d <gets+0x4d>
 4d4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d6:	8d 5e 01             	lea    0x1(%esi),%ebx
 4d9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4dc:	7d 31                	jge    50f <gets+0x4f>
    cc = read(0, &c, 1);
 4de:	8d 45 f3             	lea    -0xd(%ebp),%eax
 4e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e8:	00 
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f4:	e8 47 00 00 00       	call   540 <read>
    if(cc < 1)
 4f9:	85 c0                	test   %eax,%eax
 4fb:	7e 12                	jle    50f <gets+0x4f>
      break;
    buf[i++] = c;
 4fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 501:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 509:	3c 0a                	cmp    $0xa,%al
 50b:	75 c3                	jne    4d0 <gets+0x10>
 50d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 50f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 513:	89 f8                	mov    %edi,%eax
 515:	83 c4 1c             	add    $0x1c,%esp
 518:	5b                   	pop    %ebx
 519:	5e                   	pop    %esi
 51a:	5f                   	pop    %edi
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    
 51d:	90                   	nop    
 51e:	90                   	nop    
 51f:	90                   	nop    

00000520 <fork>:
 520:	b8 01 00 00 00       	mov    $0x1,%eax
 525:	cd 30                	int    $0x30
 527:	c3                   	ret    

00000528 <exit>:
 528:	b8 02 00 00 00       	mov    $0x2,%eax
 52d:	cd 30                	int    $0x30
 52f:	c3                   	ret    

00000530 <wait>:
 530:	b8 03 00 00 00       	mov    $0x3,%eax
 535:	cd 30                	int    $0x30
 537:	c3                   	ret    

00000538 <pipe>:
 538:	b8 04 00 00 00       	mov    $0x4,%eax
 53d:	cd 30                	int    $0x30
 53f:	c3                   	ret    

00000540 <read>:
 540:	b8 06 00 00 00       	mov    $0x6,%eax
 545:	cd 30                	int    $0x30
 547:	c3                   	ret    

00000548 <write>:
 548:	b8 05 00 00 00       	mov    $0x5,%eax
 54d:	cd 30                	int    $0x30
 54f:	c3                   	ret    

00000550 <close>:
 550:	b8 07 00 00 00       	mov    $0x7,%eax
 555:	cd 30                	int    $0x30
 557:	c3                   	ret    

00000558 <kill>:
 558:	b8 08 00 00 00       	mov    $0x8,%eax
 55d:	cd 30                	int    $0x30
 55f:	c3                   	ret    

00000560 <exec>:
 560:	b8 09 00 00 00       	mov    $0x9,%eax
 565:	cd 30                	int    $0x30
 567:	c3                   	ret    

00000568 <open>:
 568:	b8 0a 00 00 00       	mov    $0xa,%eax
 56d:	cd 30                	int    $0x30
 56f:	c3                   	ret    

00000570 <mknod>:
 570:	b8 0b 00 00 00       	mov    $0xb,%eax
 575:	cd 30                	int    $0x30
 577:	c3                   	ret    

00000578 <unlink>:
 578:	b8 0c 00 00 00       	mov    $0xc,%eax
 57d:	cd 30                	int    $0x30
 57f:	c3                   	ret    

00000580 <fstat>:
 580:	b8 0d 00 00 00       	mov    $0xd,%eax
 585:	cd 30                	int    $0x30
 587:	c3                   	ret    

00000588 <link>:
 588:	b8 0e 00 00 00       	mov    $0xe,%eax
 58d:	cd 30                	int    $0x30
 58f:	c3                   	ret    

00000590 <mkdir>:
 590:	b8 0f 00 00 00       	mov    $0xf,%eax
 595:	cd 30                	int    $0x30
 597:	c3                   	ret    

00000598 <chdir>:
 598:	b8 10 00 00 00       	mov    $0x10,%eax
 59d:	cd 30                	int    $0x30
 59f:	c3                   	ret    

000005a0 <dup>:
 5a0:	b8 11 00 00 00       	mov    $0x11,%eax
 5a5:	cd 30                	int    $0x30
 5a7:	c3                   	ret    

000005a8 <getpid>:
 5a8:	b8 12 00 00 00       	mov    $0x12,%eax
 5ad:	cd 30                	int    $0x30
 5af:	c3                   	ret    

000005b0 <sbrk>:
 5b0:	b8 13 00 00 00       	mov    $0x13,%eax
 5b5:	cd 30                	int    $0x30
 5b7:	c3                   	ret    

000005b8 <sleep>:
 5b8:	b8 14 00 00 00       	mov    $0x14,%eax
 5bd:	cd 30                	int    $0x30
 5bf:	c3                   	ret    

000005c0 <tick>:
 5c0:	b8 15 00 00 00       	mov    $0x15,%eax
 5c5:	cd 30                	int    $0x30
 5c7:	c3                   	ret    

000005c8 <fork_tickets>:
 5c8:	b8 16 00 00 00       	mov    $0x16,%eax
 5cd:	cd 30                	int    $0x30
 5cf:	c3                   	ret    

000005d0 <fork_thread>:
 5d0:	b8 17 00 00 00       	mov    $0x17,%eax
 5d5:	cd 30                	int    $0x30
 5d7:	c3                   	ret    

000005d8 <wait_thread>:
 5d8:	b8 18 00 00 00       	mov    $0x18,%eax
 5dd:	cd 30                	int    $0x30
 5df:	c3                   	ret    

000005e0 <sleep_cond>:
 5e0:	b8 19 00 00 00       	mov    $0x19,%eax
 5e5:	cd 30                	int    $0x30
 5e7:	c3                   	ret    

000005e8 <wake_cond>:
 5e8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5ed:	cd 30                	int    $0x30
 5ef:	c3                   	ret    

000005f0 <xchng>:
 5f0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5f5:	cd 30                	int    $0x30
 5f7:	c3                   	ret    

000005f8 <check>:
 5f8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5fd:	cd 30                	int    $0x30
 5ff:	c3                   	ret    

00000600 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	83 ec 18             	sub    $0x18,%esp
 606:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 609:	8d 55 fc             	lea    -0x4(%ebp),%edx
 60c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 613:	00 
 614:	89 54 24 04          	mov    %edx,0x4(%esp)
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 28 ff ff ff       	call   548 <write>
}
 620:	c9                   	leave  
 621:	c3                   	ret    
 622:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 629:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000630 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	89 ce                	mov    %ecx,%esi
 637:	53                   	push   %ebx
 638:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 63e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 641:	85 c9                	test   %ecx,%ecx
 643:	74 04                	je     649 <printint+0x19>
 645:	85 d2                	test   %edx,%edx
 647:	78 54                	js     69d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 649:	89 d0                	mov    %edx,%eax
 64b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 652:	31 db                	xor    %ebx,%ebx
 654:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 657:	31 d2                	xor    %edx,%edx
 659:	f7 f6                	div    %esi
 65b:	89 c1                	mov    %eax,%ecx
 65d:	0f b6 82 b5 09 00 00 	movzbl 0x9b5(%edx),%eax
 664:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 667:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 66a:	85 c9                	test   %ecx,%ecx
 66c:	89 c8                	mov    %ecx,%eax
 66e:	75 e7                	jne    657 <printint+0x27>
  if(neg)
 670:	8b 45 e0             	mov    -0x20(%ebp),%eax
 673:	85 c0                	test   %eax,%eax
 675:	74 08                	je     67f <printint+0x4f>
    buf[i++] = '-';
 677:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 67c:	83 c3 01             	add    $0x1,%ebx
 67f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 682:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 686:	83 eb 01             	sub    $0x1,%ebx
 689:	8b 45 dc             	mov    -0x24(%ebp),%eax
 68c:	e8 6f ff ff ff       	call   600 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 691:	39 fb                	cmp    %edi,%ebx
 693:	75 ed                	jne    682 <printint+0x52>
    putc(fd, buf[i]);
}
 695:	83 c4 1c             	add    $0x1c,%esp
 698:	5b                   	pop    %ebx
 699:	5e                   	pop    %esi
 69a:	5f                   	pop    %edi
 69b:	5d                   	pop    %ebp
 69c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 69d:	89 d0                	mov    %edx,%eax
 69f:	f7 d8                	neg    %eax
 6a1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 6a8:	eb a8                	jmp    652 <printint+0x22>
 6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bc:	0f b6 02             	movzbl (%edx),%eax
 6bf:	84 c0                	test   %al,%al
 6c1:	0f 84 84 00 00 00    	je     74b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 6c7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6ca:	89 d7                	mov    %edx,%edi
 6cc:	31 f6                	xor    %esi,%esi
 6ce:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 6d1:	eb 18                	jmp    6eb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6d3:	83 fb 25             	cmp    $0x25,%ebx
 6d6:	75 7b                	jne    753 <printf+0xa3>
 6d8:	66 be 25 00          	mov    $0x25,%si
 6dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 6e4:	83 c7 01             	add    $0x1,%edi
 6e7:	84 c0                	test   %al,%al
 6e9:	74 60                	je     74b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 6eb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 6ed:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 6f0:	74 e1                	je     6d3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6f2:	83 fe 25             	cmp    $0x25,%esi
 6f5:	75 e9                	jne    6e0 <printf+0x30>
      if(c == 'd'){
 6f7:	83 fb 64             	cmp    $0x64,%ebx
 6fa:	0f 84 db 00 00 00    	je     7db <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 700:	83 fb 78             	cmp    $0x78,%ebx
 703:	74 5b                	je     760 <printf+0xb0>
 705:	83 fb 70             	cmp    $0x70,%ebx
 708:	74 56                	je     760 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 70a:	83 fb 73             	cmp    $0x73,%ebx
 70d:	8d 76 00             	lea    0x0(%esi),%esi
 710:	74 72                	je     784 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 712:	83 fb 63             	cmp    $0x63,%ebx
 715:	0f 84 a7 00 00 00    	je     7c2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 71b:	83 fb 25             	cmp    $0x25,%ebx
 71e:	66 90                	xchg   %ax,%ax
 720:	0f 84 da 00 00 00    	je     800 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 72e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 730:	e8 cb fe ff ff       	call   600 <putc>
        putc(fd, c);
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	0f be d3             	movsbl %bl,%edx
 73b:	e8 c0 fe ff ff       	call   600 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 740:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 744:	83 c7 01             	add    $0x1,%edi
 747:	84 c0                	test   %al,%al
 749:	75 a0                	jne    6eb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74b:	83 c4 0c             	add    $0xc,%esp
 74e:	5b                   	pop    %ebx
 74f:	5e                   	pop    %esi
 750:	5f                   	pop    %edi
 751:	5d                   	pop    %ebp
 752:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	0f be d3             	movsbl %bl,%edx
 759:	e8 a2 fe ff ff       	call   600 <putc>
 75e:	eb 80                	jmp    6e0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 768:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 76a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	e8 b5 fe ff ff       	call   630 <printint>
        ap++;
 77b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 77f:	e9 5c ff ff ff       	jmp    6e0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 784:	8b 55 f0             	mov    -0x10(%ebp),%edx
 787:	8b 02                	mov    (%edx),%eax
        ap++;
 789:	83 c2 04             	add    $0x4,%edx
 78c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 78f:	ba ae 09 00 00       	mov    $0x9ae,%edx
 794:	85 c0                	test   %eax,%eax
 796:	75 26                	jne    7be <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 798:	0f b6 02             	movzbl (%edx),%eax
 79b:	84 c0                	test   %al,%al
 79d:	74 18                	je     7b7 <printf+0x107>
 79f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 7a1:	0f be d0             	movsbl %al,%edx
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	e8 54 fe ff ff       	call   600 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ac:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 7b0:	83 c3 01             	add    $0x1,%ebx
 7b3:	84 c0                	test   %al,%al
 7b5:	75 ea                	jne    7a1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7b7:	31 f6                	xor    %esi,%esi
 7b9:	e9 22 ff ff ff       	jmp    6e0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 7be:	89 c2                	mov    %eax,%edx
 7c0:	eb d6                	jmp    798 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 7c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 7c5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	0f be 11             	movsbl (%ecx),%edx
 7cd:	e8 2e fe ff ff       	call   600 <putc>
        ap++;
 7d2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 7d6:	e9 05 ff ff ff       	jmp    6e0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 7e3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	e8 39 fe ff ff       	call   630 <printint>
        ap++;
 7f7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 7fb:	e9 e0 fe ff ff       	jmp    6e0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	ba 25 00 00 00       	mov    $0x25,%edx
 808:	31 f6                	xor    %esi,%esi
 80a:	e8 f1 fd ff ff       	call   600 <putc>
 80f:	e9 cc fe ff ff       	jmp    6e0 <printf+0x30>
 814:	90                   	nop    
 815:	90                   	nop    
 816:	90                   	nop    
 817:	90                   	nop    
 818:	90                   	nop    
 819:	90                   	nop    
 81a:	90                   	nop    
 81b:	90                   	nop    
 81c:	90                   	nop    
 81d:	90                   	nop    
 81e:	90                   	nop    
 81f:	90                   	nop    

00000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8b 0d e8 09 00 00    	mov    0x9e8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 827:	89 e5                	mov    %esp,%ebp
 829:	56                   	push   %esi
 82a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 82b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 82e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	39 d9                	cmp    %ebx,%ecx
 833:	73 18                	jae    84d <free+0x2d>
 835:	8b 11                	mov    (%ecx),%edx
 837:	39 d3                	cmp    %edx,%ebx
 839:	72 17                	jb     852 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83b:	39 d1                	cmp    %edx,%ecx
 83d:	72 08                	jb     847 <free+0x27>
 83f:	39 d9                	cmp    %ebx,%ecx
 841:	72 0f                	jb     852 <free+0x32>
 843:	39 d3                	cmp    %edx,%ebx
 845:	72 0b                	jb     852 <free+0x32>
 847:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 849:	39 d9                	cmp    %ebx,%ecx
 84b:	72 e8                	jb     835 <free+0x15>
 84d:	8b 11                	mov    (%ecx),%edx
 84f:	90                   	nop    
 850:	eb e9                	jmp    83b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 852:	8b 73 04             	mov    0x4(%ebx),%esi
 855:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 858:	39 d0                	cmp    %edx,%eax
 85a:	74 18                	je     874 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 85c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 85e:	8b 51 04             	mov    0x4(%ecx),%edx
 861:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 864:	39 d8                	cmp    %ebx,%eax
 866:	74 20                	je     888 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 868:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 86a:	5b                   	pop    %ebx
 86b:	5e                   	pop    %esi
 86c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 86d:	89 0d e8 09 00 00    	mov    %ecx,0x9e8
}
 873:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 874:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 877:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 879:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 87c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 87f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 881:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 884:	39 d8                	cmp    %ebx,%eax
 886:	75 e0                	jne    868 <free+0x48>
    p->s.size += bp->s.size;
 888:	03 53 04             	add    0x4(%ebx),%edx
 88b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 88e:	8b 13                	mov    (%ebx),%edx
 890:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 892:	5b                   	pop    %ebx
 893:	5e                   	pop    %esi
 894:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 895:	89 0d e8 09 00 00    	mov    %ecx,0x9e8
}
 89b:	c3                   	ret    
 89c:	8d 74 26 00          	lea    0x0(%esi),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 e8 09 00 00    	mov    0x9e8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	83 c0 07             	add    $0x7,%eax
 8b5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 8b8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 8bd:	0f 84 8a 00 00 00    	je     94d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 8c5:	8b 41 04             	mov    0x4(%ecx),%eax
 8c8:	39 c3                	cmp    %eax,%ebx
 8ca:	76 1a                	jbe    8e6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 8cc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 8d3:	3b 0d e8 09 00 00    	cmp    0x9e8,%ecx
 8d9:	89 ca                	mov    %ecx,%edx
 8db:	74 29                	je     906 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 8df:	8b 41 04             	mov    0x4(%ecx),%eax
 8e2:	39 c3                	cmp    %eax,%ebx
 8e4:	77 ed                	ja     8d3 <malloc+0x33>
      if(p->s.size == nunits)
 8e6:	39 c3                	cmp    %eax,%ebx
 8e8:	74 5d                	je     947 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8ea:	29 d8                	sub    %ebx,%eax
 8ec:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 8ef:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 8f2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 8f5:	89 15 e8 09 00 00    	mov    %edx,0x9e8
      return (void*) (p + 1);
 8fb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fe:	83 c4 0c             	add    $0xc,%esp
 901:	5b                   	pop    %ebx
 902:	5e                   	pop    %esi
 903:	5f                   	pop    %edi
 904:	5d                   	pop    %ebp
 905:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 906:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 90c:	89 de                	mov    %ebx,%esi
 90e:	89 f8                	mov    %edi,%eax
 910:	76 29                	jbe    93b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 912:	89 04 24             	mov    %eax,(%esp)
 915:	e8 96 fc ff ff       	call   5b0 <sbrk>
  if(p == (char*) -1)
 91a:	83 f8 ff             	cmp    $0xffffffff,%eax
 91d:	74 18                	je     937 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 91f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 922:	83 c0 08             	add    $0x8,%eax
 925:	89 04 24             	mov    %eax,(%esp)
 928:	e8 f3 fe ff ff       	call   820 <free>
  return freep;
 92d:	8b 15 e8 09 00 00    	mov    0x9e8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 933:	85 d2                	test   %edx,%edx
 935:	75 a6                	jne    8dd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 937:	31 c0                	xor    %eax,%eax
 939:	eb c3                	jmp    8fe <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 93b:	be 00 10 00 00       	mov    $0x1000,%esi
 940:	b8 00 80 00 00       	mov    $0x8000,%eax
 945:	eb cb                	jmp    912 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 947:	8b 01                	mov    (%ecx),%eax
 949:	89 02                	mov    %eax,(%edx)
 94b:	eb a8                	jmp    8f5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 94d:	ba e0 09 00 00       	mov    $0x9e0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 952:	c7 05 e8 09 00 00 e0 	movl   $0x9e0,0x9e8
 959:	09 00 00 
 95c:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 963:	09 00 00 
    base.s.size = 0;
 966:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 96d:	00 00 00 
 970:	e9 4e ff ff ff       	jmp    8c3 <malloc+0x23>
