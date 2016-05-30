;Name: Christopher Sidell
;Date: 9/21/2014
;Section: 01
; Project3
; this project deals with ids and names, allows to modify after submission of 5

; Proceedures:
; 		GetID - Line 172 - retrieves ID from user input, puts in Buff 
;	 	GetName - Line 184 - retrieves name from the user input, puts in Buff
; 		NewLine - Linx 144 - prints new line to the screen
; 		ClearBuffer - Line 150 - clears entire buffer for new input
;		ValidID - Line 195 - determines if entry is valid and modifies all registers (bx is return)
; Macros:
; 		get_input(location, amount) - line 93 - gets input from stdin
; 		print_out(location,amount) - Line 107 -prints out to stdout
; 		store_registers - line 75 - stores primary 4 registers
; 		restore_registers - line 84 - restores primary 4 registers

[SECTION .data]
	PromptMsg: db "Please enter the id: " ; Prompt
	PromptLen: equ $-PromptMsg 	;Length of prompt

	PrompMessage: db "Enter the name: " ;Printed PrompMessage
	PrompMessageLen: equ $-PrompMessage 		;length of printed message

	InvalidId: db 10,"Invalid id ",10 ;Printed InvalidId
	InvalidIdLen: equ $-InvalidId 		;length of printed message

	NameWas: db "The name was: ", ;Printed NameWas
	NameWasLen: equ $-NameWas 		;length of printed message

	NewName: db "Enter the new name: " ;Printed NewName
	NewNameLen: equ $-NewName 		;length of printed message

	FinalPrompt: db "Enter ids of names to change (00 to stop)",10 ;Printed FinalPrompt
	FinalPromptLen: equ $-FinalPrompt 		;length of printed message

	ID: db "ID: "				; 'id:'
	IDLen: equ $-ID 			; length of prompt

	NAME: db "NAME: "				; 'NAME:'
	NAMELen: equ $-NAME 			; length of prompt

	NewLineMsg: db 10 			; new line
	NewLineLen: equ $-NewLineMsg ; new line length

	DigitLength equ 2 			; max length of ID
	DigitLenIn equ 3 			; max length of ID input
	NameLength equ 9 			; max length of names
	NameLenIn equ 10 			; max length of names input
[SECTION .bss]

	BUFFLEN equ 10 				; max length of buffer
	Buff resb BUFFLEN 			; allocate 10 bytes for input

	Iteration resb 1 			; Iteration byte for whole program
	Match resb 1 				; ValidID Match case

	FirstID resb 2 				; first ID
	FirstName resb 10 			; first name
	SecondID resb 2 			; second ID
	SecondName resb 10 			; second name
	ThirdID resb 2 				; third ID
	ThirdName resb 10 			; third name
	FourthID resb 2 			; fourth ID
	FourthName resb 10 			; fourth name
	FifthID resb 2 				; fifth ID
	FifthName resb 10 			; fifth name

[SECTION .text]

global _start                   ; make start global so ld can find it

;store_registers
; store primary registers on stack
%macro store_registers 0 		; define macro
	push eax 					; store eax on stack
	push ebx 					; store ebx on stack
	push ecx 					; store ecx on stack
	push edx 					; store edx on stack
%endmacro 						; end macro

;restore_registers
; restore primary registers from
%macro restore_registers 0 		; define macro
	pop edx 					; take edx from stack
	pop ecx 					; take ecx from stack
	pop ebx 					; take ebx from stack
	pop eax 					; take eax from stack
%endmacro 						; end macro

;get_input
;modifies primary 4 registers 
%macro get_input 2 				;define macro with 2 inputs
	store_registers 			; KEEP ALL THE REGISTERS

	mov eax,3					; sys_read call
	mov ebx,0 					; File descriptor 0: stdin
	mov ecx,%1 					; From parameter, how much to read in
	mov edx,%2					; from parameter, where to read to
	int 80H 					; kernel interrupt

	restore_registers 			; RESTORE THEM
%endmacro 						;end macro

;print_out
;modifies primary 4 registers 
%macro print_out 2 				;define macro with 2 inputs
	store_registers 			; KEEP ALL THE REGISTERS

	mov eax,4					; sys_write call
	mov ebx,1 					; file descriptor 1, stdout
	mov ecx,%1 					; characters to write 
	mov edx,%2					; pass number of chars to write
	int 80h 					; kernel interrupt

	restore_registers 			; RESTORE THEM
%endmacro 						;end macro

;copy_name(pointer)
;copy from buffer to name pointer given
; requires eax to hold pointer
CopyName: 
	store_registers 			; KEEP ALL THE REGISTERS
	
	mov ecx,NameLength 			; iterate for length of buffer
	mov esi,Buff 				; pointer to buffer

	.loop: 						; loop to kill buffer
		mov bl, byte [esi] ; kill char 
		mov byte [eax], bl

		inc esi					; move to next char in Buff
		inc eax

		dec ecx					; ITERATE
		cmp ecx,0 				; DID WE FINISH?!
	jne .loop 					; If no, go back

	restore_registers 			; RESTORE THEM
	ret

; NewLine (proceedure) 
; Prints a newline to the screen
NewLine:
		print_out NewLineMsg, NewLineLen ;print out new line
		ret 					; return

;Clear buffer (proceedure)
;clears entire buffer for more input
ClearBuffer:
	store_registers 			; KEEP ALL THE REGISTERS
	
	mov ecx, BUFFLEN 			; iterate for length of buffer
	mov esi,Buff 				; pointer to buffer


	.loop: 						; loop to kill buffer
		mov byte [esi],0 		; kill char 
		inc esi					; move to next char in Buff

		dec ecx					;ITERATE
		cmp ecx,0 				;DID WE FINISH?!
	jne .loop 					;If no, go back

	restore_registers 			; RESTORE THEM

	ret

; GetID
; modifies EAX with the two numbers that the user inputs
; Retrieves the ID
GetID:
	call ClearBuffer 			; clear entire buffer

	print_out PromptMsg, PromptLen ; print out message

	get_input Buff,DigitLenIn 	; get id and put it in register given

	ret 						; return

; GetName
; modifies EAX with the two numbers that the user inputs
; Retrieves the ID
GetName:
	call ClearBuffer 			; clear entire buffer

	print_out PrompMessage, PrompMessageLen ; print out message

	get_input Buff,NameLenIn 	 ; get id and put it in register given
	
	ret 						; return

;ValidID
; Modifies ax and bx, returns boolean in bx
ValidID:
	xor bx,bx 					;clear bx
	
	mov byte [Match],1 				;match 1
	mov bx,[FirstID] 			;get input for id
	cmp bx,ax 					; compare equivalence
	je .false 					; if equal, it's invalid

	mov byte [Match],2 				;match 2
	mov bx,[SecondID] 			;get input for id
	cmp bx,ax 					; compare equivalence
	je .false 					; if equal, it's invalid

	mov byte [Match],3 				;match 3
	mov bx,[ThirdID]			;get input for id
	cmp bx,ax 					; compare equivalence
	je .false 					; if equal, it's invalid

	mov byte [Match],4 				;match 4
	mov bx,[FourthID]			;get input for id
	cmp bx,ax 					; compare equivalence
	je .false 					; if equal, it's invalid

	mov byte [Match],5 				;match 5
	mov bx,[FifthID]			;get input for id
	cmp bx,ax 					; compare equivalence
	je .false 					; if equal, it's invalid

	mov byte [Match],0 				;match 0
	.true:
		xor bx,bx 				;clear bx for good measure
		mov bx,1h 				; set it to 'true'
		jmp .skip 				; skip false
	.false:
		xor bx,bx 				; clear bx 'false'

	.skip:
	ret 						;'return'

_start:                         ; the program actually starts here
		nop 					;gdb requirement

		mov byte [Iteration],0 	; zero out iteration

GettingInput:
		inc byte [Iteration] 	; increment iterator

	.fst:
		jmp .fstP				; skip invalid message printing
	.fstR:
		print_out InvalidId, InvalidIdLen ;print invalid message
	.fstP:
		cmp byte [Iteration],1  ;first
		jne .snd 				;if not check second

		call GetID 				; get id

		mov cx, word [Buff] 	; get id out of buffer

		mov ax, cx 				; move into temporary
		call ValidID 			; check validity

		cmp bx,0 				; is it valid
		je .fstR 				; warn and go back

		mov [FirstID] , cx 		; put id into holder

		call NewLine 			; print new line

		call GetName 			; get name

		mov eax,FirstName 		; put pointer in eax
		call CopyName 			; copy name from buffer

		call NewLine 			; print new line

		jmp .skip 				;skip rest of if statement
	.snd: 						;second label
		jmp .sndP				; skip invalid message printing
	.sndR:
		print_out InvalidId, InvalidIdLen ;print invalid message
	.sndP:
		cmp byte [Iteration],2 	;second
		jne .thrd 				;if not check third

		call GetID 				; get id

		mov cx, word [Buff] 	; get id out of buffer

		mov ax, cx 				; move into temporary
		call ValidID 			; check validity

		cmp bx,0 				; is it valid
		je .sndR 				; warn and go back

		mov [SecondID], cx 		; put id into holder

		call NewLine 			; print new line

		call GetName 			; get name

		mov eax,SecondName 		; put pointer in eax
		call CopyName 			; copy name from buffer

		call NewLine 			; print new line

		jmp .skip 				;skip rest of if statement
	.thrd: 						;third label
		jmp .thrdP				; skip invalid message printing
	.thrdR:
		print_out InvalidId, InvalidIdLen ;print invalid message
	.thrdP:
		cmp byte [Iteration],3 	;third
		jne .frth 				; if not check fourth

		call GetID 				; get id

		mov cx, word [Buff] 	; get id out of buffer

		mov ax, cx 				; move into temporary
		call ValidID 			; check validity

		cmp bx,0 				; is it valid
		je .thrdR 				; warn and go back

		mov [ThirdID], cx 		; put id into holder

		call NewLine 			; print new line

		call GetName 			; get name

		mov eax,ThirdName 		; put pointer in eax
		call CopyName 			; copy name from buffer

		call NewLine 			; print new line

		jmp .skip 				;skip rest of if statement
	.frth: 						;fourth label
		jmp .frthP				; skip invalid message printing
	.frthR:
		print_out InvalidId, InvalidIdLen ;print invalid message
	.frthP:
		cmp byte [Iteration],4 	;fourth
		jne .ffth 				; if not check fifth

		call GetID 				; get id

		mov cx, word [Buff] 	; get id out of buffer

		mov ax, cx 				; move into temporary
		call ValidID 			; check validity

		cmp bx,0 				; is it valid
		je .frthR 				; warn and go back

		mov [FourthID], cx 		; put id into holder

		call NewLine 			; print new line

		call GetName 			; get name

		mov eax,FourthName 		; put pointer in eax
		call CopyName 			; copy name from buffer

		call NewLine 			; print new line

		jmp .skip 				;skip rest of if statement
	.ffth: 						;fifth label
		jmp .ffthP				; skip invalid message printing
	.ffthR:
		print_out InvalidId, InvalidIdLen ;print invalid message
	.ffthP:
		cmp byte [Iteration],5 	;fifth
		jne .skip 				; if not skip

		call GetID 				; get id

		mov cx, word [Buff] 	; get id out of buffer

		mov ax, cx 				; move into temporary
		call ValidID 			; check validity

		cmp bx,0 				; is it valid
		je .ffthR 				; warn and go back

		mov [FifthID], cx 		; put id into holder

		call NewLine 			; print new line

		call GetName 			; get name

		mov eax,FifthName 		; put pointer in eax
		call CopyName 			; copy name from buffer

		call NewLine 			; print new line

	.skip: 						; skip label
		cmp byte [Iteration],5 	; compare if we're done our program
		jge ModifyingInput 		; quit the program

		jmp GettingInput 		; go back to beginning if we're not done
		

ModifyingInput:
		print_out FinalPrompt, FinalPromptLen ;display final prompt

		call NewLine 			;print new line

	.modify: 					; modifying logic
		jmp .main
		.mainI:
			print_out InvalidId, InvalidIdLen ;print invalid message
		.main:
			call GetID 				; get id

			xor cx,cx 				; clear cx
			mov cx, word [Buff] 	; get id out of buffer

			cmp cx,12336			; if '00'
			je Exit 				; exit

			mov ax, cx 				; move into temporary
			call ValidID 			; check validity

			cmp bx,0 				; is it valid
			jne .mainI 				; warn and go back

		.first:
			cmp byte [Match],1 		; match 1st
			jne .second 			; no, go to 2nd

			call NewLine 			;print new line

			print_out NameWas, NameWasLen ;print prompt for prev name

			print_out FirstName, NameLength ;print name 

			call NewLine 			;print new line

			call GetName 			; get name

			mov eax,FirstName 		; put pointer in eax
			call CopyName 			; copy name from buffer

			call NewLine 			;print new line

			jmp .main 				; go back to modify
		.second:
			cmp byte [Match],2 		;match 2nd?
			jne .third 				; no, go to 3rd

			call NewLine 			;print new line

			print_out NameWas, NameWasLen ;print prompt for prev name

			print_out SecondName, NameLength ;print name

			call NewLine 			;print new line

			call GetName 			; get name

			mov eax,SecondName 		; put pointer in eax
			call CopyName 			; copy name from buffer

			call NewLine 			;print new line

			jmp .main 				; go back to modify
		.third:
			cmp byte [Match],3 		;match 3rd?
			jne .fourth 			; no, go to 4th

			call NewLine 			;print new line

			print_out NameWas, NameWasLen ;print prompt for prev name

			print_out ThirdName, NameLength ;print name

			call NewLine 			;print new line

			call GetName 			; get name

			mov eax,ThirdName 		; put pointer in eax
			call CopyName 			; copy name from buffer

			call NewLine 			;print new line

			jmp .main 				; go back to modify
		.fourth:
			cmp byte [Match],4 		; match 4th?
			jne .fifth 				; no, go to 5th

			call NewLine 			;print new line

			print_out NameWas, NameWasLen ;print prompt for prev name

			print_out FourthName, NameLength ;print name

			call NewLine 			;print new line

			call GetName 			; get name

			mov eax,FourthName 		; put pointer in eax
			call CopyName 			; copy name from buffer

			call NewLine 			;print new line

			jmp .main 				; go back to modify
		.fifth:
			call NewLine 			;print new line

			print_out NameWas, NameWasLen ;print prompt for prev name

			print_out FifthName, NameLength ;print name

			call NewLine 			;print new line

			call GetName 			; get name

			mov eax,FifthName 		; put pointer in eax
			call CopyName 			; copy name from buffer

			call NewLine 			;print new line

			jmp .main 				; go back to modify
		jmp Exit

Exit:
		call NewLine 			;print new line

		print_out ID,IDLen 		;print id message
		print_out FirstID, DigitLength  ;print id

		call NewLine 			; print new line

		print_out NAME,NAMELen 	;print name message
		print_out FirstName, NameLength ;print name

		call NewLine 			; print new line

		print_out ID,IDLen 		;print id message
		print_out SecondID, DigitLength ;print id

		call NewLine 			; print new line

		print_out NAME,NAMELen 	;print name message
		print_out SecondName, NameLength ;print name

		call NewLine 			; print new line
		
		print_out ID,IDLen 		;print id message
		print_out ThirdID, DigitLength ;print id

		call NewLine 			; print new line
		
		print_out NAME,NAMELen 	;print name message
		print_out ThirdName, NameLength ;print name

		call NewLine 			; print new line
		
		print_out ID,IDLen 		;print id message
		print_out FourthID, DigitLength ;print id

		call NewLine 			; print new line
		
		print_out NAME,NAMELen 	;print name message
		print_out FourthName, NameLength ;print name

		call NewLine 			; print new line
		
		print_out ID,IDLen 		;print id message
		print_out FifthID, DigitLength ;print id

		call NewLine 			; print new line
		
		print_out NAME,NAMELen 	;print name message
		print_out FifthName, NameLength ;print name

		call NewLine 			; print new line
		mov eax, 1              ; sys_exit syscall
        mov ebx, 0              ; no error
        int 80H                 ; kernel interrupt