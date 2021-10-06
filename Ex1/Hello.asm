section .data
    msg     db      'Hello, World!', 0Ah

section .text
global _start

_start:

    mov     edx, 14
    mov     ecx, msg
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h