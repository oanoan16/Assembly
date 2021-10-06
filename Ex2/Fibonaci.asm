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
    InputText   db  "Input number (>=3): ", 0
    newline     db  0Ah, 0
    number      db  5      dup(?)
    f0          db  "0", 0
                db  100     dup(0)
    f1          db  "1"
                db  100     dup(0)
    f2          db  101     dup(?)
    len         dd  0
    len1        dd  0
    r           dd  0
    n           dd  0

.code
main PROC
    push    offset InputText
    call    StdOut

    push    5
    push    offset number
    call    StdIn

    push    offset number
    call    atoi
    mov     n, eax

    push    offset f0
    call    StdOut

    push    offset newline
	call    StdOut

    push    offset f1
    call    StdOut 
    

    create_fibo:
        push    offset f1
        call    strlen
        mov     len, eax

        push    offset f0
        call    strlen
        mov     len1, eax

        push    len
        push    len1
        push    offset f0
        call    changeLen

        push    len
        push    offset f1 
        push    offset f0
        call    addition

        push    offset f1
        push    offset f0
        call    coppy

        push    offset newline
	    call    StdOut

        push    offset f2
        call    StdOut

        push    offset f2
        push    offset f1
        call    coppy

        push    offset f1
        call    strlen
        mov     len, eax

        dec     n
        cmp     n, 0
        jz      done
        jmp     create_fibo

    done:
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

changeLen PROC
   push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    esi
    mov     ebx, [ebp + 08h]     ; string 
    mov     ecx, [ebp + 10h]     ; maxlen
    mov     esi, [ebp + 0Ch]     ; len string
    dec     esi
    xor     edi, edi
    push    69h

    rev_Loop:
        mov     dl, byte ptr [esi + ebx]
        cmp     esi, 0
        jl      fill_0
        dec     esi
        dec     ecx
        push    edx
        jmp     rev_Loop
    
    fill_0:
        cmp     ecx, 0
        jz      save_Loop
        dec     ecx
        push    30h                 ; push '0'
        jmp     fill_0
    
    save_Loop:
        pop     edx
        cmp     dl, 69h
        jz      break
        mov     byte ptr [edi + ebx], dl
        inc     edi
        jmp     save_Loop

    break:
        mov     byte ptr[edi + ebx], 0
        pop     ebx
        pop     ecx
        pop     esi
        pop     ebp
        ret     12
changeLen ENDP

addition PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    mov     ebx, [ebp + 08h]    ; offset b
    mov     ecx, [ebp + 0Ch]    ; offset a
    mov     edi, [ebp + 10h]    ; len
    dec     edi
    xor     esi, esi
    mov     esi, offset f2
    push    69h

    loop_add:
        xor     edx, edx
        xor     eax, eax
        mov     dl, byte ptr [ebx + edi]
        mov     al, byte ptr [ecx + edi]
        sub     dl, 30h         ; dl -30h + al + r
        add     dl, al 
        add     dl, byte ptr [r]
        cmp     dl, 3Ah            
        jl      lower_10        ; jump if dl < 40h
        mov     byte ptr [r], 1
        sub     dl, 0Ah
        push    edx
        cmp     edi, 0
        jz      done_add
        dec     edi
        jmp     loop_add

    lower_10:
        mov     byte ptr [r], 0
        push    edx
        cmp     edi, 0
        jz      done_add
        dec     edi
        jmp     loop_add
    
    done_add:
        cmp     byte ptr[r], 1
        jnz     move_to_sum
        push    31h                 ; push '1'

    move_to_sum:
        pop     edx
        cmp     edx, 69h
        jz      break
        mov     byte ptr [esi], dl
        inc     esi
        jmp     move_to_sum
    
    break:
        mov     byte ptr [esi], 0
        mov     byte ptr [r], 0
        pop     ebx
        pop     ecx
        pop     ebp
        ret     0Ch
addition ENDP

coppy PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    mov     ebx, [ebp + 08h]   
    mov     ecx, [ebp + 0Ch]    
    xor     esi, esi
    cop_Loop:
        xor     edx, edx
        mov     dl, byte ptr [ecx + esi]
        cmp     dl, 0
        jz      finish_cop
        mov     byte ptr [ebx + esi], dl
        inc     esi
        jmp     cop_Loop
    
    finish_cop:
        mov     byte ptr [ebx + esi], 0
        pop     ebx
        pop     ecx
        pop     edx
        pop     ebp
        ret     8
coppy ENDP

END main2