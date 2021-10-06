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
    Inputs      db    "s = ", 0
    Inputc      db    "c = ", 0    
    newline     db    0Ah, 0 
    s           db    100       dup(?)
    csub        db    10        dup(?)    
    clen        dd    0
    count       dd    0 
    count_str   db    3         dup(?)   
    count_ir    dd    0                 ; count index result
    index       db    3         dup(?)  
    result      db    500       dup(?)
    backspace   db    " ", 0    
.code
main PROC
    push    offset Inputs
    call    StdOut
    push    100
    push    offset s
    call    StdIn

    push    offset Inputc
    call    StdOut
    push    10
    push    offset csub
    call    StdIn

    push    offset csub
    call    strlen
    mov     clen, eax

    push    offset s
    push    offset csub
    call    find

    push    count
    push    offset count_str
    call    itoa
    push    offset count_str            ; ptint count
    call    StdOut

    push    offset newline
	call    StdOut

    push    offset result               ; print index
    call    StdOut

main ENDP

find PROC
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    mov     eax, [ebp + 08h]      ; c
    mov     ebx, [ebp + 0Ch]      ; s
    xor     esi, esi

    find_loop:
        xor     edx, edx
        xor     edi, edi
        mov     dl, byte ptr [ebx + esi]
        mov     dh, byte ptr [eax + 0h]
        cmp     dl, 0
        jz      done_find
        cmp     dl, dh               ; cmp s[esi] with c[0]
        jz      cmp_sub
        inc     esi
        jmp     find_loop

    cmp_sub:
        xor     edx, edx
        mov     dl, byte ptr [eax + edi]
        cmp     dl, 0
        jz      equal
        mov     dh, byte ptr [ebx + esi]
        cmp     dl, dh
        jnz     find_loop
        inc     edi
        inc     esi
        jmp     cmp_sub

    equal:
        mov     ecx, count
        inc     ecx
        mov     count, ecx
        sub     esi, clen
        push    esi
        push    offset index
        call    itoa
        add     esi, clen
        push    offset index
        push    offset result
        push    count_ir
        call    link
        jmp     find_loop

    done_find:
        pop     eax
        pop     ebx
        pop     ecx
        pop     ebp
        ret     8
find ENDP

link PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    eax
    mov     ebx, [ebp + 08h]        ; count_ir
    mov     ecx, [ebp + 0Ch]        ; result
    mov     eax, [ebp + 10h]        ; index
    xor     edi, edi

    link_loop:
        xor     edx, edx
        mov     dl, byte ptr [eax + edi]
        cmp     dl, 0
        jz      done_link
        mov     byte ptr [ecx + ebx], dl
        inc     edi
        inc     ebx
        jmp     link_loop
    
    done_link:
        mov     byte ptr [ecx + ebx], 20h
        inc     ebx
        mov     byte ptr [ecx + ebx], 0
        mov     count_ir, ebx
        xor     edi, edi
        pop     ebx
        pop     ecx
        pop     eax
        pop     ebp
        ret     12

link ENDP

strlen  PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp + 08h]
    xor     esi, esi
    xor     eax, eax
    nextchar:
        cmp     byte ptr [ecx + esi], 0
        jz      finished
        inc     esi
        jmp     nextchar

    finished:
        mov     eax, esi        ; eax = strlen
        pop     ebp
        ret     4
strlen  ENDP

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


    