.686P
GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS
.model flat, stdcall
.CODE
LoadData proc GoodsInfo:dword,GoodsNum:dword,ListLoc:dword
    push edi
    push ebx
    push esi
    mov edi,ListLoc
    mov ebx,GoodsInfo
    imul esi,GoodsNum,20
    add esi,GoodsInfo
LoopLoad:
    cmp ebx,esi
    jge FinishLoad
    mov [edi],ebx
    add edi,4
    add ebx,20
    jmp LoopLoad
FinishLoad:
    pop edi
    pop ebx
    pop esi
    ret
LoadData endp
;sort���ڶ�list�еĵ�ַָ���Ԫ�ػ��������ʽ�������
;listΪ�������Ʒ��Ϣ��ַ�������׵�ַ��numΪ��Ʒ����
Sort proc list:dword,num:dword
    local EndLoop :dword
    push edx
    push edi
    push eax
    push ebx
    push ecx
    push esi
    mov eax,num
    dec eax
    mov EndLoop,eax
    mov esi,list
    mov edx,[esi]
    cmp edx,0
    je NoRates
	mov edx,1
    mov edi,0
;ѡ������
BigLoop:
    cmp edi,EndLoop
    je Exit      ;�������
SmallLoop:
    mov ebx,[esi][edx*4]
    mov eax,[esi][edi*4]
    mov cx,[ebx].GOODS.RATE
    cmp [eax].GOODS.RATE,cx
    jl CHANGE
CONTINUE:
    inc edx
    cmp edx,num
    jl SmallLoop
    inc edi
    mov edx,edi
    add edx,1
    jmp BigLoop
CHANGE:
    mov ecx,[esi][edx*4]
    xchg [esi][edi*4],ecx
    mov [esi][edx*4],ecx
    jmp CONTINUE
NoRates:
    pop esi
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop edx
    mov eax,1
    ret
Exit:
    pop esi
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop edx
    mov eax,0
    ret
Sort endp
end