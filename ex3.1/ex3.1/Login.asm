.686P     
.model flat, stdcall
printf          PROTO C :VARARG
scanf          PROTO C :VARARG
system         PROTO C :VARARG
StringCompare   PROTO
includelib  libcmt.lib
includelib  legacy_stdio_definitions.lib
EXTERN lpFmtStrIn:byte
.data
NameGet DB 20 DUP(0)
PassGet DB 20 DUP(0)
EnterUserName DB '请输入用户名:',0
EnterPassword DB '请输入密码：',0
.code
Login proc BossName:DWORD,BossPassword:DWORD
    invoke printf,offset EnterUserName
    invoke scanf,offset lpFmtStrIn,addr NameGet
    invoke printf,offset EnterPassword
    invoke scanf,offset lpFmtStrIn,addr PassGet
;比较用户名
    push offset NameGet
    push BossName
    call StringCompare
    add esp,8
    cmp eax,0
    jne WrongEnter

;比较密码
    push offset PassGet
    push BossPassword
    call StringCompare
    add esp,8
    cmp eax,0
    jne WrongEnter
RightEnter:
    mov eax,1
    ret
WrongEnter:
    mov eax,0
    ret
Login ENDP
END
