proj3.out: proj3.o
	ld -o proj3.out proj3.o -melf_i386

proj3.o: proj3.asm
	nasm -f elf -g -F stabs proj3.asm -l proj3.lst

run:
	proj3.out