.include /asm51.h/
.org 0x0000
ljmp _main

.org 0x0030

;-------------------------------------
;窜口通讯子程序
;入口参数：
;r0:发送数据地址
;r1：接收数据地址
;r2：从机地址
;r3：控制命令
;r4：数据长度
;-------------------------------------

_SerialCommunication：
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
;设置主机为方式3，SM2=1，TB8=1
    mov _SCON,#0xd8

90$:
    mov a,r2       ;发送地址
    mov _SBUF,a
01$:jnb _TI,01$
02$:jnb _RI,02$
    clr _RI
    mov a,_SBUF
    xrl a,r2
    jz 03$          ;相等转发送命令
91$:
    mov _SBUF,#0x00
    setb _TB8
    sjmp 90$
03$:
    clr _TB8         ;清除地址标志，双机通讯
    mov _SBUF,r3
04$:jnb _TI,04$
05$:jnb _RI,05$
    clr _RI
    mov a,_SBUF
    cjne r3,#0x00,10$
    cjne a,#0x01,20$
    sjmp 91$
10$:
    cjne r3,#0xff,80$;输入控制命令错误
    cjne a,#0x02,20$
    sjmp 91$
20$:
    mov _SBUF,#0xf0     ;主机确认指令
04$:jnb _TI,04$
05$:jnb _RI,05$




_main:
