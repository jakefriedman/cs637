
_cvtest:     file format elf32-i386

Disassembly of section .text:

00000000 <cond_init>:
void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
   0:	a1 d4 0a 00 00       	mov    0xad4,%eax

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
   c:	c7 05 d4 0a 00 00 01 	movl   $0x1,0xad4
  13:	00 00 00 
  c->value = cond_count;
  16:	8b 15 d4 0a 00 00    	mov    0xad4,%edx
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 10                	mov    %edx,(%eax)
  cond_count++;
  21:	a1 d4 0a 00 00       	mov    0xad4,%eax
  26:	83 c0 01             	add    $0x1,%eax
  29:	a3 d4 0a 00 00       	mov    %eax,0xad4
  if(cond_count == 0)
  2e:	a1 d4 0a 00 00       	mov    0xad4,%eax
  33:	85 c0                	test   %eax,%eax
  35:	75 0a                	jne    41 <cond_init+0x41>
    cond_count = 1;
  37:	c7 05 d4 0a 00 00 01 	movl   $0x1,0xad4
  3e:	00 00 00 
}	
  41:	5d                   	pop    %ebp
  42:	c3                   	ret    
  43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000050 <put>:
struct cond_t empty;
struct cond_t fill;
struct mutex_t mutex;


void put(int value) {
  50:	55                   	push   %ebp
    buffer[fillcnt] = value;    // line F1
  51:	a1 c0 0a 00 00       	mov    0xac0,%eax
struct cond_t empty;
struct cond_t fill;
struct mutex_t mutex;


void put(int value) {
  56:	89 e5                	mov    %esp,%ebp
    buffer[fillcnt] = value;    // line F1
  58:	8b 55 08             	mov    0x8(%ebp),%edx
struct cond_t empty;
struct cond_t fill;
struct mutex_t mutex;


void put(int value) {
  5b:	53                   	push   %ebx
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
  5c:	8d 58 01             	lea    0x1(%eax),%ebx
  5f:	89 d9                	mov    %ebx,%ecx
struct cond_t fill;
struct mutex_t mutex;


void put(int value) {
    buffer[fillcnt] = value;    // line F1
  61:	89 14 85 20 0b 00 00 	mov    %edx,0xb20(,%eax,4)
    fillcnt = (fillcnt + 1) % MAX; // line F2
  68:	89 d8                	mov    %ebx,%eax
  6a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  6f:	f7 ea                	imul   %edx
  71:	c1 f9 1f             	sar    $0x1f,%ecx
    numfilled++;
  74:	83 05 c8 0a 00 00 01 	addl   $0x1,0xac8
struct mutex_t mutex;


void put(int value) {
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
  7b:	c1 fa 02             	sar    $0x2,%edx
  7e:	29 ca                	sub    %ecx,%edx
  80:	8d 14 92             	lea    (%edx,%edx,4),%edx
  83:	01 d2                	add    %edx,%edx
  85:	29 d3                	sub    %edx,%ebx
  87:	89 1d c0 0a 00 00    	mov    %ebx,0xac0
    numfilled++;
}
  8d:	5b                   	pop    %ebx
  8e:	5d                   	pop    %ebp
  8f:	c3                   	ret    

00000090 <get>:
int get() {
  90:	55                   	push   %ebp
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  91:	ba 67 66 66 66       	mov    $0x66666667,%edx
void put(int value) {
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
  96:	89 e5                	mov    %esp,%ebp
  98:	83 ec 08             	sub    $0x8,%esp
    int tmp = buffer[use];
  9b:	8b 0d c4 0a 00 00    	mov    0xac4,%ecx
void put(int value) {
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
  a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  a5:	89 1c 24             	mov    %ebx,(%esp)
    int tmp = buffer[use];
    use = (use + 1) % MAX;
   numfilled--;
  a8:	83 2d c8 0a 00 00 01 	subl   $0x1,0xac8
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
    int tmp = buffer[use];
  af:	8b 34 8d 20 0b 00 00 	mov    0xb20(,%ecx,4),%esi
    use = (use + 1) % MAX;
  b6:	83 c1 01             	add    $0x1,%ecx
  b9:	89 c8                	mov    %ecx,%eax
  bb:	89 cb                	mov    %ecx,%ebx
  bd:	f7 ea                	imul   %edx
  bf:	c1 fb 1f             	sar    $0x1f,%ebx
   numfilled--;
    return tmp;
}
  c2:	89 f0                	mov    %esi,%eax
  c4:	8b 74 24 04          	mov    0x4(%esp),%esi
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  c8:	c1 fa 02             	sar    $0x2,%edx
  cb:	29 da                	sub    %ebx,%edx
   numfilled--;
    return tmp;
}
  cd:	8b 1c 24             	mov    (%esp),%ebx
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
  d3:	01 d2                	add    %edx,%edx
  d5:	29 d1                	sub    %edx,%ecx
  d7:	89 0d c4 0a 00 00    	mov    %ecx,0xac4
   numfilled--;
    return tmp;
}
  dd:	89 ec                	mov    %ebp,%esp
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	eb 0d                	jmp    f0 <thread_wait>
  e3:	90                   	nop    
  e4:	90                   	nop    
  e5:	90                   	nop    
  e6:	90                   	nop    
  e7:	90                   	nop    
  e8:	90                   	nop    
  e9:	90                   	nop    
  ea:	90                   	nop    
  eb:	90                   	nop    
  ec:	90                   	nop    
  ed:	90                   	nop    
  ee:	90                   	nop    
  ef:	90                   	nop    

000000f0 <thread_wait>:

void thread_wait(){
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	83 ec 08             	sub    $0x8,%esp
	
	int pid;
	while((pid = wait_thread()) != -1);
  f6:	e8 cd 05 00 00       	call   6c8 <wait_thread>
  fb:	83 c0 01             	add    $0x1,%eax
  fe:	75 f6                	jne    f6 <thread_wait+0x6>
	return;
}
 100:	c9                   	leave  
 101:	c3                   	ret    
 102:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000110 <cond_signal>:
  sleep_cond(c->value, m);
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
  wake_cond(c->value);
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	8b 00                	mov    (%eax),%eax
 118:	89 45 08             	mov    %eax,0x8(%ebp)
}
 11b:	5d                   	pop    %ebp
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
 11c:	e9 b7 05 00 00       	jmp    6d8 <wake_cond>
 121:	eb 0d                	jmp    130 <cond_wait>
 123:	90                   	nop    
 124:	90                   	nop    
 125:	90                   	nop    
 126:	90                   	nop    
 127:	90                   	nop    
 128:	90                   	nop    
 129:	90                   	nop    
 12a:	90                   	nop    
 12b:	90                   	nop    
 12c:	90                   	nop    
 12d:	90                   	nop    
 12e:	90                   	nop    
 12f:	90                   	nop    

00000130 <cond_wait>:
		
	return pid;

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	8b 00                	mov    (%eax),%eax
 138:	89 45 08             	mov    %eax,0x8(%ebp)
  //mutex_lock(m);
}
 13b:	5d                   	pop    %ebp

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
 13c:	e9 8f 05 00 00       	jmp    6d0 <sleep_cond>
 141:	eb 0d                	jmp    150 <thread_create>
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

00000150 <thread_create>:
  xchng(lock->lock, 0);
  //printf(1,"unlocked-%d\n", lock);
}


int thread_create(void*(*start_routine)(void *), void *arg){
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 18             	sub    $0x18,%esp
	
	//Allocate stack using process heap
	int stack = malloc(1024);
 156:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 15d:	e8 2e 08 00 00       	call   990 <malloc>

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
 162:	8b 55 0c             	mov    0xc(%ebp),%edx
 165:	89 54 24 08          	mov    %edx,0x8(%esp)
 169:	8b 55 08             	mov    0x8(%ebp),%edx
 16c:	89 04 24             	mov    %eax,(%esp)
 16f:	89 54 24 04          	mov    %edx,0x4(%esp)
 173:	e8 48 05 00 00       	call   6c0 <fork_thread>
		
	return pid;

}
 178:	c9                   	leave  
 179:	c3                   	ret    
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
 196:	e8 45 05 00 00       	call   6e0 <xchng>
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
 1bd:	e8 1e 05 00 00       	call   6e0 <xchng>
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

000001d0 <consumer>:
        //printf(1, "ret\n");
        mutex_unlock(&mutex);          // p6
    }
exit();
}
void *consumer(void *arg) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
 1d6:	83 ec 1c             	sub    $0x1c,%esp
	int k = *(int*) arg;
    int i;
    for (i = 0; i < loops; i++) {
 1d9:	8b 0d cc 0a 00 00    	mov    0xacc,%ecx
        mutex_unlock(&mutex);          // p6
    }
exit();
}
void *consumer(void *arg) {
	int k = *(int*) arg;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
    int i;
    for (i = 0; i < loops; i++) {
 1e2:	85 c9                	test   %ecx,%ecx
        mutex_unlock(&mutex);          // p6
    }
exit();
}
void *consumer(void *arg) {
	int k = *(int*) arg;
 1e4:	8b 30                	mov    (%eax),%esi
    int i;
    for (i = 0; i < loops; i++) {
 1e6:	0f 8e 97 00 00 00    	jle    283 <consumer+0xb3>
 1ec:	31 ff                	xor    %edi,%edi
        mutex_lock(&mutex);
 1ee:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
 1f5:	e8 a6 ff ff ff       	call   1a0 <mutex_lock>
        while (numfilled == 0)
 1fa:	8b 15 c8 0a 00 00    	mov    0xac8,%edx
 200:	85 d2                	test   %edx,%edx
 202:	75 35                	jne    239 <consumer+0x69>
{
		printf(1, "consumer %d waiting\n", k);
 204:	89 74 24 08          	mov    %esi,0x8(%esp)
 208:	c7 44 24 04 65 0a 00 	movl   $0xa65,0x4(%esp)
 20f:	00 
 210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 217:	e8 84 05 00 00       	call   7a0 <printf>
            cond_wait(&fill, &mutex);
 21c:	c7 44 24 04 04 0b 00 	movl   $0xb04,0x4(%esp)
 223:	00 
 224:	c7 04 24 00 0b 00 00 	movl   $0xb00,(%esp)
 22b:	e8 00 ff ff ff       	call   130 <cond_wait>
void *consumer(void *arg) {
	int k = *(int*) arg;
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0)
 230:	a1 c8 0a 00 00       	mov    0xac8,%eax
 235:	85 c0                	test   %eax,%eax
 237:	74 cb                	je     204 <consumer+0x34>
{
		printf(1, "consumer %d waiting\n", k);
            cond_wait(&fill, &mutex);
}
        int tmp = get();
 239:	e8 52 fe ff ff       	call   90 <get>
exit();
}
void *consumer(void *arg) {
	int k = *(int*) arg;
    int i;
    for (i = 0; i < loops; i++) {
 23e:	83 c7 01             	add    $0x1,%edi
{
		printf(1, "consumer %d waiting\n", k);
            cond_wait(&fill, &mutex);
}
        int tmp = get();
        cond_signal(&empty);
 241:	c7 04 24 48 0b 00 00 	movl   $0xb48,(%esp)
        while (numfilled == 0)
{
		printf(1, "consumer %d waiting\n", k);
            cond_wait(&fill, &mutex);
}
        int tmp = get();
 248:	89 c3                	mov    %eax,%ebx
        cond_signal(&empty);
 24a:	e8 c1 fe ff ff       	call   110 <cond_signal>
        mutex_unlock(&mutex);
 24f:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
 256:	e8 25 ff ff ff       	call   180 <mutex_unlock>
        printf(1,"consumer %d got %d\n",k, tmp);
 25b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 25f:	89 74 24 08          	mov    %esi,0x8(%esp)
 263:	c7 44 24 04 7a 0a 00 	movl   $0xa7a,0x4(%esp)
 26a:	00 
 26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 272:	e8 29 05 00 00       	call   7a0 <printf>
exit();
}
void *consumer(void *arg) {
	int k = *(int*) arg;
    int i;
    for (i = 0; i < loops; i++) {
 277:	39 3d cc 0a 00 00    	cmp    %edi,0xacc
 27d:	0f 8f 6b ff ff ff    	jg     1ee <consumer+0x1e>
        int tmp = get();
        cond_signal(&empty);
        mutex_unlock(&mutex);
        printf(1,"consumer %d got %d\n",k, tmp);
    }
exit();
 283:	e8 90 03 00 00       	call   618 <exit>
 288:	90                   	nop    
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000290 <producer>:
   numfilled--;
    return tmp;
}


void *producer(void *arg) {
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; i < loops; i++) {
 297:	8b 1d cc 0a 00 00    	mov    0xacc,%ebx
 29d:	85 db                	test   %ebx,%ebx
 29f:	7e 77                	jle    318 <producer+0x88>
 2a1:	31 db                	xor    %ebx,%ebx
        mutex_lock(&mutex);            // p1
 2a3:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
 2aa:	e8 f1 fe ff ff       	call   1a0 <mutex_lock>
        while (numfilled == MAX)       // p2
 2af:	83 3d c8 0a 00 00 0a 	cmpl   $0xa,0xac8
 2b6:	75 1d                	jne    2d5 <producer+0x45>
            cond_wait(&empty, &mutex); // p3
 2b8:	c7 44 24 04 04 0b 00 	movl   $0xb04,0x4(%esp)
 2bf:	00 
 2c0:	c7 04 24 48 0b 00 00 	movl   $0xb48,(%esp)
 2c7:	e8 64 fe ff ff       	call   130 <cond_wait>

void *producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);            // p1
        while (numfilled == MAX)       // p2
 2cc:	83 3d c8 0a 00 00 0a 	cmpl   $0xa,0xac8
 2d3:	74 e3                	je     2b8 <producer+0x28>
            cond_wait(&empty, &mutex); // p3
        put(i);                        // p4
 2d5:	89 1c 24             	mov    %ebx,(%esp)
 2d8:	e8 73 fd ff ff       	call   50 <put>
        printf(1, "put %d\n", i);
 2dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
}


void *producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
 2e1:	83 c3 01             	add    $0x1,%ebx
        mutex_lock(&mutex);            // p1
        while (numfilled == MAX)       // p2
            cond_wait(&empty, &mutex); // p3
        put(i);                        // p4
        printf(1, "put %d\n", i);
 2e4:	c7 44 24 04 8e 0a 00 	movl   $0xa8e,0x4(%esp)
 2eb:	00 
 2ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f3:	e8 a8 04 00 00       	call   7a0 <printf>
        cond_signal(&fill);            // p5
 2f8:	c7 04 24 00 0b 00 00 	movl   $0xb00,(%esp)
 2ff:	e8 0c fe ff ff       	call   110 <cond_signal>
        //printf(1, "ret\n");
        mutex_unlock(&mutex);          // p6
 304:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
 30b:	e8 70 fe ff ff       	call   180 <mutex_unlock>
}


void *producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
 310:	39 1d cc 0a 00 00    	cmp    %ebx,0xacc
 316:	7f 8b                	jg     2a3 <producer+0x13>
        printf(1, "put %d\n", i);
        cond_signal(&fill);            // p5
        //printf(1, "ret\n");
        mutex_unlock(&mutex);          // p6
    }
exit();
 318:	e8 fb 02 00 00       	call   618 <exit>
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <mutex_init>:
static volatile unsigned int cond_count = 0;




void mutex_init(struct mutex_t* lock) {
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	83 ec 08             	sub    $0x8,%esp
  xchng(lock->lock, 0); //0 is unused
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	8b 00                	mov    (%eax),%eax
 32b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 332:	00 
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 a5 03 00 00       	call   6e0 <xchng>
}
 33b:	c9                   	leave  
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <main>:
exit();
}



void main() {
 340:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 344:	83 e4 f0             	and    $0xfffffff0,%esp
 347:	ff 71 fc             	pushl  -0x4(%ecx)
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 18             	sub    $0x18,%esp
    loops = 5;
    numconsumers = 3;

    mutex_init(&mutex);
 350:	c7 04 24 04 0b 00 00 	movl   $0xb04,(%esp)
exit();
}



void main() {
 357:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 35a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
 35d:	89 75 f8             	mov    %esi,-0x8(%ebp)
 360:	89 7d fc             	mov    %edi,-0x4(%ebp)
    loops = 5;
 363:	c7 05 cc 0a 00 00 05 	movl   $0x5,0xacc
 36a:	00 00 00 
    numconsumers = 3;
 36d:	c7 05 d0 0a 00 00 03 	movl   $0x3,0xad0
 374:	00 00 00 

    mutex_init(&mutex);
 377:	e8 a4 ff ff ff       	call   320 <mutex_init>
    cond_init(&fill);
 37c:	c7 04 24 00 0b 00 00 	movl   $0xb00,(%esp)
 383:	e8 78 fc ff ff       	call   0 <cond_init>
    cond_init(&empty);
 388:	c7 04 24 48 0b 00 00 	movl   $0xb48,(%esp)
 38f:	e8 6c fc ff ff       	call   0 <cond_init>
//printf(1,"lock after init %d\n",(&mutex)->lock);
    int cons[numconsumers];
 394:	a1 d0 0a 00 00       	mov    0xad0,%eax
 399:	8d 04 85 1e 00 00 00 	lea    0x1e(,%eax,4),%eax
 3a0:	83 e0 f0             	and    $0xfffffff0,%eax
 3a3:	29 c4                	sub    %eax,%esp
    int * arg = malloc(sizeof(int));
 3a5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)

    mutex_init(&mutex);
    cond_init(&fill);
    cond_init(&empty);
//printf(1,"lock after init %d\n",(&mutex)->lock);
    int cons[numconsumers];
 3ac:	8d 7c 24 17          	lea    0x17(%esp),%edi
    int * arg = malloc(sizeof(int));
 3b0:	e8 db 05 00 00       	call   990 <malloc>

    mutex_init(&mutex);
    cond_init(&fill);
    cond_init(&empty);
//printf(1,"lock after init %d\n",(&mutex)->lock);
    int cons[numconsumers];
 3b5:	83 e7 f0             	and    $0xfffffff0,%edi
    int * arg = malloc(sizeof(int));
    *arg = 1; 
 3b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    mutex_init(&mutex);
    cond_init(&fill);
    cond_init(&empty);
//printf(1,"lock after init %d\n",(&mutex)->lock);
    int cons[numconsumers];
    int * arg = malloc(sizeof(int));
 3be:	89 c3                	mov    %eax,%ebx
    *arg = 1; 
    // create threads (producer and consumers)
    int prod = thread_create(producer, arg);
 3c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c4:	c7 04 24 90 02 00 00 	movl   $0x290,(%esp)
 3cb:	e8 80 fd ff ff       	call   150 <thread_create>
    int i;
    for (i = 0; i < numconsumers; i++)
 3d0:	8b 35 d0 0a 00 00    	mov    0xad0,%esi
 3d6:	85 f6                	test   %esi,%esi
 3d8:	7e 22                	jle    3fc <main+0xbc>
 3da:	8d 46 ff             	lea    -0x1(%esi),%eax
 3dd:	89 03                	mov    %eax,(%ebx)
	*arg = i;
        cons[i] = thread_create(consumer, arg);
 3df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 3e3:	c7 04 24 d0 01 00 00 	movl   $0x1d0,(%esp)
 3ea:	e8 61 fd ff ff       	call   150 <thread_create>
 3ef:	89 04 b7             	mov    %eax,(%edi,%esi,4)
    // wait for producer and consumers to finish
    thread_wait();
 3f2:	e8 f9 fc ff ff       	call   f0 <thread_wait>
    exit();
 3f7:	e8 1c 02 00 00       	call   618 <exit>
    int * arg = malloc(sizeof(int));
    *arg = 1; 
    // create threads (producer and consumers)
    int prod = thread_create(producer, arg);
    int i;
    for (i = 0; i < numconsumers; i++)
 3fc:	31 f6                	xor    %esi,%esi
 3fe:	eb df                	jmp    3df <main+0x9f>

00000400 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 5d 08             	mov    0x8(%ebp),%ebx
 407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 40a:	89 da                	mov    %ebx,%edx
 40c:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 410:	0f b6 01             	movzbl (%ecx),%eax
 413:	83 c1 01             	add    $0x1,%ecx
 416:	88 02                	mov    %al,(%edx)
 418:	83 c2 01             	add    $0x1,%edx
 41b:	84 c0                	test   %al,%al
 41d:	75 f1                	jne    410 <strcpy+0x10>
    ;
  return os;
}
 41f:	89 d8                	mov    %ebx,%eax
 421:	5b                   	pop    %ebx
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 42a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 4d 08             	mov    0x8(%ebp),%ecx
 436:	53                   	push   %ebx
 437:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 43a:	0f b6 01             	movzbl (%ecx),%eax
 43d:	84 c0                	test   %al,%al
 43f:	74 24                	je     465 <strcmp+0x35>
 441:	0f b6 13             	movzbl (%ebx),%edx
 444:	38 d0                	cmp    %dl,%al
 446:	74 12                	je     45a <strcmp+0x2a>
 448:	eb 1e                	jmp    468 <strcmp+0x38>
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 450:	0f b6 13             	movzbl (%ebx),%edx
 453:	83 c1 01             	add    $0x1,%ecx
 456:	38 d0                	cmp    %dl,%al
 458:	75 0e                	jne    468 <strcmp+0x38>
 45a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 45e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 461:	84 c0                	test   %al,%al
 463:	75 eb                	jne    450 <strcmp+0x20>
 465:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 468:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 469:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 46c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 46d:	0f b6 d2             	movzbl %dl,%edx
 470:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 472:	c3                   	ret    
 473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000480 <strlen>:

uint
strlen(char *s)
{
 480:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 481:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 483:	89 e5                	mov    %esp,%ebp
 485:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 488:	80 39 00             	cmpb   $0x0,(%ecx)
 48b:	74 0e                	je     49b <strlen+0x1b>
 48d:	31 d2                	xor    %edx,%edx
 48f:	90                   	nop    
 490:	83 c2 01             	add    $0x1,%edx
 493:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 497:	89 d0                	mov    %edx,%eax
 499:	75 f5                	jne    490 <strlen+0x10>
    ;
  return n;
}
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    
 49d:	8d 76 00             	lea    0x0(%esi),%esi

000004a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	8b 45 10             	mov    0x10(%ebp),%eax
 4a6:	53                   	push   %ebx
 4a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 4aa:	85 c0                	test   %eax,%eax
 4ac:	74 10                	je     4be <memset+0x1e>
 4ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 4b2:	31 d2                	xor    %edx,%edx
    *d++ = c;
 4b4:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 4b7:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 4ba:	39 c2                	cmp    %eax,%edx
 4bc:	75 f6                	jne    4b4 <memset+0x14>
    *d++ = c;
  return dst;
}
 4be:	89 d8                	mov    %ebx,%eax
 4c0:	5b                   	pop    %ebx
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
 4c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000004d0 <strchr>:

char*
strchr(const char *s, char c)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 4da:	0f b6 10             	movzbl (%eax),%edx
 4dd:	84 d2                	test   %dl,%dl
 4df:	75 0c                	jne    4ed <strchr+0x1d>
 4e1:	eb 11                	jmp    4f4 <strchr+0x24>
 4e3:	83 c0 01             	add    $0x1,%eax
 4e6:	0f b6 10             	movzbl (%eax),%edx
 4e9:	84 d2                	test   %dl,%dl
 4eb:	74 07                	je     4f4 <strchr+0x24>
    if(*s == c)
 4ed:	38 ca                	cmp    %cl,%dl
 4ef:	90                   	nop    
 4f0:	75 f1                	jne    4e3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 4f2:	5d                   	pop    %ebp
 4f3:	c3                   	ret    
 4f4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4f5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 4f7:	c3                   	ret    
 4f8:	90                   	nop    
 4f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000500 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	8b 4d 08             	mov    0x8(%ebp),%ecx
 506:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 507:	31 db                	xor    %ebx,%ebx
 509:	0f b6 11             	movzbl (%ecx),%edx
 50c:	8d 42 d0             	lea    -0x30(%edx),%eax
 50f:	3c 09                	cmp    $0x9,%al
 511:	77 18                	ja     52b <atoi+0x2b>
    n = n*10 + *s++ - '0';
 513:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 516:	0f be d2             	movsbl %dl,%edx
 519:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 51d:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 521:	83 c1 01             	add    $0x1,%ecx
 524:	8d 42 d0             	lea    -0x30(%edx),%eax
 527:	3c 09                	cmp    $0x9,%al
 529:	76 e8                	jbe    513 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 52b:	89 d8                	mov    %ebx,%eax
 52d:	5b                   	pop    %ebx
 52e:	5d                   	pop    %ebp
 52f:	c3                   	ret    

00000530 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	8b 4d 10             	mov    0x10(%ebp),%ecx
 536:	56                   	push   %esi
 537:	8b 75 08             	mov    0x8(%ebp),%esi
 53a:	53                   	push   %ebx
 53b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53e:	85 c9                	test   %ecx,%ecx
 540:	7e 10                	jle    552 <memmove+0x22>
 542:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 544:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 548:	88 04 32             	mov    %al,(%edx,%esi,1)
 54b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 54e:	39 ca                	cmp    %ecx,%edx
 550:	75 f2                	jne    544 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 552:	89 f0                	mov    %esi,%eax
 554:	5b                   	pop    %ebx
 555:	5e                   	pop    %esi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop    
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000560 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 566:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 569:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 56c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 56f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 574:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 57b:	00 
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 d4 00 00 00       	call   658 <open>
  if(fd < 0)
 584:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 586:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 588:	78 19                	js     5a3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 58a:	8b 45 0c             	mov    0xc(%ebp),%eax
 58d:	89 1c 24             	mov    %ebx,(%esp)
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	e8 d7 00 00 00       	call   670 <fstat>
  close(fd);
 599:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 59c:	89 c6                	mov    %eax,%esi
  close(fd);
 59e:	e8 9d 00 00 00       	call   640 <close>
  return r;
}
 5a3:	89 f0                	mov    %esi,%eax
 5a5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 5a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 5ab:	89 ec                	mov    %ebp,%esp
 5ad:	5d                   	pop    %ebp
 5ae:	c3                   	ret    
 5af:	90                   	nop    

000005b0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	31 f6                	xor    %esi,%esi
 5b7:	53                   	push   %ebx
 5b8:	83 ec 1c             	sub    $0x1c,%esp
 5bb:	8b 7d 08             	mov    0x8(%ebp),%edi
 5be:	eb 06                	jmp    5c6 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5c0:	3c 0d                	cmp    $0xd,%al
 5c2:	74 39                	je     5fd <gets+0x4d>
 5c4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c6:	8d 5e 01             	lea    0x1(%esi),%ebx
 5c9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 5cc:	7d 31                	jge    5ff <gets+0x4f>
    cc = read(0, &c, 1);
 5ce:	8d 45 f3             	lea    -0xd(%ebp),%eax
 5d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d8:	00 
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5e4:	e8 47 00 00 00       	call   630 <read>
    if(cc < 1)
 5e9:	85 c0                	test   %eax,%eax
 5eb:	7e 12                	jle    5ff <gets+0x4f>
      break;
    buf[i++] = c;
 5ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 5f1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 5f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 5f9:	3c 0a                	cmp    $0xa,%al
 5fb:	75 c3                	jne    5c0 <gets+0x10>
 5fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 5ff:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 603:	89 f8                	mov    %edi,%eax
 605:	83 c4 1c             	add    $0x1c,%esp
 608:	5b                   	pop    %ebx
 609:	5e                   	pop    %esi
 60a:	5f                   	pop    %edi
 60b:	5d                   	pop    %ebp
 60c:	c3                   	ret    
 60d:	90                   	nop    
 60e:	90                   	nop    
 60f:	90                   	nop    

00000610 <fork>:
 610:	b8 01 00 00 00       	mov    $0x1,%eax
 615:	cd 30                	int    $0x30
 617:	c3                   	ret    

00000618 <exit>:
 618:	b8 02 00 00 00       	mov    $0x2,%eax
 61d:	cd 30                	int    $0x30
 61f:	c3                   	ret    

00000620 <wait>:
 620:	b8 03 00 00 00       	mov    $0x3,%eax
 625:	cd 30                	int    $0x30
 627:	c3                   	ret    

00000628 <pipe>:
 628:	b8 04 00 00 00       	mov    $0x4,%eax
 62d:	cd 30                	int    $0x30
 62f:	c3                   	ret    

00000630 <read>:
 630:	b8 06 00 00 00       	mov    $0x6,%eax
 635:	cd 30                	int    $0x30
 637:	c3                   	ret    

00000638 <write>:
 638:	b8 05 00 00 00       	mov    $0x5,%eax
 63d:	cd 30                	int    $0x30
 63f:	c3                   	ret    

00000640 <close>:
 640:	b8 07 00 00 00       	mov    $0x7,%eax
 645:	cd 30                	int    $0x30
 647:	c3                   	ret    

00000648 <kill>:
 648:	b8 08 00 00 00       	mov    $0x8,%eax
 64d:	cd 30                	int    $0x30
 64f:	c3                   	ret    

00000650 <exec>:
 650:	b8 09 00 00 00       	mov    $0x9,%eax
 655:	cd 30                	int    $0x30
 657:	c3                   	ret    

00000658 <open>:
 658:	b8 0a 00 00 00       	mov    $0xa,%eax
 65d:	cd 30                	int    $0x30
 65f:	c3                   	ret    

00000660 <mknod>:
 660:	b8 0b 00 00 00       	mov    $0xb,%eax
 665:	cd 30                	int    $0x30
 667:	c3                   	ret    

00000668 <unlink>:
 668:	b8 0c 00 00 00       	mov    $0xc,%eax
 66d:	cd 30                	int    $0x30
 66f:	c3                   	ret    

00000670 <fstat>:
 670:	b8 0d 00 00 00       	mov    $0xd,%eax
 675:	cd 30                	int    $0x30
 677:	c3                   	ret    

00000678 <link>:
 678:	b8 0e 00 00 00       	mov    $0xe,%eax
 67d:	cd 30                	int    $0x30
 67f:	c3                   	ret    

00000680 <mkdir>:
 680:	b8 0f 00 00 00       	mov    $0xf,%eax
 685:	cd 30                	int    $0x30
 687:	c3                   	ret    

00000688 <chdir>:
 688:	b8 10 00 00 00       	mov    $0x10,%eax
 68d:	cd 30                	int    $0x30
 68f:	c3                   	ret    

00000690 <dup>:
 690:	b8 11 00 00 00       	mov    $0x11,%eax
 695:	cd 30                	int    $0x30
 697:	c3                   	ret    

00000698 <getpid>:
 698:	b8 12 00 00 00       	mov    $0x12,%eax
 69d:	cd 30                	int    $0x30
 69f:	c3                   	ret    

000006a0 <sbrk>:
 6a0:	b8 13 00 00 00       	mov    $0x13,%eax
 6a5:	cd 30                	int    $0x30
 6a7:	c3                   	ret    

000006a8 <sleep>:
 6a8:	b8 14 00 00 00       	mov    $0x14,%eax
 6ad:	cd 30                	int    $0x30
 6af:	c3                   	ret    

000006b0 <tick>:
 6b0:	b8 15 00 00 00       	mov    $0x15,%eax
 6b5:	cd 30                	int    $0x30
 6b7:	c3                   	ret    

000006b8 <fork_tickets>:
 6b8:	b8 16 00 00 00       	mov    $0x16,%eax
 6bd:	cd 30                	int    $0x30
 6bf:	c3                   	ret    

000006c0 <fork_thread>:
 6c0:	b8 17 00 00 00       	mov    $0x17,%eax
 6c5:	cd 30                	int    $0x30
 6c7:	c3                   	ret    

000006c8 <wait_thread>:
 6c8:	b8 18 00 00 00       	mov    $0x18,%eax
 6cd:	cd 30                	int    $0x30
 6cf:	c3                   	ret    

000006d0 <sleep_cond>:
 6d0:	b8 19 00 00 00       	mov    $0x19,%eax
 6d5:	cd 30                	int    $0x30
 6d7:	c3                   	ret    

000006d8 <wake_cond>:
 6d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6dd:	cd 30                	int    $0x30
 6df:	c3                   	ret    

000006e0 <xchng>:
 6e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6e5:	cd 30                	int    $0x30
 6e7:	c3                   	ret    

000006e8 <check>:
 6e8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6ed:	cd 30                	int    $0x30
 6ef:	c3                   	ret    

000006f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	83 ec 18             	sub    $0x18,%esp
 6f6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 6f9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 6fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 703:	00 
 704:	89 54 24 04          	mov    %edx,0x4(%esp)
 708:	89 04 24             	mov    %eax,(%esp)
 70b:	e8 28 ff ff ff       	call   638 <write>
}
 710:	c9                   	leave  
 711:	c3                   	ret    
 712:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000720 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	89 ce                	mov    %ecx,%esi
 727:	53                   	push   %ebx
 728:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 72b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 72e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 731:	85 c9                	test   %ecx,%ecx
 733:	74 04                	je     739 <printint+0x19>
 735:	85 d2                	test   %edx,%edx
 737:	78 54                	js     78d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 739:	89 d0                	mov    %edx,%eax
 73b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 742:	31 db                	xor    %ebx,%ebx
 744:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 747:	31 d2                	xor    %edx,%edx
 749:	f7 f6                	div    %esi
 74b:	89 c1                	mov    %eax,%ecx
 74d:	0f b6 82 9d 0a 00 00 	movzbl 0xa9d(%edx),%eax
 754:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 757:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 75a:	85 c9                	test   %ecx,%ecx
 75c:	89 c8                	mov    %ecx,%eax
 75e:	75 e7                	jne    747 <printint+0x27>
  if(neg)
 760:	8b 45 e0             	mov    -0x20(%ebp),%eax
 763:	85 c0                	test   %eax,%eax
 765:	74 08                	je     76f <printint+0x4f>
    buf[i++] = '-';
 767:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 76c:	83 c3 01             	add    $0x1,%ebx
 76f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 772:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 776:	83 eb 01             	sub    $0x1,%ebx
 779:	8b 45 dc             	mov    -0x24(%ebp),%eax
 77c:	e8 6f ff ff ff       	call   6f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 781:	39 fb                	cmp    %edi,%ebx
 783:	75 ed                	jne    772 <printint+0x52>
    putc(fd, buf[i]);
}
 785:	83 c4 1c             	add    $0x1c,%esp
 788:	5b                   	pop    %ebx
 789:	5e                   	pop    %esi
 78a:	5f                   	pop    %edi
 78b:	5d                   	pop    %ebp
 78c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 78d:	89 d0                	mov    %edx,%eax
 78f:	f7 d8                	neg    %eax
 791:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 798:	eb a8                	jmp    742 <printint+0x22>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ac:	0f b6 02             	movzbl (%edx),%eax
 7af:	84 c0                	test   %al,%al
 7b1:	0f 84 84 00 00 00    	je     83b <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 7ba:	89 d7                	mov    %edx,%edi
 7bc:	31 f6                	xor    %esi,%esi
 7be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 7c1:	eb 18                	jmp    7db <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7c3:	83 fb 25             	cmp    $0x25,%ebx
 7c6:	75 7b                	jne    843 <printf+0xa3>
 7c8:	66 be 25 00          	mov    $0x25,%si
 7cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 7d4:	83 c7 01             	add    $0x1,%edi
 7d7:	84 c0                	test   %al,%al
 7d9:	74 60                	je     83b <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 7db:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 7dd:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 7e0:	74 e1                	je     7c3 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e2:	83 fe 25             	cmp    $0x25,%esi
 7e5:	75 e9                	jne    7d0 <printf+0x30>
      if(c == 'd'){
 7e7:	83 fb 64             	cmp    $0x64,%ebx
 7ea:	0f 84 db 00 00 00    	je     8cb <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7f0:	83 fb 78             	cmp    $0x78,%ebx
 7f3:	74 5b                	je     850 <printf+0xb0>
 7f5:	83 fb 70             	cmp    $0x70,%ebx
 7f8:	74 56                	je     850 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7fa:	83 fb 73             	cmp    $0x73,%ebx
 7fd:	8d 76 00             	lea    0x0(%esi),%esi
 800:	74 72                	je     874 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 802:	83 fb 63             	cmp    $0x63,%ebx
 805:	0f 84 a7 00 00 00    	je     8b2 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 80b:	83 fb 25             	cmp    $0x25,%ebx
 80e:	66 90                	xchg   %ax,%ax
 810:	0f 84 da 00 00 00    	je     8f0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 816:	8b 45 08             	mov    0x8(%ebp),%eax
 819:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 81e:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 820:	e8 cb fe ff ff       	call   6f0 <putc>
        putc(fd, c);
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	0f be d3             	movsbl %bl,%edx
 82b:	e8 c0 fe ff ff       	call   6f0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 830:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 834:	83 c7 01             	add    $0x1,%edi
 837:	84 c0                	test   %al,%al
 839:	75 a0                	jne    7db <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83b:	83 c4 0c             	add    $0xc,%esp
 83e:	5b                   	pop    %ebx
 83f:	5e                   	pop    %esi
 840:	5f                   	pop    %edi
 841:	5d                   	pop    %ebp
 842:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	0f be d3             	movsbl %bl,%edx
 849:	e8 a2 fe ff ff       	call   6f0 <putc>
 84e:	eb 80                	jmp    7d0 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 858:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 85a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 861:	8b 10                	mov    (%eax),%edx
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	e8 b5 fe ff ff       	call   720 <printint>
        ap++;
 86b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 86f:	e9 5c ff ff ff       	jmp    7d0 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 874:	8b 55 f0             	mov    -0x10(%ebp),%edx
 877:	8b 02                	mov    (%edx),%eax
        ap++;
 879:	83 c2 04             	add    $0x4,%edx
 87c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 87f:	ba 96 0a 00 00       	mov    $0xa96,%edx
 884:	85 c0                	test   %eax,%eax
 886:	75 26                	jne    8ae <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 888:	0f b6 02             	movzbl (%edx),%eax
 88b:	84 c0                	test   %al,%al
 88d:	74 18                	je     8a7 <printf+0x107>
 88f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 891:	0f be d0             	movsbl %al,%edx
 894:	8b 45 08             	mov    0x8(%ebp),%eax
 897:	e8 54 fe ff ff       	call   6f0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 89c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 8a0:	83 c3 01             	add    $0x1,%ebx
 8a3:	84 c0                	test   %al,%al
 8a5:	75 ea                	jne    891 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 8a7:	31 f6                	xor    %esi,%esi
 8a9:	e9 22 ff ff ff       	jmp    7d0 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 8ae:	89 c2                	mov    %eax,%edx
 8b0:	eb d6                	jmp    888 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 8b5:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	0f be 11             	movsbl (%ecx),%edx
 8bd:	e8 2e fe ff ff       	call   6f0 <putc>
        ap++;
 8c2:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 8c6:	e9 05 ff ff ff       	jmp    7d0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 8d3:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8dd:	8b 10                	mov    (%eax),%edx
 8df:	8b 45 08             	mov    0x8(%ebp),%eax
 8e2:	e8 39 fe ff ff       	call   720 <printint>
        ap++;
 8e7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 8eb:	e9 e0 fe ff ff       	jmp    7d0 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
 8f3:	ba 25 00 00 00       	mov    $0x25,%edx
 8f8:	31 f6                	xor    %esi,%esi
 8fa:	e8 f1 fd ff ff       	call   6f0 <putc>
 8ff:	e9 cc fe ff ff       	jmp    7d0 <printf+0x30>
 904:	90                   	nop    
 905:	90                   	nop    
 906:	90                   	nop    
 907:	90                   	nop    
 908:	90                   	nop    
 909:	90                   	nop    
 90a:	90                   	nop    
 90b:	90                   	nop    
 90c:	90                   	nop    
 90d:	90                   	nop    
 90e:	90                   	nop    
 90f:	90                   	nop    

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	8b 0d e0 0a 00 00    	mov    0xae0,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 917:	89 e5                	mov    %esp,%ebp
 919:	56                   	push   %esi
 91a:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 91e:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	39 d9                	cmp    %ebx,%ecx
 923:	73 18                	jae    93d <free+0x2d>
 925:	8b 11                	mov    (%ecx),%edx
 927:	39 d3                	cmp    %edx,%ebx
 929:	72 17                	jb     942 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92b:	39 d1                	cmp    %edx,%ecx
 92d:	72 08                	jb     937 <free+0x27>
 92f:	39 d9                	cmp    %ebx,%ecx
 931:	72 0f                	jb     942 <free+0x32>
 933:	39 d3                	cmp    %edx,%ebx
 935:	72 0b                	jb     942 <free+0x32>
 937:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 939:	39 d9                	cmp    %ebx,%ecx
 93b:	72 e8                	jb     925 <free+0x15>
 93d:	8b 11                	mov    (%ecx),%edx
 93f:	90                   	nop    
 940:	eb e9                	jmp    92b <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 942:	8b 73 04             	mov    0x4(%ebx),%esi
 945:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 948:	39 d0                	cmp    %edx,%eax
 94a:	74 18                	je     964 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 94c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 94e:	8b 51 04             	mov    0x4(%ecx),%edx
 951:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 954:	39 d8                	cmp    %ebx,%eax
 956:	74 20                	je     978 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 958:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 95a:	5b                   	pop    %ebx
 95b:	5e                   	pop    %esi
 95c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 95d:	89 0d e0 0a 00 00    	mov    %ecx,0xae0
}
 963:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 964:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 967:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 969:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 96c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 96f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 971:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 974:	39 d8                	cmp    %ebx,%eax
 976:	75 e0                	jne    958 <free+0x48>
    p->s.size += bp->s.size;
 978:	03 53 04             	add    0x4(%ebx),%edx
 97b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 97e:	8b 13                	mov    (%ebx),%edx
 980:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 982:	5b                   	pop    %ebx
 983:	5e                   	pop    %esi
 984:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 985:	89 0d e0 0a 00 00    	mov    %ecx,0xae0
}
 98b:	c3                   	ret    
 98c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000990 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
 996:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 999:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 99c:	8b 15 e0 0a 00 00    	mov    0xae0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	83 c0 07             	add    $0x7,%eax
 9a5:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 9a8:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9aa:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 9ad:	0f 84 8a 00 00 00    	je     a3d <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 9b5:	8b 41 04             	mov    0x4(%ecx),%eax
 9b8:	39 c3                	cmp    %eax,%ebx
 9ba:	76 1a                	jbe    9d6 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 9bc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 9c3:	3b 0d e0 0a 00 00    	cmp    0xae0,%ecx
 9c9:	89 ca                	mov    %ecx,%edx
 9cb:	74 29                	je     9f6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cd:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 9cf:	8b 41 04             	mov    0x4(%ecx),%eax
 9d2:	39 c3                	cmp    %eax,%ebx
 9d4:	77 ed                	ja     9c3 <malloc+0x33>
      if(p->s.size == nunits)
 9d6:	39 c3                	cmp    %eax,%ebx
 9d8:	74 5d                	je     a37 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 9da:	29 d8                	sub    %ebx,%eax
 9dc:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 9df:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 9e2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 9e5:	89 15 e0 0a 00 00    	mov    %edx,0xae0
      return (void*) (p + 1);
 9eb:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ee:	83 c4 0c             	add    $0xc,%esp
 9f1:	5b                   	pop    %ebx
 9f2:	5e                   	pop    %esi
 9f3:	5f                   	pop    %edi
 9f4:	5d                   	pop    %ebp
 9f5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 9f6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 9fc:	89 de                	mov    %ebx,%esi
 9fe:	89 f8                	mov    %edi,%eax
 a00:	76 29                	jbe    a2b <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 a02:	89 04 24             	mov    %eax,(%esp)
 a05:	e8 96 fc ff ff       	call   6a0 <sbrk>
  if(p == (char*) -1)
 a0a:	83 f8 ff             	cmp    $0xffffffff,%eax
 a0d:	74 18                	je     a27 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a0f:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 a12:	83 c0 08             	add    $0x8,%eax
 a15:	89 04 24             	mov    %eax,(%esp)
 a18:	e8 f3 fe ff ff       	call   910 <free>
  return freep;
 a1d:	8b 15 e0 0a 00 00    	mov    0xae0,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 a23:	85 d2                	test   %edx,%edx
 a25:	75 a6                	jne    9cd <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a27:	31 c0                	xor    %eax,%eax
 a29:	eb c3                	jmp    9ee <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 a2b:	be 00 10 00 00       	mov    $0x1000,%esi
 a30:	b8 00 80 00 00       	mov    $0x8000,%eax
 a35:	eb cb                	jmp    a02 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a37:	8b 01                	mov    (%ecx),%eax
 a39:	89 02                	mov    %eax,(%edx)
 a3b:	eb a8                	jmp    9e5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 a3d:	ba d8 0a 00 00       	mov    $0xad8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a42:	c7 05 e0 0a 00 00 d8 	movl   $0xad8,0xae0
 a49:	0a 00 00 
 a4c:	c7 05 d8 0a 00 00 d8 	movl   $0xad8,0xad8
 a53:	0a 00 00 
    base.s.size = 0;
 a56:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 a5d:	00 00 00 
 a60:	e9 4e ff ff ff       	jmp    9b3 <malloc+0x23>
