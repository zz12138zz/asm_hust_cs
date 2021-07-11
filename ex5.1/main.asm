.686
.model FLAT,STDCALL
OPTION CASEMAP:NONE
Display  proto :DWORD
Sort            PROTO :DWORD,:DWORD
CalculateRates PROTO :DWORD,:DWORD,:DWORD
WinMain proto :DWORD
WndProc proto :DWORD,:DWORD,:DWORD,:DWORD
DialogProc proto :DWORD,:DWORD,:DWORD,:DWORD
GetStringLength proto :dword
itoa proto :word,:dword
LoadData proto:dword,:dword,:dword
include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include resource.inc
GOODS  STRUCT
GOODSNAME  db 10 DUP(0)
BUYPRICE   DW  0
SELLPRICE  DW  0
BUYNUM     DW  0
SELLNUM    DW  0
RATE       DW  0
GOODS  ENDS
.data
szClassName       db "Menu",0
szTitle           db " Menu",0
hInstance         dd  0
szMessageBoxTitle db "Author Infomation",0
szMessageConfirm db "Are you sure to close the window ?",0
szAuthorInfo      db "Author : ZhengZhou",0
szVersionInfo     db "Version : 1.0",0
szInputText       db  100 dup(0)
dwInputLength dd  0
szCancelPress     db "Cancel Button is pressed ",0
dwCancelPressLength = $ - szCancelPress -1
szClosePress      db  " Close Window is pressed. ",0
dwClosePressLength = $ - szClosePress -1
szClearText       db  100 dup(' ')
NumToString db 10 dup(0)
GA1   GOODS<'PEN',15,20,70,25,0>;商品1 名称,进货价、销售价、进货数量、已售数量,利润率（尚未计算）
GA2   GOODS<'PENCIL',2,3,100,50,0>
GA3   GOODS<'BOOK',30,40,25,5,0>
GA4   GOODS<'RULER',3,4,200,150,0>
GA5   GOODS<'BAG',30,50,10,5,0>
LIST DD 5 DUP(0);存储排序后的地址
msg_name     db       'Name',0
msg_buyingPrice  db       'Buy_price',0
msg_soldPrice     db       'Sell_price',0
msg_buyingNum  db       'Buy_num',0
msg_soldNum  db       'Sell_num',0
msg_rate db 'Rate'
.code
START:
	invoke GetModuleHandle,NULL
	mov    hInstance,eax
	invoke WinMain,hInstance
	invoke ExitProcess,eax

;**************
WinMain proc hInst:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	LOCAL hMenu:HMENU
    invoke RtlZeroMemory,ADDR wc,SIZEOF wc
	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	push  hInst
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_WINDOW+1
	mov   wc.lpszClassName,OFFSET szClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov   wc.hIcon,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, ADDR wc
	invoke LoadMenu, hInst, IDM_MYMENU
	mov    hMenu,eax
	invoke CreateWindowEx,NULL,ADDR szClassName,ADDR szTitle,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,hMenu,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
StartLoop:
    invoke GetMessage,ADDR msg,NULL,0,0
    cmp  eax,0
    je   ExitLoop
    invoke TranslateMessage, ADDR msg
    invoke DispatchMessage, ADDR msg
	jmp StartLoop 
ExitLoop:
     mov  eax,msg.wParam
	 ret
WinMain ENDP

;*************************
WndProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
  LOCAL hdc:HDC
.IF uMsg == WM_COMMAND
   .IF wParam == ID_OP_EXIT
       invoke DestroyWindow, hWnd
;	   invoke PostQuitMessage,NULL
   .ELSEIF  wParam == ID_COMPUTE_RATE
       invoke CalculateRates,offset GA1,5,offset LIST
   .ELSEIF  wParam == ID_LIST_SORT
       invoke LoadData,offset GA1,5,offset LIST
       invoke Sort,offset LIST,5
       invoke GetDC,hWnd
       mov    hdc,eax
       invoke Display,hdc
	.ELSEIF wParam == ID_HELP_ABOUT
		invoke MessageBox,hWnd,addr szAuthorInfo,addr szMessageBoxTitle,MB_OK
   .ENDIF
.ELSEIF uMsg==WM_CLOSE
      invoke MessageBox, hWnd,addr szMessageConfirm, addr szMessageBoxTitle,MB_YESNO
	  .if  eax == IDYES
           invoke DestroyWindow, hWnd
		   invoke TextOut,hdc,40,40,addr szInputText,dwInputLength
	  .endif
.ELSEIF uMsg==WM_DESTROY
      invoke PostQuitMessage,NULL
 .ELSE
      invoke DefWindowProc,hWnd,uMsg,wParam,lParam
      ret
 .ENDIF
  xor    eax,eax
  ret
WndProc endp

DialogProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL  hEdit:DWORD
.IF uMsg == WM_CLOSE
     invoke	wsprintf, addr szInputText, addr szClosePress
   	 mov  dwInputLength, dwClosePressLength  
     invoke  EndDialog, hWnd, NULL
.ELSEIF uMsg == WM_COMMAND
   .IF wParam == IDOK
       invoke GetDlgItem, hWnd,IDC_MYDIALOG_EDIT
	   mov hEdit, eax
	   invoke GetWindowTextLength,hEdit
	   mov dwInputLength, eax  
       invoke GetDlgItemText, hWnd,IDC_MYDIALOG_EDIT, offset szInputText,100
       invoke EndDialog,hWnd,NULL
   .ELSEIF  wParam == IDCANCEL
       invoke	wsprintf, addr szInputText, addr szCancelPress
   	   mov dwInputLength, dwCancelPressLength  
       invoke EndDialog,hWnd,NULL
   .ENDIF
 .ENDIF
  xor    eax,eax
  ret
DialogProc endp

Display      proc   hdc:HDC
            push eax
            push ebx
            push edi
            push esi
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_name,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_buyingPrice,8
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_soldPrice,10
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_buyingNum,6
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_soldNum,8
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_rate,4
             ;;
             mov esi,1
LOOPDISPLAY:
            mov ebx,LIST[esi*4-4]
             mov edi,YY_GAP
             imul edi,esi
             add edi,YY
             cmp esi,6
             je EXIT
             invoke GetStringLength,ebx
             invoke TextOut,hdc,XX+0*XX_GAP,edi,ebx,eax

             invoke itoa,[ebx].GOODS.BUYPRICE,offset NumToString
             invoke GetStringLength,offset NumToString
             invoke TextOut,hdc,XX+1*XX_GAP,edi,offset NumToString,eax

             invoke itoa,[ebx].GOODS.SELLPRICE,offset NumToString
             invoke GetStringLength,offset NumToString
             invoke TextOut,hdc,XX+2*XX_GAP,edi,offset NumToString,eax

             invoke itoa,[ebx].GOODS.BUYNUM,offset NumToString
             invoke GetStringLength,offset NumToString
             invoke TextOut,hdc,XX+3*XX_GAP,edi,offset NumToString,eax

             invoke itoa,[ebx].GOODS.SELLNUM,offset NumToString
             invoke GetStringLength,offset NumToString
             invoke TextOut,hdc,XX+4*XX_GAP,edi,offset NumToString,eax

             invoke itoa,[ebx].GOODS.RATE,offset NumToString
             invoke GetStringLength,offset NumToString
             invoke TextOut,hdc,XX+5*XX_GAP,edi,offset NumToString,eax

             inc esi
             jmp LOOPDISPLAY
EXIT:
             pop esi
             pop edi
             pop ebx
             pop eax
             ret
Display      endp

GetStringLength proc string:dword
    mov eax,string
    dec eax
GetLength:
    inc eax
    cmp byte ptr[eax],0
    jne GetLength
    sub eax,string
    ret
GetStringLength endp
END  START