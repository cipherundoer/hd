int_print: int_print.o
	ld -melf_x86_64 -o int_print int_print.o
int_print.o: int_print.asm
	nasm -felf64 -o int_print.o int_print.asm
