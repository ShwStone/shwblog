---
title: 编译指令-Windows-IOI
date: 2022-07-13 16:23:12
tags:
categories:
- 信奥
---
非常适合各种IOI赛制自行编译运行。  
告别IDE！我爱编辑器！  

<!-- more -->

```cpp
#include <windows.h>
#include <stdio.h>
#include <time.h>

char full_filename[100], compile_command[250], run_command[150], fc_command[300];
int id;

int main() {
    scanf("%s", full_filename);
    int len1 = strlen(full_filename);
    for (int i = len1 - 1; i >= len1 - 4; i--) 
        full_filename[i] = 0;

    sprintf(compile_command, "g++ -lm %s.cpp -o %s", full_filename, full_filename);
    printf("Compiling. . .\n");

    unsigned int compile = system(compile_command);

    if (!compile) {
        sprintf(run_command, "%s.exe", full_filename);
        printf("Running. . .\n----------------\n\n");

        clock_t c1 = clock();
        unsigned int run = system(run_command);
        clock_t c2 = clock();

        printf("\n----------------\nProcess exited after %dms with return value %u\n", c2 - c1, run);
    }
    else printf("Compile Error!\n");

    system("pause");
    return 0;
}
```
注：  
输入相对路径，如 `C:\Users\lenovo\Desktop\a.cpp` 。
