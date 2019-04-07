                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.7 #11151 (MINGW64)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mmcs51 --model-small
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _Timer0
                                     12 	.globl _main
                                     13 	.globl _Timer0Init
                                     14 	.globl _TF2
                                     15 	.globl _EXF2
                                     16 	.globl _RCLK
                                     17 	.globl _TCLK
                                     18 	.globl _EXEN2
                                     19 	.globl _TR2
                                     20 	.globl _C_T2
                                     21 	.globl _CP_RL2
                                     22 	.globl _T2CON_7
                                     23 	.globl _T2CON_6
                                     24 	.globl _T2CON_5
                                     25 	.globl _T2CON_4
                                     26 	.globl _T2CON_3
                                     27 	.globl _T2CON_2
                                     28 	.globl _T2CON_1
                                     29 	.globl _T2CON_0
                                     30 	.globl _PT2
                                     31 	.globl _ET2
                                     32 	.globl _CY
                                     33 	.globl _AC
                                     34 	.globl _F0
                                     35 	.globl _RS1
                                     36 	.globl _RS0
                                     37 	.globl _OV
                                     38 	.globl _F1
                                     39 	.globl _P
                                     40 	.globl _PS
                                     41 	.globl _PT1
                                     42 	.globl _PX1
                                     43 	.globl _PT0
                                     44 	.globl _PX0
                                     45 	.globl _RD
                                     46 	.globl _WR
                                     47 	.globl _T1
                                     48 	.globl _T0
                                     49 	.globl _INT1
                                     50 	.globl _INT0
                                     51 	.globl _TXD
                                     52 	.globl _RXD
                                     53 	.globl _P3_7
                                     54 	.globl _P3_6
                                     55 	.globl _P3_5
                                     56 	.globl _P3_4
                                     57 	.globl _P3_3
                                     58 	.globl _P3_2
                                     59 	.globl _P3_1
                                     60 	.globl _P3_0
                                     61 	.globl _EA
                                     62 	.globl _ES
                                     63 	.globl _ET1
                                     64 	.globl _EX1
                                     65 	.globl _ET0
                                     66 	.globl _EX0
                                     67 	.globl _P2_7
                                     68 	.globl _P2_6
                                     69 	.globl _P2_5
                                     70 	.globl _P2_4
                                     71 	.globl _P2_3
                                     72 	.globl _P2_2
                                     73 	.globl _P2_1
                                     74 	.globl _P2_0
                                     75 	.globl _SM0
                                     76 	.globl _SM1
                                     77 	.globl _SM2
                                     78 	.globl _REN
                                     79 	.globl _TB8
                                     80 	.globl _RB8
                                     81 	.globl _TI
                                     82 	.globl _RI
                                     83 	.globl _P1_7
                                     84 	.globl _P1_6
                                     85 	.globl _P1_5
                                     86 	.globl _P1_4
                                     87 	.globl _P1_3
                                     88 	.globl _P1_2
                                     89 	.globl _P1_1
                                     90 	.globl _P1_0
                                     91 	.globl _TF1
                                     92 	.globl _TR1
                                     93 	.globl _TF0
                                     94 	.globl _TR0
                                     95 	.globl _IE1
                                     96 	.globl _IT1
                                     97 	.globl _IE0
                                     98 	.globl _IT0
                                     99 	.globl _P0_7
                                    100 	.globl _P0_6
                                    101 	.globl _P0_5
                                    102 	.globl _P0_4
                                    103 	.globl _P0_3
                                    104 	.globl _P0_2
                                    105 	.globl _P0_1
                                    106 	.globl _P0_0
                                    107 	.globl _TH2
                                    108 	.globl _TL2
                                    109 	.globl _RCAP2H
                                    110 	.globl _RCAP2L
                                    111 	.globl _T2CON
                                    112 	.globl _B
                                    113 	.globl _ACC
                                    114 	.globl _PSW
                                    115 	.globl _IP
                                    116 	.globl _P3
                                    117 	.globl _IE
                                    118 	.globl _P2
                                    119 	.globl _SBUF
                                    120 	.globl _SCON
                                    121 	.globl _P1
                                    122 	.globl _TH1
                                    123 	.globl _TH0
                                    124 	.globl _TL1
                                    125 	.globl _TL0
                                    126 	.globl _TMOD
                                    127 	.globl _TCON
                                    128 	.globl _PCON
                                    129 	.globl _DPH
                                    130 	.globl _DPL
                                    131 	.globl _SP
                                    132 	.globl _P0
                                    133 ;--------------------------------------------------------
                                    134 ; special function registers
                                    135 ;--------------------------------------------------------
                                    136 	.area RSEG    (ABS,DATA)
      000000                        137 	.org 0x0000
                           000080   138 _P0	=	0x0080
                           000081   139 _SP	=	0x0081
                           000082   140 _DPL	=	0x0082
                           000083   141 _DPH	=	0x0083
                           000087   142 _PCON	=	0x0087
                           000088   143 _TCON	=	0x0088
                           000089   144 _TMOD	=	0x0089
                           00008A   145 _TL0	=	0x008a
                           00008B   146 _TL1	=	0x008b
                           00008C   147 _TH0	=	0x008c
                           00008D   148 _TH1	=	0x008d
                           000090   149 _P1	=	0x0090
                           000098   150 _SCON	=	0x0098
                           000099   151 _SBUF	=	0x0099
                           0000A0   152 _P2	=	0x00a0
                           0000A8   153 _IE	=	0x00a8
                           0000B0   154 _P3	=	0x00b0
                           0000B8   155 _IP	=	0x00b8
                           0000D0   156 _PSW	=	0x00d0
                           0000E0   157 _ACC	=	0x00e0
                           0000F0   158 _B	=	0x00f0
                           0000C8   159 _T2CON	=	0x00c8
                           0000CA   160 _RCAP2L	=	0x00ca
                           0000CB   161 _RCAP2H	=	0x00cb
                           0000CC   162 _TL2	=	0x00cc
                           0000CD   163 _TH2	=	0x00cd
                                    164 ;--------------------------------------------------------
                                    165 ; special function bits
                                    166 ;--------------------------------------------------------
                                    167 	.area RSEG    (ABS,DATA)
      000000                        168 	.org 0x0000
                           000080   169 _P0_0	=	0x0080
                           000081   170 _P0_1	=	0x0081
                           000082   171 _P0_2	=	0x0082
                           000083   172 _P0_3	=	0x0083
                           000084   173 _P0_4	=	0x0084
                           000085   174 _P0_5	=	0x0085
                           000086   175 _P0_6	=	0x0086
                           000087   176 _P0_7	=	0x0087
                           000088   177 _IT0	=	0x0088
                           000089   178 _IE0	=	0x0089
                           00008A   179 _IT1	=	0x008a
                           00008B   180 _IE1	=	0x008b
                           00008C   181 _TR0	=	0x008c
                           00008D   182 _TF0	=	0x008d
                           00008E   183 _TR1	=	0x008e
                           00008F   184 _TF1	=	0x008f
                           000090   185 _P1_0	=	0x0090
                           000091   186 _P1_1	=	0x0091
                           000092   187 _P1_2	=	0x0092
                           000093   188 _P1_3	=	0x0093
                           000094   189 _P1_4	=	0x0094
                           000095   190 _P1_5	=	0x0095
                           000096   191 _P1_6	=	0x0096
                           000097   192 _P1_7	=	0x0097
                           000098   193 _RI	=	0x0098
                           000099   194 _TI	=	0x0099
                           00009A   195 _RB8	=	0x009a
                           00009B   196 _TB8	=	0x009b
                           00009C   197 _REN	=	0x009c
                           00009D   198 _SM2	=	0x009d
                           00009E   199 _SM1	=	0x009e
                           00009F   200 _SM0	=	0x009f
                           0000A0   201 _P2_0	=	0x00a0
                           0000A1   202 _P2_1	=	0x00a1
                           0000A2   203 _P2_2	=	0x00a2
                           0000A3   204 _P2_3	=	0x00a3
                           0000A4   205 _P2_4	=	0x00a4
                           0000A5   206 _P2_5	=	0x00a5
                           0000A6   207 _P2_6	=	0x00a6
                           0000A7   208 _P2_7	=	0x00a7
                           0000A8   209 _EX0	=	0x00a8
                           0000A9   210 _ET0	=	0x00a9
                           0000AA   211 _EX1	=	0x00aa
                           0000AB   212 _ET1	=	0x00ab
                           0000AC   213 _ES	=	0x00ac
                           0000AF   214 _EA	=	0x00af
                           0000B0   215 _P3_0	=	0x00b0
                           0000B1   216 _P3_1	=	0x00b1
                           0000B2   217 _P3_2	=	0x00b2
                           0000B3   218 _P3_3	=	0x00b3
                           0000B4   219 _P3_4	=	0x00b4
                           0000B5   220 _P3_5	=	0x00b5
                           0000B6   221 _P3_6	=	0x00b6
                           0000B7   222 _P3_7	=	0x00b7
                           0000B0   223 _RXD	=	0x00b0
                           0000B1   224 _TXD	=	0x00b1
                           0000B2   225 _INT0	=	0x00b2
                           0000B3   226 _INT1	=	0x00b3
                           0000B4   227 _T0	=	0x00b4
                           0000B5   228 _T1	=	0x00b5
                           0000B6   229 _WR	=	0x00b6
                           0000B7   230 _RD	=	0x00b7
                           0000B8   231 _PX0	=	0x00b8
                           0000B9   232 _PT0	=	0x00b9
                           0000BA   233 _PX1	=	0x00ba
                           0000BB   234 _PT1	=	0x00bb
                           0000BC   235 _PS	=	0x00bc
                           0000D0   236 _P	=	0x00d0
                           0000D1   237 _F1	=	0x00d1
                           0000D2   238 _OV	=	0x00d2
                           0000D3   239 _RS0	=	0x00d3
                           0000D4   240 _RS1	=	0x00d4
                           0000D5   241 _F0	=	0x00d5
                           0000D6   242 _AC	=	0x00d6
                           0000D7   243 _CY	=	0x00d7
                           0000AD   244 _ET2	=	0x00ad
                           0000BD   245 _PT2	=	0x00bd
                           0000C8   246 _T2CON_0	=	0x00c8
                           0000C9   247 _T2CON_1	=	0x00c9
                           0000CA   248 _T2CON_2	=	0x00ca
                           0000CB   249 _T2CON_3	=	0x00cb
                           0000CC   250 _T2CON_4	=	0x00cc
                           0000CD   251 _T2CON_5	=	0x00cd
                           0000CE   252 _T2CON_6	=	0x00ce
                           0000CF   253 _T2CON_7	=	0x00cf
                           0000C8   254 _CP_RL2	=	0x00c8
                           0000C9   255 _C_T2	=	0x00c9
                           0000CA   256 _TR2	=	0x00ca
                           0000CB   257 _EXEN2	=	0x00cb
                           0000CC   258 _TCLK	=	0x00cc
                           0000CD   259 _RCLK	=	0x00cd
                           0000CE   260 _EXF2	=	0x00ce
                           0000CF   261 _TF2	=	0x00cf
                                    262 ;--------------------------------------------------------
                                    263 ; overlayable register banks
                                    264 ;--------------------------------------------------------
                                    265 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                        266 	.ds 8
                                    267 ;--------------------------------------------------------
                                    268 ; internal ram data
                                    269 ;--------------------------------------------------------
                                    270 	.area DSEG    (DATA)
      000008                        271 _Timer0_i_65536_3:
      000008                        272 	.ds 2
                                    273 ;--------------------------------------------------------
                                    274 ; overlayable items in internal ram 
                                    275 ;--------------------------------------------------------
                                    276 ;--------------------------------------------------------
                                    277 ; Stack segment in internal ram 
                                    278 ;--------------------------------------------------------
                                    279 	.area	SSEG
      00000A                        280 __start__stack:
      00000A                        281 	.ds	1
                                    282 
                                    283 ;--------------------------------------------------------
                                    284 ; indirectly addressable internal ram data
                                    285 ;--------------------------------------------------------
                                    286 	.area ISEG    (DATA)
                                    287 ;--------------------------------------------------------
                                    288 ; absolute internal ram data
                                    289 ;--------------------------------------------------------
                                    290 	.area IABS    (ABS,DATA)
                                    291 	.area IABS    (ABS,DATA)
                                    292 ;--------------------------------------------------------
                                    293 ; bit data
                                    294 ;--------------------------------------------------------
                                    295 	.area BSEG    (BIT)
                                    296 ;--------------------------------------------------------
                                    297 ; paged external ram data
                                    298 ;--------------------------------------------------------
                                    299 	.area PSEG    (PAG,XDATA)
                                    300 ;--------------------------------------------------------
                                    301 ; external ram data
                                    302 ;--------------------------------------------------------
                                    303 	.area XSEG    (XDATA)
                                    304 ;--------------------------------------------------------
                                    305 ; absolute external ram data
                                    306 ;--------------------------------------------------------
                                    307 	.area XABS    (ABS,XDATA)
                                    308 ;--------------------------------------------------------
                                    309 ; external initialized ram data
                                    310 ;--------------------------------------------------------
                                    311 	.area XISEG   (XDATA)
                                    312 	.area HOME    (CODE)
                                    313 	.area GSINIT0 (CODE)
                                    314 	.area GSINIT1 (CODE)
                                    315 	.area GSINIT2 (CODE)
                                    316 	.area GSINIT3 (CODE)
                                    317 	.area GSINIT4 (CODE)
                                    318 	.area GSINIT5 (CODE)
                                    319 	.area GSINIT  (CODE)
                                    320 	.area GSFINAL (CODE)
                                    321 	.area CSEG    (CODE)
                                    322 ;--------------------------------------------------------
                                    323 ; interrupt vector 
                                    324 ;--------------------------------------------------------
                                    325 	.area HOME    (CODE)
      000000                        326 __interrupt_vect:
      000000 02 00 11         [24]  327 	ljmp	__sdcc_gsinit_startup
      000003 32               [24]  328 	reti
      000004                        329 	.ds	7
      00000B 02 00 82         [24]  330 	ljmp	_Timer0
                                    331 ;--------------------------------------------------------
                                    332 ; global & static initialisations
                                    333 ;--------------------------------------------------------
                                    334 	.area HOME    (CODE)
                                    335 	.area GSINIT  (CODE)
                                    336 	.area GSFINAL (CODE)
                                    337 	.area GSINIT  (CODE)
                                    338 	.globl __sdcc_gsinit_startup
                                    339 	.globl __sdcc_program_startup
                                    340 	.globl __start__stack
                                    341 	.globl __mcs51_genXINIT
                                    342 	.globl __mcs51_genXRAMCLEAR
                                    343 	.globl __mcs51_genRAMCLEAR
                                    344 	.area GSFINAL (CODE)
      00006A 02 00 0E         [24]  345 	ljmp	__sdcc_program_startup
                                    346 ;--------------------------------------------------------
                                    347 ; Home
                                    348 ;--------------------------------------------------------
                                    349 	.area HOME    (CODE)
                                    350 	.area HOME    (CODE)
      00000E                        351 __sdcc_program_startup:
      00000E 02 00 7D         [24]  352 	ljmp	_main
                                    353 ;	return from main will return to caller
                                    354 ;--------------------------------------------------------
                                    355 ; code
                                    356 ;--------------------------------------------------------
                                    357 	.area CSEG    (CODE)
                                    358 ;------------------------------------------------------------
                                    359 ;Allocation info for local variables in function 'Timer0Init'
                                    360 ;------------------------------------------------------------
                                    361 ;	.\main.c:19: void Timer0Init()
                                    362 ;	-----------------------------------------
                                    363 ;	 function Timer0Init
                                    364 ;	-----------------------------------------
      00006D                        365 _Timer0Init:
                           000007   366 	ar7 = 0x07
                           000006   367 	ar6 = 0x06
                           000005   368 	ar5 = 0x05
                           000004   369 	ar4 = 0x04
                           000003   370 	ar3 = 0x03
                           000002   371 	ar2 = 0x02
                           000001   372 	ar1 = 0x01
                           000000   373 	ar0 = 0x00
                                    374 ;	.\main.c:21: TMOD|=0X01;//选择为定时器0模式，工作方式1，仅用TR0打开启动。
      00006D 43 89 01         [24]  375 	orl	_TMOD,#0x01
                                    376 ;	.\main.c:23: TH0=0XFC;	//给定时器赋初值，定时1ms
      000070 75 8C FC         [24]  377 	mov	_TH0,#0xfc
                                    378 ;	.\main.c:24: TL0=0X18;	
      000073 75 8A 18         [24]  379 	mov	_TL0,#0x18
                                    380 ;	.\main.c:25: ET0=1;//打开定时器0中断允许
                                    381 ;	assignBit
      000076 D2 A9            [12]  382 	setb	_ET0
                                    383 ;	.\main.c:26: EA=1;//打开总中断
                                    384 ;	assignBit
      000078 D2 AF            [12]  385 	setb	_EA
                                    386 ;	.\main.c:27: TR0=1;//打开定时器			
                                    387 ;	assignBit
      00007A D2 8C            [12]  388 	setb	_TR0
                                    389 ;	.\main.c:28: }
      00007C 22               [24]  390 	ret
                                    391 ;------------------------------------------------------------
                                    392 ;Allocation info for local variables in function 'main'
                                    393 ;------------------------------------------------------------
                                    394 ;	.\main.c:36: void main()
                                    395 ;	-----------------------------------------
                                    396 ;	 function main
                                    397 ;	-----------------------------------------
      00007D                        398 _main:
                                    399 ;	.\main.c:38: Timer0Init();  //定时器0初始化
      00007D 12 00 6D         [24]  400 	lcall	_Timer0Init
                                    401 ;	.\main.c:39: while(1);		
      000080                        402 00102$:
                                    403 ;	.\main.c:40: }
      000080 80 FE            [24]  404 	sjmp	00102$
                                    405 ;------------------------------------------------------------
                                    406 ;Allocation info for local variables in function 'Timer0'
                                    407 ;------------------------------------------------------------
                                    408 ;i                         Allocated with name '_Timer0_i_65536_3'
                                    409 ;------------------------------------------------------------
                                    410 ;	.\main.c:48: void Timer0() __interrupt 1
                                    411 ;	-----------------------------------------
                                    412 ;	 function Timer0
                                    413 ;	-----------------------------------------
      000082                        414 _Timer0:
      000082 C0 E0            [24]  415 	push	acc
      000084 C0 D0            [24]  416 	push	psw
                                    417 ;	.\main.c:51: TH0=0XFC;	//给定时器赋初值，定时1ms
      000086 75 8C FC         [24]  418 	mov	_TH0,#0xfc
                                    419 ;	.\main.c:52: TL0=0X18;
      000089 75 8A 18         [24]  420 	mov	_TL0,#0x18
                                    421 ;	.\main.c:53: i++;
      00008C 05 08            [12]  422 	inc	_Timer0_i_65536_3
      00008E E4               [12]  423 	clr	a
      00008F B5 08 02         [24]  424 	cjne	a,_Timer0_i_65536_3,00109$
      000092 05 09            [12]  425 	inc	(_Timer0_i_65536_3 + 1)
      000094                        426 00109$:
                                    427 ;	.\main.c:54: if(i==1000)
      000094 74 E8            [12]  428 	mov	a,#0xe8
      000096 B5 08 0C         [24]  429 	cjne	a,_Timer0_i_65536_3,00103$
      000099 74 03            [12]  430 	mov	a,#0x03
      00009B B5 09 07         [24]  431 	cjne	a,(_Timer0_i_65536_3 + 1),00103$
                                    432 ;	.\main.c:56: i=0;
      00009E E4               [12]  433 	clr	a
      00009F F5 08            [12]  434 	mov	_Timer0_i_65536_3,a
      0000A1 F5 09            [12]  435 	mov	(_Timer0_i_65536_3 + 1),a
                                    436 ;	.\main.c:57: P2_0=~P2_0;	
                                    437 ;	assignBit
      0000A3 D2 A0            [12]  438 	setb	_P2_0
      0000A5                        439 00103$:
                                    440 ;	.\main.c:59: }
      0000A5 D0 D0            [24]  441 	pop	psw
      0000A7 D0 E0            [24]  442 	pop	acc
      0000A9 32               [24]  443 	reti
                                    444 ;	eliminated unneeded mov psw,# (no regs used in bank)
                                    445 ;	eliminated unneeded push/pop dpl
                                    446 ;	eliminated unneeded push/pop dph
                                    447 ;	eliminated unneeded push/pop b
                                    448 	.area CSEG    (CODE)
                                    449 	.area CONST   (CODE)
                                    450 	.area XINIT   (CODE)
                                    451 	.area CABS    (ABS,CODE)
