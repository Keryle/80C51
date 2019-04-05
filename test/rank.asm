.include /D:\asm51.h/
.area home (abs)
ljmp _main
.area code (code)
clr _P2_4
mov r2,0x42
