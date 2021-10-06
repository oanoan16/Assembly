.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib

.data
	s    db   256  dup (?)   ;initialize s with 32 bytes

.code
main PROC
	push    256                 ; maximum length of msg
    push    offset s      
    call    StdIn               ; input string

    push    offset s
    call    reverse

    push    offset s
    call    StdOut              ; print to stdout

    ret

main ENDP

reverse PROC
    push    ebp                 ; save  ebp     
    mov     ebp, esp    
    push    ecx
    push    esi
    push    ebx
    mov     ecx, [ebp + 08h]    ; offset of s
    xor     ebx, ebx            
    xor     esi, esi            ; index of string
    xor     edi, edi
    push    27h                 ; tick stack

    rv_loop:
        mov     bl, byte ptr [esi + ecx] 
        cmp     bl, 0
        jz      save_loop
        inc     esi             ; next index
        push    ebx   
        jmp     rv_loop

    save_loop:
        pop     ebx     
        cmp     bl, 27h
        jz      break
        mov     byte ptr [edi + ecx], bl
        inc     edi
        jmp     save_loop
    
    break:
        mov     byte ptr [edi + ecx], 0
        pop     ebx             ; return value
        pop     esi
        pop     ecx             ; return value
        pop     ebp             
        ret     4

reverse ENDP

END main