section .bss
    inbuf:  resb 256
    outbuf: resb 32

section .text
    global _start

; my_atoi(const char* buf{rdi}, size_t len{rsi}) -> uint64_t{rax}
my_atoi:
    ; TODO: copy your Task 3 solution here
    push rbx
    xor rbx, rbx

.forstr:
    test rsi, rsi
    jz .done

    movzx rcx, byte [rdi]
    sub rcx, '0'

    cmp rcx, 9
    ja .done

    imul rbx, rbx, 10
    add rbx, rcx

    inc rdi
    dec rsi
    jmp .forstr

.done:
    mov rax, rbx
    pop rbx
    ret

; ----------------------------------------------------------------------------
; my_itoa(uint64_t n{rdi}, char* buf{rsi}) -> size_t{rax}   -- GIVEN, do not edit
;   Writes the decimal text of n into buf (no null terminator). Returns the
;   number of digits written. Digits fall out of the div-by-10 loop least
;   significant first, so we fill buf forwards and then reverse it in place.
; ----------------------------------------------------------------------------
my_itoa:
    push rbx
    mov rax, rdi
    mov r8, rsi          ; write pointer
    mov r9, 10
.emit:
    xor edx, edx
    div r9              ; rax = rax/10, rdx = rax%10
    add dl, '0'
    mov [r8], dl
    inc r8
    test rax, rax
    jnz .emit

    mov rax, r8
    sub rax, rsi         ; rax = number of digits

    dec r8               ; last digit
.reverse:
    cmp rsi, r8
    jae .done
    mov cl, [rsi]
    mov dl, [r8]
    mov [rsi], dl
    mov [r8], cl
    inc rsi
    dec r8
    jmp .reverse
.done:
    pop rbx
    ret

_start:
    ; TODO: read two lines from stdin, my_atoi each, add them, my_itoa the sum
    ;       into outbuf, write the digits + a newline to stdout, exit 0.

    xor rax,rax
    xor rdi,rdi
    lea rsi, [inbuf]
    mov rdx,256
    syscall
    
    lea rdi,[inbuf]
    mov rsi,rax
    call my_atoi

    mov rbx,rax

    xor rax,rax
    xor rdi,rdi
    lea rsi, [inbuf]
    mov rdx,256
    syscall
    
    lea rdi,[inbuf]
    mov rsi,rax
    call my_atoi

    add rax,rbx

    mov rdi,rax
    lea rsi,[outbuf]
    call my_itoa
    
    mov rdx,rax
    inc rdx 

    mov rax,1
    mov rdi,1
    lea rsi,[outbuf]
    syscall    



    mov rax, 60
    xor rdi,rdi
    syscall
