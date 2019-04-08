.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x0023
ljmp _InttS


_main:
  setb _EA
  setb _ES             ;开启窜口中断
  mov _SCON,#0x50     ;way1
  mov _PCON,#0x00     ;double
  mov _TMOD,#0x20     ;T2-->way2
  mov _TH1,#0xf3
  mov _TL1,#0xf3      ;4800
  setb _TR1

01$:
  sjmp 01$

_InttS:
  clr _RI             ;清除中断标志位
  mov _P2,_SBUF
  reti
