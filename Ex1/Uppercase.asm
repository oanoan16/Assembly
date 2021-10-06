section .bss
    str:      resb      32
 
section .text
global  _start
 
_start:
    mov     edx, 32
    mov     ecx, str
    mov     ebx, 0
    mov     eax, 3
    int     80h
 
    mov     ebx, str
    mov		ecx, ebx
 
    upperCase:
    	cmp		byte [ecx], 0
    	jz		finished
        cmp     byte [ecx], 'a'
        jl      .next
        cmp     byte [ecx], 'z'
        jg      .next
        sub     byte [ecx], 20h
 
    .next:
        inc     ecx
        jnz     upperCase

    finished:
        sub		ecx, ebx
 
    mov     edx, ecx
    mov     ecx, str
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    mov     ebx, 0
    mov     eax, 1
    int     80h
 