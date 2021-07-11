.686P     
.model flat, stdcall
ExitProcess PROTO STDCALL :DWORD
includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
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
EnterGoodsName DB '��������Ʒ����:',0
CantFindGoods DB 'δ�ҵ���Ʒ',0ah,0dh,0
InfomationOfGoodsWithoutRates DB '%s ','������:%hd  ','���ۼ�:%hd  ','������:%hd  ','��������:%hd  ',0ah,0dh,0
GoodsName DB 10 DUP(0)
N    equ   100
GA1   GOODS<'PEN',15,20,70,25,0>;��Ʒ1 ����,�����ۡ����ۼۡ�������������������,�����ʣ���δ���㣩
GA2   GOODS<'PENCIL',2,3,100,50,0>
GA3   GOODS<'BOOK',30,40,25,5,0>
GA4   GOODS<'RULER',3,4,200,150,0>
GAN   GOODS N-4 DUP(<'TempValue' ,15,20,30,2,0>) ;����4���Ѿ����嶨���˵���Ʒ��Ϣ����,������Ʒ��Ϣ��ʱ�ٶ�Ϊһ���ġ�
LIST DD N DUP(0);�洢�����ĵ�ַ
.CODE
;����1��������Ʒ��Ϣ
SearchGoodsFunction proc goodsInfo:DWORD,goodsNum:DWORD
    push ebx
    push edi
    invoke printf,offset EnterGoodsName
    invoke scanf,offset lpFmtStrIn,offset goodsName
    mov ebx, goodsInfo  ;ebx���ڴ����Ʒ��Ϣ���׵�ַ
    mov edi,goodsNum
    imul edi,20
    add edi,goodsInfo
;�����Ʋ���
SearchGoodsInFunction_1:    ;������Ʒѭ��
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
;���ҽ��
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
;���ҽ��
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