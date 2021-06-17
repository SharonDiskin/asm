; Authoer: Sharon Diskin, ID: 205379993
; This program read a string and a char from a file, and print the location in the string in which the char appears, and number of appearance

INCLUDE Irvine32.inc
INCLUDE asm1_q3_data.inc

.data
studentInfo BYTE "Sharon Diskin, ID: 205379993", 0 ; My info that will be displayed

; The content that will be displayed to the screen
resString BYTE "The string is : ", 0
resCharBlockA BYTE "The char ", 0
resCharBlockB BYTE " appears ", 0
resCharBlockC BYTE " times ", 0
resCharBlockD BYTE "in the following places: ", 0

Len = LENGTHOF source ; Length of source string
resultArr BYTE LEN DUP (0) ; Result array, allocated in the length of the source string

.code
main PROC

	; Printing student info
	mov edx, offset studentInfo
	call writeString
	call crlf

	mov esi, offset source ; esi will track the address of current elemnt in the source string
	mov bl, 0 ; bl will track the number of element we currently on in the source string
	mov edi, 0	; edi will track the number of elemets in the result array
	mov al, xchar ; we keep the data char in al
	mov ecx, Len-1 ; ecx, the counter of the main loop recieves the length of the source string, in which we will iterate over

L1:
	mov ah, [esi] ; ah will store the char in the the esi currenrly point at
	inc esi ; we incremeant esi to point to the next address
	inc bl ; we inc bl to count the next location
	cmp al, ah ; we compare al (the data char) and ah (the current char)
	je addToRes ; if the comparasion worked, we will jump to 'addToRes'
	loop L1

	cmp ecx, 0 ; we check if loop counter equales to zero - if it is we will skip 'addToRes'
	je skip

	addToRes:
	dec bl ; we dec bl since it already counts the next location
	mov [resultArr+edi], bl ; we keep the current location in the result array
	inc edi ; inc edi, which is num of appearance counter
	inc bl ; we recover bl to it's former state by increasing it
	loop L1

	skip:
	; here we print the result to the screen
	mov edx, offset resString
	call writeString
	mov edx, offset source
	call writeString
	call crlf
	mov edx, offset resCharBlockA
	call writeString
	mov al, xchar
	call writeChar
	mov edx, offset resCharBlockB
	call writeString
	mov eax, edi
	call writeDec
	mov edx, offset resCharBlockC
	call writeString

	; we check if the number of appearances of the char is zero - if it is we skip to the end
	cmp edi, 0
	je exitProg

	; if we got to here, meaning the number of appearnces if greater than zero - we print the last bock of text 
	mov edx, offset resCharBlockD
	call writeString

	; we prepeare the for the array printing loop
	mov esi, offset resultArr ; we keep result arr in esi
	mov ecx, edi ; we keep number of elements in the loop counter (ecx)
	dec edi ; we decreament edi by 1 since in L1 loop it increamnetd 1 extra time
	add esi, edi ; we add edi to esi, so that the start address will be the last element
		
L2:
	movsx eax, BYTE ptr[esi] ; we keep that current element in eax
	call writeDec ; print the curr element
	mov al, ' ' 
	call writeChar ; print the space between he elements
	dec esi ; we dec the address we are currently pointing at
	loop L2
	
	exitProg:
		exit

main ENDP
END main