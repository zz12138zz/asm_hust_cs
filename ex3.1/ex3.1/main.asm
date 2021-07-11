.686P     
.model flat, stdcall
ExitProcess PROTO STDCALL :DWORD
includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
system         PROTO C :VARARG
winTimer        PROTO stdcall :DWORD
Login           PROTO stdcall :DWORD,:DWORD
SearchGoods           PROTO stdcall :DWORD,:DWORD
BuyGoods           PROTO stdcall :DWORD,:dword
Sort            PROTO :DWORD,:DWORD
StringCompare   PROTO
SellGoods PROTO stdcall :DWORD,:dword
CalculateRates PROTO :DWORD,:DWORD,:DWORD
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

PUBLIC lpFmtStrIn,BossName,BossPassword
PUBLIC CantFindGoods,InfomationOfGoodsWithoutRates
PUBLIC InfomationOfGoodsWithoutRates,SLEEP,CantFindGoods
PUBLIC lpFmtInt

.DATA
CLS db 'cls',0
SLEEP db 'pause',0
lpFmtStrIn DB '%s',0
lpFmtInt DB '%d',0
WrongUserNameOrPassword DB '�û������������',0
CantFindGoods DB 'δ�ҵ���Ʒ',0ah,0dh,0
WrongChoice DB '��������ȷ�����',0ah,0dh,0
Menu DB '1.����ָ����Ʒ����ʾ����Ϣ',0ah,0dh,'2.����',0ah,0dh,'3.����',0ah,0dh,'4.������Ʒ��������',0ah,0dh,'9.�˳�',0ah,0dh,'�����빦�����:',0
InfomationOfGoodsWithoutRates DB '%s ','������:%hd  ','���ۼ�:%hd  ','������:%hd  ','��������:%hd  ',0ah,0dh,0
InfomationOfGoodsWithRates DB '%s ','������:%hd  ','���ۼ�:%hd  ','������:%hd  ','��������:%hd  ','������:%hd %%',0ah,0dh,0
Choice dd 0
BossName  DB  'ZHENGZHOU',0  ;�ϰ�����
BossPassword  DB  'U201915115',0  ;���루�������Լ���ѧ�ţ�
N    EQU   30
GA1   GOODS<'PEN',15,20,70,25,0>;��Ʒ1 ����,�����ۡ����ۼۡ�������������������,�����ʣ���δ���㣩
GA2   GOODS<'PENCIL',2,3,100,50,0>
GA3   GOODS<'BOOK',30,40,25,5,0>
GA4   GOODS<'RULER',3,4,200,150,0>
GAN   GOODS N-4 DUP(<'TempValue' ,15,20,30,2,0>) ;����4���Ѿ����嶨���˵���Ʒ��Ϣ����,������Ʒ��Ϣ��ʱ�ٶ�Ϊһ���ġ�
LIST DD N DUP(0);�洢�����ĵ�ַ
;tips1 db 'StringCompare����',0ah,0dh,0
;tips2 db 'str1: ',0
;tips3 db 'str2: ',0
;tips4 db '��¼�ɹ�',0ah,0dh,0
.STACK 200
.CODE
;������
main proc c
;��¼
    invoke Login,offset BossName,offset BossPassword
    cmp eax,0
    je WrongEnter
;����˵�
DisplayMenu:
    invoke system,offset CLS
    invoke printf,offset Menu
    invoke scanf,offset lpFmtInt,addr Choice
    cmp Choice,1
    je FUNC1
    cmp Choice,2
    je FUNC2
    cmp Choice,3
    je FUNC3
    cmp Choice,4
    je FUNC4
    cmp Choice,9
    je EXIT
    invoke printf,offset WrongChoice
    invoke system,offset SLEEP
    jmp DisplayMenu


;����1��������Ʒ��Ϣ
FUNC1:
    invoke SearchGoods,offset GA1,N
    cmp eax,0
    jne FoundGoods
    invoke printf,offset CantFindGoods
    invoke system,offset SLEEP
    jmp DisplayMenu
FoundGoods:
    invoke printf,offset InfomationOfGoodsWithoutRates,eax,word ptr[eax+10],word ptr[eax+12],word ptr[eax+14],word ptr[eax+16]
    invoke system,offset SLEEP
    jmp DisplayMenu

;����2������
FUNC2:
    invoke SellGoods,offset GA1,N
    invoke system,offset SLEEP
    jmp DisplayMenu

;����3������
FUNC3:
    invoke BuyGoods,offset GA1,N
    invoke system,offset SLEEP
    jmp DisplayMenu

;����4�����������ʲ��������ʴӸߵ�����ʾ
FUNC4:
    mov esi,-1  ;�ظ�ִ�г���ʱ�ļ�����
    invoke winTimer,0
;�ظ�ִ�г���
RepeatFunction4:
    inc esi
    cmp esi,10000
    je Display
    invoke CalculateRates,offset GA1,N,offset LIST
    invoke Sort,offset LIST,N
    jmp RepeatFunction4
;��������4���ظ�ִ��
Display:
    mov edi,0
LoopDisplayInfomation:
    cmp edi,N
    jge FinishFunction_4
    mov ebx,LIST[edi*4]
    invoke printf,offset InfomationOfGoodsWithRates,ebx,[ebx].GOODS.BUYPRICE,[ebx].GOODS.SELLPRICE,[ebx].GOODS.BUYNUM,[ebx].GOODS.SELLNUM,[ebx].GOODS.RATE
    inc edi
    jmp LoopDisplayInfomation
FinishFunction_4:
    invoke winTimer,1
    invoke system,offset SLEEP
    jmp DisplayMenu


WrongEnter:
    invoke printf,offset WrongUserNameOrPassword
    jmp EXIT
CantFindGoodsInFunction:
    invoke printf,offset CantFindGoods
    invoke system,offset SLEEP
    jmp DisplayMenu
EXIT:
    invoke ExitProcess,0
main endp
END
;main proc c
;invoke printf,offset tips1
;invoke printf,offset tips2
;invoke scanf,offset lpFmtStrIn,offset GA1
;invoke printf,offset tips3
;invoke scanf,offset lpFmtStrIn,offset GA2
;push offset GA1
;push offset GA2
;call StringCompare
;add esp,8
;invoke printf,offset lpFmtInt,eax
;invoke ExitProcess,0
;main endp
;END