
_usertests:     file format elf32-i386

Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 70 44 00 00       	mov    0x4470,%eax
       b:	c7 44 24 04 f8 31 00 	movl   $0x31f8,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 15 2f 00 00       	call   2f30 <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 03 32 00 00 	movl   $0x3203,(%esp)
      2a:	e8 b9 2d 00 00       	call   2de8 <open>
  if(fd < 0){
      2f:	85 c0                	test   %eax,%eax
      31:	78 37                	js     6a <opentest+0x6a>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 95 2d 00 00       	call   2dd0 <close>
  fd = open("doesnotexist", 0);
      3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      42:	00 
      43:	c7 04 24 1b 32 00 00 	movl   $0x321b,(%esp)
      4a:	e8 99 2d 00 00       	call   2de8 <open>
  if(fd >= 0){
      4f:	85 c0                	test   %eax,%eax
      51:	79 31                	jns    84 <opentest+0x84>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
      53:	a1 70 44 00 00       	mov    0x4470,%eax
      58:	c7 44 24 04 46 32 00 	movl   $0x3246,0x4(%esp)
      5f:	00 
      60:	89 04 24             	mov    %eax,(%esp)
      63:	e8 c8 2e 00 00       	call   2f30 <printf>
}
      68:	c9                   	leave  
      69:	c3                   	ret    
  int fd;

  printf(stdout, "open test\n");
  fd = open("echo", 0);
  if(fd < 0){
    printf(stdout, "open echo failed!\n");
      6a:	a1 70 44 00 00       	mov    0x4470,%eax
      6f:	c7 44 24 04 08 32 00 	movl   $0x3208,0x4(%esp)
      76:	00 
      77:	89 04 24             	mov    %eax,(%esp)
      7a:	e8 b1 2e 00 00       	call   2f30 <printf>
    exit();
      7f:	e8 24 2d 00 00       	call   2da8 <exit>
  }
  close(fd);
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
      84:	a1 70 44 00 00       	mov    0x4470,%eax
      89:	c7 44 24 04 28 32 00 	movl   $0x3228,0x4(%esp)
      90:	00 
      91:	89 04 24             	mov    %eax,(%esp)
      94:	e8 97 2e 00 00       	call   2f30 <printf>
    exit();
      99:	e8 0a 2d 00 00       	call   2da8 <exit>
      9e:	66 90                	xchg   %ax,%ax

000000a0 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a0:	55                   	push   %ebp
      a1:	89 e5                	mov    %esp,%ebp
      a3:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
      a4:	31 db                	xor    %ebx,%ebx
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a6:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
      a9:	c7 44 24 04 54 32 00 	movl   $0x3254,0x4(%esp)
      b0:	00 
      b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b8:	e8 73 2e 00 00       	call   2f30 <printf>
      bd:	eb 13                	jmp    d2 <forktest+0x32>
      bf:	90                   	nop    

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
      c0:	74 68                	je     12a <forktest+0x8a>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
      c2:	83 c3 01             	add    $0x1,%ebx
      c5:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
      cb:	90                   	nop    
      cc:	8d 74 26 00          	lea    0x0(%esi),%esi
      d0:	74 5d                	je     12f <forktest+0x8f>
    pid = fork();
      d2:	e8 c9 2c 00 00       	call   2da0 <fork>
    if(pid < 0)
      d7:	83 f8 00             	cmp    $0x0,%eax
      da:	7d e4                	jge    c0 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      dc:	85 db                	test   %ebx,%ebx
      de:	66 90                	xchg   %ax,%ax
      e0:	7e 10                	jle    f2 <forktest+0x52>
    if(wait() < 0){
      e2:	e8 c9 2c 00 00       	call   2db0 <wait>
      e7:	85 c0                	test   %eax,%eax
      e9:	78 2b                	js     116 <forktest+0x76>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      eb:	83 eb 01             	sub    $0x1,%ebx
      ee:	66 90                	xchg   %ax,%ax
      f0:	75 f0                	jne    e2 <forktest+0x42>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
      f2:	e8 b9 2c 00 00       	call   2db0 <wait>
      f7:	83 c0 01             	add    $0x1,%eax
      fa:	75 4c                	jne    148 <forktest+0xa8>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
      fc:	c7 44 24 04 86 32 00 	movl   $0x3286,0x4(%esp)
     103:	00 
     104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     10b:	e8 20 2e 00 00       	call   2f30 <printf>
}
     110:	83 c4 14             	add    $0x14,%esp
     113:	5b                   	pop    %ebx
     114:	5d                   	pop    %ebp
     115:	c3                   	ret    
    exit();
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
     116:	c7 44 24 04 5f 32 00 	movl   $0x325f,0x4(%esp)
     11d:	00 
     11e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     125:	e8 06 2e 00 00       	call   2f30 <printf>
      exit();
     12a:	e8 79 2c 00 00       	call   2da8 <exit>
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
     12f:	c7 44 24 04 e0 3e 00 	movl   $0x3ee0,0x4(%esp)
     136:	00 
     137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     13e:	e8 ed 2d 00 00       	call   2f30 <printf>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
     143:	e8 60 2c 00 00       	call   2da8 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
     148:	c7 44 24 04 73 32 00 	movl   $0x3273,0x4(%esp)
     14f:	00 
     150:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     157:	e8 d4 2d 00 00       	call   2f30 <printf>
    exit();
     15c:	e8 47 2c 00 00       	call   2da8 <exit>
     161:	eb 0d                	jmp    170 <exitwait>
     163:	90                   	nop    
     164:	90                   	nop    
     165:	90                   	nop    
     166:	90                   	nop    
     167:	90                   	nop    
     168:	90                   	nop    
     169:	90                   	nop    
     16a:	90                   	nop    
     16b:	90                   	nop    
     16c:	90                   	nop    
     16d:	90                   	nop    
     16e:	90                   	nop    
     16f:	90                   	nop    

00000170 <exitwait>:
}

// try to find any races between exit and wait
void
exitwait(void)
{
     170:	55                   	push   %ebp
     171:	89 e5                	mov    %esp,%ebp
     173:	56                   	push   %esi
     174:	31 f6                	xor    %esi,%esi
     176:	53                   	push   %ebx
     177:	83 ec 10             	sub    $0x10,%esp
     17a:	eb 17                	jmp    193 <exitwait+0x23>
     17c:	8d 74 26 00          	lea    0x0(%esi),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     180:	74 53                	je     1d5 <exitwait+0x65>
      if(wait() != pid){
     182:	e8 29 2c 00 00       	call   2db0 <wait>
     187:	39 c3                	cmp    %eax,%ebx
     189:	75 2f                	jne    1ba <exitwait+0x4a>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     18b:	83 c6 01             	add    $0x1,%esi
     18e:	83 fe 64             	cmp    $0x64,%esi
     191:	74 47                	je     1da <exitwait+0x6a>
    pid = fork();
     193:	e8 08 2c 00 00       	call   2da0 <fork>
    if(pid < 0){
     198:	83 f8 00             	cmp    $0x0,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     19b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     19d:	7d e1                	jge    180 <exitwait+0x10>
      printf(1, "fork failed\n");
     19f:	c7 44 24 04 94 32 00 	movl   $0x3294,0x4(%esp)
     1a6:	00 
     1a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ae:	e8 7d 2d 00 00       	call   2f30 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1b3:	83 c4 10             	add    $0x10,%esp
     1b6:	5b                   	pop    %ebx
     1b7:	5e                   	pop    %esi
     1b8:	5d                   	pop    %ebp
     1b9:	c3                   	ret    
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
     1ba:	c7 44 24 04 a1 32 00 	movl   $0x32a1,0x4(%esp)
     1c1:	00 
     1c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c9:	e8 62 2d 00 00       	call   2f30 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1ce:	83 c4 10             	add    $0x10,%esp
     1d1:	5b                   	pop    %ebx
     1d2:	5e                   	pop    %esi
     1d3:	5d                   	pop    %ebp
     1d4:	c3                   	ret    
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
        return;
      }
    } else {
      exit();
     1d5:	e8 ce 2b 00 00       	call   2da8 <exit>
    }
  }
  printf(1, "exitwait ok\n");
     1da:	c7 44 24 04 b1 32 00 	movl   $0x32b1,0x4(%esp)
     1e1:	00 
     1e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e9:	e8 42 2d 00 00       	call   2f30 <printf>
}
     1ee:	83 c4 10             	add    $0x10,%esp
     1f1:	5b                   	pop    %ebx
     1f2:	5e                   	pop    %esi
     1f3:	5d                   	pop    %ebp
     1f4:	c3                   	ret    
     1f5:	8d 74 26 00          	lea    0x0(%esi),%esi
     1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000200 <fourteen>:
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	83 ec 08             	sub    $0x8,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
     206:	c7 44 24 04 be 32 00 	movl   $0x32be,0x4(%esp)
     20d:	00 
     20e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     215:	e8 16 2d 00 00       	call   2f30 <printf>

  if(mkdir("12345678901234") != 0){
     21a:	c7 04 24 f9 32 00 00 	movl   $0x32f9,(%esp)
     221:	e8 ea 2b 00 00       	call   2e10 <mkdir>
     226:	85 c0                	test   %eax,%eax
     228:	0f 85 9a 00 00 00    	jne    2c8 <fourteen+0xc8>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
     22e:	c7 04 24 04 3f 00 00 	movl   $0x3f04,(%esp)
     235:	e8 d6 2b 00 00       	call   2e10 <mkdir>
     23a:	85 c0                	test   %eax,%eax
     23c:	0f 85 9f 00 00 00    	jne    2e1 <fourteen+0xe1>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     242:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     249:	00 
     24a:	c7 04 24 54 3f 00 00 	movl   $0x3f54,(%esp)
     251:	e8 92 2b 00 00       	call   2de8 <open>
  if(fd < 0){
     256:	85 c0                	test   %eax,%eax
     258:	0f 88 9c 00 00 00    	js     2fa <fourteen+0xfa>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
     25e:	89 04 24             	mov    %eax,(%esp)
     261:	e8 6a 2b 00 00       	call   2dd0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     266:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     26d:	00 
     26e:	c7 04 24 c4 3f 00 00 	movl   $0x3fc4,(%esp)
     275:	e8 6e 2b 00 00       	call   2de8 <open>
  if(fd < 0){
     27a:	85 c0                	test   %eax,%eax
     27c:	0f 88 91 00 00 00    	js     313 <fourteen+0x113>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 46 2b 00 00       	call   2dd0 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
     28a:	c7 04 24 ea 32 00 00 	movl   $0x32ea,(%esp)
     291:	e8 7a 2b 00 00       	call   2e10 <mkdir>
     296:	85 c0                	test   %eax,%eax
     298:	0f 84 8e 00 00 00    	je     32c <fourteen+0x12c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
     29e:	c7 04 24 60 40 00 00 	movl   $0x4060,(%esp)
     2a5:	e8 66 2b 00 00       	call   2e10 <mkdir>
     2aa:	85 c0                	test   %eax,%eax
     2ac:	0f 84 93 00 00 00    	je     345 <fourteen+0x145>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
     2b2:	c7 44 24 04 08 33 00 	movl   $0x3308,0x4(%esp)
     2b9:	00 
     2ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c1:	e8 6a 2c 00 00       	call   2f30 <printf>
}
     2c6:	c9                   	leave  
     2c7:	c3                   	ret    

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
     2c8:	c7 44 24 04 cd 32 00 	movl   $0x32cd,0x4(%esp)
     2cf:	00 
     2d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2d7:	e8 54 2c 00 00       	call   2f30 <printf>
    exit();
     2dc:	e8 c7 2a 00 00       	call   2da8 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
     2e1:	c7 44 24 04 24 3f 00 	movl   $0x3f24,0x4(%esp)
     2e8:	00 
     2e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2f0:	e8 3b 2c 00 00       	call   2f30 <printf>
    exit();
     2f5:	e8 ae 2a 00 00       	call   2da8 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
     2fa:	c7 44 24 04 84 3f 00 	movl   $0x3f84,0x4(%esp)
     301:	00 
     302:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     309:	e8 22 2c 00 00       	call   2f30 <printf>
    exit();
     30e:	e8 95 2a 00 00       	call   2da8 <exit>
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
     313:	c7 44 24 04 f4 3f 00 	movl   $0x3ff4,0x4(%esp)
     31a:	00 
     31b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     322:	e8 09 2c 00 00       	call   2f30 <printf>
    exit();
     327:	e8 7c 2a 00 00       	call   2da8 <exit>
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
     32c:	c7 44 24 04 30 40 00 	movl   $0x4030,0x4(%esp)
     333:	00 
     334:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     33b:	e8 f0 2b 00 00       	call   2f30 <printf>
    exit();
     340:	e8 63 2a 00 00       	call   2da8 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
     345:	c7 44 24 04 80 40 00 	movl   $0x4080,0x4(%esp)
     34c:	00 
     34d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     354:	e8 d7 2b 00 00       	call   2f30 <printf>
    exit();
     359:	e8 4a 2a 00 00       	call   2da8 <exit>
     35e:	66 90                	xchg   %ax,%ax

00000360 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
  int i, fd;

  printf(1, "empty file name\n");
     364:	31 db                	xor    %ebx,%ebx
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     366:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(1, "empty file name\n");
     369:	c7 44 24 04 15 33 00 	movl   $0x3315,0x4(%esp)
     370:	00 
     371:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     378:	e8 b3 2b 00 00       	call   2f30 <printf>
     37d:	8d 76 00             	lea    0x0(%esi),%esi

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
     380:	c7 04 24 26 33 00 00 	movl   $0x3326,(%esp)
     387:	e8 84 2a 00 00       	call   2e10 <mkdir>
     38c:	85 c0                	test   %eax,%eax
     38e:	0f 85 b2 00 00 00    	jne    446 <iref+0xe6>
      printf(1, "mkdir irefd failed\n");
      exit();
    }
    if(chdir("irefd") != 0){
     394:	c7 04 24 26 33 00 00 	movl   $0x3326,(%esp)
     39b:	e8 78 2a 00 00       	call   2e18 <chdir>
     3a0:	85 c0                	test   %eax,%eax
     3a2:	0f 85 b7 00 00 00    	jne    45f <iref+0xff>
      printf(1, "chdir irefd failed\n");
      exit();
    }

    mkdir("");
     3a8:	c7 04 24 d7 3d 00 00 	movl   $0x3dd7,(%esp)
     3af:	e8 5c 2a 00 00       	call   2e10 <mkdir>
    link("README", "");
     3b4:	c7 44 24 04 d7 3d 00 	movl   $0x3dd7,0x4(%esp)
     3bb:	00 
     3bc:	c7 04 24 54 33 00 00 	movl   $0x3354,(%esp)
     3c3:	e8 40 2a 00 00       	call   2e08 <link>
    fd = open("", O_CREATE);
     3c8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     3cf:	00 
     3d0:	c7 04 24 d7 3d 00 00 	movl   $0x3dd7,(%esp)
     3d7:	e8 0c 2a 00 00       	call   2de8 <open>
    if(fd >= 0)
     3dc:	85 c0                	test   %eax,%eax
     3de:	78 08                	js     3e8 <iref+0x88>
      close(fd);
     3e0:	89 04 24             	mov    %eax,(%esp)
     3e3:	e8 e8 29 00 00       	call   2dd0 <close>
    fd = open("xx", O_CREATE);
     3e8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     3ef:	00 
     3f0:	c7 04 24 c6 38 00 00 	movl   $0x38c6,(%esp)
     3f7:	e8 ec 29 00 00       	call   2de8 <open>
    if(fd >= 0)
     3fc:	85 c0                	test   %eax,%eax
     3fe:	78 08                	js     408 <iref+0xa8>
      close(fd);
     400:	89 04 24             	mov    %eax,(%esp)
     403:	e8 c8 29 00 00       	call   2dd0 <close>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     408:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
     40b:	c7 04 24 c6 38 00 00 	movl   $0x38c6,(%esp)
     412:	e8 e1 29 00 00       	call   2df8 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     417:	83 fb 33             	cmp    $0x33,%ebx
     41a:	0f 85 60 ff ff ff    	jne    380 <iref+0x20>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
     420:	c7 04 24 5b 33 00 00 	movl   $0x335b,(%esp)
     427:	e8 ec 29 00 00       	call   2e18 <chdir>
  printf(1, "empty file name OK\n");
     42c:	c7 44 24 04 5d 33 00 	movl   $0x335d,0x4(%esp)
     433:	00 
     434:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     43b:	e8 f0 2a 00 00       	call   2f30 <printf>
}
     440:	83 c4 14             	add    $0x14,%esp
     443:	5b                   	pop    %ebx
     444:	5d                   	pop    %ebp
     445:	c3                   	ret    
  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
     446:	c7 44 24 04 2c 33 00 	movl   $0x332c,0x4(%esp)
     44d:	00 
     44e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     455:	e8 d6 2a 00 00       	call   2f30 <printf>
      exit();
     45a:	e8 49 29 00 00       	call   2da8 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
     45f:	c7 44 24 04 40 33 00 	movl   $0x3340,0x4(%esp)
     466:	00 
     467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     46e:	e8 bd 2a 00 00       	call   2f30 <printf>
      exit();
     473:	e8 30 29 00 00       	call   2da8 <exit>
     478:	90                   	nop    
     479:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000480 <rmdot>:
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
     486:	c7 44 24 04 71 33 00 	movl   $0x3371,0x4(%esp)
     48d:	00 
     48e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     495:	e8 96 2a 00 00       	call   2f30 <printf>
  if(mkdir("dots") != 0){
     49a:	c7 04 24 7d 33 00 00 	movl   $0x337d,(%esp)
     4a1:	e8 6a 29 00 00       	call   2e10 <mkdir>
     4a6:	85 c0                	test   %eax,%eax
     4a8:	0f 85 a2 00 00 00    	jne    550 <rmdot+0xd0>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
     4ae:	c7 04 24 7d 33 00 00 	movl   $0x337d,(%esp)
     4b5:	e8 5e 29 00 00       	call   2e18 <chdir>
     4ba:	85 c0                	test   %eax,%eax
     4bc:	0f 85 a7 00 00 00    	jne    569 <rmdot+0xe9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
     4c2:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
     4c9:	e8 2a 29 00 00       	call   2df8 <unlink>
     4ce:	85 c0                	test   %eax,%eax
     4d0:	0f 84 ac 00 00 00    	je     582 <rmdot+0x102>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
     4d6:	c7 04 24 e3 37 00 00 	movl   $0x37e3,(%esp)
     4dd:	e8 16 29 00 00       	call   2df8 <unlink>
     4e2:	85 c0                	test   %eax,%eax
     4e4:	0f 84 b1 00 00 00    	je     59b <rmdot+0x11b>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
     4ea:	c7 04 24 5b 33 00 00 	movl   $0x335b,(%esp)
     4f1:	e8 22 29 00 00       	call   2e18 <chdir>
     4f6:	85 c0                	test   %eax,%eax
     4f8:	0f 85 b6 00 00 00    	jne    5b4 <rmdot+0x134>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
     4fe:	c7 04 24 d5 33 00 00 	movl   $0x33d5,(%esp)
     505:	e8 ee 28 00 00       	call   2df8 <unlink>
     50a:	85 c0                	test   %eax,%eax
     50c:	0f 84 bb 00 00 00    	je     5cd <rmdot+0x14d>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
     512:	c7 04 24 f3 33 00 00 	movl   $0x33f3,(%esp)
     519:	e8 da 28 00 00       	call   2df8 <unlink>
     51e:	85 c0                	test   %eax,%eax
     520:	0f 84 c0 00 00 00    	je     5e6 <rmdot+0x166>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
     526:	c7 04 24 7d 33 00 00 	movl   $0x337d,(%esp)
     52d:	e8 c6 28 00 00       	call   2df8 <unlink>
     532:	85 c0                	test   %eax,%eax
     534:	0f 85 c5 00 00 00    	jne    5ff <rmdot+0x17f>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
     53a:	c7 44 24 04 28 34 00 	movl   $0x3428,0x4(%esp)
     541:	00 
     542:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     549:	e8 e2 29 00 00       	call   2f30 <printf>
}
     54e:	c9                   	leave  
     54f:	c3                   	ret    
void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
     550:	c7 44 24 04 82 33 00 	movl   $0x3382,0x4(%esp)
     557:	00 
     558:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     55f:	e8 cc 29 00 00       	call   2f30 <printf>
    exit();
     564:	e8 3f 28 00 00       	call   2da8 <exit>
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
     569:	c7 44 24 04 95 33 00 	movl   $0x3395,0x4(%esp)
     570:	00 
     571:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     578:	e8 b3 29 00 00       	call   2f30 <printf>
    exit();
     57d:	e8 26 28 00 00       	call   2da8 <exit>
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
     582:	c7 44 24 04 a8 33 00 	movl   $0x33a8,0x4(%esp)
     589:	00 
     58a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     591:	e8 9a 29 00 00       	call   2f30 <printf>
    exit();
     596:	e8 0d 28 00 00       	call   2da8 <exit>
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
     59b:	c7 44 24 04 b6 33 00 	movl   $0x33b6,0x4(%esp)
     5a2:	00 
     5a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5aa:	e8 81 29 00 00       	call   2f30 <printf>
    exit();
     5af:	e8 f4 27 00 00       	call   2da8 <exit>
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
     5b4:	c7 44 24 04 c5 33 00 	movl   $0x33c5,0x4(%esp)
     5bb:	00 
     5bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5c3:	e8 68 29 00 00       	call   2f30 <printf>
    exit();
     5c8:	e8 db 27 00 00       	call   2da8 <exit>
  }
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
     5cd:	c7 44 24 04 dc 33 00 	movl   $0x33dc,0x4(%esp)
     5d4:	00 
     5d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5dc:	e8 4f 29 00 00       	call   2f30 <printf>
    exit();
     5e1:	e8 c2 27 00 00       	call   2da8 <exit>
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
     5e6:	c7 44 24 04 fb 33 00 	movl   $0x33fb,0x4(%esp)
     5ed:	00 
     5ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5f5:	e8 36 29 00 00       	call   2f30 <printf>
    exit();
     5fa:	e8 a9 27 00 00       	call   2da8 <exit>
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
     5ff:	c7 44 24 04 13 34 00 	movl   $0x3413,0x4(%esp)
     606:	00 
     607:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     60e:	e8 1d 29 00 00       	call   2f30 <printf>
    exit();
     613:	e8 90 27 00 00       	call   2da8 <exit>
     618:	90                   	nop    
     619:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000620 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
     620:	55                   	push   %ebp
     621:	89 e5                	mov    %esp,%ebp
     623:	56                   	push   %esi
     624:	53                   	push   %ebx
     625:	83 ec 20             	sub    $0x20,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
     628:	c7 44 24 04 32 34 00 	movl   $0x3432,0x4(%esp)
     62f:	00 
     630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     637:	e8 f4 28 00 00       	call   2f30 <printf>
  unlink("bd");
     63c:	c7 04 24 3f 34 00 00 	movl   $0x343f,(%esp)
     643:	e8 b0 27 00 00       	call   2df8 <unlink>

  fd = open("bd", O_CREATE);
     648:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     64f:	00 
     650:	c7 04 24 3f 34 00 00 	movl   $0x343f,(%esp)
     657:	e8 8c 27 00 00       	call   2de8 <open>
  if(fd < 0){
     65c:	85 c0                	test   %eax,%eax
     65e:	0f 88 f5 00 00 00    	js     759 <bigdir+0x139>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
     664:	89 04 24             	mov    %eax,(%esp)
     667:	31 db                	xor    %ebx,%ebx
     669:	e8 62 27 00 00       	call   2dd0 <close>
     66e:	8d 75 ee             	lea    -0x12(%ebp),%esi
     671:	eb 0b                	jmp    67e <bigdir+0x5e>

  for(i = 0; i < 500; i++){
     673:	83 c3 01             	add    $0x1,%ebx
     676:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     67c:	74 56                	je     6d4 <bigdir+0xb4>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     67e:	89 d9                	mov    %ebx,%ecx
     680:	c1 f9 1f             	sar    $0x1f,%ecx
     683:	c1 e9 1a             	shr    $0x1a,%ecx
     686:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
     689:	89 d0                	mov    %edx,%eax
    name[2] = '0' + (i % 64);
     68b:	83 e2 3f             	and    $0x3f,%edx
     68e:	29 ca                	sub    %ecx,%edx
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     690:	c1 f8 06             	sar    $0x6,%eax
    name[2] = '0' + (i % 64);
     693:	83 c2 30             	add    $0x30,%edx
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     696:	83 c0 30             	add    $0x30,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
     699:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
     69d:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     6a0:	88 55 f0             	mov    %dl,-0x10(%ebp)
    name[3] = '\0';
     6a3:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
     6a7:	89 74 24 04          	mov    %esi,0x4(%esp)
     6ab:	c7 04 24 3f 34 00 00 	movl   $0x343f,(%esp)
     6b2:	e8 51 27 00 00       	call   2e08 <link>
     6b7:	85 c0                	test   %eax,%eax
     6b9:	74 b8                	je     673 <bigdir+0x53>
      printf(1, "bigdir link failed\n");
     6bb:	c7 44 24 04 58 34 00 	movl   $0x3458,0x4(%esp)
     6c2:	00 
     6c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ca:	e8 61 28 00 00       	call   2f30 <printf>
      exit();
     6cf:	e8 d4 26 00 00       	call   2da8 <exit>
    }
  }

  unlink("bd");
     6d4:	c7 04 24 3f 34 00 00 	movl   $0x343f,(%esp)
     6db:	66 31 db             	xor    %bx,%bx
     6de:	e8 15 27 00 00       	call   2df8 <unlink>
     6e3:	eb 0b                	jmp    6f0 <bigdir+0xd0>
  for(i = 0; i < 500; i++){
     6e5:	83 c3 01             	add    $0x1,%ebx
     6e8:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     6ee:	74 4e                	je     73e <bigdir+0x11e>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     6f0:	89 d9                	mov    %ebx,%ecx
     6f2:	c1 f9 1f             	sar    $0x1f,%ecx
     6f5:	c1 e9 1a             	shr    $0x1a,%ecx
     6f8:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
     6fb:	89 d0                	mov    %edx,%eax
    name[2] = '0' + (i % 64);
     6fd:	83 e2 3f             	and    $0x3f,%edx
     700:	29 ca                	sub    %ecx,%edx
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     702:	c1 f8 06             	sar    $0x6,%eax
    name[2] = '0' + (i % 64);
     705:	83 c2 30             	add    $0x30,%edx
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     708:	83 c0 30             	add    $0x30,%eax
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
     70b:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
     70f:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     712:	88 55 f0             	mov    %dl,-0x10(%ebp)
    name[3] = '\0';
     715:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
     719:	89 34 24             	mov    %esi,(%esp)
     71c:	e8 d7 26 00 00       	call   2df8 <unlink>
     721:	85 c0                	test   %eax,%eax
     723:	74 c0                	je     6e5 <bigdir+0xc5>
      printf(1, "bigdir unlink failed");
     725:	c7 44 24 04 6c 34 00 	movl   $0x346c,0x4(%esp)
     72c:	00 
     72d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     734:	e8 f7 27 00 00       	call   2f30 <printf>
      exit();
     739:	e8 6a 26 00 00       	call   2da8 <exit>
    }
  }

  printf(1, "bigdir ok\n");
     73e:	c7 44 24 04 81 34 00 	movl   $0x3481,0x4(%esp)
     745:	00 
     746:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     74d:	e8 de 27 00 00       	call   2f30 <printf>
}
     752:	83 c4 20             	add    $0x20,%esp
     755:	5b                   	pop    %ebx
     756:	5e                   	pop    %esi
     757:	5d                   	pop    %ebp
     758:	c3                   	ret    
  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
     759:	c7 44 24 04 42 34 00 	movl   $0x3442,0x4(%esp)
     760:	00 
     761:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     768:	e8 c3 27 00 00       	call   2f30 <printf>
    exit();
     76d:	e8 36 26 00 00       	call   2da8 <exit>
     772:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
     779:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000780 <createdelete>:
}

// two processes create and delete different files in same directory
void
createdelete(void)
{
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	57                   	push   %edi
     784:	56                   	push   %esi
     785:	53                   	push   %ebx
     786:	83 ec 3c             	sub    $0x3c,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     789:	c7 44 24 04 8c 34 00 	movl   $0x348c,0x4(%esp)
     790:	00 
     791:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     798:	e8 93 27 00 00       	call   2f30 <printf>
  pid = fork();
     79d:	e8 fe 25 00 00       	call   2da0 <fork>
  if(pid < 0){
     7a2:	83 f8 00             	cmp    $0x0,%eax
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
     7a5:	89 c7                	mov    %eax,%edi
  if(pid < 0){
     7a7:	0f 8c 64 02 00 00    	jl     a11 <createdelete+0x291>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7ad:	83 f8 01             	cmp    $0x1,%eax
  name[2] = '\0';
     7b0:	be 01 00 00 00       	mov    $0x1,%esi
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7b5:	19 c0                	sbb    %eax,%eax
  name[2] = '\0';
     7b7:	31 db                	xor    %ebx,%ebx
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7b9:	83 e0 f3             	and    $0xfffffff3,%eax
     7bc:	83 c0 70             	add    $0x70,%eax
     7bf:	88 45 d4             	mov    %al,-0x2c(%ebp)
  name[2] = '\0';
     7c2:	c6 45 d6 00          	movb   $0x0,-0x2a(%ebp)
     7c6:	eb 0b                	jmp    7d3 <createdelete+0x53>
  for(i = 0; i < N; i++){
     7c8:	83 fe 13             	cmp    $0x13,%esi
     7cb:	7f 73                	jg     840 <createdelete+0xc0>
     7cd:	83 c3 01             	add    $0x1,%ebx
     7d0:	83 c6 01             	add    $0x1,%esi
    name[1] = '0' + i;
     7d3:	8d 43 30             	lea    0x30(%ebx),%eax
     7d6:	88 45 d5             	mov    %al,-0x2b(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
     7d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
     7dc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7e3:	00 
     7e4:	89 04 24             	mov    %eax,(%esp)
     7e7:	e8 fc 25 00 00       	call   2de8 <open>
    if(fd < 0){
     7ec:	85 c0                	test   %eax,%eax
     7ee:	0f 88 c4 01 00 00    	js     9b8 <createdelete+0x238>
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
     7f4:	89 04 24             	mov    %eax,(%esp)
     7f7:	e8 d4 25 00 00       	call   2dd0 <close>
    if(i > 0 && (i % 2 ) == 0){
     7fc:	85 db                	test   %ebx,%ebx
     7fe:	66 90                	xchg   %ax,%ax
     800:	74 cb                	je     7cd <createdelete+0x4d>
     802:	f6 c3 01             	test   $0x1,%bl
     805:	75 c1                	jne    7c8 <createdelete+0x48>
      name[1] = '0' + (i / 2);
     807:	89 d8                	mov    %ebx,%eax
     809:	d1 f8                	sar    %eax
     80b:	83 c0 30             	add    $0x30,%eax
      if(unlink(name) < 0){
     80e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
    if(i > 0 && (i % 2 ) == 0){
      name[1] = '0' + (i / 2);
     811:	88 45 d5             	mov    %al,-0x2b(%ebp)
      if(unlink(name) < 0){
     814:	89 14 24             	mov    %edx,(%esp)
     817:	e8 dc 25 00 00       	call   2df8 <unlink>
     81c:	85 c0                	test   %eax,%eax
     81e:	79 a8                	jns    7c8 <createdelete+0x48>
        printf(1, "unlink failed\n");
     820:	c7 44 24 04 9f 34 00 	movl   $0x349f,0x4(%esp)
     827:	00 
     828:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     82f:	e8 fc 26 00 00       	call   2f30 <printf>
        exit();
     834:	e8 6f 25 00 00       	call   2da8 <exit>
     839:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      }
    }
  }

  if(pid==0)
     840:	85 ff                	test   %edi,%edi
     842:	74 7e                	je     8c2 <createdelete+0x142>
    exit();
  else
    wait();
     844:	e8 67 25 00 00       	call   2db0 <wait>
     849:	31 db                	xor    %ebx,%ebx
     84b:	90                   	nop    
     84c:	8d 74 26 00          	lea    0x0(%esi),%esi

  for(i = 0; i < N; i++){
    name[0] = 'p';
     850:	8d 7b 30             	lea    0x30(%ebx),%edi
    name[1] = '0' + i;
     853:	89 f9                	mov    %edi,%ecx
    fd = open(name, 0);
     855:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     858:	88 4d d5             	mov    %cl,-0x2b(%ebp)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
     85b:	c6 45 d4 70          	movb   $0x70,-0x2c(%ebp)
    name[1] = '0' + i;
    fd = open(name, 0);
     85f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     866:	00 
     867:	89 04 24             	mov    %eax,(%esp)
     86a:	e8 79 25 00 00       	call   2de8 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     86f:	85 db                	test   %ebx,%ebx
     871:	0f 94 c2             	sete   %dl
     874:	83 fb 09             	cmp    $0x9,%ebx
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
     877:	89 c1                	mov    %eax,%ecx
    if((i == 0 || i >= N/2) && fd < 0){
     879:	0f 9f c0             	setg   %al
     87c:	08 c2                	or     %al,%dl
     87e:	88 55 d3             	mov    %dl,-0x2d(%ebp)
     881:	74 08                	je     88b <createdelete+0x10b>
     883:	85 c9                	test   %ecx,%ecx
     885:	0f 88 66 01 00 00    	js     9f1 <createdelete+0x271>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     88b:	8d 43 ff             	lea    -0x1(%ebx),%eax
     88e:	83 f8 08             	cmp    $0x8,%eax
     891:	0f 96 c0             	setbe  %al
     894:	89 c6                	mov    %eax,%esi
     896:	89 c8                	mov    %ecx,%eax
     898:	f7 d0                	not    %eax
     89a:	89 f2                	mov    %esi,%edx
     89c:	c1 e8 1f             	shr    $0x1f,%eax
     89f:	84 d2                	test   %dl,%dl
     8a1:	74 24                	je     8c7 <createdelete+0x147>
     8a3:	84 c0                	test   %al,%al
     8a5:	74 2c                	je     8d3 <createdelete+0x153>
      printf(1, "oops createdelete %s did exist\n", name);
     8a7:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
     8aa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     8ae:	c7 44 24 04 d8 40 00 	movl   $0x40d8,0x4(%esp)
     8b5:	00 
     8b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8bd:	e8 6e 26 00 00       	call   2f30 <printf>
      exit();
     8c2:	e8 e1 24 00 00       	call   2da8 <exit>
    }
    if(fd >= 0)
     8c7:	84 c0                	test   %al,%al
     8c9:	74 08                	je     8d3 <createdelete+0x153>
      close(fd);
     8cb:	89 0c 24             	mov    %ecx,(%esp)
     8ce:	e8 fd 24 00 00       	call   2dd0 <close>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
     8d3:	8d 55 d4             	lea    -0x2c(%ebp),%edx
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
    name[1] = '0' + i;
     8d6:	89 f8                	mov    %edi,%eax
    fd = open(name, 0);
     8d8:	89 14 24             	mov    %edx,(%esp)
      exit();
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
     8db:	c6 45 d4 63          	movb   $0x63,-0x2c(%ebp)
    name[1] = '0' + i;
     8df:	88 45 d5             	mov    %al,-0x2b(%ebp)
    fd = open(name, 0);
     8e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8e9:	00 
     8ea:	e8 f9 24 00 00       	call   2de8 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     8ef:	80 7d d3 00          	cmpb   $0x0,-0x2d(%ebp)
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
     8f3:	89 c2                	mov    %eax,%edx
    if((i == 0 || i >= N/2) && fd < 0){
     8f5:	74 08                	je     8ff <createdelete+0x17f>
     8f7:	85 c0                	test   %eax,%eax
     8f9:	0f 88 d2 00 00 00    	js     9d1 <createdelete+0x251>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     8ff:	89 d0                	mov    %edx,%eax
     901:	89 f1                	mov    %esi,%ecx
     903:	f7 d0                	not    %eax
     905:	c1 e8 1f             	shr    $0x1f,%eax
     908:	84 c9                	test   %cl,%cl
     90a:	74 24                	je     930 <createdelete+0x1b0>
     90c:	84 c0                	test   %al,%al
     90e:	74 30                	je     940 <createdelete+0x1c0>
      printf(1, "oops createdelete %s did exist\n", name);
     910:	8d 45 d4             	lea    -0x2c(%ebp),%eax
     913:	89 44 24 08          	mov    %eax,0x8(%esp)
     917:	c7 44 24 04 d8 40 00 	movl   $0x40d8,0x4(%esp)
     91e:	00 
     91f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     926:	e8 05 26 00 00       	call   2f30 <printf>
      exit();
     92b:	e8 78 24 00 00       	call   2da8 <exit>
    }
    if(fd >= 0)
     930:	84 c0                	test   %al,%al
     932:	74 0c                	je     940 <createdelete+0x1c0>
      close(fd);
     934:	89 14 24             	mov    %edx,(%esp)
     937:	e8 94 24 00 00       	call   2dd0 <close>
     93c:	8d 74 26 00          	lea    0x0(%esi),%esi
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
     940:	83 c3 01             	add    $0x1,%ebx
     943:	83 fb 14             	cmp    $0x14,%ebx
     946:	0f 85 04 ff ff ff    	jne    850 <createdelete+0xd0>
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
     94c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
    name[0] = 'c';
    unlink(name);
     94f:	b3 01                	mov    $0x1,%bl
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
     951:	89 14 24             	mov    %edx,(%esp)
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
     954:	c6 45 d4 70          	movb   $0x70,-0x2c(%ebp)
    name[1] = '0' + i;
     958:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
    unlink(name);
     95c:	e8 97 24 00 00       	call   2df8 <unlink>
    name[0] = 'c';
    unlink(name);
     961:	8d 4d d4             	lea    -0x2c(%ebp),%ecx

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
    name[0] = 'c';
     964:	c6 45 d4 63          	movb   $0x63,-0x2c(%ebp)
    unlink(name);
     968:	89 0c 24             	mov    %ecx,(%esp)
     96b:	e8 88 24 00 00       	call   2df8 <unlink>
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     970:	8d 43 30             	lea    0x30(%ebx),%eax
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
     973:	83 c3 01             	add    $0x1,%ebx
    name[0] = 'p';
    name[1] = '0' + i;
     976:	88 45 d5             	mov    %al,-0x2b(%ebp)
    unlink(name);
     979:	8d 45 d4             	lea    -0x2c(%ebp),%eax
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
     97c:	c6 45 d4 70          	movb   $0x70,-0x2c(%ebp)
    name[1] = '0' + i;
    unlink(name);
     980:	89 04 24             	mov    %eax,(%esp)
     983:	e8 70 24 00 00       	call   2df8 <unlink>
    name[0] = 'c';
    unlink(name);
     988:	8d 55 d4             	lea    -0x2c(%ebp),%edx

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    unlink(name);
    name[0] = 'c';
     98b:	c6 45 d4 63          	movb   $0x63,-0x2c(%ebp)
    unlink(name);
     98f:	89 14 24             	mov    %edx,(%esp)
     992:	e8 61 24 00 00       	call   2df8 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
     997:	83 fb 14             	cmp    $0x14,%ebx
     99a:	75 d4                	jne    970 <createdelete+0x1f0>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
     99c:	c7 44 24 04 ae 34 00 	movl   $0x34ae,0x4(%esp)
     9a3:	00 
     9a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9ab:	e8 80 25 00 00       	call   2f30 <printf>
}
     9b0:	83 c4 3c             	add    $0x3c,%esp
     9b3:	5b                   	pop    %ebx
     9b4:	5e                   	pop    %esi
     9b5:	5f                   	pop    %edi
     9b6:	5d                   	pop    %ebp
     9b7:	c3                   	ret    
  name[2] = '\0';
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "create failed\n");
     9b8:	c7 44 24 04 49 34 00 	movl   $0x3449,0x4(%esp)
     9bf:	00 
     9c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c7:	e8 64 25 00 00       	call   2f30 <printf>
      exit();
     9cc:	e8 d7 23 00 00       	call   2da8 <exit>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     9d1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
     9d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     9d8:	c7 44 24 04 b4 40 00 	movl   $0x40b4,0x4(%esp)
     9df:	00 
     9e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9e7:	e8 44 25 00 00       	call   2f30 <printf>
      exit();
     9ec:	e8 b7 23 00 00       	call   2da8 <exit>
  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     9f1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
     9f4:	89 54 24 08          	mov    %edx,0x8(%esp)
     9f8:	c7 44 24 04 b4 40 00 	movl   $0x40b4,0x4(%esp)
     9ff:	00 
     a00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a07:	e8 24 25 00 00       	call   2f30 <printf>
     a0c:	e9 b1 fe ff ff       	jmp    8c2 <createdelete+0x142>
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
     a11:	c7 44 24 04 94 32 00 	movl   $0x3294,0x4(%esp)
     a18:	00 
     a19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a20:	e8 0b 25 00 00       	call   2f30 <printf>
    exit();
     a25:	e8 7e 23 00 00       	call   2da8 <exit>
     a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a30 <dirtest>:
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
     a30:	55                   	push   %ebp
     a31:	89 e5                	mov    %esp,%ebp
     a33:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     a36:	a1 70 44 00 00       	mov    0x4470,%eax
     a3b:	c7 44 24 04 bf 34 00 	movl   $0x34bf,0x4(%esp)
     a42:	00 
     a43:	89 04 24             	mov    %eax,(%esp)
     a46:	e8 e5 24 00 00       	call   2f30 <printf>

  if(mkdir("dir0") < 0) {
     a4b:	c7 04 24 cb 34 00 00 	movl   $0x34cb,(%esp)
     a52:	e8 b9 23 00 00       	call   2e10 <mkdir>
     a57:	85 c0                	test   %eax,%eax
     a59:	78 47                	js     aa2 <dirtest+0x72>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0) {
     a5b:	c7 04 24 cb 34 00 00 	movl   $0x34cb,(%esp)
     a62:	e8 b1 23 00 00       	call   2e18 <chdir>
     a67:	85 c0                	test   %eax,%eax
     a69:	78 51                	js     abc <dirtest+0x8c>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0) {
     a6b:	c7 04 24 e3 37 00 00 	movl   $0x37e3,(%esp)
     a72:	e8 a1 23 00 00       	call   2e18 <chdir>
     a77:	85 c0                	test   %eax,%eax
     a79:	78 5b                	js     ad6 <dirtest+0xa6>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0) {
     a7b:	c7 04 24 cb 34 00 00 	movl   $0x34cb,(%esp)
     a82:	e8 71 23 00 00       	call   2df8 <unlink>
     a87:	85 c0                	test   %eax,%eax
     a89:	78 65                	js     af0 <dirtest+0xc0>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test\n");
     a8b:	a1 70 44 00 00       	mov    0x4470,%eax
     a90:	c7 44 24 04 bf 34 00 	movl   $0x34bf,0x4(%esp)
     a97:	00 
     a98:	89 04 24             	mov    %eax,(%esp)
     a9b:	e8 90 24 00 00       	call   2f30 <printf>
}
     aa0:	c9                   	leave  
     aa1:	c3                   	ret    
void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0) {
    printf(stdout, "mkdir failed\n");
     aa2:	a1 70 44 00 00       	mov    0x4470,%eax
     aa7:	c7 44 24 04 d0 34 00 	movl   $0x34d0,0x4(%esp)
     aae:	00 
     aaf:	89 04 24             	mov    %eax,(%esp)
     ab2:	e8 79 24 00 00       	call   2f30 <printf>
    exit();
     ab7:	e8 ec 22 00 00       	call   2da8 <exit>
  }

  if(chdir("dir0") < 0) {
    printf(stdout, "chdir dir0 failed\n");
     abc:	a1 70 44 00 00       	mov    0x4470,%eax
     ac1:	c7 44 24 04 de 34 00 	movl   $0x34de,0x4(%esp)
     ac8:	00 
     ac9:	89 04 24             	mov    %eax,(%esp)
     acc:	e8 5f 24 00 00       	call   2f30 <printf>
    exit();
     ad1:	e8 d2 22 00 00       	call   2da8 <exit>
  }

  if(chdir("..") < 0) {
    printf(stdout, "chdir .. failed\n");
     ad6:	a1 70 44 00 00       	mov    0x4470,%eax
     adb:	c7 44 24 04 f1 34 00 	movl   $0x34f1,0x4(%esp)
     ae2:	00 
     ae3:	89 04 24             	mov    %eax,(%esp)
     ae6:	e8 45 24 00 00       	call   2f30 <printf>
    exit();
     aeb:	e8 b8 22 00 00       	call   2da8 <exit>
  }

  if(unlink("dir0") < 0) {
    printf(stdout, "unlink dir0 failed\n");
     af0:	a1 70 44 00 00       	mov    0x4470,%eax
     af5:	c7 44 24 04 02 35 00 	movl   $0x3502,0x4(%esp)
     afc:	00 
     afd:	89 04 24             	mov    %eax,(%esp)
     b00:	e8 2b 24 00 00       	call   2f30 <printf>
    exit();
     b05:	e8 9e 22 00 00       	call   2da8 <exit>
     b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000b10 <createtest>:
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     b10:	55                   	push   %ebp
     b11:	89 e5                	mov    %esp,%ebp
     b13:	53                   	push   %ebx
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
     b14:	bb 01 00 00 00       	mov    $0x1,%ebx
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     b19:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     b1c:	a1 70 44 00 00       	mov    0x4470,%eax
     b21:	c7 44 24 04 f8 40 00 	movl   $0x40f8,0x4(%esp)
     b28:	00 
     b29:	89 04 24             	mov    %eax,(%esp)
     b2c:	e8 ff 23 00 00       	call   2f30 <printf>

  name[0] = 'a';
     b31:	c6 05 a0 4c 00 00 61 	movb   $0x61,0x4ca0
  name[2] = '\0';
     b38:	c6 05 a2 4c 00 00 00 	movb   $0x0,0x4ca2
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b3f:	c6 05 a1 4c 00 00 30 	movb   $0x30,0x4ca1
    fd = open(name, O_CREATE|O_RDWR);
     b46:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b4d:	00 
     b4e:	c7 04 24 a0 4c 00 00 	movl   $0x4ca0,(%esp)
     b55:	e8 8e 22 00 00       	call   2de8 <open>
    close(fd);
     b5a:	89 04 24             	mov    %eax,(%esp)
     b5d:	e8 6e 22 00 00       	call   2dd0 <close>
  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b62:	8d 43 30             	lea    0x30(%ebx),%eax

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     b65:	83 c3 01             	add    $0x1,%ebx
    name[1] = '0' + i;
     b68:	a2 a1 4c 00 00       	mov    %al,0x4ca1
    fd = open(name, O_CREATE|O_RDWR);
     b6d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b74:	00 
     b75:	c7 04 24 a0 4c 00 00 	movl   $0x4ca0,(%esp)
     b7c:	e8 67 22 00 00       	call   2de8 <open>
    close(fd);
     b81:	89 04 24             	mov    %eax,(%esp)
     b84:	e8 47 22 00 00       	call   2dd0 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     b89:	83 fb 34             	cmp    $0x34,%ebx
     b8c:	75 d4                	jne    b62 <createtest+0x52>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     b8e:	c6 05 a0 4c 00 00 61 	movb   $0x61,0x4ca0
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
    unlink(name);
     b95:	b3 01                	mov    $0x1,%bl
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
     b97:	c6 05 a2 4c 00 00 00 	movb   $0x0,0x4ca2
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b9e:	c6 05 a1 4c 00 00 30 	movb   $0x30,0x4ca1
    unlink(name);
     ba5:	c7 04 24 a0 4c 00 00 	movl   $0x4ca0,(%esp)
     bac:	e8 47 22 00 00       	call   2df8 <unlink>
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     bb1:	8d 43 30             	lea    0x30(%ebx),%eax
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     bb4:	83 c3 01             	add    $0x1,%ebx
    name[1] = '0' + i;
     bb7:	a2 a1 4c 00 00       	mov    %al,0x4ca1
    unlink(name);
     bbc:	c7 04 24 a0 4c 00 00 	movl   $0x4ca0,(%esp)
     bc3:	e8 30 22 00 00       	call   2df8 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     bc8:	83 fb 34             	cmp    $0x34,%ebx
     bcb:	75 e4                	jne    bb1 <createtest+0xa1>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     bcd:	a1 70 44 00 00       	mov    0x4470,%eax
     bd2:	c7 44 24 04 20 41 00 	movl   $0x4120,0x4(%esp)
     bd9:	00 
     bda:	89 04 24             	mov    %eax,(%esp)
     bdd:	e8 4e 23 00 00       	call   2f30 <printf>
}
     be2:	83 c4 14             	add    $0x14,%esp
     be5:	5b                   	pop    %ebx
     be6:	5d                   	pop    %ebp
     be7:	c3                   	ret    
     be8:	90                   	nop    
     be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000bf0 <dirfile>:
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	53                   	push   %ebx
     bf4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "dir vs file\n");
     bf7:	c7 44 24 04 16 35 00 	movl   $0x3516,0x4(%esp)
     bfe:	00 
     bff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c06:	e8 25 23 00 00       	call   2f30 <printf>

  fd = open("dirfile", O_CREATE);
     c0b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     c12:	00 
     c13:	c7 04 24 23 35 00 00 	movl   $0x3523,(%esp)
     c1a:	e8 c9 21 00 00       	call   2de8 <open>
  if(fd < 0){
     c1f:	85 c0                	test   %eax,%eax
     c21:	0f 88 39 01 00 00    	js     d60 <dirfile+0x170>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
     c27:	89 04 24             	mov    %eax,(%esp)
     c2a:	e8 a1 21 00 00       	call   2dd0 <close>
  if(chdir("dirfile") == 0){
     c2f:	c7 04 24 23 35 00 00 	movl   $0x3523,(%esp)
     c36:	e8 dd 21 00 00       	call   2e18 <chdir>
     c3b:	85 c0                	test   %eax,%eax
     c3d:	0f 84 36 01 00 00    	je     d79 <dirfile+0x189>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
     c43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c4a:	00 
     c4b:	c7 04 24 5c 35 00 00 	movl   $0x355c,(%esp)
     c52:	e8 91 21 00 00       	call   2de8 <open>
  if(fd >= 0){
     c57:	85 c0                	test   %eax,%eax
     c59:	0f 89 e8 00 00 00    	jns    d47 <dirfile+0x157>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
     c5f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     c66:	00 
     c67:	c7 04 24 5c 35 00 00 	movl   $0x355c,(%esp)
     c6e:	e8 75 21 00 00       	call   2de8 <open>
  if(fd >= 0){
     c73:	85 c0                	test   %eax,%eax
     c75:	0f 89 cc 00 00 00    	jns    d47 <dirfile+0x157>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
     c7b:	c7 04 24 5c 35 00 00 	movl   $0x355c,(%esp)
     c82:	e8 89 21 00 00       	call   2e10 <mkdir>
     c87:	85 c0                	test   %eax,%eax
     c89:	0f 84 03 01 00 00    	je     d92 <dirfile+0x1a2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
     c8f:	c7 04 24 5c 35 00 00 	movl   $0x355c,(%esp)
     c96:	e8 5d 21 00 00       	call   2df8 <unlink>
     c9b:	85 c0                	test   %eax,%eax
     c9d:	0f 84 08 01 00 00    	je     dab <dirfile+0x1bb>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
     ca3:	c7 44 24 04 5c 35 00 	movl   $0x355c,0x4(%esp)
     caa:	00 
     cab:	c7 04 24 54 33 00 00 	movl   $0x3354,(%esp)
     cb2:	e8 51 21 00 00       	call   2e08 <link>
     cb7:	85 c0                	test   %eax,%eax
     cb9:	0f 84 05 01 00 00    	je     dc4 <dirfile+0x1d4>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
     cbf:	c7 04 24 23 35 00 00 	movl   $0x3523,(%esp)
     cc6:	e8 2d 21 00 00       	call   2df8 <unlink>
     ccb:	85 c0                	test   %eax,%eax
     ccd:	0f 85 0a 01 00 00    	jne    ddd <dirfile+0x1ed>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
     cd3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     cda:	00 
     cdb:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
     ce2:	e8 01 21 00 00       	call   2de8 <open>
  if(fd >= 0){
     ce7:	85 c0                	test   %eax,%eax
     ce9:	0f 89 07 01 00 00    	jns    df6 <dirfile+0x206>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     cef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cf6:	00 
     cf7:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
     cfe:	e8 e5 20 00 00       	call   2de8 <open>
  if(write(fd, "x", 1) > 0){
     d03:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     d0a:	00 
     d0b:	c7 44 24 04 c7 38 00 	movl   $0x38c7,0x4(%esp)
     d12:	00 
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     d13:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
     d15:	89 04 24             	mov    %eax,(%esp)
     d18:	e8 ab 20 00 00       	call   2dc8 <write>
     d1d:	85 c0                	test   %eax,%eax
     d1f:	0f 8f ea 00 00 00    	jg     e0f <dirfile+0x21f>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
     d25:	89 1c 24             	mov    %ebx,(%esp)
     d28:	e8 a3 20 00 00       	call   2dd0 <close>

  printf(1, "dir vs file OK\n");
     d2d:	c7 44 24 04 ec 35 00 	movl   $0x35ec,0x4(%esp)
     d34:	00 
     d35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d3c:	e8 ef 21 00 00       	call   2f30 <printf>
}
     d41:	83 c4 14             	add    $0x14,%esp
     d44:	5b                   	pop    %ebx
     d45:	5d                   	pop    %ebp
     d46:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
     d47:	c7 44 24 04 67 35 00 	movl   $0x3567,0x4(%esp)
     d4e:	00 
     d4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d56:	e8 d5 21 00 00       	call   2f30 <printf>
    exit();
     d5b:	e8 48 20 00 00       	call   2da8 <exit>

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    printf(1, "create dirfile failed\n");
     d60:	c7 44 24 04 2b 35 00 	movl   $0x352b,0x4(%esp)
     d67:	00 
     d68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d6f:	e8 bc 21 00 00       	call   2f30 <printf>
    exit();
     d74:	e8 2f 20 00 00       	call   2da8 <exit>
  }
  close(fd);
  if(chdir("dirfile") == 0){
    printf(1, "chdir dirfile succeeded!\n");
     d79:	c7 44 24 04 42 35 00 	movl   $0x3542,0x4(%esp)
     d80:	00 
     d81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d88:	e8 a3 21 00 00       	call   2f30 <printf>
    exit();
     d8d:	e8 16 20 00 00       	call   2da8 <exit>
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
     d92:	c7 44 24 04 85 35 00 	movl   $0x3585,0x4(%esp)
     d99:	00 
     d9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     da1:	e8 8a 21 00 00       	call   2f30 <printf>
    exit();
     da6:	e8 fd 1f 00 00       	call   2da8 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
     dab:	c7 44 24 04 a2 35 00 	movl   $0x35a2,0x4(%esp)
     db2:	00 
     db3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dba:	e8 71 21 00 00       	call   2f30 <printf>
    exit();
     dbf:	e8 e4 1f 00 00       	call   2da8 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
     dc4:	c7 44 24 04 48 41 00 	movl   $0x4148,0x4(%esp)
     dcb:	00 
     dcc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dd3:	e8 58 21 00 00       	call   2f30 <printf>
    exit();
     dd8:	e8 cb 1f 00 00       	call   2da8 <exit>
  }
  if(unlink("dirfile") != 0){
    printf(1, "unlink dirfile failed!\n");
     ddd:	c7 44 24 04 c0 35 00 	movl   $0x35c0,0x4(%esp)
     de4:	00 
     de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dec:	e8 3f 21 00 00       	call   2f30 <printf>
    exit();
     df1:	e8 b2 1f 00 00       	call   2da8 <exit>
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
     df6:	c7 44 24 04 68 41 00 	movl   $0x4168,0x4(%esp)
     dfd:	00 
     dfe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e05:	e8 26 21 00 00       	call   2f30 <printf>
    exit();
     e0a:	e8 99 1f 00 00       	call   2da8 <exit>
  }
  fd = open(".", 0);
  if(write(fd, "x", 1) > 0){
    printf(1, "write . succeeded!\n");
     e0f:	c7 44 24 04 d8 35 00 	movl   $0x35d8,0x4(%esp)
     e16:	00 
     e17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e1e:	e8 0d 21 00 00       	call   2f30 <printf>
    exit();
     e23:	e8 80 1f 00 00       	call   2da8 <exit>
     e28:	90                   	nop    
     e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000e30 <bigfile>:
  printf(1, "subdir ok\n");
}

void
bigfile(void)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	57                   	push   %edi
     e34:	56                   	push   %esi
     e35:	53                   	push   %ebx

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
     e36:	31 db                	xor    %ebx,%ebx
  printf(1, "subdir ok\n");
}

void
bigfile(void)
{
     e38:	83 ec 0c             	sub    $0xc,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
     e3b:	c7 44 24 04 fc 35 00 	movl   $0x35fc,0x4(%esp)
     e42:	00 
     e43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e4a:	e8 e1 20 00 00       	call   2f30 <printf>

  unlink("bigfile");
     e4f:	c7 04 24 18 36 00 00 	movl   $0x3618,(%esp)
     e56:	e8 9d 1f 00 00       	call   2df8 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
     e5b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e62:	00 
     e63:	c7 04 24 18 36 00 00 	movl   $0x3618,(%esp)
     e6a:	e8 79 1f 00 00       	call   2de8 <open>
  if(fd < 0){
     e6f:	85 c0                	test   %eax,%eax
  int fd, i, total, cc;

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
     e71:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     e73:	0f 88 69 01 00 00    	js     fe2 <bigfile+0x1b2>
     e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
     e80:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     e87:	00 
     e88:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     e8c:	c7 04 24 a0 44 00 00 	movl   $0x44a0,(%esp)
     e93:	e8 98 1d 00 00       	call   2c30 <memset>
    if(write(fd, buf, 600) != 600){
     e98:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     e9f:	00 
     ea0:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
     ea7:	00 
     ea8:	89 34 24             	mov    %esi,(%esp)
     eab:	e8 18 1f 00 00       	call   2dc8 <write>
     eb0:	3d 58 02 00 00       	cmp    $0x258,%eax
     eb5:	0f 85 dc 00 00 00    	jne    f97 <bigfile+0x167>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
     ebb:	83 c3 01             	add    $0x1,%ebx
     ebe:	83 fb 14             	cmp    $0x14,%ebx
     ec1:	75 bd                	jne    e80 <bigfile+0x50>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
     ec3:	89 34 24             	mov    %esi,(%esp)

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
     ec6:	30 db                	xor    %bl,%bl
     ec8:	31 ff                	xor    %edi,%edi
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
     eca:	e8 01 1f 00 00       	call   2dd0 <close>

  fd = open("bigfile", 0);
     ecf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     ed6:	00 
     ed7:	c7 04 24 18 36 00 00 	movl   $0x3618,(%esp)
     ede:	e8 05 1f 00 00       	call   2de8 <open>
  if(fd < 0){
     ee3:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
     ee5:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     ee7:	79 3a                	jns    f23 <bigfile+0xf3>
     ee9:	e9 0d 01 00 00       	jmp    ffb <bigfile+0x1cb>
     eee:	66 90                	xchg   %ax,%ax
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
     ef0:	3d 2c 01 00 00       	cmp    $0x12c,%eax
     ef5:	0f 85 ce 00 00 00    	jne    fc9 <bigfile+0x199>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
     efb:	0f be 15 a0 44 00 00 	movsbl 0x44a0,%edx
     f02:	89 d8                	mov    %ebx,%eax
     f04:	c1 e8 1f             	shr    $0x1f,%eax
     f07:	01 d8                	add    %ebx,%eax
     f09:	d1 f8                	sar    %eax
     f0b:	39 c2                	cmp    %eax,%edx
     f0d:	75 6f                	jne    f7e <bigfile+0x14e>
     f0f:	0f be 05 cb 45 00 00 	movsbl 0x45cb,%eax
     f16:	39 c2                	cmp    %eax,%edx
     f18:	75 64                	jne    f7e <bigfile+0x14e>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
     f1a:	81 c7 2c 01 00 00    	add    $0x12c,%edi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
     f20:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
     f23:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
     f2a:	00 
     f2b:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
     f32:	00 
     f33:	89 34 24             	mov    %esi,(%esp)
     f36:	e8 85 1e 00 00       	call   2dc0 <read>
    if(cc < 0){
     f3b:	83 f8 00             	cmp    $0x0,%eax
     f3e:	7c 70                	jl     fb0 <bigfile+0x180>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
     f40:	75 ae                	jne    ef0 <bigfile+0xc0>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
     f42:	89 34 24             	mov    %esi,(%esp)
     f45:	e8 86 1e 00 00       	call   2dd0 <close>
  if(total != 20*600){
     f4a:	81 ff e0 2e 00 00    	cmp    $0x2ee0,%edi
     f50:	0f 85 be 00 00 00    	jne    1014 <bigfile+0x1e4>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
     f56:	c7 04 24 18 36 00 00 	movl   $0x3618,(%esp)
     f5d:	e8 96 1e 00 00       	call   2df8 <unlink>

  printf(1, "bigfile test ok\n");
     f62:	c7 44 24 04 a7 36 00 	movl   $0x36a7,0x4(%esp)
     f69:	00 
     f6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f71:	e8 ba 1f 00 00       	call   2f30 <printf>
}
     f76:	83 c4 0c             	add    $0xc,%esp
     f79:	5b                   	pop    %ebx
     f7a:	5e                   	pop    %esi
     f7b:	5f                   	pop    %edi
     f7c:	5d                   	pop    %ebp
     f7d:	c3                   	ret    
    if(cc != 300){
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
     f7e:	c7 44 24 04 74 36 00 	movl   $0x3674,0x4(%esp)
     f85:	00 
     f86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f8d:	e8 9e 1f 00 00       	call   2f30 <printf>
      exit();
     f92:	e8 11 1e 00 00       	call   2da8 <exit>
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
     f97:	c7 44 24 04 20 36 00 	movl   $0x3620,0x4(%esp)
     f9e:	00 
     f9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa6:	e8 85 1f 00 00       	call   2f30 <printf>
      exit();
     fab:	e8 f8 1d 00 00       	call   2da8 <exit>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
     fb0:	c7 44 24 04 4b 36 00 	movl   $0x364b,0x4(%esp)
     fb7:	00 
     fb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fbf:	e8 6c 1f 00 00       	call   2f30 <printf>
      exit();
     fc4:	e8 df 1d 00 00       	call   2da8 <exit>
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
     fc9:	c7 44 24 04 60 36 00 	movl   $0x3660,0x4(%esp)
     fd0:	00 
     fd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fd8:	e8 53 1f 00 00       	call   2f30 <printf>
      exit();
     fdd:	e8 c6 1d 00 00       	call   2da8 <exit>
  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
     fe2:	c7 44 24 04 0a 36 00 	movl   $0x360a,0x4(%esp)
     fe9:	00 
     fea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff1:	e8 3a 1f 00 00       	call   2f30 <printf>
    exit();
     ff6:	e8 ad 1d 00 00       	call   2da8 <exit>
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
     ffb:	c7 44 24 04 36 36 00 	movl   $0x3636,0x4(%esp)
    1002:	00 
    1003:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100a:	e8 21 1f 00 00       	call   2f30 <printf>
    exit();
    100f:	e8 94 1d 00 00       	call   2da8 <exit>
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    1014:	c7 44 24 04 8d 36 00 	movl   $0x368d,0x4(%esp)
    101b:	00 
    101c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1023:	e8 08 1f 00 00       	call   2f30 <printf>
    exit();
    1028:	e8 7b 1d 00 00       	call   2da8 <exit>
    102d:	8d 76 00             	lea    0x0(%esi),%esi

00001030 <subdir>:
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	83 ec 14             	sub    $0x14,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1037:	c7 44 24 04 b8 36 00 	movl   $0x36b8,0x4(%esp)
    103e:	00 
    103f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1046:	e8 e5 1e 00 00       	call   2f30 <printf>

  unlink("ff");
    104b:	c7 04 24 41 37 00 00 	movl   $0x3741,(%esp)
    1052:	e8 a1 1d 00 00       	call   2df8 <unlink>
  if(mkdir("dd") != 0){
    1057:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    105e:	e8 ad 1d 00 00       	call   2e10 <mkdir>
    1063:	85 c0                	test   %eax,%eax
    1065:	0f 85 f6 03 00 00    	jne    1461 <subdir+0x431>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    106b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1072:	00 
    1073:	c7 04 24 17 37 00 00 	movl   $0x3717,(%esp)
    107a:	e8 69 1d 00 00       	call   2de8 <open>
  if(fd < 0){
    107f:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1081:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1083:	0f 88 f1 03 00 00    	js     147a <subdir+0x44a>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1089:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1090:	00 
    1091:	c7 44 24 04 41 37 00 	movl   $0x3741,0x4(%esp)
    1098:	00 
    1099:	89 04 24             	mov    %eax,(%esp)
    109c:	e8 27 1d 00 00       	call   2dc8 <write>
  close(fd);
    10a1:	89 1c 24             	mov    %ebx,(%esp)
    10a4:	e8 27 1d 00 00       	call   2dd0 <close>
  
  if(unlink("dd") >= 0){
    10a9:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    10b0:	e8 43 1d 00 00       	call   2df8 <unlink>
    10b5:	85 c0                	test   %eax,%eax
    10b7:	0f 89 d6 03 00 00    	jns    1493 <subdir+0x463>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    10bd:	c7 04 24 f2 36 00 00 	movl   $0x36f2,(%esp)
    10c4:	e8 47 1d 00 00       	call   2e10 <mkdir>
    10c9:	85 c0                	test   %eax,%eax
    10cb:	0f 85 db 03 00 00    	jne    14ac <subdir+0x47c>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    10d1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10d8:	00 
    10d9:	c7 04 24 14 37 00 00 	movl   $0x3714,(%esp)
    10e0:	e8 03 1d 00 00       	call   2de8 <open>
  if(fd < 0){
    10e5:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    10e7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    10e9:	0f 88 d6 03 00 00    	js     14c5 <subdir+0x495>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    10ef:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    10f6:	00 
    10f7:	c7 44 24 04 35 37 00 	movl   $0x3735,0x4(%esp)
    10fe:	00 
    10ff:	89 04 24             	mov    %eax,(%esp)
    1102:	e8 c1 1c 00 00       	call   2dc8 <write>
  close(fd);
    1107:	89 1c 24             	mov    %ebx,(%esp)
    110a:	e8 c1 1c 00 00       	call   2dd0 <close>

  fd = open("dd/dd/../ff", 0);
    110f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1116:	00 
    1117:	c7 04 24 38 37 00 00 	movl   $0x3738,(%esp)
    111e:	e8 c5 1c 00 00       	call   2de8 <open>
  if(fd < 0){
    1123:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    1125:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1127:	0f 88 b1 03 00 00    	js     14de <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    112d:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1134:	00 
    1135:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    113c:	00 
    113d:	89 04 24             	mov    %eax,(%esp)
    1140:	e8 7b 1c 00 00       	call   2dc0 <read>
  if(cc != 2 || buf[0] != 'f'){
    1145:	83 f8 02             	cmp    $0x2,%eax
    1148:	75 09                	jne    1153 <subdir+0x123>
    114a:	80 3d a0 44 00 00 66 	cmpb   $0x66,0x44a0
    1151:	74 1d                	je     1170 <subdir+0x140>
    printf(1, "dd/dd/../ff wrong content\n");
    1153:	c7 44 24 04 5d 37 00 	movl   $0x375d,0x4(%esp)
    115a:	00 
    115b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1162:	e8 c9 1d 00 00       	call   2f30 <printf>
    exit();
    1167:	e8 3c 1c 00 00       	call   2da8 <exit>
    116c:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  close(fd);
    1170:	89 1c 24             	mov    %ebx,(%esp)
    1173:	e8 58 1c 00 00       	call   2dd0 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1178:	c7 44 24 04 78 37 00 	movl   $0x3778,0x4(%esp)
    117f:	00 
    1180:	c7 04 24 14 37 00 00 	movl   $0x3714,(%esp)
    1187:	e8 7c 1c 00 00       	call   2e08 <link>
    118c:	85 c0                	test   %eax,%eax
    118e:	0f 85 ae 03 00 00    	jne    1542 <subdir+0x512>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1194:	c7 04 24 14 37 00 00 	movl   $0x3714,(%esp)
    119b:	e8 58 1c 00 00       	call   2df8 <unlink>
    11a0:	85 c0                	test   %eax,%eax
    11a2:	0f 85 68 03 00 00    	jne    1510 <subdir+0x4e0>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    11a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11af:	00 
    11b0:	c7 04 24 14 37 00 00 	movl   $0x3714,(%esp)
    11b7:	e8 2c 1c 00 00       	call   2de8 <open>
    11bc:	85 c0                	test   %eax,%eax
    11be:	0f 89 65 03 00 00    	jns    1529 <subdir+0x4f9>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    11c4:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    11cb:	e8 48 1c 00 00       	call   2e18 <chdir>
    11d0:	85 c0                	test   %eax,%eax
    11d2:	0f 85 83 03 00 00    	jne    155b <subdir+0x52b>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    11d8:	c7 04 24 ac 37 00 00 	movl   $0x37ac,(%esp)
    11df:	e8 34 1c 00 00       	call   2e18 <chdir>
    11e4:	85 c0                	test   %eax,%eax
    11e6:	0f 85 0b 03 00 00    	jne    14f7 <subdir+0x4c7>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    11ec:	c7 04 24 d2 37 00 00 	movl   $0x37d2,(%esp)
    11f3:	e8 20 1c 00 00       	call   2e18 <chdir>
    11f8:	85 c0                	test   %eax,%eax
    11fa:	0f 85 f7 02 00 00    	jne    14f7 <subdir+0x4c7>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1200:	c7 04 24 e1 37 00 00 	movl   $0x37e1,(%esp)
    1207:	e8 0c 1c 00 00       	call   2e18 <chdir>
    120c:	85 c0                	test   %eax,%eax
    120e:	0f 85 79 03 00 00    	jne    158d <subdir+0x55d>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    121b:	00 
    121c:	c7 04 24 78 37 00 00 	movl   $0x3778,(%esp)
    1223:	e8 c0 1b 00 00       	call   2de8 <open>
  if(fd < 0){
    1228:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    122a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    122c:	0f 88 42 03 00 00    	js     1574 <subdir+0x544>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1232:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1239:	00 
    123a:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1241:	00 
    1242:	89 04 24             	mov    %eax,(%esp)
    1245:	e8 76 1b 00 00       	call   2dc0 <read>
    124a:	83 f8 02             	cmp    $0x2,%eax
    124d:	0f 85 85 03 00 00    	jne    15d8 <subdir+0x5a8>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1253:	89 1c 24             	mov    %ebx,(%esp)
    1256:	e8 75 1b 00 00       	call   2dd0 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    125b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1262:	00 
    1263:	c7 04 24 14 37 00 00 	movl   $0x3714,(%esp)
    126a:	e8 79 1b 00 00       	call   2de8 <open>
    126f:	85 c0                	test   %eax,%eax
    1271:	0f 89 48 03 00 00    	jns    15bf <subdir+0x58f>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1277:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    127e:	00 
    127f:	c7 04 24 2c 38 00 00 	movl   $0x382c,(%esp)
    1286:	e8 5d 1b 00 00       	call   2de8 <open>
    128b:	85 c0                	test   %eax,%eax
    128d:	0f 89 13 03 00 00    	jns    15a6 <subdir+0x576>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1293:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    129a:	00 
    129b:	c7 04 24 51 38 00 00 	movl   $0x3851,(%esp)
    12a2:	e8 41 1b 00 00       	call   2de8 <open>
    12a7:	85 c0                	test   %eax,%eax
    12a9:	0f 89 42 03 00 00    	jns    15f1 <subdir+0x5c1>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    12af:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    12b6:	00 
    12b7:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    12be:	e8 25 1b 00 00       	call   2de8 <open>
    12c3:	85 c0                	test   %eax,%eax
    12c5:	0f 89 d5 03 00 00    	jns    16a0 <subdir+0x670>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    12cb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12d2:	00 
    12d3:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    12da:	e8 09 1b 00 00       	call   2de8 <open>
    12df:	85 c0                	test   %eax,%eax
    12e1:	0f 89 a0 03 00 00    	jns    1687 <subdir+0x657>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    12e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    12ee:	00 
    12ef:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    12f6:	e8 ed 1a 00 00       	call   2de8 <open>
    12fb:	85 c0                	test   %eax,%eax
    12fd:	0f 89 6b 03 00 00    	jns    166e <subdir+0x63e>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1303:	c7 44 24 04 c0 38 00 	movl   $0x38c0,0x4(%esp)
    130a:	00 
    130b:	c7 04 24 2c 38 00 00 	movl   $0x382c,(%esp)
    1312:	e8 f1 1a 00 00       	call   2e08 <link>
    1317:	85 c0                	test   %eax,%eax
    1319:	0f 84 36 03 00 00    	je     1655 <subdir+0x625>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    131f:	c7 44 24 04 c0 38 00 	movl   $0x38c0,0x4(%esp)
    1326:	00 
    1327:	c7 04 24 51 38 00 00 	movl   $0x3851,(%esp)
    132e:	e8 d5 1a 00 00       	call   2e08 <link>
    1333:	85 c0                	test   %eax,%eax
    1335:	0f 84 01 03 00 00    	je     163c <subdir+0x60c>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    133b:	c7 44 24 04 78 37 00 	movl   $0x3778,0x4(%esp)
    1342:	00 
    1343:	c7 04 24 17 37 00 00 	movl   $0x3717,(%esp)
    134a:	e8 b9 1a 00 00       	call   2e08 <link>
    134f:	85 c0                	test   %eax,%eax
    1351:	0f 84 cc 02 00 00    	je     1623 <subdir+0x5f3>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1357:	c7 04 24 2c 38 00 00 	movl   $0x382c,(%esp)
    135e:	e8 ad 1a 00 00       	call   2e10 <mkdir>
    1363:	85 c0                	test   %eax,%eax
    1365:	0f 84 9f 02 00 00    	je     160a <subdir+0x5da>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    136b:	c7 04 24 51 38 00 00 	movl   $0x3851,(%esp)
    1372:	e8 99 1a 00 00       	call   2e10 <mkdir>
    1377:	85 c0                	test   %eax,%eax
    1379:	0f 84 3a 03 00 00    	je     16b9 <subdir+0x689>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    137f:	c7 04 24 78 37 00 00 	movl   $0x3778,(%esp)
    1386:	e8 85 1a 00 00       	call   2e10 <mkdir>
    138b:	85 c0                	test   %eax,%eax
    138d:	0f 84 d5 03 00 00    	je     1768 <subdir+0x738>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1393:	c7 04 24 51 38 00 00 	movl   $0x3851,(%esp)
    139a:	e8 59 1a 00 00       	call   2df8 <unlink>
    139f:	85 c0                	test   %eax,%eax
    13a1:	0f 84 a8 03 00 00    	je     174f <subdir+0x71f>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    13a7:	c7 04 24 2c 38 00 00 	movl   $0x382c,(%esp)
    13ae:	e8 45 1a 00 00       	call   2df8 <unlink>
    13b3:	85 c0                	test   %eax,%eax
    13b5:	0f 84 7b 03 00 00    	je     1736 <subdir+0x706>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    13bb:	c7 04 24 17 37 00 00 	movl   $0x3717,(%esp)
    13c2:	e8 51 1a 00 00       	call   2e18 <chdir>
    13c7:	85 c0                	test   %eax,%eax
    13c9:	0f 84 4e 03 00 00    	je     171d <subdir+0x6ed>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    13cf:	c7 04 24 c3 38 00 00 	movl   $0x38c3,(%esp)
    13d6:	e8 3d 1a 00 00       	call   2e18 <chdir>
    13db:	85 c0                	test   %eax,%eax
    13dd:	0f 84 21 03 00 00    	je     1704 <subdir+0x6d4>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    13e3:	c7 04 24 78 37 00 00 	movl   $0x3778,(%esp)
    13ea:	e8 09 1a 00 00       	call   2df8 <unlink>
    13ef:	85 c0                	test   %eax,%eax
    13f1:	0f 85 19 01 00 00    	jne    1510 <subdir+0x4e0>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    13f7:	c7 04 24 17 37 00 00 	movl   $0x3717,(%esp)
    13fe:	e8 f5 19 00 00       	call   2df8 <unlink>
    1403:	85 c0                	test   %eax,%eax
    1405:	0f 85 e0 02 00 00    	jne    16eb <subdir+0x6bb>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    140b:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    1412:	e8 e1 19 00 00       	call   2df8 <unlink>
    1417:	85 c0                	test   %eax,%eax
    1419:	0f 84 b3 02 00 00    	je     16d2 <subdir+0x6a2>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    141f:	c7 04 24 f3 36 00 00 	movl   $0x36f3,(%esp)
    1426:	e8 cd 19 00 00       	call   2df8 <unlink>
    142b:	85 c0                	test   %eax,%eax
    142d:	0f 88 67 03 00 00    	js     179a <subdir+0x76a>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1433:	c7 04 24 de 37 00 00 	movl   $0x37de,(%esp)
    143a:	e8 b9 19 00 00       	call   2df8 <unlink>
    143f:	85 c0                	test   %eax,%eax
    1441:	0f 88 3a 03 00 00    	js     1781 <subdir+0x751>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1447:	c7 44 24 04 c0 39 00 	movl   $0x39c0,0x4(%esp)
    144e:	00 
    144f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1456:	e8 d5 1a 00 00       	call   2f30 <printf>
}
    145b:	83 c4 14             	add    $0x14,%esp
    145e:	5b                   	pop    %ebx
    145f:	5d                   	pop    %ebp
    1460:	c3                   	ret    

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    1461:	c7 44 24 04 c5 36 00 	movl   $0x36c5,0x4(%esp)
    1468:	00 
    1469:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1470:	e8 bb 1a 00 00       	call   2f30 <printf>
    exit();
    1475:	e8 2e 19 00 00       	call   2da8 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/ff failed\n");
    147a:	c7 44 24 04 dd 36 00 	movl   $0x36dd,0x4(%esp)
    1481:	00 
    1482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1489:	e8 a2 1a 00 00       	call   2f30 <printf>
    exit();
    148e:	e8 15 19 00 00       	call   2da8 <exit>
  }
  write(fd, "ff", 2);
  close(fd);
  
  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1493:	c7 44 24 04 88 41 00 	movl   $0x4188,0x4(%esp)
    149a:	00 
    149b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14a2:	e8 89 1a 00 00       	call   2f30 <printf>
    exit();
    14a7:	e8 fc 18 00 00       	call   2da8 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    14ac:	c7 44 24 04 f9 36 00 	movl   $0x36f9,0x4(%esp)
    14b3:	00 
    14b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14bb:	e8 70 1a 00 00       	call   2f30 <printf>
    exit();
    14c0:	e8 e3 18 00 00       	call   2da8 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    14c5:	c7 44 24 04 1d 37 00 	movl   $0x371d,0x4(%esp)
    14cc:	00 
    14cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14d4:	e8 57 1a 00 00       	call   2f30 <printf>
    exit();
    14d9:	e8 ca 18 00 00       	call   2da8 <exit>
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    14de:	c7 44 24 04 44 37 00 	movl   $0x3744,0x4(%esp)
    14e5:	00 
    14e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ed:	e8 3e 1a 00 00       	call   2f30 <printf>
    exit();
    14f2:	e8 b1 18 00 00       	call   2da8 <exit>
  if(chdir("dd/../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    14f7:	c7 44 24 04 b8 37 00 	movl   $0x37b8,0x4(%esp)
    14fe:	00 
    14ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1506:	e8 25 1a 00 00       	call   2f30 <printf>
    exit();
    150b:	e8 98 18 00 00       	call   2da8 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    1510:	c7 44 24 04 83 37 00 	movl   $0x3783,0x4(%esp)
    1517:	00 
    1518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    151f:	e8 0c 1a 00 00       	call   2f30 <printf>
    exit();
    1524:	e8 7f 18 00 00       	call   2da8 <exit>
  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1529:	c7 44 24 04 d4 41 00 	movl   $0x41d4,0x4(%esp)
    1530:	00 
    1531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1538:	e8 f3 19 00 00       	call   2f30 <printf>
    exit();
    153d:	e8 66 18 00 00       	call   2da8 <exit>
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1542:	c7 44 24 04 b0 41 00 	movl   $0x41b0,0x4(%esp)
    1549:	00 
    154a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1551:	e8 da 19 00 00       	call   2f30 <printf>
    exit();
    1556:	e8 4d 18 00 00       	call   2da8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    printf(1, "chdir dd failed\n");
    155b:	c7 44 24 04 9b 37 00 	movl   $0x379b,0x4(%esp)
    1562:	00 
    1563:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    156a:	e8 c1 19 00 00       	call   2f30 <printf>
    exit();
    156f:	e8 34 18 00 00       	call   2da8 <exit>
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    1574:	c7 44 24 04 f9 37 00 	movl   $0x37f9,0x4(%esp)
    157b:	00 
    157c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1583:	e8 a8 19 00 00       	call   2f30 <printf>
    exit();
    1588:	e8 1b 18 00 00       	call   2da8 <exit>
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    158d:	c7 44 24 04 e6 37 00 	movl   $0x37e6,0x4(%esp)
    1594:	00 
    1595:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    159c:	e8 8f 19 00 00       	call   2f30 <printf>
    exit();
    15a1:	e8 02 18 00 00       	call   2da8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    15a6:	c7 44 24 04 35 38 00 	movl   $0x3835,0x4(%esp)
    15ad:	00 
    15ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15b5:	e8 76 19 00 00       	call   2f30 <printf>
    exit();
    15ba:	e8 e9 17 00 00       	call   2da8 <exit>
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    15bf:	c7 44 24 04 f8 41 00 	movl   $0x41f8,0x4(%esp)
    15c6:	00 
    15c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ce:	e8 5d 19 00 00       	call   2f30 <printf>
    exit();
    15d3:	e8 d0 17 00 00       	call   2da8 <exit>
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    printf(1, "read dd/dd/ffff wrong len\n");
    15d8:	c7 44 24 04 11 38 00 	movl   $0x3811,0x4(%esp)
    15df:	00 
    15e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e7:	e8 44 19 00 00       	call   2f30 <printf>
    exit();
    15ec:	e8 b7 17 00 00       	call   2da8 <exit>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    15f1:	c7 44 24 04 5a 38 00 	movl   $0x385a,0x4(%esp)
    15f8:	00 
    15f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1600:	e8 2b 19 00 00       	call   2f30 <printf>
    exit();
    1605:	e8 9e 17 00 00       	call   2da8 <exit>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    160a:	c7 44 24 04 c9 38 00 	movl   $0x38c9,0x4(%esp)
    1611:	00 
    1612:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1619:	e8 12 19 00 00       	call   2f30 <printf>
    exit();
    161e:	e8 85 17 00 00       	call   2da8 <exit>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1623:	c7 44 24 04 68 42 00 	movl   $0x4268,0x4(%esp)
    162a:	00 
    162b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1632:	e8 f9 18 00 00       	call   2f30 <printf>
    exit();
    1637:	e8 6c 17 00 00       	call   2da8 <exit>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    163c:	c7 44 24 04 44 42 00 	movl   $0x4244,0x4(%esp)
    1643:	00 
    1644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    164b:	e8 e0 18 00 00       	call   2f30 <printf>
    exit();
    1650:	e8 53 17 00 00       	call   2da8 <exit>
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    1655:	c7 44 24 04 20 42 00 	movl   $0x4220,0x4(%esp)
    165c:	00 
    165d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1664:	e8 c7 18 00 00       	call   2f30 <printf>
    exit();
    1669:	e8 3a 17 00 00       	call   2da8 <exit>
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    166e:	c7 44 24 04 a5 38 00 	movl   $0x38a5,0x4(%esp)
    1675:	00 
    1676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    167d:	e8 ae 18 00 00       	call   2f30 <printf>
    exit();
    1682:	e8 21 17 00 00       	call   2da8 <exit>
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    1687:	c7 44 24 04 8c 38 00 	movl   $0x388c,0x4(%esp)
    168e:	00 
    168f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1696:	e8 95 18 00 00       	call   2f30 <printf>
    exit();
    169b:	e8 08 17 00 00       	call   2da8 <exit>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    16a0:	c7 44 24 04 76 38 00 	movl   $0x3876,0x4(%esp)
    16a7:	00 
    16a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16af:	e8 7c 18 00 00       	call   2f30 <printf>
    exit();
    16b4:	e8 ef 16 00 00       	call   2da8 <exit>
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    16b9:	c7 44 24 04 e4 38 00 	movl   $0x38e4,0x4(%esp)
    16c0:	00 
    16c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c8:	e8 63 18 00 00       	call   2f30 <printf>
    exit();
    16cd:	e8 d6 16 00 00       	call   2da8 <exit>
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    16d2:	c7 44 24 04 8c 42 00 	movl   $0x428c,0x4(%esp)
    16d9:	00 
    16da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16e1:	e8 4a 18 00 00       	call   2f30 <printf>
    exit();
    16e6:	e8 bd 16 00 00       	call   2da8 <exit>
  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    16eb:	c7 44 24 04 84 39 00 	movl   $0x3984,0x4(%esp)
    16f2:	00 
    16f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16fa:	e8 31 18 00 00       	call   2f30 <printf>
    exit();
    16ff:	e8 a4 16 00 00       	call   2da8 <exit>
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    printf(1, "chdir dd/xx succeeded!\n");
    1704:	c7 44 24 04 6c 39 00 	movl   $0x396c,0x4(%esp)
    170b:	00 
    170c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1713:	e8 18 18 00 00       	call   2f30 <printf>
    exit();
    1718:	e8 8b 16 00 00       	call   2da8 <exit>
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    171d:	c7 44 24 04 54 39 00 	movl   $0x3954,0x4(%esp)
    1724:	00 
    1725:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    172c:	e8 ff 17 00 00       	call   2f30 <printf>
    exit();
    1731:	e8 72 16 00 00       	call   2da8 <exit>
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    1736:	c7 44 24 04 38 39 00 	movl   $0x3938,0x4(%esp)
    173d:	00 
    173e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1745:	e8 e6 17 00 00       	call   2f30 <printf>
    exit();
    174a:	e8 59 16 00 00       	call   2da8 <exit>
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    174f:	c7 44 24 04 1c 39 00 	movl   $0x391c,0x4(%esp)
    1756:	00 
    1757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    175e:	e8 cd 17 00 00       	call   2f30 <printf>
    exit();
    1763:	e8 40 16 00 00       	call   2da8 <exit>
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    1768:	c7 44 24 04 ff 38 00 	movl   $0x38ff,0x4(%esp)
    176f:	00 
    1770:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1777:	e8 b4 17 00 00       	call   2f30 <printf>
    exit();
    177c:	e8 27 16 00 00       	call   2da8 <exit>
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    1781:	c7 44 24 04 ae 39 00 	movl   $0x39ae,0x4(%esp)
    1788:	00 
    1789:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1790:	e8 9b 17 00 00       	call   2f30 <printf>
    exit();
    1795:	e8 0e 16 00 00       	call   2da8 <exit>
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    179a:	c7 44 24 04 99 39 00 	movl   $0x3999,0x4(%esp)
    17a1:	00 
    17a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17a9:	e8 82 17 00 00       	call   2f30 <printf>
    exit();
    17ae:	e8 f5 15 00 00       	call   2da8 <exit>
    17b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    17b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000017c0 <concreate>:
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    17c0:	55                   	push   %ebp
    17c1:	89 e5                	mov    %esp,%ebp
    17c3:	57                   	push   %edi
    17c4:	56                   	push   %esi
    17c5:	53                   	push   %ebx
    char name[14];
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
    17c6:	31 db                	xor    %ebx,%ebx
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    17c8:	83 ec 5c             	sub    $0x5c,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    17cb:	c7 44 24 04 cb 39 00 	movl   $0x39cb,0x4(%esp)
    17d2:	00 
    17d3:	8d 7d f1             	lea    -0xf(%ebp),%edi
    17d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17dd:	e8 4e 17 00 00       	call   2f30 <printf>
  file[0] = 'C';
    17e2:	c6 45 f1 43          	movb   $0x43,-0xf(%ebp)
  file[2] = '\0';
    17e6:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    17ea:	eb 53                	jmp    183f <concreate+0x7f>
    17ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    17f0:	89 d8                	mov    %ebx,%eax
    17f2:	ba 56 55 55 55       	mov    $0x55555556,%edx
    17f7:	f7 ea                	imul   %edx
    17f9:	89 d8                	mov    %ebx,%eax
    17fb:	c1 f8 1f             	sar    $0x1f,%eax
    17fe:	29 c2                	sub    %eax,%edx
    1800:	89 d8                	mov    %ebx,%eax
    1802:	8d 14 52             	lea    (%edx,%edx,2),%edx
    1805:	29 d0                	sub    %edx,%eax
    1807:	83 e8 01             	sub    $0x1,%eax
    180a:	74 7f                	je     188b <concreate+0xcb>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    180c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1813:	00 
    1814:	89 3c 24             	mov    %edi,(%esp)
    1817:	e8 cc 15 00 00       	call   2de8 <open>
      if(fd < 0){
    181c:	85 c0                	test   %eax,%eax
    181e:	0f 88 be 01 00 00    	js     19e2 <concreate+0x222>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1824:	89 04 24             	mov    %eax,(%esp)
    1827:	e8 a4 15 00 00       	call   2dd0 <close>
    }
    if(pid == 0)
    182c:	85 f6                	test   %esi,%esi
    182e:	66 90                	xchg   %ax,%ax
    1830:	74 54                	je     1886 <concreate+0xc6>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1832:	83 c3 01             	add    $0x1,%ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1835:	e8 76 15 00 00       	call   2db0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    183a:	83 fb 28             	cmp    $0x28,%ebx
    183d:	74 69                	je     18a8 <concreate+0xe8>
    file[1] = '0' + i;
    183f:	8d 43 30             	lea    0x30(%ebx),%eax
    1842:	88 45 f2             	mov    %al,-0xe(%ebp)
    unlink(file);
    1845:	89 3c 24             	mov    %edi,(%esp)
    1848:	e8 ab 15 00 00       	call   2df8 <unlink>
    pid = fork();
    184d:	e8 4e 15 00 00       	call   2da0 <fork>
    if(pid && (i % 3) == 1){
    1852:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    1854:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    1856:	75 98                	jne    17f0 <concreate+0x30>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    1858:	89 d8                	mov    %ebx,%eax
    185a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    185f:	f7 ea                	imul   %edx
    1861:	89 d8                	mov    %ebx,%eax
    1863:	c1 f8 1f             	sar    $0x1f,%eax
    1866:	d1 fa                	sar    %edx
    1868:	29 c2                	sub    %eax,%edx
    186a:	89 d8                	mov    %ebx,%eax
    186c:	8d 14 92             	lea    (%edx,%edx,4),%edx
    186f:	29 d0                	sub    %edx,%eax
    1871:	83 e8 01             	sub    $0x1,%eax
    1874:	75 96                	jne    180c <concreate+0x4c>
      link("C0", file);
    1876:	89 7c 24 04          	mov    %edi,0x4(%esp)
    187a:	c7 04 24 db 39 00 00 	movl   $0x39db,(%esp)
    1881:	e8 82 15 00 00       	call   2e08 <link>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
    1886:	e8 1d 15 00 00       	call   2da8 <exit>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    188b:	83 c3 01             	add    $0x1,%ebx
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    188e:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1892:	c7 04 24 db 39 00 00 	movl   $0x39db,(%esp)
    1899:	e8 6a 15 00 00       	call   2e08 <link>
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    189e:	e8 0d 15 00 00       	call   2db0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    18a3:	83 fb 28             	cmp    $0x28,%ebx
    18a6:	75 97                	jne    183f <concreate+0x7f>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    18a8:	8d 45 b8             	lea    -0x48(%ebp),%eax
    18ab:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    18b2:	00 
    18b3:	8d 75 e0             	lea    -0x20(%ebp),%esi
    18b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18bd:	00 
    18be:	89 04 24             	mov    %eax,(%esp)
    18c1:	e8 6a 13 00 00       	call   2c30 <memset>
  fd = open(".", 0);
    18c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18cd:	00 
    18ce:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    18d5:	e8 0e 15 00 00       	call   2de8 <open>
    18da:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
    18e1:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    18e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18ea:	00 
    18eb:	89 74 24 04          	mov    %esi,0x4(%esp)
    18ef:	89 1c 24             	mov    %ebx,(%esp)
    18f2:	e8 c9 14 00 00       	call   2dc0 <read>
    18f7:	85 c0                	test   %eax,%eax
    18f9:	7e 3d                	jle    1938 <concreate+0x178>
    if(de.inum == 0)
    18fb:	66 83 7d e0 00       	cmpw   $0x0,-0x20(%ebp)
    1900:	74 e1                	je     18e3 <concreate+0x123>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1902:	80 7d e2 43          	cmpb   $0x43,-0x1e(%ebp)
    1906:	75 db                	jne    18e3 <concreate+0x123>
    1908:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
    190c:	8d 74 26 00          	lea    0x0(%esi),%esi
    1910:	75 d1                	jne    18e3 <concreate+0x123>
      i = de.name[1] - '0';
    1912:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
    1916:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1919:	83 f8 27             	cmp    $0x27,%eax
    191c:	0f 87 16 01 00 00    	ja     1a38 <concreate+0x278>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1922:	80 7c 05 b8 00       	cmpb   $0x0,-0x48(%ebp,%eax,1)
    1927:	0f 85 eb 00 00 00    	jne    1a18 <concreate+0x258>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    192d:	c6 44 05 b8 01       	movb   $0x1,-0x48(%ebp,%eax,1)
      n++;
    1932:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
    1936:	eb ab                	jmp    18e3 <concreate+0x123>
    }
  }
  close(fd);
    1938:	89 1c 24             	mov    %ebx,(%esp)

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
    193b:	31 f6                	xor    %esi,%esi
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    193d:	e8 8e 14 00 00       	call   2dd0 <close>

  if(n != 40){
    1942:	83 7d b0 28          	cmpl   $0x28,-0x50(%ebp)
    1946:	74 2d                	je     1975 <concreate+0x1b5>
    1948:	e9 0b 01 00 00       	jmp    1a58 <concreate+0x298>
    194d:	8d 76 00             	lea    0x0(%esi),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1950:	83 e8 01             	sub    $0x1,%eax
    1953:	74 6b                	je     19c0 <concreate+0x200>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
      close(fd);
    } else {
      unlink(file);
    1955:	89 3c 24             	mov    %edi,(%esp)
    1958:	e8 9b 14 00 00       	call   2df8 <unlink>
    195d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    if(pid == 0)
    1960:	85 db                	test   %ebx,%ebx
    1962:	0f 84 1e ff ff ff    	je     1886 <concreate+0xc6>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1968:	83 c6 01             	add    $0x1,%esi
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    196b:	e8 40 14 00 00       	call   2db0 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1970:	83 fe 28             	cmp    $0x28,%esi
    1973:	74 51                	je     19c6 <concreate+0x206>
    file[1] = '0' + i;
    1975:	8d 46 30             	lea    0x30(%esi),%eax
    1978:	88 45 f2             	mov    %al,-0xe(%ebp)
    pid = fork();
    197b:	e8 20 14 00 00       	call   2da0 <fork>
    if(pid < 0){
    1980:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    1982:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1984:	78 79                	js     19ff <concreate+0x23f>
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1986:	89 f0                	mov    %esi,%eax
    1988:	ba 56 55 55 55       	mov    $0x55555556,%edx
    198d:	f7 ea                	imul   %edx
    198f:	89 f0                	mov    %esi,%eax
    1991:	c1 f8 1f             	sar    $0x1f,%eax
    1994:	29 c2                	sub    %eax,%edx
    1996:	89 f0                	mov    %esi,%eax
    1998:	8d 14 52             	lea    (%edx,%edx,2),%edx
    199b:	29 d0                	sub    %edx,%eax
    199d:	89 c2                	mov    %eax,%edx
    199f:	09 da                	or     %ebx,%edx
    19a1:	75 ad                	jne    1950 <concreate+0x190>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
    19a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19aa:	00 
    19ab:	89 3c 24             	mov    %edi,(%esp)
    19ae:	e8 35 14 00 00       	call   2de8 <open>
      close(fd);
    19b3:	89 04 24             	mov    %eax,(%esp)
    19b6:	e8 15 14 00 00       	call   2dd0 <close>
    19bb:	eb a3                	jmp    1960 <concreate+0x1a0>
    19bd:	8d 76 00             	lea    0x0(%esi),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    19c0:	85 db                	test   %ebx,%ebx
    19c2:	74 91                	je     1955 <concreate+0x195>
    19c4:	eb dd                	jmp    19a3 <concreate+0x1e3>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    19c6:	c7 44 24 04 30 3a 00 	movl   $0x3a30,0x4(%esp)
    19cd:	00 
    19ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19d5:	e8 56 15 00 00       	call   2f30 <printf>
}
    19da:	83 c4 5c             	add    $0x5c,%esp
    19dd:	5b                   	pop    %ebx
    19de:	5e                   	pop    %esi
    19df:	5f                   	pop    %edi
    19e0:	5d                   	pop    %ebp
    19e1:	c3                   	ret    
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    19e2:	89 7c 24 08          	mov    %edi,0x8(%esp)
    19e6:	c7 44 24 04 de 39 00 	movl   $0x39de,0x4(%esp)
    19ed:	00 
    19ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19f5:	e8 36 15 00 00       	call   2f30 <printf>
        exit();
    19fa:	e8 a9 13 00 00       	call   2da8 <exit>

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    19ff:	c7 44 24 04 94 32 00 	movl   $0x3294,0x4(%esp)
    1a06:	00 
    1a07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a0e:	e8 1d 15 00 00       	call   2f30 <printf>
      exit();
    1a13:	e8 90 13 00 00       	call   2da8 <exit>
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    1a18:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a1f:	c7 44 24 04 13 3a 00 	movl   $0x3a13,0x4(%esp)
    1a26:	00 
    1a27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a2e:	e8 fd 14 00 00       	call   2f30 <printf>
    1a33:	e9 4e fe ff ff       	jmp    1886 <concreate+0xc6>
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
    1a38:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1a3b:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a3f:	c7 44 24 04 fa 39 00 	movl   $0x39fa,0x4(%esp)
    1a46:	00 
    1a47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a4e:	e8 dd 14 00 00       	call   2f30 <printf>
    1a53:	e9 2e fe ff ff       	jmp    1886 <concreate+0xc6>
    }
  }
  close(fd);

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    1a58:	c7 44 24 04 ac 42 00 	movl   $0x42ac,0x4(%esp)
    1a5f:	00 
    1a60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a67:	e8 c4 14 00 00       	call   2f30 <printf>
    exit();
    1a6c:	e8 37 13 00 00       	call   2da8 <exit>
    1a71:	eb 0d                	jmp    1a80 <linktest>
    1a73:	90                   	nop    
    1a74:	90                   	nop    
    1a75:	90                   	nop    
    1a76:	90                   	nop    
    1a77:	90                   	nop    
    1a78:	90                   	nop    
    1a79:	90                   	nop    
    1a7a:	90                   	nop    
    1a7b:	90                   	nop    
    1a7c:	90                   	nop    
    1a7d:	90                   	nop    
    1a7e:	90                   	nop    
    1a7f:	90                   	nop    

00001a80 <linktest>:
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    1a80:	55                   	push   %ebp
    1a81:	89 e5                	mov    %esp,%ebp
    1a83:	53                   	push   %ebx
    1a84:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "linktest\n");
    1a87:	c7 44 24 04 3e 3a 00 	movl   $0x3a3e,0x4(%esp)
    1a8e:	00 
    1a8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a96:	e8 95 14 00 00       	call   2f30 <printf>

  unlink("lf1");
    1a9b:	c7 04 24 48 3a 00 00 	movl   $0x3a48,(%esp)
    1aa2:	e8 51 13 00 00       	call   2df8 <unlink>
  unlink("lf2");
    1aa7:	c7 04 24 4c 3a 00 00 	movl   $0x3a4c,(%esp)
    1aae:	e8 45 13 00 00       	call   2df8 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1ab3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1aba:	00 
    1abb:	c7 04 24 48 3a 00 00 	movl   $0x3a48,(%esp)
    1ac2:	e8 21 13 00 00       	call   2de8 <open>
  if(fd < 0){
    1ac7:	85 c0                	test   %eax,%eax
  printf(1, "linktest\n");

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
    1ac9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1acb:	0f 88 2e 01 00 00    	js     1bff <linktest+0x17f>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    1ad1:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1ad8:	00 
    1ad9:	c7 44 24 04 63 3a 00 	movl   $0x3a63,0x4(%esp)
    1ae0:	00 
    1ae1:	89 04 24             	mov    %eax,(%esp)
    1ae4:	e8 df 12 00 00       	call   2dc8 <write>
    1ae9:	83 f8 05             	cmp    $0x5,%eax
    1aec:	0f 85 26 01 00 00    	jne    1c18 <linktest+0x198>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1af2:	89 1c 24             	mov    %ebx,(%esp)
    1af5:	e8 d6 12 00 00       	call   2dd0 <close>

  if(link("lf1", "lf2") < 0){
    1afa:	c7 44 24 04 4c 3a 00 	movl   $0x3a4c,0x4(%esp)
    1b01:	00 
    1b02:	c7 04 24 48 3a 00 00 	movl   $0x3a48,(%esp)
    1b09:	e8 fa 12 00 00       	call   2e08 <link>
    1b0e:	85 c0                	test   %eax,%eax
    1b10:	0f 88 1b 01 00 00    	js     1c31 <linktest+0x1b1>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1b16:	c7 04 24 48 3a 00 00 	movl   $0x3a48,(%esp)
    1b1d:	e8 d6 12 00 00       	call   2df8 <unlink>

  if(open("lf1", 0) >= 0){
    1b22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b29:	00 
    1b2a:	c7 04 24 48 3a 00 00 	movl   $0x3a48,(%esp)
    1b31:	e8 b2 12 00 00       	call   2de8 <open>
    1b36:	85 c0                	test   %eax,%eax
    1b38:	0f 89 0c 01 00 00    	jns    1c4a <linktest+0x1ca>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1b3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b45:	00 
    1b46:	c7 04 24 4c 3a 00 00 	movl   $0x3a4c,(%esp)
    1b4d:	e8 96 12 00 00       	call   2de8 <open>
  if(fd < 0){
    1b52:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1b54:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b56:	0f 88 07 01 00 00    	js     1c63 <linktest+0x1e3>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1b5c:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1b63:	00 
    1b64:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1b6b:	00 
    1b6c:	89 04 24             	mov    %eax,(%esp)
    1b6f:	e8 4c 12 00 00       	call   2dc0 <read>
    1b74:	83 f8 05             	cmp    $0x5,%eax
    1b77:	0f 85 ff 00 00 00    	jne    1c7c <linktest+0x1fc>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    1b7d:	89 1c 24             	mov    %ebx,(%esp)
    1b80:	e8 4b 12 00 00       	call   2dd0 <close>

  if(link("lf2", "lf2") >= 0){
    1b85:	c7 44 24 04 4c 3a 00 	movl   $0x3a4c,0x4(%esp)
    1b8c:	00 
    1b8d:	c7 04 24 4c 3a 00 00 	movl   $0x3a4c,(%esp)
    1b94:	e8 6f 12 00 00       	call   2e08 <link>
    1b99:	85 c0                	test   %eax,%eax
    1b9b:	0f 89 f4 00 00 00    	jns    1c95 <linktest+0x215>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1ba1:	c7 04 24 4c 3a 00 00 	movl   $0x3a4c,(%esp)
    1ba8:	e8 4b 12 00 00       	call   2df8 <unlink>
  if(link("lf2", "lf1") >= 0){
    1bad:	c7 44 24 04 48 3a 00 	movl   $0x3a48,0x4(%esp)
    1bb4:	00 
    1bb5:	c7 04 24 4c 3a 00 00 	movl   $0x3a4c,(%esp)
    1bbc:	e8 47 12 00 00       	call   2e08 <link>
    1bc1:	85 c0                	test   %eax,%eax
    1bc3:	0f 89 e5 00 00 00    	jns    1cae <linktest+0x22e>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1bc9:	c7 44 24 04 48 3a 00 	movl   $0x3a48,0x4(%esp)
    1bd0:	00 
    1bd1:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    1bd8:	e8 2b 12 00 00       	call   2e08 <link>
    1bdd:	85 c0                	test   %eax,%eax
    1bdf:	0f 89 e2 00 00 00    	jns    1cc7 <linktest+0x247>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    1be5:	c7 44 24 04 ec 3a 00 	movl   $0x3aec,0x4(%esp)
    1bec:	00 
    1bed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bf4:	e8 37 13 00 00       	call   2f30 <printf>
}
    1bf9:	83 c4 14             	add    $0x14,%esp
    1bfc:	5b                   	pop    %ebx
    1bfd:	5d                   	pop    %ebp
    1bfe:	c3                   	ret    
  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    1bff:	c7 44 24 04 50 3a 00 	movl   $0x3a50,0x4(%esp)
    1c06:	00 
    1c07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c0e:	e8 1d 13 00 00       	call   2f30 <printf>
    exit();
    1c13:	e8 90 11 00 00       	call   2da8 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    printf(1, "write lf1 failed\n");
    1c18:	c7 44 24 04 69 3a 00 	movl   $0x3a69,0x4(%esp)
    1c1f:	00 
    1c20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c27:	e8 04 13 00 00       	call   2f30 <printf>
    exit();
    1c2c:	e8 77 11 00 00       	call   2da8 <exit>
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    printf(1, "link lf1 lf2 failed\n");
    1c31:	c7 44 24 04 7b 3a 00 	movl   $0x3a7b,0x4(%esp)
    1c38:	00 
    1c39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c40:	e8 eb 12 00 00       	call   2f30 <printf>
    exit();
    1c45:	e8 5e 11 00 00       	call   2da8 <exit>
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    1c4a:	c7 44 24 04 e0 42 00 	movl   $0x42e0,0x4(%esp)
    1c51:	00 
    1c52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c59:	e8 d2 12 00 00       	call   2f30 <printf>
    exit();
    1c5e:	e8 45 11 00 00       	call   2da8 <exit>
  }

  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    1c63:	c7 44 24 04 90 3a 00 	movl   $0x3a90,0x4(%esp)
    1c6a:	00 
    1c6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c72:	e8 b9 12 00 00       	call   2f30 <printf>
    exit();
    1c77:	e8 2c 11 00 00       	call   2da8 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "read lf2 failed\n");
    1c7c:	c7 44 24 04 a1 3a 00 	movl   $0x3aa1,0x4(%esp)
    1c83:	00 
    1c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c8b:	e8 a0 12 00 00       	call   2f30 <printf>
    exit();
    1c90:	e8 13 11 00 00       	call   2da8 <exit>
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1c95:	c7 44 24 04 b2 3a 00 	movl   $0x3ab2,0x4(%esp)
    1c9c:	00 
    1c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ca4:	e8 87 12 00 00       	call   2f30 <printf>
    exit();
    1ca9:	e8 fa 10 00 00       	call   2da8 <exit>
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    1cae:	c7 44 24 04 08 43 00 	movl   $0x4308,0x4(%esp)
    1cb5:	00 
    1cb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cbd:	e8 6e 12 00 00       	call   2f30 <printf>
    exit();
    1cc2:	e8 e1 10 00 00       	call   2da8 <exit>
  }

  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    1cc7:	c7 44 24 04 d0 3a 00 	movl   $0x3ad0,0x4(%esp)
    1cce:	00 
    1ccf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cd6:	e8 55 12 00 00       	call   2f30 <printf>
    exit();
    1cdb:	e8 c8 10 00 00       	call   2da8 <exit>

00001ce0 <unlinkread>:
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1ce0:	55                   	push   %ebp
    1ce1:	89 e5                	mov    %esp,%ebp
    1ce3:	56                   	push   %esi
    1ce4:	53                   	push   %ebx
    1ce5:	83 ec 10             	sub    $0x10,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1ce8:	c7 44 24 04 f9 3a 00 	movl   $0x3af9,0x4(%esp)
    1cef:	00 
    1cf0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cf7:	e8 34 12 00 00       	call   2f30 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1cfc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d03:	00 
    1d04:	c7 04 24 0a 3b 00 00 	movl   $0x3b0a,(%esp)
    1d0b:	e8 d8 10 00 00       	call   2de8 <open>
  if(fd < 0){
    1d10:	85 c0                	test   %eax,%eax
unlinkread(void)
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1d12:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d14:	0f 88 06 01 00 00    	js     1e20 <unlinkread+0x140>
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1d1a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1d21:	00 
    1d22:	c7 44 24 04 63 3a 00 	movl   $0x3a63,0x4(%esp)
    1d29:	00 
    1d2a:	89 04 24             	mov    %eax,(%esp)
    1d2d:	e8 96 10 00 00       	call   2dc8 <write>
  close(fd);
    1d32:	89 1c 24             	mov    %ebx,(%esp)
    1d35:	e8 96 10 00 00       	call   2dd0 <close>

  fd = open("unlinkread", O_RDWR);
    1d3a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1d41:	00 
    1d42:	c7 04 24 0a 3b 00 00 	movl   $0x3b0a,(%esp)
    1d49:	e8 9a 10 00 00       	call   2de8 <open>
  if(fd < 0){
    1d4e:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
    1d50:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1d52:	0f 88 e1 00 00 00    	js     1e39 <unlinkread+0x159>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1d58:	c7 04 24 0a 3b 00 00 	movl   $0x3b0a,(%esp)
    1d5f:	e8 94 10 00 00       	call   2df8 <unlink>
    1d64:	85 c0                	test   %eax,%eax
    1d66:	0f 85 e6 00 00 00    	jne    1e52 <unlinkread+0x172>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1d6c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d73:	00 
    1d74:	c7 04 24 0a 3b 00 00 	movl   $0x3b0a,(%esp)
    1d7b:	e8 68 10 00 00       	call   2de8 <open>
  write(fd1, "yyy", 3);
    1d80:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    1d87:	00 
    1d88:	c7 44 24 04 61 3b 00 	movl   $0x3b61,0x4(%esp)
    1d8f:	00 
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1d90:	89 c3                	mov    %eax,%ebx
  write(fd1, "yyy", 3);
    1d92:	89 04 24             	mov    %eax,(%esp)
    1d95:	e8 2e 10 00 00       	call   2dc8 <write>
  close(fd1);
    1d9a:	89 1c 24             	mov    %ebx,(%esp)
    1d9d:	e8 2e 10 00 00       	call   2dd0 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1da2:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1da9:	00 
    1daa:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1db1:	00 
    1db2:	89 34 24             	mov    %esi,(%esp)
    1db5:	e8 06 10 00 00       	call   2dc0 <read>
    1dba:	83 f8 05             	cmp    $0x5,%eax
    1dbd:	0f 85 a8 00 00 00    	jne    1e6b <unlinkread+0x18b>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    1dc3:	80 3d a0 44 00 00 68 	cmpb   $0x68,0x44a0
    1dca:	0f 85 b4 00 00 00    	jne    1e84 <unlinkread+0x1a4>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    1dd0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1dd7:	00 
    1dd8:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1ddf:	00 
    1de0:	89 34 24             	mov    %esi,(%esp)
    1de3:	e8 e0 0f 00 00       	call   2dc8 <write>
    1de8:	83 f8 0a             	cmp    $0xa,%eax
    1deb:	0f 85 ac 00 00 00    	jne    1e9d <unlinkread+0x1bd>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1df1:	89 34 24             	mov    %esi,(%esp)
    1df4:	e8 d7 0f 00 00       	call   2dd0 <close>
  unlink("unlinkread");
    1df9:	c7 04 24 0a 3b 00 00 	movl   $0x3b0a,(%esp)
    1e00:	e8 f3 0f 00 00       	call   2df8 <unlink>
  printf(1, "unlinkread ok\n");
    1e05:	c7 44 24 04 ac 3b 00 	movl   $0x3bac,0x4(%esp)
    1e0c:	00 
    1e0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e14:	e8 17 11 00 00       	call   2f30 <printf>
}
    1e19:	83 c4 10             	add    $0x10,%esp
    1e1c:	5b                   	pop    %ebx
    1e1d:	5e                   	pop    %esi
    1e1e:	5d                   	pop    %ebp
    1e1f:	c3                   	ret    
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create unlinkread failed\n");
    1e20:	c7 44 24 04 15 3b 00 	movl   $0x3b15,0x4(%esp)
    1e27:	00 
    1e28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e2f:	e8 fc 10 00 00       	call   2f30 <printf>
    exit();
    1e34:	e8 6f 0f 00 00       	call   2da8 <exit>
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    1e39:	c7 44 24 04 2f 3b 00 	movl   $0x3b2f,0x4(%esp)
    1e40:	00 
    1e41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e48:	e8 e3 10 00 00       	call   2f30 <printf>
    exit();
    1e4d:	e8 56 0f 00 00       	call   2da8 <exit>
  }
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    1e52:	c7 44 24 04 47 3b 00 	movl   $0x3b47,0x4(%esp)
    1e59:	00 
    1e5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e61:	e8 ca 10 00 00       	call   2f30 <printf>
    exit();
    1e66:	e8 3d 0f 00 00       	call   2da8 <exit>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    1e6b:	c7 44 24 04 65 3b 00 	movl   $0x3b65,0x4(%esp)
    1e72:	00 
    1e73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e7a:	e8 b1 10 00 00       	call   2f30 <printf>
    exit();
    1e7f:	e8 24 0f 00 00       	call   2da8 <exit>
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    1e84:	c7 44 24 04 7c 3b 00 	movl   $0x3b7c,0x4(%esp)
    1e8b:	00 
    1e8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e93:	e8 98 10 00 00       	call   2f30 <printf>
    exit();
    1e98:	e8 0b 0f 00 00       	call   2da8 <exit>
  }
  if(write(fd, buf, 10) != 10){
    printf(1, "unlinkread write failed\n");
    1e9d:	c7 44 24 04 93 3b 00 	movl   $0x3b93,0x4(%esp)
    1ea4:	00 
    1ea5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eac:	e8 7f 10 00 00       	call   2f30 <printf>
    exit();
    1eb1:	e8 f2 0e 00 00       	call   2da8 <exit>
    1eb6:	8d 76 00             	lea    0x0(%esi),%esi
    1eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00001ec0 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    1ec0:	55                   	push   %ebp
    1ec1:	89 e5                	mov    %esp,%ebp
    1ec3:	57                   	push   %edi
    1ec4:	56                   	push   %esi
    1ec5:	53                   	push   %ebx
    1ec6:	83 ec 1c             	sub    $0x1c,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    1ec9:	c7 44 24 04 bb 3b 00 	movl   $0x3bbb,0x4(%esp)
    1ed0:	00 
    1ed1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ed8:	e8 53 10 00 00       	call   2f30 <printf>

  unlink("f1");
    1edd:	c7 04 24 49 3a 00 00 	movl   $0x3a49,(%esp)
    1ee4:	e8 0f 0f 00 00       	call   2df8 <unlink>
  unlink("f2");
    1ee9:	c7 04 24 4d 3a 00 00 	movl   $0x3a4d,(%esp)
    1ef0:	e8 03 0f 00 00       	call   2df8 <unlink>

  pid = fork();
    1ef5:	e8 a6 0e 00 00       	call   2da0 <fork>
  if(pid < 0){
    1efa:	83 f8 00             	cmp    $0x0,%eax
  printf(1, "twofiles test\n");

  unlink("f1");
  unlink("f2");

  pid = fork();
    1efd:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    1eff:	0f 8c 87 01 00 00    	jl     208c <twofiles+0x1cc>
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
    1f05:	0f 85 ee 00 00 00    	jne    1ff9 <twofiles+0x139>
    1f0b:	b8 4d 3a 00 00       	mov    $0x3a4d,%eax
  fd = open(fname, O_CREATE | O_RDWR);
    1f10:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1f17:	00 
    1f18:	89 04 24             	mov    %eax,(%esp)
    1f1b:	e8 c8 0e 00 00       	call   2de8 <open>
  if(fd < 0){
    1f20:	85 c0                	test   %eax,%eax
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
    1f22:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1f24:	0f 88 9b 01 00 00    	js     20c5 <twofiles+0x205>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
    1f2a:	83 ff 01             	cmp    $0x1,%edi
    1f2d:	19 c0                	sbb    %eax,%eax
    1f2f:	31 db                	xor    %ebx,%ebx
    1f31:	83 e0 f3             	and    $0xfffffff3,%eax
    1f34:	83 c0 70             	add    $0x70,%eax
    1f37:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1f3e:	00 
    1f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f43:	c7 04 24 a0 44 00 00 	movl   $0x44a0,(%esp)
    1f4a:	e8 e1 0c 00 00       	call   2c30 <memset>
    1f4f:	90                   	nop    
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
    1f50:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1f57:	00 
    1f58:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1f5f:	00 
    1f60:	89 34 24             	mov    %esi,(%esp)
    1f63:	e8 60 0e 00 00       	call   2dc8 <write>
    1f68:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1f6d:	0f 85 35 01 00 00    	jne    20a8 <twofiles+0x1e8>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    1f73:	83 c3 01             	add    $0x1,%ebx
    1f76:	83 fb 0c             	cmp    $0xc,%ebx
    1f79:	75 d5                	jne    1f50 <twofiles+0x90>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    1f7b:	89 34 24             	mov    %esi,(%esp)
    1f7e:	e8 4d 0e 00 00       	call   2dd0 <close>
  if(pid)
    1f83:	85 ff                	test   %edi,%edi
    1f85:	0f 84 90 00 00 00    	je     201b <twofiles+0x15b>
    wait();
    1f8b:	e8 20 0e 00 00       	call   2db0 <wait>
    1f90:	31 f6                	xor    %esi,%esi
  else
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    1f92:	85 f6                	test   %esi,%esi
    1f94:	b8 49 3a 00 00       	mov    $0x3a49,%eax
    1f99:	75 05                	jne    1fa0 <twofiles+0xe0>
    1f9b:	b8 4d 3a 00 00       	mov    $0x3a4d,%eax
    1fa0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1fa7:	00 
    1fa8:	31 ff                	xor    %edi,%edi
    1faa:	89 04 24             	mov    %eax,(%esp)
    1fad:	e8 36 0e 00 00       	call   2de8 <open>
    1fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1fb5:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1fbc:	00 
    1fbd:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    1fc4:	00 
    1fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1fc8:	89 04 24             	mov    %eax,(%esp)
    1fcb:	e8 f0 0d 00 00       	call   2dc0 <read>
    1fd0:	85 c0                	test   %eax,%eax
    1fd2:	89 c3                	mov    %eax,%ebx
    1fd4:	7e 63                	jle    2039 <twofiles+0x179>
    1fd6:	31 c9                	xor    %ecx,%ecx
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
    1fd8:	83 fe 01             	cmp    $0x1,%esi
    1fdb:	0f be 91 a0 44 00 00 	movsbl 0x44a0(%ecx),%edx
    1fe2:	19 c0                	sbb    %eax,%eax
    1fe4:	83 e0 f3             	and    $0xfffffff3,%eax
    1fe7:	83 c0 70             	add    $0x70,%eax
    1fea:	39 c2                	cmp    %eax,%edx
    1fec:	75 32                	jne    2020 <twofiles+0x160>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    1fee:	83 c1 01             	add    $0x1,%ecx
    1ff1:	39 d9                	cmp    %ebx,%ecx
    1ff3:	75 e3                	jne    1fd8 <twofiles+0x118>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1ff5:	01 df                	add    %ebx,%edi
    1ff7:	eb bc                	jmp    1fb5 <twofiles+0xf5>
  if(pid < 0){
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
    1ff9:	b8 49 3a 00 00       	mov    $0x3a49,%eax
    1ffe:	e9 0d ff ff ff       	jmp    1f10 <twofiles+0x50>
      }
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
    2003:	89 7c 24 08          	mov    %edi,0x8(%esp)
    2007:	c7 44 24 04 e7 3b 00 	movl   $0x3be7,0x4(%esp)
    200e:	00 
    200f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2016:	e8 15 0f 00 00       	call   2f30 <printf>
      exit();
    201b:	e8 88 0d 00 00       	call   2da8 <exit>
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
    2020:	c7 44 24 04 db 3b 00 	movl   $0x3bdb,0x4(%esp)
    2027:	00 
    2028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    202f:	e8 fc 0e 00 00       	call   2f30 <printf>
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
      exit();
    2034:	e8 6f 0d 00 00       	call   2da8 <exit>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    2039:	8b 45 f0             	mov    -0x10(%ebp),%eax
    203c:	89 04 24             	mov    %eax,(%esp)
    203f:	e8 8c 0d 00 00       	call   2dd0 <close>
    if(total != 12*500){
    2044:	81 ff 70 17 00 00    	cmp    $0x1770,%edi
    204a:	75 b7                	jne    2003 <twofiles+0x143>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    204c:	83 c6 01             	add    $0x1,%esi
    204f:	83 fe 02             	cmp    $0x2,%esi
    2052:	0f 85 3a ff ff ff    	jne    1f92 <twofiles+0xd2>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    2058:	c7 04 24 49 3a 00 00 	movl   $0x3a49,(%esp)
    205f:	e8 94 0d 00 00       	call   2df8 <unlink>
  unlink("f2");
    2064:	c7 04 24 4d 3a 00 00 	movl   $0x3a4d,(%esp)
    206b:	e8 88 0d 00 00       	call   2df8 <unlink>

  printf(1, "twofiles ok\n");
    2070:	c7 44 24 04 f8 3b 00 	movl   $0x3bf8,0x4(%esp)
    2077:	00 
    2078:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    207f:	e8 ac 0e 00 00       	call   2f30 <printf>
}
    2084:	83 c4 1c             	add    $0x1c,%esp
    2087:	5b                   	pop    %ebx
    2088:	5e                   	pop    %esi
    2089:	5f                   	pop    %edi
    208a:	5d                   	pop    %ebp
    208b:	c3                   	ret    
  unlink("f1");
  unlink("f2");

  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    208c:	c7 44 24 04 94 32 00 	movl   $0x3294,0x4(%esp)
    2093:	00 
    2094:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    209b:	e8 90 0e 00 00       	call   2f30 <printf>

  unlink("f1");
  unlink("f2");

  printf(1, "twofiles ok\n");
}
    20a0:	83 c4 1c             	add    $0x1c,%esp
    20a3:	5b                   	pop    %ebx
    20a4:	5e                   	pop    %esi
    20a5:	5f                   	pop    %edi
    20a6:	5d                   	pop    %ebp
    20a7:	c3                   	ret    
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
    20a8:	89 44 24 08          	mov    %eax,0x8(%esp)
    20ac:	c7 44 24 04 ca 3b 00 	movl   $0x3bca,0x4(%esp)
    20b3:	00 
    20b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20bb:	e8 70 0e 00 00       	call   2f30 <printf>
      exit();
    20c0:	e8 e3 0c 00 00       	call   2da8 <exit>
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create failed\n");
    20c5:	c7 44 24 04 49 34 00 	movl   $0x3449,0x4(%esp)
    20cc:	00 
    20cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20d4:	e8 57 0e 00 00       	call   2f30 <printf>
    exit();
    20d9:	e8 ca 0c 00 00       	call   2da8 <exit>
    20de:	66 90                	xchg   %ax,%ax

000020e0 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    20e0:	55                   	push   %ebp
    20e1:	89 e5                	mov    %esp,%ebp
    20e3:	57                   	push   %edi
    20e4:	56                   	push   %esi
    20e5:	53                   	push   %ebx
    20e6:	83 ec 2c             	sub    $0x2c,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
    20e9:	c7 04 24 05 3c 00 00 	movl   $0x3c05,(%esp)
    20f0:	e8 03 0d 00 00       	call   2df8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    20f5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20fc:	00 
    20fd:	c7 04 24 05 3c 00 00 	movl   $0x3c05,(%esp)
    2104:	e8 df 0c 00 00       	call   2de8 <open>
  if(fd < 0){
    2109:	85 c0                	test   %eax,%eax
{
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
    210b:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    210d:	0f 88 26 01 00 00    	js     2239 <sharedfd+0x159>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    2113:	e8 88 0c 00 00       	call   2da0 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2118:	8d 75 ea             	lea    -0x16(%ebp),%esi
    211b:	83 f8 01             	cmp    $0x1,%eax
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    211e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2121:	19 c0                	sbb    %eax,%eax
    2123:	31 db                	xor    %ebx,%ebx
    2125:	83 e0 f3             	and    $0xfffffff3,%eax
    2128:	83 c0 70             	add    $0x70,%eax
    212b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2132:	00 
    2133:	89 44 24 04          	mov    %eax,0x4(%esp)
    2137:	89 34 24             	mov    %esi,(%esp)
    213a:	e8 f1 0a 00 00       	call   2c30 <memset>
    213f:	eb 0b                	jmp    214c <sharedfd+0x6c>
  for(i = 0; i < 1000; i++){
    2141:	83 c3 01             	add    $0x1,%ebx
    2144:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    214a:	74 2d                	je     2179 <sharedfd+0x99>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    214c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2153:	00 
    2154:	89 74 24 04          	mov    %esi,0x4(%esp)
    2158:	89 3c 24             	mov    %edi,(%esp)
    215b:	e8 68 0c 00 00       	call   2dc8 <write>
    2160:	83 f8 0a             	cmp    $0xa,%eax
    2163:	74 dc                	je     2141 <sharedfd+0x61>
      printf(1, "fstests: write sharedfd failed\n");
    2165:	c7 44 24 04 58 43 00 	movl   $0x4358,0x4(%esp)
    216c:	00 
    216d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2174:	e8 b7 0d 00 00       	call   2f30 <printf>
      break;
    }
  }
  if(pid == 0)
    2179:	8b 45 dc             	mov    -0x24(%ebp),%eax
    217c:	85 c0                	test   %eax,%eax
    217e:	0f 84 11 01 00 00    	je     2295 <sharedfd+0x1b5>
    exit();
  else
    wait();
    2184:	e8 27 0c 00 00       	call   2db0 <wait>
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    2189:	31 db                	xor    %ebx,%ebx
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    218b:	89 3c 24             	mov    %edi,(%esp)
  fd = open("sharedfd", 0);
  if(fd < 0){
    218e:	31 ff                	xor    %edi,%edi
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    2190:	e8 3b 0c 00 00       	call   2dd0 <close>
  fd = open("sharedfd", 0);
    2195:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    219c:	00 
    219d:	c7 04 24 05 3c 00 00 	movl   $0x3c05,(%esp)
    21a4:	e8 3f 0c 00 00       	call   2de8 <open>
  if(fd < 0){
    21a9:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
    21ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
    21ae:	0f 88 c5 00 00 00    	js     2279 <sharedfd+0x199>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    21b4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    21bb:	00 
    21bc:	89 74 24 04          	mov    %esi,0x4(%esp)
    21c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    21c3:	89 04 24             	mov    %eax,(%esp)
    21c6:	e8 f5 0b 00 00       	call   2dc0 <read>
    21cb:	85 c0                	test   %eax,%eax
    21cd:	7e 27                	jle    21f6 <sharedfd+0x116>
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
    21cf:	ba 01 00 00 00       	mov    $0x1,%edx
    21d4:	eb 12                	jmp    21e8 <sharedfd+0x108>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
    21d6:	3c 70                	cmp    $0x70,%al
    21d8:	0f 94 c0             	sete   %al
    21db:	0f b6 c0             	movzbl %al,%eax
    21de:	01 c3                	add    %eax,%ebx
    21e0:	83 c2 01             	add    $0x1,%edx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    21e3:	83 fa 0b             	cmp    $0xb,%edx
    21e6:	74 cc                	je     21b4 <sharedfd+0xd4>
      if(buf[i] == 'c')
    21e8:	0f b6 44 32 ff       	movzbl -0x1(%edx,%esi,1),%eax
    21ed:	3c 63                	cmp    $0x63,%al
    21ef:	75 e5                	jne    21d6 <sharedfd+0xf6>
        nc++;
    21f1:	83 c7 01             	add    $0x1,%edi
    21f4:	eb ea                	jmp    21e0 <sharedfd+0x100>
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    21f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
    21f9:	89 04 24             	mov    %eax,(%esp)
    21fc:	e8 cf 0b 00 00       	call   2dd0 <close>
  unlink("sharedfd");
    2201:	c7 04 24 05 3c 00 00 	movl   $0x3c05,(%esp)
    2208:	e8 eb 0b 00 00       	call   2df8 <unlink>
  if(nc == 10000 && np == 10000)
    220d:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    2213:	74 40                	je     2255 <sharedfd+0x175>
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
    2215:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    2219:	89 7c 24 08          	mov    %edi,0x8(%esp)
    221d:	c7 44 24 04 1b 3c 00 	movl   $0x3c1b,0x4(%esp)
    2224:	00 
    2225:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    222c:	e8 ff 0c 00 00       	call   2f30 <printf>
}
    2231:	83 c4 2c             	add    $0x2c,%esp
    2234:	5b                   	pop    %ebx
    2235:	5e                   	pop    %esi
    2236:	5f                   	pop    %edi
    2237:	5d                   	pop    %ebp
    2238:	c3                   	ret    
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    2239:	c7 44 24 04 2c 43 00 	movl   $0x432c,0x4(%esp)
    2240:	00 
    2241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2248:	e8 e3 0c 00 00       	call   2f30 <printf>
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    224d:	83 c4 2c             	add    $0x2c,%esp
    2250:	5b                   	pop    %ebx
    2251:	5e                   	pop    %esi
    2252:	5f                   	pop    %edi
    2253:	5d                   	pop    %ebp
    2254:	c3                   	ret    
        np++;
    }
  }
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    2255:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    225b:	75 b8                	jne    2215 <sharedfd+0x135>
    printf(1, "sharedfd ok\n");
    225d:	c7 44 24 04 0e 3c 00 	movl   $0x3c0e,0x4(%esp)
    2264:	00 
    2265:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    226c:	e8 bf 0c 00 00       	call   2f30 <printf>
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    2271:	83 c4 2c             	add    $0x2c,%esp
    2274:	5b                   	pop    %ebx
    2275:	5e                   	pop    %esi
    2276:	5f                   	pop    %edi
    2277:	5d                   	pop    %ebp
    2278:	c3                   	ret    
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    2279:	c7 44 24 04 78 43 00 	movl   $0x4378,0x4(%esp)
    2280:	00 
    2281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2288:	e8 a3 0c 00 00       	call   2f30 <printf>
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    228d:	83 c4 2c             	add    $0x2c,%esp
    2290:	5b                   	pop    %ebx
    2291:	5e                   	pop    %esi
    2292:	5f                   	pop    %edi
    2293:	5d                   	pop    %ebp
    2294:	c3                   	ret    
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
    exit();
    2295:	e8 0e 0b 00 00       	call   2da8 <exit>
    229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000022a0 <writetest1>:
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    22a0:	55                   	push   %ebp
    22a1:	89 e5                	mov    %esp,%ebp
    22a3:	56                   	push   %esi
    22a4:	53                   	push   %ebx
  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
    22a5:	31 db                	xor    %ebx,%ebx
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    22a7:	83 ec 10             	sub    $0x10,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    22aa:	a1 70 44 00 00       	mov    0x4470,%eax
    22af:	c7 44 24 04 30 3c 00 	movl   $0x3c30,0x4(%esp)
    22b6:	00 
    22b7:	89 04 24             	mov    %eax,(%esp)
    22ba:	e8 71 0c 00 00       	call   2f30 <printf>

  fd = open("big", O_CREATE|O_RDWR);
    22bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    22c6:	00 
    22c7:	c7 04 24 aa 3c 00 00 	movl   $0x3caa,(%esp)
    22ce:	e8 15 0b 00 00       	call   2de8 <open>
  if(fd < 0){
    22d3:	85 c0                	test   %eax,%eax
{
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
    22d5:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    22d7:	79 12                	jns    22eb <writetest1+0x4b>
    22d9:	e9 37 01 00 00       	jmp    2415 <writetest1+0x175>
    22de:	66 90                	xchg   %ax,%ax
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++) {
    22e0:	83 c3 01             	add    $0x1,%ebx
    22e3:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    22e9:	74 43                	je     232e <writetest1+0x8e>
    ((int*) buf)[0] = i;
    22eb:	89 1d a0 44 00 00    	mov    %ebx,0x44a0
    if(write(fd, buf, 512) != 512) {
    22f1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    22f8:	00 
    22f9:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    2300:	00 
    2301:	89 34 24             	mov    %esi,(%esp)
    2304:	e8 bf 0a 00 00       	call   2dc8 <write>
    2309:	3d 00 02 00 00       	cmp    $0x200,%eax
    230e:	74 d0                	je     22e0 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
    2310:	a1 70 44 00 00       	mov    0x4470,%eax
    2315:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2319:	c7 44 24 04 5a 3c 00 	movl   $0x3c5a,0x4(%esp)
    2320:	00 
    2321:	89 04 24             	mov    %eax,(%esp)
    2324:	e8 07 0c 00 00       	call   2f30 <printf>
      exit();
    2329:	e8 7a 0a 00 00       	call   2da8 <exit>
    }
  }

  close(fd);
    232e:	89 34 24             	mov    %esi,(%esp)

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
    exit();
    2331:	31 f6                	xor    %esi,%esi
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    2333:	e8 98 0a 00 00       	call   2dd0 <close>

  fd = open("big", O_RDONLY);
    2338:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    233f:	00 
    2340:	c7 04 24 aa 3c 00 00 	movl   $0x3caa,(%esp)
    2347:	e8 9c 0a 00 00       	call   2de8 <open>
  if(fd < 0){
    234c:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
    234e:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2350:	79 20                	jns    2372 <writetest1+0xd2>
    2352:	e9 fa 00 00 00       	jmp    2451 <writetest1+0x1b1>
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
    2357:	3d 00 02 00 00       	cmp    $0x200,%eax
    235c:	8d 74 26 00          	lea    0x0(%esi),%esi
    2360:	75 73                	jne    23d5 <writetest1+0x135>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n) {
    2362:	a1 a0 44 00 00       	mov    0x44a0,%eax
    2367:	39 f0                	cmp    %esi,%eax
    2369:	0f 85 84 00 00 00    	jne    23f3 <writetest1+0x153>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
    236f:	8d 70 01             	lea    0x1(%eax),%esi
    exit();
  }

  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    2372:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    2379:	00 
    237a:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    2381:	00 
    2382:	89 1c 24             	mov    %ebx,(%esp)
    2385:	e8 36 0a 00 00       	call   2dc0 <read>
    if(i == 0) {
    238a:	85 c0                	test   %eax,%eax
    238c:	75 c9                	jne    2357 <writetest1+0xb7>
      if(n == MAXFILE - 1) {
    238e:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
    2394:	0f 84 95 00 00 00    	je     242f <writetest1+0x18f>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    239a:	89 1c 24             	mov    %ebx,(%esp)
    239d:	8d 76 00             	lea    0x0(%esi),%esi
    23a0:	e8 2b 0a 00 00       	call   2dd0 <close>
  if(unlink("big") < 0) {
    23a5:	c7 04 24 aa 3c 00 00 	movl   $0x3caa,(%esp)
    23ac:	e8 47 0a 00 00       	call   2df8 <unlink>
    23b1:	85 c0                	test   %eax,%eax
    23b3:	0f 88 b2 00 00 00    	js     246b <writetest1+0x1cb>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
    23b9:	a1 70 44 00 00       	mov    0x4470,%eax
    23be:	c7 44 24 04 d1 3c 00 	movl   $0x3cd1,0x4(%esp)
    23c5:	00 
    23c6:	89 04 24             	mov    %eax,(%esp)
    23c9:	e8 62 0b 00 00       	call   2f30 <printf>
}
    23ce:	83 c4 10             	add    $0x10,%esp
    23d1:	5b                   	pop    %ebx
    23d2:	5e                   	pop    %esi
    23d3:	5d                   	pop    %ebp
    23d4:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
      printf(stdout, "read failed %d\n", i);
    23d5:	89 44 24 08          	mov    %eax,0x8(%esp)
    23d9:	a1 70 44 00 00       	mov    0x4470,%eax
    23de:	c7 44 24 04 ae 3c 00 	movl   $0x3cae,0x4(%esp)
    23e5:	00 
    23e6:	89 04 24             	mov    %eax,(%esp)
    23e9:	e8 42 0b 00 00       	call   2f30 <printf>
      exit();
    23ee:	e8 b5 09 00 00       	call   2da8 <exit>
    }
    if(((int*)buf)[0] != n) {
      printf(stdout, "read content of block %d is %d\n",
    23f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
    23f7:	a1 70 44 00 00       	mov    0x4470,%eax
    23fc:	89 74 24 08          	mov    %esi,0x8(%esp)
    2400:	c7 44 24 04 a4 43 00 	movl   $0x43a4,0x4(%esp)
    2407:	00 
    2408:	89 04 24             	mov    %eax,(%esp)
    240b:	e8 20 0b 00 00       	call   2f30 <printf>
             n, ((int*)buf)[0]);
      exit();
    2410:	e8 93 09 00 00       	call   2da8 <exit>

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    2415:	a1 70 44 00 00       	mov    0x4470,%eax
    241a:	c7 44 24 04 40 3c 00 	movl   $0x3c40,0x4(%esp)
    2421:	00 
    2422:	89 04 24             	mov    %eax,(%esp)
    2425:	e8 06 0b 00 00       	call   2f30 <printf>
    exit();
    242a:	e8 79 09 00 00       	call   2da8 <exit>
  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    if(i == 0) {
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
    242f:	a1 70 44 00 00       	mov    0x4470,%eax
    2434:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
    243b:	00 
    243c:	c7 44 24 04 91 3c 00 	movl   $0x3c91,0x4(%esp)
    2443:	00 
    2444:	89 04 24             	mov    %eax,(%esp)
    2447:	e8 e4 0a 00 00       	call   2f30 <printf>
        exit();
    244c:	e8 57 09 00 00       	call   2da8 <exit>

  close(fd);

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
    2451:	a1 70 44 00 00       	mov    0x4470,%eax
    2456:	c7 44 24 04 78 3c 00 	movl   $0x3c78,0x4(%esp)
    245d:	00 
    245e:	89 04 24             	mov    %eax,(%esp)
    2461:	e8 ca 0a 00 00       	call   2f30 <printf>
    exit();
    2466:	e8 3d 09 00 00       	call   2da8 <exit>
    }
    n++;
  }
  close(fd);
  if(unlink("big") < 0) {
    printf(stdout, "unlink big failed\n");
    246b:	a1 70 44 00 00       	mov    0x4470,%eax
    2470:	c7 44 24 04 be 3c 00 	movl   $0x3cbe,0x4(%esp)
    2477:	00 
    2478:	89 04 24             	mov    %eax,(%esp)
    247b:	e8 b0 0a 00 00       	call   2f30 <printf>
    exit();
    2480:	e8 23 09 00 00       	call   2da8 <exit>
    2485:	8d 74 26 00          	lea    0x0(%esi),%esi
    2489:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002490 <writetest>:
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
    2490:	55                   	push   %ebp
    2491:	89 e5                	mov    %esp,%ebp
    2493:	56                   	push   %esi
    2494:	53                   	push   %ebx
    2495:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    2498:	a1 70 44 00 00       	mov    0x4470,%eax
    249d:	c7 44 24 04 df 3c 00 	movl   $0x3cdf,0x4(%esp)
    24a4:	00 
    24a5:	89 04 24             	mov    %eax,(%esp)
    24a8:	e8 83 0a 00 00       	call   2f30 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    24ad:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    24b4:	00 
    24b5:	c7 04 24 f0 3c 00 00 	movl   $0x3cf0,(%esp)
    24bc:	e8 27 09 00 00       	call   2de8 <open>
  if(fd >= 0){
    24c1:	85 c0                	test   %eax,%eax
{
  int fd;
  int i;

  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
    24c3:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
    24c5:	0f 88 4f 01 00 00    	js     261a <writetest+0x18a>
    printf(stdout, "creat small succeeded; ok\n");
    24cb:	a1 70 44 00 00       	mov    0x4470,%eax
    24d0:	31 db                	xor    %ebx,%ebx
    24d2:	c7 44 24 04 f6 3c 00 	movl   $0x3cf6,0x4(%esp)
    24d9:	00 
    24da:	89 04 24             	mov    %eax,(%esp)
    24dd:	e8 4e 0a 00 00       	call   2f30 <printf>
    24e2:	eb 25                	jmp    2509 <writetest+0x79>
  for(i = 0; i < 100; i++) {
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
    24e4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    24eb:	00 
    24ec:	c7 44 24 04 38 3d 00 	movl   $0x3d38,0x4(%esp)
    24f3:	00 
    24f4:	89 34 24             	mov    %esi,(%esp)
    24f7:	e8 cc 08 00 00       	call   2dc8 <write>
    24fc:	83 f8 0a             	cmp    $0xa,%eax
    24ff:	75 43                	jne    2544 <writetest+0xb4>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    2501:	83 c3 01             	add    $0x1,%ebx
    2504:	83 fb 64             	cmp    $0x64,%ebx
    2507:	74 59                	je     2562 <writetest+0xd2>
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
    2509:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2510:	00 
    2511:	c7 44 24 04 2d 3d 00 	movl   $0x3d2d,0x4(%esp)
    2518:	00 
    2519:	89 34 24             	mov    %esi,(%esp)
    251c:	e8 a7 08 00 00       	call   2dc8 <write>
    2521:	83 f8 0a             	cmp    $0xa,%eax
    2524:	74 be                	je     24e4 <writetest+0x54>
      printf(stdout, "error: write aa %d new file failed\n", i);
    2526:	a1 70 44 00 00       	mov    0x4470,%eax
    252b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    252f:	c7 44 24 04 c4 43 00 	movl   $0x43c4,0x4(%esp)
    2536:	00 
    2537:	89 04 24             	mov    %eax,(%esp)
    253a:	e8 f1 09 00 00       	call   2f30 <printf>
      exit();
    253f:	e8 64 08 00 00       	call   2da8 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
      printf(stdout, "error: write bb %d new file failed\n", i);
    2544:	a1 70 44 00 00       	mov    0x4470,%eax
    2549:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    254d:	c7 44 24 04 e8 43 00 	movl   $0x43e8,0x4(%esp)
    2554:	00 
    2555:	89 04 24             	mov    %eax,(%esp)
    2558:	e8 d3 09 00 00       	call   2f30 <printf>
      exit();
    255d:	e8 46 08 00 00       	call   2da8 <exit>
    }
  }
  printf(stdout, "writes ok\n");
    2562:	a1 70 44 00 00       	mov    0x4470,%eax
    2567:	c7 44 24 04 43 3d 00 	movl   $0x3d43,0x4(%esp)
    256e:	00 
    256f:	89 04 24             	mov    %eax,(%esp)
    2572:	e8 b9 09 00 00       	call   2f30 <printf>
  close(fd);
    2577:	89 34 24             	mov    %esi,(%esp)
    257a:	e8 51 08 00 00       	call   2dd0 <close>
  fd = open("small", O_RDONLY);
    257f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2586:	00 
    2587:	c7 04 24 f0 3c 00 00 	movl   $0x3cf0,(%esp)
    258e:	e8 55 08 00 00       	call   2de8 <open>
  if(fd >= 0){
    2593:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
    2595:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    2597:	0f 88 97 00 00 00    	js     2634 <writetest+0x1a4>
    printf(stdout, "open small succeeded ok\n");
    259d:	a1 70 44 00 00       	mov    0x4470,%eax
    25a2:	c7 44 24 04 4e 3d 00 	movl   $0x3d4e,0x4(%esp)
    25a9:	00 
    25aa:	89 04 24             	mov    %eax,(%esp)
    25ad:	e8 7e 09 00 00       	call   2f30 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    25b2:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    25b9:	00 
    25ba:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    25c1:	00 
    25c2:	89 1c 24             	mov    %ebx,(%esp)
    25c5:	e8 f6 07 00 00       	call   2dc0 <read>
  if(i == 2000) {
    25ca:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    25cf:	75 7d                	jne    264e <writetest+0x1be>
    printf(stdout, "read succeeded ok\n");
    25d1:	a1 70 44 00 00       	mov    0x4470,%eax
    25d6:	c7 44 24 04 82 3d 00 	movl   $0x3d82,0x4(%esp)
    25dd:	00 
    25de:	89 04 24             	mov    %eax,(%esp)
    25e1:	e8 4a 09 00 00       	call   2f30 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    25e6:	89 1c 24             	mov    %ebx,(%esp)
    25e9:	e8 e2 07 00 00       	call   2dd0 <close>

  if(unlink("small") < 0) {
    25ee:	c7 04 24 f0 3c 00 00 	movl   $0x3cf0,(%esp)
    25f5:	e8 fe 07 00 00       	call   2df8 <unlink>
    25fa:	85 c0                	test   %eax,%eax
    25fc:	78 6a                	js     2668 <writetest+0x1d8>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
    25fe:	a1 70 44 00 00       	mov    0x4470,%eax
    2603:	c7 44 24 04 aa 3d 00 	movl   $0x3daa,0x4(%esp)
    260a:	00 
    260b:	89 04 24             	mov    %eax,(%esp)
    260e:	e8 1d 09 00 00       	call   2f30 <printf>
}
    2613:	83 c4 10             	add    $0x10,%esp
    2616:	5b                   	pop    %ebx
    2617:	5e                   	pop    %esi
    2618:	5d                   	pop    %ebp
    2619:	c3                   	ret    
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    261a:	a1 70 44 00 00       	mov    0x4470,%eax
    261f:	c7 44 24 04 11 3d 00 	movl   $0x3d11,0x4(%esp)
    2626:	00 
    2627:	89 04 24             	mov    %eax,(%esp)
    262a:	e8 01 09 00 00       	call   2f30 <printf>
    exit();
    262f:	e8 74 07 00 00       	call   2da8 <exit>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
    2634:	a1 70 44 00 00       	mov    0x4470,%eax
    2639:	c7 44 24 04 67 3d 00 	movl   $0x3d67,0x4(%esp)
    2640:	00 
    2641:	89 04 24             	mov    %eax,(%esp)
    2644:	e8 e7 08 00 00       	call   2f30 <printf>
    exit();
    2649:	e8 5a 07 00 00       	call   2da8 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000) {
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
    264e:	a1 70 44 00 00       	mov    0x4470,%eax
    2653:	c7 44 24 04 22 3b 00 	movl   $0x3b22,0x4(%esp)
    265a:	00 
    265b:	89 04 24             	mov    %eax,(%esp)
    265e:	e8 cd 08 00 00       	call   2f30 <printf>
    exit();
    2663:	e8 40 07 00 00       	call   2da8 <exit>
  }
  close(fd);

  if(unlink("small") < 0) {
    printf(stdout, "unlink small failed\n");
    2668:	a1 70 44 00 00       	mov    0x4470,%eax
    266d:	c7 44 24 04 95 3d 00 	movl   $0x3d95,0x4(%esp)
    2674:	00 
    2675:	89 04 24             	mov    %eax,(%esp)
    2678:	e8 b3 08 00 00       	call   2f30 <printf>
    exit();
    267d:	e8 26 07 00 00       	call   2da8 <exit>
    2682:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    2689:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002690 <mem>:
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    2690:	55                   	push   %ebp
    2691:	89 e5                	mov    %esp,%ebp
    2693:	56                   	push   %esi
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    2694:	31 f6                	xor    %esi,%esi
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    2696:	53                   	push   %ebx
    2697:	83 ec 10             	sub    $0x10,%esp
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    269a:	e8 01 07 00 00       	call   2da0 <fork>
    269f:	85 c0                	test   %eax,%eax
    26a1:	74 11                	je     26b4 <mem+0x24>
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
  }
}
    26a3:	83 c4 10             	add    $0x10,%esp
    26a6:	5b                   	pop    %ebx
    26a7:	5e                   	pop    %esi
    26a8:	5d                   	pop    %ebp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    26a9:	e9 02 07 00 00       	jmp    2db0 <wait>
    26ae:	66 90                	xchg   %ax,%ax
  int pid;

  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
    26b0:	89 30                	mov    %esi,(%eax)
    26b2:	89 c6                	mov    %eax,%esi
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
    26b4:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    26bb:	e8 60 0a 00 00       	call   3120 <malloc>
    26c0:	85 c0                	test   %eax,%eax
    26c2:	75 ec                	jne    26b0 <mem+0x20>
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    26c4:	85 f6                	test   %esi,%esi
    26c6:	74 10                	je     26d8 <mem+0x48>
      m2 = *(char**)m1;
    26c8:	8b 1e                	mov    (%esi),%ebx
      free(m1);
    26ca:	89 34 24             	mov    %esi,(%esp)
    26cd:	e8 ce 09 00 00       	call   30a0 <free>
    26d2:	89 de                	mov    %ebx,%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    26d4:	85 f6                	test   %esi,%esi
    26d6:	75 f0                	jne    26c8 <mem+0x38>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    26d8:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    26df:	e8 3c 0a 00 00       	call   3120 <malloc>
    if(m1 == 0) {
    26e4:	85 c0                	test   %eax,%eax
    26e6:	75 19                	jne    2701 <mem+0x71>
      printf(1, "couldn't allocate mem?!!\n");
    26e8:	c7 44 24 04 be 3d 00 	movl   $0x3dbe,0x4(%esp)
    26ef:	00 
    26f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26f7:	e8 34 08 00 00       	call   2f30 <printf>
      exit();
    26fc:	e8 a7 06 00 00       	call   2da8 <exit>
    }
    free(m1);
    2701:	89 04 24             	mov    %eax,(%esp)
    2704:	e8 97 09 00 00       	call   30a0 <free>
    printf(1, "mem ok\n");
    2709:	c7 44 24 04 d8 3d 00 	movl   $0x3dd8,0x4(%esp)
    2710:	00 
    2711:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2718:	e8 13 08 00 00       	call   2f30 <printf>
    exit();
    271d:	e8 86 06 00 00       	call   2da8 <exit>
    2722:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    2729:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002730 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    2730:	55                   	push   %ebp
    2731:	89 e5                	mov    %esp,%ebp
    2733:	57                   	push   %edi
    2734:	56                   	push   %esi
    2735:	53                   	push   %ebx
    2736:	83 ec 1c             	sub    $0x1c,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    2739:	8d 45 ec             	lea    -0x14(%ebp),%eax
    273c:	89 04 24             	mov    %eax,(%esp)
    273f:	e8 74 06 00 00       	call   2db8 <pipe>
    2744:	85 c0                	test   %eax,%eax
    2746:	0f 85 53 01 00 00    	jne    289f <pipe1+0x16f>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    274c:	e8 4f 06 00 00       	call   2da0 <fork>
  seq = 0;
  if(pid == 0){
    2751:	83 f8 00             	cmp    $0x0,%eax
    2754:	74 7c                	je     27d2 <pipe1+0xa2>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    2756:	0f 8e 5c 01 00 00    	jle    28b8 <pipe1+0x188>
    close(fds[1]);
    275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    275f:	31 db                	xor    %ebx,%ebx
    2761:	be 01 00 00 00       	mov    $0x1,%esi
    2766:	31 ff                	xor    %edi,%edi
    2768:	89 04 24             	mov    %eax,(%esp)
    276b:	e8 60 06 00 00       	call   2dd0 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    2770:	89 74 24 08          	mov    %esi,0x8(%esp)
    2774:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    277b:	00 
    277c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    277f:	89 04 24             	mov    %eax,(%esp)
    2782:	e8 39 06 00 00       	call   2dc0 <read>
    2787:	85 c0                	test   %eax,%eax
    2789:	0f 8e aa 00 00 00    	jle    2839 <pipe1+0x109>
    278f:	31 d2                	xor    %edx,%edx
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    2791:	38 9a a0 44 00 00    	cmp    %bl,0x44a0(%edx)
    2797:	75 1d                	jne    27b6 <pipe1+0x86>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    2799:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    279c:	83 c3 01             	add    $0x1,%ebx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    279f:	39 c2                	cmp    %eax,%edx
    27a1:	75 ee                	jne    2791 <pipe1+0x61>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
    27a3:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
    27a5:	81 fe 00 08 00 00    	cmp    $0x800,%esi
    27ab:	76 05                	jbe    27b2 <pipe1+0x82>
    27ad:	be 00 08 00 00       	mov    $0x800,%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    27b2:	01 c7                	add    %eax,%edi
    27b4:	eb ba                	jmp    2770 <pipe1+0x40>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
    27b6:	c7 44 24 04 fd 3d 00 	movl   $0x3dfd,0x4(%esp)
    27bd:	00 
    27be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c5:	e8 66 07 00 00       	call   2f30 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    27ca:	83 c4 1c             	add    $0x1c,%esp
    27cd:	5b                   	pop    %ebx
    27ce:	5e                   	pop    %esi
    27cf:	5f                   	pop    %edi
    27d0:	5d                   	pop    %ebp
    27d1:	c3                   	ret    
    exit();
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    27d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    27d5:	31 db                	xor    %ebx,%ebx
    27d7:	89 04 24             	mov    %eax,(%esp)
    27da:	e8 f1 05 00 00       	call   2dd0 <close>
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    exit();
    27df:	89 d9                	mov    %ebx,%ecx
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
    27e1:	ba 01 00 00 00       	mov    $0x1,%edx
    27e6:	88 1d a0 44 00 00    	mov    %bl,0x44a0
    27ec:	8d 74 26 00          	lea    0x0(%esi),%esi
    27f0:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    27f3:	88 82 a0 44 00 00    	mov    %al,0x44a0(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    27f9:	83 c2 01             	add    $0x1,%edx
    27fc:	81 fa 09 04 00 00    	cmp    $0x409,%edx
    2802:	75 ec                	jne    27f0 <pipe1+0xc0>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    2804:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    280b:	00 
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    280c:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    2812:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    2819:	00 
    281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    281d:	89 04 24             	mov    %eax,(%esp)
    2820:	e8 a3 05 00 00       	call   2dc8 <write>
    2825:	3d 09 04 00 00       	cmp    $0x409,%eax
    282a:	75 5a                	jne    2886 <pipe1+0x156>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    282c:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    2832:	75 ab                	jne    27df <pipe1+0xaf>
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    exit();
    2834:	e8 6f 05 00 00       	call   2da8 <exit>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033)
    2839:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
    283f:	90                   	nop    
    2840:	74 18                	je     285a <pipe1+0x12a>
      printf(1, "pipe1 oops 3 total %d\n", total);
    2842:	89 7c 24 08          	mov    %edi,0x8(%esp)
    2846:	c7 44 24 04 0b 3e 00 	movl   $0x3e0b,0x4(%esp)
    284d:	00 
    284e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2855:	e8 d6 06 00 00       	call   2f30 <printf>
    close(fds[0]);
    285a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    285d:	89 04 24             	mov    %eax,(%esp)
    2860:	e8 6b 05 00 00       	call   2dd0 <close>
    wait();
    2865:	e8 46 05 00 00       	call   2db0 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    286a:	c7 44 24 04 22 3e 00 	movl   $0x3e22,0x4(%esp)
    2871:	00 
    2872:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2879:	e8 b2 06 00 00       	call   2f30 <printf>
}
    287e:	83 c4 1c             	add    $0x1c,%esp
    2881:	5b                   	pop    %ebx
    2882:	5e                   	pop    %esi
    2883:	5f                   	pop    %edi
    2884:	5d                   	pop    %ebp
    2885:	c3                   	ret    
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
    2886:	c7 44 24 04 ef 3d 00 	movl   $0x3def,0x4(%esp)
    288d:	00 
    288e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2895:	e8 96 06 00 00       	call   2f30 <printf>
        exit();
    289a:	e8 09 05 00 00       	call   2da8 <exit>
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    289f:	c7 44 24 04 e0 3d 00 	movl   $0x3de0,0x4(%esp)
    28a6:	00 
    28a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ae:	e8 7d 06 00 00       	call   2f30 <printf>
    exit();
    28b3:	e8 f0 04 00 00       	call   2da8 <exit>
    if(total != 5 * 1033)
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    28b8:	c7 44 24 04 2c 3e 00 	movl   $0x3e2c,0x4(%esp)
    28bf:	00 
    28c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28c7:	e8 64 06 00 00       	call   2f30 <printf>
    28cc:	e9 63 ff ff ff       	jmp    2834 <pipe1+0x104>
    28d1:	eb 0d                	jmp    28e0 <preempt>
    28d3:	90                   	nop    
    28d4:	90                   	nop    
    28d5:	90                   	nop    
    28d6:	90                   	nop    
    28d7:	90                   	nop    
    28d8:	90                   	nop    
    28d9:	90                   	nop    
    28da:	90                   	nop    
    28db:	90                   	nop    
    28dc:	90                   	nop    
    28dd:	90                   	nop    
    28de:	90                   	nop    
    28df:	90                   	nop    

000028e0 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    28e0:	55                   	push   %ebp
    28e1:	89 e5                	mov    %esp,%ebp
    28e3:	57                   	push   %edi
    28e4:	56                   	push   %esi
    28e5:	53                   	push   %ebx
    28e6:	83 ec 1c             	sub    $0x1c,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    28e9:	c7 44 24 04 3b 3e 00 	movl   $0x3e3b,0x4(%esp)
    28f0:	00 
    28f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28f8:	e8 33 06 00 00       	call   2f30 <printf>
  pid1 = fork();
    28fd:	e8 9e 04 00 00       	call   2da0 <fork>
  if(pid1 == 0)
    2902:	85 c0                	test   %eax,%eax
{
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
  pid1 = fork();
    2904:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
    2906:	75 02                	jne    290a <preempt+0x2a>
    2908:	eb fe                	jmp    2908 <preempt+0x28>
    290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(;;)
      ;

  pid2 = fork();
    2910:	e8 8b 04 00 00       	call   2da0 <fork>
  if(pid2 == 0)
    2915:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
    2917:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    2919:	75 02                	jne    291d <preempt+0x3d>
    291b:	eb fe                	jmp    291b <preempt+0x3b>
    for(;;)
      ;

  pipe(pfds);
    291d:	8d 45 ec             	lea    -0x14(%ebp),%eax
    2920:	89 04 24             	mov    %eax,(%esp)
    2923:	e8 90 04 00 00       	call   2db8 <pipe>
  pid3 = fork();
    2928:	e8 73 04 00 00       	call   2da0 <fork>
  if(pid3 == 0){
    292d:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
    292f:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    2931:	75 4c                	jne    297f <preempt+0x9f>
    close(pfds[0]);
    2933:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2936:	89 04 24             	mov    %eax,(%esp)
    2939:	e8 92 04 00 00       	call   2dd0 <close>
    if(write(pfds[1], "x", 1) != 1)
    293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2941:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2948:	00 
    2949:	c7 44 24 04 c7 38 00 	movl   $0x38c7,0x4(%esp)
    2950:	00 
    2951:	89 04 24             	mov    %eax,(%esp)
    2954:	e8 6f 04 00 00       	call   2dc8 <write>
    2959:	83 e8 01             	sub    $0x1,%eax
    295c:	74 14                	je     2972 <preempt+0x92>
      printf(1, "preempt write error");
    295e:	c7 44 24 04 45 3e 00 	movl   $0x3e45,0x4(%esp)
    2965:	00 
    2966:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    296d:	e8 be 05 00 00       	call   2f30 <printf>
    close(pfds[1]);
    2972:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2975:	89 04 24             	mov    %eax,(%esp)
    2978:	e8 53 04 00 00       	call   2dd0 <close>
    297d:	eb fe                	jmp    297d <preempt+0x9d>
    for(;;)
      ;
  }

  close(pfds[1]);
    297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2982:	89 04 24             	mov    %eax,(%esp)
    2985:	e8 46 04 00 00       	call   2dd0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    298a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    298d:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    2994:	00 
    2995:	c7 44 24 04 a0 44 00 	movl   $0x44a0,0x4(%esp)
    299c:	00 
    299d:	89 04 24             	mov    %eax,(%esp)
    29a0:	e8 1b 04 00 00       	call   2dc0 <read>
    29a5:	83 e8 01             	sub    $0x1,%eax
    29a8:	74 1c                	je     29c6 <preempt+0xe6>
    printf(1, "preempt read error");
    29aa:	c7 44 24 04 59 3e 00 	movl   $0x3e59,0x4(%esp)
    29b1:	00 
    29b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b9:	e8 72 05 00 00       	call   2f30 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    29be:	83 c4 1c             	add    $0x1c,%esp
    29c1:	5b                   	pop    %ebx
    29c2:	5e                   	pop    %esi
    29c3:	5f                   	pop    %edi
    29c4:	5d                   	pop    %ebp
    29c5:	c3                   	ret    
  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
    29c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    29c9:	89 04 24             	mov    %eax,(%esp)
    29cc:	e8 ff 03 00 00       	call   2dd0 <close>
  printf(1, "kill... ");
    29d1:	c7 44 24 04 6c 3e 00 	movl   $0x3e6c,0x4(%esp)
    29d8:	00 
    29d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29e0:	e8 4b 05 00 00       	call   2f30 <printf>
  kill(pid1);
    29e5:	89 3c 24             	mov    %edi,(%esp)
    29e8:	e8 eb 03 00 00       	call   2dd8 <kill>
  kill(pid2);
    29ed:	89 34 24             	mov    %esi,(%esp)
    29f0:	e8 e3 03 00 00       	call   2dd8 <kill>
  kill(pid3);
    29f5:	89 1c 24             	mov    %ebx,(%esp)
    29f8:	e8 db 03 00 00       	call   2dd8 <kill>
  printf(1, "wait... ");
    29fd:	c7 44 24 04 75 3e 00 	movl   $0x3e75,0x4(%esp)
    2a04:	00 
    2a05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a0c:	e8 1f 05 00 00       	call   2f30 <printf>
  wait();
    2a11:	e8 9a 03 00 00       	call   2db0 <wait>
  wait();
    2a16:	e8 95 03 00 00       	call   2db0 <wait>
    2a1b:	90                   	nop    
    2a1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  wait();
    2a20:	e8 8b 03 00 00       	call   2db0 <wait>
  printf(1, "preempt ok\n");
    2a25:	c7 44 24 04 7e 3e 00 	movl   $0x3e7e,0x4(%esp)
    2a2c:	00 
    2a2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a34:	e8 f7 04 00 00       	call   2f30 <printf>
    2a39:	eb 83                	jmp    29be <preempt+0xde>
    2a3b:	90                   	nop    
    2a3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00002a40 <exectest>:
  printf(stdout, "mkdir test\n");
}

void
exectest(void)
{
    2a40:	55                   	push   %ebp
    2a41:	89 e5                	mov    %esp,%ebp
    2a43:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
    2a46:	a1 70 44 00 00       	mov    0x4470,%eax
    2a4b:	c7 44 24 04 8a 3e 00 	movl   $0x3e8a,0x4(%esp)
    2a52:	00 
    2a53:	89 04 24             	mov    %eax,(%esp)
    2a56:	e8 d5 04 00 00       	call   2f30 <printf>
  if(exec("echo", echo_args) < 0) {
    2a5b:	c7 44 24 04 50 44 00 	movl   $0x4450,0x4(%esp)
    2a62:	00 
    2a63:	c7 04 24 03 32 00 00 	movl   $0x3203,(%esp)
    2a6a:	e8 71 03 00 00       	call   2de0 <exec>
    2a6f:	85 c0                	test   %eax,%eax
    2a71:	78 02                	js     2a75 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
    2a73:	c9                   	leave  
    2a74:	c3                   	ret    
void
exectest(void)
{
  printf(stdout, "exec test\n");
  if(exec("echo", echo_args) < 0) {
    printf(stdout, "exec echo failed\n");
    2a75:	a1 70 44 00 00       	mov    0x4470,%eax
    2a7a:	c7 44 24 04 95 3e 00 	movl   $0x3e95,0x4(%esp)
    2a81:	00 
    2a82:	89 04 24             	mov    %eax,(%esp)
    2a85:	e8 a6 04 00 00       	call   2f30 <printf>
    exit();
    2a8a:	e8 19 03 00 00       	call   2da8 <exit>
    2a8f:	90                   	nop    

00002a90 <main>:
  printf(1, "fork test OK\n");
}

int
main(int argc, char *argv[])
{
    2a90:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    2a94:	83 e4 f0             	and    $0xfffffff0,%esp
    2a97:	ff 71 fc             	pushl  -0x4(%ecx)
    2a9a:	55                   	push   %ebp
    2a9b:	89 e5                	mov    %esp,%ebp
    2a9d:	51                   	push   %ecx
    2a9e:	83 ec 14             	sub    $0x14,%esp
  printf(1, "usertests starting\n");
    2aa1:	c7 44 24 04 a7 3e 00 	movl   $0x3ea7,0x4(%esp)
    2aa8:	00 
    2aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab0:	e8 7b 04 00 00       	call   2f30 <printf>

  if(open("usertests.ran", 0) >= 0){
    2ab5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2abc:	00 
    2abd:	c7 04 24 bb 3e 00 00 	movl   $0x3ebb,(%esp)
    2ac4:	e8 1f 03 00 00       	call   2de8 <open>
    2ac9:	85 c0                	test   %eax,%eax
    2acb:	78 19                	js     2ae6 <main+0x56>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    2acd:	c7 44 24 04 0c 44 00 	movl   $0x440c,0x4(%esp)
    2ad4:	00 
    2ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2adc:	e8 4f 04 00 00       	call   2f30 <printf>
    exit();
    2ae1:	e8 c2 02 00 00       	call   2da8 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    2ae6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2aed:	00 
    2aee:	c7 04 24 bb 3e 00 00 	movl   $0x3ebb,(%esp)
    2af5:	e8 ee 02 00 00       	call   2de8 <open>
    2afa:	89 04 24             	mov    %eax,(%esp)
    2afd:	e8 ce 02 00 00       	call   2dd0 <close>

  opentest();
    2b02:	e8 f9 d4 ff ff       	call   0 <opentest>
  writetest();
    2b07:	e8 84 f9 ff ff       	call   2490 <writetest>
    2b0c:	8d 74 26 00          	lea    0x0(%esi),%esi
  writetest1();
    2b10:	e8 8b f7 ff ff       	call   22a0 <writetest1>
  createtest();
    2b15:	e8 f6 df ff ff       	call   b10 <createtest>

  mem();
    2b1a:	e8 71 fb ff ff       	call   2690 <mem>
    2b1f:	90                   	nop    
  pipe1();
    2b20:	e8 0b fc ff ff       	call   2730 <pipe1>
  preempt();
    2b25:	e8 b6 fd ff ff       	call   28e0 <preempt>
  exitwait();
    2b2a:	e8 41 d6 ff ff       	call   170 <exitwait>
    2b2f:	90                   	nop    

  rmdot();
    2b30:	e8 4b d9 ff ff       	call   480 <rmdot>
  fourteen();
    2b35:	e8 c6 d6 ff ff       	call   200 <fourteen>
  bigfile();
    2b3a:	e8 f1 e2 ff ff       	call   e30 <bigfile>
    2b3f:	90                   	nop    
  subdir();
    2b40:	e8 eb e4 ff ff       	call   1030 <subdir>
  concreate();
    2b45:	e8 76 ec ff ff       	call   17c0 <concreate>
  linktest();
    2b4a:	e8 31 ef ff ff       	call   1a80 <linktest>
    2b4f:	90                   	nop    
  unlinkread();
    2b50:	e8 8b f1 ff ff       	call   1ce0 <unlinkread>
  createdelete();
    2b55:	e8 26 dc ff ff       	call   780 <createdelete>
  twofiles();
    2b5a:	e8 61 f3 ff ff       	call   1ec0 <twofiles>
    2b5f:	90                   	nop    
  sharedfd();
    2b60:	e8 7b f5 ff ff       	call   20e0 <sharedfd>
  dirfile();
    2b65:	e8 86 e0 ff ff       	call   bf0 <dirfile>
  iref();
    2b6a:	e8 f1 d7 ff ff       	call   360 <iref>
    2b6f:	90                   	nop    
  forktest();
    2b70:	e8 2b d5 ff ff       	call   a0 <forktest>
  bigdir(); // slow
    2b75:	e8 a6 da ff ff       	call   620 <bigdir>

  exectest();
    2b7a:	e8 c1 fe ff ff       	call   2a40 <exectest>
    2b7f:	90                   	nop    

  exit();
    2b80:	e8 23 02 00 00       	call   2da8 <exit>
    2b85:	90                   	nop    
    2b86:	90                   	nop    
    2b87:	90                   	nop    
    2b88:	90                   	nop    
    2b89:	90                   	nop    
    2b8a:	90                   	nop    
    2b8b:	90                   	nop    
    2b8c:	90                   	nop    
    2b8d:	90                   	nop    
    2b8e:	90                   	nop    
    2b8f:	90                   	nop    

00002b90 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
    2b90:	55                   	push   %ebp
    2b91:	89 e5                	mov    %esp,%ebp
    2b93:	53                   	push   %ebx
    2b94:	8b 5d 08             	mov    0x8(%ebp),%ebx
    2b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    2b9a:	89 da                	mov    %ebx,%edx
    2b9c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    2ba0:	0f b6 01             	movzbl (%ecx),%eax
    2ba3:	83 c1 01             	add    $0x1,%ecx
    2ba6:	88 02                	mov    %al,(%edx)
    2ba8:	83 c2 01             	add    $0x1,%edx
    2bab:	84 c0                	test   %al,%al
    2bad:	75 f1                	jne    2ba0 <strcpy+0x10>
    ;
  return os;
}
    2baf:	89 d8                	mov    %ebx,%eax
    2bb1:	5b                   	pop    %ebx
    2bb2:	5d                   	pop    %ebp
    2bb3:	c3                   	ret    
    2bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00002bc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    2bc0:	55                   	push   %ebp
    2bc1:	89 e5                	mov    %esp,%ebp
    2bc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    2bc6:	53                   	push   %ebx
    2bc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
    2bca:	0f b6 01             	movzbl (%ecx),%eax
    2bcd:	84 c0                	test   %al,%al
    2bcf:	74 24                	je     2bf5 <strcmp+0x35>
    2bd1:	0f b6 13             	movzbl (%ebx),%edx
    2bd4:	38 d0                	cmp    %dl,%al
    2bd6:	74 12                	je     2bea <strcmp+0x2a>
    2bd8:	eb 1e                	jmp    2bf8 <strcmp+0x38>
    2bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2be0:	0f b6 13             	movzbl (%ebx),%edx
    2be3:	83 c1 01             	add    $0x1,%ecx
    2be6:	38 d0                	cmp    %dl,%al
    2be8:	75 0e                	jne    2bf8 <strcmp+0x38>
    2bea:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    2bee:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2bf1:	84 c0                	test   %al,%al
    2bf3:	75 eb                	jne    2be0 <strcmp+0x20>
    2bf5:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2bf8:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2bf9:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2bfc:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2bfd:	0f b6 d2             	movzbl %dl,%edx
    2c00:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2c02:	c3                   	ret    
    2c03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002c10 <strlen>:

uint
strlen(char *s)
{
    2c10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
    2c11:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    2c13:	89 e5                	mov    %esp,%ebp
    2c15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    2c18:	80 39 00             	cmpb   $0x0,(%ecx)
    2c1b:	74 0e                	je     2c2b <strlen+0x1b>
    2c1d:	31 d2                	xor    %edx,%edx
    2c1f:	90                   	nop    
    2c20:	83 c2 01             	add    $0x1,%edx
    2c23:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
    2c27:	89 d0                	mov    %edx,%eax
    2c29:	75 f5                	jne    2c20 <strlen+0x10>
    ;
  return n;
}
    2c2b:	5d                   	pop    %ebp
    2c2c:	c3                   	ret    
    2c2d:	8d 76 00             	lea    0x0(%esi),%esi

00002c30 <memset>:

void*
memset(void *dst, int c, uint n)
{
    2c30:	55                   	push   %ebp
    2c31:	89 e5                	mov    %esp,%ebp
    2c33:	8b 45 10             	mov    0x10(%ebp),%eax
    2c36:	53                   	push   %ebx
    2c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
    2c3a:	85 c0                	test   %eax,%eax
    2c3c:	74 10                	je     2c4e <memset+0x1e>
    2c3e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
    2c42:	31 d2                	xor    %edx,%edx
    *d++ = c;
    2c44:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
    2c47:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
    2c4a:	39 c2                	cmp    %eax,%edx
    2c4c:	75 f6                	jne    2c44 <memset+0x14>
    *d++ = c;
  return dst;
}
    2c4e:	89 d8                	mov    %ebx,%eax
    2c50:	5b                   	pop    %ebx
    2c51:	5d                   	pop    %ebp
    2c52:	c3                   	ret    
    2c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002c60 <strchr>:

char*
strchr(const char *s, char c)
{
    2c60:	55                   	push   %ebp
    2c61:	89 e5                	mov    %esp,%ebp
    2c63:	8b 45 08             	mov    0x8(%ebp),%eax
    2c66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    2c6a:	0f b6 10             	movzbl (%eax),%edx
    2c6d:	84 d2                	test   %dl,%dl
    2c6f:	75 0c                	jne    2c7d <strchr+0x1d>
    2c71:	eb 11                	jmp    2c84 <strchr+0x24>
    2c73:	83 c0 01             	add    $0x1,%eax
    2c76:	0f b6 10             	movzbl (%eax),%edx
    2c79:	84 d2                	test   %dl,%dl
    2c7b:	74 07                	je     2c84 <strchr+0x24>
    if(*s == c)
    2c7d:	38 ca                	cmp    %cl,%dl
    2c7f:	90                   	nop    
    2c80:	75 f1                	jne    2c73 <strchr+0x13>
      return (char*) s;
  return 0;
}
    2c82:	5d                   	pop    %ebp
    2c83:	c3                   	ret    
    2c84:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    2c85:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
    2c87:	c3                   	ret    
    2c88:	90                   	nop    
    2c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00002c90 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    2c90:	55                   	push   %ebp
    2c91:	89 e5                	mov    %esp,%ebp
    2c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
    2c96:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2c97:	31 db                	xor    %ebx,%ebx
    2c99:	0f b6 11             	movzbl (%ecx),%edx
    2c9c:	8d 42 d0             	lea    -0x30(%edx),%eax
    2c9f:	3c 09                	cmp    $0x9,%al
    2ca1:	77 18                	ja     2cbb <atoi+0x2b>
    n = n*10 + *s++ - '0';
    2ca3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
    2ca6:	0f be d2             	movsbl %dl,%edx
    2ca9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2cad:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
    2cb1:	83 c1 01             	add    $0x1,%ecx
    2cb4:	8d 42 d0             	lea    -0x30(%edx),%eax
    2cb7:	3c 09                	cmp    $0x9,%al
    2cb9:	76 e8                	jbe    2ca3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
    2cbb:	89 d8                	mov    %ebx,%eax
    2cbd:	5b                   	pop    %ebx
    2cbe:	5d                   	pop    %ebp
    2cbf:	c3                   	ret    

00002cc0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    2cc0:	55                   	push   %ebp
    2cc1:	89 e5                	mov    %esp,%ebp
    2cc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    2cc6:	56                   	push   %esi
    2cc7:	8b 75 08             	mov    0x8(%ebp),%esi
    2cca:	53                   	push   %ebx
    2ccb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2cce:	85 c9                	test   %ecx,%ecx
    2cd0:	7e 10                	jle    2ce2 <memmove+0x22>
    2cd2:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
    2cd4:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
    2cd8:	88 04 32             	mov    %al,(%edx,%esi,1)
    2cdb:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2cde:	39 ca                	cmp    %ecx,%edx
    2ce0:	75 f2                	jne    2cd4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
    2ce2:	89 f0                	mov    %esi,%eax
    2ce4:	5b                   	pop    %ebx
    2ce5:	5e                   	pop    %esi
    2ce6:	5d                   	pop    %ebp
    2ce7:	c3                   	ret    
    2ce8:	90                   	nop    
    2ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00002cf0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2cf0:	55                   	push   %ebp
    2cf1:	89 e5                	mov    %esp,%ebp
    2cf3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2cf9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    2cfc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    2cff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2d04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d0b:	00 
    2d0c:	89 04 24             	mov    %eax,(%esp)
    2d0f:	e8 d4 00 00 00       	call   2de8 <open>
  if(fd < 0)
    2d14:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2d16:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    2d18:	78 19                	js     2d33 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    2d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
    2d1d:	89 1c 24             	mov    %ebx,(%esp)
    2d20:	89 44 24 04          	mov    %eax,0x4(%esp)
    2d24:	e8 d7 00 00 00       	call   2e00 <fstat>
  close(fd);
    2d29:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    2d2c:	89 c6                	mov    %eax,%esi
  close(fd);
    2d2e:	e8 9d 00 00 00       	call   2dd0 <close>
  return r;
}
    2d33:	89 f0                	mov    %esi,%eax
    2d35:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    2d38:	8b 75 fc             	mov    -0x4(%ebp),%esi
    2d3b:	89 ec                	mov    %ebp,%esp
    2d3d:	5d                   	pop    %ebp
    2d3e:	c3                   	ret    
    2d3f:	90                   	nop    

00002d40 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    2d40:	55                   	push   %ebp
    2d41:	89 e5                	mov    %esp,%ebp
    2d43:	57                   	push   %edi
    2d44:	56                   	push   %esi
    2d45:	31 f6                	xor    %esi,%esi
    2d47:	53                   	push   %ebx
    2d48:	83 ec 1c             	sub    $0x1c,%esp
    2d4b:	8b 7d 08             	mov    0x8(%ebp),%edi
    2d4e:	eb 06                	jmp    2d56 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    2d50:	3c 0d                	cmp    $0xd,%al
    2d52:	74 39                	je     2d8d <gets+0x4d>
    2d54:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2d56:	8d 5e 01             	lea    0x1(%esi),%ebx
    2d59:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    2d5c:	7d 31                	jge    2d8f <gets+0x4f>
    cc = read(0, &c, 1);
    2d5e:	8d 45 f3             	lea    -0xd(%ebp),%eax
    2d61:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2d68:	00 
    2d69:	89 44 24 04          	mov    %eax,0x4(%esp)
    2d6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d74:	e8 47 00 00 00       	call   2dc0 <read>
    if(cc < 1)
    2d79:	85 c0                	test   %eax,%eax
    2d7b:	7e 12                	jle    2d8f <gets+0x4f>
      break;
    buf[i++] = c;
    2d7d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    2d81:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
    2d85:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    2d89:	3c 0a                	cmp    $0xa,%al
    2d8b:	75 c3                	jne    2d50 <gets+0x10>
    2d8d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    2d8f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    2d93:	89 f8                	mov    %edi,%eax
    2d95:	83 c4 1c             	add    $0x1c,%esp
    2d98:	5b                   	pop    %ebx
    2d99:	5e                   	pop    %esi
    2d9a:	5f                   	pop    %edi
    2d9b:	5d                   	pop    %ebp
    2d9c:	c3                   	ret    
    2d9d:	90                   	nop    
    2d9e:	90                   	nop    
    2d9f:	90                   	nop    

00002da0 <fork>:
    2da0:	b8 01 00 00 00       	mov    $0x1,%eax
    2da5:	cd 30                	int    $0x30
    2da7:	c3                   	ret    

00002da8 <exit>:
    2da8:	b8 02 00 00 00       	mov    $0x2,%eax
    2dad:	cd 30                	int    $0x30
    2daf:	c3                   	ret    

00002db0 <wait>:
    2db0:	b8 03 00 00 00       	mov    $0x3,%eax
    2db5:	cd 30                	int    $0x30
    2db7:	c3                   	ret    

00002db8 <pipe>:
    2db8:	b8 04 00 00 00       	mov    $0x4,%eax
    2dbd:	cd 30                	int    $0x30
    2dbf:	c3                   	ret    

00002dc0 <read>:
    2dc0:	b8 06 00 00 00       	mov    $0x6,%eax
    2dc5:	cd 30                	int    $0x30
    2dc7:	c3                   	ret    

00002dc8 <write>:
    2dc8:	b8 05 00 00 00       	mov    $0x5,%eax
    2dcd:	cd 30                	int    $0x30
    2dcf:	c3                   	ret    

00002dd0 <close>:
    2dd0:	b8 07 00 00 00       	mov    $0x7,%eax
    2dd5:	cd 30                	int    $0x30
    2dd7:	c3                   	ret    

00002dd8 <kill>:
    2dd8:	b8 08 00 00 00       	mov    $0x8,%eax
    2ddd:	cd 30                	int    $0x30
    2ddf:	c3                   	ret    

00002de0 <exec>:
    2de0:	b8 09 00 00 00       	mov    $0x9,%eax
    2de5:	cd 30                	int    $0x30
    2de7:	c3                   	ret    

00002de8 <open>:
    2de8:	b8 0a 00 00 00       	mov    $0xa,%eax
    2ded:	cd 30                	int    $0x30
    2def:	c3                   	ret    

00002df0 <mknod>:
    2df0:	b8 0b 00 00 00       	mov    $0xb,%eax
    2df5:	cd 30                	int    $0x30
    2df7:	c3                   	ret    

00002df8 <unlink>:
    2df8:	b8 0c 00 00 00       	mov    $0xc,%eax
    2dfd:	cd 30                	int    $0x30
    2dff:	c3                   	ret    

00002e00 <fstat>:
    2e00:	b8 0d 00 00 00       	mov    $0xd,%eax
    2e05:	cd 30                	int    $0x30
    2e07:	c3                   	ret    

00002e08 <link>:
    2e08:	b8 0e 00 00 00       	mov    $0xe,%eax
    2e0d:	cd 30                	int    $0x30
    2e0f:	c3                   	ret    

00002e10 <mkdir>:
    2e10:	b8 0f 00 00 00       	mov    $0xf,%eax
    2e15:	cd 30                	int    $0x30
    2e17:	c3                   	ret    

00002e18 <chdir>:
    2e18:	b8 10 00 00 00       	mov    $0x10,%eax
    2e1d:	cd 30                	int    $0x30
    2e1f:	c3                   	ret    

00002e20 <dup>:
    2e20:	b8 11 00 00 00       	mov    $0x11,%eax
    2e25:	cd 30                	int    $0x30
    2e27:	c3                   	ret    

00002e28 <getpid>:
    2e28:	b8 12 00 00 00       	mov    $0x12,%eax
    2e2d:	cd 30                	int    $0x30
    2e2f:	c3                   	ret    

00002e30 <sbrk>:
    2e30:	b8 13 00 00 00       	mov    $0x13,%eax
    2e35:	cd 30                	int    $0x30
    2e37:	c3                   	ret    

00002e38 <sleep>:
    2e38:	b8 14 00 00 00       	mov    $0x14,%eax
    2e3d:	cd 30                	int    $0x30
    2e3f:	c3                   	ret    

00002e40 <tick>:
    2e40:	b8 15 00 00 00       	mov    $0x15,%eax
    2e45:	cd 30                	int    $0x30
    2e47:	c3                   	ret    

00002e48 <fork_tickets>:
    2e48:	b8 16 00 00 00       	mov    $0x16,%eax
    2e4d:	cd 30                	int    $0x30
    2e4f:	c3                   	ret    

00002e50 <fork_thread>:
    2e50:	b8 17 00 00 00       	mov    $0x17,%eax
    2e55:	cd 30                	int    $0x30
    2e57:	c3                   	ret    

00002e58 <wait_thread>:
    2e58:	b8 18 00 00 00       	mov    $0x18,%eax
    2e5d:	cd 30                	int    $0x30
    2e5f:	c3                   	ret    

00002e60 <sleep_cond>:
    2e60:	b8 19 00 00 00       	mov    $0x19,%eax
    2e65:	cd 30                	int    $0x30
    2e67:	c3                   	ret    

00002e68 <wake_cond>:
    2e68:	b8 1a 00 00 00       	mov    $0x1a,%eax
    2e6d:	cd 30                	int    $0x30
    2e6f:	c3                   	ret    

00002e70 <xchng>:
    2e70:	b8 1b 00 00 00       	mov    $0x1b,%eax
    2e75:	cd 30                	int    $0x30
    2e77:	c3                   	ret    

00002e78 <check>:
    2e78:	b8 1c 00 00 00       	mov    $0x1c,%eax
    2e7d:	cd 30                	int    $0x30
    2e7f:	c3                   	ret    

00002e80 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    2e80:	55                   	push   %ebp
    2e81:	89 e5                	mov    %esp,%ebp
    2e83:	83 ec 18             	sub    $0x18,%esp
    2e86:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
    2e89:	8d 55 fc             	lea    -0x4(%ebp),%edx
    2e8c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e93:	00 
    2e94:	89 54 24 04          	mov    %edx,0x4(%esp)
    2e98:	89 04 24             	mov    %eax,(%esp)
    2e9b:	e8 28 ff ff ff       	call   2dc8 <write>
}
    2ea0:	c9                   	leave  
    2ea1:	c3                   	ret    
    2ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    2ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00002eb0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    2eb0:	55                   	push   %ebp
    2eb1:	89 e5                	mov    %esp,%ebp
    2eb3:	57                   	push   %edi
    2eb4:	56                   	push   %esi
    2eb5:	89 ce                	mov    %ecx,%esi
    2eb7:	53                   	push   %ebx
    2eb8:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2ebb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    2ebe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2ec1:	85 c9                	test   %ecx,%ecx
    2ec3:	74 04                	je     2ec9 <printint+0x19>
    2ec5:	85 d2                	test   %edx,%edx
    2ec7:	78 54                	js     2f1d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    2ec9:	89 d0                	mov    %edx,%eax
    2ecb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    2ed2:	31 db                	xor    %ebx,%ebx
    2ed4:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    2ed7:	31 d2                	xor    %edx,%edx
    2ed9:	f7 f6                	div    %esi
    2edb:	89 c1                	mov    %eax,%ecx
    2edd:	0f b6 82 3f 44 00 00 	movzbl 0x443f(%edx),%eax
    2ee4:	88 04 3b             	mov    %al,(%ebx,%edi,1)
    2ee7:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
    2eea:	85 c9                	test   %ecx,%ecx
    2eec:	89 c8                	mov    %ecx,%eax
    2eee:	75 e7                	jne    2ed7 <printint+0x27>
  if(neg)
    2ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2ef3:	85 c0                	test   %eax,%eax
    2ef5:	74 08                	je     2eff <printint+0x4f>
    buf[i++] = '-';
    2ef7:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
    2efc:	83 c3 01             	add    $0x1,%ebx
    2eff:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
    2f02:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
    2f06:	83 eb 01             	sub    $0x1,%ebx
    2f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2f0c:	e8 6f ff ff ff       	call   2e80 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2f11:	39 fb                	cmp    %edi,%ebx
    2f13:	75 ed                	jne    2f02 <printint+0x52>
    putc(fd, buf[i]);
}
    2f15:	83 c4 1c             	add    $0x1c,%esp
    2f18:	5b                   	pop    %ebx
    2f19:	5e                   	pop    %esi
    2f1a:	5f                   	pop    %edi
    2f1b:	5d                   	pop    %ebp
    2f1c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    2f1d:	89 d0                	mov    %edx,%eax
    2f1f:	f7 d8                	neg    %eax
    2f21:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
    2f28:	eb a8                	jmp    2ed2 <printint+0x22>
    2f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00002f30 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2f30:	55                   	push   %ebp
    2f31:	89 e5                	mov    %esp,%ebp
    2f33:	57                   	push   %edi
    2f34:	56                   	push   %esi
    2f35:	53                   	push   %ebx
    2f36:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2f39:	8b 55 0c             	mov    0xc(%ebp),%edx
    2f3c:	0f b6 02             	movzbl (%edx),%eax
    2f3f:	84 c0                	test   %al,%al
    2f41:	0f 84 84 00 00 00    	je     2fcb <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    2f47:	8d 4d 10             	lea    0x10(%ebp),%ecx
    2f4a:	89 d7                	mov    %edx,%edi
    2f4c:	31 f6                	xor    %esi,%esi
    2f4e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
    2f51:	eb 18                	jmp    2f6b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    2f53:	83 fb 25             	cmp    $0x25,%ebx
    2f56:	75 7b                	jne    2fd3 <printf+0xa3>
    2f58:	66 be 25 00          	mov    $0x25,%si
    2f5c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2f60:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    2f64:	83 c7 01             	add    $0x1,%edi
    2f67:	84 c0                	test   %al,%al
    2f69:	74 60                	je     2fcb <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
    2f6b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    2f6d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
    2f70:	74 e1                	je     2f53 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    2f72:	83 fe 25             	cmp    $0x25,%esi
    2f75:	75 e9                	jne    2f60 <printf+0x30>
      if(c == 'd'){
    2f77:	83 fb 64             	cmp    $0x64,%ebx
    2f7a:	0f 84 db 00 00 00    	je     305b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    2f80:	83 fb 78             	cmp    $0x78,%ebx
    2f83:	74 5b                	je     2fe0 <printf+0xb0>
    2f85:	83 fb 70             	cmp    $0x70,%ebx
    2f88:	74 56                	je     2fe0 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    2f8a:	83 fb 73             	cmp    $0x73,%ebx
    2f8d:	8d 76 00             	lea    0x0(%esi),%esi
    2f90:	74 72                	je     3004 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    2f92:	83 fb 63             	cmp    $0x63,%ebx
    2f95:	0f 84 a7 00 00 00    	je     3042 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    2f9b:	83 fb 25             	cmp    $0x25,%ebx
    2f9e:	66 90                	xchg   %ax,%ax
    2fa0:	0f 84 da 00 00 00    	je     3080 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2fa6:	8b 45 08             	mov    0x8(%ebp),%eax
    2fa9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
    2fae:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2fb0:	e8 cb fe ff ff       	call   2e80 <putc>
        putc(fd, c);
    2fb5:	8b 45 08             	mov    0x8(%ebp),%eax
    2fb8:	0f be d3             	movsbl %bl,%edx
    2fbb:	e8 c0 fe ff ff       	call   2e80 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2fc0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    2fc4:	83 c7 01             	add    $0x1,%edi
    2fc7:	84 c0                	test   %al,%al
    2fc9:	75 a0                	jne    2f6b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    2fcb:	83 c4 0c             	add    $0xc,%esp
    2fce:	5b                   	pop    %ebx
    2fcf:	5e                   	pop    %esi
    2fd0:	5f                   	pop    %edi
    2fd1:	5d                   	pop    %ebp
    2fd2:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    2fd3:	8b 45 08             	mov    0x8(%ebp),%eax
    2fd6:	0f be d3             	movsbl %bl,%edx
    2fd9:	e8 a2 fe ff ff       	call   2e80 <putc>
    2fde:	eb 80                	jmp    2f60 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fe3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    2fe8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ff1:	8b 10                	mov    (%eax),%edx
    2ff3:	8b 45 08             	mov    0x8(%ebp),%eax
    2ff6:	e8 b5 fe ff ff       	call   2eb0 <printint>
        ap++;
    2ffb:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    2fff:	e9 5c ff ff ff       	jmp    2f60 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
    3004:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3007:	8b 02                	mov    (%edx),%eax
        ap++;
    3009:	83 c2 04             	add    $0x4,%edx
    300c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
    300f:	ba 38 44 00 00       	mov    $0x4438,%edx
    3014:	85 c0                	test   %eax,%eax
    3016:	75 26                	jne    303e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
    3018:	0f b6 02             	movzbl (%edx),%eax
    301b:	84 c0                	test   %al,%al
    301d:	74 18                	je     3037 <printf+0x107>
    301f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
    3021:	0f be d0             	movsbl %al,%edx
    3024:	8b 45 08             	mov    0x8(%ebp),%eax
    3027:	e8 54 fe ff ff       	call   2e80 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    302c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    3030:	83 c3 01             	add    $0x1,%ebx
    3033:	84 c0                	test   %al,%al
    3035:	75 ea                	jne    3021 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3037:	31 f6                	xor    %esi,%esi
    3039:	e9 22 ff ff ff       	jmp    2f60 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    303e:	89 c2                	mov    %eax,%edx
    3040:	eb d6                	jmp    3018 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3042:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
    3045:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3047:	8b 45 08             	mov    0x8(%ebp),%eax
    304a:	0f be 11             	movsbl (%ecx),%edx
    304d:	e8 2e fe ff ff       	call   2e80 <putc>
        ap++;
    3052:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    3056:	e9 05 ff ff ff       	jmp    2f60 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    305e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    3063:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3066:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    306d:	8b 10                	mov    (%eax),%edx
    306f:	8b 45 08             	mov    0x8(%ebp),%eax
    3072:	e8 39 fe ff ff       	call   2eb0 <printint>
        ap++;
    3077:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
    307b:	e9 e0 fe ff ff       	jmp    2f60 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
    3080:	8b 45 08             	mov    0x8(%ebp),%eax
    3083:	ba 25 00 00 00       	mov    $0x25,%edx
    3088:	31 f6                	xor    %esi,%esi
    308a:	e8 f1 fd ff ff       	call   2e80 <putc>
    308f:	e9 cc fe ff ff       	jmp    2f60 <printf+0x30>
    3094:	90                   	nop    
    3095:	90                   	nop    
    3096:	90                   	nop    
    3097:	90                   	nop    
    3098:	90                   	nop    
    3099:	90                   	nop    
    309a:	90                   	nop    
    309b:	90                   	nop    
    309c:	90                   	nop    
    309d:	90                   	nop    
    309e:	90                   	nop    
    309f:	90                   	nop    

000030a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    30a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    30a1:	8b 0d 88 44 00 00    	mov    0x4488,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
    30a7:	89 e5                	mov    %esp,%ebp
    30a9:	56                   	push   %esi
    30aa:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    30ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    30ae:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    30b1:	39 d9                	cmp    %ebx,%ecx
    30b3:	73 18                	jae    30cd <free+0x2d>
    30b5:	8b 11                	mov    (%ecx),%edx
    30b7:	39 d3                	cmp    %edx,%ebx
    30b9:	72 17                	jb     30d2 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    30bb:	39 d1                	cmp    %edx,%ecx
    30bd:	72 08                	jb     30c7 <free+0x27>
    30bf:	39 d9                	cmp    %ebx,%ecx
    30c1:	72 0f                	jb     30d2 <free+0x32>
    30c3:	39 d3                	cmp    %edx,%ebx
    30c5:	72 0b                	jb     30d2 <free+0x32>
    30c7:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    30c9:	39 d9                	cmp    %ebx,%ecx
    30cb:	72 e8                	jb     30b5 <free+0x15>
    30cd:	8b 11                	mov    (%ecx),%edx
    30cf:	90                   	nop    
    30d0:	eb e9                	jmp    30bb <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    30d2:	8b 73 04             	mov    0x4(%ebx),%esi
    30d5:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
    30d8:	39 d0                	cmp    %edx,%eax
    30da:	74 18                	je     30f4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    30dc:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
    30de:	8b 51 04             	mov    0x4(%ecx),%edx
    30e1:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    30e4:	39 d8                	cmp    %ebx,%eax
    30e6:	74 20                	je     3108 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    30e8:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
    30ea:	5b                   	pop    %ebx
    30eb:	5e                   	pop    %esi
    30ec:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    30ed:	89 0d 88 44 00 00    	mov    %ecx,0x4488
}
    30f3:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    30f4:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
    30f7:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    30f9:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    30fc:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    30ff:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    3101:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
    3104:	39 d8                	cmp    %ebx,%eax
    3106:	75 e0                	jne    30e8 <free+0x48>
    p->s.size += bp->s.size;
    3108:	03 53 04             	add    0x4(%ebx),%edx
    310b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
    310e:	8b 13                	mov    (%ebx),%edx
    3110:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    3112:	5b                   	pop    %ebx
    3113:	5e                   	pop    %esi
    3114:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    3115:	89 0d 88 44 00 00    	mov    %ecx,0x4488
}
    311b:	c3                   	ret    
    311c:	8d 74 26 00          	lea    0x0(%esi),%esi

00003120 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3120:	55                   	push   %ebp
    3121:	89 e5                	mov    %esp,%ebp
    3123:	57                   	push   %edi
    3124:	56                   	push   %esi
    3125:	53                   	push   %ebx
    3126:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3129:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    312c:	8b 15 88 44 00 00    	mov    0x4488,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3132:	83 c0 07             	add    $0x7,%eax
    3135:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
    3138:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    313a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
    313d:	0f 84 8a 00 00 00    	je     31cd <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3143:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    3145:	8b 41 04             	mov    0x4(%ecx),%eax
    3148:	39 c3                	cmp    %eax,%ebx
    314a:	76 1a                	jbe    3166 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    314c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
    3153:	3b 0d 88 44 00 00    	cmp    0x4488,%ecx
    3159:	89 ca                	mov    %ecx,%edx
    315b:	74 29                	je     3186 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    315d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
    315f:	8b 41 04             	mov    0x4(%ecx),%eax
    3162:	39 c3                	cmp    %eax,%ebx
    3164:	77 ed                	ja     3153 <malloc+0x33>
      if(p->s.size == nunits)
    3166:	39 c3                	cmp    %eax,%ebx
    3168:	74 5d                	je     31c7 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    316a:	29 d8                	sub    %ebx,%eax
    316c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
    316f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
    3172:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
    3175:	89 15 88 44 00 00    	mov    %edx,0x4488
      return (void*) (p + 1);
    317b:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    317e:	83 c4 0c             	add    $0xc,%esp
    3181:	5b                   	pop    %ebx
    3182:	5e                   	pop    %esi
    3183:	5f                   	pop    %edi
    3184:	5d                   	pop    %ebp
    3185:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    3186:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    318c:	89 de                	mov    %ebx,%esi
    318e:	89 f8                	mov    %edi,%eax
    3190:	76 29                	jbe    31bb <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
    3192:	89 04 24             	mov    %eax,(%esp)
    3195:	e8 96 fc ff ff       	call   2e30 <sbrk>
  if(p == (char*) -1)
    319a:	83 f8 ff             	cmp    $0xffffffff,%eax
    319d:	74 18                	je     31b7 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    319f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    31a2:	83 c0 08             	add    $0x8,%eax
    31a5:	89 04 24             	mov    %eax,(%esp)
    31a8:	e8 f3 fe ff ff       	call   30a0 <free>
  return freep;
    31ad:	8b 15 88 44 00 00    	mov    0x4488,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    31b3:	85 d2                	test   %edx,%edx
    31b5:	75 a6                	jne    315d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    31b7:	31 c0                	xor    %eax,%eax
    31b9:	eb c3                	jmp    317e <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    31bb:	be 00 10 00 00       	mov    $0x1000,%esi
    31c0:	b8 00 80 00 00       	mov    $0x8000,%eax
    31c5:	eb cb                	jmp    3192 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    31c7:	8b 01                	mov    (%ecx),%eax
    31c9:	89 02                	mov    %eax,(%edx)
    31cb:	eb a8                	jmp    3175 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
    31cd:	ba 80 44 00 00       	mov    $0x4480,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    31d2:	c7 05 88 44 00 00 80 	movl   $0x4480,0x4488
    31d9:	44 00 00 
    31dc:	c7 05 80 44 00 00 80 	movl   $0x4480,0x4480
    31e3:	44 00 00 
    base.s.size = 0;
    31e6:	c7 05 84 44 00 00 00 	movl   $0x0,0x4484
    31ed:	00 00 00 
    31f0:	e9 4e ff ff ff       	jmp    3143 <malloc+0x23>
