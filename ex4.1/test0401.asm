

;  程序功能：每隔约1秒钟 显示一次当前的时间（时：分：秒）
;            按任意键结束本程序的运行
;        为了更好的展示正在运行的程序被打断，时间的显示和字符串的显示交杂在一起

;  涉及的知识点：
;  (1) 8号中断
;  (2) 扩充8号中断的中断处理程序
;  (3) 中断处理程序驻留在内存
;  (4) 获取系统当前时间
;  (5) 在屏幕指定位置显示串

.386
STACK  SEGMENT  USE16  STACK
       DB  200  DUP (0)
STACK  ENDS

CODE   SEGMENT USE16
       ASSUME CS:CODE, SS:STACK
  SIGN DW 0CCCCH
  OLD_INT  DW  ?, ?
  NEW_INT DW ?,?
  COUNT  DB  18
  HOUR   DB  ?, ?, ':'
  MIN    DB  ?, ?, ':'
  SEC    DB  ?, ?
  BUF_LEN = $ - HOUR
  CURSOR   DW  ?
  installed DB 'Already Installed',0ah,0dh,'$'
  prompt db 'Intall Complete!',0ah,0dh,'$'

; -------------------------------------NEW08H----------------------------------------------------
; 扩充的 8号中断处理程序  
NEW08H  PROC  FAR
        PUSHF
        CALL  DWORD  PTR  OLD_INT
        DEC   COUNT
        JZ    DISP
        IRET
  DISP: MOV  COUNT,18
        STI
        PUSHA
        PUSH  DS
        PUSH  ES
        MOV   AX, CS
        MOV   DS, AX
        MOV   ES, AX

        CALL  GET_TIME

        MOV   BH, 0
        MOV   AH, 3
        INT    10H                   ; 读取光标位置 (DH,DL)=(行，列)
        MOV   CURSOR,  DX   ; 保存当前光标的位置
                                           ; 在指定位置显示时间后，再将光标复原

        MOV   DH, 0
        MOV   DL, 80 - BUF_LEN
         MOV   BP,  OFFSET  HOUR
        MOV   BH, 0
        MOV   BL, 07H
        MOV   CX, BUF_LEN
        MOV   AL, 0
        MOV   AH, 13H
        INT    10H        ;  显示时间字符串
 
        MOV   DX, CURSOR
        MOV   AH, 2
        INT   10H            ; 设置光标位置，也即恢复到显示时间串前的位置
         
        POP   ES
        POP   DS
        POPA
        IRET
NEW08H  ENDP

; -------------------------------GET_TIME -----------------------------------------------
; 取时间
; 参考资料，CMOS数据的读写
GET_TIME  PROC
        MOV   AL, 4
        OUT   70H, AL
        JMP    $+2
        IN       AL, 71H
        MOV   AH,AL
        AND    AL,0FH
        SHR     AH, 4
        ADD    AX, 3030H
        XCHG  AH,  AL
        MOV   WORD PTR HOUR, AX
        MOV    AL, 2
        OUT    70H, AL
        JMP    $+2
        IN       AL, 71H
        MOV   AH, AL
        AND   AL, 0FH
        SHR   AH, 4
        ADD   AX, 3030H
        XCHG  AH, AL
        MOV   WORD PTR MIN, AX
        MOV   AL, 0
        OUT   70H, AL
        JMP    $+2
        IN       AL,  71H
        MOV   AH,  AL
        AND   AL,  0FH
        SHR    AH,  4
        ADD    AX,  3030H
        XCHG  AH,  AL
        MOV   WORD PTR SEC, AX
        RET
GET_TIME ENDP

RESIDULE_INTR8      PROC
    ;       将新的中断处理程序驻留内存
        MOV   DX, OFFSET RESIDULE_INTR8 +15
        MOV   CL, 4
        SHR   DX, CL
        ADD   DX, 10H
        ADD   DX, 70H
        MOV   AL, 0
        MOV   AH, 31H
        INT   21H
RESIDULE_INTR8   ENDP


; -------------------------------------------------------------------------------------------------------
; 主程序开始
; 程序从此处开始执行

BEGIN:   
        PUSH  CS
        POP   DS
        ;调试中断程序
        ; mov NEW_INT,BX
        ; mov NEW_INT+2,ES
        ; call dword ptr NEW_INT
            ;判断程序是否已经安装
        CMP  WORD PTR ES:[0], 0CCCCH
        JZ   installed_p
           ; 设置新的 8号中断的中断处理程序的入口地址，安装程序
        MOV   AX, 3508H
        INT   21H
        MOV   OLD_INT,  BX
        MOV   OLD_INT+2, ES
        MOV   DX, OFFSET NEW08H
        MOV   AX, 2508H
        INT   21H 
           ;输出提示信息      
        lea DX,prompt
        MOV   AH, 9
        INT   21H  
        CALL    RESIDULE_INTR8 
installed_p:
        LEA   DX, installed  ; 显示提示串 已安装
        MOV   AH, 9
        INT   21H
        MOV  AH,4CH
        INT   21H     
CODE    ENDS
        END  BEGIN