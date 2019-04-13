#ifndef __ST7565_H
#define __ST7565_H

#include<8052.h>
#define DELAY \
    __asm \
    nop \
    nop \
    __endasm

//#define CHAR_CODE

#ifndef uchar
#define uchar unsigned char
#endif

#ifndef uint
#define uint unsigned int
#endif

//定义接口//
#define DATA_PORT P0
#define LCD12864_CS P3_2;
#define LCD12864_RSET P3_3;
#define LCD12864_RS P2_6;
#define LCD12864_RW P2_7;
#define LCD12864_RD P2_5;

//--函数定义--//
void LcdSt7565_WriteCmd(cmd);
void LcdSt7565_WriteData(dat);
void Lcd12864_Init();
void Lcd12864_ClearScreen(void);
uchar Lcd12864_Write16CnCHAR(uchar x, uchar y, uchar *cn);

#endif
