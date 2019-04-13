#include <8052.h>
#define DELAY \
    __asm \
    nop \
    nop \
    __endasm
#define Led P0
#define Led1 P0_1
void main()
{
    Led=0xf3;
    Led1=0;
    DELAY;
    while(1);
}
void isr(void) __interrupt 1
{
    char a;
}
