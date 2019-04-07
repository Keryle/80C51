.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x000b
ljmp _TimerIntterupt0  ;控制输出波形频率
.org 0x001b
ljmp _TimerIntterupt1   ;控制持续时间

_main:
  mov _TMOD,#0x10  ;timer0,13bit;timer1, 16bit
  setb _EA
  setb _ET0
  setb _ET1          ;允许中断T0，T1
  mov a,#0x00
  mov r2,#20
  lcall _FindStartT0
  lcall _StartT1     ;赋初值，启动中断
01$:
  sjmp 01$

;--------------------------
;时间中断0，输出特定波形
;--------------------------
_TimerIntterupt0:
  clr _TR0
  lcall _FindStartT0
  cpl _P1_5               ;取反输出波形，该io口连接蜂鸣器
  reti

  ;-----------------------
  ;时间中断1，定时改变寻址指针a
  ;-----------------------

_TimerIntterupt1:
  clr _TR1              ;关闭定时器
  djnz r2,01$           ;50ms*20=1s延时，r2=0时，改变指针a，使定时器0定时时间改变
  mov r2,#20
  inc a                 ;a值查表，
  cjne a,#0x02,01$      ;控制指针自增次数，溢出清零
  mov a,#0x00
01$:
  lcall _StartT1
  reti

_StartT1:
  mov _TH1,0x3c
  mov _TL1,0xb0         ;赋定时初值
  setb _TR1             ;启动定时器1
  ret

_FindStartT0:
  mov r4,a
  mov dptr,#0x1000
  movc a,@a+dptr
  mov _TL0,a            ;查表赋值低位
  mov dptr,#0x1010
  mov a,r4
  movc a,@a+dptr
  mov _TH0,a            ;查表赋值高位
  setb _TR0             ;启动定时器0
  mov a,r4              ;返回a的值
  ret

;timer0定时初值表格
.org 0x1000               ;TL
.db 0x11,0x88
.org 0x1010               ;TH
.db 0x1e,0x1f
