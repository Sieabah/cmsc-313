;Name: Christopher Sidell
;Date: 9/21/2014
;Section: 01
; Project1
; This project takes lowercase and makes it uppercase, upper to lower, 
; 	number of stars, and prints current iteration in symbols

[SECTION .data]
	PromptMsg: db 10,10,10,"Enter one char: " ;Prompt
	PromptLen: equ $-PromptMsg 	;Length of prompt

	PrintMsg: db 10,"Here is the output: " ;Printed PrintMsg
	PrintLen: equ $-PrintMsg 	;length of print message

	ExitMsg: db 10,10,"Thank you for using this program",10 ; exit message
	ExitLen: equ $-ExitMsg 		; exitmessage length

	Star: db "*" 				; start
	StarLen: equ $-Star 		; length of star

[SECTION .bss]
		Buff resb 4 			; allocate 4 bytes 3 for char, newline, null
								; and safety bit
		LoTemp resd 1 			; LoopTemporary byte for counting
		Iteration resb 1 		; Iteration byte for whole program

[SECTION .text]

global _start                   ; make start global so ld can find it

_start:                         ; the program actually starts here
		nop

		mov byte [Iteration],0 		; init iteration value to 0

Read:	inc byte [Iteration] 	; increment iterator

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,PromptMsg 		; characters to write 
		mov edx,PromptLen		; pass number of chars to write
		int 80h 				; kernel interrupt

		mov eax,3				; sys_read call
		mov ebx,0 				; File descriptor 0: stdin
		mov ecx,Buff 			; Pass offset of the buffer to read to
		mov edx, 3 				; sys_read to read one char form stdin
		int 80H 				; kernel interrupt

		and dword [Buff],0xff 	; clear out all but first byte

		cmp eax,0 				; find what EAX has from sys_read
		je Exit 				; Jump if equal to 0 (0 means EOF) to Exit

		cmp byte [Buff],30h 	; Check lower end symbol
		jb Symbol 				; Go to symbol processing

		cmp byte [Buff],7Ah 	; Check higher end symbols
		ja Symbol 				; Go to symbol processing

		cmp byte [Buff],39h 	; If within range of numbers
		jbe Number 				; Go to Number processing

		cmp byte [Buff],40h 	;check in between symbols
		jbe Symbol 				; Go to symbol processing

		cmp byte [Buff],5Ah 	; check if uppercase
		jbe Upper 				; Go to uppercase processing

		cmp byte [Buff],60h 	; check in between symbols
		jbe Symbol 				; Go to symbol processing

		cmp byte [Buff],7Ah 	; check if lowercase
		jbe Lower 				; Go to lowercase processing

		jmp Exit 				; if all else fails quit

Number:	mov ecx,[Buff] 			; copy the character
		sub ecx, 48 			; offset for ascii value
		add ecx, 10 			; project requires 10 moaaarrr
		start_num_loop: 			; loop label
			mov [LoTemp], ecx 		; keep copy of iteration

			mov eax,4				; We're going to print the star
			mov ebx,1 				; file descriptor 1, stdout
			mov ecx,Star 			; characters to write 
			mov edx,StarLen			; pass number of chars to write
			int 80h 				; kernel interrupt

			mov ecx, [LoTemp] 		; put the iteration back in ecx
		loop start_num_loop 	; Loop back if ecx != 0
		jmp Read

Symbol: mov eax,4				; We're going to print the prompt
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,PrintMsg 		; characters to write 
		mov edx,PrintLen		; pass number of chars to write
		int 80h 				; kernel interrupt

		mov ecx,[Iteration]
		start_sym_loop: 			; loop label
			mov [LoTemp], ecx 		; keep copy of iteration

			mov eax,4				; We're going to print the star
			mov ebx,1 				; file descriptor 1, stdout
			mov ecx,Buff 			; characters to write 
			mov edx,1				; pass number of chars to write
			int 80h 				; kernel interrupt

			mov ecx, [LoTemp] 		; put the iteration back in ecx
		loop start_sym_loop 		; Loop back if ecx != 0

		jmp Read 				; Back to read 

Upper: 	mov eax,4				; We're going to print the prompt
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,PrintMsg 		; characters to write 
		mov edx,PrintLen		; pass number of chars to write
		int 80h 				; kernel interrupt

		add byte [Buff],20h 	; subtract 20h from lowercase to give uppercase

		mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,Buff 			; characters to write 
		mov edx,1 				; pass number of chars to write
		int 80h 				; call sys_write

		jmp Read 				; go back to get another character

Lower: 	mov eax,4				; We're going to print the prompt
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,PrintMsg 		; characters to write 
		mov edx,PrintLen		; pass number of chars to write
		int 80h 				; kernel interrupt

		sub byte [Buff],20h 	; subtract 20h from lowercase to give uppercase

		mov eax,4				; write the character
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,Buff 			; characters to write 
		mov edx,1 				; pass number of chars to write
		int 80h 				; call sys_write

		jmp Read 				; go back to get another character

Write: 	mov eax,4				; write the character
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,Buff 			; characters to write 
		mov edx,1 				; pass number of chars to write
		int 80h 				; call sys_write

		jmp Read 				; go back to get another character

Exit:	mov eax,4				; sys_write call
		mov ebx,1 				; file descriptor 1, stdout
		mov ecx,ExitMsg 		; characters to write 
		mov edx,ExitLen			; pass number of chars to write
		int 80h 				; kernel interrupt

		mov eax, 1              ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt
