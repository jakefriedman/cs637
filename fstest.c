#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int
main() {
char teststring[1024];
int k;
for(k =0 ; k< 1024; k++)
   teststring[k] = 'j';
struct stat *a;
int i = 0;
int fd = open("fstestfile", O_CREATE | O_RDWR);
printf(1, "File fstestfile Created\n");
while(1) {
if(i % 10 == 0) {
fstat(fd, a);
printf(1, "Current Test File Size %d bytes\n", a->size);
}
write(fd, &teststring, 1024);
i++;
}
exit();
}
