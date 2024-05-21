 section .data
    lu_table db "0123456789ABCDEF"
    
section .bss
    ; At the moment, we have hard coded the amount of memory we are going to 
    ; allocate for the input and output buffer.
    ; Ideally we would imlement some sort of memory management functionality to
    ; dynamically grow the size of the allocated space as needed, but this will
    ; do for now 
    buffer_size equ 65000000      ;"65Mb"
    input_buffer resb buffer_size 
    output_buffer resb buffer_size 

section .text
    extern _start
_start:

    ; base addr
    lea r13, lu_table         ; setup lookup table pointer
    lea r10, output_buffer


Read_from_stdin:
    mov rdi, 0                  ; file descriptor for stdin
    mov rax, 0                  ; syscall for linux Read
    mov rsi, input_buffer       ; store a pointer to the input buffer in rsi for 
    mov rdx, buffer_size        ; passing the count to read (same as stack allocation)
    syscall
    mov r12, rax                ; r12 is the number of bytes read
    test rax, rax
    js Failed_to_read 


    xor r15, r15                ; x15 is used as a index into the data on the stack
    xor r11, r11
Process_byte:
    xor rdx, rdx                ; make sure rdx is empty 
    mov dl, byte [rsi+r15]      ; grab one byte from the user input (this stuff is residing on the stack)
    mov bl, dl                  ; backup for another use later
    and dl,0xf                  ; mask off the MSF half and leave only the LSF
    xor rax, rax
    mov al, byte [r13 + rdx]    ; look up the 4 bit mask using the lookup table
    mov byte [r10+r11+1], al    ; FIXME! attemt to store the resulting byte into the stack!

    ; ----------------------      pretty much the same as above
    xor rdx, rdx
    mov dl, bl
    shr dl, 4                   ; Shifting 4 bits to the right so that we can work
                                ; on the second (higher) nybble
    xor rbx, rbx
    mov bl, byte [r13 + rdx]
    mov byte [r10+r11], bl      ; FIXME! attemt to store the resulting byte into the stack!
    ; ----------------------
    
    add r11, 2
    inc r15                     ; r15 is the index into the retrieved data
    cmp r15, r12                ; check if the index reached count of bytes read
    jl Process_byte 

Print:
    mov rsi, r10 
    mov rdx, r11 
    mov rax, 1
    mov rdi, 1
    syscall
    mov rdi, 0

Done:
    mov rax, 60
    syscall

Failed_to_read:
    mov rdi, 10 
    jmp Done