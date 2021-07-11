.686P
.model flat,stdCall
.code
myimul macro x1,x2,x3
    push edi
    push esi
    movsx edi,word ptr x1
    movsx esi,word ptr x2
    imul edi,esi
    mov x3,edi
    pop esi
    pop edi
    endm
;Calculate用于计算全部商品的利润率
;GoodsInfo为商品信息首地址，GoodsNum为商品数量，ListDoc为商品地址记录表（排序用）
calculateRates proc GoodsInfo:dword,GoodsNum:dword,ListLoc:dword
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov edi,ListLoc
    mov ebx,GoodsInfo
    imul esi,GoodsNum,20
    add esi,GoodsInfo
Calculate:     ;计算利润率
    cmp ebx,esi
    jge FinishCalculatingRates
    myimul [ebx+12],[ebx+16],eax    ;eax存放收入
    myimul [ebx+10],[ebx+14],ecx    ;ecx存放成本
    sub eax,ecx ; eax存放利润
    imul eax,100
    mov edx,eax
    shr edx,16
    idiv cx
    mov sword ptr[ebx+18],sword ptr ax
    mov [edi],ebx
    add edi,4
    add ebx,20
    jmp Calculate
FinishCalculatingRates:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CalculateRates endp
end