section .bss
    str:     resb    255
section .text
global  _start

_start:
    mov     edx, 255
    mov     ecx, str
    mov     ebx, 0
    mov     eax, 3
    int     80h

    mov     ebx, str
    mov     eax, ebx
    
    nextchar:
        cmp     byte [eax], 0
        jz      finished
        inc     eax
        jmp     nextchar

    finished:
        sub     eax, ebx
    
    mov     edx, eax
    mov     ecx, str
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h