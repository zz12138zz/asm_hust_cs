

;  �����ܣ�ÿ��Լ1���� ��ʾһ�ε�ǰ��ʱ�䣨ʱ���֣��룩
;            ����������������������
;        Ϊ�˸��õ�չʾ�������еĳ��򱻴�ϣ�ʱ�����ʾ���ַ�������ʾ������һ��

;  �漰��֪ʶ�㣺
;  (1) 8���ж�
;  (2) ����8���жϵ��жϴ������
;  (3) �жϴ������פ�����ڴ�
;  (4) ��ȡϵͳ��ǰʱ��
;  (5) ����Ļָ��λ����ʾ��

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
; ����� 8���жϴ������  
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
        INT    10H                   ; ��ȡ���λ�� (DH,DL)=(�У���)
        MOV   CURSOR,  DX   ; ���浱ǰ����λ��
                                           ; ��ָ��λ����ʾʱ����ٽ���긴ԭ

        MOV   DH, 0
        MOV   DL, 80 - BUF_LEN
         MOV   BP,  OFFSET  HOUR
        MOV   BH, 0
        MOV   BL, 07H
        MOV   CX, BUF_LEN
        MOV   AL, 0
        MOV   AH, 13H
        INT    10H        ;  ��ʾʱ���ַ���
 
        MOV   DX, CURSOR
        MOV   AH, 2
        INT   10H            ; ���ù��λ�ã�Ҳ���ָ�����ʾʱ�䴮ǰ��λ��
         
        POP   ES
        POP   DS
        POPA
        IRET
NEW08H  ENDP

; -------------------------------GET_TIME -----------------------------------------------
; ȡʱ��
; �ο����ϣ�CMOS���ݵĶ�д
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
    ;       ���µ��жϴ������פ���ڴ�
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
; ������ʼ
; ����Ӵ˴���ʼִ��

BEGIN:   
        PUSH  CS
        POP   DS
        ;�����жϳ���
        ; mov NEW_INT,BX
        ; mov NEW_INT+2,ES
        ; call dword ptr NEW_INT
            ;�жϳ����Ƿ��Ѿ���װ
        CMP  WORD PTR ES:[0], 0CCCCH
        JZ   installed_p
           ; �����µ� 8���жϵ��жϴ���������ڵ�ַ����װ����
        MOV   AX, 3508H
        INT   21H
        MOV   OLD_INT,  BX
        MOV   OLD_INT+2, ES
        MOV   DX, OFFSET NEW08H
        MOV   AX, 2508H
        INT   21H 
           ;�����ʾ��Ϣ      
        lea DX,prompt
        MOV   AH, 9
        INT   21H  
        CALL    RESIDULE_INTR8 
installed_p:
        LEA   DX, installed  ; ��ʾ��ʾ�� �Ѱ�װ
        MOV   AH, 9
        INT   21H
        MOV  AH,4CH
        INT   21H     
CODE    ENDS
        END  BEGIN