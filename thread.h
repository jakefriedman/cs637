//#include "mutex.h"
//#include "x86.h"

struct mutex_t{
  volatile unsigned int lock;
};

struct cond_t {
  volatile unsigned int value;
};


static volatile unsigned int cond_count = 0;




void mutex_init(struct mutex_t* lock) {
  xchng(lock->lock, 0); //0 is unused
}

void mutex_lock(struct mutex_t* lock) {
  //printf(1,"locking-%d,value-%d\n", lock, lock->lock);
  while(xchng(lock->lock, 1) == 1){;}
   // printf(1,"spin\n");
  //printf(1,"locked-%d,value-%d\n", lock, lock->lock);
}

void mutex_unlock(struct mutex_t* lock) {
  xchng(lock->lock, 0);
  //printf(1,"unlocked-%d\n", lock);
}


int thread_create(void*(*start_routine)(void *), void *arg){
	
	//Allocate stack using process heap
	int stack = malloc(1024);

	//create new thread
	int pid = fork_thread((int)stack, (int)start_routine, (int)arg);
		
	return pid;

}

void cond_wait(struct cond_t * c, struct mutex_t * m) { 
  // mutex_unlock(m); do icond_t * c, mutex_t * m) {
  sleep_cond(c->value, m);
  //mutex_lock(m);
}


void cond_signal(struct cond_t *c) {
  wake_cond(c->value);
}

void cond_init(struct cond_t * c) {
  if(cond_count == 0)
    cond_count = 1;
  c->value = cond_count;
  cond_count++;
  if(cond_count == 0)
    cond_count = 1;
}	

void thread_wait(){
	
	int pid;
	while((pid = wait_thread()) != -1);
	return;
}





