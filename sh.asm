
_sh:     file format elf32-i386

Disassembly of section .text:

00000000 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 04             	sub    $0x4,%esp
       7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	85 db                	test   %ebx,%ebx
       c:	74 05                	je     13 <nulterminate+0x13>
    return 0;
  
  switch(cmd->type){
       e:	83 3b 05             	cmpl   $0x5,(%ebx)
      11:	76 0d                	jbe    20 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      13:	89 d8                	mov    %ebx,%eax
      15:	83 c4 04             	add    $0x4,%esp
      18:	5b                   	pop    %ebx
      19:	5d                   	pop    %ebp
      1a:	c3                   	ret    
      1b:	90                   	nop    
      1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
      20:	8b 03                	mov    (%ebx),%eax
      22:	ff 24 85 88 12 00 00 	jmp    *0x1288(,%eax,4)
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      29:	8b 43 04             	mov    0x4(%ebx),%eax
      2c:	89 04 24             	mov    %eax,(%esp)
      2f:	e8 cc ff ff ff       	call   0 <nulterminate>
    nulterminate(lcmd->right);
      34:	8b 43 08             	mov    0x8(%ebx),%eax
      37:	89 04 24             	mov    %eax,(%esp)
      3a:	e8 c1 ff ff ff       	call   0 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      3f:	89 d8                	mov    %ebx,%eax
      41:	83 c4 04             	add    $0x4,%esp
      44:	5b                   	pop    %ebx
      45:	5d                   	pop    %ebp
      46:	c3                   	ret    
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      47:	8b 43 04             	mov    0x4(%ebx),%eax
      4a:	89 04 24             	mov    %eax,(%esp)
      4d:	e8 ae ff ff ff       	call   0 <nulterminate>
    break;
  }
  return cmd;
}
      52:	89 d8                	mov    %ebx,%eax
      54:	83 c4 04             	add    $0x4,%esp
      57:	5b                   	pop    %ebx
      58:	5d                   	pop    %ebp
      59:	c3                   	ret    
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      5a:	8b 43 04             	mov    0x4(%ebx),%eax
      5d:	89 04 24             	mov    %eax,(%esp)
      60:	e8 9b ff ff ff       	call   0 <nulterminate>
    *rcmd->efile = 0;
      65:	8b 43 0c             	mov    0xc(%ebx),%eax
      68:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      6b:	89 d8                	mov    %ebx,%eax
      6d:	83 c4 04             	add    $0x4,%esp
      70:	5b                   	pop    %ebx
      71:	5d                   	pop    %ebp
      72:	c3                   	ret    
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      73:	8b 43 04             	mov    0x4(%ebx),%eax
      76:	85 c0                	test   %eax,%eax
      78:	74 99                	je     13 <nulterminate+0x13>
      7a:	89 da                	mov    %ebx,%edx
      7c:	8d 74 26 00          	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
      80:	8b 42 2c             	mov    0x2c(%edx),%eax
      83:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      86:	8b 42 08             	mov    0x8(%edx),%eax
      89:	83 c2 04             	add    $0x4,%edx
      8c:	85 c0                	test   %eax,%eax
      8e:	75 f0                	jne    80 <nulterminate+0x80>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      90:	89 d8                	mov    %ebx,%eax
      92:	83 c4 04             	add    $0x4,%esp
      95:	5b                   	pop    %ebx
      96:	5d                   	pop    %ebp
      97:	c3                   	ret    
      98:	90                   	nop    
      99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000000a0 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
      a0:	55                   	push   %ebp
      a1:	89 e5                	mov    %esp,%ebp
      a3:	57                   	push   %edi
      a4:	56                   	push   %esi
      a5:	53                   	push   %ebx
      a6:	83 ec 0c             	sub    $0xc,%esp
      a9:	8b 7d 08             	mov    0x8(%ebp),%edi
      ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;
  
  s = *ps;
      af:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
      b1:	39 f3                	cmp    %esi,%ebx
      b3:	72 09                	jb     be <peek+0x1e>
      b5:	eb 1e                	jmp    d5 <peek+0x35>
    s++;
      b7:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
      ba:	39 f3                	cmp    %esi,%ebx
      bc:	74 17                	je     d5 <peek+0x35>
      be:	0f be 03             	movsbl (%ebx),%eax
      c1:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
      c8:	89 44 24 04          	mov    %eax,0x4(%esp)
      cc:	e8 1f 0c 00 00       	call   cf0 <strchr>
      d1:	85 c0                	test   %eax,%eax
      d3:	75 e2                	jne    b7 <peek+0x17>
    s++;
  *ps = s;
      d5:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
      d7:	0f b6 03             	movzbl (%ebx),%eax
      da:	31 d2                	xor    %edx,%edx
      dc:	84 c0                	test   %al,%al
      de:	74 19                	je     f9 <peek+0x59>
      e0:	0f be c0             	movsbl %al,%eax
      e3:	89 44 24 04          	mov    %eax,0x4(%esp)
      e7:	8b 45 10             	mov    0x10(%ebp),%eax
      ea:	89 04 24             	mov    %eax,(%esp)
      ed:	e8 fe 0b 00 00       	call   cf0 <strchr>
      f2:	31 d2                	xor    %edx,%edx
      f4:	85 c0                	test   %eax,%eax
      f6:	0f 95 c2             	setne  %dl
}
      f9:	83 c4 0c             	add    $0xc,%esp
      fc:	89 d0                	mov    %edx,%eax
      fe:	5b                   	pop    %ebx
      ff:	5e                   	pop    %esi
     100:	5f                   	pop    %edi
     101:	5d                   	pop    %ebp
     102:	c3                   	ret    
     103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     109:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000110 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	57                   	push   %edi
     114:	56                   	push   %esi
     115:	53                   	push   %ebx
     116:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;
  
  s = *ps;
     119:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     11c:	8b 75 0c             	mov    0xc(%ebp),%esi
     11f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;
  
  s = *ps;
     122:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     124:	39 f3                	cmp    %esi,%ebx
     126:	72 0f                	jb     137 <gettoken+0x27>
     128:	eb 24                	jmp    14e <gettoken+0x3e>
     12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     130:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     133:	39 f3                	cmp    %esi,%ebx
     135:	74 17                	je     14e <gettoken+0x3e>
     137:	0f be 03             	movsbl (%ebx),%eax
     13a:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
     141:	89 44 24 04          	mov    %eax,0x4(%esp)
     145:	e8 a6 0b 00 00       	call   cf0 <strchr>
     14a:	85 c0                	test   %eax,%eax
     14c:	75 e2                	jne    130 <gettoken+0x20>
    s++;
  if(q)
     14e:	85 ff                	test   %edi,%edi
     150:	74 02                	je     154 <gettoken+0x44>
    *q = s;
     152:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     154:	0f b6 03             	movzbl (%ebx),%eax
     157:	0f be f8             	movsbl %al,%edi
  switch(*s){
     15a:	3c 3c                	cmp    $0x3c,%al
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     15c:	89 fa                	mov    %edi,%edx
  switch(*s){
     15e:	7f 4d                	jg     1ad <gettoken+0x9d>
     160:	3c 3b                	cmp    $0x3b,%al
     162:	0f 8c 99 00 00 00    	jl     201 <gettoken+0xf1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     168:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     16b:	8b 55 14             	mov    0x14(%ebp),%edx
     16e:	85 d2                	test   %edx,%edx
     170:	74 05                	je     177 <gettoken+0x67>
    *eq = s;
     172:	8b 45 14             	mov    0x14(%ebp),%eax
     175:	89 18                	mov    %ebx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     177:	39 f3                	cmp    %esi,%ebx
     179:	72 0c                	jb     187 <gettoken+0x77>
     17b:	eb 21                	jmp    19e <gettoken+0x8e>
     17d:	8d 76 00             	lea    0x0(%esi),%esi
    s++;
     180:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     183:	39 f3                	cmp    %esi,%ebx
     185:	74 17                	je     19e <gettoken+0x8e>
     187:	0f be 03             	movsbl (%ebx),%eax
     18a:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
     191:	89 44 24 04          	mov    %eax,0x4(%esp)
     195:	e8 56 0b 00 00       	call   cf0 <strchr>
     19a:	85 c0                	test   %eax,%eax
     19c:	75 e2                	jne    180 <gettoken+0x70>
    s++;
  *ps = s;
     19e:	8b 45 08             	mov    0x8(%ebp),%eax
     1a1:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     1a3:	83 c4 0c             	add    $0xc,%esp
     1a6:	89 f8                	mov    %edi,%eax
     1a8:	5b                   	pop    %ebx
     1a9:	5e                   	pop    %esi
     1aa:	5f                   	pop    %edi
     1ab:	5d                   	pop    %ebp
     1ac:	c3                   	ret    
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     1ad:	3c 3e                	cmp    $0x3e,%al
     1af:	74 74                	je     225 <gettoken+0x115>
     1b1:	3c 7c                	cmp    $0x7c,%al
     1b3:	74 b3                	je     168 <gettoken+0x58>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     1b5:	39 de                	cmp    %ebx,%esi
     1b7:	77 2a                	ja     1e3 <gettoken+0xd3>
     1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
     1c0:	eb 35                	jmp    1f7 <gettoken+0xe7>
     1c2:	0f be 03             	movsbl (%ebx),%eax
     1c5:	c7 04 24 8e 13 00 00 	movl   $0x138e,(%esp)
     1cc:	89 44 24 04          	mov    %eax,0x4(%esp)
     1d0:	e8 1b 0b 00 00       	call   cf0 <strchr>
     1d5:	85 c0                	test   %eax,%eax
     1d7:	75 1e                	jne    1f7 <gettoken+0xe7>
      s++;
     1d9:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     1dc:	39 f3                	cmp    %esi,%ebx
     1de:	74 17                	je     1f7 <gettoken+0xe7>
     1e0:	0f be 13             	movsbl (%ebx),%edx
     1e3:	89 54 24 04          	mov    %edx,0x4(%esp)
     1e7:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
     1ee:	e8 fd 0a 00 00       	call   cf0 <strchr>
     1f3:	85 c0                	test   %eax,%eax
     1f5:	74 cb                	je     1c2 <gettoken+0xb2>
     1f7:	bf 61 00 00 00       	mov    $0x61,%edi
     1fc:	e9 6a ff ff ff       	jmp    16b <gettoken+0x5b>
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     201:	3c 29                	cmp    $0x29,%al
     203:	7f b0                	jg     1b5 <gettoken+0xa5>
     205:	3c 28                	cmp    $0x28,%al
     207:	0f 8d 5b ff ff ff    	jge    168 <gettoken+0x58>
     20d:	84 c0                	test   %al,%al
     20f:	90                   	nop    
     210:	0f 84 55 ff ff ff    	je     16b <gettoken+0x5b>
     216:	3c 26                	cmp    $0x26,%al
     218:	75 9b                	jne    1b5 <gettoken+0xa5>
     21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     220:	e9 43 ff ff ff       	jmp    168 <gettoken+0x58>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     225:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     228:	bf 3e 00 00 00       	mov    $0x3e,%edi
     22d:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     230:	0f 85 35 ff ff ff    	jne    16b <gettoken+0x5b>
      ret = '+';
      s++;
     236:	83 c3 01             	add    $0x1,%ebx
     239:	66 bf 2b 00          	mov    $0x2b,%di
     23d:	e9 29 ff ff ff       	jmp    16b <gettoken+0x5b>
     242:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
     249:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000250 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	53                   	push   %ebx
     254:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     257:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     25e:	e8 4d 0f 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     263:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     26a:	00 
     26b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     272:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     273:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     275:	89 04 24             	mov    %eax,(%esp)
     278:	e8 43 0a 00 00       	call   cc0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     27d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
     280:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     286:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     289:	89 d8                	mov    %ebx,%eax
     28b:	83 c4 14             	add    $0x14,%esp
     28e:	5b                   	pop    %ebx
     28f:	5d                   	pop    %ebp
     290:	c3                   	ret    
     291:	eb 0d                	jmp    2a0 <listcmd>
     293:	90                   	nop    
     294:	90                   	nop    
     295:	90                   	nop    
     296:	90                   	nop    
     297:	90                   	nop    
     298:	90                   	nop    
     299:	90                   	nop    
     29a:	90                   	nop    
     29b:	90                   	nop    
     29c:	90                   	nop    
     29d:	90                   	nop    
     29e:	90                   	nop    
     29f:	90                   	nop    

000002a0 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
     2a3:	53                   	push   %ebx
     2a4:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2a7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2ae:	e8 fd 0e 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2b3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     2ba:	00 
     2bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2c2:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2c5:	89 04 24             	mov    %eax,(%esp)
     2c8:	e8 f3 09 00 00       	call   cc0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     2cd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
     2d0:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     2d6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     2dc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2df:	89 d8                	mov    %ebx,%eax
     2e1:	83 c4 14             	add    $0x14,%esp
     2e4:	5b                   	pop    %ebx
     2e5:	5d                   	pop    %ebp
     2e6:	c3                   	ret    
     2e7:	89 f6                	mov    %esi,%esi
     2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000002f0 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	53                   	push   %ebx
     2f4:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2fe:	e8 ad 0e 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     303:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     30a:	00 
     30b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     312:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     313:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     315:	89 04 24             	mov    %eax,(%esp)
     318:	e8 a3 09 00 00       	call   cc0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     31d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
     320:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     326:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     329:	8b 45 0c             	mov    0xc(%ebp),%eax
     32c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     32f:	89 d8                	mov    %ebx,%eax
     331:	83 c4 14             	add    $0x14,%esp
     334:	5b                   	pop    %ebx
     335:	5d                   	pop    %ebp
     336:	c3                   	ret    
     337:	89 f6                	mov    %esi,%esi
     339:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000340 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	53                   	push   %ebx
     344:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     347:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     34e:	e8 5d 0e 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     353:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     35a:	00 
     35b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     362:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     363:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     365:	89 04 24             	mov    %eax,(%esp)
     368:	e8 53 09 00 00       	call   cc0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     36d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
     370:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     376:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     379:	8b 45 0c             	mov    0xc(%ebp),%eax
     37c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     37f:	8b 45 10             	mov    0x10(%ebp),%eax
     382:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     385:	8b 45 14             	mov    0x14(%ebp),%eax
     388:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     38b:	8b 45 18             	mov    0x18(%ebp),%eax
     38e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     391:	89 d8                	mov    %ebx,%eax
     393:	83 c4 14             	add    $0x14,%esp
     396:	5b                   	pop    %ebx
     397:	5d                   	pop    %ebp
     398:	c3                   	ret    
     399:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000003a0 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     3a0:	55                   	push   %ebp
     3a1:	89 e5                	mov    %esp,%ebp
     3a3:	53                   	push   %ebx
     3a4:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a7:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3ae:	e8 fd 0d 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3b3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3ba:	00 
     3bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c2:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3c5:	89 04 24             	mov    %eax,(%esp)
     3c8:	e8 f3 08 00 00       	call   cc0 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     3cd:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     3cf:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     3d5:	83 c4 14             	add    $0x14,%esp
     3d8:	5b                   	pop    %ebx
     3d9:	5d                   	pop    %ebp
     3da:	c3                   	ret    
     3db:	90                   	nop    
     3dc:	8d 74 26 00          	lea    0x0(%esi),%esi

000003e0 <panic>:
  exit();
}

void
panic(char *s)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     3e6:	8b 45 08             	mov    0x8(%ebp),%eax
     3e9:	c7 44 24 04 21 13 00 	movl   $0x1321,0x4(%esp)
     3f0:	00 
     3f1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3f8:	89 44 24 08          	mov    %eax,0x8(%esp)
     3fc:	e8 bf 0b 00 00       	call   fc0 <printf>
  exit();
     401:	e8 32 0a 00 00       	call   e38 <exit>
     406:	8d 76 00             	lea    0x0(%esi),%esi
     409:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000410 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	57                   	push   %edi
     414:	56                   	push   %esi
     415:	53                   	push   %ebx
     416:	83 ec 2c             	sub    $0x2c,%esp
     419:	8b 75 08             	mov    0x8(%ebp),%esi
     41c:	8b 7d 10             	mov    0x10(%ebp),%edi
     41f:	90                   	nop    
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     420:	8b 45 0c             	mov    0xc(%ebp),%eax
     423:	c7 44 24 08 d5 12 00 	movl   $0x12d5,0x8(%esp)
     42a:	00 
     42b:	89 7c 24 04          	mov    %edi,0x4(%esp)
     42f:	89 04 24             	mov    %eax,(%esp)
     432:	e8 69 fc ff ff       	call   a0 <peek>
     437:	85 c0                	test   %eax,%eax
     439:	0f 84 a6 00 00 00    	je     4e5 <parseredirs+0xd5>
    tok = gettoken(ps, es, 0, 0);
     43f:	8b 45 0c             	mov    0xc(%ebp),%eax
     442:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     449:	00 
     44a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     451:	00 
     452:	89 7c 24 04          	mov    %edi,0x4(%esp)
     456:	89 04 24             	mov    %eax,(%esp)
     459:	e8 b2 fc ff ff       	call   110 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     45e:	89 7c 24 04          	mov    %edi,0x4(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     462:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     464:	8d 45 ec             	lea    -0x14(%ebp),%eax
     467:	89 44 24 0c          	mov    %eax,0xc(%esp)
     46b:	8d 45 f0             	lea    -0x10(%ebp),%eax
     46e:	89 44 24 08          	mov    %eax,0x8(%esp)
     472:	8b 45 0c             	mov    0xc(%ebp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 93 fc ff ff       	call   110 <gettoken>
     47d:	83 f8 61             	cmp    $0x61,%eax
     480:	74 0c                	je     48e <parseredirs+0x7e>
      panic("missing file for redirection");
     482:	c7 04 24 b8 12 00 00 	movl   $0x12b8,(%esp)
     489:	e8 52 ff ff ff       	call   3e0 <panic>
    switch(tok){
     48e:	83 fb 3c             	cmp    $0x3c,%ebx
     491:	74 40                	je     4d3 <parseredirs+0xc3>
     493:	83 fb 3e             	cmp    $0x3e,%ebx
     496:	74 0e                	je     4a6 <parseredirs+0x96>
     498:	83 fb 2b             	cmp    $0x2b,%ebx
     49b:	90                   	nop    
     49c:	8d 74 26 00          	lea    0x0(%esi),%esi
     4a0:	0f 85 7a ff ff ff    	jne    420 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     4a6:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     4ad:	00 
     4ae:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     4b5:	00 
     4b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4b9:	89 34 24             	mov    %esi,(%esp)
     4bc:	89 44 24 08          	mov    %eax,0x8(%esp)
     4c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
     4c7:	e8 74 fe ff ff       	call   340 <redircmd>
     4cc:	89 c6                	mov    %eax,%esi
     4ce:	e9 4d ff ff ff       	jmp    420 <parseredirs+0x10>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4d3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     4da:	00 
     4db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     4e2:	00 
     4e3:	eb d1                	jmp    4b6 <parseredirs+0xa6>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     4e5:	83 c4 2c             	add    $0x2c,%esp
     4e8:	89 f0                	mov    %esi,%eax
     4ea:	5b                   	pop    %ebx
     4eb:	5e                   	pop    %esi
     4ec:	5f                   	pop    %edi
     4ed:	5d                   	pop    %ebp
     4ee:	c3                   	ret    
     4ef:	90                   	nop    

000004f0 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     4f0:	55                   	push   %ebp
     4f1:	89 e5                	mov    %esp,%ebp
     4f3:	83 ec 28             	sub    $0x28,%esp
     4f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     4f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     4fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
     4ff:	8b 75 08             	mov    0x8(%ebp),%esi
     502:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     505:	c7 44 24 08 d8 12 00 	movl   $0x12d8,0x8(%esp)
     50c:	00 
     50d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     511:	89 34 24             	mov    %esi,(%esp)
     514:	e8 87 fb ff ff       	call   a0 <peek>
     519:	85 c0                	test   %eax,%eax
     51b:	0f 84 87 00 00 00    	je     5a8 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     521:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     528:	00 
     529:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     530:	00 
     531:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     535:	89 34 24             	mov    %esi,(%esp)
     538:	e8 d3 fb ff ff       	call   110 <gettoken>
  cmd = parseline(ps, es);
     53d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     541:	89 34 24             	mov    %esi,(%esp)
     544:	e8 27 02 00 00       	call   770 <parseline>
  if(!peek(ps, es, ")"))
     549:	c7 44 24 08 f6 12 00 	movl   $0x12f6,0x8(%esp)
     550:	00 
     551:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     555:	89 34 24             	mov    %esi,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     558:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     55a:	e8 41 fb ff ff       	call   a0 <peek>
     55f:	85 c0                	test   %eax,%eax
     561:	75 0c                	jne    56f <parseblock+0x7f>
    panic("syntax - missing )");
     563:	c7 04 24 e5 12 00 00 	movl   $0x12e5,(%esp)
     56a:	e8 71 fe ff ff       	call   3e0 <panic>
  gettoken(ps, es, 0, 0);
     56f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     573:	89 34 24             	mov    %esi,(%esp)
     576:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     57d:	00 
     57e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     585:	00 
     586:	e8 85 fb ff ff       	call   110 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     58b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     58f:	89 74 24 04          	mov    %esi,0x4(%esp)
     593:	89 3c 24             	mov    %edi,(%esp)
     596:	e8 75 fe ff ff       	call   410 <parseredirs>
  return cmd;
}
     59b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     59e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     5a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
     5a4:	89 ec                	mov    %ebp,%esp
     5a6:	5d                   	pop    %ebp
     5a7:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     5a8:	c7 04 24 da 12 00 00 	movl   $0x12da,(%esp)
     5af:	e8 2c fe ff ff       	call   3e0 <panic>
     5b4:	e9 68 ff ff ff       	jmp    521 <parseblock+0x31>
     5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000005c0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     5c0:	55                   	push   %ebp
     5c1:	89 e5                	mov    %esp,%ebp
     5c3:	57                   	push   %edi
     5c4:	56                   	push   %esi
     5c5:	53                   	push   %ebx
     5c6:	83 ec 2c             	sub    $0x2c,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     5c9:	c7 44 24 08 d8 12 00 	movl   $0x12d8,0x8(%esp)
     5d0:	00 
     5d1:	8b 45 0c             	mov    0xc(%ebp),%eax
     5d4:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d8:	8b 45 08             	mov    0x8(%ebp),%eax
     5db:	89 04 24             	mov    %eax,(%esp)
     5de:	e8 bd fa ff ff       	call   a0 <peek>
     5e3:	85 c0                	test   %eax,%eax
     5e5:	74 1e                	je     605 <parseexec+0x45>
    return parseblock(ps, es);
     5e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
     5ee:	8b 45 08             	mov    0x8(%ebp),%eax
     5f1:	89 04 24             	mov    %eax,(%esp)
     5f4:	e8 f7 fe ff ff       	call   4f0 <parseblock>
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5f9:	83 c4 2c             	add    $0x2c,%esp
     5fc:	5b                   	pop    %ebx
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);
     5fd:	89 c6                	mov    %eax,%esi
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5ff:	89 f0                	mov    %esi,%eax
     601:	5e                   	pop    %esi
     602:	5f                   	pop    %edi
     603:	5d                   	pop    %ebp
     604:	c3                   	ret    
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     605:	e8 96 fd ff ff       	call   3a0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     60a:	31 db                	xor    %ebx,%ebx
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     60c:	89 c7                	mov    %eax,%edi
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     60e:	8b 45 0c             	mov    0xc(%ebp),%eax
     611:	89 44 24 08          	mov    %eax,0x8(%esp)
     615:	8b 45 08             	mov    0x8(%ebp),%eax
     618:	89 3c 24             	mov    %edi,(%esp)
     61b:	89 44 24 04          	mov    %eax,0x4(%esp)
     61f:	e8 ec fd ff ff       	call   410 <parseredirs>
     624:	89 c6                	mov    %eax,%esi
     626:	eb 18                	jmp    640 <parseexec+0x80>
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     628:	8b 45 0c             	mov    0xc(%ebp),%eax
     62b:	89 44 24 08          	mov    %eax,0x8(%esp)
     62f:	8b 45 08             	mov    0x8(%ebp),%eax
     632:	89 34 24             	mov    %esi,(%esp)
     635:	89 44 24 04          	mov    %eax,0x4(%esp)
     639:	e8 d2 fd ff ff       	call   410 <parseredirs>
     63e:	89 c6                	mov    %eax,%esi
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     640:	c7 44 24 08 0d 13 00 	movl   $0x130d,0x8(%esp)
     647:	00 
     648:	8b 45 0c             	mov    0xc(%ebp),%eax
     64b:	89 44 24 04          	mov    %eax,0x4(%esp)
     64f:	8b 45 08             	mov    0x8(%ebp),%eax
     652:	89 04 24             	mov    %eax,(%esp)
     655:	e8 46 fa ff ff       	call   a0 <peek>
     65a:	85 c0                	test   %eax,%eax
     65c:	75 60                	jne    6be <parseexec+0xfe>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     65e:	8d 45 ec             	lea    -0x14(%ebp),%eax
     661:	89 44 24 0c          	mov    %eax,0xc(%esp)
     665:	8d 45 f0             	lea    -0x10(%ebp),%eax
     668:	89 44 24 08          	mov    %eax,0x8(%esp)
     66c:	8b 45 0c             	mov    0xc(%ebp),%eax
     66f:	89 44 24 04          	mov    %eax,0x4(%esp)
     673:	8b 45 08             	mov    0x8(%ebp),%eax
     676:	89 04 24             	mov    %eax,(%esp)
     679:	e8 92 fa ff ff       	call   110 <gettoken>
     67e:	85 c0                	test   %eax,%eax
     680:	74 3c                	je     6be <parseexec+0xfe>
      break;
    if(tok != 'a')
     682:	83 f8 61             	cmp    $0x61,%eax
     685:	74 0c                	je     693 <parseexec+0xd3>
      panic("syntax");
     687:	c7 04 24 f8 12 00 00 	movl   $0x12f8,(%esp)
     68e:	e8 4d fd ff ff       	call   3e0 <panic>
    cmd->argv[argc] = q;
     693:	8b 45 f0             	mov    -0x10(%ebp),%eax
     696:	89 44 9f 04          	mov    %eax,0x4(%edi,%ebx,4)
    cmd->eargv[argc] = eq;
     69a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     69d:	89 44 9f 2c          	mov    %eax,0x2c(%edi,%ebx,4)
    argc++;
     6a1:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     6a4:	83 fb 09             	cmp    $0x9,%ebx
     6a7:	0f 8e 7b ff ff ff    	jle    628 <parseexec+0x68>
      panic("too many args");
     6ad:	c7 04 24 ff 12 00 00 	movl   $0x12ff,(%esp)
     6b4:	e8 27 fd ff ff       	call   3e0 <panic>
     6b9:	e9 6a ff ff ff       	jmp    628 <parseexec+0x68>
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     6be:	c7 44 9f 04 00 00 00 	movl   $0x0,0x4(%edi,%ebx,4)
     6c5:	00 
  cmd->eargv[argc] = 0;
  return ret;
}
     6c6:	89 f0                	mov    %esi,%eax
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
     6c8:	c7 44 9f 2c 00 00 00 	movl   $0x0,0x2c(%edi,%ebx,4)
     6cf:	00 
  return ret;
}
     6d0:	83 c4 2c             	add    $0x2c,%esp
     6d3:	5b                   	pop    %ebx
     6d4:	5e                   	pop    %esi
     6d5:	5f                   	pop    %edi
     6d6:	5d                   	pop    %ebp
     6d7:	c3                   	ret    
     6d8:	90                   	nop    
     6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000006e0 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     6e0:	55                   	push   %ebp
     6e1:	89 e5                	mov    %esp,%ebp
     6e3:	83 ec 28             	sub    $0x28,%esp
     6e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     6e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     6ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
     6ef:	8b 75 08             	mov    0x8(%ebp),%esi
     6f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
     6f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     6f9:	89 34 24             	mov    %esi,(%esp)
     6fc:	e8 bf fe ff ff       	call   5c0 <parseexec>
  if(peek(ps, es, "|")){
     701:	c7 44 24 08 12 13 00 	movl   $0x1312,0x8(%esp)
     708:	00 
     709:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     70d:	89 34 24             	mov    %esi,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
     710:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     712:	e8 89 f9 ff ff       	call   a0 <peek>
     717:	85 c0                	test   %eax,%eax
     719:	75 15                	jne    730 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     71b:	89 f8                	mov    %edi,%eax
     71d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     720:	8b 75 f8             	mov    -0x8(%ebp),%esi
     723:	8b 7d fc             	mov    -0x4(%ebp),%edi
     726:	89 ec                	mov    %ebp,%esp
     728:	5d                   	pop    %ebp
     729:	c3                   	ret    
     72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     730:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     734:	89 34 24             	mov    %esi,(%esp)
     737:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     73e:	00 
     73f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     746:	00 
     747:	e8 c4 f9 ff ff       	call   110 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     74c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     750:	89 34 24             	mov    %esi,(%esp)
     753:	e8 88 ff ff ff       	call   6e0 <parsepipe>
  }
  return cmd;
}
     758:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     75b:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     75e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     761:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     764:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     767:	89 ec                	mov    %ebp,%esp
     769:	5d                   	pop    %ebp
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     76a:	e9 81 fb ff ff       	jmp    2f0 <pipecmd>
     76f:	90                   	nop    

00000770 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     770:	55                   	push   %ebp
     771:	89 e5                	mov    %esp,%ebp
     773:	57                   	push   %edi
     774:	56                   	push   %esi
     775:	53                   	push   %ebx
     776:	83 ec 1c             	sub    $0x1c,%esp
     779:	8b 75 08             	mov    0x8(%ebp),%esi
     77c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     77f:	89 34 24             	mov    %esi,(%esp)
     782:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     786:	e8 55 ff ff ff       	call   6e0 <parsepipe>
     78b:	89 c7                	mov    %eax,%edi
     78d:	eb 27                	jmp    7b6 <parseline+0x46>
     78f:	90                   	nop    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
     790:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     797:	00 
     798:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     79f:	00 
     7a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     7a4:	89 34 24             	mov    %esi,(%esp)
     7a7:	e8 64 f9 ff ff       	call   110 <gettoken>
    cmd = backcmd(cmd);
     7ac:	89 3c 24             	mov    %edi,(%esp)
     7af:	e8 9c fa ff ff       	call   250 <backcmd>
     7b4:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7b6:	c7 44 24 08 14 13 00 	movl   $0x1314,0x8(%esp)
     7bd:	00 
     7be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     7c2:	89 34 24             	mov    %esi,(%esp)
     7c5:	e8 d6 f8 ff ff       	call   a0 <peek>
     7ca:	85 c0                	test   %eax,%eax
     7cc:	75 c2                	jne    790 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7ce:	c7 44 24 08 10 13 00 	movl   $0x1310,0x8(%esp)
     7d5:	00 
     7d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     7da:	89 34 24             	mov    %esi,(%esp)
     7dd:	e8 be f8 ff ff       	call   a0 <peek>
     7e2:	85 c0                	test   %eax,%eax
     7e4:	75 0a                	jne    7f0 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     7e6:	83 c4 1c             	add    $0x1c,%esp
     7e9:	89 f8                	mov    %edi,%eax
     7eb:	5b                   	pop    %ebx
     7ec:	5e                   	pop    %esi
     7ed:	5f                   	pop    %edi
     7ee:	5d                   	pop    %ebp
     7ef:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     7f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     7f4:	89 34 24             	mov    %esi,(%esp)
     7f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7fe:	00 
     7ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     806:	00 
     807:	e8 04 f9 ff ff       	call   110 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     80c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     810:	89 34 24             	mov    %esi,(%esp)
     813:	e8 58 ff ff ff       	call   770 <parseline>
     818:	89 7d 08             	mov    %edi,0x8(%ebp)
     81b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     81e:	83 c4 1c             	add    $0x1c,%esp
     821:	5b                   	pop    %ebx
     822:	5e                   	pop    %esi
     823:	5f                   	pop    %edi
     824:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     825:	e9 76 fa ff ff       	jmp    2a0 <listcmd>
     82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000830 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	56                   	push   %esi
     834:	53                   	push   %ebx
     835:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;
  
  es = s + strlen(s);
     838:	8b 45 08             	mov    0x8(%ebp),%eax
     83b:	89 04 24             	mov    %eax,(%esp)
     83e:	e8 5d 04 00 00       	call   ca0 <strlen>
     843:	89 c3                	mov    %eax,%ebx
     845:	03 5d 08             	add    0x8(%ebp),%ebx
  cmd = parseline(&s, es);
     848:	8d 45 08             	lea    0x8(%ebp),%eax
     84b:	89 04 24             	mov    %eax,(%esp)
     84e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     852:	e8 19 ff ff ff       	call   770 <parseline>
  peek(&s, es, "");
     857:	c7 44 24 08 43 13 00 	movl   $0x1343,0x8(%esp)
     85e:	00 
     85f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;
  
  es = s + strlen(s);
  cmd = parseline(&s, es);
     863:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     865:	8d 45 08             	lea    0x8(%ebp),%eax
     868:	89 04 24             	mov    %eax,(%esp)
     86b:	e8 30 f8 ff ff       	call   a0 <peek>
  if(s != es){
     870:	8b 45 08             	mov    0x8(%ebp),%eax
     873:	39 d8                	cmp    %ebx,%eax
     875:	74 24                	je     89b <parsecmd+0x6b>
    printf(2, "leftovers: %s\n", s);
     877:	89 44 24 08          	mov    %eax,0x8(%esp)
     87b:	c7 44 24 04 16 13 00 	movl   $0x1316,0x4(%esp)
     882:	00 
     883:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     88a:	e8 31 07 00 00       	call   fc0 <printf>
    panic("syntax");
     88f:	c7 04 24 f8 12 00 00 	movl   $0x12f8,(%esp)
     896:	e8 45 fb ff ff       	call   3e0 <panic>
  }
  nulterminate(cmd);
     89b:	89 34 24             	mov    %esi,(%esp)
     89e:	e8 5d f7 ff ff       	call   0 <nulterminate>
  return cmd;
}
     8a3:	83 c4 10             	add    $0x10,%esp
     8a6:	89 f0                	mov    %esi,%eax
     8a8:	5b                   	pop    %ebx
     8a9:	5e                   	pop    %esi
     8aa:	5d                   	pop    %ebp
     8ab:	c3                   	ret    
     8ac:	8d 74 26 00          	lea    0x0(%esi),%esi

000008b0 <fork1>:
  exit();
}

int
fork1(void)
{
     8b0:	55                   	push   %ebp
     8b1:	89 e5                	mov    %esp,%ebp
     8b3:	53                   	push   %ebx
     8b4:	83 ec 04             	sub    $0x4,%esp
  int pid;
  
  pid = fork();
     8b7:	e8 74 05 00 00       	call   e30 <fork>
  if(pid == -1)
     8bc:	83 f8 ff             	cmp    $0xffffffff,%eax
int
fork1(void)
{
  int pid;
  
  pid = fork();
     8bf:	89 c3                	mov    %eax,%ebx
  if(pid == -1)
     8c1:	74 0d                	je     8d0 <fork1+0x20>
    panic("fork");
  return pid;
}
     8c3:	89 d8                	mov    %ebx,%eax
     8c5:	83 c4 04             	add    $0x4,%esp
     8c8:	5b                   	pop    %ebx
     8c9:	5d                   	pop    %ebp
     8ca:	c3                   	ret    
     8cb:	90                   	nop    
     8cc:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
     8d0:	c7 04 24 25 13 00 00 	movl   $0x1325,(%esp)
     8d7:	e8 04 fb ff ff       	call   3e0 <panic>
  return pid;
}
     8dc:	89 d8                	mov    %ebx,%eax
     8de:	83 c4 04             	add    $0x4,%esp
     8e1:	5b                   	pop    %ebx
     8e2:	5d                   	pop    %ebp
     8e3:	c3                   	ret    
     8e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     8ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000008f0 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     8f0:	55                   	push   %ebp
     8f1:	89 e5                	mov    %esp,%ebp
     8f3:	83 ec 18             	sub    $0x18,%esp
     8f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     8f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
     8ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     902:	c7 44 24 04 2a 13 00 	movl   $0x132a,0x4(%esp)
     909:	00 
     90a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     911:	e8 aa 06 00 00       	call   fc0 <printf>
  memset(buf, 0, nbuf);
     916:	89 74 24 08          	mov    %esi,0x8(%esp)
     91a:	89 1c 24             	mov    %ebx,(%esp)
     91d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     924:	00 
     925:	e8 96 03 00 00       	call   cc0 <memset>
  gets(buf, nbuf);
     92a:	89 74 24 04          	mov    %esi,0x4(%esp)
     92e:	89 1c 24             	mov    %ebx,(%esp)
     931:	e8 9a 04 00 00       	call   dd0 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     936:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     939:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     93c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     93f:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     941:	89 ec                	mov    %ebp,%esp
     943:	5d                   	pop    %ebp
     944:	c3                   	ret    
     945:	8d 74 26 00          	lea    0x0(%esi),%esi
     949:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000950 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     950:	55                   	push   %ebp
     951:	89 e5                	mov    %esp,%ebp
     953:	53                   	push   %ebx
     954:	83 ec 24             	sub    $0x24,%esp
     957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     95a:	85 db                	test   %ebx,%ebx
     95c:	74 42                	je     9a0 <runcmd+0x50>
    exit();
  
  switch(cmd->type){
     95e:	83 3b 05             	cmpl   $0x5,(%ebx)
     961:	76 42                	jbe    9a5 <runcmd+0x55>
  default:
    panic("runcmd");
     963:	c7 04 24 2d 13 00 00 	movl   $0x132d,(%esp)
     96a:	e8 71 fa ff ff       	call   3e0 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     96f:	8b 53 04             	mov    0x4(%ebx),%edx
     972:	85 d2                	test   %edx,%edx
     974:	74 2a                	je     9a0 <runcmd+0x50>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
     976:	8d 43 04             	lea    0x4(%ebx),%eax
     979:	89 44 24 04          	mov    %eax,0x4(%esp)
     97d:	89 14 24             	mov    %edx,(%esp)
     980:	e8 eb 04 00 00       	call   e70 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     985:	8b 43 04             	mov    0x4(%ebx),%eax
     988:	c7 44 24 04 34 13 00 	movl   $0x1334,0x4(%esp)
     98f:	00 
     990:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     997:	89 44 24 08          	mov    %eax,0x8(%esp)
     99b:	e8 20 06 00 00       	call   fc0 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9a0:	e8 93 04 00 00       	call   e38 <exit>
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
  
  switch(cmd->type){
     9a5:	8b 03                	mov    (%ebx),%eax
     9a7:	ff 24 85 a0 12 00 00 	jmp    *0x12a0(,%eax,4)
     9ae:	66 90                	xchg   %ax,%ax
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     9b0:	e8 fb fe ff ff       	call   8b0 <fork1>
     9b5:	85 c0                	test   %eax,%eax
     9b7:	0f 84 9f 00 00 00    	je     a5c <runcmd+0x10c>
     9bd:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9c0:	e8 73 04 00 00       	call   e38 <exit>
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     9c5:	e8 e6 fe ff ff       	call   8b0 <fork1>
     9ca:	85 c0                	test   %eax,%eax
     9cc:	0f 84 9a 00 00 00    	je     a6c <runcmd+0x11c>
      runcmd(lcmd->left);
    wait();
     9d2:	e8 69 04 00 00       	call   e40 <wait>
    runcmd(lcmd->right);
     9d7:	8b 43 08             	mov    0x8(%ebx),%eax
     9da:	89 04 24             	mov    %eax,(%esp)
     9dd:	e8 6e ff ff ff       	call   950 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9e2:	e8 51 04 00 00       	call   e38 <exit>
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     9e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
     9ea:	89 04 24             	mov    %eax,(%esp)
     9ed:	e8 56 04 00 00       	call   e48 <pipe>
     9f2:	85 c0                	test   %eax,%eax
     9f4:	0f 88 fc 00 00 00    	js     af6 <runcmd+0x1a6>
      panic("pipe");
    if(fork1() == 0){
     9fa:	e8 b1 fe ff ff       	call   8b0 <fork1>
     9ff:	85 c0                	test   %eax,%eax
     a01:	0f 84 b2 00 00 00    	je     ab9 <runcmd+0x169>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
     a07:	e8 a4 fe ff ff       	call   8b0 <fork1>
     a0c:	85 c0                	test   %eax,%eax
     a0e:	66 90                	xchg   %ax,%ax
     a10:	74 6a                	je     a7c <runcmd+0x12c>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
     a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a15:	89 04 24             	mov    %eax,(%esp)
     a18:	e8 43 04 00 00       	call   e60 <close>
    close(p[1]);
     a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a20:	89 04 24             	mov    %eax,(%esp)
     a23:	e8 38 04 00 00       	call   e60 <close>
    wait();
     a28:	e8 13 04 00 00       	call   e40 <wait>
    wait();
     a2d:	e8 0e 04 00 00       	call   e40 <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a32:	e8 01 04 00 00       	call   e38 <exit>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     a37:	8b 43 14             	mov    0x14(%ebx),%eax
     a3a:	89 04 24             	mov    %eax,(%esp)
     a3d:	e8 1e 04 00 00       	call   e60 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     a42:	8b 43 10             	mov    0x10(%ebx),%eax
     a45:	89 44 24 04          	mov    %eax,0x4(%esp)
     a49:	8b 43 08             	mov    0x8(%ebx),%eax
     a4c:	89 04 24             	mov    %eax,(%esp)
     a4f:	e8 24 04 00 00       	call   e78 <open>
     a54:	85 c0                	test   %eax,%eax
     a56:	0f 88 ab 00 00 00    	js     b07 <runcmd+0x1b7>
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
     a5c:	8b 43 04             	mov    0x4(%ebx),%eax
     a5f:	89 04 24             	mov    %eax,(%esp)
     a62:	e8 e9 fe ff ff       	call   950 <runcmd>
    break;
  }
  exit();
     a67:	e8 cc 03 00 00       	call   e38 <exit>
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
     a6c:	8b 43 04             	mov    0x4(%ebx),%eax
     a6f:	89 04 24             	mov    %eax,(%esp)
     a72:	e8 d9 fe ff ff       	call   950 <runcmd>
     a77:	e9 56 ff ff ff       	jmp    9d2 <runcmd+0x82>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
     a7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a83:	e8 d8 03 00 00       	call   e60 <close>
      dup(p[0]);
     a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a8b:	89 04 24             	mov    %eax,(%esp)
     a8e:	e8 1d 04 00 00       	call   eb0 <dup>
      close(p[0]);
     a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a96:	89 04 24             	mov    %eax,(%esp)
     a99:	e8 c2 03 00 00       	call   e60 <close>
      close(p[1]);
     a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     aa1:	89 04 24             	mov    %eax,(%esp)
     aa4:	e8 b7 03 00 00       	call   e60 <close>
      runcmd(pcmd->right);
     aa9:	8b 43 08             	mov    0x8(%ebx),%eax
     aac:	89 04 24             	mov    %eax,(%esp)
     aaf:	e8 9c fe ff ff       	call   950 <runcmd>
     ab4:	e9 59 ff ff ff       	jmp    a12 <runcmd+0xc2>
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     ab9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ac0:	e8 9b 03 00 00       	call   e60 <close>
      dup(p[1]);
     ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ac8:	89 04 24             	mov    %eax,(%esp)
     acb:	e8 e0 03 00 00       	call   eb0 <dup>
      close(p[0]);
     ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad3:	89 04 24             	mov    %eax,(%esp)
     ad6:	e8 85 03 00 00       	call   e60 <close>
      close(p[1]);
     adb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ade:	89 04 24             	mov    %eax,(%esp)
     ae1:	e8 7a 03 00 00       	call   e60 <close>
      runcmd(pcmd->left);
     ae6:	8b 43 04             	mov    0x4(%ebx),%eax
     ae9:	89 04 24             	mov    %eax,(%esp)
     aec:	e8 5f fe ff ff       	call   950 <runcmd>
     af1:	e9 11 ff ff ff       	jmp    a07 <runcmd+0xb7>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     af6:	c7 04 24 54 13 00 00 	movl   $0x1354,(%esp)
     afd:	e8 de f8 ff ff       	call   3e0 <panic>
     b02:	e9 f3 fe ff ff       	jmp    9fa <runcmd+0xaa>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     b07:	8b 43 08             	mov    0x8(%ebx),%eax
     b0a:	c7 44 24 04 44 13 00 	movl   $0x1344,0x4(%esp)
     b11:	00 
     b12:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     b19:	89 44 24 08          	mov    %eax,0x8(%esp)
     b1d:	e8 9e 04 00 00       	call   fc0 <printf>
      exit();
     b22:	e8 11 03 00 00       	call   e38 <exit>
     b27:	89 f6                	mov    %esi,%esi
     b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000b30 <main>:
  return 0;
}

int
main(void)
{
     b30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     b34:	83 e4 f0             	and    $0xfffffff0,%esp
     b37:	ff 71 fc             	pushl  -0x4(%ecx)
     b3a:	55                   	push   %ebp
     b3b:	89 e5                	mov    %esp,%ebp
     b3d:	51                   	push   %ecx
     b3e:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     b41:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     b48:	00 
     b49:	c7 04 24 59 13 00 00 	movl   $0x1359,(%esp)
     b50:	e8 23 03 00 00       	call   e78 <open>
     b55:	85 c0                	test   %eax,%eax
     b57:	78 2c                	js     b85 <main+0x55>
    if(fd >= 3){
     b59:	83 f8 02             	cmp    $0x2,%eax
     b5c:	7e e3                	jle    b41 <main+0x11>
      close(fd);
     b5e:	89 04 24             	mov    %eax,(%esp)
     b61:	e8 fa 02 00 00       	call   e60 <close>
     b66:	eb 1d                	jmp    b85 <main+0x55>
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
     b68:	c7 04 24 a0 13 00 00 	movl   $0x13a0,(%esp)
     b6f:	e8 bc fc ff ff       	call   830 <parsecmd>
     b74:	89 04 24             	mov    %eax,(%esp)
     b77:	e8 d4 fd ff ff       	call   950 <runcmd>
     b7c:	8d 74 26 00          	lea    0x0(%esi),%esi
    wait();
     b80:	e8 bb 02 00 00       	call   e40 <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     b85:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     b8c:	00 
     b8d:	c7 04 24 a0 13 00 00 	movl   $0x13a0,(%esp)
     b94:	e8 57 fd ff ff       	call   8f0 <getcmd>
     b99:	85 c0                	test   %eax,%eax
     b9b:	78 73                	js     c10 <main+0xe0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b9d:	80 3d a0 13 00 00 63 	cmpb   $0x63,0x13a0
     ba4:	75 09                	jne    baf <main+0x7f>
     ba6:	80 3d a1 13 00 00 64 	cmpb   $0x64,0x13a1
     bad:	74 11                	je     bc0 <main+0x90>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
     baf:	e8 fc fc ff ff       	call   8b0 <fork1>
     bb4:	85 c0                	test   %eax,%eax
     bb6:	75 c8                	jne    b80 <main+0x50>
     bb8:	eb ae                	jmp    b68 <main+0x38>
     bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     bc0:	80 3d a2 13 00 00 20 	cmpb   $0x20,0x13a2
     bc7:	75 e6                	jne    baf <main+0x7f>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     bc9:	c7 04 24 a0 13 00 00 	movl   $0x13a0,(%esp)
     bd0:	e8 cb 00 00 00       	call   ca0 <strlen>
      if(chdir(buf+3) < 0)
     bd5:	c7 04 24 a3 13 00 00 	movl   $0x13a3,(%esp)
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     bdc:	c6 80 9f 13 00 00 00 	movb   $0x0,0x139f(%eax)
      if(chdir(buf+3) < 0)
     be3:	e8 c0 02 00 00       	call   ea8 <chdir>
     be8:	85 c0                	test   %eax,%eax
     bea:	79 99                	jns    b85 <main+0x55>
        printf(2, "cannot cd %s\n", buf+3);
     bec:	c7 44 24 08 a3 13 00 	movl   $0x13a3,0x8(%esp)
     bf3:	00 
     bf4:	c7 44 24 04 61 13 00 	movl   $0x1361,0x4(%esp)
     bfb:	00 
     bfc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c03:	e8 b8 03 00 00       	call   fc0 <printf>
     c08:	e9 78 ff ff ff       	jmp    b85 <main+0x55>
     c0d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     c10:	e8 23 02 00 00       	call   e38 <exit>
     c15:	90                   	nop    
     c16:	90                   	nop    
     c17:	90                   	nop    
     c18:	90                   	nop    
     c19:	90                   	nop    
     c1a:	90                   	nop    
     c1b:	90                   	nop    
     c1c:	90                   	nop    
     c1d:	90                   	nop    
     c1e:	90                   	nop    
     c1f:	90                   	nop    

00000c20 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
     c20:	55                   	push   %ebp
     c21:	89 e5                	mov    %esp,%ebp
     c23:	53                   	push   %ebx
     c24:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     c2a:	89 da                	mov    %ebx,%edx
     c2c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c30:	0f b6 01             	movzbl (%ecx),%eax
     c33:	83 c1 01             	add    $0x1,%ecx
     c36:	88 02                	mov    %al,(%edx)
     c38:	83 c2 01             	add    $0x1,%edx
     c3b:	84 c0                	test   %al,%al
     c3d:	75 f1                	jne    c30 <strcpy+0x10>
    ;
  return os;
}
     c3f:	89 d8                	mov    %ebx,%eax
     c41:	5b                   	pop    %ebx
     c42:	5d                   	pop    %ebp
     c43:	c3                   	ret    
     c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c50:	55                   	push   %ebp
     c51:	89 e5                	mov    %esp,%ebp
     c53:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c56:	53                   	push   %ebx
     c57:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
     c5a:	0f b6 01             	movzbl (%ecx),%eax
     c5d:	84 c0                	test   %al,%al
     c5f:	74 24                	je     c85 <strcmp+0x35>
     c61:	0f b6 13             	movzbl (%ebx),%edx
     c64:	38 d0                	cmp    %dl,%al
     c66:	74 12                	je     c7a <strcmp+0x2a>
     c68:	eb 1e                	jmp    c88 <strcmp+0x38>
     c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c70:	0f b6 13             	movzbl (%ebx),%edx
     c73:	83 c1 01             	add    $0x1,%ecx
     c76:	38 d0                	cmp    %dl,%al
     c78:	75 0e                	jne    c88 <strcmp+0x38>
     c7a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     c7e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c81:	84 c0                	test   %al,%al
     c83:	75 eb                	jne    c70 <strcmp+0x20>
     c85:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     c88:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c89:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     c8c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c8d:	0f b6 d2             	movzbl %dl,%edx
     c90:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     c92:	c3                   	ret    
     c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000ca0 <strlen>:

uint
strlen(char *s)
{
     ca0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     ca1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     ca3:	89 e5                	mov    %esp,%ebp
     ca5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     ca8:	80 39 00             	cmpb   $0x0,(%ecx)
     cab:	74 0e                	je     cbb <strlen+0x1b>
     cad:	31 d2                	xor    %edx,%edx
     caf:	90                   	nop    
     cb0:	83 c2 01             	add    $0x1,%edx
     cb3:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
     cb7:	89 d0                	mov    %edx,%eax
     cb9:	75 f5                	jne    cb0 <strlen+0x10>
    ;
  return n;
}
     cbb:	5d                   	pop    %ebp
     cbc:	c3                   	ret    
     cbd:	8d 76 00             	lea    0x0(%esi),%esi

00000cc0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	8b 45 10             	mov    0x10(%ebp),%eax
     cc6:	53                   	push   %ebx
     cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
     cca:	85 c0                	test   %eax,%eax
     ccc:	74 10                	je     cde <memset+0x1e>
     cce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
     cd2:	31 d2                	xor    %edx,%edx
    *d++ = c;
     cd4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
     cd7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
     cda:	39 c2                	cmp    %eax,%edx
     cdc:	75 f6                	jne    cd4 <memset+0x14>
    *d++ = c;
  return dst;
}
     cde:	89 d8                	mov    %ebx,%eax
     ce0:	5b                   	pop    %ebx
     ce1:	5d                   	pop    %ebp
     ce2:	c3                   	ret    
     ce3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000cf0 <strchr>:

char*
strchr(const char *s, char c)
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	8b 45 08             	mov    0x8(%ebp),%eax
     cf6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     cfa:	0f b6 10             	movzbl (%eax),%edx
     cfd:	84 d2                	test   %dl,%dl
     cff:	75 0c                	jne    d0d <strchr+0x1d>
     d01:	eb 11                	jmp    d14 <strchr+0x24>
     d03:	83 c0 01             	add    $0x1,%eax
     d06:	0f b6 10             	movzbl (%eax),%edx
     d09:	84 d2                	test   %dl,%dl
     d0b:	74 07                	je     d14 <strchr+0x24>
    if(*s == c)
     d0d:	38 ca                	cmp    %cl,%dl
     d0f:	90                   	nop    
     d10:	75 f1                	jne    d03 <strchr+0x13>
      return (char*) s;
  return 0;
}
     d12:	5d                   	pop    %ebp
     d13:	c3                   	ret    
     d14:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d15:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
     d17:	c3                   	ret    
     d18:	90                   	nop    
     d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000d20 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d26:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d27:	31 db                	xor    %ebx,%ebx
     d29:	0f b6 11             	movzbl (%ecx),%edx
     d2c:	8d 42 d0             	lea    -0x30(%edx),%eax
     d2f:	3c 09                	cmp    $0x9,%al
     d31:	77 18                	ja     d4b <atoi+0x2b>
    n = n*10 + *s++ - '0';
     d33:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
     d36:	0f be d2             	movsbl %dl,%edx
     d39:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d3d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
     d41:	83 c1 01             	add    $0x1,%ecx
     d44:	8d 42 d0             	lea    -0x30(%edx),%eax
     d47:	3c 09                	cmp    $0x9,%al
     d49:	76 e8                	jbe    d33 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
     d4b:	89 d8                	mov    %ebx,%eax
     d4d:	5b                   	pop    %ebx
     d4e:	5d                   	pop    %ebp
     d4f:	c3                   	ret    

00000d50 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
     d53:	8b 4d 10             	mov    0x10(%ebp),%ecx
     d56:	56                   	push   %esi
     d57:	8b 75 08             	mov    0x8(%ebp),%esi
     d5a:	53                   	push   %ebx
     d5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d5e:	85 c9                	test   %ecx,%ecx
     d60:	7e 10                	jle    d72 <memmove+0x22>
     d62:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
     d64:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
     d68:	88 04 32             	mov    %al,(%edx,%esi,1)
     d6b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d6e:	39 ca                	cmp    %ecx,%edx
     d70:	75 f2                	jne    d64 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
     d72:	89 f0                	mov    %esi,%eax
     d74:	5b                   	pop    %ebx
     d75:	5e                   	pop    %esi
     d76:	5d                   	pop    %ebp
     d77:	c3                   	ret    
     d78:	90                   	nop    
     d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000d80 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d86:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
     d89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     d8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
     d8f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d9b:	00 
     d9c:	89 04 24             	mov    %eax,(%esp)
     d9f:	e8 d4 00 00 00       	call   e78 <open>
  if(fd < 0)
     da4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     da6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
     da8:	78 19                	js     dc3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
     daa:	8b 45 0c             	mov    0xc(%ebp),%eax
     dad:	89 1c 24             	mov    %ebx,(%esp)
     db0:	89 44 24 04          	mov    %eax,0x4(%esp)
     db4:	e8 d7 00 00 00       	call   e90 <fstat>
  close(fd);
     db9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
     dbc:	89 c6                	mov    %eax,%esi
  close(fd);
     dbe:	e8 9d 00 00 00       	call   e60 <close>
  return r;
}
     dc3:	89 f0                	mov    %esi,%eax
     dc5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
     dc8:	8b 75 fc             	mov    -0x4(%ebp),%esi
     dcb:	89 ec                	mov    %ebp,%esp
     dcd:	5d                   	pop    %ebp
     dce:	c3                   	ret    
     dcf:	90                   	nop    

00000dd0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
     dd0:	55                   	push   %ebp
     dd1:	89 e5                	mov    %esp,%ebp
     dd3:	57                   	push   %edi
     dd4:	56                   	push   %esi
     dd5:	31 f6                	xor    %esi,%esi
     dd7:	53                   	push   %ebx
     dd8:	83 ec 1c             	sub    $0x1c,%esp
     ddb:	8b 7d 08             	mov    0x8(%ebp),%edi
     dde:	eb 06                	jmp    de6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     de0:	3c 0d                	cmp    $0xd,%al
     de2:	74 39                	je     e1d <gets+0x4d>
     de4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     de6:	8d 5e 01             	lea    0x1(%esi),%ebx
     de9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     dec:	7d 31                	jge    e1f <gets+0x4f>
    cc = read(0, &c, 1);
     dee:	8d 45 f3             	lea    -0xd(%ebp),%eax
     df1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     df8:	00 
     df9:	89 44 24 04          	mov    %eax,0x4(%esp)
     dfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e04:	e8 47 00 00 00       	call   e50 <read>
    if(cc < 1)
     e09:	85 c0                	test   %eax,%eax
     e0b:	7e 12                	jle    e1f <gets+0x4f>
      break;
    buf[i++] = c;
     e0d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
     e11:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
     e15:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
     e19:	3c 0a                	cmp    $0xa,%al
     e1b:	75 c3                	jne    de0 <gets+0x10>
     e1d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     e1f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     e23:	89 f8                	mov    %edi,%eax
     e25:	83 c4 1c             	add    $0x1c,%esp
     e28:	5b                   	pop    %ebx
     e29:	5e                   	pop    %esi
     e2a:	5f                   	pop    %edi
     e2b:	5d                   	pop    %ebp
     e2c:	c3                   	ret    
     e2d:	90                   	nop    
     e2e:	90                   	nop    
     e2f:	90                   	nop    

00000e30 <fork>:
     e30:	b8 01 00 00 00       	mov    $0x1,%eax
     e35:	cd 30                	int    $0x30
     e37:	c3                   	ret    

00000e38 <exit>:
     e38:	b8 02 00 00 00       	mov    $0x2,%eax
     e3d:	cd 30                	int    $0x30
     e3f:	c3                   	ret    

00000e40 <wait>:
     e40:	b8 03 00 00 00       	mov    $0x3,%eax
     e45:	cd 30                	int    $0x30
     e47:	c3                   	ret    

00000e48 <pipe>:
     e48:	b8 04 00 00 00       	mov    $0x4,%eax
     e4d:	cd 30                	int    $0x30
     e4f:	c3                   	ret    

00000e50 <read>:
     e50:	b8 06 00 00 00       	mov    $0x6,%eax
     e55:	cd 30                	int    $0x30
     e57:	c3                   	ret    

00000e58 <write>:
     e58:	b8 05 00 00 00       	mov    $0x5,%eax
     e5d:	cd 30                	int    $0x30
     e5f:	c3                   	ret    

00000e60 <close>:
     e60:	b8 07 00 00 00       	mov    $0x7,%eax
     e65:	cd 30                	int    $0x30
     e67:	c3                   	ret    

00000e68 <kill>:
     e68:	b8 08 00 00 00       	mov    $0x8,%eax
     e6d:	cd 30                	int    $0x30
     e6f:	c3                   	ret    

00000e70 <exec>:
     e70:	b8 09 00 00 00       	mov    $0x9,%eax
     e75:	cd 30                	int    $0x30
     e77:	c3                   	ret    

00000e78 <open>:
     e78:	b8 0a 00 00 00       	mov    $0xa,%eax
     e7d:	cd 30                	int    $0x30
     e7f:	c3                   	ret    

00000e80 <mknod>:
     e80:	b8 0b 00 00 00       	mov    $0xb,%eax
     e85:	cd 30                	int    $0x30
     e87:	c3                   	ret    

00000e88 <unlink>:
     e88:	b8 0c 00 00 00       	mov    $0xc,%eax
     e8d:	cd 30                	int    $0x30
     e8f:	c3                   	ret    

00000e90 <fstat>:
     e90:	b8 0d 00 00 00       	mov    $0xd,%eax
     e95:	cd 30                	int    $0x30
     e97:	c3                   	ret    

00000e98 <link>:
     e98:	b8 0e 00 00 00       	mov    $0xe,%eax
     e9d:	cd 30                	int    $0x30
     e9f:	c3                   	ret    

00000ea0 <mkdir>:
     ea0:	b8 0f 00 00 00       	mov    $0xf,%eax
     ea5:	cd 30                	int    $0x30
     ea7:	c3                   	ret    

00000ea8 <chdir>:
     ea8:	b8 10 00 00 00       	mov    $0x10,%eax
     ead:	cd 30                	int    $0x30
     eaf:	c3                   	ret    

00000eb0 <dup>:
     eb0:	b8 11 00 00 00       	mov    $0x11,%eax
     eb5:	cd 30                	int    $0x30
     eb7:	c3                   	ret    

00000eb8 <getpid>:
     eb8:	b8 12 00 00 00       	mov    $0x12,%eax
     ebd:	cd 30                	int    $0x30
     ebf:	c3                   	ret    

00000ec0 <sbrk>:
     ec0:	b8 13 00 00 00       	mov    $0x13,%eax
     ec5:	cd 30                	int    $0x30
     ec7:	c3                   	ret    

00000ec8 <sleep>:
     ec8:	b8 14 00 00 00       	mov    $0x14,%eax
     ecd:	cd 30                	int    $0x30
     ecf:	c3                   	ret    

00000ed0 <tick>:
     ed0:	b8 15 00 00 00       	mov    $0x15,%eax
     ed5:	cd 30                	int    $0x30
     ed7:	c3                   	ret    

00000ed8 <fork_tickets>:
     ed8:	b8 16 00 00 00       	mov    $0x16,%eax
     edd:	cd 30                	int    $0x30
     edf:	c3                   	ret    

00000ee0 <fork_thread>:
     ee0:	b8 17 00 00 00       	mov    $0x17,%eax
     ee5:	cd 30                	int    $0x30
     ee7:	c3                   	ret    

00000ee8 <wait_thread>:
     ee8:	b8 18 00 00 00       	mov    $0x18,%eax
     eed:	cd 30                	int    $0x30
     eef:	c3                   	ret    

00000ef0 <sleep_cond>:
     ef0:	b8 19 00 00 00       	mov    $0x19,%eax
     ef5:	cd 30                	int    $0x30
     ef7:	c3                   	ret    

00000ef8 <wake_cond>:
     ef8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     efd:	cd 30                	int    $0x30
     eff:	c3                   	ret    

00000f00 <xchng>:
     f00:	b8 1b 00 00 00       	mov    $0x1b,%eax
     f05:	cd 30                	int    $0x30
     f07:	c3                   	ret    

00000f08 <check>:
     f08:	b8 1c 00 00 00       	mov    $0x1c,%eax
     f0d:	cd 30                	int    $0x30
     f0f:	c3                   	ret    

00000f10 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	83 ec 18             	sub    $0x18,%esp
     f16:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
     f19:	8d 55 fc             	lea    -0x4(%ebp),%edx
     f1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f23:	00 
     f24:	89 54 24 04          	mov    %edx,0x4(%esp)
     f28:	89 04 24             	mov    %eax,(%esp)
     f2b:	e8 28 ff ff ff       	call   e58 <write>
}
     f30:	c9                   	leave  
     f31:	c3                   	ret    
     f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
     f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000f40 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f40:	55                   	push   %ebp
     f41:	89 e5                	mov    %esp,%ebp
     f43:	57                   	push   %edi
     f44:	56                   	push   %esi
     f45:	89 ce                	mov    %ecx,%esi
     f47:	53                   	push   %ebx
     f48:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     f4e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f51:	85 c9                	test   %ecx,%ecx
     f53:	74 04                	je     f59 <printint+0x19>
     f55:	85 d2                	test   %edx,%edx
     f57:	78 54                	js     fad <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f59:	89 d0                	mov    %edx,%eax
     f5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     f62:	31 db                	xor    %ebx,%ebx
     f64:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
     f67:	31 d2                	xor    %edx,%edx
     f69:	f7 f6                	div    %esi
     f6b:	89 c1                	mov    %eax,%ecx
     f6d:	0f b6 82 76 13 00 00 	movzbl 0x1376(%edx),%eax
     f74:	88 04 3b             	mov    %al,(%ebx,%edi,1)
     f77:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
     f7a:	85 c9                	test   %ecx,%ecx
     f7c:	89 c8                	mov    %ecx,%eax
     f7e:	75 e7                	jne    f67 <printint+0x27>
  if(neg)
     f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f83:	85 c0                	test   %eax,%eax
     f85:	74 08                	je     f8f <printint+0x4f>
    buf[i++] = '-';
     f87:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
     f8c:	83 c3 01             	add    $0x1,%ebx
     f8f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
     f92:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
     f96:	83 eb 01             	sub    $0x1,%ebx
     f99:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f9c:	e8 6f ff ff ff       	call   f10 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fa1:	39 fb                	cmp    %edi,%ebx
     fa3:	75 ed                	jne    f92 <printint+0x52>
    putc(fd, buf[i]);
}
     fa5:	83 c4 1c             	add    $0x1c,%esp
     fa8:	5b                   	pop    %ebx
     fa9:	5e                   	pop    %esi
     faa:	5f                   	pop    %edi
     fab:	5d                   	pop    %ebp
     fac:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     fad:	89 d0                	mov    %edx,%eax
     faf:	f7 d8                	neg    %eax
     fb1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
     fb8:	eb a8                	jmp    f62 <printint+0x22>
     fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000fc0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	57                   	push   %edi
     fc4:	56                   	push   %esi
     fc5:	53                   	push   %ebx
     fc6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
     fcc:	0f b6 02             	movzbl (%edx),%eax
     fcf:	84 c0                	test   %al,%al
     fd1:	0f 84 84 00 00 00    	je     105b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     fd7:	8d 4d 10             	lea    0x10(%ebp),%ecx
     fda:	89 d7                	mov    %edx,%edi
     fdc:	31 f6                	xor    %esi,%esi
     fde:	89 4d f0             	mov    %ecx,-0x10(%ebp)
     fe1:	eb 18                	jmp    ffb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     fe3:	83 fb 25             	cmp    $0x25,%ebx
     fe6:	75 7b                	jne    1063 <printf+0xa3>
     fe8:	66 be 25 00          	mov    $0x25,%si
     fec:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ff0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
     ff4:	83 c7 01             	add    $0x1,%edi
     ff7:	84 c0                	test   %al,%al
     ff9:	74 60                	je     105b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
     ffb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
     ffd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
    1000:	74 e1                	je     fe3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1002:	83 fe 25             	cmp    $0x25,%esi
    1005:	75 e9                	jne    ff0 <printf+0x30>
      if(c == 'd'){
    1007:	83 fb 64             	cmp    $0x64,%ebx
    100a:	0f 84 db 00 00 00    	je     10eb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1010:	83 fb 78             	cmp    $0x78,%ebx
    1013:	74 5b                	je     1070 <printf+0xb0>
    1015:	83 fb 70             	cmp    $0x70,%ebx
    1018:	74 56                	je     1070 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    101a:	83 fb 73             	cmp    $0x73,%ebx
    101d:	8d 76 00             	lea    0x0(%esi),%esi
    1020:	74 72                	je     1094 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1022:	83 fb 63             	cmp    $0x63,%ebx
    1025:	0f 84 a7 00 00 00    	je     10d2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    102b:	83 fb 25             	cmp    $0x25,%ebx
    102e:	66 90                	xchg   %ax,%ax
    1030:	0f 84 da 00 00 00    	je     1110 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1036:	8b 45 08             	mov    0x8(%ebp),%eax
    1039:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
    103e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1040:	e8 cb fe ff ff       	call   f10 <putc>
        putc(fd, c);
    1045:	8b 45 08             	mov    0x8(%ebp),%eax
    1048:	0f be d3             	movsbl %bl,%edx
    104b:	e8 c0 fe ff ff       	call   f10 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1050:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    1054:	83 c7 01             	add    $0x1,%edi
    1057:	84 c0                	test   %al,%al
    1059:	75 a0                	jne    ffb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    105b:	83 c4 0c             	add    $0xc,%esp
    105e:	5b                   	pop    %ebx
    105f:	5e                   	pop    %esi
    1060:	5f                   	pop    %edi
    1061:	5d                   	pop    %ebp
    1062:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	0f be d3             	movsbl %bl,%edx
    1069:	e8 a2 fe ff ff       	call   f10 <putc>
    106e:	eb 80                	jmp    ff0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1070:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1073:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    1078:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    107a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1081:	8b 10                	mov    (%eax),%edx
    1083:	8b 45 08             	mov    0x8(%ebp),%eax
    1086:	e8 b5 fe ff ff       	call   f40 <printint>
        ap++;
    108b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    108f:	e9 5c ff ff ff       	jmp    ff0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
    1094:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1097:	8b 02                	mov    (%edx),%eax
        ap++;
    1099:	83 c2 04             	add    $0x4,%edx
    109c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
    109f:	ba 6f 13 00 00       	mov    $0x136f,%edx
    10a4:	85 c0                	test   %eax,%eax
    10a6:	75 26                	jne    10ce <printf+0x10e>
          s = "(null)";
        while(*s != 0){
    10a8:	0f b6 02             	movzbl (%edx),%eax
    10ab:	84 c0                	test   %al,%al
    10ad:	74 18                	je     10c7 <printf+0x107>
    10af:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
    10b1:	0f be d0             	movsbl %al,%edx
    10b4:	8b 45 08             	mov    0x8(%ebp),%eax
    10b7:	e8 54 fe ff ff       	call   f10 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    10bc:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    10c0:	83 c3 01             	add    $0x1,%ebx
    10c3:	84 c0                	test   %al,%al
    10c5:	75 ea                	jne    10b1 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    10c7:	31 f6                	xor    %esi,%esi
    10c9:	e9 22 ff ff ff       	jmp    ff0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    10ce:	89 c2                	mov    %eax,%edx
    10d0:	eb d6                	jmp    10a8 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    10d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
    10d5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    10d7:	8b 45 08             	mov    0x8(%ebp),%eax
    10da:	0f be 11             	movsbl (%ecx),%edx
    10dd:	e8 2e fe ff ff       	call   f10 <putc>
        ap++;
    10e2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    10e6:	e9 05 ff ff ff       	jmp    ff0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    10eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    10f3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    10f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fd:	8b 10                	mov    (%eax),%edx
    10ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1102:	e8 39 fe ff ff       	call   f40 <printint>
        ap++;
    1107:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    110b:	e9 e0 fe ff ff       	jmp    ff0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	ba 25 00 00 00       	mov    $0x25,%edx
    1118:	31 f6                	xor    %esi,%esi
    111a:	e8 f1 fd ff ff       	call   f10 <putc>
    111f:	e9 cc fe ff ff       	jmp    ff0 <printf+0x30>
    1124:	90                   	nop    
    1125:	90                   	nop    
    1126:	90                   	nop    
    1127:	90                   	nop    
    1128:	90                   	nop    
    1129:	90                   	nop    
    112a:	90                   	nop    
    112b:	90                   	nop    
    112c:	90                   	nop    
    112d:	90                   	nop    
    112e:	90                   	nop    
    112f:	90                   	nop    

00001130 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1130:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1131:	8b 0d 0c 14 00 00    	mov    0x140c,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
    1137:	89 e5                	mov    %esp,%ebp
    1139:	56                   	push   %esi
    113a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    113b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    113e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1141:	39 d9                	cmp    %ebx,%ecx
    1143:	73 18                	jae    115d <free+0x2d>
    1145:	8b 11                	mov    (%ecx),%edx
    1147:	39 d3                	cmp    %edx,%ebx
    1149:	72 17                	jb     1162 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    114b:	39 d1                	cmp    %edx,%ecx
    114d:	72 08                	jb     1157 <free+0x27>
    114f:	39 d9                	cmp    %ebx,%ecx
    1151:	72 0f                	jb     1162 <free+0x32>
    1153:	39 d3                	cmp    %edx,%ebx
    1155:	72 0b                	jb     1162 <free+0x32>
    1157:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1159:	39 d9                	cmp    %ebx,%ecx
    115b:	72 e8                	jb     1145 <free+0x15>
    115d:	8b 11                	mov    (%ecx),%edx
    115f:	90                   	nop    
    1160:	eb e9                	jmp    114b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1162:	8b 73 04             	mov    0x4(%ebx),%esi
    1165:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
    1168:	39 d0                	cmp    %edx,%eax
    116a:	74 18                	je     1184 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    116c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
    116e:	8b 51 04             	mov    0x4(%ecx),%edx
    1171:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    1174:	39 d8                	cmp    %ebx,%eax
    1176:	74 20                	je     1198 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1178:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
    117a:	5b                   	pop    %ebx
    117b:	5e                   	pop    %esi
    117c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    117d:	89 0d 0c 14 00 00    	mov    %ecx,0x140c
}
    1183:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1184:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
    1187:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1189:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    118c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    118f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1191:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    1194:	39 d8                	cmp    %ebx,%eax
    1196:	75 e0                	jne    1178 <free+0x48>
    p->s.size += bp->s.size;
    1198:	03 53 04             	add    0x4(%ebx),%edx
    119b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
    119e:	8b 13                	mov    (%ebx),%edx
    11a0:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    11a2:	5b                   	pop    %ebx
    11a3:	5e                   	pop    %esi
    11a4:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    11a5:	89 0d 0c 14 00 00    	mov    %ecx,0x140c
}
    11ab:	c3                   	ret    
    11ac:	8d 74 26 00          	lea    0x0(%esi),%esi

000011b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	57                   	push   %edi
    11b4:	56                   	push   %esi
    11b5:	53                   	push   %ebx
    11b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11bc:	8b 15 0c 14 00 00    	mov    0x140c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11c2:	83 c0 07             	add    $0x7,%eax
    11c5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
    11c8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11ca:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
    11cd:	0f 84 8a 00 00 00    	je     125d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11d3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    11d5:	8b 41 04             	mov    0x4(%ecx),%eax
    11d8:	39 c3                	cmp    %eax,%ebx
    11da:	76 1a                	jbe    11f6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    11dc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
    11e3:	3b 0d 0c 14 00 00    	cmp    0x140c,%ecx
    11e9:	89 ca                	mov    %ecx,%edx
    11eb:	74 29                	je     1216 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ed:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    11ef:	8b 41 04             	mov    0x4(%ecx),%eax
    11f2:	39 c3                	cmp    %eax,%ebx
    11f4:	77 ed                	ja     11e3 <malloc+0x33>
      if(p->s.size == nunits)
    11f6:	39 c3                	cmp    %eax,%ebx
    11f8:	74 5d                	je     1257 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    11fa:	29 d8                	sub    %ebx,%eax
    11fc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
    11ff:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
    1202:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
    1205:	89 15 0c 14 00 00    	mov    %edx,0x140c
      return (void*) (p + 1);
    120b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    120e:	83 c4 0c             	add    $0xc,%esp
    1211:	5b                   	pop    %ebx
    1212:	5e                   	pop    %esi
    1213:	5f                   	pop    %edi
    1214:	5d                   	pop    %ebp
    1215:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    1216:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    121c:	89 de                	mov    %ebx,%esi
    121e:	89 f8                	mov    %edi,%eax
    1220:	76 29                	jbe    124b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 96 fc ff ff       	call   ec0 <sbrk>
  if(p == (char*) -1)
    122a:	83 f8 ff             	cmp    $0xffffffff,%eax
    122d:	74 18                	je     1247 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    122f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1232:	83 c0 08             	add    $0x8,%eax
    1235:	89 04 24             	mov    %eax,(%esp)
    1238:	e8 f3 fe ff ff       	call   1130 <free>
  return freep;
    123d:	8b 15 0c 14 00 00    	mov    0x140c,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1243:	85 d2                	test   %edx,%edx
    1245:	75 a6                	jne    11ed <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1247:	31 c0                	xor    %eax,%eax
    1249:	eb c3                	jmp    120e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    124b:	be 00 10 00 00       	mov    $0x1000,%esi
    1250:	b8 00 80 00 00       	mov    $0x8000,%eax
    1255:	eb cb                	jmp    1222 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1257:	8b 01                	mov    (%ecx),%eax
    1259:	89 02                	mov    %eax,(%edx)
    125b:	eb a8                	jmp    1205 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
    125d:	ba 04 14 00 00       	mov    $0x1404,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1262:	c7 05 0c 14 00 00 04 	movl   $0x1404,0x140c
    1269:	14 00 00 
    126c:	c7 05 04 14 00 00 04 	movl   $0x1404,0x1404
    1273:	14 00 00 
    base.s.size = 0;
    1276:	c7 05 08 14 00 00 00 	movl   $0x0,0x1408
    127d:	00 00 00 
    1280:	e9 4e ff ff ff       	jmp    11d3 <malloc+0x23>
