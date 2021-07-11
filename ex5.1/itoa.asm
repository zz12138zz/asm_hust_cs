.686P
.model flat,stdcall
.stack 200
.code
itoa proc value:word,string:dword
	push eax
	push ebx
	push ecx
	push edx
	push esi
	mov ax,value
	mov esi,string
	mov ebx,10
	mov ecx,0
	cmp ax,0
	jge itoa_unsigned
	neg ax
	mov byte ptr[esi],'-'
	inc esi
itoa_unsigned:
	mov edx,0
	div ebx
	push edx
	inc ecx
	cmp ax,0
	jne itoa_unsigned
itoa_save:
	pop edx
	add dl,30H
	mov [esi],dl
	inc esi
	dec ecx
	jnz itoa_save
	mov [esi],byte ptr 0
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
itoa endp
end