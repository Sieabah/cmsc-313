proj4.o: proj4.asm
	nasm -f elf -g -F stabs proj4.asm 
	gcc -o proj4 proj4.o -m32

run:
	proj4.out output.txt