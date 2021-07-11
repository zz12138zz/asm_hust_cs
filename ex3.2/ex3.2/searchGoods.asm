.686P     
.model flat, stdcall
ExitProcess PROTO STDCALL :DWORD
includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
system         PROTO C :VARARG
winTimer        PROTO stdcall :DWORD
Sort            PROTO :DWORD,:DWORD
stringCompare   PROTO stdcall
SellGoods PROTO :DWORD,:DWORD,:DWORD,:DWORD
CalculateRates PROTO :DWORD,:DWORD,:DWORD
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
PUBLIC GA1
PUBLIC LIST
PUBLIC CantFindGoods,lpFmtStrIn,lpFmtInt,InfomationOfGoodsWithoutRates
EXTERN GoodsInStorage:dword
GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS

.DATA
CLS db 'cls',0
SLEEP db 'pause',0
lpFmtStrIn DB '%s',0
lpFmtInt DB '%d',0
EnterGoodsName DB '请输入商品名称:',0
CantFindGoods DB '未找到商品',0ah,0dh,0
InfomationOfGoodsWithoutRates DB '%s ','进货价:%hd  ','销售价:%hd  ','进货量:%hd  ','已售数量:%hd  ',0ah,0dh,0
GoodsName DB 10 DUP(0)
N    equ   100
GA1   GOODS<'PEN',15,20,70,25,0>;商品1 名称,进货价、销售价、进货数量、已售数量,利润率（尚未计算）
GA2   GOODS<'PENCIL',2,3,100,50,0>
GA3   GOODS<'BOOK',30,40,25,5,0>
GA4   GOODS<'RULER',3,4,200,150,0>
GAN   GOODS N-4 DUP(<'TempValue' ,15,20,30,2,0>) ;除了4个已经具体定义了的商品信息以外,其他商品信息暂时假定为一样的。
LIST DD N DUP(0);存储排序后的地址
.CODE
;功能1：查找商品信息
SearchGoodsFunction proc goodsInfo:DWORD,goodsNum:DWORD
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
    call stringCompare
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
SearchGoodsFunction endp

searchGoods proc
    push ebx
    invoke SearchGoodsFunction,offset GA1,GoodsInStorage
    cmp eax,0
    je CantFindGoodsInFunction
    mov ebx,eax
;查找结果
    invoke printf,offset InfomationOfGoodsWithoutRates,ebx,word ptr[ebx+10],word ptr[ebx+12],word ptr[ebx+14],word ptr[ebx+16]
    invoke system,offset SLEEP
    pop ebx
    ret
CantFindGoodsInFunction:
    invoke printf,offset CantFindGoods
    invoke system,offset SLEEP
    pop ebx
    ret
searchGoods endp
end