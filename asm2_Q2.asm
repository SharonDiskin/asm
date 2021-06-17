; Written by: Sharon Diskin, 205379993
; This program recieve a string with nested brackets. Each time the program finds a pair of bracket it reverses the string inside the pair of bracket
; The program scans the bracket inside out - it starts with the the most inner pair of brackets
; Example - input: [4[12]3] --> output: 3124

include irvine32.inc
include asm2_q2_data.inc

.data
studentInfo BYTE "Sharon Diskin, ID: 205379993", 0 ; my info that will be displayed
textBlockA byte "Please enter you string: ", 0 ; First headline printed to the screen
textBlockB byte "The final string: ", 0 ; Second headline printed to the screen
tmpString byte 80 dup(0)

.code
main PROC

; Print student info
	mov edx, offset studentInfo
	call writestring
	call crlf

; Print first headline 
	mov edx, offset textBlockA
	call writestring

	mov esi, offset BracketStr ; ESI will point to BracketStr
	mov edi, offset OpoStr ;EDI will point to OpoStr

; This loop will recieve chars from the user until the user hit '$'
	ReadChars: 
		call ReadChar
		mov [esi], al
		cmp al, '$'
		je PrintInputString ; If al is '$', no need to increase ESI, we immedietly jump to the next step which in printing the input string
		inc esi
		loop ReadChars

; We print the input string
	PrintInputString: 
		mov esi, offset BracketStr ; We restore ESI to point at the begining of the string
		mov edx, esi ; We print the string with '$' in the end like in the example
		call writestring
		call crlf

; This loop insert each char of the string to the stack until it finds a ']' char and when it does, it skips the']'
	FindClosingBracket: 
		mov bl, byte ptr[esi] ; We move the next char of the string to a register so we can "work" on this char
		movzx bx, bl ; We change the from 8-bit to 16-bit so we later push it to the stack
		cmp bx, '$'  ; We check if the char is '$' - if it is meaning got to the end of string and we need to skip to the end and print the string
		jz EndProgram
		cmp bx, ']' ; We check if the char is ']' - if it is we skip the char
		jz SkipClosingBracket
		push bx ; If we got here meaning the char is not ']' - we push the char to the stack
		inc esi
		loop FindClosingBracket

	SkipClosingBracket:
		inc esi ; We just increase ESI without pushing ']' stack
		mov edi, offset OpoStr ; We want to re-initalize EDI to point to the beggining of OpoStr

; This loop places the chars from the stack to the string
	PutCharsInResString: 
		pop bx ; We take the next char from the stack
		cmp bx, '[' ; If the char is '[' we ignore this char
		jz SkipOpeningBracket
		mov byte ptr [edi], bl ; Else, the char is not '[' - we place it in the string
		inc edi
		loop PutCharsInResString

	SkipOpeningBracket:
		mov edi, offset OpoStr

; This loop pushs back the chars to the stack, this way we reverse the string each time
	ReturnToStack:
		cmp byte ptr [edi], 0  ; If the pointer point to '0' meaning we scanned all the elements in the string inner string, we loop and do the process again
		jz findClosingBracket
		mov bx, [edi]
		push bx
		inc edi
		loop ReturnToStack

; Here we print the result string
	EndProgram: 
		mov edx, offset textBlockB
		call writeString
		mov edx, offset OpoStr
		call writeString

exit
main ENDP
END main
