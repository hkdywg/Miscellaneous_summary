#include <stdio.h>
#include <strings.h>
#include <unistd.h>
#include "print.h"

void func_log(char *msg)
{
    func_print(msg);
    return ;
}
