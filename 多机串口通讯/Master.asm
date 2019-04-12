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

_delay:
    mov r7,#50
02$:
    mov r6,#100
01$:
    djnz r6,01$
    djnz r7,02$   ;(2*100+1)*50约为10ms
    ret
;----------------------------------------
;扫描函数
;使用寄存器r2,r3,r4,r6,r7
;退出标志位0x11，bug位0x10
_KeyDown:
    mov _P1,#0x0f
    mov a,_P1
    anl a,#0x0f
    mov b,a
    mov _P1,#0xf0
    mov a,_P1
    anl a,#0xf0
    orl a,b
    cjne a,#0xff,01$
    ret
01$:                       ;判断按键是否按下
    lcall _delay
    mov a,_P1
    cjne a,#0xf0,02$
    ret                       ;延时再次判断
02$:
    mov _P1,#0x0f            ;判断行，高电平被拉低
102$:
    mov a,_P1
    anl a,#0x0f
    cjne a,#0x0f,101$
    sjmp 102$
101$:
    cjne a,#0x07,03$
    mov r2,#4
    sjmp 20$                ;第4行
03$:
    cjne a,#0x0b,04$
    mov r2,#3
    sjmp 20$
04$:
    cjne a,#0x0d,05$
    mov r2,#2
    sjmp 20$
05$:
    cjne a,#0x0e,06$
    mov r2,#1
    sjmp 20$
06$:
    setb 0x10
    ret
                        ;可能同时有多个按键按下，置位报错
20$:
    mov _P1,#0xf0            ;判断列，高电平被拉低
    nop
    mov a,_P1
    anl a,#0xf0


    cjne a,#0x70,13$
    mov r3,#1
    sjmp 30$                 ;第1列
13$:
    cjne a,#0xb0,14$
    mov r3,#2
    sjmp 30$
14$:
    cjne a,#0xd0,15$
    mov r3,#3
    sjmp 30$
15$:
    cjne a,#0xe0,16$
    mov r3,#4
    sjmp 30$
16$:
    setb 0x10                 ;可能同时有多个按键按下，置位报错
    ret

;求出按键的地址，r2保存行值，r3保存列值
30$:
    mov a,r2
    clr c
    subb a,#1
    mov b,#4
    mul ab
    add a,r3

;判断按键是否松开
    mov _P1,#0xf0
40$:
    mov r4,_P1
    cjne r4,#0xf0,40$
;-----------------------------------------
;停止按钮位地址设定
;-----------------------------------------
    cjne a,#0x04,51$
    setb 0x11           ;退出标志位
    ret
51$:
;------------------------------------------
;将DPL传递到DPH，再传递按键的地址到DPL
;------------------------------------------
    mov _DPH,_DPL
    mov _DPL,a
    ret



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
    mov _TMOD,#0x20
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
