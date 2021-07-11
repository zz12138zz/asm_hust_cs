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
printf PROTO C :VARARG
.data
InfomationOfGoodsWithRates DB '%s ','进货价:%hd  ','销售价:%hd  ','进货量:%hd  ','已售数量:%hd  ','利润率:%hd %%',0ah,0dh,0
.CODE
;sort用于对list中的地址指向的元素基于利润率进行排序
;list为存放了商品信息地址的数组首地址，num为商品数量
sort proc list:dword,num:dword
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
;选择排序
BigLoop:
    cmp edi,EndLoop
    je Exit      ;排序结束
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
sort endp

sortAndDisplay PROC LIST:DWORD,GoodsNum:DWORD
    push esi
    push ebx
invoke sort,LIST,GoodsNum
    cmp eax,1
    je Exit
    mov esi,0
    mov edi,GoodsNum
    mov eax,LIST
LoopDisplayInfomation:
    cmp esi,edi
    jge Exit
    mov ebx,[eax][esi*4]
    push eax
    invoke printf,offset InfomationOfGoodsWithRates,ebx,[ebx].GOODS.BUYPRICE,[ebx].GOODS.SELLPRICE,[ebx].GOODS.BUYNUM,[ebx].GOODS.SELLNUM,[ebx].GOODS.RATE
    pop eax
    inc esi
    jmp LoopDisplayInfomation
Exit:
    pop ebx
    pop esi
    ret
sortAndDisplay endp
END