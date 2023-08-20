pwd //显示当前所在文件夹
dir //显示当前文件夹中的文件
ssc hot
ssc new
ssc install commandname  //下载ssc网站的外部命令
findit dynamic penal
db //打开窗口操作

import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", firstrow clear


*-2.帮助
help commandname
research linear regress //不知道命令直接搜相关的名字


*-3.变量创建与修改
gen ln_wage = log(wage)
gen wage_2 = wage^2
label var wage "工资"

bysort educ: egen mean_wage = mean(wages), after(wages)
bysort education: su wages
dis r(mean) //会输出最近的那个r(mean)
drop mean_wage
bysort educ: gen mean_wage = mean(wage) //会报错gen不能产生函数

replace wage = 0 if wage<7
replace wage = wage-1
//replace既可以替换变量或者替换变量中的值

*变量重新命名
rename (old_varlist) (new_varlist)
rename (wage educ) (wages education)


*-4.贴值标签:分为两步
label define gender 0 "female" 1 "male" 
label gender female

encode female, gen(code_female)


*-5.描述数据
keep if _n<20
tabulate educ //频数,百分比,累积分布函数
tabulate educ wage //每一个教育水平下有哪些工资水平以及不同工资水平的人的数量
tabulate female educ

su varlist
su varlist if
su varlist, detail


*-6.数据处理
drop if wages==.
keep if wages!=.
keep varlist
drop varlist
bysort education: egen wagemax=max(wages)
bysort education :gen wage1=wages[1], after(wages)

replace wages=educ if educ==6


*-7.dis的计算器功能
dis wages*3

local a=4
gen b = `a'*5

local a=4
local c =5
gen d = `a'*`c'

*—8.日志
log using fielname, replace //以fielname命名log文件
log on //代开log文件记录
log off //暂时关闭log文件的记录
log close //结束现在的log文件记录



*-9.保存数据
save dedede.dta //保存到当前文件夹
clear
use dedede.dta

*-10.通配符 "*" "?" 



*-11.索引,索引用方括号
dis wages[1]==wages
replace wages=. in 1


*四大分布以及随机数
*-1正态分布
*正态分布函数
dis normal(0)==0.5

f~N(8,9) F(9)
dis "F(9)=" normal((9-8)/9)

clear 
set obs 1000
set seed 100
gen x = runiform(0,1)
gen y = runiform(0,1)
gen inner = x^2+y^2<1
su inner
scalar phi = r(mean)*4

dis "兀="phi

*正态分布概率密度函数
dis normalden(8,8,9)==1/(9*sqrt(_pi*2))

dis normalden(8,8,9)

dis 1/(9*sqrt(_pi*2))

*正太分布的分位数
dis invnormal(0.6)*sqrt(7)+8

dis normal((8.67029-8)/sqrt(7))

*抽样
clear
set obs 1000
gen rn = rnormal(0,1)
histogram rn, kdensity

*-chi2分布
*分布函数
dis chi2(1,2)

dis chi2tail(1,2)
dis chi2(1,2)+chi2tail(1,2)

*密度函数
dis chi2den(1,2)


*分位数
dis invchi2(1,0.975)==invchi2tail(1,0.025)

*随机数
dis rchi2(1)

gen chi2 = rchi2(1)
histogram chi2 if chi2<6, kdensity

*-t分布
*分布函数
dis t(2,0)==0.5
dis t(2,7)+ttail(2,7)==1

*概率密度函数
dis tden(2,8)

dis tden(2,-8)

dis tden(2,8)==tden(2,-8)

*分位数
dis invt(2,0.5)

dis invt(2,0.6)==invttail(2,0.4)

*随机数
gen rt1 = rt(2)
histogram rt1 if rt1>-5 & rt1<5

*F分布
*分布函数
dis F(3,4,4)
dis Ftail(3,4,4)
dis F(3,4,4)+Ftail(3,4,4)==1

*概率密度函数
dis Fden(3,4,4)

*分位数
dis invF(3,4,0.8930887)
dis invF(3,4,0.6)==invFtail(3,4,0.4)

*随机数
gen r_u = runiform(0,1)
gen invf = invF(3,4,r_u)
histogram invf if invf<30, kdensity

import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", firstrow clear
import excel "/users/mac/desktop/stata/cps4_small.xlsx", firstrow clear
*histogram
histogram wage //默认画密度图
histogram wage, percent addlabels //省略%,一个区间内的数据占总数据的百分比
histogram wage, fraction addlabels
histogram wage, kdensity //默认画密度图
histogram wage, frequency //一个区间内的数据的多少
histogram wage, normal
histogram wage, normal(0,5) //只能标准正态分布
 
histogram wage, width(1)
histogram wage, bin(50)

 
*twoway scatter
twoway scatter wage educ, msize(tiny) color(red) xline(10) text(30 15 "嗯哼") ///
    || lfit wage educ, lcolor(red) ///
    || scatter exper educ, msize(small) color(blue) ///
	|| lfit exper educ, lcolor(blue) title("ssds") subtitle("shdjhs") legend(off) name(hahaha)
 
graph display hahaha
graph drop hahaha
 
*twoway function
 twoway function pdf = exp(-x^2), range(-6 6) lcolor(black) xtitle("自变量") ytitle("因变量") ///
                 xlabel(-6 -1.96 0 1.96 6) legend(off) plotregion(margin(0)) ///
     || function pdf = exp(-x^2), range(-6 -1.96) recast(area) color(black) ///
	 || function pdf = exp(-x^2), range(1.96 6) recast(area) color(black) saving(wuwuwu)
 
graph use wuwuwu
erase wuwuwu.gph
 
graph combine hahaha wuwuwu.gph, r(2)
 
graph combine hahaha wuwuwu.gph, c(2)
 
graph dir 
 
 
*-编程
*macro
local
global

local a 2*2
dis "2*2=`a'"

local a = 2*2
dis "2*2=`a'"

gen newvar=0, before(wage)
foreach v of varlist wage-hrswk{
	replace newvar=`v'+newvar
	}
dis newvar[1]
dis wage[1]+educ[1]+exper[1]+hrswk[1]


scalar a1 = 0
foreach j of numlist 1/100{
	scalar a1 = a1 + `j'
	}
dis a1

scalar s = 0
scalar j = 1
while s<15{
	scalar s = s + j
	scalar j = j + 1
		}
scalar list j

scalar s = 0
scalar j = 0
while s<=21{
	scalar j = j + 1
	scalar s = s + j
	}
scalar list j
scalar list s
 
scalar s = 0
scalar j = 0
while s<21{
	scalar j = j + 1
	scalar s = s + j
	}
scalar list j 
scalar list s
 
capture program drop distance
program distance, rclass
	args x1 x2
	return scalar norm = sqrt(`x1'^2+`x2'^2)
end
distance 3 4
dis r(norm)
 
foreach j of numlist 1/100{
	if mod(`j',2)==0{                //mod(x,y)表示x除以y取余数
	dis "`j'为基数"
	}
	else{
	dis "`j'为偶数"
	}
	}
 
clear
set obs 6
set seed 100
foreach j of numlist 1/120{
	gen student`j' = int(runiform(70,90))
	}
	
foreach i of numlist 1/120{
	sort student`i'
	su student`i' in 2/5
	}
 
foreach i of numlist 1/120{
	sort student`i'
	qui:replace student`i' = . if _n==1 | _n==6
	} 
su
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


