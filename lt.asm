
_lt:     file format elf32-i386

Disassembly of section .text:

00000000 <cond_init>:
void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
   0:	a1 90 08 00 00       	mov    0x890,%eax

void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
   5:	55                   	push   %ebp
   6:	89 e5                	mov    %esp,%ebp
   8:	8b 55 08             	mov    0x8(%ebp),%edx
  if(cond_count == 0)
   b:	85 c0                	test   %eax,%eax
   d:	75 12                	jne    21 <cond_init+0x21>
    cond_count = 1;
  c->value = cond_count;
   f:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  cond_count++;
  15:	c7 05 90 08 00 00 02 	movl   $0x2,0x890
  1c:	00 00 00 
  if(cond_count == 0)
    cond_count = 1;
}	
  1f:	5d                   	pop    %ebp
  20:	c3                   	ret    
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
    cond_count = 1;
  c->value = cond_count;
  21:	89 02                	mov    %eax,(%edx)
  cond_count++;
  23:	83 c0 01             	add    $0x1,%eax
  if(cond_count == 0)
  26:	85 c0                	test   %eax,%eax

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
    cond_count = 1;
  c->value = cond_count;
  cond_count++;
  28:	a3 90 08 00 00       	mov    %eax,0x890
  if(cond_count == 0)
  2d:	75 f0                	jne    1f <cond_init+0x1f>
    cond_count = 1;
}	
  2f:	5d                   	pop    %ebp
  if(cond_count == 0)
    cond_count = 1;
  c->value = cond_count;
  cond_count++;
  if(cond_count == 0)
    cond_count = 1;
  30:	c7 05 90 08 00 00 01 	movl   $0x1,0x890
  37:	00 00 00 
}	
  3a:	c3                   	ret    
  3b:	90                   	nop    
  3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000040 <add>:

static int count;


void add(void* arg) 
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 08             	sub    $0x8,%esp
  int k;
	int tik = tick();
  46:	e8 45 04 00 00       	call   490 <tick>
  4b:	eb fe                	jmp    4b <add+0xb>
  4d:	8d 76 00             	lea    0x0(%esi),%esi

00000050 <thread_wait>:

void thread_wait(){
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 08             	sub    $0x8,%esp
	
	int pid;
	while((pid = wait_thread()) != -1);
  56:	e8 4d 04 00 00       	call   4a8 <wait_thread>
  5b:	83 c0 01             	add    $0x1,%eax
  5e:	75 f6                	jne    56 <thread_wait+0x6>
	return;
}
  60:	c9                   	leave  
  61:	c3                   	ret    
  62:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000070 <cond_signal>:
  sleep_cond(c->value, m);
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  wake_cond(c->value);
  73:	8b 45 08             	mov    0x8(%ebp),%eax
  76:	8b 00                	mov    (%eax),%eax
  78:	89 45 08             	mov    %eax,0x8(%ebp)
}
  7b:	5d                   	pop    %ebp
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
  7c:	e9 37 04 00 00       	jmp    4b8 <wake_cond>
  81:	eb 0d                	jmp    90 <cond_wait>
  83:	90                   	nop    
  84:	90                   	nop    
  85:	90                   	nop    
  86:	90                   	nop    
  87:	90                   	nop    
  88:	90                   	nop    
  89:	90                   	nop    
  8a:	90                   	nop    
  8b:	90                   	nop    
  8c:	90                   	nop    
  8d:	90                   	nop    
  8e:	90                   	nop    
  8f:	90                   	nop    

00000090 <cond_wait>:
		
	return pid;

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	8b 00                	mov    (%eax),%eax
  98:	89 45 08             	mov    %eax,0x8(%ebp)
  //mutex_lock(m);
}
  9b:	5d                   	pop    %ebp

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
  9c:	e9 0f 04 00 00       	jmp    4b0 <sleep_cond>
  a1:	eb 0d                	jmp    b0 <thread_create>
  a3:	90                   	nop    
  a4:	90                   	nop    
  a5:	90                   	nop    
  a6:	90                   	nop    
  a7:	90                   	nop    
  a8:	90                   	nop    
  a9:	90                   	nop    
  aa:	90                   	nop    
  ab:	90                   	nop    
  ac:	90                   	nop    
  ad:	90                   	nop    
  ae:	90                   	nop    
  af:	90                   	nop    

000000b0 <thread_create>:
void mutex_unlock(struct mutex_t* lock) {
  xchng(&lock->lock, 0);
}


int thread_create(void*(*start_routine)(void *), void *arg){
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 18             	sub    $0x18,%esp
	
	//Allocate stack using process heap
	int stack = malloc(1024);
  b6:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  bd:	e8 ae 06 00 00       	call   770 <malloc>

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
  c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  c5:	89 54 24 08          	mov    %edx,0x8(%esp)
  c9:	8b 55 08             	mov    0x8(%ebp),%edx
  cc:	89 04 24             	mov    %eax,(%esp)
  cf:	89 54 24 04          	mov    %edx,0x4(%esp)
  d3:	e8 c8 03 00 00       	call   4a0 <fork_thread>
		
	return pid;

}
  d8:	c9                   	leave  
  d9:	c3                   	ret    
  da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000e0 <main>:
} 
 printf(1, "variable %d\n", count);
  exit();
}

int main() {
  e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  e4:	83 e4 f0             	and    $0xfffffff0,%esp
  e7:	ff 71 fc             	pushl  -0x4(%ecx)
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 38             	sub    $0x38,%esp
  f0:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
  f3:	8d 5d f0             	lea    -0x10(%ebp),%ebx
} 
 printf(1, "variable %d\n", count);
  exit();
}

int main() {
  f6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  count = 0;
  fc:	c7 05 94 08 00 00 00 	movl   $0x0,0x894
 103:	00 00 00 
  int x = 0;
 106:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
 10d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 111:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
 118:	e8 93 ff ff ff       	call   b0 <thread_create>
  pid2 = thread_create(&add, zero);
 11d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 121:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
 128:	89 c6                	mov    %eax,%esi
  pid2 = thread_create(&add, zero);
 12a:	e8 81 ff ff ff       	call   b0 <thread_create>
  thread_wait();
 12f:	e8 1c ff ff ff       	call   50 <thread_wait>
  //add(zero); 
// sleep();
  //for(x = 0; x < 100000000 ; x++);
  printf(1, "Value of global variable %d, pid %d, parent %d\n",count, pid, getpid());
 134:	e8 3f 03 00 00       	call   478 <getpid>
 139:	89 74 24 0c          	mov    %esi,0xc(%esp)
 13d:	c7 44 24 04 48 08 00 	movl   $0x848,0x4(%esp)
 144:	00 
 145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14c:	89 44 24 10          	mov    %eax,0x10(%esp)
 150:	a1 94 08 00 00       	mov    0x894,%eax
 155:	89 44 24 08          	mov    %eax,0x8(%esp)
 159:	e8 22 04 00 00       	call   580 <printf>
  exit();
 15e:	e8 95 02 00 00       	call   3f8 <exit>
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000170 <mutex_unlock>:

void mutex_lock(struct mutex_t* lock) {
  while(xchng(&lock->lock, 1) == 1);
}

void mutex_unlock(struct mutex_t* lock) {
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 08             	sub    $0x8,%esp
  xchng(&lock->lock, 0);
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 180:	00 
 181:	89 04 24             	mov    %eax,(%esp)
 184:	e8 37 03 00 00       	call   4c0 <xchng>
}
 189:	c9                   	leave  
 18a:	c3                   	ret    
 18b:	90                   	nop    
 18c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000190 <mutex_lock>:

void mutex_init(struct mutex_t* lock) {
  xchng(&lock->lock, 0); //0 is unused
}

void mutex_lock(struct mutex_t* lock) {
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	83 ec 14             	sub    $0x14,%esp
 197:	8b 5d 08             	mov    0x8(%ebp),%ebx
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(xchng(&lock->lock, 1) == 1);
 1a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 1a7:	00 
 1a8:	89 1c 24             	mov    %ebx,(%esp)
 1ab:	e8 10 03 00 00       	call   4c0 <xchng>
 1b0:	83 e8 01             	sub    $0x1,%eax
 1b3:	74 eb                	je     1a0 <mutex_lock+0x10>
}
 1b5:	83 c4 14             	add    $0x14,%esp
 1b8:	5b                   	pop    %ebx
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    
 1bb:	90                   	nop    
 1bc:	8d 74 26 00          	lea    0x0(%esi),%esi

000001c0 <mutex_init>:
static unsigned int cond_count = 0;




void mutex_init(struct mutex_t* lock) {
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 08             	sub    $0x8,%esp
  xchng(&lock->lock, 0); //0 is unused
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d0:	00 
 1d1:	89 04 24             	mov    %eax,(%esp)
 1d4:	e8 e7 02 00 00       	call   4c0 <xchng>
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    
 1db:	90                   	nop    
 1dc:	90                   	nop    
 1dd:	90                   	nop    
 1de:	90                   	nop    
 1df:	90                   	nop    

000001e0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1ea:	89 da                	mov    %ebx,%edx
 1ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f0:	0f b6 01             	movzbl (%ecx),%eax
 1f3:	83 c1 01             	add    $0x1,%ecx
 1f6:	88 02                	mov    %al,(%edx)
 1f8:	83 c2 01             	add    $0x1,%edx
 1fb:	84 c0                	test   %al,%al
 1fd:	75 f1                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 1ff:	89 d8                	mov    %ebx,%eax
 201:	5b                   	pop    %ebx
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 4d 08             	mov    0x8(%ebp),%ecx
 216:	53                   	push   %ebx
 217:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 21a:	0f b6 01             	movzbl (%ecx),%eax
 21d:	84 c0                	test   %al,%al
 21f:	74 24                	je     245 <strcmp+0x35>
 221:	0f b6 13             	movzbl (%ebx),%edx
 224:	38 d0                	cmp    %dl,%al
 226:	74 12                	je     23a <strcmp+0x2a>
 228:	eb 1e                	jmp    248 <strcmp+0x38>
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 230:	0f b6 13             	movzbl (%ebx),%edx
 233:	83 c1 01             	add    $0x1,%ecx
 236:	38 d0                	cmp    %dl,%al
 238:	75 0e                	jne    248 <strcmp+0x38>
 23a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 23e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 241:	84 c0                	test   %al,%al
 243:	75 eb                	jne    230 <strcmp+0x20>
 245:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 248:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 249:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 24c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 24d:	0f b6 d2             	movzbl %dl,%edx
 250:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000260 <strlen>:

uint
strlen(char *s)
{
 260:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 261:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 263:	89 e5                	mov    %esp,%ebp
 265:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 268:	80 39 00             	cmpb   $0x0,(%ecx)
 26b:	74 0e                	je     27b <strlen+0x1b>
 26d:	31 d2                	xor    %edx,%edx
 26f:	90                   	nop    
 270:	83 c2 01             	add    $0x1,%edx
 273:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 277:	89 d0                	mov    %edx,%eax
 279:	75 f5                	jne    270 <strlen+0x10>
    ;
  return n;
}
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi

00000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 45 10             	mov    0x10(%ebp),%eax
 286:	53                   	push   %ebx
 287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 28a:	85 c0                	test   %eax,%eax
 28c:	74 10                	je     29e <memset+0x1e>
 28e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 292:	31 d2                	xor    %edx,%edx
    *d++ = c;
 294:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 297:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 29a:	39 c2                	cmp    %eax,%edx
 29c:	75 f6                	jne    294 <memset+0x14>
    *d++ = c;
  return dst;
}
 29e:	89 d8                	mov    %ebx,%eax
 2a0:	5b                   	pop    %ebx
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	84 d2                	test   %dl,%dl
 2bf:	75 0c                	jne    2cd <strchr+0x1d>
 2c1:	eb 11                	jmp    2d4 <strchr+0x24>
 2c3:	83 c0 01             	add    $0x1,%eax
 2c6:	0f b6 10             	movzbl (%eax),%edx
 2c9:	84 d2                	test   %dl,%dl
 2cb:	74 07                	je     2d4 <strchr+0x24>
    if(*s == c)
 2cd:	38 ca                	cmp    %cl,%dl
 2cf:	90                   	nop    
 2d0:	75 f1                	jne    2c3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    
 2d4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 2d7:	c3                   	ret    
 2d8:	90                   	nop    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000002e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	31 db                	xor    %ebx,%ebx
 2e9:	0f b6 11             	movzbl (%ecx),%edx
 2ec:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ef:	3c 09                	cmp    $0x9,%al
 2f1:	77 18                	ja     30b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 2f3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 2f6:	0f be d2             	movsbl %dl,%edx
 2f9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fd:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 301:	83 c1 01             	add    $0x1,%ecx
 304:	8d 42 d0             	lea    -0x30(%edx),%eax
 307:	3c 09                	cmp    $0x9,%al
 309:	76 e8                	jbe    2f3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 30b:	89 d8                	mov    %ebx,%eax
 30d:	5b                   	pop    %ebx
 30e:	5d                   	pop    %ebp
 30f:	c3                   	ret    

00000310 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 10             	mov    0x10(%ebp),%ecx
 316:	56                   	push   %esi
 317:	8b 75 08             	mov    0x8(%ebp),%esi
 31a:	53                   	push   %ebx
 31b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 c9                	test   %ecx,%ecx
 320:	7e 10                	jle    332 <memmove+0x22>
 322:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 324:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 328:	88 04 32             	mov    %al,(%edx,%esi,1)
 32b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	39 ca                	cmp    %ecx,%edx
 330:	75 f2                	jne    324 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 332:	89 f0                	mov    %esi,%eax
 334:	5b                   	pop    %ebx
 335:	5e                   	pop    %esi
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    
 338:	90                   	nop    
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000340 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 346:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 349:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 34c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 34f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 354:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 35b:	00 
 35c:	89 04 24             	mov    %eax,(%esp)
 35f:	e8 d4 00 00 00       	call   438 <open>
  if(fd < 0)
 364:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 366:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 368:	78 19                	js     383 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 1c 24             	mov    %ebx,(%esp)
 370:	89 44 24 04          	mov    %eax,0x4(%esp)
 374:	e8 d7 00 00 00       	call   450 <fstat>
  close(fd);
 379:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 37c:	89 c6                	mov    %eax,%esi
  close(fd);
 37e:	e8 9d 00 00 00       	call   420 <close>
  return r;
}
 383:	89 f0                	mov    %esi,%eax
 385:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 388:	8b 75 fc             	mov    -0x4(%ebp),%esi
 38b:	89 ec                	mov    %ebp,%esp
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret    
 38f:	90                   	nop    

00000390 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	31 f6                	xor    %esi,%esi
 397:	53                   	push   %ebx
 398:	83 ec 1c             	sub    $0x1c,%esp
 39b:	8b 7d 08             	mov    0x8(%ebp),%edi
 39e:	eb 06                	jmp    3a6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a0:	3c 0d                	cmp    $0xd,%al
 3a2:	74 39                	je     3dd <gets+0x4d>
 3a4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	8d 5e 01             	lea    0x1(%esi),%ebx
 3a9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ac:	7d 31                	jge    3df <gets+0x4f>
    cc = read(0, &c, 1);
 3ae:	8d 45 f3             	lea    -0xd(%ebp),%eax
 3b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b8:	00 
 3b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3c4:	e8 47 00 00 00       	call   410 <read>
    if(cc < 1)
 3c9:	85 c0                	test   %eax,%eax
 3cb:	7e 12                	jle    3df <gets+0x4f>
      break;
    buf[i++] = c;
 3cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3d1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 3d5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 3d9:	3c 0a                	cmp    $0xa,%al
 3db:	75 c3                	jne    3a0 <gets+0x10>
 3dd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3df:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3e3:	89 f8                	mov    %edi,%eax
 3e5:	83 c4 1c             	add    $0x1c,%esp
 3e8:	5b                   	pop    %ebx
 3e9:	5e                   	pop    %esi
 3ea:	5f                   	pop    %edi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	90                   	nop    
 3ee:	90                   	nop    
 3ef:	90                   	nop    

000003f0 <fork>:
 3f0:	b8 01 00 00 00       	mov    $0x1,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <exit>:
 3f8:	b8 02 00 00 00       	mov    $0x2,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <wait>:
 400:	b8 03 00 00 00       	mov    $0x3,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <pipe>:
 408:	b8 04 00 00 00       	mov    $0x4,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <read>:
 410:	b8 06 00 00 00       	mov    $0x6,%eax
 415:	cd 30                	int    $0x30
 417:	c3                   	ret    

00000418 <write>:
 418:	b8 05 00 00 00       	mov    $0x5,%eax
 41d:	cd 30                	int    $0x30
 41f:	c3                   	ret    

00000420 <close>:
 420:	b8 07 00 00 00       	mov    $0x7,%eax
 425:	cd 30                	int    $0x30
 427:	c3                   	ret    

00000428 <kill>:
 428:	b8 08 00 00 00       	mov    $0x8,%eax
 42d:	cd 30                	int    $0x30
 42f:	c3                   	ret    

00000430 <exec>:
 430:	b8 09 00 00 00       	mov    $0x9,%eax
 435:	cd 30                	int    $0x30
 437:	c3                   	ret    

00000438 <open>:
 438:	b8 0a 00 00 00       	mov    $0xa,%eax
 43d:	cd 30                	int    $0x30
 43f:	c3                   	ret    

00000440 <mknod>:
 440:	b8 0b 00 00 00       	mov    $0xb,%eax
 445:	cd 30                	int    $0x30
 447:	c3                   	ret    

00000448 <unlink>:
 448:	b8 0c 00 00 00       	mov    $0xc,%eax
 44d:	cd 30                	int    $0x30
 44f:	c3                   	ret    

00000450 <fstat>:
 450:	b8 0d 00 00 00       	mov    $0xd,%eax
 455:	cd 30                	int    $0x30
 457:	c3                   	ret    

00000458 <link>:
 458:	b8 0e 00 00 00       	mov    $0xe,%eax
 45d:	cd 30                	int    $0x30
 45f:	c3                   	ret    

00000460 <mkdir>:
 460:	b8 0f 00 00 00       	mov    $0xf,%eax
 465:	cd 30                	int    $0x30
 467:	c3                   	ret    

00000468 <chdir>:
 468:	b8 10 00 00 00       	mov    $0x10,%eax
 46d:	cd 30                	int    $0x30
 46f:	c3                   	ret    

00000470 <dup>:
 470:	b8 11 00 00 00       	mov    $0x11,%eax
 475:	cd 30                	int    $0x30
 477:	c3                   	ret    

00000478 <getpid>:
 478:	b8 12 00 00 00       	mov    $0x12,%eax
 47d:	cd 30                	int    $0x30
 47f:	c3                   	ret    

00000480 <sbrk>:
 480:	b8 13 00 00 00       	mov    $0x13,%eax
 485:	cd 30                	int    $0x30
 487:	c3                   	ret    

00000488 <sleep>:
 488:	b8 14 00 00 00       	mov    $0x14,%eax
 48d:	cd 30                	int    $0x30
 48f:	c3                   	ret    

00000490 <tick>:
 490:	b8 15 00 00 00       	mov    $0x15,%eax
 495:	cd 30                	int    $0x30
 497:	c3                   	ret    

00000498 <fork_tickets>:
 498:	b8 16 00 00 00       	mov    $0x16,%eax
 49d:	cd 30                	int    $0x30
 49f:	c3                   	ret    

000004a0 <fork_thread>:
 4a0:	b8 17 00 00 00       	mov    $0x17,%eax
 4a5:	cd 30                	int    $0x30
 4a7:	c3                   	ret    

000004a8 <wait_thread>:
 4a8:	b8 18 00 00 00       	mov    $0x18,%eax
 4ad:	cd 30                	int    $0x30
 4af:	c3                   	ret    

000004b0 <sleep_cond>:
 4b0:	b8 19 00 00 00       	mov    $0x19,%eax
 4b5:	cd 30                	int    $0x30
 4b7:	c3                   	ret    

000004b8 <wake_cond>:
 4b8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4bd:	cd 30                	int    $0x30
 4bf:	c3                   	ret    

000004c0 <xchng>:
 4c0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c5:	cd 30                	int    $0x30
 4c7:	c3                   	ret    
 4c8:	90                   	nop    
 4c9:	90                   	nop    
 4ca:	90                   	nop    
 4cb:	90                   	nop    
 4cc:	90                   	nop    
 4cd:	90                   	nop    
 4ce:	90                   	nop    
 4cf:	90                   	nop    

000004d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	83 ec 18             	sub    $0x18,%esp
 4d6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 4d9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 4dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e3:	00 
 4e4:	89 54 24 04          	mov    %edx,0x4(%esp)
 4e8:	89 04 24             	mov    %eax,(%esp)
 4eb:	e8 28 ff ff ff       	call   418 <write>
}
 4f0:	c9                   	leave  
 4f1:	c3                   	ret    
 4f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000500 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	89 ce                	mov    %ecx,%esi
 507:	53                   	push   %ebx
 508:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 50e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 511:	85 c9                	test   %ecx,%ecx
 513:	74 04                	je     519 <printint+0x19>
 515:	85 d2                	test   %edx,%edx
 517:	78 54                	js     56d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 519:	89 d0                	mov    %edx,%eax
 51b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 522:	31 db                	xor    %ebx,%ebx
 524:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 527:	31 d2                	xor    %edx,%edx
 529:	f7 f6                	div    %esi
 52b:	89 c1                	mov    %eax,%ecx
 52d:	0f b6 82 7f 08 00 00 	movzbl 0x87f(%edx),%eax
 534:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 537:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 53a:	85 c9                	test   %ecx,%ecx
 53c:	89 c8                	mov    %ecx,%eax
 53e:	75 e7                	jne    527 <printint+0x27>
  if(neg)
 540:	8b 45 e0             	mov    -0x20(%ebp),%eax
 543:	85 c0                	test   %eax,%eax
 545:	74 08                	je     54f <printint+0x4f>
    buf[i++] = '-';
 547:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 54c:	83 c3 01             	add    $0x1,%ebx
 54f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 552:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 556:	83 eb 01             	sub    $0x1,%ebx
 559:	8b 45 dc             	mov    -0x24(%ebp),%eax
 55c:	e8 6f ff ff ff       	call   4d0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 561:	39 fb                	cmp    %edi,%ebx
 563:	75 ed                	jne    552 <printint+0x52>
    putc(fd, buf[i]);
}
 565:	83 c4 1c             	add    $0x1c,%esp
 568:	5b                   	pop    %ebx
 569:	5e                   	pop    %esi
 56a:	5f                   	pop    %edi
 56b:	5d                   	pop    %ebp
 56c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 56d:	89 d0                	mov    %edx,%eax
 56f:	f7 d8                	neg    %eax
 571:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 578:	eb a8                	jmp    522 <printint+0x22>
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 589:	8b 55 0c             	mov    0xc(%ebp),%edx
 58c:	0f b6 02             	movzbl (%edx),%eax
 58f:	84 c0                	test   %al,%al
 591:	0f 84 84 00 00 00    	je     61b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 597:	8d 4d 10             	lea    0x10(%ebp),%ecx
 59a:	89 d7                	mov    %edx,%edi
 59c:	31 f6                	xor    %esi,%esi
 59e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 5a1:	eb 18                	jmp    5bb <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5a3:	83 fb 25             	cmp    $0x25,%ebx
 5a6:	75 7b                	jne    623 <printf+0xa3>
 5a8:	66 be 25 00          	mov    $0x25,%si
 5ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 5b4:	83 c7 01             	add    $0x1,%edi
 5b7:	84 c0                	test   %al,%al
 5b9:	74 60                	je     61b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 5bb:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5bd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 5c0:	74 e1                	je     5a3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c2:	83 fe 25             	cmp    $0x25,%esi
 5c5:	75 e9                	jne    5b0 <printf+0x30>
      if(c == 'd'){
 5c7:	83 fb 64             	cmp    $0x64,%ebx
 5ca:	0f 84 db 00 00 00    	je     6ab <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5d0:	83 fb 78             	cmp    $0x78,%ebx
 5d3:	74 5b                	je     630 <printf+0xb0>
 5d5:	83 fb 70             	cmp    $0x70,%ebx
 5d8:	74 56                	je     630 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5da:	83 fb 73             	cmp    $0x73,%ebx
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
 5e0:	74 72                	je     654 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e2:	83 fb 63             	cmp    $0x63,%ebx
 5e5:	0f 84 a7 00 00 00    	je     692 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5eb:	83 fb 25             	cmp    $0x25,%ebx
 5ee:	66 90                	xchg   %ax,%ax
 5f0:	0f 84 da 00 00 00    	je     6d0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 5fe:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 600:	e8 cb fe ff ff       	call   4d0 <putc>
        putc(fd, c);
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	0f be d3             	movsbl %bl,%edx
 60b:	e8 c0 fe ff ff       	call   4d0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 610:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 614:	83 c7 01             	add    $0x1,%edi
 617:	84 c0                	test   %al,%al
 619:	75 a0                	jne    5bb <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61b:	83 c4 0c             	add    $0xc,%esp
 61e:	5b                   	pop    %ebx
 61f:	5e                   	pop    %esi
 620:	5f                   	pop    %edi
 621:	5d                   	pop    %ebp
 622:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	0f be d3             	movsbl %bl,%edx
 629:	e8 a2 fe ff ff       	call   4d0 <putc>
 62e:	eb 80                	jmp    5b0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 630:	8b 45 f0             	mov    -0x10(%ebp),%eax
 633:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 638:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 63a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 641:	8b 10                	mov    (%eax),%edx
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	e8 b5 fe ff ff       	call   500 <printint>
        ap++;
 64b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 64f:	e9 5c ff ff ff       	jmp    5b0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 654:	8b 55 f0             	mov    -0x10(%ebp),%edx
 657:	8b 02                	mov    (%edx),%eax
        ap++;
 659:	83 c2 04             	add    $0x4,%edx
 65c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 65f:	ba 78 08 00 00       	mov    $0x878,%edx
 664:	85 c0                	test   %eax,%eax
 666:	75 26                	jne    68e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 668:	0f b6 02             	movzbl (%edx),%eax
 66b:	84 c0                	test   %al,%al
 66d:	74 18                	je     687 <printf+0x107>
 66f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 671:	0f be d0             	movsbl %al,%edx
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	e8 54 fe ff ff       	call   4d0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 680:	83 c3 01             	add    $0x1,%ebx
 683:	84 c0                	test   %al,%al
 685:	75 ea                	jne    671 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 687:	31 f6                	xor    %esi,%esi
 689:	e9 22 ff ff ff       	jmp    5b0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 68e:	89 c2                	mov    %eax,%edx
 690:	eb d6                	jmp    668 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 692:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 695:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	0f be 11             	movsbl (%ecx),%edx
 69d:	e8 2e fe ff ff       	call   4d0 <putc>
        ap++;
 6a2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 6a6:	e9 05 ff ff ff       	jmp    5b0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 6b3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	e8 39 fe ff ff       	call   500 <printint>
        ap++;
 6c7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 6cb:	e9 e0 fe ff ff       	jmp    5b0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 6d0:	8b 45 08             	mov    0x8(%ebp),%eax
 6d3:	ba 25 00 00 00       	mov    $0x25,%edx
 6d8:	31 f6                	xor    %esi,%esi
 6da:	e8 f1 fd ff ff       	call   4d0 <putc>
 6df:	e9 cc fe ff ff       	jmp    5b0 <printf+0x30>
 6e4:	90                   	nop    
 6e5:	90                   	nop    
 6e6:	90                   	nop    
 6e7:	90                   	nop    
 6e8:	90                   	nop    
 6e9:	90                   	nop    
 6ea:	90                   	nop    
 6eb:	90                   	nop    
 6ec:	90                   	nop    
 6ed:	90                   	nop    
 6ee:	90                   	nop    
 6ef:	90                   	nop    

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	8b 0d a0 08 00 00    	mov    0x8a0,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f7:	89 e5                	mov    %esp,%ebp
 6f9:	56                   	push   %esi
 6fa:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6fe:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	39 d9                	cmp    %ebx,%ecx
 703:	73 18                	jae    71d <free+0x2d>
 705:	8b 11                	mov    (%ecx),%edx
 707:	39 d3                	cmp    %edx,%ebx
 709:	72 17                	jb     722 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70b:	39 d1                	cmp    %edx,%ecx
 70d:	72 08                	jb     717 <free+0x27>
 70f:	39 d9                	cmp    %ebx,%ecx
 711:	72 0f                	jb     722 <free+0x32>
 713:	39 d3                	cmp    %edx,%ebx
 715:	72 0b                	jb     722 <free+0x32>
 717:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 719:	39 d9                	cmp    %ebx,%ecx
 71b:	72 e8                	jb     705 <free+0x15>
 71d:	8b 11                	mov    (%ecx),%edx
 71f:	90                   	nop    
 720:	eb e9                	jmp    70b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 722:	8b 73 04             	mov    0x4(%ebx),%esi
 725:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 728:	39 d0                	cmp    %edx,%eax
 72a:	74 18                	je     744 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 72c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 72e:	8b 51 04             	mov    0x4(%ecx),%edx
 731:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 734:	39 d8                	cmp    %ebx,%eax
 736:	74 20                	je     758 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 738:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 73a:	5b                   	pop    %ebx
 73b:	5e                   	pop    %esi
 73c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 73d:	89 0d a0 08 00 00    	mov    %ecx,0x8a0
}
 743:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 744:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 747:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 749:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 74c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 74f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 751:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 754:	39 d8                	cmp    %ebx,%eax
 756:	75 e0                	jne    738 <free+0x48>
    p->s.size += bp->s.size;
 758:	03 53 04             	add    0x4(%ebx),%edx
 75b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 75e:	8b 13                	mov    (%ebx),%edx
 760:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 765:	89 0d a0 08 00 00    	mov    %ecx,0x8a0
}
 76b:	c3                   	ret    
 76c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 15 a0 08 00 00    	mov    0x8a0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	83 c0 07             	add    $0x7,%eax
 785:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 788:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 78d:	0f 84 8a 00 00 00    	je     81d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 795:	8b 41 04             	mov    0x4(%ecx),%eax
 798:	39 c3                	cmp    %eax,%ebx
 79a:	76 1a                	jbe    7b6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 79c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 7a3:	3b 0d a0 08 00 00    	cmp    0x8a0,%ecx
 7a9:	89 ca                	mov    %ecx,%edx
 7ab:	74 29                	je     7d6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ad:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 7af:	8b 41 04             	mov    0x4(%ecx),%eax
 7b2:	39 c3                	cmp    %eax,%ebx
 7b4:	77 ed                	ja     7a3 <malloc+0x33>
      if(p->s.size == nunits)
 7b6:	39 c3                	cmp    %eax,%ebx
 7b8:	74 5d                	je     817 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ba:	29 d8                	sub    %ebx,%eax
 7bc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 7bf:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 7c2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 7c5:	89 15 a0 08 00 00    	mov    %edx,0x8a0
      return (void*) (p + 1);
 7cb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ce:	83 c4 0c             	add    $0xc,%esp
 7d1:	5b                   	pop    %ebx
 7d2:	5e                   	pop    %esi
 7d3:	5f                   	pop    %edi
 7d4:	5d                   	pop    %ebp
 7d5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 7d6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 7dc:	89 de                	mov    %ebx,%esi
 7de:	89 f8                	mov    %edi,%eax
 7e0:	76 29                	jbe    80b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 96 fc ff ff       	call   480 <sbrk>
  if(p == (char*) -1)
 7ea:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ed:	74 18                	je     807 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7ef:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 7f2:	83 c0 08             	add    $0x8,%eax
 7f5:	89 04 24             	mov    %eax,(%esp)
 7f8:	e8 f3 fe ff ff       	call   6f0 <free>
  return freep;
 7fd:	8b 15 a0 08 00 00    	mov    0x8a0,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 803:	85 d2                	test   %edx,%edx
 805:	75 a6                	jne    7ad <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 807:	31 c0                	xor    %eax,%eax
 809:	eb c3                	jmp    7ce <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 80b:	be 00 10 00 00       	mov    $0x1000,%esi
 810:	b8 00 80 00 00       	mov    $0x8000,%eax
 815:	eb cb                	jmp    7e2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 817:	8b 01                	mov    (%ecx),%eax
 819:	89 02                	mov    %eax,(%edx)
 81b:	eb a8                	jmp    7c5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 81d:	ba 98 08 00 00       	mov    $0x898,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 822:	c7 05 a0 08 00 00 98 	movl   $0x898,0x8a0
 829:	08 00 00 
 82c:	c7 05 98 08 00 00 98 	movl   $0x898,0x898
 833:	08 00 00 
    base.s.size = 0;
 836:	c7 05 9c 08 00 00 00 	movl   $0x0,0x89c
 83d:	00 00 00 
 840:	e9 4e ff ff ff       	jmp    793 <malloc+0x23>
