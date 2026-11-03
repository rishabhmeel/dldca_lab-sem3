; unroll4.s -- unroll the loop of loop.s by 4.
;
; One iteration of your loop handles 4 elements, so the branch, the counter
; and the pointer updates are paid once per 4 elements. c must end up as
; a[i] + b[i]. In the tests N is a multiple of 4.
;
; Hints:
;   - Element j of an iteration is at offset 8*j: 0(r1), 8(r1), ...
;   - Give each element its own registers.
;   - Advance each pointer by 8*4 once per iteration, and subtract 4 from r4.
;
; As given, the program stops without writing c.
; The data below is the test with N = 8; `make task2-tests` writes the others.

        .data
n:      .word 8                  ; N, the number of elements
a:      .word 3, 10, 17, 24, 31, 38, 45, 52
b:      .word 5, 18, 31, 44, 57, 70, 83, 96
c:      .space 64                ; N words, filled in by the program

        .text
        ; ---- setup: DO NOT EDIT ----
        ld    r4, n(r0)          ; r4 = N, the number of elements left
        daddi r1, r0, a          ; r1 -> a[0]
        dsll  r5, r4, 3          ; r5 = 8 * N, the size of one array in bytes
        dadd  r2, r1, r5         ; r2 -> b[0]  (b follows a in memory)
        dadd  r3, r2, r5         ; r3 -> c[0]  (c follows b)
        ; ---- end of setup ----

loop:   ; TODO: unrolled loop body, ending with the branch back to loop
        ld    r5, 0(r1)
        ld    r6, 8(r1)     
        ld    r7, 16(r1)     
        ld    r8, 24(r1)
        ld    r9, 0(r2)
        ld    r10, 8(r2)     
        ld    r11, 16(r2)
        ld    r12, 24(r2)
         
        dadd  r13, r5,  r9         ;addition
        dadd  r14, r6,  r10  
        dadd  r15, r7, r11
        dadd  r16, r8, r12
        
        sd    r13,  0(r3)          ; storing values
        sd    r14, 8(r3)
        sd    r15, 16(r3)          
        sd    r16, 24(r3)          
        
        daddi r1, r1, 32          ; move each pointer to the next word(8 bytes) * 4
        daddi r2, r2, 32
        daddi r3, r3, 32

        daddi r4, r4, -4         ; 4 elements done
        bne   r4, r0, loop

        syscall 0                ; stop the simulator
