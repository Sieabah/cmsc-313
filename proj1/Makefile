proj1.out: proj1.o
	ld -o proj1.out proj1.o -melf_i386

proj1.o: proj1.asm
	nasm -f elf -g -F stabs proj1.asm -l proj1.lst

run:
	proj1.out