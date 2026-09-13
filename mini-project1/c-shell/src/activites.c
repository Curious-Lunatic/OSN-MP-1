#include"../include/shell.h"
#include"../include/lexer.h"
void activities(void){
    reap_finished();
    for(int i = 0; i < job_count; i++){
        if(!jobs[i].active) continue;
        printf("[%d] pgid %d\n", jobs[i].job_number, jobs[i].pgid);
        for(int p = 0; p < jobs[i].nproc; p++){
            printf("  %d %s %s\n", jobs[i].pids[p], jobs[i].names[p],
                   jobs[i].state == job_stopped ? "Stopped" : "Running");
        }
    }
}