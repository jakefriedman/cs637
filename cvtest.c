#include "types.h"
#include "user.h"
#include "thread.h"

static int MAX = 10;
int buffer[10];
int fillcnt      = 0;
int use       = 0;
int numfilled = 0;
int loops = 0;
int numconsumers = 0;
struct cond_t empty;
struct cond_t fill;
struct mutex_t mutex;


void put(int value) {
    buffer[fillcnt] = value;    // line F1
    fillcnt = (fillcnt + 1) % MAX; // line F2
    numfilled++;
}
int get() {
    int tmp = buffer[use];
    use = (use + 1) % MAX;
   numfilled--;
    return tmp;
}


void *producer(void *arg) {
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);            // p1
        while (numfilled == MAX)       // p2
            cond_wait(&empty, &mutex); // p3
        put(i);                        // p4
        printf(1, "put %d\n", i);
        cond_signal(&fill);            // p5
        //printf(1, "ret\n");
        mutex_unlock(&mutex);          // p6
    }
exit();
}
void *consumer(void *arg) {
	int k = *(int*) arg;
    int i;
    for (i = 0; i < loops; i++) {
        mutex_lock(&mutex);
        while (numfilled == 0)
{
		printf(1, "consumer %d waiting\n", k);
            cond_wait(&fill, &mutex);
}
        int tmp = get();
        cond_signal(&empty);
        mutex_unlock(&mutex);
        printf(1,"consumer %d got %d\n",k, tmp);
    }
exit();
}



void main() {
    loops = 5;
    numconsumers = 3;

    mutex_init(&mutex);
    cond_init(&fill);
    cond_init(&empty);
//printf(1,"lock after init %d\n",(&mutex)->lock);
    int cons[numconsumers];
    int * arg = malloc(sizeof(int));
    *arg = 1; 
    // create threads (producer and consumers)
    int prod = thread_create(producer, arg);
    int i;
    for (i = 0; i < numconsumers; i++)
	*arg = i;
        cons[i] = thread_create(consumer, arg);
    // wait for producer and consumers to finish
    thread_wait();
    exit();
}


