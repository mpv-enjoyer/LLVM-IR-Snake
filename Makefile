all:
	clang main.ll -O0 -lraylib -g -o snake
sample:
	clang -emit-llvm -O0 -S sample.c -o sample.ll