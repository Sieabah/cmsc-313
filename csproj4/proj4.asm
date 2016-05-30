;Name: Christopher Sidell
;Date: 10/30/2014
;Section: 01
; Project4
; This project asks for a number and bases to transfer it to

; Proceedures:
;		ClearBuffer - Line 100 - clears entire buffer for new input
; Macros:
; 		get_number - line 45 - gets number through scanf
;		print_string - line 54 - prints string to screen
;		file_string -line 62 - prints string to file
;		print_number - line 71 - prints number to screen
; 		store_registers - line 80 - stores primary 4 registers
; 		restore_registers - line 90 - restores primary 4 registers

[SECTION .data]

	WriteCode: db "w",0 		;operation code for writing to file

	Iformat: db "%d",0 			;string for single digit format

	NewLine: db "",10,0 		;newline
	PrompMessage: db "Enter a number between 0 and 255: ",0 ;Printed PrompMessage
	BaseMessage: db "Enter a base between 2 and 9: ",0 ;prompt

[SECTION .bss]

	BUFFLEN equ 9 				; max length of buffer
	Buff resb BUFFLEN 			; allocate 10 bytes for input

	FILELEN equ 9001			; max length of file
	Filename resb FILELEN 		; allocate 9001 bytes for filename

	File resb 4 				;file holder

	Number resb 4 				; number
	Printer resb 4 				; number
	Base resb 4 				; base to go to

[SECTION .text]

;get_number
;gets number through scanf
%macro get_number 1
	push %1 				; push number reference
	push Iformat 				; push integer format string
	call scanf 					; get number
	add esp,8 					; cleanup
%endmacro

;print_string
;prints string to screen, pass string
%macro print_string 1 	
	push %1 				;put string in stack
	call printf 			;print it
	add esp,4 				;cleanup
%endmacro

;file_string
;prints string to file created at beginning of program, pass string
%macro file_string 1 	
	push %1 				;put string in stack
	push dword [File]		;push file
	call fprintf 			;print it
	add esp,8 				;cleanup
%endmacro

;print_number
;prints number to screen ,pass number
%macro print_number 1
	push dword [%1] 		;push number
	push Iformat			;push format
	call printf 			;print it 
	add esp,8 				;cleanup
%endmacro

;store_registers
; store primary registers on stack
%macro store_registers 0 		; define macro
	push eax 					; store eax on stack
	push ebx 					; store ebx on stack
	push ecx 					; store ecx on stack
	push edx 					; store edx on stack
	push esi 					; take esi from stack
%endmacro 						; end macro

;restore_registers
; restore primary registers from
%macro restore_registers 0 		; define macro
	pop esi 					;; take esi from stack
	pop edx 					; take edx from stack
	pop ecx 					; take ecx from stack
	pop ebx 					; take ebx from stack
	pop eax 					; take eax from stack
%endmacro 						; end macro

;Clear buffer (proceedure)
;clears entire buffer for more input
ClearBuffer:
	
	store_registers 			; KEEP ALL THE REGISTERS
	
	mov ecx, BUFFLEN 			; iterate for length of buffer
	mov esi,Buff 				; pointer to buffer

	.loop: 						; loop to kill buffer
		mov byte [esi],48 		; kill char 
		inc esi					; move to next char in Buff

		dec ecx					;ITERATE
		cmp ecx,0 				;DID WE FINISH?!
	jne .loop 					;If no, go back

	dec esi
	mov byte [esi],0 			; kill char 

	restore_registers 			; RESTORE THEM

	ret

extern scanf 				;import scanf
extern printf 				;import printf
extern fprintf  			;import fprintf
extern fopen 				;import fopen
extern fclose				;import fclose

global main 

main:							; main()
	mov eax, [ebp+16]  			; Get pointer to args
	mov eax, [eax+4] 			; get 2nd arg

 	push WriteCode 				;open for write
 	push eax 					;push filename
 	call fopen 					;call fopen 
 	add esp,8 					;cleanup

 	push ebp ; Set up stack frame for debugger
	mov ebp,esp
	push ebx ; Program must preserve EBP, EBX, ESI, & EDI
	push esi
	push edi

 	mov [File],eax 				;keep file pointer

GetNum: 						; Get initial number
	print_string PrompMessage 	;print message
	get_number Number 			; get init number 

	cmp dword [Number],0 		;compare Num < 0
	jb GetNum 					;get num again

	cmp dword [Number],255 		;compare num > 255
	ja GetNum 					; get num again

GetBase:
	print_string BaseMessage 	;print message 
	get_number Base 			;get base number

	cmp dword [Base],0 			;compare exit condition
	je Exit 					;exit

	cmp dword [Base],2 			;base < 2
	jb GetBase 					;true, get base again

	cmp dword [Base],9 			;base > 9
	ja GetBase 					;true, get base again

	call ConvertNum 			;convert number
	jmp GetBase 				;get base again

ConvertNum:
	call ClearBuffer 			;put zeros and null
	mov ecx,Buff+7 				;go 7 chars in 
	mov eax,[Number] 			; get number
	mov ebx,[Base] 				;get base 

GoAgain:
	xor edx,edx 				;clear modulus
 
 	div ebx						;divide eax by ebx

	add dl,48 					;add 48 for char 0

	mov [ecx],dl 				;move modulus into char
	dec ecx 					;decrement ecx

	sub dl,48 					;add 48 for char 0

	cmp eax,0 					;done?
	jne GoAgain 				;if not 0, GO BACK

	print_string Buff 			;print number to screen
	print_string NewLine 		;print newline

	file_string Buff 			;print to file
	file_string NewLine 		;print to file

	ret

Exit:	
	push dword [File] 			;get file pointer
	call fclose 				;close file
	add esp,4 					;clean up

	pop edi ; Restore saved registers
	pop esi
	pop ebx
	mov esp,ebp ; Destroy stack frame before returning
	pop ebp
	ret ; Return control to to the C shutdown code