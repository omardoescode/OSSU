#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE (100)

int main(int argc, char *argv[]) {
  // argv[0] -> my-cat
  FILE *fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("my-cat: cannot open file\n");
    exit(1);
  }

  char buffer[BUFFER_SIZE];
  while (fgets(buffer, BUFFER_SIZE, fp) != NULL)
    printf("%s", buffer);

  fclose(fp);
  return 0;
}
