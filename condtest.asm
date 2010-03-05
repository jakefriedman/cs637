
_condtest:     file format elf32-i386

Disassembly of section .text:

00000000 <cond_init>:
void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
   0:	a1 34 0d 00 00       	mov    0xd34,%eax

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
  15:	c7 05 34 0d 00 00 02 	movl   $0x2,0xd34
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
  28:	a3 34 0d 00 00       	mov    %eax,0xd34
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
  30:	c7 05 34 0d 00 00 01 	movl   $0x1,0xd34
  37:	00 00 00 
}	
  3a:	c3                   	ret    
  3b:	90                   	nop    
  3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000040 <put>:
    printf(2, "Child %d exits.\n", pid);
    mutex_unlock(&print);
    exit();
}
 
void put(int value) {
  40:	55                   	push   %ebp
    buffer[fill] = value;    // line F1
  41:	a1 20 0d 00 00       	mov    0xd20,%eax
    printf(2, "Child %d exits.\n", pid);
    mutex_unlock(&print);
    exit();
}
 
void put(int value) {
  46:	89 e5                	mov    %esp,%ebp
    buffer[fill] = value;    // line F1
  48:	8b 55 08             	mov    0x8(%ebp),%edx
    printf(2, "Child %d exits.\n", pid);
    mutex_unlock(&print);
    exit();
}
 
void put(int value) {
  4b:	53                   	push   %ebx
    buffer[fill] = value;    // line F1
    fill = (fill + 1) % MAX; // line F2
  4c:	8d 58 01             	lea    0x1(%eax),%ebx
  4f:	89 d9                	mov    %ebx,%ecx
    mutex_unlock(&print);
    exit();
}
 
void put(int value) {
    buffer[fill] = value;    // line F1
  51:	89 14 85 80 0d 00 00 	mov    %edx,0xd80(,%eax,4)
    fill = (fill + 1) % MAX; // line F2
  58:	89 d8                	mov    %ebx,%eax
  5a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  5f:	f7 ea                	imul   %edx
    numfilled++;
  61:	a1 28 0d 00 00       	mov    0xd28,%eax
    exit();
}
 
void put(int value) {
    buffer[fill] = value;    // line F1
    fill = (fill + 1) % MAX; // line F2
  66:	c1 f9 1f             	sar    $0x1f,%ecx
  69:	c1 fa 02             	sar    $0x2,%edx
    numfilled++;
  6c:	83 c0 01             	add    $0x1,%eax
    exit();
}
 
void put(int value) {
    buffer[fill] = value;    // line F1
    fill = (fill + 1) % MAX; // line F2
  6f:	29 ca                	sub    %ecx,%edx
  71:	8d 14 92             	lea    (%edx,%edx,4),%edx
  74:	01 d2                	add    %edx,%edx
  76:	29 d3                	sub    %edx,%ebx
  78:	89 1d 20 0d 00 00    	mov    %ebx,0xd20
    numfilled++;
    return;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
}
 
void put(int value) {
    buffer[fill] = value;    // line F1
    fill = (fill + 1) % MAX; // line F2
    numfilled++;
  80:	a3 28 0d 00 00       	mov    %eax,0xd28
    return;
}
  85:	c3                   	ret    
  86:	8d 76 00             	lea    0x0(%esi),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000090 <get>:
 
int get() {
  90:	55                   	push   %ebp
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  91:	ba 67 66 66 66       	mov    $0x66666667,%edx
    fill = (fill + 1) % MAX; // line F2
    numfilled++;
    return;
}
 
int get() {
  96:	89 e5                	mov    %esp,%ebp
  98:	83 ec 08             	sub    $0x8,%esp
    int tmp = buffer[use];
  9b:	8b 0d 24 0d 00 00    	mov    0xd24,%ecx
    fill = (fill + 1) % MAX; // line F2
    numfilled++;
    return;
}
 
int get() {
  a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  a5:	89 1c 24             	mov    %ebx,(%esp)
    int tmp = buffer[use];
  a8:	8b 34 8d 80 0d 00 00 	mov    0xd80(,%ecx,4),%esi
    use = (use + 1) % MAX;
  af:	83 c1 01             	add    $0x1,%ecx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	89 cb                	mov    %ecx,%ebx
  b6:	f7 ea                	imul   %edx
  b8:	c1 fb 1f             	sar    $0x1f,%ebx
    numfilled--;
    return tmp;
}
  bb:	89 f0                	mov    %esi,%eax
  bd:	8b 74 24 04          	mov    0x4(%esp),%esi
    return;
}
 
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  c1:	c1 fa 02             	sar    $0x2,%edx
  c4:	29 da                	sub    %ebx,%edx
    numfilled--;
    return tmp;
}
  c6:	8b 1c 24             	mov    (%esp),%ebx
    return;
}
 
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
  cc:	01 d2                	add    %edx,%edx
  ce:	29 d1                	sub    %edx,%ecx
    numfilled--;
  d0:	8b 15 28 0d 00 00    	mov    0xd28,%edx
    return;
}
 
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
  d6:	89 0d 24 0d 00 00    	mov    %ecx,0xd24
    numfilled--;
  dc:	83 ea 01             	sub    $0x1,%edx
  df:	89 15 28 0d 00 00    	mov    %edx,0xd28
    return tmp;
}
  e5:	89 ec                	mov    %ebp,%esp
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000000f0 <thread_wait>:

void thread_wait(){
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	83 ec 08             	sub    $0x8,%esp
	
	int pid;
	while((pid = wait_thread()) != -1);
  f6:	e8 8d 07 00 00       	call   888 <wait_thread>
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
 11c:	e9 77 07 00 00       	jmp    898 <wake_cond>
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
 13c:	e9 4f 07 00 00       	jmp    890 <sleep_cond>
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
void mutex_unlock(struct mutex_t* lock) {
  xchng(&lock->lock, 0);
}


int thread_create(void*(*start_routine)(void *), void *arg){
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 18             	sub    $0x18,%esp
	
	//Allocate stack using process heap
	int stack = malloc(1024);
 156:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 15d:	e8 ee 09 00 00       	call   b50 <malloc>

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
 162:	8b 55 0c             	mov    0xc(%ebp),%edx
 165:	89 54 24 08          	mov    %edx,0x8(%esp)
 169:	8b 55 08             	mov    0x8(%ebp),%edx
 16c:	89 04 24             	mov    %eax,(%esp)
 16f:	89 54 24 04          	mov    %edx,0x4(%esp)
 173:	e8 08 07 00 00       	call   880 <fork_thread>
		
	return pid;

}
 178:	c9                   	leave  
 179:	c3                   	ret    
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <mutex_unlock>:

void mutex_lock(struct mutex_t* lock) {
  while(xchng(&lock->lock, 1) == 1);
}

void mutex_unlock(struct mutex_t* lock) {
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 08             	sub    $0x8,%esp
  xchng(&lock->lock, 0);
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 190:	00 
 191:	89 04 24             	mov    %eax,(%esp)
 194:	e8 07 07 00 00       	call   8a0 <xchng>
}
 199:	c9                   	leave  
 19a:	c3                   	ret    
 19b:	90                   	nop    
 19c:	8d 74 26 00          	lea    0x0(%esi),%esi

000001a0 <mutex_lock>:

void mutex_init(struct mutex_t* lock) {
  xchng(&lock->lock, 0); //0 is unused
}

void mutex_lock(struct mutex_t* lock) {
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	83 ec 14             	sub    $0x14,%esp
 1a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while(xchng(&lock->lock, 1) == 1);
 1b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 1b7:	00 
 1b8:	89 1c 24             	mov    %ebx,(%esp)
 1bb:	e8 e0 06 00 00       	call   8a0 <xchng>
 1c0:	83 e8 01             	sub    $0x1,%eax
 1c3:	74 eb                	je     1b0 <mutex_lock+0x10>
}
 1c5:	83 c4 14             	add    $0x14,%esp
 1c8:	5b                   	pop    %ebx
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop    
 1cc:	8d 74 26 00          	lea    0x0(%esi),%esi

000001d0 <consumer>:
        mutex_unlock(&mutex);          // p6
    }
    done = 1;
    exit();
}
void* consumer(void *arg) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
 1d6:	83 ec 1c             	sub    $0x1c,%esp
    int pid = getpid();
 1d9:	e8 7a 06 00 00       	call   858 <getpid>
 1de:	89 c6                	mov    %eax,%esi
    int i;
    for (i = 0; i < loops; i++) {
 1e0:	a1 30 0d 00 00       	mov    0xd30,%eax
 1e5:	85 c0                	test   %eax,%eax
 1e7:	0f 8e f8 00 00 00    	jle    2e5 <consumer+0x115>
 1ed:	31 ff                	xor    %edi,%edi
        mutex_lock(&mutex);
 1ef:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 1f6:	e8 a5 ff ff ff       	call   1a0 <mutex_lock>
 1fb:	90                   	nop    
 1fc:	8d 74 26 00          	lea    0x0(%esi),%esi
        while (numfilled == 0){
 200:	a1 28 0d 00 00       	mov    0xd28,%eax
 205:	85 c0                	test   %eax,%eax
 207:	75 79                	jne    282 <consumer+0xb2>
        		if(done == 1){
 209:	83 3d 2c 0d 00 00 01 	cmpl   $0x1,0xd2c
 210:	0f 85 0b 01 00 00    	jne    321 <consumer+0x151>
        			int j;
        			for(j = 0; j < numconsumers; j++){
 216:	a1 64 0d 00 00       	mov    0xd64,%eax
 21b:	85 c0                	test   %eax,%eax
 21d:	7e 25                	jle    244 <consumer+0x74>
 21f:	31 db                	xor    %ebx,%ebx
        				cond_signal(&full);
 221:	c7 04 24 68 0d 00 00 	movl   $0xd68,(%esp)
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0){
        		if(done == 1){
        			int j;
        			for(j = 0; j < numconsumers; j++){
 228:	83 c3 01             	add    $0x1,%ebx
        				cond_signal(&full);
 22b:	e8 e0 fe ff ff       	call   110 <cond_signal>
        				mutex_unlock(&mutex);
 230:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 237:	e8 44 ff ff ff       	call   180 <mutex_unlock>
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0){
        		if(done == 1){
        			int j;
        			for(j = 0; j < numconsumers; j++){
 23c:	39 1d 64 0d 00 00    	cmp    %ebx,0xd64
 242:	7f dd                	jg     221 <consumer+0x51>
        				cond_signal(&full);
        				mutex_unlock(&mutex);
        			}
        			mutex_lock(&print);
 244:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 24b:	e8 50 ff ff ff       	call   1a0 <mutex_lock>
        			printf(2, "Child %d exits.\n", pid);
 250:	89 74 24 08          	mov    %esi,0x8(%esp)
 254:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
 25b:	00 
 25c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 263:	e8 f8 06 00 00       	call   960 <printf>
        			mutex_unlock(&print);
 268:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 26f:	e8 0c ff ff ff       	call   180 <mutex_unlock>
        			exit();
 274:	e8 5f 05 00 00       	call   7d8 <exit>
void* consumer(void *arg) {
    int pid = getpid();
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0){
 279:	a1 28 0d 00 00       	mov    0xd28,%eax
 27e:	85 c0                	test   %eax,%eax
 280:	74 87                	je     209 <consumer+0x39>
        			printf(2, "Child %d going to sleep.\n", pid);
        			mutex_unlock(&print);
            	cond_wait(&full, &mutex);
            }
        }
        int tmp = get();
 282:	e8 09 fe ff ff       	call   90 <get>
    exit();
}
void* consumer(void *arg) {
    int pid = getpid();
    int i;
    for (i = 0; i < loops; i++) {
 287:	83 c7 01             	add    $0x1,%edi
        			mutex_unlock(&print);
            	cond_wait(&full, &mutex);
            }
        }
        int tmp = get();
        mutex_lock(&print);
 28a:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
        			printf(2, "Child %d going to sleep.\n", pid);
        			mutex_unlock(&print);
            	cond_wait(&full, &mutex);
            }
        }
        int tmp = get();
 291:	89 c3                	mov    %eax,%ebx
        mutex_lock(&print);
 293:	e8 08 ff ff ff       	call   1a0 <mutex_lock>
        printf(2, "child %d got %d\n", pid, tmp);
 298:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 29c:	89 74 24 08          	mov    %esi,0x8(%esp)
 2a0:	c7 44 24 04 53 0c 00 	movl   $0xc53,0x4(%esp)
 2a7:	00 
 2a8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2af:	e8 ac 06 00 00       	call   960 <printf>
        mutex_unlock(&print);
 2b4:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 2bb:	e8 c0 fe ff ff       	call   180 <mutex_unlock>
        cond_signal(&empty);
 2c0:	c7 04 24 a8 0d 00 00 	movl   $0xda8,(%esp)
 2c7:	e8 44 fe ff ff       	call   110 <cond_signal>
        mutex_unlock(&mutex);
 2cc:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 2d3:	e8 a8 fe ff ff       	call   180 <mutex_unlock>
    exit();
}
void* consumer(void *arg) {
    int pid = getpid();
    int i;
    for (i = 0; i < loops; i++) {
 2d8:	a1 30 0d 00 00       	mov    0xd30,%eax
 2dd:	39 f8                	cmp    %edi,%eax
 2df:	0f 8f 0a ff ff ff    	jg     1ef <consumer+0x1f>
        printf(2, "child %d got %d\n", pid, tmp);
        mutex_unlock(&print);
        cond_signal(&empty);
        mutex_unlock(&mutex);
    }
    mutex_lock(&print);
 2e5:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 2ec:	e8 af fe ff ff       	call   1a0 <mutex_lock>
    printf(2, "Child %d exits.\n", pid);
 2f1:	89 74 24 08          	mov    %esi,0x8(%esp)
 2f5:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
 2fc:	00 
 2fd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 304:	e8 57 06 00 00       	call   960 <printf>
    mutex_unlock(&print);
 309:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 310:	e8 6b fe ff ff       	call   180 <mutex_unlock>
    exit();
}
 315:	83 c4 1c             	add    $0x1c,%esp
 318:	5b                   	pop    %ebx
 319:	5e                   	pop    %esi
 31a:	5f                   	pop    %edi
 31b:	5d                   	pop    %ebp
        mutex_unlock(&mutex);
    }
    mutex_lock(&print);
    printf(2, "Child %d exits.\n", pid);
    mutex_unlock(&print);
    exit();
 31c:	e9 b7 04 00 00       	jmp    7d8 <exit>
        			mutex_lock(&print);
        			printf(2, "Child %d exits.\n", pid);
        			mutex_unlock(&print);
        			exit();
        		}else{
        		  mutex_lock(&print);
 321:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 328:	e8 73 fe ff ff       	call   1a0 <mutex_lock>
        			printf(2, "Child %d going to sleep.\n", pid);
 32d:	89 74 24 08          	mov    %esi,0x8(%esp)
 331:	c7 44 24 04 39 0c 00 	movl   $0xc39,0x4(%esp)
 338:	00 
 339:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 340:	e8 1b 06 00 00       	call   960 <printf>
        			mutex_unlock(&print);
 345:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 34c:	e8 2f fe ff ff       	call   180 <mutex_unlock>
            	cond_wait(&full, &mutex);
 351:	c7 44 24 04 6c 0d 00 	movl   $0xd6c,0x4(%esp)
 358:	00 
 359:	c7 04 24 68 0d 00 00 	movl   $0xd68,(%esp)
 360:	e8 cb fd ff ff       	call   130 <cond_wait>
 365:	e9 96 fe ff ff       	jmp    200 <consumer+0x30>
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <producer>:
 
	exit();
 
}
 
void* producer(void *arg) {
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; i < loops; i++) {
 377:	a1 30 0d 00 00       	mov    0xd30,%eax
 37c:	85 c0                	test   %eax,%eax
 37e:	0f 8e c6 00 00 00    	jle    44a <producer+0xda>
 384:	31 db                	xor    %ebx,%ebx
        mutex_lock(&mutex);            // p1
 386:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 38d:	e8 0e fe ff ff       	call   1a0 <mutex_lock>
        while (numfilled == MAX){       // p2
 392:	a1 28 0d 00 00       	mov    0xd28,%eax
 397:	83 f8 0a             	cmp    $0xa,%eax
 39a:	75 4e                	jne    3ea <producer+0x7a>
 39c:	8d 74 26 00          	lea    0x0(%esi),%esi
        		mutex_lock(&print);
 3a0:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 3a7:	e8 f4 fd ff ff       	call   1a0 <mutex_lock>
        		printf(2, "Producer going to sleep.\n");
 3ac:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
 3b3:	00 
 3b4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 3bb:	e8 a0 05 00 00       	call   960 <printf>
        		mutex_unlock(&print);
 3c0:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 3c7:	e8 b4 fd ff ff       	call   180 <mutex_unlock>
            cond_wait(&empty, &mutex); // p3
 3cc:	c7 44 24 04 6c 0d 00 	movl   $0xd6c,0x4(%esp)
 3d3:	00 
 3d4:	c7 04 24 a8 0d 00 00 	movl   $0xda8,(%esp)
 3db:	e8 50 fd ff ff       	call   130 <cond_wait>
 
void* producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);            // p1
        while (numfilled == MAX){       // p2
 3e0:	a1 28 0d 00 00       	mov    0xd28,%eax
 3e5:	83 f8 0a             	cmp    $0xa,%eax
 3e8:	74 b6                	je     3a0 <producer+0x30>
        		mutex_lock(&print);
        		printf(2, "Producer going to sleep.\n");
        		mutex_unlock(&print);
            cond_wait(&empty, &mutex); // p3
        }
        put(i);                        // p4
 3ea:	89 1c 24             	mov    %ebx,(%esp)
 3ed:	e8 4e fc ff ff       	call   40 <put>
        mutex_lock(&print);
 3f2:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 3f9:	e8 a2 fd ff ff       	call   1a0 <mutex_lock>
        printf(2, "put %d\n", i);
 3fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 
}
 
void* producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
 402:	83 c3 01             	add    $0x1,%ebx
        		mutex_unlock(&print);
            cond_wait(&empty, &mutex); // p3
        }
        put(i);                        // p4
        mutex_lock(&print);
        printf(2, "put %d\n", i);
 405:	c7 44 24 04 7e 0c 00 	movl   $0xc7e,0x4(%esp)
 40c:	00 
 40d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 414:	e8 47 05 00 00       	call   960 <printf>
        mutex_unlock(&print);
 419:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 420:	e8 5b fd ff ff       	call   180 <mutex_unlock>
        cond_signal(&full);            // p5
 425:	c7 04 24 68 0d 00 00 	movl   $0xd68,(%esp)
 42c:	e8 df fc ff ff       	call   110 <cond_signal>
        mutex_unlock(&mutex);          // p6
 431:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 438:	e8 43 fd ff ff       	call   180 <mutex_unlock>
 
}
 
void* producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
 43d:	a1 30 0d 00 00       	mov    0xd30,%eax
 442:	39 d8                	cmp    %ebx,%eax
 444:	0f 8f 3c ff ff ff    	jg     386 <producer+0x16>
        printf(2, "put %d\n", i);
        mutex_unlock(&print);
        cond_signal(&full);            // p5
        mutex_unlock(&mutex);          // p6
    }
    done = 1;
 44a:	c7 05 2c 0d 00 00 01 	movl   $0x1,0xd2c
 451:	00 00 00 
    exit();
}
 454:	83 c4 14             	add    $0x14,%esp
 457:	5b                   	pop    %ebx
 458:	5d                   	pop    %ebp
        mutex_unlock(&print);
        cond_signal(&full);            // p5
        mutex_unlock(&mutex);          // p6
    }
    done = 1;
    exit();
 459:	e9 7a 03 00 00       	jmp    7d8 <exit>
 45e:	66 90                	xchg   %ax,%ax

00000460 <mutex_init>:
static unsigned int cond_count = 0;




void mutex_init(struct mutex_t* lock) {
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	83 ec 08             	sub    $0x8,%esp
  xchng(&lock->lock, 0); //0 is unused
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 470:	00 
 471:	89 04 24             	mov    %eax,(%esp)
 474:	e8 27 04 00 00       	call   8a0 <xchng>
}
 479:	c9                   	leave  
 47a:	c3                   	ret    
 47b:	90                   	nop    
 47c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000480 <main>:
/**
*		Creates a case in which two threads will be racing to write one variable.  Exected
*   x will not be equal to actual x for a large enough loop unless there are locks.
*/
int main(int argc, char *argv[])
{
 480:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 484:	83 e4 f0             	and    $0xfffffff0,%esp
 487:	ff 71 fc             	pushl  -0x4(%ecx)
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	56                   	push   %esi
 48e:	53                   	push   %ebx
 48f:	51                   	push   %ecx
 490:	83 ec 1c             	sub    $0x1c,%esp
 493:	8b 59 04             	mov    0x4(%ecx),%ebx
	//Create 2 new threads.
	if(argc != 3){
 496:	83 39 03             	cmpl   $0x3,(%ecx)
 499:	74 19                	je     4b4 <main+0x34>
		printf(2, "Usage: condtest <loop count> <num consumers>\n");
 49b:	c7 44 24 04 88 0c 00 	movl   $0xc88,0x4(%esp)
 4a2:	00 
 4a3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 4aa:	e8 b1 04 00 00       	call   960 <printf>
		exit();
 4af:	e8 24 03 00 00       	call   7d8 <exit>
	}
 
	int pid;
	loops = atoi(argv[1]);
 4b4:	8b 43 04             	mov    0x4(%ebx),%eax
 4b7:	89 04 24             	mov    %eax,(%esp)
 4ba:	e8 01 02 00 00       	call   6c0 <atoi>
 4bf:	a3 30 0d 00 00       	mov    %eax,0xd30
	numconsumers = atoi(argv[2]);
 4c4:	8b 43 08             	mov    0x8(%ebx),%eax
 4c7:	89 04 24             	mov    %eax,(%esp)
 4ca:	e8 f1 01 00 00       	call   6c0 <atoi>
 4cf:	a3 64 0d 00 00       	mov    %eax,0xd64
	//initialize locks and condition variables
	mutex_init(&mutex);
 4d4:	c7 04 24 6c 0d 00 00 	movl   $0xd6c,(%esp)
 4db:	e8 80 ff ff ff       	call   460 <mutex_init>
	cond_init(&empty);
 4e0:	c7 04 24 a8 0d 00 00 	movl   $0xda8,(%esp)
 4e7:	e8 14 fb ff ff       	call   0 <cond_init>
	cond_init(&full);
 4ec:	c7 04 24 68 0d 00 00 	movl   $0xd68,(%esp)
 4f3:	e8 08 fb ff ff       	call   0 <cond_init>
	//create one producer
	pid = thread_create(&producer, (void *)"A");	//Thread 1: Add 1 to x
 4f8:	c7 44 24 04 86 0c 00 	movl   $0xc86,0x4(%esp)
 4ff:	00 
 500:	c7 04 24 70 03 00 00 	movl   $0x370,(%esp)
 507:	e8 44 fc ff ff       	call   150 <thread_create>
	printf(2, "Parent created producer with pid %d.\n", pid);
 50c:	c7 44 24 04 b8 0c 00 	movl   $0xcb8,0x4(%esp)
 513:	00 
 514:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 51b:	89 44 24 08          	mov    %eax,0x8(%esp)
 51f:	e8 3c 04 00 00       	call   960 <printf>
	int i;
	//create x number of consumers
	for (i = 0; i < numconsumers; i++){
 524:	8b 15 64 0d 00 00    	mov    0xd64,%edx
 52a:	85 d2                	test   %edx,%edx
 52c:	7e 57                	jle    585 <main+0x105>
 52e:	31 f6                	xor    %esi,%esi
		pid = thread_create(&consumer, 0);
 530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 537:	00 
 538:	c7 04 24 d0 01 00 00 	movl   $0x1d0,(%esp)
 53f:	e8 0c fc ff ff       	call   150 <thread_create>
		mutex_lock(&print);
 544:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
	pid = thread_create(&producer, (void *)"A");	//Thread 1: Add 1 to x
	printf(2, "Parent created producer with pid %d.\n", pid);
	int i;
	//create x number of consumers
	for (i = 0; i < numconsumers; i++){
		pid = thread_create(&consumer, 0);
 54b:	89 c3                	mov    %eax,%ebx
		mutex_lock(&print);
 54d:	e8 4e fc ff ff       	call   1a0 <mutex_lock>
		printf(2, "Created consumer %d with pid %d.\n", i, pid);
 552:	89 74 24 08          	mov    %esi,0x8(%esp)
	//create one producer
	pid = thread_create(&producer, (void *)"A");	//Thread 1: Add 1 to x
	printf(2, "Parent created producer with pid %d.\n", pid);
	int i;
	//create x number of consumers
	for (i = 0; i < numconsumers; i++){
 556:	83 c6 01             	add    $0x1,%esi
		pid = thread_create(&consumer, 0);
		mutex_lock(&print);
		printf(2, "Created consumer %d with pid %d.\n", i, pid);
 559:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 55d:	c7 44 24 04 e0 0c 00 	movl   $0xce0,0x4(%esp)
 564:	00 
 565:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 56c:	e8 ef 03 00 00       	call   960 <printf>
		mutex_unlock(&print);
 571:	c7 04 24 60 0d 00 00 	movl   $0xd60,(%esp)
 578:	e8 03 fc ff ff       	call   180 <mutex_unlock>
	//create one producer
	pid = thread_create(&producer, (void *)"A");	//Thread 1: Add 1 to x
	printf(2, "Parent created producer with pid %d.\n", pid);
	int i;
	//create x number of consumers
	for (i = 0; i < numconsumers; i++){
 57d:	39 35 64 0d 00 00    	cmp    %esi,0xd64
 583:	7f ab                	jg     530 <main+0xb0>
		mutex_lock(&print);
		printf(2, "Created consumer %d with pid %d.\n", i, pid);
		mutex_unlock(&print);
	}
	//wait for children
	for(i = 0; i < numconsumers+1; i++){
 585:	a1 64 0d 00 00       	mov    0xd64,%eax
 58a:	83 c0 01             	add    $0x1,%eax
 58d:	85 c0                	test   %eax,%eax
 58f:	7e 16                	jle    5a7 <main+0x127>
 591:	31 db                	xor    %ebx,%ebx
		thread_wait();
 593:	e8 58 fb ff ff       	call   f0 <thread_wait>
		mutex_lock(&print);
		printf(2, "Created consumer %d with pid %d.\n", i, pid);
		mutex_unlock(&print);
	}
	//wait for children
	for(i = 0; i < numconsumers+1; i++){
 598:	a1 64 0d 00 00       	mov    0xd64,%eax
 59d:	83 c3 01             	add    $0x1,%ebx
 5a0:	83 c0 01             	add    $0x1,%eax
 5a3:	39 d8                	cmp    %ebx,%eax
 5a5:	7f ec                	jg     593 <main+0x113>
		thread_wait();
	}
 
 
	exit();
 5a7:	e8 2c 02 00 00       	call   7d8 <exit>
 
}
 5ac:	83 c4 1c             	add    $0x1c,%esp
 5af:	59                   	pop    %ecx
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5d                   	pop    %ebp
 5b3:	8d 61 fc             	lea    -0x4(%ecx),%esp
 5b6:	c3                   	ret    
 5b7:	90                   	nop    
 5b8:	90                   	nop    
 5b9:	90                   	nop    
 5ba:	90                   	nop    
 5bb:	90                   	nop    
 5bc:	90                   	nop    
 5bd:	90                   	nop    
 5be:	90                   	nop    
 5bf:	90                   	nop    

000005c0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	53                   	push   %ebx
 5c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 5ca:	89 da                	mov    %ebx,%edx
 5cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5d0:	0f b6 01             	movzbl (%ecx),%eax
 5d3:	83 c1 01             	add    $0x1,%ecx
 5d6:	88 02                	mov    %al,(%edx)
 5d8:	83 c2 01             	add    $0x1,%edx
 5db:	84 c0                	test   %al,%al
 5dd:	75 f1                	jne    5d0 <strcpy+0x10>
    ;
  return os;
}
 5df:	89 d8                	mov    %ebx,%eax
 5e1:	5b                   	pop    %ebx
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000005f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5f6:	53                   	push   %ebx
 5f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 5fa:	0f b6 01             	movzbl (%ecx),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	74 24                	je     625 <strcmp+0x35>
 601:	0f b6 13             	movzbl (%ebx),%edx
 604:	38 d0                	cmp    %dl,%al
 606:	74 12                	je     61a <strcmp+0x2a>
 608:	eb 1e                	jmp    628 <strcmp+0x38>
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 610:	0f b6 13             	movzbl (%ebx),%edx
 613:	83 c1 01             	add    $0x1,%ecx
 616:	38 d0                	cmp    %dl,%al
 618:	75 0e                	jne    628 <strcmp+0x38>
 61a:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 61e:	83 c3 01             	add    $0x1,%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 621:	84 c0                	test   %al,%al
 623:	75 eb                	jne    610 <strcmp+0x20>
 625:	0f b6 13             	movzbl (%ebx),%edx
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 628:	5b                   	pop    %ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 629:	0f b6 c0             	movzbl %al,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 62c:	5d                   	pop    %ebp
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 62d:	0f b6 d2             	movzbl %dl,%edx
 630:	29 d0                	sub    %edx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 632:	c3                   	ret    
 633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000640 <strlen>:

uint
strlen(char *s)
{
 640:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 641:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 643:	89 e5                	mov    %esp,%ebp
 645:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 648:	80 39 00             	cmpb   $0x0,(%ecx)
 64b:	74 0e                	je     65b <strlen+0x1b>
 64d:	31 d2                	xor    %edx,%edx
 64f:	90                   	nop    
 650:	83 c2 01             	add    $0x1,%edx
 653:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
 657:	89 d0                	mov    %edx,%eax
 659:	75 f5                	jne    650 <strlen+0x10>
    ;
  return n;
}
 65b:	5d                   	pop    %ebp
 65c:	c3                   	ret    
 65d:	8d 76 00             	lea    0x0(%esi),%esi

00000660 <memset>:

void*
memset(void *dst, int c, uint n)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	8b 45 10             	mov    0x10(%ebp),%eax
 666:	53                   	push   %ebx
 667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;
  
  d = dst;
  while(n-- > 0)
 66a:	85 c0                	test   %eax,%eax
 66c:	74 10                	je     67e <memset+0x1e>
 66e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
 672:	31 d2                	xor    %edx,%edx
    *d++ = c;
 674:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
 677:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 67a:	39 c2                	cmp    %eax,%edx
 67c:	75 f6                	jne    674 <memset+0x14>
    *d++ = c;
  return dst;
}
 67e:	89 d8                	mov    %ebx,%eax
 680:	5b                   	pop    %ebx
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
 683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 689:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000690 <strchr>:

char*
strchr(const char *s, char c)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 69a:	0f b6 10             	movzbl (%eax),%edx
 69d:	84 d2                	test   %dl,%dl
 69f:	75 0c                	jne    6ad <strchr+0x1d>
 6a1:	eb 11                	jmp    6b4 <strchr+0x24>
 6a3:	83 c0 01             	add    $0x1,%eax
 6a6:	0f b6 10             	movzbl (%eax),%edx
 6a9:	84 d2                	test   %dl,%dl
 6ab:	74 07                	je     6b4 <strchr+0x24>
    if(*s == c)
 6ad:	38 ca                	cmp    %cl,%dl
 6af:	90                   	nop    
 6b0:	75 f1                	jne    6a3 <strchr+0x13>
      return (char*) s;
  return 0;
}
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
 6b4:	5d                   	pop    %ebp
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 6b5:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 6b7:	c3                   	ret    
 6b8:	90                   	nop    
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

000006c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6c6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c7:	31 db                	xor    %ebx,%ebx
 6c9:	0f b6 11             	movzbl (%ecx),%edx
 6cc:	8d 42 d0             	lea    -0x30(%edx),%eax
 6cf:	3c 09                	cmp    $0x9,%al
 6d1:	77 18                	ja     6eb <atoi+0x2b>
    n = n*10 + *s++ - '0';
 6d3:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 6d6:	0f be d2             	movsbl %dl,%edx
 6d9:	8d 5c 42 d0          	lea    -0x30(%edx,%eax,2),%ebx
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6dd:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
 6e1:	83 c1 01             	add    $0x1,%ecx
 6e4:	8d 42 d0             	lea    -0x30(%edx),%eax
 6e7:	3c 09                	cmp    $0x9,%al
 6e9:	76 e8                	jbe    6d3 <atoi+0x13>
    n = n*10 + *s++ - '0';
  return n;
}
 6eb:	89 d8                	mov    %ebx,%eax
 6ed:	5b                   	pop    %ebx
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    

000006f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6f6:	56                   	push   %esi
 6f7:	8b 75 08             	mov    0x8(%ebp),%esi
 6fa:	53                   	push   %ebx
 6fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6fe:	85 c9                	test   %ecx,%ecx
 700:	7e 10                	jle    712 <memmove+0x22>
 702:	31 d2                	xor    %edx,%edx
    *dst++ = *src++;
 704:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
 708:	88 04 32             	mov    %al,(%edx,%esi,1)
 70b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 70e:	39 ca                	cmp    %ecx,%edx
 710:	75 f2                	jne    704 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
}
 712:	89 f0                	mov    %esi,%eax
 714:	5b                   	pop    %ebx
 715:	5e                   	pop    %esi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	90                   	nop    
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00000720 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 726:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 729:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 72c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 72f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 734:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 73b:	00 
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 d4 00 00 00       	call   818 <open>
  if(fd < 0)
 744:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 746:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 748:	78 19                	js     763 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 74a:	8b 45 0c             	mov    0xc(%ebp),%eax
 74d:	89 1c 24             	mov    %ebx,(%esp)
 750:	89 44 24 04          	mov    %eax,0x4(%esp)
 754:	e8 d7 00 00 00       	call   830 <fstat>
  close(fd);
 759:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 75c:	89 c6                	mov    %eax,%esi
  close(fd);
 75e:	e8 9d 00 00 00       	call   800 <close>
  return r;
}
 763:	89 f0                	mov    %esi,%eax
 765:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 768:	8b 75 fc             	mov    -0x4(%ebp),%esi
 76b:	89 ec                	mov    %ebp,%esp
 76d:	5d                   	pop    %ebp
 76e:	c3                   	ret    
 76f:	90                   	nop    

00000770 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	31 f6                	xor    %esi,%esi
 777:	53                   	push   %ebx
 778:	83 ec 1c             	sub    $0x1c,%esp
 77b:	8b 7d 08             	mov    0x8(%ebp),%edi
 77e:	eb 06                	jmp    786 <gets+0x16>
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 780:	3c 0d                	cmp    $0xd,%al
 782:	74 39                	je     7bd <gets+0x4d>
 784:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 786:	8d 5e 01             	lea    0x1(%esi),%ebx
 789:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 78c:	7d 31                	jge    7bf <gets+0x4f>
    cc = read(0, &c, 1);
 78e:	8d 45 f3             	lea    -0xd(%ebp),%eax
 791:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 798:	00 
 799:	89 44 24 04          	mov    %eax,0x4(%esp)
 79d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7a4:	e8 47 00 00 00       	call   7f0 <read>
    if(cc < 1)
 7a9:	85 c0                	test   %eax,%eax
 7ab:	7e 12                	jle    7bf <gets+0x4f>
      break;
    buf[i++] = c;
 7ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 7b1:	88 44 3b ff          	mov    %al,-0x1(%ebx,%edi,1)
    if(c == '\n' || c == '\r')
 7b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
 7b9:	3c 0a                	cmp    $0xa,%al
 7bb:	75 c3                	jne    780 <gets+0x10>
 7bd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 7bf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 7c3:	89 f8                	mov    %edi,%eax
 7c5:	83 c4 1c             	add    $0x1c,%esp
 7c8:	5b                   	pop    %ebx
 7c9:	5e                   	pop    %esi
 7ca:	5f                   	pop    %edi
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret    
 7cd:	90                   	nop    
 7ce:	90                   	nop    
 7cf:	90                   	nop    

000007d0 <fork>:
 7d0:	b8 01 00 00 00       	mov    $0x1,%eax
 7d5:	cd 30                	int    $0x30
 7d7:	c3                   	ret    

000007d8 <exit>:
 7d8:	b8 02 00 00 00       	mov    $0x2,%eax
 7dd:	cd 30                	int    $0x30
 7df:	c3                   	ret    

000007e0 <wait>:
 7e0:	b8 03 00 00 00       	mov    $0x3,%eax
 7e5:	cd 30                	int    $0x30
 7e7:	c3                   	ret    

000007e8 <pipe>:
 7e8:	b8 04 00 00 00       	mov    $0x4,%eax
 7ed:	cd 30                	int    $0x30
 7ef:	c3                   	ret    

000007f0 <read>:
 7f0:	b8 06 00 00 00       	mov    $0x6,%eax
 7f5:	cd 30                	int    $0x30
 7f7:	c3                   	ret    

000007f8 <write>:
 7f8:	b8 05 00 00 00       	mov    $0x5,%eax
 7fd:	cd 30                	int    $0x30
 7ff:	c3                   	ret    

00000800 <close>:
 800:	b8 07 00 00 00       	mov    $0x7,%eax
 805:	cd 30                	int    $0x30
 807:	c3                   	ret    

00000808 <kill>:
 808:	b8 08 00 00 00       	mov    $0x8,%eax
 80d:	cd 30                	int    $0x30
 80f:	c3                   	ret    

00000810 <exec>:
 810:	b8 09 00 00 00       	mov    $0x9,%eax
 815:	cd 30                	int    $0x30
 817:	c3                   	ret    

00000818 <open>:
 818:	b8 0a 00 00 00       	mov    $0xa,%eax
 81d:	cd 30                	int    $0x30
 81f:	c3                   	ret    

00000820 <mknod>:
 820:	b8 0b 00 00 00       	mov    $0xb,%eax
 825:	cd 30                	int    $0x30
 827:	c3                   	ret    

00000828 <unlink>:
 828:	b8 0c 00 00 00       	mov    $0xc,%eax
 82d:	cd 30                	int    $0x30
 82f:	c3                   	ret    

00000830 <fstat>:
 830:	b8 0d 00 00 00       	mov    $0xd,%eax
 835:	cd 30                	int    $0x30
 837:	c3                   	ret    

00000838 <link>:
 838:	b8 0e 00 00 00       	mov    $0xe,%eax
 83d:	cd 30                	int    $0x30
 83f:	c3                   	ret    

00000840 <mkdir>:
 840:	b8 0f 00 00 00       	mov    $0xf,%eax
 845:	cd 30                	int    $0x30
 847:	c3                   	ret    

00000848 <chdir>:
 848:	b8 10 00 00 00       	mov    $0x10,%eax
 84d:	cd 30                	int    $0x30
 84f:	c3                   	ret    

00000850 <dup>:
 850:	b8 11 00 00 00       	mov    $0x11,%eax
 855:	cd 30                	int    $0x30
 857:	c3                   	ret    

00000858 <getpid>:
 858:	b8 12 00 00 00       	mov    $0x12,%eax
 85d:	cd 30                	int    $0x30
 85f:	c3                   	ret    

00000860 <sbrk>:
 860:	b8 13 00 00 00       	mov    $0x13,%eax
 865:	cd 30                	int    $0x30
 867:	c3                   	ret    

00000868 <sleep>:
 868:	b8 14 00 00 00       	mov    $0x14,%eax
 86d:	cd 30                	int    $0x30
 86f:	c3                   	ret    

00000870 <tick>:
 870:	b8 15 00 00 00       	mov    $0x15,%eax
 875:	cd 30                	int    $0x30
 877:	c3                   	ret    

00000878 <fork_tickets>:
 878:	b8 16 00 00 00       	mov    $0x16,%eax
 87d:	cd 30                	int    $0x30
 87f:	c3                   	ret    

00000880 <fork_thread>:
 880:	b8 17 00 00 00       	mov    $0x17,%eax
 885:	cd 30                	int    $0x30
 887:	c3                   	ret    

00000888 <wait_thread>:
 888:	b8 18 00 00 00       	mov    $0x18,%eax
 88d:	cd 30                	int    $0x30
 88f:	c3                   	ret    

00000890 <sleep_cond>:
 890:	b8 19 00 00 00       	mov    $0x19,%eax
 895:	cd 30                	int    $0x30
 897:	c3                   	ret    

00000898 <wake_cond>:
 898:	b8 1a 00 00 00       	mov    $0x1a,%eax
 89d:	cd 30                	int    $0x30
 89f:	c3                   	ret    

000008a0 <xchng>:
 8a0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8a5:	cd 30                	int    $0x30
 8a7:	c3                   	ret    
 8a8:	90                   	nop    
 8a9:	90                   	nop    
 8aa:	90                   	nop    
 8ab:	90                   	nop    
 8ac:	90                   	nop    
 8ad:	90                   	nop    
 8ae:	90                   	nop    
 8af:	90                   	nop    

000008b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	83 ec 18             	sub    $0x18,%esp
 8b6:	88 55 fc             	mov    %dl,-0x4(%ebp)
  write(fd, &c, 1);
 8b9:	8d 55 fc             	lea    -0x4(%ebp),%edx
 8bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8c3:	00 
 8c4:	89 54 24 04          	mov    %edx,0x4(%esp)
 8c8:	89 04 24             	mov    %eax,(%esp)
 8cb:	e8 28 ff ff ff       	call   7f8 <write>
}
 8d0:	c9                   	leave  
 8d1:	c3                   	ret    
 8d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 8d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000008e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	89 ce                	mov    %ecx,%esi
 8e7:	53                   	push   %ebx
 8e8:	83 ec 1c             	sub    $0x1c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 8ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8f1:	85 c9                	test   %ecx,%ecx
 8f3:	74 04                	je     8f9 <printint+0x19>
 8f5:	85 d2                	test   %edx,%edx
 8f7:	78 54                	js     94d <printint+0x6d>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8f9:	89 d0                	mov    %edx,%eax
 8fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 902:	31 db                	xor    %ebx,%ebx
 904:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 907:	31 d2                	xor    %edx,%edx
 909:	f7 f6                	div    %esi
 90b:	89 c1                	mov    %eax,%ecx
 90d:	0f b6 82 0b 0d 00 00 	movzbl 0xd0b(%edx),%eax
 914:	88 04 3b             	mov    %al,(%ebx,%edi,1)
 917:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
 91a:	85 c9                	test   %ecx,%ecx
 91c:	89 c8                	mov    %ecx,%eax
 91e:	75 e7                	jne    907 <printint+0x27>
  if(neg)
 920:	8b 45 e0             	mov    -0x20(%ebp),%eax
 923:	85 c0                	test   %eax,%eax
 925:	74 08                	je     92f <printint+0x4f>
    buf[i++] = '-';
 927:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
 92c:	83 c3 01             	add    $0x1,%ebx
 92f:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx

  while(--i >= 0)
    putc(fd, buf[i]);
 932:	0f be 53 ff          	movsbl -0x1(%ebx),%edx
 936:	83 eb 01             	sub    $0x1,%ebx
 939:	8b 45 dc             	mov    -0x24(%ebp),%eax
 93c:	e8 6f ff ff ff       	call   8b0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 941:	39 fb                	cmp    %edi,%ebx
 943:	75 ed                	jne    932 <printint+0x52>
    putc(fd, buf[i]);
}
 945:	83 c4 1c             	add    $0x1c,%esp
 948:	5b                   	pop    %ebx
 949:	5e                   	pop    %esi
 94a:	5f                   	pop    %edi
 94b:	5d                   	pop    %ebp
 94c:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 94d:	89 d0                	mov    %edx,%eax
 94f:	f7 d8                	neg    %eax
 951:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
 958:	eb a8                	jmp    902 <printint+0x22>
 95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000960 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	57                   	push   %edi
 964:	56                   	push   %esi
 965:	53                   	push   %ebx
 966:	83 ec 0c             	sub    $0xc,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 969:	8b 55 0c             	mov    0xc(%ebp),%edx
 96c:	0f b6 02             	movzbl (%edx),%eax
 96f:	84 c0                	test   %al,%al
 971:	0f 84 84 00 00 00    	je     9fb <printf+0x9b>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 977:	8d 4d 10             	lea    0x10(%ebp),%ecx
 97a:	89 d7                	mov    %edx,%edi
 97c:	31 f6                	xor    %esi,%esi
 97e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 981:	eb 18                	jmp    99b <printf+0x3b>
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 983:	83 fb 25             	cmp    $0x25,%ebx
 986:	75 7b                	jne    a03 <printf+0xa3>
 988:	66 be 25 00          	mov    $0x25,%si
 98c:	8d 74 26 00          	lea    0x0(%esi),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 990:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 994:	83 c7 01             	add    $0x1,%edi
 997:	84 c0                	test   %al,%al
 999:	74 60                	je     9fb <printf+0x9b>
    c = fmt[i] & 0xff;
    if(state == 0){
 99b:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 99d:	0f b6 d8             	movzbl %al,%ebx
    if(state == 0){
 9a0:	74 e1                	je     983 <printf+0x23>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 9a2:	83 fe 25             	cmp    $0x25,%esi
 9a5:	75 e9                	jne    990 <printf+0x30>
      if(c == 'd'){
 9a7:	83 fb 64             	cmp    $0x64,%ebx
 9aa:	0f 84 db 00 00 00    	je     a8b <printf+0x12b>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 9b0:	83 fb 78             	cmp    $0x78,%ebx
 9b3:	74 5b                	je     a10 <printf+0xb0>
 9b5:	83 fb 70             	cmp    $0x70,%ebx
 9b8:	74 56                	je     a10 <printf+0xb0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 9ba:	83 fb 73             	cmp    $0x73,%ebx
 9bd:	8d 76 00             	lea    0x0(%esi),%esi
 9c0:	74 72                	je     a34 <printf+0xd4>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9c2:	83 fb 63             	cmp    $0x63,%ebx
 9c5:	0f 84 a7 00 00 00    	je     a72 <printf+0x112>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 9cb:	83 fb 25             	cmp    $0x25,%ebx
 9ce:	66 90                	xchg   %ax,%ax
 9d0:	0f 84 da 00 00 00    	je     ab0 <printf+0x150>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	ba 25 00 00 00       	mov    $0x25,%edx
        putc(fd, c);
 9de:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e0:	e8 cb fe ff ff       	call   8b0 <putc>
        putc(fd, c);
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	0f be d3             	movsbl %bl,%edx
 9eb:	e8 c0 fe ff ff       	call   8b0 <putc>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9f0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 9f4:	83 c7 01             	add    $0x1,%edi
 9f7:	84 c0                	test   %al,%al
 9f9:	75 a0                	jne    99b <printf+0x3b>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9fb:	83 c4 0c             	add    $0xc,%esp
 9fe:	5b                   	pop    %ebx
 9ff:	5e                   	pop    %esi
 a00:	5f                   	pop    %edi
 a01:	5d                   	pop    %ebp
 a02:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 a03:	8b 45 08             	mov    0x8(%ebp),%eax
 a06:	0f be d3             	movsbl %bl,%edx
 a09:	e8 a2 fe ff ff       	call   8b0 <putc>
 a0e:	eb 80                	jmp    990 <printf+0x30>
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a13:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 a18:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 a1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 a21:	8b 10                	mov    (%eax),%edx
 a23:	8b 45 08             	mov    0x8(%ebp),%eax
 a26:	e8 b5 fe ff ff       	call   8e0 <printint>
        ap++;
 a2b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 a2f:	e9 5c ff ff ff       	jmp    990 <printf+0x30>
      } else if(c == 's'){
        s = (char*)*ap;
 a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
 a37:	8b 02                	mov    (%edx),%eax
        ap++;
 a39:	83 c2 04             	add    $0x4,%edx
 a3c:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
 a3f:	ba 04 0d 00 00       	mov    $0xd04,%edx
 a44:	85 c0                	test   %eax,%eax
 a46:	75 26                	jne    a6e <printf+0x10e>
          s = "(null)";
        while(*s != 0){
 a48:	0f b6 02             	movzbl (%edx),%eax
 a4b:	84 c0                	test   %al,%al
 a4d:	74 18                	je     a67 <printf+0x107>
 a4f:	89 d3                	mov    %edx,%ebx
          putc(fd, *s);
 a51:	0f be d0             	movsbl %al,%edx
 a54:	8b 45 08             	mov    0x8(%ebp),%eax
 a57:	e8 54 fe ff ff       	call   8b0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a5c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 a60:	83 c3 01             	add    $0x1,%ebx
 a63:	84 c0                	test   %al,%al
 a65:	75 ea                	jne    a51 <printf+0xf1>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 a67:	31 f6                	xor    %esi,%esi
 a69:	e9 22 ff ff ff       	jmp    990 <printf+0x30>
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 a6e:	89 c2                	mov    %eax,%edx
 a70:	eb d6                	jmp    a48 <printf+0xe8>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 a72:	8b 4d f0             	mov    -0x10(%ebp),%ecx
        ap++;
 a75:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 a77:	8b 45 08             	mov    0x8(%ebp),%eax
 a7a:	0f be 11             	movsbl (%ecx),%edx
 a7d:	e8 2e fe ff ff       	call   8b0 <putc>
        ap++;
 a82:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 a86:	e9 05 ff ff ff       	jmp    990 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 a93:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 a96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a9d:	8b 10                	mov    (%eax),%edx
 a9f:	8b 45 08             	mov    0x8(%ebp),%eax
 aa2:	e8 39 fe ff ff       	call   8e0 <printint>
        ap++;
 aa7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
 aab:	e9 e0 fe ff ff       	jmp    990 <printf+0x30>
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 ab0:	8b 45 08             	mov    0x8(%ebp),%eax
 ab3:	ba 25 00 00 00       	mov    $0x25,%edx
 ab8:	31 f6                	xor    %esi,%esi
 aba:	e8 f1 fd ff ff       	call   8b0 <putc>
 abf:	e9 cc fe ff ff       	jmp    990 <printf+0x30>
 ac4:	90                   	nop    
 ac5:	90                   	nop    
 ac6:	90                   	nop    
 ac7:	90                   	nop    
 ac8:	90                   	nop    
 ac9:	90                   	nop    
 aca:	90                   	nop    
 acb:	90                   	nop    
 acc:	90                   	nop    
 acd:	90                   	nop    
 ace:	90                   	nop    
 acf:	90                   	nop    

00000ad0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad1:	8b 0d 40 0d 00 00    	mov    0xd40,%ecx
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad7:	89 e5                	mov    %esp,%ebp
 ad9:	56                   	push   %esi
 ada:	53                   	push   %ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ade:	83 eb 08             	sub    $0x8,%ebx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae1:	39 d9                	cmp    %ebx,%ecx
 ae3:	73 18                	jae    afd <free+0x2d>
 ae5:	8b 11                	mov    (%ecx),%edx
 ae7:	39 d3                	cmp    %edx,%ebx
 ae9:	72 17                	jb     b02 <free+0x32>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aeb:	39 d1                	cmp    %edx,%ecx
 aed:	72 08                	jb     af7 <free+0x27>
 aef:	39 d9                	cmp    %ebx,%ecx
 af1:	72 0f                	jb     b02 <free+0x32>
 af3:	39 d3                	cmp    %edx,%ebx
 af5:	72 0b                	jb     b02 <free+0x32>
 af7:	89 d1                	mov    %edx,%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af9:	39 d9                	cmp    %ebx,%ecx
 afb:	72 e8                	jb     ae5 <free+0x15>
 afd:	8b 11                	mov    (%ecx),%edx
 aff:	90                   	nop    
 b00:	eb e9                	jmp    aeb <free+0x1b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b02:	8b 73 04             	mov    0x4(%ebx),%esi
 b05:	8d 04 f3             	lea    (%ebx,%esi,8),%eax
 b08:	39 d0                	cmp    %edx,%eax
 b0a:	74 18                	je     b24 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b0c:	89 13                	mov    %edx,(%ebx)
  if(p + p->s.size == bp){
 b0e:	8b 51 04             	mov    0x4(%ecx),%edx
 b11:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 b14:	39 d8                	cmp    %ebx,%eax
 b16:	74 20                	je     b38 <free+0x68>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b18:	89 19                	mov    %ebx,(%ecx)
  freep = p;
}
 b1a:	5b                   	pop    %ebx
 b1b:	5e                   	pop    %esi
 b1c:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 b1d:	89 0d 40 0d 00 00    	mov    %ecx,0xd40
}
 b23:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b24:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 b27:	8b 02                	mov    (%edx),%eax
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b29:	89 73 04             	mov    %esi,0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b2c:	8b 51 04             	mov    0x4(%ecx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b2f:	89 03                	mov    %eax,(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b31:	8d 04 d1             	lea    (%ecx,%edx,8),%eax
 b34:	39 d8                	cmp    %ebx,%eax
 b36:	75 e0                	jne    b18 <free+0x48>
    p->s.size += bp->s.size;
 b38:	03 53 04             	add    0x4(%ebx),%edx
 b3b:	89 51 04             	mov    %edx,0x4(%ecx)
    p->s.ptr = bp->s.ptr;
 b3e:	8b 13                	mov    (%ebx),%edx
 b40:	89 11                	mov    %edx,(%ecx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b42:	5b                   	pop    %ebx
 b43:	5e                   	pop    %esi
 b44:	5d                   	pop    %ebp
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 b45:	89 0d 40 0d 00 00    	mov    %ecx,0xd40
}
 b4b:	c3                   	ret    
 b4c:	8d 74 26 00          	lea    0x0(%esi),%esi

00000b50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b50:	55                   	push   %ebp
 b51:	89 e5                	mov    %esp,%ebp
 b53:	57                   	push   %edi
 b54:	56                   	push   %esi
 b55:	53                   	push   %ebx
 b56:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b59:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b5c:	8b 15 40 0d 00 00    	mov    0xd40,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b62:	83 c0 07             	add    $0x7,%eax
 b65:	c1 e8 03             	shr    $0x3,%eax
  if((prevp = freep) == 0){
 b68:	85 d2                	test   %edx,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b6a:	8d 58 01             	lea    0x1(%eax),%ebx
  if((prevp = freep) == 0){
 b6d:	0f 84 8a 00 00 00    	je     bfd <malloc+0xad>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b73:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 b75:	8b 41 04             	mov    0x4(%ecx),%eax
 b78:	39 c3                	cmp    %eax,%ebx
 b7a:	76 1a                	jbe    b96 <malloc+0x46>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 b7c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
    }
    if(p == freep)
 b83:	3b 0d 40 0d 00 00    	cmp    0xd40,%ecx
 b89:	89 ca                	mov    %ecx,%edx
 b8b:	74 29                	je     bb6 <malloc+0x66>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8d:	8b 0a                	mov    (%edx),%ecx
    if(p->s.size >= nunits){
 b8f:	8b 41 04             	mov    0x4(%ecx),%eax
 b92:	39 c3                	cmp    %eax,%ebx
 b94:	77 ed                	ja     b83 <malloc+0x33>
      if(p->s.size == nunits)
 b96:	39 c3                	cmp    %eax,%ebx
 b98:	74 5d                	je     bf7 <malloc+0xa7>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 b9a:	29 d8                	sub    %ebx,%eax
 b9c:	89 41 04             	mov    %eax,0x4(%ecx)
        p += p->s.size;
 b9f:	8d 0c c1             	lea    (%ecx,%eax,8),%ecx
        p->s.size = nunits;
 ba2:	89 59 04             	mov    %ebx,0x4(%ecx)
      }
      freep = prevp;
 ba5:	89 15 40 0d 00 00    	mov    %edx,0xd40
      return (void*) (p + 1);
 bab:	8d 41 08             	lea    0x8(%ecx),%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bae:	83 c4 0c             	add    $0xc,%esp
 bb1:	5b                   	pop    %ebx
 bb2:	5e                   	pop    %esi
 bb3:	5f                   	pop    %edi
 bb4:	5d                   	pop    %ebp
 bb5:	c3                   	ret    
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 bb6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 bbc:	89 de                	mov    %ebx,%esi
 bbe:	89 f8                	mov    %edi,%eax
 bc0:	76 29                	jbe    beb <malloc+0x9b>
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 bc2:	89 04 24             	mov    %eax,(%esp)
 bc5:	e8 96 fc ff ff       	call   860 <sbrk>
  if(p == (char*) -1)
 bca:	83 f8 ff             	cmp    $0xffffffff,%eax
 bcd:	74 18                	je     be7 <malloc+0x97>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 bcf:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 bd2:	83 c0 08             	add    $0x8,%eax
 bd5:	89 04 24             	mov    %eax,(%esp)
 bd8:	e8 f3 fe ff ff       	call   ad0 <free>
  return freep;
 bdd:	8b 15 40 0d 00 00    	mov    0xd40,%edx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 be3:	85 d2                	test   %edx,%edx
 be5:	75 a6                	jne    b8d <malloc+0x3d>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 be7:	31 c0                	xor    %eax,%eax
 be9:	eb c3                	jmp    bae <malloc+0x5e>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 beb:	be 00 10 00 00       	mov    $0x1000,%esi
 bf0:	b8 00 80 00 00       	mov    $0x8000,%eax
 bf5:	eb cb                	jmp    bc2 <malloc+0x72>
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 bf7:	8b 01                	mov    (%ecx),%eax
 bf9:	89 02                	mov    %eax,(%edx)
 bfb:	eb a8                	jmp    ba5 <malloc+0x55>
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
 bfd:	ba 38 0d 00 00       	mov    $0xd38,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 c02:	c7 05 40 0d 00 00 38 	movl   $0xd38,0xd40
 c09:	0d 00 00 
 c0c:	c7 05 38 0d 00 00 38 	movl   $0xd38,0xd38
 c13:	0d 00 00 
    base.s.size = 0;
 c16:	c7 05 3c 0d 00 00 00 	movl   $0x0,0xd3c
 c1d:	00 00 00 
 c20:	e9 4e ff ff ff       	jmp    b73 <malloc+0x23>
