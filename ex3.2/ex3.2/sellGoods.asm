.686P
.model flat,stdcall
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
SearchGoodsFunction           PROTO stdcall :DWORD,:DWORD
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
EXTERN CantFindGoods:BYTE,lpFmtInt:BYTE,InfomationOfGoodsWithoutRates:BYTE
.data
sellNum dd 0
EnterShipments DB '�����������:',0
WrongShipments DB '����������',0ah,0dh,0
.code
;SellGoods����ʵ�ֳ�������
;goodsInfoΪ��Ʒ��Ϣ�׵�ַ��sellNumΪ��������GoodsNumΪ��Ʒ����
sellGoods proc goodsInfo:dword,GoodsNum:dword
    push eax
    push ebx
    push ecx
    push edi
    invoke SearchGoodsFunction,goodsInfo,GoodsNum
    cmp eax,0
    je CantFindGoodsInFunction
    mov ebx,eax
FindGoodsInFunction:
    invoke printf,offset EnterShipments 
    invoke scanf,offset lpFmtInt,OFFSET sellNum
    mov ax,[ebx+14]
    mov cx,[ebx+16]
    sub ax,cx
    cmp ax,word ptr sellNum
    jae RightShipments
    invoke printf,offset WrongShipments
    jmp Exit
RightShipments:
    mov cx,word ptr sellNum
    add word ptr[ebx+16],cx
    invoke printf,offset InfomationOfGoodsWithoutRates,ebx,word ptr[ebx+10],word ptr[ebx+12],word ptr[ebx+14],word ptr[ebx+16]
    jmp Exit
CantFindGoodsInFunction:
    invoke printf,offset CantFindGoods
    jmp Exit
Exit:
    pop edi
    pop ecx
    pop ebx
    pop eax
    ret
SellGoods ENDP
end