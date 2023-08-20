*求exp(-x^2)在2到3的积分
 *法1:随机投点
clear
set obs 100000
global t "1/sqrt(_pi)"         //normal(0,1/sqrt(2))概率密度在0处的值
global sigma "1/sqrt(2)"       //标准差

set seed 100
gen x = runiform(2,3)
set seed 101
gen y = runiform(0,$t)         //在2<x<3 & 0<y<1/sqrt(_pi)内投点

gen inner = y<(($t)*exp(-x^2)) //找落在范围内的点

sum inner

global s0 "r(mean)*($t)"       //概率密度图像在2～3的面积
global s1 "($s0)/($t)"         //积分值
dis $s1

dis sqrt(_pi)*(normal(3/($sigma)) - normal(2/($sigma)))    //检查

 *法2：随机抽样
clear
set obs 100000
global sigma "1/sqrt(2)"
set seed 103
gen x2 = rnormal(0,$sigma)
histogram x2
gen inner2 = (x2>2) & (x2<=3)
sum inner2
dis r(mean)/($t)              //r(mean)储存平均值

 *法3:积分法
clear
set obs 100000
gen x31 = _n
dis _N
global bw "1/(_N)"
gen x32 = x31*($bw)+2
gen y31 = exp(-(x32)^2)
gen y32 = y31*($bw)
sum y32
dis r(mean)*(_N)

global z "1/sqrt(_pi)*exp(-1/2*(x^2))"



*************************************课堂作业************************************
*求负无穷到正无穷的exp(-x^2)的积分
 *法1:重要性抽样(IS) 
clear
set obs 100000
set seed 123
gen x = rnormal(0,1)
gen y = exp(-(x^2))/(1/sqrt(_pi*2)*exp(-1/2*(x^2))) //用公式计算
sum y
dis r(mean)

gen gx = exp(-(x^2))/normalden()      //用命令计算，normalden()表示了标准正态密度函数

twoway function pdf = normalden(x)

*求F(-8), F~normal(),使用随机的办法
在计算机语言中"e"代表"10"
 *法1
clear
set obs 100000
set seed 234
gen x = rnormal(0,1)
gen inner = cond(x > 8,1,0)           // gen inner = x*(x > 8)
sum inner
"算出来为0,怎么办呢？用下面的重要性抽样"
 
 
 *法2:重要性抽样
clear
set obs 100000
set seed 2345
gen x = rnormal(8,1)
gen y = (x>8)*normalden(x,0,1)/normalden(x,8,1)     //(x>8)就直接表示指示函数1(x>8)
                                                    //x>8时取1,x<8时取0
sum y

*-画F分布图
clear
set obs 100000
set seed 100
gen x = rchi2(10)

set seed 101
gen y = rchi2(25)

gen z = x/y

histogram z, kdensity

********
set seed 3456
gen i = runiform(0,1)

gen rf = invF(10,25,i)

histogram rf, kdensity

//运行出来的图像并不太相同，那我可不可以，随机很多次，取平均再画图呢，但是循环不会写。


*-画图

 global alpha = invnormal(0.975)
 twoway (function y = normalden(x), range(-6 6) xlabels(-5 -1.96 0 1.96 5) xline(0)  ///
		title("正态分布的概率密度函数") ytitle("概率密度值") xtitle("x值") lcolor(green)) ///
     || (function y = normalden(x), range(1.96 6) recast(area) color(blue))  ///
     || (function y = normalden(x), range(-6 -1.96) recast(area) color(blue) plotregion(margin(0))legend(off)) 

	 
	 
twoway function y = normalden(x), name(p1) range(-6 6) xlabels(-5 -1.96 1.96 5) /// 
       xline(0) title("正态分布的概率密度函数") ytitle("概率密度值") xtitle("x值") ///
	   lcolor(green)	   
twoway(function y = normalden(x),name(p2) range(1.96 6) lcolor(green) recast(area) color(blue))
twoway(function y = normalden(x),name(p3) range(-6 -1.96) lcolor(green) recast(area) color(blue))

graph combine p1 p2 p3

 clear
 import excel "/Users/mac/Desktop/stata/example.xls", sheet("Sheet1") firstrow
 foreach j of numlist 1/120{
	sort student`j'                        //对第一个变量进行排序
	replace student`j' = . in 1            //把排序好的变量的第一个和第六个观测值用.代替
	replace student`j' = . in 6            //做平均值是.不会被记入
	su student`j'                          //求变量平均值
	dis r(mean)                            //r(mean)储存了平均值,显示平均值
	drop student`j'                        //drop掉第一个变量
	}
 "这里的第一个变量是指在stata数据中在第一列的变量"
 
clear
import excel "/Users/mac/Desktop/stata/example.xls", sheet("Sheet1") firstrow
set obs 7                                   //多出来的没有定义的观测值自动用.填补
foreach j of numlist 1/120{                 //数值遍历1到120
	sort student`j' in 1/6                  //对第j个变量进行排序
	local ofstudent`j'= student`j' in 1     //排序后的第j个变量的第一个观测值用ofstudent`j'替代
	local olstudent`j'= student`j' in 6     //排序后的第j个变量的第六个观测值用olstudent`j'替代
	replace student`j'=. in 1               //排序后的第j个变量的第一个观测值用.代替
	replace student`j'=. in 6               //排序后的第j个变量的第六个观测值用.代替
	su student`j'                           //对第j个去掉最大最小值变量求均值
	replace student`j'=r(mean) in 7         //第7个观测值用去掉最大最小值的平均值替代
	replace student`j'= `ofstudent`j'' in 1 //排序后的第j个变量的第一个观测值用再换回原来的第一的观测值
	replace student`j'= `olstudent`j'' in 6 //排序后的第j个变量的第六个观测值用再换回原来的第六的观测值
	}
"这样既可以保留原来的数据也可以列出去掉最大最小值后求的平均值"

clear
set obs 6
set seed 100
foreach j of numlist 1/120{
	gen student`j' = runiform(50, 100)
	}

replace student1 = . if student1 == max(student1)
"以上错误,max只能找出若干数值当中的最大值,如:dis max(1,3,5,2,7)"

sum student1                                  //只有sum之后才会把最大最小值存在r类当中
replace student1 = . if student1 == r(max)
replace student1 = . if student1 == r(min)

foreach v of varlist student1-student120{
	qui:sum `v'
	qui:replace `v' = . if `v' == r(max)
	qui:replace `v' = . if `v' == r(min)
	}

foreach v of varlist student1-student120{
	quietly
	{sum `v'
	replace `v' = . if `v' == r(max)
	replace `v' = . if `v' == r(min)
	}                                 //大括号得单独成行
	}
"这里会出现问题因为会有多个最大最小值,多个最大最小值都会被去掉"
 
 *如何去掉一次最大或者最小值后循环就停止
clear
set obs 6 
set seed 11
forvalues j=1/120{
	gen student`j'=runiformint(50,80)
}

su student1
local max1=r(max)
local min1=r(min)
foreach i of numlist 1/6{
	if student1[`i']== `max1'{   
	replace student1 = . in `i'                        //if语句里面才会加continue,break
	continue,break
	}
}

foreach i of numlist 1/6{
	if student1[`i']== `min1'{   
	replace student1 = . in `i'                       
	continue,break
	}
}
"一个的处理了那么怎么推广呢？"

"**********************************"
"错误,哪里错了没找到"
foreach v varlist _all{
	su `v'   
	local max = r(max)
	local min = r(min)
	foreach j of numlist 1/6{
		if `v'[`j'] == `max'{
		replace `v' = . in `j'
		continue,break
		}
		}
	foreach j of numlist 1/6{
		if `v'[`j'] == `min'{
		replace `v' = . in `j'
		continue,break                   //continue,break表示if成立并操作完了就会跳出整个循环
		}
	}
}
"*****************************"

*以下为正确操作
foreach v of varlist _all{
	qui:{
		su `v'
        local max=r(max)
        local min=r(min)
	}
    forvalues j=1/6{
	     if `v'[`j']==`min'{
	      qui replace `v' = . in `j'
	       continue,break
          }
       }
    forvalues j=1/6{
	    if `v'[`j']==`max'{
	      qui replace `v' = . in `j'
	       continue,break
         }
      }
}	
	


	
	
	
	
	
clear
import excel "/Users/mac/Desktop/stata/example.xls", sheet("Sheet1") firstrow
set obs 7                                  //多出来的没有定义的观测值自动用.填补
foreach j of numlist 1/120{                //数值遍历1到120
	sort student`j' in 1/6                 //对第j个变量进行排序
	su student`j' in 2/5                   //对第2个到第5个求均值
	replace student`j'=r(mean) in 7        //第7个观测值用去掉最大最小值的平均值替代
}	
	
 clear
 import excel "/Users/mac/Desktop/stata/example.xls", sheet("Sheet1") firstrow
 foreach j of numlist 1/120{           
	sort student`j'
	replace student`j'=. in 1                 
	replace student`j'=. in 6                         
	}	
sum

 clear
 import excel "/Users/mac/Desktop/stata/example.xls", sheet("Sheet1") firstrow

 foreach j of numlist 1/120{           
	sort student`j'
	qui:replace student`j'=. if _n==1 | _n==6                                        
	}	
sum


	
program subsum





end

sort student1
replace student1=. if _n=_N | _=1



clear
set obs 10
set seed 100
foreach j of numlist 1/120{
	gen student`j'=runiformint(50,90)               //int取整; mod(被除数,除数) 取余数
	}

program subsum
foreach v of varlist _all{
	sort `v'
	qui:replace `v'=. if _n==_N | _n==1
}
su
end


import excel "/Users/mac/Desktop/stata/副本宽型数据.xlsx", sheet("Sheet1") firstrow clear
rename (B C D E) (y1999 y2000 y2001 y2002)
encode provinceyear, gen(prv)
drop provinceyear
reshape long y, i(prv) j(year)

import excel "/Users/mac/Desktop/stata/副本宽型数据.xlsx", sheet("Sheet1") firstrow clear
foreach v of varlist B-E{
	rename `v' year`v'
	}
encode provinceyear, gen(prv)
drop provinceyear
reshape long year, i(prv) j(y) //这个reshape对应变量时必须要是变量名加上数字的才可以,变量名加上字母不可以

import excel "/Users/mac/Desktop/stata/季度GDP增长率.xlsx", sheet("Sheet1") firstrow clear
reshape long Q, i(季度年份) j(province_year)
reshape wide //把转成的长型数据还原为宽型数据



histogram volume, freq ///
                xaxis(1 2) ///
                ylabel(0(10)60, grid) ///
                xlabel(12321 "mean" ///
                      9735 "-1 s.d." ///
                     14907 "+1 s.d." ///
                      7149 "-2 s.d." ///
                     17493 "+2 s.d." ///
                     20078 "+3 s.d." ///
                     22664 "+4 s.d." ///
                                        , axis(2) grid gmax) ///
                xtitle("", axis(2)) ///
                subtitle("S&P 500, January 2001 - December 2001") ///
                note("Source:  Yahoo!Finance and Commodity Systems, Inc.")

******Sims P384******	
clear
set obs 1001
gen T = _n
gen x = _n
global f = 0.25
global s = 0.017

scalar mu1 = 0.047
foreach j of numlist 1/1000{
	local i = `j'+1
	qui:replace x = mu`j' - 0.25*mu`j' + 0.017-0.017*mu`j' in `i'
	scalar mu`i' = x[`i']
	}
replace x = mu1 in 1
drop in 1001
twoway scatter x T	
	
******Sims P426******	
clear
set obs 200
local r_t = 0.1
local y_t1 = 15
local g_t = 10
local g_t1 = 10
local a_t1 = 5
local k_t = 15
dis (-0.6*`g_t'+0.5*(`y_t1'-`g_t1')-10*`r_t'-20*`r_t'+1*`a_t1'+0.5*`k_t'+`g_t1')/(1-0.6)

local r_t = 0.15
local y_t1 = 15
local g_t = 10
local g_t1 = 10
local a_t1 = 5
local k_t = 15
dis (-0.6*`g_t'+0.5*(`y_t1'-`g_t1')-10*`r_t'-20*`r_t'+1*`a_t1'+0.5*`k_t'+`g_t1')/(1-0.6)

clear
set obs 200
gen R = _n/100
local y_t1 = 15
local g_t = 10
local g_t1 = 10
local a_t1 = 5
local k_t = 15
gen Y1 = (-0.6*`g_t'+0.5*(`y_t1'-`g_t1')-10*R-20*R+1*`a_t1'+0.5*`k_t'+`g_t1')/(1-0.6)

local y_t1 = 15
local g_t = 10
local g_t1 = 10
local a_t1 = 7
local k_t = 15
gen Y2 = (-0.6*`g_t'+0.5*(`y_t1'-`g_t1')-10*R-20*R+1*`a_t1'+0.5*`k_t'+`g_t1')/(1-0.6)


twoway (scatter R Y2 in 1/20, color(black)) ///
       (lfit R Y2 in 1/20, color(black)) ///
	|| (scatter R Y1 in 1/20, color(red)) ///
	   (lfit R Y1 in 1/20, color(red))


 dis (-0.6*`g_t'+0.5*(`y_t1'-`g_t1')-10*0.01-20*0.01+1*`a_t1'+0.5*`k_t'+`g_t1')/(1-0.6)











(2)Durbin两步法
 use "/Users/mac/Desktop/stata/消费data.dta", clear
 //"先找出是几阶的序列相关"
 reg lcons linc lw r
 predict e, r
 estat bgodfrey, lags(1/10) //发现到三阶就不相关了
 reg e L1.e linc lw r 
 reg e L2.e linc lw r       //辅助回归滞后两阶不显著,暂定一阶自相关
 
 reg lcons linc lw r
 estat dwatson
 
 //"一阶自相关"
 reg e L1.e
 dis _b[L1.e]
 local lvar "lcons linc lw r"
 foreach v of local lvar {
	gen n`v' = `v' - 0.324*L1.`v'
	}
 reg n*
 dis "beta1_hat=" _b[nlinc] 
 dis "beta2_hat=" _b[nlw]
 dis "beta3_hat=" _b[nr]
 dis "beta0_hat=" _b[_cons]*(1-0.324)
 
 clear
 scalar a = 0
 foreach j of numlist 1/20{
	scalar a = a+`j'
	}
 scalar list a
 
 clear
 local b=0
 foreach j of numlist 1/100{
	local b = `b'+`j"
	}
 dis b
 
 
 foreach i of numlist 1/3{
	dis `i'
	foreach j of numlist 1/3{
	dis `j'
	}
	}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
