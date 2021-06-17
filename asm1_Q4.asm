; Authoer: Sharon Diskin, ID: 205379993
; This program multiply two given binary N*N matrices

INCLUDE Irvine32.inc
INCLUDE asm1_q4_data.inc

.data
studentInfo BYTE "Sharon Diskin, ID: 205379993", 0 ; My info that will be displayed
resTextBlockA BYTE "Binary Matrix Multiplication", 0 ; The header that will be displayed
resTextBlockB BYTE "-----------------------------", 0
counter BYTE 0
currLine DWORD 0 
LineCounter BYTE N
sum BYTE 0

.code
main PROC

	; Printing student info
	mov edx, offset studentInfo
	call writeString
	call crlf
	call crlf

	; printing headline
	mov edx, offset resTextBlockA
	call writeString
	call crlf
	
	mov edx, offset resTextBlockB
	call writeString
	call crlf

	mov esi,OFFSET A ; Matrix A address
	mov ebx,OFFSET B ; Matrix B address
 
	mov ecx,N  ; init loop counter
	; init all other counters
	mov edx,0
	mov edi, 0
	mov eax, 0

	L1: ; Rows loop 
		mov di, 0   
		mov dl, 0   
		mov counter,0 
		add esi, currLine
		mov LineCounter,cl   
		mov cl, N*N+1
 
		L2: ;Cols counter
			cmp edi,N  ; we check if edi is equal to N
			jnz doLoopLogicAgain ; jnz--> meaning edi is not zero yet, we should keep multiplying elements of the matrix
  
			; When we get here meaning we finished claculating an element in the result matrix, we print this element:
			inc counter  
			mov di,0 ; clean edx before printing
			mov dl,counter 
			mov ah,0 ; clean eax before printing
			mov al,sum ; put the current sum for the print
			call writedec ; print matrix cell
			mov al,' '  ; prepare eax for space printing between cells
			call writechar  ; print space
			mov sum, 0 ; clear sum for the next round

			cmp cl,1 
			jz continue
   
			doLoopLogicAgain:
				mov al,[esi + edi] ; al will keep the next element in matrix A
				mov ah,[ebx + edx] ; ah will keep the next element in matrix B
				add edx,N  ; edx is increased by N for the next column
			    inc edi   ; we increase the counter
			    and al,ah ; if both al and ah are 1 we will get 1 as 'and' reault and that means the mult is 1
			    jz continue ; jz --> meaning we got a result that is not 1, that mean mult is 0, we will skip increasing sum
	     		inc sum 
			loop L2 ; end of col

			continue:
				loop L2 
			call crlf   ; we print enter because we finshied printing a complete row
			mov cl, LineCounter
			mov currLine, N  ; we init currLine
		loop L1 ; end of row

exit
main ENDP
end main