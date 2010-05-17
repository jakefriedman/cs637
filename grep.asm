
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
 16f:	05 c0 09 00 00       	add    $0x9c0,%eax
 174:	89 44 24 04          	mov    %eax,0x4(%esp)
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	89 04 24             	mov    %eax,(%esp)
 17e:	e8 bd 03 00 00       	call   540 <read>
 183:	85 c0                	test   %eax,%eax
 185:	89 c7                	mov    %eax,%edi
 187:	0f 8e a2 00 00 00    	jle    22f <grep+0xdf>
 18d:	be c0 09 00 00       	mov    $0x9c0,%esi
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
 1e7:	81 fe c0 09 00 00    	cmp    $0x9c0,%esi
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
 1ff:	2d c0 09 00 00       	sub    $0x9c0,%eax
 204:	29 45 f0             	sub    %eax,-0x10(%ebp)
      memmove(buf, p, m);
 207:	8b 45 f0             	mov    -0x10(%ebp),%eax
 20a:	89 74 24 04          	mov    %esi,0x4(%esp)
 20e:	c7 04 24 c0 09 00 00 	movl   $0x9c0,(%esp)
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
 2bc:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
 2c3:	00 
 2c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2cb:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cf:	e8 ac 03 00 00       	call   680 <printf>
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
 2f3:	c7 44 24 04 48 09 00 	movl   $0x948,0x4(%esp)
 2fa:	00 
 2fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 302:	e8 79 03 00 00       	call   680 <printf>
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

000005c0 <kalloctest>:
 5c0:	b8 15 00 00 00       	mov    $0x15,%eax
 5c5:	cd 30                	int    $0x30
 5c7:	c3                   	ret    
 5c8:	90                   	nop    
 5c9:	90                   	nop    
 5ca:	90                   	nop    
 5cb:	90                   	nop    
 5cc:	90                   	nop    
 5cd:	90                   	nop    
 5ce:	90                   	nop    
 5cf:	90                   	nop    

000005d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	83 ec 18             	sub    $0x18,%esp
 5d6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 5d9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 5dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e3:	00 
 5e4:	89 54 24 04          	mov    %edx,0x4(%esp)
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 58 ff ff ff       	call   548 <write>
}
 5f0:	c9                   	leave  
 5f1:	c3                   	ret    
 5f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000600 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	89 ce                	mov    %ecx,%esi
 607:	53                   	push   %ebx
 608:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 60e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 611:	85 c9                	test   %ecx,%ecx
 613:	74 04                	je     619 <printint+0x19>
 615:	85 d2                	test   %edx,%edx
 617:	78 54                	js     66d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 619:	89 d0                	mov    %edx,%eax
 61b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 622:	31 db                	xor    %ebx,%ebx
 624:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 627:	31 d2                	xor    %edx,%edx
 629:	f7 f6                	div    %esi
 62b:	89 c1                	mov    %eax,%ecx
 62d:	0f b6 82 85 09 00 00 	movzbl 0x985(%edx),%eax
 634:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 637:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 63a:	85 c9                	test   %ecx,%ecx
 63c:	89 c8                	mov    %ecx,%eax
 63e:	75 e7                	jne    627 <printint+0x27>
  if(neg)
 640:	8b 45 e0             	mov    -0x20(%ebp),%eax
 643:	85 c0                	test   %eax,%eax
 645:	74 08                	je     64f <printint+0x4f>
    buf[i++] = '-';
 647:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 64c:	83 c3 01             	add    $0x1,%ebx
 64f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 652:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 656:	83 eb 01             	sub    $0x1,%ebx
 659:	8b 45 dc             	mov    -0x24(%ebp),%eax
 65c:	e8 6f ff ff ff       	call   5d0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 661:	39 fb                	cmp    %edi,%ebx
 663:	75 ed                	jne    652 <printint+0x52>
    putc(fd, buf[i]);
}
 665:	83 c4 1c             	add    $0x1c,%esp
 668:	5b                   	pop    %ebx
 669:	5e                   	pop    %esi
 66a:	5f                   	pop    %edi
 66b:	5d                   	pop    %ebp
 66c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 66d:	89 d0                	mov    %edx,%eax
 66f:	f7 d8                	neg    %eax
 671:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 678:	eb a8                	jmp    622 <printint+0x22>
 67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000680 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 689:	8b 55 0c             	mov    0xc(%ebp),%edx
 68c:	0f b6 02             	movzbl (%edx),%eax
 68f:	84 c0                	test   %al,%al
 691:	0f 84 84 00 00 00    	je     71b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 697:	8d 4d 10             	lea    0x10(%ebp),%ecx
 69a:	89 d7                	mov    %edx,%edi
 69c:	31 f6                	xor    %esi,%esi
 69e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 6a1:	eb 18                	jmp    6bb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6a3:	83 fb 25             	cmp    $0x25,%ebx
 6a6:	75 7b                	jne    723 <printf+0xa3>
 6a8:	66 be 25 00          	mov    $0x25,%si
 6ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 6b4:	83 c7 01             	add    $0x1,%edi
 6b7:	84 c0                	test   %al,%al
 6b9:	74 60                	je     71b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 6bb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 6bd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 6c0:	74 e1                	je     6a3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6c2:	83 fe 25             	cmp    $0x25,%esi
 6c5:	75 e9                	jne    6b0 <printf+0x30>
      if(c == 'd'){
 6c7:	83 fb 64             	cmp    $0x64,%ebx
 6ca:	0f 84 db 00 00 00    	je     7ab <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6d0:	83 fb 78             	cmp    $0x78,%ebx
 6d3:	74 5b                	je     730 <printf+0xb0>
 6d5:	83 fb 70             	cmp    $0x70,%ebx
 6d8:	74 56                	je     730 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6da:	83 fb 73             	cmp    $0x73,%ebx
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
 6e0:	74 72                	je     754 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e2:	83 fb 63             	cmp    $0x63,%ebx
 6e5:	0f 84 a7 00 00 00    	je     792 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6eb:	83 fb 25             	cmp    $0x25,%ebx
 6ee:	66 90                	xchg   %ax,%ax
 6f0:	0f 84 da 00 00 00    	je     7d0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 6fe:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 700:	e8 cb fe ff ff       	call   5d0 <putc>
        putc(fd, c);
 705:	8b 45 08             	mov    0x8(%ebp),%eax
 708:	0f be d3             	movsbl %bl,%edx
 70b:	e8 c0 fe ff ff       	call   5d0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 710:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 714:	83 c7 01             	add    $0x1,%edi
 717:	84 c0                	test   %al,%al
 719:	75 a0                	jne    6bb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 71b:	83 c4 0c             	add    $0xc,%esp
 71e:	5b                   	pop    %ebx
 71f:	5e                   	pop    %esi
 720:	5f                   	pop    %edi
 721:	5d                   	pop    %ebp
 722:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	0f be d3             	movsbl %bl,%edx
 729:	e8 a2 fe ff ff       	call   5d0 <putc>
 72e:	eb 80                	jmp    6b0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 738:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 73a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	e8 b5 fe ff ff       	call   600 <printint>
        ap++;
 74b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 74f:	e9 5c ff ff ff       	jmp    6b0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 754:	8b 55 f0             	mov    -0x10(%ebp),%edx
 757:	8b 02                	mov    (%edx),%eax
        ap++;
 759:	83 c2 04             	add    $0x4,%edx
 75c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 75f:	ba 7e 09 00 00       	mov    $0x97e,%edx
 764:	85 c0                	test   %eax,%eax
 766:	75 26                	jne    78e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 768:	0f b6 02             	movzbl (%edx),%eax
 76b:	84 c0                	test   %al,%al
 76d:	74 18                	je     787 <printf+0x107>
 76f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 771:	0f be d0             	movsbl %al,%edx
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	e8 54 fe ff ff       	call   5d0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 77c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 780:	83 c3 01             	add    $0x1,%ebx
 783:	84 c0                	test   %al,%al
 785:	75 ea                	jne    771 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 787:	31 f6                	xor    %esi,%esi
 789:	e9 22 ff ff ff       	jmp    6b0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 78e:	89 c2                	mov    %eax,%edx
 790:	eb d6                	jmp    768 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 795:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	0f be 11             	movsbl (%ecx),%edx
 79d:	e8 2e fe ff ff       	call   5d0 <putc>
        ap++;
 7a2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 7a6:	e9 05 ff ff ff       	jmp    6b0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 7b3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7bd:	8b 10                	mov    (%eax),%edx
 7bf:	8b 45 08             	mov    0x8(%ebp),%eax
 7c2:	e8 39 fe ff ff       	call   600 <printint>
        ap++;
 7c7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 7cb:	e9 e0 fe ff ff       	jmp    6b0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	ba 25 00 00 00       	mov    $0x25,%edx
 7d8:	31 f6                	xor    %esi,%esi
 7da:	e8 f1 fd ff ff       	call   5d0 <putc>
 7df:	e9 cc fe ff ff       	jmp    6b0 <printf+0x30>
 7e4:	90                   	nop    
 7e5:	90                   	nop    
 7e6:	90                   	nop    
 7e7:	90                   	nop    
 7e8:	90                   	nop    
 7e9:	90                   	nop    
 7ea:	90                   	nop    
 7eb:	90                   	nop    
 7ec:	90                   	nop    
 7ed:	90                   	nop    
 7ee:	90                   	nop    
 7ef:	90                   	nop    

000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8b 0d a8 09 00 00    	mov    0x9a8,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f7:	89 e5                	mov    %esp,%ebp
 7f9:	56                   	push   %esi
 7fa:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 7fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7fe:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	39 d9                	cmp    %ebx,%ecx
 803:	73 18                	jae    81d <free+0x2d>
 805:	8b 11                	mov    (%ecx),%edx
 807:	39 d3                	cmp    %edx,%ebx
 809:	72 17                	jb     822 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80b:	39 d1                	cmp    %edx,%ecx
 80d:	72 08                	jb     817 <free+0x27>
 80f:	39 d9                	cmp    %ebx,%ecx
 811:	72 0f                	jb     822 <free+0x32>
 813:	39 d3                	cmp    %edx,%ebx
 815:	72 0b                	jb     822 <free+0x32>
 817:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 819:	39 d9                	cmp    %ebx,%ecx
 81b:	72 e8                	jb     805 <free+0x15>
 81d:	8b 11                	mov    (%ecx),%edx
 81f:	90                   	nop    
 820:	eb e9                	jmp    80b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 822:	8b 73 04             	mov    0x4(%ebx),%esi
 825:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 828:	39 d0                	cmp    %edx,%eax
 82a:	74 18                	je     844 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 82c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 82e:	8b 51 04             	mov    0x4(%ecx),%edx
 831:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 834:	39 d8                	cmp    %ebx,%eax
 836:	74 20                	je     858 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 838:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 83a:	5b                   	pop    %ebx
 83b:	5e                   	pop    %esi
 83c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 83d:	89 0d a8 09 00 00    	mov    %ecx,0x9a8
}
 843:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 844:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 847:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 849:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 84c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 84f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 851:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 854:	39 d8                	cmp    %ebx,%eax
 856:	75 e0                	jne    838 <free+0x48>
    p->s.size += bp->s.size;
 858:	03 53 04             	add    0x4(%ebx),%edx
 85b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 85e:	8b 13                	mov    (%ebx),%edx
 860:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 862:	5b                   	pop    %ebx
 863:	5e                   	pop    %esi
 864:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 865:	89 0d a8 09 00 00    	mov    %ecx,0x9a8
}
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 a8 09 00 00    	mov    0x9a8,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	83 c0 07             	add    $0x7,%eax
 885:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 888:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 88d:	0f 84 8a 00 00 00    	je     91d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 895:	8b 41 04             	mov    0x4(%ecx),%eax
 898:	39 c3                	cmp    %eax,%ebx
 89a:	76 1a                	jbe    8b6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 89c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 8a3:	3b 0d a8 09 00 00    	cmp    0x9a8,%ecx
 8a9:	89 ca                	mov    %ecx,%edx
 8ab:	74 29                	je     8d6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ad:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 8af:	8b 41 04             	mov    0x4(%ecx),%eax
 8b2:	39 c3                	cmp    %eax,%ebx
 8b4:	77 ed                	ja     8a3 <malloc+0x33>
      if(p->s.size == nunits)
 8b6:	39 c3                	cmp    %eax,%ebx
 8b8:	74 5d                	je     917 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8ba:	29 d8                	sub    %ebx,%eax
 8bc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 8bf:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 8c2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 8c5:	89 15 a8 09 00 00    	mov    %edx,0x9a8
      return (void*) (p + 1);
 8cb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ce:	83 c4 0c             	add    $0xc,%esp
 8d1:	5b                   	pop    %ebx
 8d2:	5e                   	pop    %esi
 8d3:	5f                   	pop    %edi
 8d4:	5d                   	pop    %ebp
 8d5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 8d6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 8dc:	89 de                	mov    %ebx,%esi
 8de:	89 f8                	mov    %edi,%eax
 8e0:	76 29                	jbe    90b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 c6 fc ff ff       	call   5b0 <sbrk>
  if(p == (char*) -1)
 8ea:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ed:	74 18                	je     907 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8ef:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8f2:	83 c0 08             	add    $0x8,%eax
 8f5:	89 04 24             	mov    %eax,(%esp)
 8f8:	e8 f3 fe ff ff       	call   7f0 <free>
  return freep;
 8fd:	8b 15 a8 09 00 00    	mov    0x9a8,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 903:	85 d2                	test   %edx,%edx
 905:	75 a6                	jne    8ad <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 907:	31 c0                	xor    %eax,%eax
 909:	eb c3                	jmp    8ce <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 90b:	be 00 10 00 00       	mov    $0x1000,%esi
 910:	b8 00 80 00 00       	mov    $0x8000,%eax
 915:	eb cb                	jmp    8e2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 917:	8b 01                	mov    (%ecx),%eax
 919:	89 02                	mov    %eax,(%edx)
 91b:	eb a8                	jmp    8c5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 91d:	ba a0 09 00 00       	mov    $0x9a0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 922:	c7 05 a8 09 00 00 a0 	movl   $0x9a0,0x9a8
 929:	09 00 00 
 92c:	c7 05 a0 09 00 00 a0 	movl   $0x9a0,0x9a0
 933:	09 00 00 
    base.s.size = 0;
 936:	c7 05 a4 09 00 00 00 	movl   $0x0,0x9a4
 93d:	00 00 00 
 940:	e9 4e ff ff ff       	jmp    893 <malloc+0x23>
