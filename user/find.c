#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--) // p指向路径字符串的末尾（即空字符 \0 的位置）
        ;
    p++; // p指向最后一个/后的第一个字符

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p)); // 保证 buf的总长度为DIRSIZ，即使文件名不够长也会用空格填充
    return buf;
}

void findName(char *path,char *name)
{
    char buf[512], *p; // 用于存储路径和文件名的缓冲区，大小为512字节
    int fd;            // 文件描述符，用于打开和读取文件
    struct dirent de;  // 目录项结构体，用于存储从目录中读取的每个文件或目录项的信息。
    struct stat st;    // 文件状态结构体，用于获取文件或目录的详细信息
    char *temp = ".";
    char *temp1 = "..";

    if ((fd = open(path, O_RDONLY)) < 0)
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
    { // 由文件描述符取得文件的状态,and复制到参数st所指向的结构中
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
    {
    case T_DEVICE: // 如果是普通文件或设备文件，就打印出它的文件名，文件类型，索引节点号和大小
    case T_FILE:
        if (strcmp(fmtname(path),name)==0){
            printf("%s\n", fmtname(path));
        }
        break;

    case T_DIR:
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
        {
            printf("ls: path too long\n");
            break;
        }
        strcpy(buf, path);
        p = buf + strlen(buf); // 指针p移动到路径最后
        *p++ = '/';            // p当前位置写入一个/，然后p再往后移动一次（表示进入此目录）
        while (read(fd, &de, sizeof(de)) == sizeof(de))
        {
            if (de.inum == 0) // 跳过空目录项（inum为0）
                continue;
            if(strcmp(de.name,temp)==0){
                continue;
            }
            if (strcmp(de.name, temp1) == 0)
            {
                continue;
            }
            memmove(p, de.name, DIRSIZ); // 将目录项的名称复制到buf的末尾，并进行文件状态获取
            p[DIRSIZ] = 0;
            if (stat(buf, &st) < 0)
            {
                printf("ls: cannot stat %s\n", buf);
                continue;
            }
            if (strcmp(de.name, name) == 0)
            {
                 printf("%s\n", buf);
            }
            else{
                if (st.type == T_DIR)
                {
                    findName(buf, name);
                }
            } 
        }
        break;
    }
    close(fd);
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("User forgets to pass an argument\n");
        exit(0);
    }
    findName(argv[1], argv[2]);
    exit(0);
}
