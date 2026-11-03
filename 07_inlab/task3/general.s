; general.s -- c[i] = a[i] + b[i] for ANY N >= 0.
;
; Three loops run one after the other, each with its own compare and jump:
;   loop4  4 elements per iteration while at least 4 are left
;   loop2  2 elements per iteration while at least 2 are left
;   loop1  1 element per iteration while at least 1 is left
;
; Goal: correct for every N, and as fast as possible (remove RAW and other
; stalls).
;
; Hints:
;   - r4 is the number of elements left. Each loop needs a test to enter it
;     and a test to repeat it.
;   - `slti rd, rs, imm` sets rd to 1 if rs < imm; then `bne`/`beq` on rd.
;   - A branch reads its register in ID: compute its condition early.
;   - Tests: N = 8, 6, 9, 1024, 2047, 4098.
;
; As given, the program stops without writing c.
; The data below is the test with N = 8; `make task3-tests` writes the others.

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

        ; TODO: loop4 -- 4 elements per iteration while at least 4 are left
        slti  r20, r4, 4 ;20==1 if r4<1
        bne   r20, r0, loop2

loop4:
        ld    r5, 0(r1)
        ld    r6, 8(r1)     
        ld    r7, 16(r1)     
        ld    r8, 24(r1)
        ld    r9, 0(r2)
        ld    r10, 8(r2)     
        ld    r11, 16(r2)
        ld    r12, 24(r2)
         
        daddi r4, r4, -4

        dadd  r13, r5,  r9         ;addition
        dadd  r14, r6,  r10  
        dadd  r15, r7, r11
        dadd  r16, r8, r12

        slti  r20, r4, 4


        sd    r13,  0(r3)          ; storing values
        sd    r14, 8(r3)
        sd    r15, 16(r3)          
        sd    r16, 24(r3)          

        daddi r1, r1, 32          ; move each pointer to the next word(8 bytes) * 4
        daddi r2, r2, 32
        daddi r3, r3, 32

        beq r20,r0, loop4


        ; TODO: loop2 -- 2 elements per iteration while at least 2 are left
        ; runs at most once always
loop2:
    ; 2 elements done
        slti  r20, r4, 2
        ld    r5, 0(r1)      ; branch delay slot :P
        bne   r20, r0, one

        ld    r6, 8(r1)     
        ld    r9, 0(r2)
        ld    r10, 8(r2)     
         
        dadd  r13, r5,  r9         ;addition
        dadd  r14, r6,  r10  
        
        daddi r4, r4, -2         ; 2 elements done
        
        sd    r13,  0(r3)          ; storing values
        sd    r14, 8(r3)
        
        daddi r1, r1, 16         ; move each pointer to the next word(8 bytes) * 4
        daddi r2, r2, 16
        daddi r3, r3, 16





        ; TODO: loop1 -- 1 element per iteration while at least 1 is left
        ; runs at most once always
one:
        slti  r20, r4, 1
        ld    r5, 0(r1)      ; branch delay slot :P
        bne   r20, r0, done

        ld    r6, 0(r2)          ; r6 = b[i]
        dadd  r7, r5, r6         ; r7 = a[i] + b[i]
        sd    r7, 0(r3)          ; c[i] = r7
        daddi r1, r1, 8          ; move each pointer to the next word
        daddi r2, r2, 8
        daddi r3, r3, 8
        daddi r4, r4, -1         ; one element done


done:   syscall 0                ; stop the simulator
