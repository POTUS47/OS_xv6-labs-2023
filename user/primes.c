#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void childProcess(int p_left[2])
{
    int prime;
    if (read(p_left[0], &prime, sizeof(prime)) <= 0)
    {
        close(p_left[0]); // 关闭读端
        exit(0);
    }

    printf("prime %d\n", prime);

    int p_right[2];
    pipe(p_right);

    if (fork() == 0)
    {
        close(p_right[1]); // 子进程关闭写端
        childProcess(p_right);
    }
    else
    {
        close(p_right[0]); // 父进程关闭读端

        int num;
        while (read(p_left[0], &num, sizeof(num)) > 0)
        {
            if (num % prime != 0)
            {
                write(p_right[1], &num, sizeof(num));
            }
        }

        close(p_left[0]);  // 关闭读端
        close(p_right[1]); // 关闭写端
        wait(0);           // 等待子进程结束
        exit(0);
    }
}

int main(int argc, char *argv[])
{
    int p[2];
    pipe(p);

    if (fork() == 0)
    {
        close(p[1]); // 子进程关闭写端
        childProcess(p);
    }
    else
    {
        close(p[0]); // 父进程关闭读端
        for (int i = 2; i <= 35; i++)
        {
            write(p[1], &i, sizeof(i)); // 写入整数
        }
        close(p[1]); // 关闭写端
        wait(0);     // 等待子进程结束
    }

    exit(0);
}

