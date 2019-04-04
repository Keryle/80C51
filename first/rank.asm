.include /asm51.h/
.area home (abs)
ljmp _main
.area code (code)
_Num = 7
;存入数据
mov 0x31,#0x52
mov 0x30,#0x22
mov 0x32,#0x12
mov 0x33,#0xa2
mov 0x34,#0x02
mov 0x35,#0x12
mov 0x36,#0xe2
 _main:
mov a,0x30

  lcall _rank
  01$:sjmp 01$

_rank:         ;首地址传递到a
  mov r7,#_Num;每轮比较次数
  mov r6,#_Num;循环次数
  mov r0,a  ; r0 首地址
01$:
  clr 0x00
03$:
  mov a,@r0
  mov r2,a
  inc r0
  mov a,@r0 ;r2->first , a->second
  clr c
  subb a,r2
  jnc 02$  ;a>=r2,jmp;else exchang
  setb 0x00
  mov a,r2
  xch a,@r0
  dec r0
  mov @r0,a
  inc r0
02$:
  djnz r7,03$;一轮比较
  dec r6
  mov a,r6
  mov r7,a
  jb 0x00,01$; 一轮比完没有交换，排序结束
  ret
