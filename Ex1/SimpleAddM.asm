.386
.model flat,stdcall
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
	a    db   10  dup (?)       ;initialize s with 32 bytes
    b    db   10, 13  dup (?)
    s    db   10  dup (?)
.code
main PROC
	push    10                  ; maximum length of a
    push    offset a      
    call    StdIn               ; input string a

    push    10                  ; maximum length of b
    push    offset b      
    call    StdIn               ; input string b

    mov     edx, 0
    mov     eax, offset a
    call    atoi
    add     edx, eax

    mov     eax, offset b
    call    atoi
    add     eax, edx            ; eax = a + b
    call    iprint

    push    eax
    call    StdOut

    ret                        ; exit

main    ENDP

atoi PROC
	push 	ebx
    push    edx
    push    esi
    mov		esi, eax		    ; offset 
	mov 	eax, 0	
	mov		ecx, 10		        

    mulLoop:
	    xor 	ebx, ebx		; ebx = 0
	    mov		bl, byte ptr [esi]	; mov 1 byte(8 bit) of eax to lower byte of ebx 
    	cmp		bl, 0			; compare with 0 (end of string)
	    jz		break		    ; (Jump if equal)  bl = 0

    	sub		bl, 48			; ascci to int
    	add		eax, ebx		; eax + ebx			 
    	mul		ecx				; eax * 10 
    	inc		esi				
    	jmp		mulLoop	        ; continue

    break:
        div     ecx
	    pop		ebx
        pop     edx
        pop     esi
	    ret

atoi ENDP

iprint PROC   
    ; in: eax, number value
    ; out: eax, offset of value in string 
	mov     esi, offset s   ; end index string s
    add     esi, 9
    mov     ebx, 10

divLoop:
    dec     esi
    xor     edx, edx
    div     ebx
    or      edx, 30h            ; int to ascci
    mov     byte ptr [esi], dl
    test    eax, eax            ; eax = 0 ?
    jnz     divLoop             
    mov     eax, esi
    ret

iprint  ENDP

END main