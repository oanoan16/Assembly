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
	msg    db   32  dup (?) ;initialize msg with 32 bytes

.code
main PROC
	push    32              ; maximum length of msg
    push    offset msg      
    call    StdIn           ; input string

    push    offset msg
    call    StdOut          ; print to stdout

    push    0
    call    ExitProcess

main ENDP
END main