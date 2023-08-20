*-1.随机投点法求积分
 *求exp(-x^2)在2到3上的积分
 
 clear
 set obs 100000
 set seed 100
 gen x = runiform(2,3)   //区间用空格隔开,其他情况用逗号.这里均匀分布()里面是均匀分布的参数而不是代表区间
 gen y = runiform(0,exp(-4))
 gen inner = y<exp(-x^2)
 su inner
 local square = r(mean)*exp(-4)*1
 dis `square'
 
 *求圆周率
 clear
 set obs 10000
 set seed 100
 gen x = runiform(0,1)
 gen y = runiform(0,1) 
 gen inner = x^2+y^2<1
 su inner
 dis "_pi=" r(mean)*4
 

*-2.如果积分面积太小投点法过程中取不到所求面积上的点怎么办？
 *求F(-8), F~normal(),使用随机的办法
 clear
 set obs 1000
 set seed 100
 gen x = rnormal()
 gen x1 = x>8
 su x1
 dis r(mean)
 
 *重要性抽样法
 clear
 set obs 20000
 set seed 120
 gen x = rnormal(-8,1)
 gen i = (x<-8)
 gen y = i*normalden(x)/normalden(x,-8,1)
 su y
 dis r(mean)

 
 dis normal(-8)
 

 
*-3.求exp(-x^2)从负无穷到正无穷的积分
 clear
 set obs 1000
 set seed 100
 gen x = rnormal()
 gen x1 = exp(-(x^2))/(1/sqrt(2*_pi)*exp(-1/2*x^2))
 su x1
 

*-4.去掉最大最小值去平均
 clear
 set obs 6
 set seed 100
 foreach j of numlist 1/120{
	gen stu`j'=runiform(50,99)
	}
 foreach v of varlist _all{
	sort `v'
	qui:replace `v' = . if _n==1 | _n==6
	su
	qui:dis r(mean)
	}




*-5.模拟布朗运动
 
 replace x =rnormal() in 1
 replace x = x[1]+rnormal() in 2
 replace x = x[2]+rnormal() in 3

 clear
 set obs 1001
 set seed 102
 gen x = 0
 local sigma = 1
 local mu = 0
 foreach j of numlist 1/1000{
	local newj = `j'+1
	qui:replace x = x[`j']+rnormal(`mu',`sigma') in `newj'
	}
 drop if x==0
 gen t=_n
 scatter x i                                      //scatter y x

 clear
 set obs 1000
 gen x = 0
 set seed 102
 scalar b = 0
 foreach j of numlist 1/1000{
	local mu = 0
	local sigma = 1
	scalar b = b + rnormal(`mu',`sigma')
	qui:replace x = b in `j'
	}
 scalar list b
 gen t = _n
 scatter x t
 
*布朗运动的结果
 set seed 102
 scalar b = 0
 foreach j of numlist 1/1000{
	local mu = 0
	local sigma = 1
	scalar b = b + rnormal(`mu',`sigma')
	}
 scalar list b
 
 *-6.画F分布图
 clear
 set obs 1000
 set seed 100
 gen x = runiform(0,1)
 gen invF = invF(3,4,x)
 histogram invF, kdensity
 
local a = ceil(10/sqrt(2*_pi))/10
twoway function p = normalden(x), range(-5 5) lcolor(green) xline(0) title("概率密度函数") ///
                               xlabels(-5 -1.96 1.96 5) ylabels(0 0.1 0.2 0.3 `a') ///
							   xtitle("x") ytitle("概率密度") ///
	|| function p = normalden(x), range(-5 -1.96) recast(area) color(black) ///
	|| function p = normalden(x), range(1.96 5) recast(area) color(black) ///
	legend(off) plotregion(margin(0))

local j = 0
local suma = 0
while `suma'<5{
	local j = `j' + 1
	local suma = `suma' + `j'
	dis `j'
	}


 foreach j of numlist 1(2)10{                      //依次遍历1到10以2为公差的等比数列的数  
	if `j'==5{
	dis "`j'is`j'"                                 //如果满足if的判断那么就终止整个循环
	}
	else{
	continue
	}
	}  

 capture program drop hello                         //为了保证稳健性,把可能重名的program删掉
 program hello
	dis "hello stata"
 end














