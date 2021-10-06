.386
.model flat,stdcall
option casemap:none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	s    db   32  dup (?)   ;initialize s with 32 bytes

.code
main PROC
	push    32                  ; maximum length of msg
    push    offset s      
    call    StdIn               ; input string

    mov     ecx, 0              ; string index, start = 0
    upper:
    	cmp		s [ecx], 0      ; compare with end char of string  
    	jz		finished
        cmp     s [ecx], 'a'    ; compare with 'a'
        jl      next            ; jump to next if less than 'a'
        cmp     s [ecx], 'z'    
        jg      next            ; jump to next if less than 'a'
        sub     s [ecx], 20h
 
        next:
            inc     ecx         ; increase index
            jnz     upper       ; loop

        finished:
            nop                 ; nope ===> break

    push    offset s
    call    StdOut          ; print to stdout

    push    0               
    call    ExitProcess     ; exit 

main ENDP
END main