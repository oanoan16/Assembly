section .bss
	a		resb	10
	b		resb	10
	
section .text
global _start

_start:
	mov		edx, 10			; do dai chuoi a
	mov		ecx, a			; chuyen dia chi a vao ecx
	mov 	ebx, 0			; 'No Errors'
	mov		eax, 3			; sys_read
	int		80h

	mov		edx, 10
	mov		ecx, b
	mov 	ebx, 0
	mov		eax, 3
	int		80h

	mov 	edx, 0			; edx thanh ghi du lieu, luu ket qua
	mov 	eax, a			; chuyen chuoi a vao eax
	call	ASCIItoINT
	add		edx, eax		; cong eax vao edx

	mov		eax, b			; chuyen chuoi b vao eax
	call 	ASCIItoINT		
	add		eax, edx		; edx = a+ b

	call 	iprint 			; goi ham INT to ASCII 
	push 	eax		
	mov		eax, 0Ah		; chen ki tu xuong dong 
	push	eax		
	mov 	eax, esp
	call	sprint
	pop		eax
	pop 	eax
	
	mov		ebx, 0			; no errors
	mov 	eax, 1			; sys_exit
	int		80h

iprint:    
	push 	eax
	push 	ecx
	push 	edx
	push	esi
	mov 	ecx, 0

divideLoop:
	inc 	ecx				; dem so luong ki tu
	mov 	edx, 0			; (phan du phep chia eax cho edx)
	mov		esi, 10
	idiv	esi				; chia eax cho esi, phan nguyen là eax, phan du luu trong edx
	add 	edx, 48			; cong 48 de chuyen thanh ASCII
	push	edx				; push gia tri edx (ASCII) vao stack
	cmp 	eax, 0			; so sanh voi 0
	jnz		divideLoop		; neu eax != 0 thuc hien chia tiep
	
printLoop:
	dec 	ecx				; tru di tung byte da dat vao stack
	mov 	eax, esp		; ESP - con tro stack hien tai (dinh stack)
	call 	sprint 			; goi ham in chuoi
	pop		eax 			; pop dinh stack ra ngoai
	cmp 	ecx, 0			; kiem tra da in het phan tu chua, ecx = 0 thi stack rong 
	jnz		printLoop

	pop 	esi
	pop 	edx	
	pop 	ecx	
	pop 	eax
	ret

slen:
	push	ebx
	mov		ebx, eax		; chuyen dia chi eax vao ebx

nextchar:
	cmp		byte [eax], 0	; so sanh byte duoc tro boi eax voi 0
	jz		finished		; nhay neu ZF = 1 (byte[eax] = 0)
	inc 	eax				; tang dia chi eax them 1 byte (byte[eax] !+ 0)
	jmp		nextchar		; tiep tuc nhay 

finished:
	sub 	eax, ebx		; tru eax cho ebx de lay do dai chuoi
	pop		ebx				; 
	ret

sprint:
	push 	edx
	push 	ecx
	push	ebx
	push 	eax
	call 	slen

	mov		edx, eax 		; chuyen eax = len vao edx
	pop		eax

	mov		ecx, eax		
	mov 	ebx, 1			; ghi vao STDOUT
	mov		eax, 4			; sys_write 
	int 	80h
	
	pop		ebx
	pop		ecx
	pop		edx
	ret

ASCIItoINT:
	push 	ebx
	push	edx
	push	esi				; esi (thanh ghi nguon), duoc bao toan 
	
    mov		esi, eax		; di chuyen con tro eax vao esi
	mov 	eax, 0	
	mov		ecx, 10			; thanh ghi bo dem 

    .multiplyLoop:
	    xor 	ebx, ebx		; reset byte thap, byte cao cua ebx = 0
	    mov		bl, byte [esi]	; di chuyen 1 byte(8 bit so) vao byte thap cua ebx 
    	cmp		bl, 0Ah			; so sánh gia tri cua byte vưa chuyen vao voi '0'
	    jz		.restore		; (jump if less) nhay xuong ham .finished neu < 48
    	
    	sub		bl, 48			; trư di 48 de có gia tri nguyen
    	add		eax, ebx		; cong vao eax
    	mul		ecx				; eax * 10 
    	inc		esi			; 
    	jmp		.multiplyLoop	; tiep tuc lap

    .restore:
		div		ecx
	    pop		esi
	    pop		edx	
	    pop		ebx
	    ret


