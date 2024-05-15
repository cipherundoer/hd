hd: hd.o
	ld -melf_x86_64 -o hd hd.o
hd.o: hd.asm
	nasm -felf64 -o hd.o hd.asm
