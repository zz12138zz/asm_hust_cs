.686P
.model flat, stdcall
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
system         PROTO C :VARARG
SearchGoods           PROTO stdcall :DWORD,:DWORD
StringCompare   PROTO stdcall
printf          PROTO C :VARARG
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS
EXTERN CantFindGoods:word
EXTERN InfomationOfGoodsWithoutRates:byte,lpFmtStrIn:byte
EXTERN lpFmtInt:byte,SLEEP:byte
.data
sellNum DD 0
EnterShipments DB '请输入出货量:',0
WrongShipments DB '出货量错误',0ah,0dh,0
.CODE
;SellGoods用于实现出货功能
;goodsInfo为商品信息首地址，sellNum为出货量，GoodsNum为商品数量
SellGoods proc goodsInfo:dword,GoodsNum:dword
    push eax
    push ebx
    push ecx
    push edi
    invoke SearchGoods,goodsInfo,GoodsNum
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