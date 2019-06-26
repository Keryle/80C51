	PA	 XDATA	7F00H		;8255 PA口地址：位码口
	PB	 XDATA	7F01H		;8255 PB口地址：段码口
	CON	 XDATA	7F03H		;8255 控制端口
	SEC	    	DATA	21H		;秒
	MIN	    	DATA	22H		;分
	HOUR			DATA	23H		;时；时、分、秒均为BCD码
	KEY_VALUE 	DATA  24H		;按键值保存位置
	DIG_BIT			DATA 	25H		;显示位标志
	TEMP				DATA	26H		;存放临时变量
	BUFFER			DATA	38H		;8个字节显示缓冲区30H～37H
	COUNT				DATA	39H		;T0计数
	UNDERLINE		DATA	20
	FLICKER			DATA	43H		;闪烁值暂存
	FLICKER_BIT	DATA	44H
	TEMP1				DATA 	45H
	COUNT1			DATA	46H
	TEMP_R1			DATA	47H

	;BIT
	STATE			EQU 	00H		;状态标志位，0表示正常状态，1表示设置状态
	BCD_SUPRISE	EQU	01H		;BCD加法标志位
	PBUTTON		EQU		P1		;键盘IO口
	ORG 0000H
	LJMP MAIN
	ORG 0003H
	LJMP INTX0
	ORG 000BH
	LJMP INTT0
	ORG 0013H
	LJMP INTX1
	ORG 001BH
	LJMP INTT1
	ORG 0030H
TAB:
	DB 0FCH, 60H, 0DAH, 0F2H, 66H, 0B6H, 0BEH, 0E0H, 0FEH, 0F6H, 02H, 38H, 10H
TAB_ADD_DATA1:
	DB 12H, 34H, 56H
TAB_ADD_DATA2:
	DB 33H, 44H, 55H
;--------------------------------------
;延时10ms
;寄存器：	R7,R6
;--------------------------------------
DELAY:
	MOV R7,#100
D001:
	MOV R6,#50
	DJNZ R6,$
	DJNZ R7,D001
	RET

;-----------
;延时1ms
;---------
DELAY1MS:
	MOV R7,#10
D901:
	MOV R6,#50
	DJNZ R6,$
	DJNZ R7,D901
	RET

;================================
;外部中断0	：	获得按键值
;返回值		：	KEY_VALUE
;================================
INTX0:
	PUSH PSW
	PUSH ACC
	SETB RS0
	LCALL DELAY
	LCALL BUTTON_PRINT
	JB P3.2,X0_LAST		;再次判断按键是否按下

	MOV 27H,#0FEH		;27H保存比较值
	MOV R3,#0			;R3保存键值
X002:
	MOV PBUTTON,27H
	JB P3.2,X001		;判断按键
	MOV KEY_VALUE,R3	;传递键值
	SJMP X0_LAST
X001:
	INC R3
	MOV A,27H
	RL A
	MOV 27H,A
	CJNE R3,#10H,X002	;左环移循环判断

X0_LAST:
	MOV PBUTTON,#0
Q007:
	JNB P3.2,$			;等待按键松开
	LCALL DELAY
	JNB P3.2,Q007
	CLR RS0
	POP ACC
	POP PSW
	RETI

;==================================
;外部中断1	：	获得按键值
;返回值		：	KEY_VALUE
;==================================
INTX1:
	PUSH PSW
	PUSH ACC
	SETB RS0
	LCALL DELAY
	JB P3.3,X1_LAST		;再次判断按键是否按下

	MOV 27H,#0FEH		;27H保存比较值
	MOV R3,#8			;R3保存键值
X102:
	MOV PBUTTON,27H
	JB P3.3,X101		;判断按键
	MOV KEY_VALUE,R3	;传递键值
	SJMP X1_LAST
X101:
	INC R3
	MOV A,27H
	RL A
	MOV 27H,A
	CJNE R3,#10H,X102	;左环移循环判断

X1_LAST:
	MOV A,KEY_VALUE
	CJNE A,#10,X109
	SETB 00H
X109:
	MOV PBUTTON,#0
	JNB P3.3,$			;等待按键松开
	CLR RS0
	POP ACC
	POP PSW
	RETI

;==================================
;定时器T0	：	秒针计时
;返回值		：	NONE
;==================================
INTT0:
	PUSH PSW
	PUSH ACC
	MOV TL0,#0B0H
	MOV TH0,#3CH	;定时50ms
	MOV A,COUNT
	INC A
	CJNE A,#20,INTT001	;20次共1s
	MOV COUNT,#0
	LCALL	TIME_INC	;秒自增1
	SJMP INTT002
INTT001:
	MOV COUNT,A
INTT002:
	POP ACC
	POP PSW
	RETI

;==================================
;定时器T1	：	闪烁
;返回值		：	NONE
;==================================
INTT1:
	MOV TL1,#0B0H
	MOV TH1,#3CH	;定时50ms
	PUSH PSW
	PUSH ACC
	SETB RS1

	MOV A,TEMP1
	ADD A,#28H
	MOV R1,A
	MOV A,COUNT1
	CJNE A,#10,TT1001	;计时0.5s，显示数字

	MOV @R1,FLICKER
	SJMP TT1002
TT1001:
	CJNE A,#20,TT1002	;再过0.5s，显示下划线
	MOV @R1,#12
	MOV COUNT1,#0
TT1002:
	INC COUNT1
	CLR RS1
	POP ACC
	POP PSW
	RETI

;=================================
;主函数
;=================================
MAIN:
	MOV SP,#48H
;外部中断初始化
	CLR IT0
	CLR IT1
	SETB EX0
	SETB EX1
	SETB EA

;定时器初始化
	MOV TMOD,#11H
	SETB ET0
	SETB ET1
	MOV TL0,#0B0H
	MOV TH0,#3CH	;定时50ms
	MOV TL1,#0B0H
	MOV TH1,#3CH	;定时50ms
	SETB TR0		;开启定时器t0

;数码管显示初始化
	MOV DPTR,#CON
	MOV A,#80H
	MOVX @DPTR,A	;控制命令

;控制状态初始化
	MOV DIG_BIT,#0	;数码管显示位
	MOV PBUTTON,#0	;按键IO
	MOV HOUR,#23H
	MOV MIN,#59H
	MOV SEC,#54H
	MOV KEY_VALUE,#0	;按键值初始0
	MOV 28H,#2		;显示缓存区初始化
	MOV 29H,#3
	MOV 2AH,#10
	MOV 2BH,#5
	MOV 2CH,#9
	MOV 2DH,#10
	MOV 2EH,#5
	MOV 2FH,#4
	MOV COUNT,#0	;定时器计数初始0
	CLR STATE		 	;进入设置状态

M000:
	SETB EA
	JB STATE,M001		;判断是否进入设置状态
	LCALL DPRINT		;动态显示
	JB BCD_SUPRISE,M666
	SJMP M000
M666:
	LCALL BCD_ADD
M001:
	CLR EA			;关闭定时器
	CLR TR0
	LCALL BUTTON_PRINT ;显示按键
	LCALL DATA_CHANGE
M200:
	MOV A,KEY_VALUE
	CJNE A,#0AH,M002	 ;开始？
	MOV DIG_BIT,#0		;按键显示的初值
	SJMP M000
M002:
	CJNE A,#0CH,M003	 ;结束？
	CLR STATE
	SETB TR0
	SJMP M000
M003:
	CJNE A,#11,M004		;切换？
	MOV A,DIG_BIT

	CJNE A,#7,M005		;是否切换到最后？
M006:
	MOV DIG_BIT,#0
	;LCALL BUTTON_PRINT
	SJMP M009
M005:
	JNC M006
	INC DIG_BIT
	;LCALL BUTTON_PRINT
	SJMP M009
M004:
	LCALL DATA_CHANGE		;改变数码管内存值
	;LCALL BUTTON_PRINT
	;LCALL CHECK24		;检查是否符合24小时制
	LCALL DATA_RET	;数据存入MIN,HOUR,SEC
M009:
	MOV A,DIG_BIT
	ADD A,#28H
	MOV R1,A
	MOV TEMP_R1,R1
	MOV FLICKER,@R1		;将该位存入闪烁缓存
	MOV COUNT1,#0
	SETB TR1
	MOV A,KEY_VALUE
	SETB EA
M010:
	NOP
	CJNE A,KEY_VALUE,M100
	PUSH ACC
	;MOV TEMP1,DIG_BIT		;暂存DIG_BIT，关闭中断防止DIG_BIT改变
	;MOV DIG_BIT,TEMP1
	LCALL DPRINT
	POP ACC
	SJMP M010				  	;等待按键值改变
M100:
	MOV R1,TEMP_R1
	MOV @R1,FLICKER			;从闪烁返回数值
	CLR TR1
	MOV A,KEY_VALUE
	SJMP M200
	SJMP $

;----------------------------------
;动态循环显示程序
;输入参数；	DIG_BIT,
;----------------------------------
DPRINT:
	MOV R5,#8
	MOV TEMP1,DIG_BIT
	MOV DIG_BIT,#0
DP010:
	LCALL DIG_PRINT
	INC DIG_BIT
	LCALL DELAY1MS

	DJNZ R5, DP010
	MOV DIG_BIT,TEMP1
	RET

;-----------------------------
;输出控制位,选择点亮的数码管
;输入参数：	DIG_BIT
;返回参数： 	NONE
;寄存器：		R2
;-----------------------------
DIG_CONTROL_BIT:
	MOV R2,DIG_BIT
	MOV A,#0FEH		;共阴极数码管
D102:
	CJNE R2,#0,D101	;判断是否左环移
	MOV DPTR,#PA
	MOVX @DPTR,A
	RET
D101:
	RL A
	DEC R2
	SJMP D102

;-----------------------------
;将BCD码转为十六进制数
;输入参数： BUFFER
;返回参数： A(存高位),B(存低位)
;----------------------------
HEX_TO_BCD:
	MOV TEMP,BUFFER
	MOV A,TEMP
	ANL	A,#0FH
	MOV B,A			;返回低四位
	MOV A,TEMP
	SWAP A
	ANL A,#0FH		;返回高四位
	RET

;---------------------------
;数码管显示程序
;输入参数：	DIG_BIT
;						SEC
;						MIN
;						HOUR
;返回参数：	NONE
;DIG_BIT:		0		 1		2		 3		4		 5		6		 7
;				   ___  ___  ___  ___  ___  ___  ___  ___
;		  		|__| |__| |__| |__| |__| |__| |__| |__|
;   			|__| |__| |__| |__| |__| |__| |__| |__|
;						HOUR						MIN						SEC
;---------------------------
DIG_DATA:
			;数组开始地址，8个数码管对应8个
	MOV R0,#P_DATA
	MOV BUFFER,HOUR
	LCALL HEX_TO_BCD
	MOV 28H,A
	MOV 29H,B
	MOV 2AH,#10				;10对应的段码是 ‘——’
	MOV BUFFER,MIN
	LCALL HEX_TO_BCD
	MOV 2BH,A
	MOV 2CH,B
	MOV 2DH,#10
	MOV BUFFER,SEC
	LCALL HEX_TO_BCD
	MOV 2EH,A
	MOV 2FH,B					;数组转换结束
	RET

;----------------------------
;点亮数码管:  显示28H~2FH保存值
;----------------------------
DIG_PRINT:
	P_DATA 	DATA	28H
	LCALL DIG_CONTROL_BIT
	MOV A,DIG_BIT
	ADD A,#P_DATA
	MOV R0,A
	MOV A,@R0					;获得数码管显示数字
	MOV DPTR,#TAB
	MOVC A,@A+DPTR		;查表
	MOV DPTR,#PB
	MOVX @DPTR,A			;点亮数码管
	RET

;----------------------------
;点亮数码管,显示按键值
;----------------------------
BUTTON_PRINT:
	LCALL DIG_CONTROL_BIT
	MOV A,KEY_VALUE
	CJNE A,#10,B001
	RET
B001:
	JNC B999
	MOV DPTR,#TAB
	MOVC A,@A+DPTR		;查表
	MOV DPTR,#PB
	MOVX @DPTR,A			;点亮数码管
B999:
	CJNE A,#11,B099
	MOV DPTR,#PB
	MOV A,#10H
	MOVX @DPTR,A
	SJMP B199
B099:
	CJNE A,#20,B199
	MOV DPTR,#PB
	MOV A,#10H
	MOVX @DPTR,A
B199:
	RET

;-------------------------------
;根据键盘输入改变时间储存区域值
;输入：	DIG_BIT,KEY_VALUE
;返回：	28H~2FH
;-------------------------------
DATA_CHANGE:
	MOV A,DIG_BIT
	MOV TEMP,A
	ADD A,#28H
	MOV R0,A		;R0表示数码管的地址
	MOV A,TEMP
	CJNE A,#2,DATA001	;D2位显示“-”
	MOV @R0,#10		;第10位在tab表中查的值为“--”
	RET
DATA001:
	CJNE A,#5,DATA002	;D5位显示“-”
	MOV @R0,#10
	RET
DATA002:
	MOV A,KEY_VALUE
	CJNE A,#10,DATA003	;键值=10？
	RET
DATA003:
	JNC DATA009		;键值<10?
	MOV @R0,KEY_VALUE
DATA009:
	CJNE A,#11,DATA888
	MOV @R0,#12
DATA888:
	RET

;---------------------------
;返回MIN,HOUR,SEC(BCD码)
;输入：	28H~2FH
;返回：	MIN,HOUR,SEC
;------------------------------
DATA_RET:
	MOV A,28H
	SWAP A
	ORL A,29H
	MOV HOUR,A

	MOV A,2BH
	SWAP A
	ORL A,2CH
	MOV MIN,A

	MOV A,2EH
	SWAP A
	ORL A,2FH
	MOV SEC,A
	RET

;-------------------------------
;时间自增1s
;输入参数：	MIN,HOUR,SEC
;返回：	MIN,HOUR,SEC
;				BCD_SUPRISE(BCD加法标志位)
;-------------------------------
TIME_INC:
	MOV A,SEC
	ADD A,#01H
	DA A

	CJNE A,#60H,TI001	;SEC=60?
	MOV SEC,#0
	MOV A,MIN
	ADD A,#01H
	DA A

	CJNE A,#60H,TI011	;MIN=60?
	MOV MIN,#0
	MOV A,HOUR
	ADD A,#01H
	DA A

	CJNE A,#24H,TI021	;HOUR=24?
	MOV HOUR,#0
	SETB BCD_SUPRISE
	SJMP TI999
TI021:
	JNC TI999
	MOV HOUR,A
	SJMP TI999
TI011:
	JNC TI999
	MOV MIN,A
	SJMP TI999
TI001:
	JNC TI999
	MOV SEC,A
TI999:
	JB BCD_SUPRISE,TI888
	LCALL	DIG_DATA
	RET
TI888:
	MOV BUFFER,SEC
	LCALL	HEX_TO_BCD
	MOV 2EH,A
	MOV 2FH,B
	RET

;-------------------------
;将加法数据读取到缓存区域
;输入参数： DPTR
;返回：		28H~2CH(显示缓存)
;					30H~32H(加法缓存)
;-------------------------
READ_ADD_DATA:
	MOV A,#0
	MOVC A,@A+DPTR
	MOV BUFFER,A
	MOV 30H,A
	LCALL HEX_TO_BCD
	MOV 28H,A
	MOV 29H,B

	MOV A,#1
	MOVC A,@A+DPTR
	MOV BUFFER,A
	MOV 31H,A
	LCALL HEX_TO_BCD
	MOV 2AH,A
	MOV 2BH,B

	MOV A,#2
	MOVC A,@A+DPTR
	MOV BUFFER,A
	MOV 32H,A
	LCALL HEX_TO_BCD
	MOV 2CH,A
	MOV 2DH,B
	RET

;-----------------------
;BCD 加法
;-----------------------
BCD_ADD:
	MOV DPTR,#TAB_ADD_DATA1
	LCALL READ_ADD_DATA
	MOV 33H,30H
	MOV 34H,31H
	MOV 35H,32H
	MOV A,31H
BCDA001:
	MOV A,2EH	;秒针的十位
	CJNE A,#1,BCDA002
	SJMP	BCDA200
BCDA002:
	LCALL DPRINT
	SJMP BCDA001
BCDA200:
	MOV DPTR,#TAB_ADD_DATA2
	LCALL READ_ADD_DATA
BCDA011:
	MOV A,2EH	;秒针的十位
	CJNE A,#2,BCDA012
	SJMP BCDA300
BCDA012:
	LCALL DPRINT
	SJMP BCDA011
BCDA300:
	MOV A,35H
	ADD A,32H
	DA A
	MOV BUFFER,A
	LCALL HEX_TO_BCD
	MOV 2CH,A
	MOV 2DH,B			;十位个位相加移动到显示缓存

	MOV A,34H
	ADDC A,31H
	DA A
	MOV BUFFER,A
	LCALL HEX_TO_BCD
	MOV 2AH,A
	MOV 2BH,B		;百位千位相加移动到显示缓存

	MOV A,33H
	ADDC A,30H
	DA A
	MOV BUFFER,A
	LCALL HEX_TO_BCD
	MOV 28H,A
	MOV 29H,B		;高两位相加移动到显示缓存

	JC BCDA100
	MOV 2EH,#10
	MOV 2FH,#10
	SJMP BCDA199
BCDA100:
	MOV 2EH,#11
	MOV 2FH,#11
BCDA199:
	CLR TR0
	LCALL DPRINT
	SJMP BCDA199
	RET

	END
