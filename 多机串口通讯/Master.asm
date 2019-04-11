.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main

.org 0x0030
_main:
    mov r0,#0x30
    mov @r0,#0x11
    mov r2,#0x01
    mov r3,#0x00
    mov r4,#0x01
    lcall _SerialCom
    clr _P3_7
01$:
    sjmp 01$
;-------------------------------------
;窜口通讯子程序
;入口参数：
;r0:发送数据地址
;r1：接收数据地址
;r2：从机地址
;r3：控制命令
;r4：数据长度
;-------------------------------------

_SerialCom:
;定时器T1方式2 波特率2400 不加倍
    mov _TOMD,#0x20
    mov _TH1,#0xf3
    mov _TL1,#0xf3
    setb _TR1
    mov _PCON,#0x00
;TB8=1，即发送的第九位为1
;当SM2=1，发送第九位为1时，RI=1，串口中断
;发送第九位为0时，RI=0，不产生串口中断
;当SM2=0不管第九位，产生中断
;设置主机为方式3，SM2=0，TB8=1,允许接收
    mov _SCON,#0xd8

90$:
    mov a,r2       ;发送地址
    mov _SBUF,a
09$:jnb _TI,09$
02$:jnb _RI,02$
    clr _RI
    clr _TI
    mov a,_SBUF
    xrl a,r2
    jz 03$          ;应答地址相等转
91$:                ;复位操作
    mov _SBUF,#0x00
    setb _TB8
    sjmp 90$
03$:
    clr _TB8         ;发送命令帧
    mov _SBUF,r3
04$:jnb _TI,04$
05$:jnb _RI,05$
    clr _RI
    clr _TI
    ;接收从机返回信号
    ;判断接收或发送
    ;发送
    mov a,_SBUF
    cjne r3,#0x00,10$;如果发送的命令是00H
    cjne a,#0x01,91$ ;返回信号错误转到复位，否则发送数据
11$:
    mov _SBUF,@r0
06$:jnb _TI,06$
    clr _TI
    inc r0
    djnz r4,11$
    ret
    ;接收
10$:
    cjne r3,#0xff,80$;转到控制命令错误
    cjne a,#0x02,91$ ;返回信号错误转到复位，否则接收数据
07$:jnb _RI,07$
    clr _RI
    mov @r1,_SBUF
    inc r1
    djnz r4,07$
    ret
80$:
    setb 0x00
    ret
