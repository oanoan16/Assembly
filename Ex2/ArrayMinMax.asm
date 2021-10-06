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
    n         dd  0   
    number    db  10   dup(?)
    min       dd  4294967295
    max       dd  0
    s         db  10   dup(?)
    backspace db  " ", 0
    
.code
main PROC
    push    3
    push    offset number
    call    StdIn

    push    offset number
    call    atoi
    mov     n, eax

    find:
        cmp     n, 0
        jz      done
        push    15
        push    offset number
        call    StdIn
        dec     n
        push    offset number
        call    atoi
        cmp     eax, min
        jl      find_min
        cmp     eax, max
        jg      find_max
    
    find_min:
        mov     min, eax
        cmp     eax, max
        jg      find_max
        jmp     find_max
    
    find_max:
        mov     max, eax
        cmp     eax, min
        jl      find_min
        jmp     find
    
    done:
        push    min
        push    offset s
        call    itoa 
        push    offset s
        call    StdOut

        push    offset backspace
        call    StdOut

        push    max 
        push    offset s
        call    itoa
        push    offset s
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
    mov     eax, [ebp + 0Ch]        
    mov     ebx, [ebp + 08h]       
    xor     esi, esi 
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
        mov     byte ptr [ebx + esi], dl
        inc     esi
        jmp     pop_itoa

    break_itoa:
        mov     byte ptr [ebx + esi], 0
        pop     eax
        pop     ebx
        pop     ebp
        ret     8
itoa ENDP
END main






