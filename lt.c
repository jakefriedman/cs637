#include "thread.h"
#include "user.h"
static int count;


void add(void* arg) 
{
  int k;
  for (k = 0; k = 1000; k++)
    count = count++;
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
  //pid2 = thread_create(&add, (void*)one); 
  thread_wait();
  //add(zero); 
// sleep();
  //for(x = 0; x < 100000000 ; x++);
  printf(1, "Value of global variable %d\n",count);
  exit();
}

