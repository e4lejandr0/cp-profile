#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define WRONG_ARGS 1
#define FILE_ERR 2
#define COPY_ERR 3

#define BUF_SIZE 4096

int copy(FILE* src, FILE* dest)
{
	char buffer[BUF_SIZE];
	size_t bytesRead = 0;
	size_t bytesWritten = 0;

	do {
		bytesRead = fread(buffer, sizeof(char), BUF_SIZE, src);
		bytesWritten = fwrite(buffer, sizeof(char), bytesRead, dest);
	} while(!feof(src) && !ferror(src) && !ferror(dest));

	return ferror(src) || ferror(dest);
}

int main(int argc, char** argv)
{
	if(argc != 3) {
		fprintf(stderr, "Usage: %s <src> <dest>\n", argv[0]);
		return WRONG_ARGS;
	}

	const char* destPath = argv[2];
	const char* srcPath = argv[1];
	FILE* src = fopen(srcPath, "r");
	FILE* dest = fopen(destPath, "w");

	if(src == NULL || dest == NULL) {
		perror("could not open file");
		return FILE_ERR;
	}
	
	printf("%s -> %s\n", srcPath, destPath);
	int failure = copy(src, dest);
	if(failure) {
		perror("could not copy file");
	}

	return 0;
}
