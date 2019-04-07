.include /asm51.h/
.area home (abs)
.org 0x0000
ljmp _main
.org 0x000b
ljmp _TimerIntterupt0
