section .data
    msg db "H"
	msg_len equ $-msg
    lu_table db "0123456789ABCDEF"

section .bss 
    buffer resb 32    



section .text
    extern _start
_start:

    ; base addr
    lea rdi, [lu_table]

    ; load the first byte in msg to dl 
    mov dl, byte [msg]
    mov bl, dl
    ; mask off the MSF half and leave only the LSF
    and dl,0xf
    xor rax, rax
    ; look up the 4 bit mask using the lookup table
    mov al, byte [rdi + rdx]

    xor rdx, rdx
    mov dl, bl
    shr dl, 4
    mov bl, byte [rdi + rdx]
    ; We are going to use 
    xor rcx, rcx
    mov  cl, al 
    mov cl, bl
    ; mov  cl,  

    ; EXPERIMENTAL
    mov rax, rcx
    mov rsi, rsp
    add rsp, 2

    mov [rsi], rax
	mov rdx, 2 
    mov rax, 1
    mov rdi, 1
	syscall

    mov rax, 60
    xor rdi, rdi
    syscall
