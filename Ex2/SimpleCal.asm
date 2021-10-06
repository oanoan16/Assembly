.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\windows.inc 
include D:\masm32\include\user32.inc 
include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 

includelib D:\masm32\lib\user32.lib
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\msvcrt.lib
includelib D:\masm32\lib\masm32.lib

.data
    Inputa      db      "a = ", 0
    Inputb      db      "b = ", 0
    inp_option  db      "1. Add", 0Ah, "2. Sub", 0Ah, "3. Mul", 0Ah, "4. Div", 0Ah, "op = ", 0
    newline     db      0Ah, 0 
    a           db      20      dup(?)
    b           db      20      dup(?)
    op          db      ?
    opt         dd      0
    s           db      40      dup(?)
    r           db      "r = ", 0
    rint        dd      0
    rascii      db      20      dup(?)    

.code
main PROC
    push    offset Inputa
    call    StdOut
    push    20
    push    offset a
    call    StdIn

    push    offset Inputb
    call    StdOut
    push    20
    push    offset b            ; input b
    call    StdIn

    push    offset inp_option
    call    StdOut
    push    1
    push    offset op
    call    StdIn

    push    offset op
    call    atoi
    mov     opt, eax            ; opt = chosen option

    push    offset b            
    call    atoi
    mov     ebx, eax            ; ebx = b, eax = a
    push    offset a
    call    atoi

    cal:
        cmp     opt, 3
        jz      @mul
        jg      @div
        jl      add_sub
        
        @div:                   ; eax = int(a / b) , r = edx
            xor     edx, edx
            div     ebx
            jmp     done

        @mul:                   ; a * b
            mul     ebx
            jmp     done
        
        add_sub:
            cmp     opt, 1
            jz      @add
            jnz     @sub

            @add:
                add     eax, ebx        ; a + b
                jmp     done

            @sub:
                sub     eax, ebx         ; a - b
                jmp     done

    done:
        mov     rint, edx
        push    eax
        push    offset s
        call    itoa

        push    offset s
        call    StdOut

        cmp     opt, 4          ; if (a / b)
        jz     remainder
        ret

        remainder:
            push    offset newline
	        call    StdOut
            push    offset r
            call    StdOut
            push    rint
            push    offset rascii
            call    itoa
            push    offset rascii
            call    StdOut
            ret

main ENDP

atoi  PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp + 08h]
    xor     esi, esi
    xor     eax, eax
    mov     ecx, 10

    mul_Loop:
        xor     edx, edx
        mov     dl, byte ptr [ebx + esi]
        cmp     dl, 0
        jz      break
        sub     dl, 30h
        add     eax, edx
        mul     ecx
        inc     esi
        jmp     mul_Loop

    break:
        div     ecx
        pop     ebx
        pop     ebp
        ret     4
atoi  ENDP

itoa PROC
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx     
    mov     ebx, [ebp + 08h]    ; ascci
    mov     eax, [ebp + 0Ch]    ; int
    xor     edi, edi 
    mov     ecx, 10
    push    69h

    div_Loop:
        xor     edx, edx
        div     ecx
        or      edx, 30h
        push    edx
        cmp     eax, 0
        jz      pop_itoa
        jmp     div_Loop

    pop_itoa:
        pop     edx
        cmp     dl, 69h
        jz      break_itoa
        mov     byte ptr [ebx + edi], dl
        inc     edi
        jmp     pop_itoa

    break_itoa:
        mov     byte ptr [ebx + edi], 0
        xor     edi, edi
        pop     eax
        pop     ebx
        pop     ebp
        ret     8
itoa ENDP

END main
    