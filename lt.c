#include "types.h"
#include "user.h"
#include "thread.h"

static int count;


void add(void* arg) 
{
  int k;
	int tik = tick();
	int ticker = tik;
  for (k = 0; k < 6000000000; k++)
{/*
	if(k = 60000)
    		while((tik = tick()) < ticker + 100)
			printf(1, "%d\n",tik);
   */ count = count++;
} 
 printf(1, "variable %d\n", count);
  exit();
}

int main() {
  count = 0;
  int x = 0;
  int pid;
  int pid2;
  int * zero;
  zero = &x;
  //int * one;
  //*one = 1;
  pid = thread_create(&add, zero);
  pid2 = thread_create(&add, zero);
  thread_wait();
  //add(zero); 
// sleep();
  //for(x = 0; x < 100000000 ; x++);
  printf(1, "Value of global variable %d, pid %d, parent %d\n",count, pid, getpid());
  exit();
}
