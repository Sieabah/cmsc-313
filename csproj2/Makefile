proj2.out: proj2.o
	ld -o proj2.out proj2.o -melf_i386

proj2.o: proj2.asm
	nasm -f elf -g -F stabs proj2.asm -l proj2.lst

run:
	proj2.out