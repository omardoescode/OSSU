#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE (100)

int main(int argc, char *argv[]) {
    // argv[0] -> my-cat
    int count = 91;
    //printf("%d", count);
    fwrite(&count, sizeof(int), 1, stdout);
    return 0;
}

