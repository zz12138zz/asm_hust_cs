.686P
.model flat,stdcall
printf PROTO C :VARARG
scanf  PROTO C :VARARG
SearchGoodsFunction PROTO stdcall :DWORD,:DWORD
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
EXTERN CantFindGoods:BYTE,lpFmtInt:BYTE,InfomationOfGoodsWithoutRates:BYTE
.data
EnterReplenishment DB '请输入补货量:',0
deltaGoodsNum DD 0
.code
buyGoods proc goodsInfo:DWORD,goodsNum:DWORD
    push eax
    push ebx
    push ecx
    invoke SearchGoodsFunction,goodsInfo,goodsNum
    cmp eax,0
    je CantFindGoodsInFunction
    mov ebx,eax
;查找结果
RightReplenishment:
    invoke printf,offset EnterReplenishment
    invoke scanf,offset lpFmtInt,offset deltaGoodsNum
    mov cx,word ptr deltaGoodsNum
    add word ptr[ebx+14],cx
    invoke printf,offset InfomationOfGoodsWithoutRates,ebx,word ptr[ebx+10],word ptr[ebx+12],word ptr[ebx+14],word ptr[ebx+16]
    jmp Exit
CantFindGoodsInFunction:
    invoke printf,offset CantFindGoods
Exit:
    pop ecx
    pop ebx
    pop eax
    ret
BuyGoods endp
END
