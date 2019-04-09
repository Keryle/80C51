.include /asm51.h/
.area home (abs)
ljmp _main
nop

;延时函数
_delay:
  mov r7,#50
02$:
  mov r6,#100
01$:
  djnz r6,01$
  djnz r7,02$   ;(2*100+1)*50约为10ms
  ret

;扫描函数
_KeyDown:
  mov _P1,#0x0f
  nop
  mov a,_P1
  cjne a,#0x0f,01$
  ret
01$:                       ;判断按键是否按下
  lcall _delay
  mov a,_P1
  cjne a,#0x0f,02$
  ret                       ;延时再次判断
02$:
  mov _P1,#0x0f            ;判断行，高电平被拉低
  mov r0,_P1
  cjne r0,#0x07,03$
  mov r2,#1
  sjmp 20$                ;第1行
03$:
  cjne r0,#0x0b,04$
  mov r2,#2
  sjmp 20$
04$:
  cjne r0,#0x0d,05$
  mov r2,#3
  sjmp 20$
05$:
  cjne r0,#0x0e,06$
  mov r2,#4
  sjmp 20$
06$:
  setb 0x10
                        ;可能同时有多个按键按下，置位报错
20$:


  mov _P1,#0xf0            ;判断列，高电平被拉低
  nop
  mov r0,_P1


  cjne r0,#0x70,13$
  mov r3,#4
  sjmp 30$                 ;第4列
13$:
  cjne r0,#0xb0,14$
  mov r3,#3
  sjmp 30$
14$:
  cjne r0,#0xd0,15$
  mov r3,#2
  sjmp 30$
15$:
  cjne r0,#0xe0,16$
  mov r3,#1
  sjmp 30$
16$:
  setb 0x10                 ;可能同时有多个按键按下，置位报错
  ret

;求出按键的地址
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

  cjne a,#0x02,51$
  setb 0x11
  ret
51$:
  mov _DPL,a            ;传递到dpl
  ret

_main:

01$:
  lcall _KeyDown
  jnb 0x11,01$
  clr _P3_7
  clr _P3_1
  mov a,_DPL
  cjne a,#0x01,01$
  mov _P2,#0xf9
  sjmp 01$
