#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

int main() {

char * file1 = "usertests";
int fd1 = open(file1, O_RDONLY);
char * file2 = "forktest";
int fd2 = open (file2, O_RDONLY);

char buffer[10];
int rd1 = read(fd1, &buffer, 10);
int ch1 = check(fd1, 2);
int ch2 = check(fd2, 2);
close(fd1);
close(fd2);
printf(1,"check on read file %d, check on unread file %d, read ret %d\n",ch1,ch2,rd1);
printf(1, "fd1: %d, fd2 (unread): %d \n", fd1,fd2);
printf(1, "%s :buffer\n", &buffer);
exit();
}
