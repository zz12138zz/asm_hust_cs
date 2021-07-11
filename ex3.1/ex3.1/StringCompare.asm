.686P     
.model flat, stdcall
.CODE
;StringCompare为字符串比较函数
StringCompare proc
	push ebp
	mov ebp,esp
	push ebx
	push ecx
	push edx
	mov ebx,[ebp+8]
	mov ecx,[ebp+12]
Compare:
	mov dl,[ebx]
	cmp dl,[ecx]
	jne NotEqual
	cmp dl,0
	je Equal
	inc ebx
	inc ecx
	jmp Compare
NotEqual:
	mov eax,1
	jmp Exit
Equal:
	mov eax,0
	jmp Exit
Exit:
	pop edx	
    pop ecx
	pop ebx
	pop ebp
	ret
StringCompare endp
end
