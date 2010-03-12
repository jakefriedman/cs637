
_lt:     file format elf32-i386

Disassembly of section .text:

00000000 <cond_init>:
void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
   0:	a1 a0 08 00 00       	mov    0x8a0,%eax

void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
   5:	55                   	push   %ebp
   6:	89 e5                	mov    %esp,%ebp
  if(cond_count == 0)
   8:	85 c0                	test   %eax,%eax
   a:	75 0a                	jne    16 <cond_init+0x16>
    cond_count = 1;
   c:	c7 05 a0 08 00 00 01 	movl   $0x1,0x8a0
  13:	00 00 00 
  c->value = cond_count;
  16:	8b 15 a0 08 00 00    	mov    0x8a0,%edx
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 10                	mov    %edx,(%eax)
  cond_count++;
  21:	a1 a0 08 00 00       	mov    0x8a0,%eax
  26:	83 c0 01             	add    $0x1,%eax
  29:	a3 a0 08 00 00       	mov    %eax,0x8a0
  if(cond_count == 0)
  2e:	a1 a0 08 00 00       	mov    0x8a0,%eax
  33:	85 c0                	test   %eax,%eax
  35:	75 0a                	jne    41 <cond_init+0x41>
    cond_count = 1;
  37:	c7 05 a0 08 00 00 01 	movl   $0x1,0x8a0
  3e:	00 00 00 
}	
  41:	5d                   	pop    %ebp
  42:	c3                   	ret    
  43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000050 <add>:

static int count;


void add(void* arg) 
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 08             	sub    $0x8,%esp
  int k;
	int tik = tick();
  56:	e8 45 04 00 00       	call   4a0 <tick>
  5b:	eb fe                	jmp    5b <add+0xb>
  5d:	8d 76 00             	lea    0x0(%esi),%esi

00000060 <thread_wait>:

void thread_wait(){
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	83 ec 08             	sub    $0x8,%esp
	
	int pid;
	while((pid = wait_thread()) != -1);
  66:	e8 4d 04 00 00       	call   4b8 <wait_thread>
  6b:	83 c0 01             	add    $0x1,%eax
  6e:	75 f6                	jne    66 <thread_wait+0x6>
	return;
}
  70:	c9                   	leave  
  71:	c3                   	ret    
  72:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000080 <cond_signal>:
  sleep_cond(c->value, m);
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  wake_cond(c->value);
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	8b 00                	mov    (%eax),%eax
  88:	89 45 08             	mov    %eax,0x8(%ebp)
}
  8b:	5d                   	pop    %ebp
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
  8c:	e9 37 04 00 00       	jmp    4c8 <wake_cond>
  91:	eb 0d                	jmp    a0 <cond_wait>
  93:	90                   	nop    
  94:	90                   	nop    
  95:	90                   	nop    
  96:	90                   	nop    
  97:	90                   	nop    
  98:	90                   	nop    
  99:	90                   	nop    
  9a:	90                   	nop    
  9b:	90                   	nop    
  9c:	90                   	nop    
  9d:	90                   	nop    
  9e:	90                   	nop    
  9f:	90                   	nop    

000000a0 <cond_wait>:
		
	return pid;

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8b 00                	mov    (%eax),%eax
  a8:	89 45 08             	mov    %eax,0x8(%ebp)
  //mutex_lock(m);
}
  ab:	5d                   	pop    %ebp

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
  ac:	e9 0f 04 00 00       	jmp    4c0 <sleep_cond>
  b1:	eb 0d                	jmp    c0 <thread_create>
  b3:	90                   	nop    
  b4:	90                   	nop    
  b5:	90                   	nop    
  b6:	90                   	nop    
  b7:	90                   	nop    
  b8:	90                   	nop    
  b9:	90                   	nop    
  ba:	90                   	nop    
  bb:	90                   	nop    
  bc:	90                   	nop    
  bd:	90                   	nop    
  be:	90                   	nop    
  bf:	90                   	nop    

000000c0 <thread_create>:
  xchng(lock->lock, 0);
  //printf(1,"unlocked-%d\n", lock);
}


int thread_create(void*(*start_routine)(void *), void *arg){
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 18             	sub    $0x18,%esp
	
	//Allocate stack using process heap
	int stack = malloc(1024);
  c6:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  cd:	e8 ae 06 00 00       	call   780 <malloc>

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
  d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  d5:	89 54 24 08          	mov    %edx,0x8(%esp)
  d9:	8b 55 08             	mov    0x8(%ebp),%edx
  dc:	89 04 24             	mov    %eax,(%esp)
  df:	89 54 24 04          	mov    %edx,0x4(%esp)
  e3:	e8 c8 03 00 00       	call   4b0 <fork_thread>
		
	return pid;

}
  e8:	c9                   	leave  
  e9:	c3                   	ret    
  ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000f0 <main>:
} 
 printf(1, "variable %d\n", count);
  exit();
}

int main() {
  f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f4:	83 e4 f0             	and    $0xfffffff0,%esp
  f7:	ff 71 fc             	pushl  -0x4(%ecx)
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 38             	sub    $0x38,%esp
 100:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
 103:	8d 5d f0             	lea    -0x10(%ebp),%ebx
} 
 printf(1, "variable %d\n", count);
  exit();
}

int main() {
 106:	89 4d f4             	mov    %ecx,-0xc(%ebp)
 109:	89 75 fc             	mov    %esi,-0x4(%ebp)
  count = 0;
 10c:	c7 05 a4 08 00 00 00 	movl   $0x0,0x8a4
 113:	00 00 00 
  int x = 0;
 116:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
 11d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 121:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
 128:	e8 93 ff ff ff       	call   c0 <thread_create>
  pid2 = thread_create(&add, zero);
 12d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 131:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
 138:	89 c6                	mov    %eax,%esi
  pid2 = thread_create(&add, zero);
 13a:	e8 81 ff ff ff       	call   c0 <thread_create>
  thread_wait();
 13f:	e8 1c ff ff ff       	call   60 <thread_wait>
  //add(zero); 
// sleep();
  //for(x = 0; x < 100000000 ; x++);
  printf(1, "Value of global variable %d, pid %d, parent %d\n",count, pid, getpid());
 144:	e8 3f 03 00 00       	call   488 <getpid>
 149:	89 74 24 0c          	mov    %esi,0xc(%esp)
 14d:	c7 44 24 04 58 08 00 	movl   $0x858,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	89 44 24 10          	mov    %eax,0x10(%esp)
 160:	a1 a4 08 00 00       	mov    0x8a4,%eax
 165:	89 44 24 08          	mov    %eax,0x8(%esp)
 169:	e8 22 04 00 00       	call   590 <printf>
  exit();
 16e:	e8 95 02 00 00       	call   408 <exit>
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000180 <mutex_unlock>:
  while(xchng(lock->lock, 1) == 1){;}
   // printf(1,"spin\n");
  //printf(1,"locked-%d,value-%d\n", lock, lock->lock);
}

void mutex_unlock(struct mutex_t* lock) {
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 08             	sub    $0x8,%esp
  xchng(lock->lock, 0);
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	8b 00                	mov    (%eax),%eax
 18b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 192:	00 
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 35 03 00 00       	call   4d0 <xchng>
  //printf(1,"unlocked-%d\n", lock);
}
 19b:	c9                   	leave  
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <mutex_lock>:

void mutex_init(struct mutex_t* lock) {
  xchng(lock->lock, 0); //0 is unused
}

void mutex_lock(struct mutex_t* lock) {
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	83 ec 14             	sub    $0x14,%esp
 1a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  //printf(1,"locking-%d,value-%d\n", lock, lock->lock);
  while(xchng(lock->lock, 1) == 1){;}
 1b0:	8b 03                	mov    (%ebx),%eax
 1b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 1b9:	00 
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 0e 03 00 00       	call   4d0 <xchng>
 1c2:	83 e8 01             	sub    $0x1,%eax
 1c5:	74 e9                	je     1b0 <mutex_lock+0x10>
   // printf(1,"spin\n");
  //printf(1,"locked-%d,value-%d\n", lock, lock->lock);
}
 1c7:	83 c4 14             	add    $0x14,%esp
 1ca:	5b                   	pop    %ebx
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <mutex_init>:
static volatile unsigned int cond_count = 0;




void mutex_init(struct mutex_t* lock) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 08             	sub    $0x8,%esp
  xchng(lock->lock, 0); //0 is unused
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	8b 00                	mov    (%eax),%eax
 1db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1e2:	00 
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 e5 02 00 00       	call   4d0 <xchng>
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    
 1ed:	90                   	nop    
 1ee:	90                   	nop    
 1ef:	90                   	nop    

000001f0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1fa:	89 da                	mov    %ebx,%edx
 1fc:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 200:	0f b6 01             	movzbl (%ecx),%eax
 203:	83 c1 01             	add    $0x1,%ecx
 206:	88 02                	mov    %al,(%edx)
 208:	83 c2 01             	add    $0x1,%edx
 20b:	84 c0                	test   %al,%al
 20d:	75 f1                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 20f:	89 d8                	mov    %ebx,%eax
 211:	5b                   	pop    %ebx
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 21a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
 226:	53                   	push   %ebx
 227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 22a:	0f b6 01             	movzbl (%ecx),%eax
 22d:	84 c0                	test   %al,%al
 22f:	74 24                	je     255 <strcmp+0x35>
 231:	0f b6 13             	movzbl (%ebx),%edx
 234:	38 d0                	cmp    %dl,%al
 236:	74 12                	je     24a <strcmp+0x2a>
 238:	eb 1e                	jmp    258 <strcmp+0x38>
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	0f b6 13             	movzbl (%ebx),%edx
 243:	83 c1 01             	add    $0x1,%ecx
 246:	38 d0                	cmp    %dl,%al
 248:	75 0e                	jne    258 <strcmp+0x38>
 24a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 24e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 251:	84 c0                	test   %al,%al
 253:	75 eb                	jne    240 <strcmp+0x20>
 255:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 258:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 259:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 25c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 25d:	0f b6 d2             	movzbl %dl,%edx
 260:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000270 <strlen>:

uint
strlen(char *s)
{
 270:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 271:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 273:	89 e5                	mov    %esp,%ebp
 275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 278:	80 39 00             	cmpb   $0x0,(%ecx)
 27b:	74 0e                	je     28b <strlen+0x1b>
 27d:	31 d2                	xor    %edx,%edx
 27f:	90                   	nop    
 280:	83 c2 01             	add    $0x1,%edx
 283:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 287:	89 d0                	mov    %edx,%eax
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 45 10             	mov    0x10(%ebp),%eax
 296:	53                   	push   %ebx
 297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 29a:	85 c0                	test   %eax,%eax
 29c:	74 10                	je     2ae <memset+0x1e>
 29e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 2a2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 2a4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 2a7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 2aa:	39 c2                	cmp    %eax,%edx
 2ac:	75 f6                	jne    2a4 <memset+0x14>
    *d++ = c;
  return dst;
}
 2ae:	89 d8                	mov    %ebx,%eax
 2b0:	5b                   	pop    %ebx
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	84 d2                	test   %dl,%dl
 2cf:	75 0c                	jne    2dd <strchr+0x1d>
 2d1:	eb 11                	jmp    2e4 <strchr+0x24>
 2d3:	83 c0 01             	add    $0x1,%eax
 2d6:	0f b6 10             	movzbl (%eax),%edx
 2d9:	84 d2                	test   %dl,%dl
 2db:	74 07                	je     2e4 <strchr+0x24>
    if(*s == c)
 2dd:	38 ca                	cmp    %cl,%dl
 2df:	90                   	nop    
 2e0:	75 f1                	jne    2d3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret    
 2e4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 2e7:	c3                   	ret    
 2e8:	90                   	nop    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000002f0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f7:	31 db                	xor    %ebx,%ebx
 2f9:	0f b6 11             	movzbl (%ecx),%edx
 2fc:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ff:	3c 09                	cmp    $0x9,%al
 301:	77 18                	ja     31b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 303:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 306:	0f be d2             	movsbl %dl,%edx
 309:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 311:	83 c1 01             	add    $0x1,%ecx
 314:	8d 42 d0             	lea    -0x30(%edx),%eax
 317:	3c 09                	cmp    $0x9,%al
 319:	76 e8                	jbe    303 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 31b:	89 d8                	mov    %ebx,%eax
 31d:	5b                   	pop    %ebx
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    

00000320 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 10             	mov    0x10(%ebp),%ecx
 326:	56                   	push   %esi
 327:	8b 75 08             	mov    0x8(%ebp),%esi
 32a:	53                   	push   %ebx
 32b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 c9                	test   %ecx,%ecx
 330:	7e 10                	jle    342 <memmove+0x22>
 332:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 334:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 338:	88 04 32             	mov    %al,(%edx,%esi,1)
 33b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	39 ca                	cmp    %ecx,%edx
 340:	75 f2                	jne    334 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 342:	89 f0                	mov    %esi,%eax
 344:	5b                   	pop    %ebx
 345:	5e                   	pop    %esi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    
 348:	90                   	nop    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000350 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 356:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 359:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 35c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 35f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 364:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 36b:	00 
 36c:	89 04 24             	mov    %eax,(%esp)
 36f:	e8 d4 00 00 00       	call   448 <open>
  if(fd < 0)
 374:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 376:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 378:	78 19                	js     393 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	89 1c 24             	mov    %ebx,(%esp)
 380:	89 44 24 04          	mov    %eax,0x4(%esp)
 384:	e8 d7 00 00 00       	call   460 <fstat>
  close(fd);
 389:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 38c:	89 c6                	mov    %eax,%esi
  close(fd);
 38e:	e8 9d 00 00 00       	call   430 <close>
  return r;
}
 393:	89 f0                	mov    %esi,%eax
 395:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 398:	8b 75 fc             	mov    -0x4(%ebp),%esi
 39b:	89 ec                	mov    %ebp,%esp
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    
 39f:	90                   	nop    

000003a0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	31 f6                	xor    %esi,%esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 1c             	sub    $0x1c,%esp
 3ab:	8b 7d 08             	mov    0x8(%ebp),%edi
 3ae:	eb 06                	jmp    3b6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b0:	3c 0d                	cmp    $0xd,%al
 3b2:	74 39                	je     3ed <gets+0x4d>
 3b4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b6:	8d 5e 01             	lea    0x1(%esi),%ebx
 3b9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3bc:	7d 31                	jge    3ef <gets+0x4f>
    cc = read(0, &c, 1);
 3be:	8d 45 f3             	lea    -0xd(%ebp),%eax
 3c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c8:	00 
 3c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3d4:	e8 47 00 00 00       	call   420 <read>
    if(cc < 1)
 3d9:	85 c0                	test   %eax,%eax
 3db:	7e 12                	jle    3ef <gets+0x4f>
      break;
    buf[i++] = c;
 3dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3e1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 3e5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3e9:	3c 0a                	cmp    $0xa,%al
 3eb:	75 c3                	jne    3b0 <gets+0x10>
 3ed:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3ef:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3f3:	89 f8                	mov    %edi,%eax
 3f5:	83 c4 1c             	add    $0x1c,%esp
 3f8:	5b                   	pop    %ebx
 3f9:	5e                   	pop    %esi
 3fa:	5f                   	pop    %edi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	90                   	nop    
 3fe:	90                   	nop    
 3ff:	90                   	nop    

00000400 <fork>:
 400:	b8 01 00 00 00       	mov    $0x1,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <exit>:
 408:	b8 02 00 00 00       	mov    $0x2,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <wait>:
 410:	b8 03 00 00 00       	mov    $0x3,%eax
 415:	cd 30                	int    $0x30
 417:	c3                   	ret    

00000418 <pipe>:
 418:	b8 04 00 00 00       	mov    $0x4,%eax
 41d:	cd 30                	int    $0x30
 41f:	c3                   	ret    

00000420 <read>:
 420:	b8 06 00 00 00       	mov    $0x6,%eax
 425:	cd 30                	int    $0x30
 427:	c3                   	ret    

00000428 <write>:
 428:	b8 05 00 00 00       	mov    $0x5,%eax
 42d:	cd 30                	int    $0x30
 42f:	c3                   	ret    

00000430 <close>:
 430:	b8 07 00 00 00       	mov    $0x7,%eax
 435:	cd 30                	int    $0x30
 437:	c3                   	ret    

00000438 <kill>:
 438:	b8 08 00 00 00       	mov    $0x8,%eax
 43d:	cd 30                	int    $0x30
 43f:	c3                   	ret    

00000440 <exec>:
 440:	b8 09 00 00 00       	mov    $0x9,%eax
 445:	cd 30                	int    $0x30
 447:	c3                   	ret    

00000448 <open>:
 448:	b8 0a 00 00 00       	mov    $0xa,%eax
 44d:	cd 30                	int    $0x30
 44f:	c3                   	ret    

00000450 <mknod>:
 450:	b8 0b 00 00 00       	mov    $0xb,%eax
 455:	cd 30                	int    $0x30
 457:	c3                   	ret    

00000458 <unlink>:
 458:	b8 0c 00 00 00       	mov    $0xc,%eax
 45d:	cd 30                	int    $0x30
 45f:	c3                   	ret    

00000460 <fstat>:
 460:	b8 0d 00 00 00       	mov    $0xd,%eax
 465:	cd 30                	int    $0x30
 467:	c3                   	ret    

00000468 <link>:
 468:	b8 0e 00 00 00       	mov    $0xe,%eax
 46d:	cd 30                	int    $0x30
 46f:	c3                   	ret    

00000470 <mkdir>:
 470:	b8 0f 00 00 00       	mov    $0xf,%eax
 475:	cd 30                	int    $0x30
 477:	c3                   	ret    

00000478 <chdir>:
 478:	b8 10 00 00 00       	mov    $0x10,%eax
 47d:	cd 30                	int    $0x30
 47f:	c3                   	ret    

00000480 <dup>:
 480:	b8 11 00 00 00       	mov    $0x11,%eax
 485:	cd 30                	int    $0x30
 487:	c3                   	ret    

00000488 <getpid>:
 488:	b8 12 00 00 00       	mov    $0x12,%eax
 48d:	cd 30                	int    $0x30
 48f:	c3                   	ret    

00000490 <sbrk>:
 490:	b8 13 00 00 00       	mov    $0x13,%eax
 495:	cd 30                	int    $0x30
 497:	c3                   	ret    

00000498 <sleep>:
 498:	b8 14 00 00 00       	mov    $0x14,%eax
 49d:	cd 30                	int    $0x30
 49f:	c3                   	ret    

000004a0 <tick>:
 4a0:	b8 15 00 00 00       	mov    $0x15,%eax
 4a5:	cd 30                	int    $0x30
 4a7:	c3                   	ret    

000004a8 <fork_tickets>:
 4a8:	b8 16 00 00 00       	mov    $0x16,%eax
 4ad:	cd 30                	int    $0x30
 4af:	c3                   	ret    

000004b0 <fork_thread>:
 4b0:	b8 17 00 00 00       	mov    $0x17,%eax
 4b5:	cd 30                	int    $0x30
 4b7:	c3                   	ret    

000004b8 <wait_thread>:
 4b8:	b8 18 00 00 00       	mov    $0x18,%eax
 4bd:	cd 30                	int    $0x30
 4bf:	c3                   	ret    

000004c0 <sleep_cond>:
 4c0:	b8 19 00 00 00       	mov    $0x19,%eax
 4c5:	cd 30                	int    $0x30
 4c7:	c3                   	ret    

000004c8 <wake_cond>:
 4c8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4cd:	cd 30                	int    $0x30
 4cf:	c3                   	ret    

000004d0 <xchng>:
 4d0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d5:	cd 30                	int    $0x30
 4d7:	c3                   	ret    

000004d8 <check>:
 4d8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4dd:	cd 30                	int    $0x30
 4df:	c3                   	ret    

000004e0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 18             	sub    $0x18,%esp
 4e6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 4e9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 4ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f3:	00 
 4f4:	89 54 24 04          	mov    %edx,0x4(%esp)
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 28 ff ff ff       	call   428 <write>
}
 500:	c9                   	leave  
 501:	c3                   	ret    
 502:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000510 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	89 ce                	mov    %ecx,%esi
 517:	53                   	push   %ebx
 518:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 51e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 521:	85 c9                	test   %ecx,%ecx
 523:	74 04                	je     529 <printint+0x19>
 525:	85 d2                	test   %edx,%edx
 527:	78 54                	js     57d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 529:	89 d0                	mov    %edx,%eax
 52b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 532:	31 db                	xor    %ebx,%ebx
 534:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 537:	31 d2                	xor    %edx,%edx
 539:	f7 f6                	div    %esi
 53b:	89 c1                	mov    %eax,%ecx
 53d:	0f b6 82 8f 08 00 00 	movzbl 0x88f(%edx),%eax
 544:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 547:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 54a:	85 c9                	test   %ecx,%ecx
 54c:	89 c8                	mov    %ecx,%eax
 54e:	75 e7                	jne    537 <printint+0x27>
  if(neg)
 550:	8b 45 e0             	mov    -0x20(%ebp),%eax
 553:	85 c0                	test   %eax,%eax
 555:	74 08                	je     55f <printint+0x4f>
    buf[i++] = '-';
 557:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 55c:	83 c3 01             	add    $0x1,%ebx
 55f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 562:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 566:	83 eb 01             	sub    $0x1,%ebx
 569:	8b 45 dc             	mov    -0x24(%ebp),%eax
 56c:	e8 6f ff ff ff       	call   4e0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 571:	39 fb                	cmp    %edi,%ebx
 573:	75 ed                	jne    562 <printint+0x52>
    putc(fd, buf[i]);
}
 575:	83 c4 1c             	add    $0x1c,%esp
 578:	5b                   	pop    %ebx
 579:	5e                   	pop    %esi
 57a:	5f                   	pop    %edi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 57d:	89 d0                	mov    %edx,%eax
 57f:	f7 d8                	neg    %eax
 581:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 588:	eb a8                	jmp    532 <printint+0x22>
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000590 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 599:	8b 55 0c             	mov    0xc(%ebp),%edx
 59c:	0f b6 02             	movzbl (%edx),%eax
 59f:	84 c0                	test   %al,%al
 5a1:	0f 84 84 00 00 00    	je     62b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5a7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5aa:	89 d7                	mov    %edx,%edi
 5ac:	31 f6                	xor    %esi,%esi
 5ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 5b1:	eb 18                	jmp    5cb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5b3:	83 fb 25             	cmp    $0x25,%ebx
 5b6:	75 7b                	jne    633 <printf+0xa3>
 5b8:	66 be 25 00          	mov    $0x25,%si
 5bc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 5c4:	83 c7 01             	add    $0x1,%edi
 5c7:	84 c0                	test   %al,%al
 5c9:	74 60                	je     62b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 5cb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5cd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 5d0:	74 e1                	je     5b3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d2:	83 fe 25             	cmp    $0x25,%esi
 5d5:	75 e9                	jne    5c0 <printf+0x30>
      if(c == 'd'){
 5d7:	83 fb 64             	cmp    $0x64,%ebx
 5da:	0f 84 db 00 00 00    	je     6bb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5e0:	83 fb 78             	cmp    $0x78,%ebx
 5e3:	74 5b                	je     640 <printf+0xb0>
 5e5:	83 fb 70             	cmp    $0x70,%ebx
 5e8:	74 56                	je     640 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5ea:	83 fb 73             	cmp    $0x73,%ebx
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
 5f0:	74 72                	je     664 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f2:	83 fb 63             	cmp    $0x63,%ebx
 5f5:	0f 84 a7 00 00 00    	je     6a2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5fb:	83 fb 25             	cmp    $0x25,%ebx
 5fe:	66 90                	xchg   %ax,%ax
 600:	0f 84 da 00 00 00    	je     6e0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 60e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 610:	e8 cb fe ff ff       	call   4e0 <putc>
        putc(fd, c);
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	0f be d3             	movsbl %bl,%edx
 61b:	e8 c0 fe ff ff       	call   4e0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 620:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 624:	83 c7 01             	add    $0x1,%edi
 627:	84 c0                	test   %al,%al
 629:	75 a0                	jne    5cb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62b:	83 c4 0c             	add    $0xc,%esp
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	0f be d3             	movsbl %bl,%edx
 639:	e8 a2 fe ff ff       	call   4e0 <putc>
 63e:	eb 80                	jmp    5c0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 640:	8b 45 f0             	mov    -0x10(%ebp),%eax
 643:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 648:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 64a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	e8 b5 fe ff ff       	call   510 <printint>
        ap++;
 65b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 65f:	e9 5c ff ff ff       	jmp    5c0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 664:	8b 55 f0             	mov    -0x10(%ebp),%edx
 667:	8b 02                	mov    (%edx),%eax
        ap++;
 669:	83 c2 04             	add    $0x4,%edx
 66c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 66f:	ba 88 08 00 00       	mov    $0x888,%edx
 674:	85 c0                	test   %eax,%eax
 676:	75 26                	jne    69e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 678:	0f b6 02             	movzbl (%edx),%eax
 67b:	84 c0                	test   %al,%al
 67d:	74 18                	je     697 <printf+0x107>
 67f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 681:	0f be d0             	movsbl %al,%edx
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	e8 54 fe ff ff       	call   4e0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 690:	83 c3 01             	add    $0x1,%ebx
 693:	84 c0                	test   %al,%al
 695:	75 ea                	jne    681 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 697:	31 f6                	xor    %esi,%esi
 699:	e9 22 ff ff ff       	jmp    5c0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 69e:	89 c2                	mov    %eax,%edx
 6a0:	eb d6                	jmp    678 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 6a5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	0f be 11             	movsbl (%ecx),%edx
 6ad:	e8 2e fe ff ff       	call   4e0 <putc>
        ap++;
 6b2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 6b6:	e9 05 ff ff ff       	jmp    5c0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6be:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 6c3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	e8 39 fe ff ff       	call   510 <printint>
        ap++;
 6d7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 6db:	e9 e0 fe ff ff       	jmp    5c0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	ba 25 00 00 00       	mov    $0x25,%edx
 6e8:	31 f6                	xor    %esi,%esi
 6ea:	e8 f1 fd ff ff       	call   4e0 <putc>
 6ef:	e9 cc fe ff ff       	jmp    5c0 <printf+0x30>
 6f4:	90                   	nop    
 6f5:	90                   	nop    
 6f6:	90                   	nop    
 6f7:	90                   	nop    
 6f8:	90                   	nop    
 6f9:	90                   	nop    
 6fa:	90                   	nop    
 6fb:	90                   	nop    
 6fc:	90                   	nop    
 6fd:	90                   	nop    
 6fe:	90                   	nop    
 6ff:	90                   	nop    

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 0d b0 08 00 00    	mov    0x8b0,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 707:	89 e5                	mov    %esp,%ebp
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 70e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	39 d9                	cmp    %ebx,%ecx
 713:	73 18                	jae    72d <free+0x2d>
 715:	8b 11                	mov    (%ecx),%edx
 717:	39 d3                	cmp    %edx,%ebx
 719:	72 17                	jb     732 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71b:	39 d1                	cmp    %edx,%ecx
 71d:	72 08                	jb     727 <free+0x27>
 71f:	39 d9                	cmp    %ebx,%ecx
 721:	72 0f                	jb     732 <free+0x32>
 723:	39 d3                	cmp    %edx,%ebx
 725:	72 0b                	jb     732 <free+0x32>
 727:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 729:	39 d9                	cmp    %ebx,%ecx
 72b:	72 e8                	jb     715 <free+0x15>
 72d:	8b 11                	mov    (%ecx),%edx
 72f:	90                   	nop    
 730:	eb e9                	jmp    71b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 732:	8b 73 04             	mov    0x4(%ebx),%esi
 735:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 738:	39 d0                	cmp    %edx,%eax
 73a:	74 18                	je     754 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 73c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 73e:	8b 51 04             	mov    0x4(%ecx),%edx
 741:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 744:	39 d8                	cmp    %ebx,%eax
 746:	74 20                	je     768 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 748:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 74a:	5b                   	pop    %ebx
 74b:	5e                   	pop    %esi
 74c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 74d:	89 0d b0 08 00 00    	mov    %ecx,0x8b0
}
 753:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 754:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 757:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 759:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 75c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 75f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 761:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 764:	39 d8                	cmp    %ebx,%eax
 766:	75 e0                	jne    748 <free+0x48>
    p->s.size += bp->s.size;
 768:	03 53 04             	add    0x4(%ebx),%edx
 76b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 76e:	8b 13                	mov    (%ebx),%edx
 770:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 772:	5b                   	pop    %ebx
 773:	5e                   	pop    %esi
 774:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 775:	89 0d b0 08 00 00    	mov    %ecx,0x8b0
}
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 15 b0 08 00 00    	mov    0x8b0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	83 c0 07             	add    $0x7,%eax
 795:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 798:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 79d:	0f 84 8a 00 00 00    	je     82d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7a5:	8b 41 04             	mov    0x4(%ecx),%eax
 7a8:	39 c3                	cmp    %eax,%ebx
 7aa:	76 1a                	jbe    7c6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 7ac:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 7b3:	3b 0d b0 08 00 00    	cmp    0x8b0,%ecx
 7b9:	89 ca                	mov    %ecx,%edx
 7bb:	74 29                	je     7e6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7bf:	8b 41 04             	mov    0x4(%ecx),%eax
 7c2:	39 c3                	cmp    %eax,%ebx
 7c4:	77 ed                	ja     7b3 <malloc+0x33>
      if(p->s.size == nunits)
 7c6:	39 c3                	cmp    %eax,%ebx
 7c8:	74 5d                	je     827 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ca:	29 d8                	sub    %ebx,%eax
 7cc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 7cf:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 7d2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 7d5:	89 15 b0 08 00 00    	mov    %edx,0x8b0
      return (void*) (p + 1);
 7db:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7de:	83 c4 0c             	add    $0xc,%esp
 7e1:	5b                   	pop    %ebx
 7e2:	5e                   	pop    %esi
 7e3:	5f                   	pop    %edi
 7e4:	5d                   	pop    %ebp
 7e5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 7e6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 7ec:	89 de                	mov    %ebx,%esi
 7ee:	89 f8                	mov    %edi,%eax
 7f0:	76 29                	jbe    81b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 7f2:	89 04 24             	mov    %eax,(%esp)
 7f5:	e8 96 fc ff ff       	call   490 <sbrk>
  if(p == (char*) -1)
 7fa:	83 f8 ff             	cmp    $0xffffffff,%eax
 7fd:	74 18                	je     817 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7ff:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 802:	83 c0 08             	add    $0x8,%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 f3 fe ff ff       	call   700 <free>
  return freep;
 80d:	8b 15 b0 08 00 00    	mov    0x8b0,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 813:	85 d2                	test   %edx,%edx
 815:	75 a6                	jne    7bd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 817:	31 c0                	xor    %eax,%eax
 819:	eb c3                	jmp    7de <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 81b:	be 00 10 00 00       	mov    $0x1000,%esi
 820:	b8 00 80 00 00       	mov    $0x8000,%eax
 825:	eb cb                	jmp    7f2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 827:	8b 01                	mov    (%ecx),%eax
 829:	89 02                	mov    %eax,(%edx)
 82b:	eb a8                	jmp    7d5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 82d:	ba a8 08 00 00       	mov    $0x8a8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 832:	c7 05 b0 08 00 00 a8 	movl   $0x8a8,0x8b0
 839:	08 00 00 
 83c:	c7 05 a8 08 00 00 a8 	movl   $0x8a8,0x8a8
 843:	08 00 00 
    base.s.size = 0;
 846:	c7 05 ac 08 00 00 00 	movl   $0x0,0x8ac
 84d:	00 00 00 
 850:	e9 4e ff ff ff       	jmp    7a3 <malloc+0x23>
