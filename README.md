# 80c51
单片机汇编语言基于编译器SDCC（sdas8051）

## windows编译环境搭建
  1.程序编辑器atom 网站https://atom.io/
  
  2.编译器：sdcc（windows版）网站http://sdcc.sourceforge.net/
  
    sdcc是一款专门为微型控制器编译的跨平台编译器，自带有详细的使用说明。
    
  3.搭建c语言环境,
     首先安装atom与sdcc，然后启动windows自带的powershell（快捷键win+r，输入powershell）。
  在powershell命令行中输入atom可启动软件atom。创建文件*.c，注意sdcc与keil的差异：
         
         sdcc头文件#include <8051.h>
   keil中sbit led1 = P1 ^ 0; 而在SDCC是这样子写： 
              
              sbit at 0x90 led1; 
            或 
              __sbit __at 0x90 led1;
          
   在atom中使用快捷键Ctrl + Shift + C复制*.c文件地址（假如为c：\test\my.c）,
   在powershell中输入
                          
      sdcc  c：\test\my.c(文件目录)  
   系统将会在该目录下生成*.ihx文件,
   使用命令：
                          
         packihx c：\test\my.ihx > c：\test\my.hex
           
   生成hex文件，直接使用windows软件烧写程序。如果生成的hex文件无效，请用cmd输入上述命令重新生成hex文件。
   
  4.搭建asm（汇编）环境：汇编程序格式如仓库的源代码所示，详细帮助请浏览网页http://svn.code.sf.net/p/sdcc/code/trunk/sdcc/sdas/doc/asmlnk.txt；
  在powershell中输入命令，生成*。rel文件：
  
    sdas8051 -plogsff c：\test\my.asm
  再输入生成*.ihx文件
      
      sdcc c：\test\my.rel
  再输入生成*.hex文件

       packihx c：\test\my.ihx > c：\test\my.hex
  如果生成hex文件有问题请使用cmd输入上述命令重新生成hex文件。
