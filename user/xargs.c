#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

void xargs_exec(char *program, char **paraments)
{
    if (fork() > 0)
    {
        wait(0);
    }
    else
    {
        if (exec(program, paraments) == -1)
        {
            fprintf(2, "xargs: Error exec %s\n", program);
        }
    }
}

void xargs(char **first_arg, int size, char *program_name)
{
    char buf[1024];
    char *arg[MAXARG];
    int m = 0;
    while (read(0, buf + m, 1) == 1)
    {
        // 读取到一个完整的字符串
        if (buf[m] == '\n')
        {
            // 将该字符串作为参数存储到arg数组中
            arg[0] = program_name;
            for (int i = 0; i < size; ++i)
            {
                arg[i + 1] = first_arg[i];
            }
            arg[size + 1] = malloc(sizeof(char) * (m + 1));
            memcpy(arg[size + 1], buf, m + 1);
            // 调用xargs_exec函数执行命令
            xargs_exec(program_name, arg);
            free(arg[size + 1]);
            m = 0;
        }
        else
        {
            m++;
        }
    }
}
int main(int argc, char *argv[])
{
    if(argc<1){
        printf("we need more arguments");
    }
    else{
        xargs(argv + 1, argc - 1, argv[1]);
    }
    exit(0);
}