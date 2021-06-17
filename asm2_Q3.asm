; Written by: Sharon Diskin
; This program gets a matrix of words, convert it to a binary matrix, multiply the matrix by itself and converts the result to a string.

include Irvine32.inc
include asm2_q3_data.inc

.data
studentInfo BYTE "Sharon Diskin, ID: 205379993", 0 ; my info that will be displayed

; All the headers that will be displayed to the screen: 
textBlockA BYTE "The original string is:", 0 
textBlockB BYTE "The computed string is:", 0 

tempMask byte 10000000b ; We save a copy of the mask, we will use it each loop
defMask byte 10000000b ; 8 bit mask
BM byte N*N dup(0) ; Binary matrix
BM2 byte N*N dup(0) ; Binary matrix after multiplication

.code

makemat PROC USES esi edi
	mov ecx, N 
	L1: ; This loop runs on each word (runs os rows of the matrix)
		mov ebx, ecx
		mov ecx, N/8
		L2: ; This loop runs on each letter (runs on the cols of the matrix)
			mov eax, ecx
			mov ecx, N/4
			L3: ; This loop runs on each bit in a letter
				mov dl, byte ptr[esi] ; We keep each letter in dl
				and dl, tempMask ; We check if the leftest bit of the letter is '1'
				jnz insertOne ; If the it is one we jump to insertOne and place one in the right place in the bit matrix
				continue:
				inc edi 
				shr tempMask, 1 ; We move the bit right to check the next bit of the letter
			 loop L3
			 mov dh, defMask 
			 mov tempMask, dh ; We restore the mask to each beginning state
			 mov ecx, eax ; We restore ecx
			inc esi
		loop L2
		mov ecx, ebx ; Restore ecx
	loop L1
	ret

	insertOne:
	add byte ptr [edi], 1
	jmp continue

makemat ENDP


multmat proc USES esi edi ecx ebx edx
	mov ecx, N ; Initalize amount of rows
	mov ebx, 0 ; Rows pcounter
	L1: ; This loop runs on the row of the matrix
		push ecx
		mov ecx, N ; Init amount of cols
		mov edx, 0 ; Cols counter
		L2: ; This loop runs on the cols of the matrix
			push ecx
			push edx
			mov eax, ebx
			mov ecx, N
			mul ecx ; edx:eax
			add eax, esi
			pop edx

			push ebx
			mov ebx, edx
			add ebx, esi

			push edx
			mov dl, 0  ; dl initialize to zero and will be used for the 'or' that replaces the '+' in binary matrix multiplication
			mov ecx, N
			L3: ; This loop multiply row by cols
				push ecx ; We store ecx in order we can use 'cl' register
				mov cl, [eax] ; eax points to row
				and cl, [ebx] ; ebx point to col --> The Logic behin the 'and' if to check if both of the elemens we point at are '1'
				or dl, cl ; If the both [eax] and [ebx] were '1' the or result will be '1', else or result will be '0'
				pop ecx ; we restore ecx
				inc eax ; we increase the pointer that points at the row by 1
				add ebx, N ; we increase the pointer that points at col by 32
				loop L3
			mov [edi], dl ; We store the resulte in the right cell in the result matrix
			inc edi ; We inc the pointer of result matrix to point at the next cell
			pop edx
			pop ebx
			pop ecx
			inc edx ; Inc col num
			loop L2
		pop ecx ; Restore ecx
		inc ebx ; Inc row num
		loop L1
	ret
multmat endp

makestr PROC USES esi edi
	mov ecx, N
	L1: ; This loop runs on rows - there are 32 row in the matrix
		mov ebx, ecx
		mov ecx, N/8
		L2: ; This loop "divides" the 32 bytes in the matrix to 4 groups of 8 - each group of 8 bytes represent a lettet in a word
			mov ebp, ecx
			mov ecx, N/4
				L3: ; This loop runs on every 8 bytes and puts together a word from this 8 bytes
					mov dl,byte ptr [esi]
					dec ecx ; We decreament ecx because we want to use 'cl' register in the 'shl' operator but need it to be always 1 less than the round number
					shl dl, cl ; We shift left the byte to the place it represents
					inc ecx ; We restore ecx to it's former start
					movzx eax,dl 
					or [edi], eax ; We actulley place the "byte" as a bit in it's right place
					inc esi
				loop L3
			inc edi
			mov ecx, ebp
		loop L2
		mov ecx, ebx
	loop L1
	mov byte ptr[edi], 0
	ret
makestr ENDP


printmat PROC USES edi ; This subroutine print a matrix. No need to explain simple logic
	mov ecx, N
	L1: ; This loop runs on rows - there are 32 rows in the matrix
		mov ebx, ecx
		mov ecx, N
		L2: ; This loop runs on cols - there a 32 cols in the matrix
			movsx eax, byte ptr [edi]
			call Writedec
			mov al, ' '
			call writechar
			inc edi
		loop L2
		mov ecx, ebx
		call crlf
	loop L1
	call crlf
	ret

printmat ENDP

main PROC
; Print my info
	mov edx, offset studentInfo
	call writestring
	call crlf
	call crlf

; Print header + original string 
	mov edx, offset textBlockA
	call writestring
	call crlf
	mov edx, offset M
	call writestring
	call crlf
	call crlf

; Create bit matrix
	mov esi, offset M
	mov edi, offset BM
	call makemat

; Create mltiplication of bit matrix
	mov esi, offset BM
	mov edi, offset BM2
	call multmat

; Create computed string
	mov esi, offset BM2
	mov edi, offset M2
	call makestr 

; Print header + computer string
	mov edx, offset textBlockB
	call writestring
	call crlf
	mov edx, offset M2
	call writestring
	call crlf

exit
main ENDP
END main