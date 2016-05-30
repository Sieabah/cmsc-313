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

	NewLineMsg: db 10 			; new line
	NewLineLen: equ $-NewLineMsg; new line length

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
		mov edx,BUFFLEN			; sys_read to read 500 chars
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

		mov esi, Buff		; Go to beginning of Buff
		mov edi, TestBuff	; Go to beginning of TestBuff
		.findLowercase:			; loop for finding lowercase
			xor eax,eax				; zero out eax for good measure
			mov al, byte [esi]		; get first char from Buff

			cmp al, 'a' 			; char >= a
			jl .next1 				; skip it, not lowercase
			cmp al, 'z' 			; char <= z
			jg .next1				; skip it, not lowercase

			mov byte [edi], al		; put char into test buffer   
			inc edi					; increase offset for test string
			.next1:					; skipping logic

			inc esi			; move to next char in Buff
			cmp eax,0 		; is the char null
		jne .findLowercase	; if not equal, there's more

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,SortMsg 		; characters to write 
		mov edx,SortLen			; pass number of chars to write
		int 80h 				; kernel interrupt

Write:
		mov eax,4 				; sys_write call
		mov ebx, 1 				; stdout
		mov ecx,TestBuff		; buffer to write from
		mov edx,BUFFLEN 		; print only what we need
		int 80h 				; kernel interrupt

		; Following code is bubble sort
		; [d]  [c]  [b]  [a]
		; [>c] [d<] [b]  [a]
		; [>b] [d]  [c<] [a]
		; [>a] [d]  [c]  [b<]
		; [a]  [>c] [d<] [b]
		; [a]  [>b] [d]  [c<]
		; [a]  [b]  [>c] [d<]
		xor ax,ax 				; clear AX register
		mov esi, TestBuff 		; beginning of testbuff
		mov edi, TestBuff 		; beginning of testbuff
		; for i = 1 to n - 1
		;	min = i
		;	for j = i + 1 to n
		; 		if array[j] < array[min]
		; 			min = kernel
		; 		if min != i
		; 			swap array[min] and array[i]

;		.loop4: 				; sorting loop
;			inc edi				; increase second pointer to check n and n+1
;			mov al, byte [esi] 	; copy char 1 to al
;			mov ah, byte [edi] 	; copy char 2 to ah
;
;			cmp ah, 0			; check if ptr 2 is at the end of the string
;			je .l3next			; continue if it isn't, otherwise go to the next part
;
;			cmp al, ah				; check if ptr 1 comes before ptr 2
;			jl .loop4 				; skip the following two lines if not
;				mov byte [esi], ah		; if it doesn't, flip ptr 2 and ptr 1
;				mov byte [edi], al 		; flip the other char
;				call WriteTest 			; we changed, print it
;			jmp .loop4				; loop it back
;
;			.l3next:		; part 2
;			inc esi			; increase n for checking
;			mov edi, esi	; set ptr 1 to ptr 2
;
;			mov al, byte [esi]	; check if ptr 1 is at the end of the string
;			cmp al, 0 			; find if we're at the end of the string
;		jne .loop4				; if so, exit, otherwise loop

		jmp Read 				; go back to reading in a character

NewLine:
		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,NewLineMsg 		; characters to write 
		mov edx,NewLineLen		; pass number of chars to write
		int 80h 				; kernel interrupt
		ret 					; return

WriteTest:
		call NewLine 			; print new line

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,TestBuff 		; characters to write 
		mov edx,BUFFLEN			; pass number of chars to write
		int 80h 				; kernel interrupt
		ret 					; return
Exit:
		call NewLine 			; print new line
		mov eax, 1              ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
