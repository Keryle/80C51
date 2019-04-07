.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x000b
ljmp _TimerIntterupt0
_main:
  mov _TMOD,#0x00  ;定时器0，方式0，13位定时器
  setb _EA
  setb _ET0
  mov a,#0x00
  lcall _FindStartT0
01$:
  sjmp 01$


_TimerIntterupt0:
  clr _TR0
  mov a,#0x00
  lcall _FindStartT0
  cpl _P1_5               ;取反输出波形
  reti



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
  ret


.org 0x1000               ;TL
.db 0x11,0x21
.org 0x1010               ;TH
.db 0x1e,0x3c
