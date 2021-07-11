.686P     
.model flat, stdcall
ExitProcess PROTO STDCALL :DWORD
includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
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
WrongUserNameOrPassword DB '用户名或密码错误',0
CantFindGoods DB '未找到商品',0ah,0dh,0
WrongChoice DB '请输入正确的序号',0ah,0dh,0
Menu DB '1.查找指定商品并显示其信息',0ah,0dh,'2.出货',0ah,0dh,'3.补货',0ah,0dh,'4.计算商品的利润率',0ah,0dh,'9.退出',0ah,0dh,'请输入功能序号:',0
InfomationOfGoodsWithoutRates DB '%s ','进货价:%hd  ','销售价:%hd  ','进货量:%hd  ','已售数量:%hd  ',0ah,0dh,0
InfomationOfGoodsWithRates DB '%s ','进货价:%hd  ','销售价:%hd  ','进货量:%hd  ','已售数量:%hd  ','利润率:%hd %%',0ah,0dh,0
Choice dd 0
BossName  DB  'ZHENGZHOU',0  ;老板姓名
BossPassword  DB  'U201915115',0  ;密码（必须是自己的学号）
N    EQU   30
GA1   GOODS<'PEN',15,20,70,25,0>;商品1 名称,进货价、销售价、进货数量、已售数量,利润率（尚未计算）
GA2   GOODS<'PENCIL',2,3,100,50,0>
GA3   GOODS<'BOOK',30,40,25,5,0>
GA4   GOODS<'RULER',3,4,200,150,0>
GAN   GOODS N-4 DUP(<'TempValue' ,15,20,30,2,0>) ;除了4个已经具体定义了的商品信息以外,其他商品信息暂时假定为一样的。
LIST DD N DUP(0);存储排序后的地址
;tips1 db 'StringCompare测试',0ah,0dh,0
;tips2 db 'str1: ',0
;tips3 db 'str2: ',0
;tips4 db '登录成功',0ah,0dh,0
.STACK 200
.CODE
;主程序
main proc c
;登录
    invoke Login,offset BossName,offset BossPassword
    cmp eax,0
    je WrongEnter
;输出菜单
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


;功能1：查找商品信息
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

;功能2：出货
FUNC2:
    invoke SellGoods,offset GA1,N
    invoke system,offset SLEEP
    jmp DisplayMenu

;功能3：补货
FUNC3:
    invoke BuyGoods,offset GA1,N
    invoke system,offset SLEEP
    jmp DisplayMenu

;功能4：计算利润率并按利润率从高到低显示
FUNC4:
    mov esi,-1  ;重复执行程序时的计数器
    invoke winTimer,0
;重复执行程序
RepeatFunction4:
    inc esi
    cmp esi,10000
    je Display
    invoke CalculateRates,offset GA1,N,offset LIST
    invoke Sort,offset LIST,N
    jmp RepeatFunction4
;结束功能4的重复执行
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