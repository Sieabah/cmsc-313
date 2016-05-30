;Name: Christopher Sidell
;Date: 9/21/2014
;Section: 01
; Project2
; This project takes a string, removes symbols and prints characters in 
; 	alphabetical order

[SECTION .data]
	PromptMsg: db 10,10,"Enter the input: " ; Prompt
	PromptLen: equ $-PromptMsg 	;Length of prompt

	SortMsg: db "Sorting string: " ;Printed SortMsg
	SortLen: equ $-SortMsg 		;length of printed message

	DebugMsg: db 10,10,"-hit-",10,10 ; exit message
	DebugLen: equ $-DebugMsg 		; exitmessage length

[SECTION .bss]
	BUFFLEN equ 500 			; length of buffer
	Buff resb BUFFLEN 			; allocate 500 bytes for input

	TestBuff resb BUFFLEN 		; string manipulation buffer

	Iteration resb 1 			; Iteration byte for whole program

[SECTION .text]

global _start                   ; make start global so ld can find it

_start:                         ; the program actually starts here
		nop

		mov byte [Iteration],0 	; zero out iteration

; Read in the string
Read:	inc byte [Iteration] 	; increment iterator
	
		cmp byte [Iteration],3 	; compare if we're done our program
		ja Exit 				; quit the program

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,PromptMsg 		; characters to write 
		mov edx,PromptLen		; pass number of chars to write
		int 80h 				; kernel interrupt

		mov esi, Buff 			; We need to clear buff for new input
		xor eax,eax				; clear EAX
		.clearBuff:				; loop
			mov byte[esi],0h 		; clear byte 
			inc eax 				; increase counter
			inc esi 				; increase memory pointer
			cmp eax, BUFFLEN 		; check if we reached the end
			jl .clearBuff 		; if more exist, go back

		mov eax,3				; sys_read call
		mov ebx,0 				; File descriptor 0: stdin
		mov ecx,Buff 			; Pass offset of the buffer to read to
		mov edx, 500			; sys_read to read 500 chars
		int 80H 				; kernel interrupt

		mov esi, eax 			; copy sys_read return value
		cmp eax,0 				; if nothing entered
		je Exit 				; quit

		mov esi, TestBuff 		; We also need to clear the testing buffer
		xor eax,eax 			; clear EAX
		.clearTest:				; start loop
			mov byte[esi],0h 		; clear byte out
			inc eax 				; increase counter
			inc esi 				; increase counter
			cmp eax, BUFFLEN 		; see if we're at the end
			jl .clearTest 		; if we're not done go back

		mov esi, Buff		; char *buff = [Buff]
		mov edi, TestBuff	; char *testbuff = [TestBuff]
		.findLowercase:			; while(c) {
			xor eax,eax				; char c = 0
			mov al, byte [esi]		; c = *buff

			cmp al, 'a'
			jl .next1
			cmp al, 'z'
			jg .next1				; if(c >= 'a' || c <= 'z') {
				mov byte [edi], al	;   *testbuff = c
				inc edi				;   testbuff++
			.next1:					; }

			inc esi			; buff++
			cmp eax,0
		jne .findLowercase		}

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,SortMsg 		; characters to write 
		mov edx,SortLen			; pass number of chars to write
		int 80h 				; kernel interrupt

Write:
		mov eax,4 				; sys_write call
		mov ebx, 1 				; stdout
		mov ecx,TestBuff			; buffer to write from
		mov edx,BUFFLEN 		; print only what we need
		int 80h 				; kernel interrupt

		; goes through like this:
		; [d]  [c]  [b]  [a]
		; [>c] [d<] [b]  [a]
		; [>b] [d]  [c<] [a]
		; [>a] [d]  [c]  [b<]
		; [a]  [>c] [d<] [b]
		; [a]  [>b] [d]  [c<]
		; [a]  [b]  [>c] [d<]
		xor ax,ax
		mov esi, TestBuff
		mov edi, TestBuff
		.loop4:
			inc edi				; increase ptr 2
			mov al, byte [esi]
			mov ah, byte [edi]

			cmp ah, 0			; check if ptr 2 is at the end of the string
			je .l3next			; continue if it isn't, otherwise go to the next part

			cmp al, ah				; check if ptr 1 comes before ptr 2
			jl .loop4
				mov byte [esi], ah	; if it doesn't, flip ptr 2 and ptr 1
				mov byte [edi], al
			jmp .loop4				; loop it back

			.l3next:		; part 2
			inc esi			; increase ptr 1
			mov edi, esi	; set ptr 1 to ptr 2

			mov al, byte [esi]	; check if ptr 1 is at the end of the string
			cmp al, 0
		jne .loop4				; if so, exit, otherwise loop

		jmp Read

Exit:
		mov eax, 1              ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
