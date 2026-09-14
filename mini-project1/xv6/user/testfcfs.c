#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int
main(void)
{
  int i, j;
  for(i = 0; i < 4; i++){
    if(fork() == 0){
      for(j = 0; j < 5; j++)
        printf("pid %d: iteration %d\n", getpid(), j);
      exit(0);
    }
  }
  for(i = 0; i < 4; i++)
    wait(0);
  exit(0);
}