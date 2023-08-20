**********************************lecture 4编程**********************************

*-4.1 macro:local,global

 twoway function pdf = exp(-x^2), range(2 3) yline(0.018)  //画函数图像自变量只能用x
"twoway function pdf = exp(-x^2), range(2 3) yline(exp(-4)) //会报错,因为这里面不能识别非小数"
*这个问题怎么解决呢？就用macro解决

*4.1.1 local 
//局部宏要和其他命令一起执行才能发挥作用,并且用完一次就不能再用了,在命令窗口里面运行的local倒是可以一直用,但是他会被同名的宏覆盖掉.在do文件中同名的macro会报错.
*怎么解决呢？就用macro解决
 local ymax = exp(-4)                                      //ymax是这个宏的名称               
//把exp(-4)算出的值存在ymax上,也就是说ymax存的是dis exp(-4)输出的值,用`ymax'调用
//局部宏用`#'调用,其中#表示宏的名称

 local ymax = exp(-4)
 twoway function pdf = exp(-x^2), range(2 3) yline(`ymax') //local宏要和其他行命令一起运行才会起作用

 local ymax exp(-4)
 twoway function pdf = exp(-x^2), range(2 3) yline(`ymax') //会报错,因为ymax中存的是没有计算的exp(-4)


"local带等号与不带等号不一样"                                      
 local a 2*2                                               //把2*2这个形式存在a上,用`a'调用
 dis "2*2=" "`a'"                                          //这里a就代表了2*2

 local a = 2*2                                             //把2*2运算的值赋给a,用`a'调用
 dis "2*2=" "`a'"                                          //这里a代表了2*2计算出的小数值

*4.1.2 global 
//全局宏不必和其他命令一起执行,只要运行一次不删除就一直可以用

 global x exp(-4)
 dis "$x"                                                  //global用$调用

 global y = exp(-4)
 dis "$y"

 macro list                                                //找自己创建的macro,_下划线代表local,但是只能找到全局macro

"不加等号的macro只是字面上的替代,加等号的macro是对计算出的小数的替代"
"local只能用一次,global只要不关闭stata就一直有用,global在不同的但同时打开的do文件中都运行时相同会冲突"
"local如果在命令窗口中执行那就会global差不多,命令窗口会和local连在一起"
"macro和scalar的区别,scalar只能用于计算后再储存,而macro既可以用于计算后储存也可以用于字面替代"

 macro drop x                                             //删除已经设定的macro
 graph drop picture_name                                  //删除内存里面的图片
 erase picture_name.gph                                   //删除磁盘里面的图片
 capture program drop program_name                        //删除程序
 scalar drop #                                            //删除scalar
 drop var_name                                            //删除变量
 drop if var==.                                           //删除某一个变量中的缺失值
 
 
*-4.2 loop 
// loop里面的命名要用local macro 调用

*-4.2.1 

*foreach v of varlist varname{                          //既可以做挨着的变量也,可以做没有挨着的变量
	}
 local macroname "wage educ exper hrswk" 
 foreach v of local macroname{                          //这里的macroname就代表了
	gen l`v' = log(`v')
	}

*如何把变量wage到hrswk加起来生成一个新变量
 drop newvar
 gen newvar = 0, after(hrswk)
 foreach v of varlist wage educ exper hrswk{             //foreach表示遍历完从wage到hrswk才结束循环
	replace newvar = newvar+`v'
	}
	
 drop newvar
 gen newvar = 0, after(hrswk)
 foreach v of varlist wage-hrswk{                        //foreach表示遍历完从wage到hrswk才结束循环
	replace newvar = newvar+`v'
	}
 
 
 import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", sheet("Data") firstrow clear
 macro drop  varname
 global varname "wage educ exper hrswk" 
 gen newvar1 = 0, after(hrswk)
 foreach v of global varname{                             //v依次遍历完存在macro varname里面的东西,"这里用global很特殊"
	replace newvar1 = newvar1+`v'
	}
 dis newvar==newvar1                                      //判断变量是否相等就是判断向量是否相等

 
 macro drop  varname
 local varname "wage educ exper hrswk"
 drop newvar1
 gen newvar1 = 0, after(hrswk)
 foreach v of local varname{                             //v依次遍历完存在macro varname里面的东西,"这里用local很特殊"
	replace newvar1 = newvar1+`v'
	}
 dis newvar==newvar1
 
*-4.2.2 
*foreach i of numlist 1/20{
	}			
*forvalues j = 1/20{
	}
	
*1加到20怎么算？	
 scalar a0 = 0                                            //scalar是定义标量,return scalar是存数值
 foreach j of numlist 1/20{
	scalar a0 = a0+`j'                                    //scalar a0里面明明存了那么多值为什么最后指输出最后的a0呢？
 }
 dis a0
 
 clear
 set obs 1
 gen a = 0
 foreach j of numlist 1/20{
	qui:replace a = a +`j'
	}
	
 clear
 local suma = 0
 foreach j of numlist 1/20{
	local suma = `suma' + `j'                   
	}
 dis `suma'
			
 clear
 global suma = 0
 foreach j of numlist 1/20{
	global suma = $suma + `j'                           
	}
 dis $suma
"是循环语句里面都是可以替换原来同名的吗？" //是输出最靠近现在的那一个值

 local l = 1
 local l = `l'+1                                      
 dis `l'                                                  
 
 global l = 1
 global l = 2                                      
 dis $l  
 
 
"***********值得注意**************"
 clear
 set obs 10
 set seed 100
 gen gg=rnormal()                                //把gg变量第一个字母改为不是g就可以避免下面的问题
 scalar g=0
 forvalues i=1/2{
	scalar g=g+`i'                               //此处等号右边的g会索引到变量gg的第一个值
 }
 scalar list g                                   //scalar会找标量
 dis g                                          //dis会显示以g开头的变量的第一个数值,dis先寻找变量                              
 "dis 后面跟缩写时会先匹配变量,scalar的匹配居后,显示g能配对上的变量gg的第一个值"
 scalar list g                                   //显示出gg变量的第一个数加上2的值
"***********值得注意**************"


*生成stata中example.xls的数据
 clear
 set obs 6
 set seed 101
 foreach j of numlist 1/120{
 gen student`j' = runiformint(50,90)
	}	  

	
*-4.3 if,else if,else

*q取出1到100中的被5除余数为3的数
 foreach j of numlist 1/100{
	if mod(`j',5)==3{
	dis `j'
	}
	}
	
 foreach j of numlist 1/100{
	if mod(`j',2)==0{
	dis "`j'是偶数"
	}
	else{
	dis "`j'是奇数"
	}
	}

	
"***********************************"
"错误示范:"
 foreach j of numlist 1/100{
	if mod(`j',2)==0{
		dis "`j'是一个偶数"}                         //这个大括号还必须另起一行
	else{ 
		dis "`j'是一个奇数"
		}
	}
"************************************"


 foreach j of numlist 1/100{
	if `j'==0{
	dis "`j'为零"
	}
	else if mod(`j',2)==0{
	dis "`j'是偶数"
	}
	else{
	dis "`j'是奇数"
	}
	}
	
 foreach j of numlist 1/100{
  if `j'<=30{
  dis "`j'<=30"
  }
  else if `j'>30 & `j'<60{                           //&代表且,｜代表或
  dis "30<`j'<60"
  }
  else{
  dis "`j'>=60"
  }
  }
  

	
  
*-4.4 while                                          //foreach得知道在哪个范围循环,循环次数已知,那么对于循环次数未知的怎么办呢？

*从1开始公差为1的数列,前多少项的和恰好大于100但少了最后一项就小于100了？
 clear
 local summer = 1
 local j = 0
 while `summer'<100{
	local summer = `summer' + `j'
	local j = `j' + 1
	}
 dis `j'-1
 
 local a1 = 0
 foreach j of numlist 1/14{
	local a1 = `a1' + `j'
	}
 dis `a1'
 
 clear
 local summer = 0
 local j = 0
 while `summer'<100{
	local j = `j' + 1
	local summer = `summer' + `j'	
	}
 dis `j'


*-4.5 continue, contibue break

 foreach j of numlist 1(2)10{                      //遍历1到10以2为公差的等比数列的数  
	if `j'==5{
	continue                                       //如果满足if的判断那么就continue,也就是说不往下进行再从这个循环的头开始
	}
	else{
	dis "`j'是`j'"
	}
	}  
	
 foreach j of numlist 1(2)10{                      //依次遍历1到10以2为公差的等比数列的数  
	if `j'==5{
	continue,break                                 //如果满足if的判断那么就终止整个循环
	}
	else{
	dis "`j'是`j';"
	}
	}  

	
*循环的嵌套
*输出
1是1
1是1
3是3
2是2
1是1
3是3
3是3
1是1
3是3
 foreach j of numlist 1/3{
	dis "`j'是`j'"
	foreach i of numlist 1 3 5{
	if `i'==5{
	continue,break
	}
	else{
	dis "`i'是`i'"
	}
	}
	}
	
	
*输出
1是1
1是1
3是3
2是2
1是1
3是3
3是3
 foreach j of numlist 1/3{
	dis "`j' 是 `j'"
	if `j'==3{
	continue,break
	}
	else{
	foreach i of numlist 1 3 5{
	if `i'==5{
	continue,break
	}
	else{
	dis "`i' 是 `i'"
	}
	}
	}
	}


  foreach j of numlist 1/5{
	dis "`j'是`j'"
	foreach i of numlist 1(2)10{
	if `i'==5{
	continue
	}
	else{
	dis "`i'是`i'"
	}
	}
	}
	
*-4.6 program

 capture program drop hello                         //为了保证稳健性,把可能重名的program删掉
 program hello
	dis "hello stata"
 end
 hello                                              //在program执行之后执行才有用
 
//可以把写好的do文件储存为ado后缀的文件,这样stata执行命令时才会自动执行这个ado文件
".ado文件会自动寻找执行"
"stata执行操作时会从base->site->personal的顺序寻找文件执行"
"ado文件执行时会先找base->site->personal,如果这里面都没有就会寻找当前路径下的ado文件"
 
 program list hello                                //找到hello并且显示hello的内容
 adopath                                           //显示出ado文件的路径

//自己编写的program可以保存到"/Users/mac/Documents/Stata/ado/personal/"自己创建文件夹

 capture program drop square
 program square                                    //定义program的名
	args k                                         //这里的参数k是local mcaro,k既可以是数也可以是变量
	dis "这个数的平方=" `k'^2                          
 end
 square 4
 square wage                                       //把变量的第一个数进行了程序
 
 capture program drop var_su
 program var_inter
 args  var1 var2  
 gen new_inter_item = `var1'*`var2'
 end
 var_inter female black
 order female black new_inter_item
 
 capture program drop s
 program s
	args a b
	dis "这两个数的和="`a'+`b'
 end
 s 2 3

 capture program drop summation
 program summation, rclass                        //把返还的值存在r类中,并名为s
	args a b
	dis "这两个数的和="`a'+`b'
	return scalar s = `a'+`b'                     //返还的值存在标量s中,必须是return scalar
 end                                              //只有return scalar才能出存在r类中
 summation 2 3
 dis r(s)

 
scalar list                                     //列出所有标量
help su                                         //看看数值怎么储存的

*求欧几里德模
 capture program drop Euclid
 program Euclid, rclass
	args x y
	return scalar norm = sqrt((`x')^2+(`y')^2)
 end
 Euclid 3 4
 dis r(norm)
 
 *把求欧几里德模分为两部
 capture program drop square
 progra square, rclass	
	args x y
	return scalar sq = (`x')^2+(`y')^2
 end
 capture program drop root
 program root, rclass
	args x1 y1
	square `x1' `y1'
	return scalar roots = sqrt(r(sq))
 end
 root 3 4
 dis r(roots)
	
 
 capture program drop ab
 program ab, rclass
	args x1 x2 
	return scalar absolute = sqrt((`x1'-`x2')^2)
 end

 
 
*-4.7 simulate
 capture program drop onesample          //删除自编的程序
 clear
 program onesample, rclass
 drop _all
 set obs 30
 gen x = runiform()
 sum x
 return scalar mean_sample = r(mean)
 end

 simulate xbar=r(mean_sample), seed(101) reps(10000) :onesample //会产生变量
 histogram xbar, kdensity



capture program drop square
program square ,rclass
	args x1 x2
	return scalar sq = `x1'^2 + `x2'^2
end
capture program drop edistance
program edistance, rclass
	args x1 x2
	square `x1' `x2'
	return scalar distance = sqrt(r(sq))
end
edistance 3 4
dis r(distance)

clear
set obs 10000
set seed 100
gen x = runiform(2,3)
local max = exp(-4)
gen y = exp(-x^2)
gen a = runiform(0,`max')
gen inner = a<y
su inner 
dis r(mean)*exp(-4)













