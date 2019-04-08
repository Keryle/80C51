;主机程序，接线图请阅读README.md
.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x0003
ljmp _InttX0


_main:
  setb _EA
  setb _EX0
  setb _IT0            ;打开外部中断1，下降沿触发
  mov _SCON,#0x40     ;串口通讯方式1
  mov _PCON,#0x00     ;波特率不加倍
  mov _TMOD,#0x20     ;T2设置为方式2
  mov _TH1,#0xf3
  mov _TL1,#0xf3      ;设置波特率
  setb _TR1           ;启动定时器T1
01$:
  sjmp 01$

_InttX0:
  mov _SBUF,#0xf9      ;传送数据
01$:
  jnb _TI,01$          ;等待数据传送完毕
  clr _TI              ;  清除发送完成标志
  cpl _P2_2             ;接的led灯显示中断已经触发
  reti
