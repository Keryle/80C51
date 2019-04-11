.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x0023
ljmp _SerialIntt

.org 0x0030
_main:
    mov _SP,#0x60   ;堆栈指针
    mov _SCON,#0xf0 ;方式3，允许接收，SM2=1
    mov _TMOD,#0x20
    mov _TH1,#0xf3
    mov _TL1,#0xf3
    setb _TR1
    mov _PCON,#0x00
    setb _EA
    setb _ES
    mov 0x08,#0x40 ;1组r0,接收
    mov 0x09,#0x50 ;1组r1,发送
    mov 0x0a,#0x01 ;1组r2,字节数
01$:
    mov a,0x40
    cjne a,#0x11,01$
    clr _P3_7
    sjmp 01$

_SerialIntt:
    clr _RI
    push a
    push _PSW
    setb _RS0
    clr _RS1
    mov a,_SBUF
    xrl a,#0x01
    jz 01$
90$:                ;返回
    pop _PSW
    pop a
    clr _RS0
    setb _SM2
    reti
01$:                ;地址相等,发送本机地址
    clr _SM2
    mov _SBUF,#0x01
101$:
    jnb _TI,101$
102$:
    jnb _RI,102$
    clr _RI         ;接收命令帧
    clr _TI
    jb _RB,90$
    mov a,_SBUF
    ;判断命令帧类型
    ;接收
    cjne a,#0x00,10$
    mov _SBUF,#0x01
103$:
    jnb _TI,103$
02$:jnb _RI,02$

    clr _RI
    mov @r0,_SBUF
    inc r0
    djnz r2,02$
    sjmp 90$        ;退出

    ;发送
10$:
    cjne a,#0xff,90$
    mov _SBUF,#0x02
104$:
    jnb _TI,104$
    clr _TI
    mov _SBUF,@r1
    inc r1
    djnz r2,104$
    sjmp 90$
