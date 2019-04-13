#include"st7565.h"

/*******************************************************************************
* 函数名          	: LCD12864_WriteCmd
* 写一个命令到	 : lcd12864
* 输入            : cmd
* 输出            : 无
*******************************************************************************/

void LcdSt7565_WriteCmd(cmd)
{
	LCD12864_CS = 0;	   //chip select
	LCD12864_RD = 1;	   //disable read
	LCD12864_RS = 0;       //select command
	LCD12864_RW = 0;       //select write
	DELAY;
	DATA_PORT = cmd; 		//put command
	DELAY;
	LCD12864_RW = 1;	   //command writing
}

/*******************************************************************************
* 函数名         : LcdSt7565_WriteData
* 写一个数据到   : lcd12864
* 输入          : dat
*******************************************************************************/

void LcdSt7565_WriteData(dat)
{
	LCD12864_CS = 0;	   //chip select
	LCD12864_RD = 1;	   //disable read
	LCD12864_RS = 1;       //select data
	LCD12864_RW = 0;       //select write
	DELAY;
	DATA_PORT = dat;       //put data
	DELAY;
	LCD12864_RW = 1;	   //data writing
}
/*******************************************************************************
* 函数名           : LCD12864_Init
* 初始化 		    : lcd12864
* 说明	        : LCD12864命令指令请到st7565p手册查看
*******************************************************************************/

void Lcd12864_Init()
{
	uchar i;
	LCD12864_RSET = 0;
	for (i=0; i<100; i++);
	LCD12864_CS = 0;
	LCD12864_RSET = 1;

	//----------------Start Initial Sequence-------//

	//--软件初始化--//
	LcdSt7565_WriteCmd(0xE2);  //reset
	for (i=0; i<100; i++);	   //delay

	LcdSt7565_WriteCmd(0xA1);  //ADC select segment direction

	LcdSt7565_WriteCmd(0xC8);  //Common direction

	LcdSt7565_WriteCmd(0xA6);  //reverse display

	LcdSt7565_WriteCmd(0xA4);  //normal display

	LcdSt7565_WriteCmd(0xA2);  //bias set 1/9

	LcdSt7565_WriteCmd(0xF8);  //Boost ratio set
	LcdSt7565_WriteCmd(0x01);  //x4

	LcdSt7565_WriteCmd(0x81);  //V0 a set
	LcdSt7565_WriteCmd(0x23);

	LcdSt7565_WriteCmd(0x25);  //Ra/Rb set

	LcdSt7565_WriteCmd(0x2F);
	for (i=0; i<100; i++);

	LcdSt7565_WriteCmd(0x40);  //start line

	LcdSt7565_WriteCmd(0xAF);  // display on
	for (i=0; i<100; i++);

}

/*******************************************************************************
* �� �� ��         : LCD12864_ClearScreen

*******************************************************************************/

void Lcd12864_ClearScreen(void)
{
	uchar i, j;

	for(i=0; i<8; i++)
	{

		LcdSt7565_WriteCmd(0xB0+i);


		LcdSt7565_WriteCmd(0x10);
		LcdSt7565_WriteCmd(0x04);


		for(j=0; j<128; j++)
		{
			LcdSt7565_WriteData(0x00);
		}
	}
}



#ifdef  CHAR_CODE

#include"charcode.h"

uchar Lcd12864_Write16CnCHAR(uchar x, uchar y, uchar *cn)
{
	uchar j, x1, x2, wordNum;

	if(y > 7)
	{
		return 0;
	}


	if(x > 128)
	{
		return 0;
	}
	y += 0xB0;

	LcdSt7565_WriteCmd(y);
	while ( *cn != '\0')
	{


		LcdSt7565_WriteCmd(y);

		x1 = (x >> 4) & 0x0F;
		x2 = x & 0x0F;

		LcdSt7565_WriteCmd(0x10 + x1);
		LcdSt7565_WriteCmd(0x04 + x2);

		for (wordNum=0; wordNum<50; wordNum++)
		{

			if ((CN16CHAR[wordNum].Index[0] == *cn)
			     &&(CN16CHAR[wordNum].Index[1] == *(cn+1)))
			{
				for (j=0; j<32; j++)
					if (j == 16)
					{

			   			LcdSt7565_WriteCmd(y + 1);


						LcdSt7565_WriteCmd(0x10 + x1);
						LcdSt7565_WriteCmd(0x04 + x2);
					}
					LcdSt7565_WriteData(CN16CHAR[wordNum].Msk[j]);
				}
				x += 16;
			}
		}
		cn += 2;
	}
	return 1;
}

#endif
