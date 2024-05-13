#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc,char* argv[])
{
    int p1[2]; //存放文件描述符
    int p2[2]; //一对管道
    pipe(p1); //创建一个管道
    pipe(p2);
    int pid = fork();

    //child
    if(pid==0){
        char bufer[1];
        close(p1[1]); //关闭p1管道写端，因为子进程要收到父进程的字节
        close(p2[0]); //关闭p2管道读端，因为子进程要写
        int n = read(p1[0], bufer, 1); //从管道中读一个字节
        if (n == 1)
        {
            int cpid = getpid();
            printf("%d: received ping\n", cpid);
            write(p2[1], bufer, 1); //向p2管道中写入这个字节
            exit(0);  //如果这里不写，父进程退出后，子进程会变成孤儿进程
        }
        else{
            printf("failed to read");
            exit(1);
        }
    }
    else if(pid>0){//father
        close(p1[0]);
        close(p2[1]);
        write(p1[1], "a", 1);
        wait(0); 
        char bufer[1];
        int n=read(p2[0], bufer, 1);
        if(n==1){
            int fpid = getpid();
            printf("%d: received pong\n", fpid);
            exit(0);
        }
        else{
            printf("failed to read");
            exit(1);
        }
    }
    else{
        printf("fork error\n");
        exit(1);
    }
    return 0;
}