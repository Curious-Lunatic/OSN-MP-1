#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define SPIN_COUNT 50000000
static void spin(int iters) {
  volatile long x = 0;
  long long total_iters = (long long)iters * SPIN_COUNT; 
  for(long long i = 0; i < total_iters; i++)
    x += i;
  (void)x;
}

int
main(void)
{
  int pids[5];
  uint start = uptime();

  for(int i = 0; i < 5; i++){
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(1);
    }
    if(pid == 0){
      uint child_start = uptime();
      int sleep_ticks = 0;
      switch(i){
      case 0:
        spin(100);
        break;
      case 1:
        spin(8);
        break;
      case 2:
        spin(3); sleep(2); sleep_ticks += 2;
        spin(3); sleep(2); sleep_ticks += 2;
        spin(3);
        break;

      case 3:
        for(int r = 0; r < 4; r++){
          spin(1);
          sleep(8);
          sleep_ticks += 8;
        }
        break;
      case 4:
        for(int r = 0; r < 6; r++){
          spin(1);
          sleep(5);
          sleep_ticks += 5;
        }
        break;
      }
      uint child_end = uptime();
      int cpu_spin_ticks = (child_end - child_start) - sleep_ticks;
      printf("CHILDSTATS,%d,%d,%d,%d\n",
             getpid(), child_start, child_end, cpu_spin_ticks);
      exit(0);
    }
    pids[i] = pid;
  }

  printf("schedulertest: spawned 5 children (pids");
  for(int i = 0; i < 5; i++)
    printf(" %d", pids[i]);
  printf(") start_tick=%d\n", start);

  for(int i = 0; i < 5; i++)
    wait(0);

  uint end = uptime();
  printf("schedulertest: all done, end_tick=%d total_ticks=%d\n",
         end, end - start);

  printf("SCHEDTEST_DONE\n");
  exit(0);
}