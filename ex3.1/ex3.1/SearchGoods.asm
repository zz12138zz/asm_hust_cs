.686P     
.model flat, stdcall
ExitProcess PROTO STDCALL :DWORD
includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
StringCompare   PROTO stdcall
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
EXTERN lpFmtStrIn:byte,SLEEP:byte

GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS
.data
EnterGoodsName DB '请输入商品名称:',0
goodsName db 10 dup(0)
.CODE
;功能1：查找商品信息
SearchGoods proc goodsInfo:DWORD,goodsNum:DWORD
    push ebx
    push edi
    invoke printf,offset EnterGoodsName
    invoke scanf,offset lpFmtStrIn,offset goodsName
    mov ebx, goodsInfo  ;ebx用于存放商品信息的首地址
    mov edi,goodsNum
    imul edi,20
    add edi,goodsInfo
;按名称查找
SearchGoodsInFunction_1:    ;控制商品循环
    cmp ebx, edi
    jg CantFindGoodsInFunction
    push ebx
    push offset goodsName
    call StringCompare
    add esp,8
    cmp eax,0
    je FindGoods
    add ebx,20
    jmp SearchGoodsInFunction_1

;查找结果
FindGoods:
    mov eax,ebx
    pop edi
    pop ebx
    ret
CantFindGoodsInFunction:
    mov eax,0
    pop edi
    pop ebx
    ret
SearchGoods endp
end