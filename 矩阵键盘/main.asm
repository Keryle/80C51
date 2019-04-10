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
  sjmp 20$                ;第1行
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
  sjmp 30$                 ;第4列
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
;-----------------------------------------
;停止按钮位地址设定
;-----------------------------------------
  cjne a,#0x04,51$
  setb 0x11
  ret
51$:
  mov _DPL,a
  ret
_main:

01$:
  lcall _KeyDown
  jnb 0x11,01$
  clr 0x11
  cpl _P3_7
  clr _P3_1
  mov a,_DPL
  cjne a,#0x01,01$
  mov _P2,#0xf9
  sjmp 01$
