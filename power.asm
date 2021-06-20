INCLUDE Irvine32.inc

.data  
COEF SWORD 3, 0, -3, 10
POW BYTE 2, 4, 2, 1
N = 4
.code

calcPow proc uses ecx ebx
	POWNUM = 16
	push ebp
	mov ebp, esp

	mov ecx, [ebp+POWNUM]
	xor ax, ax 
	mov ax, 1 ; return value will be stored in eax

	xor ebx, ebx
	mov bx, 8
	L1:
		mul bx
	loop L1

	mov esp, ebp
	pop ebp
	ret 1
calcPow endp

RVecMutl proc uses esi edi cx
	LEN = 18
	PV = LEN + 4
	CV = PV + 4
	push ebp
	mov ebp, esp

	push ebx
	mov ebx, 0
	push edx

	mov esi, [ebp+CV] ; esi = coef offset
	mov edi, [ebp+PV] ; edi = power offset
	mov cx, [ebp+LEN]

	cmp cx, 0
	je fin

	add esi, 2 ; we will send recurivly the next element in the coef array
	add edi, 1 ; we will send the next element of pow array
	dec cx

	push esi
	push edi
	push ecx
	call RVecMutl
	
	sub esi, 2
	sub edi, 1
	mov edx, eax ; we push the current value of eax so we won't lose it
	movzx ebx, byte ptr[edi]
	push ebx
	call calcPow

	mov bx, ax
	shl edx, 16
	mov eax, edx
	mov ax, bx
	imul sword ptr[esi] ; we multiply the reult of the power with the matching element from coef array
	mov eax, edx ; we restore the value of eax 
	add eax, ebx ; eax, will store the final return value will be added with the multiplication we just calculated
	jmp Lend

	fin:
		mov eax, 0

	Lend:
		pop edx
		pop ebx
		mov esp, ebp
		pop ebp
		ret 10

RVecMutl endp

main PROC
	push offset coef
	push offset pow
	push dword ptr N
	call RVecMutl
	call writeDec
	call crlf

		exit
main ENDP    
END main
