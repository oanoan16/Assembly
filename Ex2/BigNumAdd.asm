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
    a       db    20    dup(?)
    b       db    20    dup(?)
    r       db    0 
    len     dd    0 
    len1    dd    0
    len2    dd    0
    s       db    21    dup(?)  
    nline   db    0Ah, 0
    
.code
main PROC
    push    20
    push    offset a
    call    StdIn
    
    push    20
    push    offset b
    call    StdIn

    call    max_Len

    push    len
    push    offset a
    push    offset b
    call    Addition

    push    offset s
    call    StdOut
main ENDP

max_Len PROC
    push    offset a 
    call    strlen
    mov     len1, eax            ; save edx = strlen(a)
    mov     edx, eax

    push    offset b
    call    strlen              ; eax = strlen(b)
    mov     len2, eax

    cmp     eax, edx        
    jl      maxLen1             ; jump if strlen(b) < strlen(a)     
    cmp     eax, edx
    jg      maxLen2             ; jump if strlen(a) > strlen(b)

    maxLen1:
        mov     len, edx         ; maxLen = strlen(a)
        push    len
        push    len2
        push    offset b
        call    ChangeLen       ; fill_0 b
        ret     
    
    maxLen2:    
        mov     len, eax        ; maxLen = strlen(b)
        push    len
        push    len1 
        push    offset a        ; fill_0 a
        call    ChangeLen
        ret     
max_Len ENDP

strlen  PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp + 08h]
    xor     esi, esi

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

ChangeLen PROC
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
ChangeLen ENDP

Addition PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    mov     ebx, [ebp + 08h]    ; offset b
    mov     ecx, [ebp + 0Ch]    ; offset a
    mov     edi, [ebp + 10h]    ; len
    dec     edi
    xor     esi, esi
    mov     esi, offset s
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
        pop     ebx
        pop     ecx
        pop     ebp
        ret     0Ch
Addition ENDP

END  main
    
