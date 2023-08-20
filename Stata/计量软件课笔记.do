**********************************lecture 1*************************************

*-路径
 pwd                                    //显示当前工作路径
 cd "/Users/mac/desktop/stata"          //更换工作目录，就可以直接读这个路径下的文件了
 dir                                    //显示当前路径下的文件
 
*-帮助
 help reg                               //已经知道命令是什么，找命令怎么写
 search linear regression               //不知道命令是什么，但是知道是什么名字
 ssc hot                                //寻找最近用的火的方法
 ssc new                                //寻找最近新的方法
 ssc install                            //直接下载ssc网站的外部命令
 findit dynamic panel                   //搜索关键词，下载外部命令
 db                                     //弹出窗口进行了相关操作

*-变量创建与修改
 generate ln_mpg=log(mpg)               //产生新变量
 gen price_2=price^2, after(mpg)        //产生新变量，并且跟在mpg变量的后面
 
 rename old_varname new_varname         //修改变量名
 rename (price mpg) (pri mp)            //批量修改变量名,批量修改要加上括号来识别哪些是要修改的
 rename (v1-v3) (price mpg rep78).      //批量修改连续挨着的变量名
 label var var_name "new_label"         //给变量贴标签，变量标签可以中文也可以英文
 label var educ "教育年限"
 label var wage "工资/年度/元"
 *作图,作表时可以显示出标签
 scatter educ wage
 
 *贴值标签
 label define gender 1 "female" 0 "male" //定义数值标签
 label value female gender               //贴上数值标签
 
*-导入数据
 File——>import                           //import excel时注意选项要使得第一行为变量名
 
 insheet using "d1.txt", clear           //倒入txt文件
 
 import excel "auto.xls", clear          //导入数据，但是第一行不能识别是变量名
 import excel "/Users/mac/desktop/stata/auto.xls",sheet("Data") firstrow clear                                         //第一行可以识别为变量名
 import excel "auto.xls", clear sheet() firstrow
                                         //导入excel中的一个指定sheet
 sysuse "auto.dta",clear                 //使用系统自带数据
 
*-描述数据
 describe                                //描述数据形态
 des2                                    //好用的外部命令
 des var_name                            //描述数据类型，标签等
 
 display
 dis 2>3
 
 summarize                               //对所有数据进行统计描述
 summarize var_name                      //对指定数据进行统计描述
 sum ,detail                             //对所有数据进行更加详细的描述
 summarize var_name, detail              //对指定数据进行更详细的描述
 sum in 1/10                             //第1到第10个观测值做统计描述
 sum in -200/l                           //对倒数第200个到最后一个观测值做统计描述
 sum in f/l
 correlate price mpg                     //price和mpg的相关系数
 
 count                                   //计算样本个数
 display _N                              //显示样本个数
 codebook                                //描述数据，数据的分位数，最大最小值，均值等
 tabulate                                //频数统计,tab最多写两个变量
 tab price , sum(mpg)
 tab price , sum(mpg) mean

*-判断
 drop if price=.                         //如果价格在表中是"."就扔掉
 help operator                           //查找运算符
 "!=" "~='" 		表示不等于
 "=="               双等号代表判断
 "="                单等号代表赋值
 dis 2>3            显示"2>3"这个判断的结果
 dis 2>3 | 3>2      "|"代表或
 dis 3>2 & 1<4      "&"代表且
 
**********************************lecture 2*************************************

*-计算器功能
 dis log(10)                             //计算ln(10)
 dis log10(19)                           //计算log10(19)

*—日志
 log using filename,replace              //执行之后后台就会记录我们的操作了
 log off                                 //暂停log的使用
 log on                                  //重新启用log
 log close
 "日志不会记录窗口操作,只会记录显示窗口里面的结果"

*-数据处理与描述
 order educ wage black                   //改变变量排序
 edit                                    //编辑数据
 sort price mpg                          //升序排序，先按price升序，再按mpg升序排，
 gsort -price mpg                        //price降序排列，mpg升序排列(广义的排序)
 sort female
 by                                      //前缀作为分类
 
 "sort后面是冒号":""
 by exper,sort: gen n1=_n,after(exper)   //先排序分类,再在分类内编号,跟在exper后面
 by exper,sort: gen N1=_N                //先排序分类显示该组的样本总量
 
 by exper,sort: gen wage10=wage[1] ,after(wage)       //显示排序中第一个wage
 
 by female, sort: sum wage educ                //需要先排序运行这行命才不会报错
 by female, sort: sum wage educ
 bysort female: sum wage educ            //bysort自动帮助排序
 summarize price, detail                 //更加详细的price的统计描述
 
 mean,max,min.                           //是一个指令不是函数，不能用于产生新变量
 gen mean_wage=mean(wage)                //会报错
 egen mean_wage=mean(wage)               //这个不会报错
 egen std=sd(#)
 
 gen dif=dif(edu,exper)                  //报错
 egen dif=dif(edu,exper)                 //不报错
 
 gen dif= edu!=exp                       //dif 不等时等于为1,相等时为0
 
 keep var_name                           //保留变量,其他变量全部删掉
 keep wage - married                     //保留从wage到married连着的
 drop var_name                           //去掉变量
 drop wage - married                     //去掉从wage到married连着的
 
*-保存数据
 save newdata.dta                        //这样保存知道自己把着一数据保存成了什么名字
 use newdata.dta                         //使用路径下的dta文件
 
 
**********************************lecture 3*************************************
 
 generate wage_2=wage^2
 gen wage_3=wage^3, after(edu)
 gen wage_4=wage^4, before(edu)          //stata自动匹配唯一能对应上的变量
 replace wage_3=wage^0                   //替换掉原来的已经定义的
 
*-生成判断语句的值
 gen hedu=1 if edu > 16
 replace hedu=0 if edu<=16               //两行一起执行，edu大于16的为1，小于等于16的为0
 
 gen hedu9=cond(edu>16,1,0)              //条件，满足条件时的值，不满足条件的值
 
 gen hedu5 = edu > 16
 ".表示的缺失值,也表示正无穷"
 
*-索引,索引用方括号
 _n                                      //表示1,2,3,4,...,N
 dis wage[_N]                            //索引出最后一个观测值
 dis wage[1]                             //索引wage中第一个数
 
 gen n=_n
 
 "sort后面是冒号":""
 by exper,sort: gen n3=_n                //先排序分类再编号
 by exper,sort: gen N1=_N                //先排序分类，产生该组的样本总量的变量
 by exper,sort: gen wage0=wage[1]        //显示排序中第一个wage

 
*-通配符 "*" "?"                          //*能表示很多，？只能表示一个
 keep w*                                 //保留w开头的所有变量
 drop *t                                 //去掉t结尾的变量
 drop sou?h
 
 drop if married==1                      //删除married等于1时的观测，对行操作
 "drop wage if married==1                //会报错，stata做向量变化"
 keep if _n > 9
 
*-值标签
*直接在原来的变量上面编码,把红色的字变为蓝色的,但是这个对于编码比较少的合适,编码的多了就不合适了
 label define gender 1 "female" 0 "male" //定义数值标签
 label value female gender               //贴上数值标签
*这个对于比较多的编码也合适
 encode female, gen(fe_male)

 

**********************************lecture 4*************************************

"正太分布在stata中没有为不分布函数,其他分布t,chi2,F都有尾部分布"

*-正态分布 F(x,Ex,sigma^2)
 *分布值
 display normal(0)                       //F(X<=0)的值，求分布值
 scalar phi = normal(0)                  //储存normal(0)的值为phi
 "dis normaltail(2)"                     //会报错，normal没有tail的玩法
 dis phi                                 //显示phi
 
 dis "p(z<=-2)=" phi   
 
 *分位数
 dis invnormal(0.95)                     //F=0.95的分位数
 dis invnormal(0.975)
 
 *概率密度值
 dis normalden(0)                        //标准正态分布0处的概率密度值
 dis 1/(2*_pi)^(1/2)                     //_pi表示兀
 
 dis normalden(x,mean,standard deviation)
 dis normalden(0,5,10)                   //显示均值为5，标准差为10的正态分布在0处的概率密度值
 dis normalden(2,5)                      //求均值为0，标准差为5时，在2处的概率密度值
 "如果想求均值为非0数的概率密度，通过均值为0的正态平移就可以了"
  
 *模拟
 dis rnormal(2,5)                        //在均值为2，标准差为5的正态分布中随机抽取一个值
 dis normal()                            //在标准分布中随机抽取一个值
 "计算机只能的出伪随机数，但是也可以用，伪随机数和真的随机数性质相近，计算机随机生成的数是算法模拟的"
 
 set obs  1000                           //设定样本数
 gen x = _N
 gen y = rnormal(0,1)                    //随机生成1000个
 histogram y                             //画出y的直方图，直方图高度为概率
 histogram y, kdensity                   //画出y的直方图并且加上概率密度线 
 
 set obs 1000
 set obs 100                             //报错，缩减数据会报错,stata怕你误删了数据
 set obs 2000                            //扩充样本不会报错
 
*-卡方分布(chi2) chi2(r, )
 *分布函数
 dis chi2(10,5)                          //求F(X<=5)的值，F服从于自由度为10的卡方分布
 dis chi2tail(10,5)                      //求F(X>5)的值，F服从于自由度为10的卡方分布
 
 *概率密度
 dis chi2den(10,5)                       //求f(5),f服从于自由度为10的卡方分布
 
 *分位数
 dis invchi2(10,0.95)                    //求F=0.95的分位数
 dis invchi2tail(10,0.05)                //求自由度为10的卡方分布右边概率为0.05的分位数
 
 *随机抽样
 dis rchi2(10) 
 gen l = rchi2(10)                       //如果不设定种子数每次随机出来的不一样，产生新变量
 
 set seed 100
 dis rchi2(10)
 set seed 100                            //设定种子数
 dis rchi2(10)
 
 set seed 120
 gen chi100=rchi2(10)
 set seed 120
 gen chi200=rchi2(10)                    //种子数要相同随机生成的才能一样
 
*-t分布 t(r, ) r代表自由度
 *分布值
 dis t(20,1.5)                           //F(X<=1.5)
 dis ttail(20,1.5)                       //1-F(X<=1.5)
 
 *概率密度值
 dis tden(50,9)                          //自由度为50的t分布，x=9时的概率密度值
 
 *分位数
 dis invt(20,0.975)                      
 dis invttail(20,0.025)                  //尾部分位数，自由度为20的t分布的上分位数
 
 *模拟
 set seed 3456
 dis rt(10)                              //在自由度为10的t分布中随机取一个数
 gen z = rt(10)
 
*-F分布 F(r1,r2,x)
 *分布值
 dis F(10,20,6)
 dis Ftail(10,20,6)
 
 *概率密度值
 dis Fden(10,20,6)
 
 *分位数
 dis invF(10,20,0.999)
 dis invFtail(10,20,0.001)
 
 *模拟
 "F分布随机抽样在stata里面不能直接实现"
 怎么解决？
 1.外部命令
 2.自己编写程序

 

**********************************lecture 5*************************************

*-1.从F分布中随机抽样
 现在均匀分布U(0,1)中抽一个0到1之间的数，也就可以看作分布值，然后用这个分布值就可以对应一个F分
 的x值
 
 set seed 234
 gen z = runiform(0,1)                      //生成样本数个的服从0到1的均匀分布的随机数
 gen rF = invF(10,25,z)
 
 histogram rF                               //画出变量rF的直方图
 histogram rF if rF<5, kdensity             //kdensit是选项
 
*-2.线性回归DGP
 造一个"y=beta0+beta1*x+u"的回归
 clear
 set obs 10000                              //生成观测值，_N=10000
 set seed 2345
 gen x =  runiformint(50,100)               //只要整数
 gen u = rnormal(0,5)                       
 gen y = 2.5 + 2.7*x + u
 
 reg y x
 reg y x in 1/100
 
*-求圆周率
 clear
 set obs 100000
 gen pointy = runiform(0,1)                  //括号里面啥也不写是0到1的均匀分布
 gen pointx = runiform(0,1)
 
*-产生判断变量
 *方法1
 gen inner = 1 if pointx^2+pointy^2 < 1
 replace inner = 0 if pointx^2+pointy^2 > 1
 
 *方法2
 gen inner = cond(pointx^2+pointy^2 < 1,1,0)
 
 *方法3
 gen inner = pointx^2+pointy^2 < 1           //直接输出判断，true为1，false为0
 
 
 
**********************************lecture 6作图**********************************
 *common option
 title(title名)                              //给图命名
 xtitle()                                    //给x轴命名
 ytitle()
 
 xlable(0(5)30)                              //x轴上的数字从0开始以5为间隔到30进行标示
 ylable(0(0.1)1)                             //y轴上的数字从0开始以0.1为间隔到1进行标示
 xlabel(1 2 3 4)                             //在x轴上面标出数字1,2,3,4
 
 xline(0)
 yline(0)
 
 text(20 0.7 "文字")                          //在坐标为(0.7,20)的点处写文本,text(y,x)
 range()                                      
 *保存图片
 saving                                      //保存在硬盘中,没有后缀名
 name                                        //保存在内存中,有后缀名
 
 *保存了之后怎么看
 graph dir
 
  *合并图像
 graph combine listname                       //把多幅图片放到一张图中，但是各张图还是分开的 
 *调出图片
 graph use p1                                 //调出硬盘里面的图
 graph display p2                             //调出内存里面的图
 
 *删除图片(只能删内存里面的图片)
 graph drop p2                                   //只能删除内存里面的图
 graph drop p1.pgh                               //删不了硬盘里的图
 erase p1.gph                                    //erase可以删除硬盘里面的图
 
 
 
*-1直方图(histogram)
 histogram wage, title("工资直方图")           //引号可加可不加
 hist wage, title("工资直方图") kdensity       //kdensity既可以用作选项也可以做命令
 kdensity wage                               //画出wage的核密度图
 hist wage, normal kdensity                  //画出的直方图中加一个正态分布和核概率密度图
 
 hist wage, xtitle(wage) ytitle(frequency)   //给x轴和y轴加标示
 
 hist wage, bin(5)                          //bin()直方图柱子的个数,柱子越多越精,bin()只有直方图才可以用细
 
 hist wage, xlabels(0(5)30) ylabels(0(0.1)1)//在轴上面标出指定间隔的数
 hist wage, xlabels(0 1 2 3)                //在轴上面标出指定的数
  
 hist wage, xline(20)                       //垂直于x轴的线
 hist wage, xline(20) text(0.04 20 "文字")   //在坐标为(20,0.04)的点处写文本
 
 hist wage if wage > -30                    //只画出工资从-30开始
 hist wage, title("工资直方图") start(-20)    //画出工资从-20开始,改变坐标轴,默认往左走一个间隔
 hist wage in 100/200                       //只取100到200个观测值作图
 
 hist wage, title("工资直方图") saving(p1)    //把图命名为p1存在硬盘中
 hist wage, title("工资直方图") name(p2)      //把图命名为p2存在内存中
 
 histogram wage,normal kdensity ///
           xtitle(wage) ytitle(frequency) /// 
		   bin(50) ///
		   xlabels(0(5)60) ylabels(0(0.01)0.06) ///
		   xline(20) text(0.05  25  "2023-3-30") ///
		   saving(p2) 

*-2散点图(scatter)                           //twoway双向做图
 twoway(scatter y x)
 twoway(scatter wage educ) 
 
 twoway(scatter wage educ) (lfit wage educ) //lfit加一条fitted line(拟合线)
 
 twoway(scatter wage educ, color(black)) ///
       (lfit wage educ, lcolor(black))      //color指点的颜色,lcolor指线的颜色
	   
 "编辑图片直接Graph Edit"
 "也可以不用twoway，但是当一张图中scatter和function都有时就用一下twoway"

 
*-3函数图(function)
 twoway(function)
 twoway(function y=exp(x))                  //默认从横坐标的零开始画
 twoway(function y=exp(x), range(-10 10))   //range用空格分开不用逗号，逗号分隔选项与命令
 
 twoway(function PDF=normalden(x))          //画正态密度图
 
 twoway(function PDF=normalden(x), lcolor(red)) //这里面不能用计算，只能用数
 twoway(function PDF=normalden(x), lcolor(red) xline(exp(-4)))//会报错,可以用macro解决
 
 local ymax=exp(-4)
 twoway(function y=exp(-x^2), xline(2 3) yline(`ymax' 0) range(2 3)) //x=2和x=3处都画
 
 twoway(func y=exp(-x^2),range(2 3) lcolor(black)) //函数线为黑色lcolor()
 
 *画出的图下方填充颜色
 twoway(func y=exp(-x^2),range(2 3) recast(area) color(blue)) //在range()填充颜色
                         //()中不加逗号代表区间                
 "填充颜色只能对一个函数图像的下面的全部部分进行填充"
 
 *把几张图放在一块
graph combine p1 p2 p1.gph
graph combine p1 p2 p1.gph, r(4) //r代表row排成四行
graph combine p1 p2 p1.gph, c(4) //c代表colum排成四列

erase p1,gph //删除硬盘里面的文件,无论图片什么的都可以
graph drop p1 //



**********************************lecture 7编程**********************************

*-1.macro:local global
 local ymax = exp(-4)                            //用ymax替代exp(-4),且经过计算
 twoway(function PDF=normalden(x)), yline(`ymax')//local必须要一起执行,这里的`ymax'就相当于是exp(-4)的小数表达
 
 local ymax exp(-4)                              //用ymax替代exp(-4),仅仅只是用ymax表示exp(-4)
 twoway(function PDF=normalden(x)), yline(`ymax')//这会儿就会出错
 
 local x = 2*2
 dis `x'                                         //dis会自己计算,所以显示出来4
 
 local x 2*2
 dis "`x'"                                       //显示字符串,local那里就不能加等号了,等号会计算

 global x = exp(-4)                              //global只要不关闭stata就一直有用,加等号会计算
 dis $x
 
 global x exp(-4)
 dis "$x"
 
 macro list                                      //找自己创建的macro,_下划线代表local
 "macro只是字面上的替代,local只能用一次,global只要不关闭stata就一直有用,global在不同的但同时打开的do文件中相同会冲突"
 "local如果在命令窗口中执行那就会global差不多,命令窗口会和local连在一起"
 "macro和scalar的区别,scalar只能用于计算,而macro既可以用于计算也可以用于表示"
 
 macro drop x                                    //删除已经设定的macro
 graph drop p2                                   //只能删除内存里面的图
 graph drop p1.pgh                               //删不了硬盘里的图
 
 use csp4
 correlate wage-exper 

 
*-2.loop

 gen newvar1 = 0
 foreach v of varlist wage-hrswk{        //v在foreach中是一个局部macro,foreach表示v要遍历wage到,遍历完了才结束
	replace newvar1=newvar1+`v'
	}                                            //v只能用局部macro
 
 foreach n of numlist 1/10{                      //numberlist数值列表
	dis `n'}
	
 forvalues n=1/10 {                              //forvalues只适合做连续的或者等差数列也行
	dis `n'
	}
	
 foreach n of numlist 0 2/4 1(2)5 30{            //foreach可以做非连续的,更加灵活
	dis `n'
	}
 dis `n' 会显示: 0 2 3 4 1 3 5 30

 clear
 set obs 6	
 foreach n of numlist 1/120{
    gen student`n' = runiformint(0,100)
	 }

 *从1加到100,会产生变量的办法
 clear
 set obs 1
 gen x = 0
 foreach n of numlist 1/100{
	 replace x = x+`n' 
	 }
 
 clear
 set obs 1
 gen x = 0
 forvalues n=1/100{
	replace x = x+`n'
	}

 *从0加到100,不会产生变量的办法
 clear                                           //stata每一行的开头必须要是指令
 local gauss = 0
 foreach n of numlist 1/100{
	 local gauss = `gauss' + `n'                 //把先定义好的`gauss'加上`1'赋予给
	 }                                           //gauss,然后再重复这一过程直至循环结束
 dis `gauss'

 
 clear
 set obs 10
 set seed 100
 gen gg=rnormal()                                //把gg变量第一个字母改为不是g就可以避免下面的问题
 scalar g=0
 forvalues i=1/2{
	scalar g=g+`i'                               //此处等号右边的g会索引到变量gg的第一个值
 }
 dis g                                           //显示以g开头的变量的第一个数值                              
 "dis 后面跟缩写时会先匹配变量,scalar的匹配居后,显示g能配对上的变量gg的第一个值"
 scalar list g                                   //显示出gg变量的第一个数加上2的值
 
*例如下面:
 clear
 set obs 10
 gen og=rnormal()                                
 scalar g=0
 forvalues i=1/2{
	scalar g=g+`i'                               
 }
 dis g                                           
 scalar list g 
 
 clear
 scalar g = 0
 forvalues j=1/14{
	scalar g = g+`j'
	}
 scalar list g                                    //当没有变量名和scalar名冲突时就会匹配对
 
 *生成stata中example.xls的数据
 clear
 set obs 6
 foreach j of numlist 1/120{
	gen student`j'=runiformint(50,90)
	}




*-3.if, else if, else
foreach j of numlist 1/100{
	if mod(`j',2)==0{                            //mod(x,y),取x/y的余数
		dis "`j'是一个偶数"
		}
	else{ 
		dis "`j'是一个奇数"
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

 forvalues j=-5/5{
	if `j'==0{
		dis "`j'为零"
		}
	else if mod(`j',2)==0{
		dis "`j'为偶数"
		}
	else {
		dis "`j'为奇数"
		}
}
 

*-4.while                                    //foreach得知道在哪个范围循环,循环次数已知
 问题:"比如说从1加到n和小于100时的n的最大值"
 
 clear
 local sunumber = 0
 local j = 1
 while `sunumber'<100{
	local sunumber = `sunumber'+`j'          //对sunumber急性更新
	local j = `j'+1
	}
dis `j'                                      //这个时候j并不是n的最大值
        //1+2+...+13<100,1+2+...+14>100;`sunumber'+14>100
	    //这时j还要进行一次+1运算,所以输出的会是15
			 
clear
local sunumber = 0
local j = 0
while `sunumber'<100{
	local j = `j'+1
	local sunumber = `sunumber'+`j'
	}
dis `j'                                        //这个时候j并不是所求的n值
   //`sunumber'+14就结束循环,这个时候j输出会是14
   
 *continue
 foreach j of numlist 1(2)10{
	if `j'==5{                                 //continue也可以理解为从头开始而不往下进行
	continue                                   //continue跳出满足条件的这个一次,然后再继续这个循环
	}                                          //j为5时这个时候就跳过这一次，然后再继续进行循环
	else{
	dis "j是`j'"
	}
	}

foreach j of numlist 1(2)10{
	if `j'==5{
	continue,break                             //if成立时会跳出整个循环,不会继续这个循环
	}
	dis "j是`j'"
	}

"当有嵌套的循环时内部循环完了才会在循环外部循环"
forvalues i=1/5{                              
	dis "i是`i'"
	forvalues j=1(2)10{                        //内部循环完了才会在循环外部循环,i刚开始是1
	if `j'==5{
	continue,break
	}
	dis "j是`j'"
	}
	}
	
*-5.program 

capture program drop hello                     //把原来已经有的hello去掉,避免重复会报错,为了代码的健壮性
 program define hello                          //define可以省略 program hello
	dis "hello world"
end                                            //这个program执行之后才可以使用
hello

".ado文件会自动寻找执行"
"stata执行操作时会从base->site->personal的顺序寻找文件执行"

program list hello                             //找到hello并且显示hello的内容
adopath                                        //显示出ado文件的路径

//自己编写的program可以保存到"/Users/mac/Documents/Stata/ado/personal/"自己创建文件夹

program cal
	dis "2+2" = 2+2
end

program calsquare                               //定义program名
	args k                                      //这个参数k在这里是局部macro
	dis "这个数的平方=" `k'^2
end	
calsquare 5                                     //把5赋给k

program calsum
	args a b                                    //这个参数a b在这里是局部macro
	dis "这两个数的和=" `a'+`b'
end	
calsum 5 6                                      //把5赋给a,6赋给b运行program calsum

program calsum2, rclass                         //把输出的值存在r类当中,clasum2是函数名
	args a b                                    //这个参数a b在这里是局部macro
	return scalar summation = `a'+`b' //这里把summation不是储存在scalar中,而是储存的rclass中
end	
calsum2 5 6                                     //求出5加6,先求出5+6但不显示出来,储存在r类当中
dis r(summation)

scalar  x = 1+2
scalar list                                     //列出所有标量

help su                                         //看看数值怎么储存的


 *求欧式距离
capture program drop Edistance
program Edistance, rclass                       //把Edistance输出的值存为r类
	args x y
	return scalar Edistance = sqrt((`x')^2+(`y')^2)
end
Edistance 3 4
dis r(Eucliddistance)


*-6.函数嵌套

capture program drop sq                   
program sq, rclass                              //这两行可以看作一起的,让stata知道sq 3 4是什么
	args d1 d2                                  //这里参数对应的就是要输入的数
	return scalar sqsum = `d1'^2+`d2'^2   
end

capture progra drop dist
program dist, rclass
	args x1 x2                             
	sq `x1' `x2'  
	return scalar d = sqrt(r(sqsum))
end

dist 3 4    //这里只是将输出的值算出来并储存了起来
dis r(d)    //这里才是将算出来的值显示出来

	 
*-模拟布朗运动:随机因素也会导致趋势
clear
set seed 100
set obs 2
foreach j of numlist 1/500{
	gen B`j' = rnormal()
	}
foreach i of numlist 2/500{
	local i_1 = `i' - 1
	qui:replace B`i' = B`i_1'[1] + B`i'[2] in 2 
	}
*-解题过程
clear
set seed 100
set obs 2
foreach j of numlist 1/500{
	gen B`j' = rnormal()
	}	
replace B2 = B1[1] + B2[2] in 2
replace B3 = B3[1] + B2[2] in 2
replace B4 = B4[1] + B3[2] in 2


*-老师给的解法	
clear
set obs 501
set seed 100
gen B = 0
global mu = 0
global sigma = 1
foreach i of numlist 1/500{
	local now = `i'+1
	qui:replace B = B[`i']+rnormal($mu,$sigma) in `now'
	}
	//in索引时后面只能用一个数不能运算
	//qui:replace ,quiet让提示不要出现,让他闭嘴

gen T = _n - 1 
twoway(scatter B T)
	
	
*-带飘移的布朗运动
clear
set obs 501
gen B=0
global mu = 0
global sigma = 1
foreach i of numlist 1/500{
	local now = `i' + 1
	qui:replace B = 0.2*`i' + B[`i'] + rnormal($mu,$sigma) in `now'
}
gen T = _n - 1
twoway(scatter B T)

replace B = 0.2*1 + B[1] + rnormal($mu,$sigma) in 2
replace B = 0.2*2 + B[2] + rnormal($mu,$sigma) in 3

"数字有多少到多少用/,变量有哪个到哪个只能是连续的用-"


********************************lecture 8一元回归********************************
*-1.导入Excel文件
import excel "/Users/mac/Desktop/stata/food.xlsx", sheet("Data") firstrow clear


*-2.导入txt文件
"整数型数据后面的tab键隔开的比较短,浮点型数据会大一些"

import delimited "/Users/mac/Desktop/stata/gdp出口.txt", clear 
//delimited表示有分隔符的数据

tsset year  //告诉stata我这是时间序列数据,这样之后时间序列操作才能用,ts:time series

*-3.倒入宽型数据
 *3.1把宽型的数据转为长型的
 rename 季度年份 year
 reshape long Q, i(year) j(year_q)

*-4.导入面板数据
 import excel "/Users/mac/Desktop/stata/面板数据示例.xlsx", sheet("Sheet1") firstrow clear
 
 encode province, gen(prv)  //用编码了的province生成对应的值标签,值标签从第一个往后从1开始标
 "红色是"字符串",stata无法操作字符串.把红色转为蓝色,蓝色是值标签."
 xtset prv year             //告诉stata设定为面板数据
 
 
*-5.一元回归
 *5.1描述性统计
 su
 ssc install logout //装一个导出数据的包
 
 logout, save(filename) word replace:su //save(文件名) word导出为word能识别的文件 replace是如果有重复把原来的替换掉
 logout, save(filename) excel replace:su //会导出到现在所在文件夹
 
 *5.2回归
 reg food income
 estimates store  model1 //把输出的模型储存下来,储存名为model1
 estimates replay model1 //把输出的结果掉出来
 
 gen lfood=log(food)
 gen linc=log(income)
 reg lfood linc
 est store model2
 
 reg food income in 1/25  //标示为1表示这个样本用到了
 est store model3
 
 su income
 local mean_income=r(mean)
 reg food linc if income > `mean_income'
 est store model4
 
 local mean_income=r(mean)
 gen id = income>`mean_income' //符合判断的是1不符合的是0
 gen id1 = 1 if income>`mean_income' //符合判断的是1,不符合的是.
 bysort id:reg food income //按id进行分组回归
 
 
 reg food linc if income > r(mean) //恶心,reg不能和r(mean)一起用
 gen p = 1 if income>r(mean) //这样可以
 
 estimate stats model1 model2 //对模型进行统计描述
 estimates table model1 model2, b(%7.4f) se(%6.2f) stats(aic r2)  //默认输出b,b(7.4f)占7位小数点后保留4位,f:float
 estimates table model1 model4, star(0.1 0.05 0.01)               //显示星
 estimates table model1 model4, star(0.1 0.05 0.01) se(%7.3f)     //显著性水平和其他t检验的指标不能共存
 
 estimates table model1, drop(_cons) se(%7.3f)                    //drop去掉不想要的系数       
 
 
 *5.3择信息
 "回归信息储存在e类中 help reg"
 help reg                                //在help reg里面找e类
 matrix list e(v)                        //dis展示出的结果只能是标量
 matrix list r(table)
 matrix trans_table = r(table)'          //生成一个新矩阵,这里可以运算
 matrix list trans_table
 
 dis trans_table[1,1]/trans_table[1,2]   //索引矩阵里面的数
 
 estimates replay model1
 estimates restore model1
 
 dis _b[income]                          //_b就是表示系数矩阵,这里不能用数字索引
 dis _b[_cons]
 dis _se[income] //se样本标准误差
3
 
 reg food income
 estimates replay model2                 //这个只能把原来输出的结果拿出来看一看
 matrix list e(b)                        //这里会展示最近的一个运算里面储存的值
 
 reg food income
 estimates restore model2                //激活model1但是不会展示
 matrix list e(b)                        //这时会输出model2中的结果
 
 est replay model2
 est restore model2
 est replay model2
 dis (e(mss)/e(df_m))/(e(rss)/(e(df_r))) //e(mss)里面存的是模型能解释的部分
 "e(rmse)这里面存的是标准误也就是(sigma_hat)"
 
 scalar f = (e(mss)/e(df_m))/(e(rss)/(e(df_r)))
 dis f                                   //dis 展示会先寻找能对应上的变量
 scalar list f                           //展示储存在f中的scalar
 
 estat vif          //estimators statistics
 vif                //与estat vif同样,有些可以简写有些不可以
 estat ic           //信息准则,这个就不能简写
 estat vce          //方差协方差矩阵
 
 db su              //调出su操作的窗口
 db reg
 
 
 
*5.4导出数据表
 *5.4.1 logout 导出所见即所得
 
 *5.4.2 estout 可以直接导出一群
 ssc install estout
 //直接导出
 esttab model1 using reg.rtf, b(%7.4f) se(%7.4f) nogap star(* 0.1 ** 0.05 *** 0.01)  ///  //输出为doc类型文件可以WPS打开
                        stats(r2 r2_a aic bic) replace
 
 esttab model1 using reg.rtf, b(%7.4f) se(%7.4f) nogap star(* 0.1 ** 0.05 *** 0.01)  ///   //输出为rtf类型文件.rtf只能在记事本中打开
                        stats(r2 r2_a aic bic rss) replace mtitle("食物" "收入")    
						
 //存储后再导出						
 est store reg food income
 
 
 *5.4.3 outreg2 只能一个一个导出 苹果电脑用不了呜呜呜
 ssc install outreg2
 est restore model1
 outreg2 model1 using outreg2.doc, bdec(4) tdec(3) //bdec:b小数点后四位
 
 outreg2 model1 using outreg2.doc, dec(4) //dec直接所以都是四位小数
 
 outreg2 model1 using outreg2.doc, bdec(4) tdec(3) stats(r2 r2_a) ///
                                   ctitle("基准回归")
 outreg2 model1 using outreg2.excel, bdec(4) tdec(3)
 
 outreg2 model2 using outreg2.doc, bdec(4) tdec(3) dec(3) ///
                                   stats(r2 r2_a) ///
                                   ctitle(benchmark)
 						   
 
 *5.5虚拟变量,因子变量
 *虚拟变量
 su income
 gen income_h = income>20
 reg food income_h
 
 su food if income_h==1
 dis r(mean)==_b[_cons]+_b[income_h]
 
 su food if income_h==0
 dis r(mean)==_b[_cons]                             //这里会不相等就因为保留的小数不同,注意样本与总体的区别
 
 su income, detail
 drop low_inc
 gen low_inc = income<r(p25)
 gen mid_inc = income>=r(p25) & income<=r(p75)
 gen high_income = income>r(p75) 
 reg food mid_inc high_income
 reg low_inc food mid_inc high_income
 reg low_inc food mid_inc high_income, nocons       //nocons不要常数项
 
 *因子变量
 su income, detail
 drop class 
 gen class =1  if low_inc
 replace class = 2 if mid_inc
 replace class = 3 if high_inc
 list i.class low_inc mid_inc high_inc              //1.# #有m个水平值那就产生m个虚变量
 
 reg food i.class 
 su food if low_inc==1
 dis _b[_cons]
 dis r(mean)
 dis r(mean)==_b[_cons]
 
 reg food ib51.class
 
 list c.income                                      //列出来和list income 一样,c.income直接就是因子变量不用创建
 list c.income income
 
 reg food income income^2                           //会报错income^2这个变量都没有而且变量名不支持这个样子
 
 reg food income c.income#c.income                  //c.income相乘用#
 list c.income##c.income                            //两个#包含因子本身和因子的平方
 reg food c.income##c.income
 
 list c.food##c.income                              //包含本身以及他们的交叉项
 
 
 *5.6simulate
 
 
 
 
 
*******************************lecture 9 多元回归*********************************
 use nerlove.dta
 local vlist tc-pk
 foreach v of varlist `vlist'{
	gen ln_`v'=log(`v')
	}
	
*-9.1 做回归,导出回归结果


*-9.2 约束检验
 *9.2.1 线性约束检验 
 reg ln_tc ln_q-ln_pk
 test ln_pl+ln_pf+ln_pk=1                            //tset跟在回归后做线性约束的wald检验
                                                     //线性约束既可以用变量表示也可以用系数表示
 reg ln_tc ln_q-ln_pk
 test (ln_pl+ln_pf+ln_pk=1) (ln_q+ln_pl=0.5)         //可以施加多个线性约束
 
 reg ln_tc ln_q-ln_pk
 test _b[ln_pl]+_b[ln_pf]+_b[ln_pk]=1                //与上等价
 
 reg ln_tc ln_q-ln_pk
 lincom ln_pl+ln_pf+ln_pk-1                          //看这个东西是否为0,lincom本质是t检验,而t检验是看是否显著异于0
 lincom _b[ln_pl]+_b[ln_pf]+_b[ln_pk]-1
 
 lincom ln_q                                         //和lincom ln_q-0等价

 *9.2.2 非线形约束检验
 reg ln_tc ln_q-ln_pk
 testnl _b[ln_pl]=_b[ln_q]^2                         //nl:non-linear
 
 reg ln_tc ln_q-ln_pk
 nlcom _b[ln_pl]-_b[ln_q]^2

 
*-9.3 带约束的回归

 constrain 1 ln_pl+ln_pf+ln_pk=1                      //首先定义约束,前面的1表示是第一个约束
 constrain 2 _b[ln_pl]=_b[ln_q]^2                     //线性和非线形约束可以同时存在
 cnsreg ln_tc ln_q-ln_pk, c(1 2)                      //可以同时多个约束
 
*-9.4 LPM--线性概率模型:有缺陷
 use mroz.dta, clear                                  //什么因素导致妇女就业
 label variable inlf "in labor force" 
 
 reg inlf exper c.exper#c.exper kidslt6 educ huswage  //平方项的意义:引入了边际贡献递减的规律.倒U型关系二次项最好为负的
 //系数如何解读呢?比如说beta3=-0.168,就是说kidslt6增加一个单位inlf=1的概率平均减少0.168
 
 predict inlf_hat, xb                                 //产生拟合值并出现在变量中
 predict residual, r                                  //产生残差项
 
 "reg与logistic回归的不同,线性回归对虚拟变量做回归有缺陷？"
 "reg的拟合值可能超出1或者为负值,logistic回归可以规范为1"
 
 gen pc = inlf_hat>=0.5
 gen correct = pc==inlf
 su correct 
 dis r(mean)                                          //如果r(mean)较大的话设置的0.5位界限就还挺不错
 
*-9.5 partialling out--控制变量的作用
 use "/Users/mac/Desktop/stata/nerlove.dta", clear
 reg tc-pk
 *方法1
 global control pl-pk            //认为哪些变量会对估计结果产生影响就控制这个变量,控制变量的目的就是让核心变量变的干净
 reg q $control                                       //拿控制变量对核心解释变量做回归
 predict e, r                                         //把核心解释变量中能被其他变量解释的部分剔除出去
 reg tc e                                             //把能被其他变量解释的部分剔除之后剩下得就只是核心解释变量对被解释变量的解释了
 
 *方法2
 //把整个模型中的其他解释变量能解释的部分全部剔除出去
 reg tc $control
 predict e_tc, r
 reg q $control
 predict e_q, r
 reg e_tc e_q  
 
 
*******************************lecture 10 多元回归********************************
 dr                                                  //看看当前文件夹里面有什么文件
 
 use price2023.5.dta, clear
 
 *-10.1检验异方差
 * 10.1.1 scatter画图 画图要用残差的平方
 reg price lot-bd                                    //截面数据一般没有序列相关
 predict e, r
 gen e_2=e^2
 twoway scatter e_2 lotsize
 
 twoway scatter e_2 sqrft                            //对每一个解释变量做图只要有一个出现异方差就有异方差,全部显示没有才没有
 
 reg price lot-bd                                    //截面数据一般没有序列相关
 rvfplot                                             //用拟合值画残差图

 
 * 10.1.2 BP检验
 estat hettest                                       //estat hettest默认正态的检验,hettest:异方差检验
 estat hettest, iid                                  //可以非正太,但是需要大样本
 
 estat hettest lot                                   //只用一个变量对e^2回归,就像画图一样
 estat hettest lot-bd                                //相当于reg e^2 lot hqrft bdrms
 
 estat hettest lot-bd, mtest                         
 
 
 * 10.1.3 White检验:用变量的一次项
 estat //看estat回归以后的结果
 
 estat imtest, white                                      //white检验,imtest表示用信息矩阵检验
 estat hettest (c.lotsize-bdrms)##(c.lotsize-bdrms), iid  //这是手动做法与white检验一样
 
 //(c.lotsize-bdrms)##(c.lotsize-bdrms) 
 //相当于 lotsize sqrft bdrms lotsize*sqrft lotsize*bdrms sqrft*bdrms lotsize^2 sqrft^2 bdrms^2

 //(c.lotsize-bdrms)先是lotsize到bdrms然后取因子变量
 
 *-10.2 消除异方差
 * 10.2.1 取对数  有时候变量不能取对数:(1)可能会有负数的变量 (2)有限的正整数
 "取对数为什么可以削弱共线性与异方差等？"
 
 foreach v of varlist price-sqrft{
	 gen ln_`v'=log(`v')
	 }
 reg ln_price-ln_sqrft bdrms
 estat imtest, white                                //这个时候就不拒绝同方差的假定了
 
 * 10.2.2 用稳健标准误 vce(robust),样本量大的时候比较好
 reg ln_price-ln_sqrft bdrms, vce(robust)           //与简单的reg相比就是标准误变了,估计的系数不变
 reg ln_price-ln_sqrft bdrms, r                     //r是robust的简写
 
 * 10.2.3 FGLS——feasible generalized least square
 //WLS加权最小二乘是FGLS的一个特例,
 reg price-bdrms
 predict e,r
 gen e_2 = c.e#c.e
 reg e_2 (c.lotsize-bdrms)##(c.lotsize-bdrms)       
 
 reg e_2 lot-bd
 
 * 加权最小二乘命令写法
 reg price-bdrms [aw=1/lotsize]                     //加权最小二乘用命令写
 estat imtest, white                                //stata不支持加权最小二乘的white检验,那就用BP手动
 
 * 加权最小二乘具体步骤写法
 foreach v of varlist _all{                         //手动写加权最小二乘
	gen w_`v' = `v'/sqrt(lotsize)
	}
 gen w_1 = 1/sqrt(lotsize)
 reg w_*, nocons                                    //*星号是通配符
 estat imtest, white                                //再检验一下异方差
 
 reg w_*, nocons r                                  //若稳健标准误和加权过后的估计差距不大那么就说明加权后处理异方差效果很好
 
 
 *-10.2 序列相关/自相关 GLS-->GDM广义差分
 use "/Users/mac/Desktop/stata/消费data.dta", clear
 tsset year  //time series set 告诉stata这是时间序列数据, year就是你的时间
 
 * 时间序列特有的回归
 twoway (connect lcons lw linc r year)            //最后一个放时间
 tsline lcons lw linc r, lpattern(dot solid dash) //画图会自己识别时间序列
 
 reg lcons lw linc r, r                           //选项r表示如果有异方差稳健标准误下t检验也靠谱,如果没有异方差就和普通回归一样
 
 * 10.2.1 图示法
 reg lcons lw linc r
 predict e, r
 twoway   (scatter e L1.e)  ///                   //L1.e表示e滞后一期
       || (lfit e L1.e)                           //用L1.e时必须是时间序列数据,先让stata知道是时间序列
	   
 * 10.2.2 BP/LM检验
 reg lcons lw linc r
 estat bgodfrey                      //一阶BG检验
 estat bgodfrey, lags(2)             //二阶BG检验,bgodfrey检验中用到两个滞后项
 estat bgodfrey, lags(1/10)          //1到10阶的BG检验
 
 reg e L1.e lw linc r                //一阶BG检验的辅助回归,这个L1.e系数显著
 reg e L2.e  lw linc r               //二阶BG检验的辅助回归,这个L2.e系数不显著,这个时候可以初步判断为一阶自相关
 //初步判断是一阶自相关后再用DW检验如果DW检验也是一阶那么就更加确认是一阶
 
 reg e L(1/2).e lw linc r            //一起检验,相当于reg e L1.e lw linc r和reg e L2.e  lw linc r一起
 
 * 10.2.2 DW检验:只能检验一阶自相关,但是检验的很准对于一阶DW检验比BG更准
 //宏观时间序列很多时候是一阶自相关的
 reg lcons lw linc r
 estat dwatson
 
 * 10.3 序列相关的消除
 * 10.3.1 F-GLS
 * (1) CO迭代法:科克伦奥科特迭代
 prais lcons lw linc r               //prais-winsten提出的检验
 prais lcons lw linc r, corc         // prais后面跟上回归里面的被解释变量和解释变量
 
 * (2)Durbin两步法
 "先找出是几阶的序列相关"
 
 
 
 * 10.3.2 异方差-序列相关稳健标准误(HAC):hete-ar-consistent 规避序列相关和异方差的后果使得t检验仍然准确
 //有异方差或者序列相关就规避如果没有就和普通回归没啥区别
 newey lcons lw linc r, lag(3)  //括号里面是你自己认为的可能最高阶数,这里的lag不加s,因为这里是你认为的最大值只是一个值
 //lags(#)中#建议选择为N^0.25或者0.75*N^(1/3)
 dis _N^0.25
 dis 0.75*_N^(1/3)
 newey lcons lw linc r, lag(3) 
 
 "当用好几种方法估计时一个办法系数显著而另一个系数不显著,那么看系数是不是很接近于0"
 
 

******************************lecture 11 内生性和IV******************************
 "内生性的后果:有偏不一致"
 "准对截面与面板的内生性,内生性的原因:双向因果,遗漏变量,样本自选择(例如调研数据不对),测量误差"
 "解决内生性的办法:IV、代理变量、面板、联立方程、DID、RD......"
 "为什么面板是消除内生性的"
  *-11.1 工具变量
  * 作为IV的必要条件 (1)IV引入后不能有内生性 (2)IV需要与内生变量相关
  
  reg 经济增长 制度 经济增长与制度双向因果
  第一步:找制度的代理变量,财产制度,作者认为制度中最根本的是财产制度,要论证一下吧
  第二步:从财产制度往下找-->殖民者对殖民地的喜爱程度-->殖民者登陆殖民地时的死亡率,找到能找到数据的
 
 *-11.2 工具变量分类:恰好识别,过度识别和不可识别
 *恰好识别:一个变量对应一个工具变量
 *过度识别:一个变量对应多个工具变量
 *无法识别:好几个变量有内生性但是找不到足够的工具变量
 
 *-11.3 工具变量估计方法
 *两阶段最小二乘
 "大样本性质:一致性,渐近无偏,渐近正态性"
 drop if inlf==0
 reg lwage edu exper expersq, r
 
 use "/Users/mac/Desktop/stata/mroz.dta", clear
 reg lwage edu exper expersq if inlf==1, r
 //代理变量 IQ-->ability,被代理的变量可以没有数据所以采用代理变量
 //工具变量 被工具变量的的变量必须要有数据,才可以做一阶段回归嘛
 
 use "/Users/mac/Desktop/stata/mroz.dta", clear
 reg lwage edu exper expersq if inlf==1, r
 estimates store ols_r
 
 reg lwage edu exper expersq if inlf==1
 estimates store ols
 
 *内生变量对 IV(mothedu)以及所有"外生控制变量"做回归
 dis _N //样本量大才好
 *手动分两阶段会出现误差
 "第一阶段"
 reg educ mothedu exper expersq if inlf==1 //经验说mothedu的t检验值大于3.3几说明还不错,这个工具变量就还不错
 test mothedu //F值很大时工具变量选的就挺好,强工具变量
 *当工具变量个数为1,2,3,4时,F临界值为8.96,11.59,12.83,22.88
 
 predict eduIV, xb //mothedu exper expersq外生那么他们的线性组合也是外生的
 
 
 
 "第二阶段"Y对 IV_hat和所有外生的控制变量做回归
 reg lwage eduIV exper expersq if inlf==1, r
 
 *直接用命令一次性减小误差
 ivregress 2sls lwage exper expersq (educ=mothedu) if inlf==1,  r //括号里面是要被工具变量的,等号右边是用来做工具变量的变量
 
 ivregress 2sls lwage exper expersq (educ=mothedu) if inlf==1,  r first //first表示把合着的两阶段分为两个阶段
 estimates store iv1
 
 
 *两个工具变量
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1,  r first //用两个工具变量
 estimates store iv2
 
 reg educ exper expersq mothedu fathedu
 *工具变量强弱检验,F值越大越是强工具变量
 test (mothedu=0) (fathedu=0) //约束检验看F值
 
 *外生性检验(没法做),对于过度识别的情况sargen检验可以一定程度上检验外生
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1,  r first
 estat overid
 
 ivregress 2sls lwage exper expersq (educ=mothedu fathedu) if inlf==1 //做sargen检验默认没有异方差,或者要消除异方差,这里不能加robust的选项,加了robust不会报告sargen检验值
 estat overid
 
 *内生性检验:如果没有内生那么工具变量法和没有用工具变量法算出来的beta们很接近,如果内生用工具变量和不用工具变量的出来的beta们差距大
 *那么可以根据beta们差距大不大来判断是否内生
 *没有内生性IV法和不用IV法差不多
 hausman iv2 ols_r, constant sigmamore //会报错,hausman检验不能有robust
 
 ivregress 2sls lwage exper expersq (educ=mothedu) if inlf==1
 estimates store iv2_heter
 hausman iv2_heter ols, constant sigmamore
 "为了谨慎这里p值以10%作为临界"
 
 ivregress 2sls lwage exper expersq (educ=mothedu) if inlf==1
 estat endogenous //这个也能做hausman检验
 
 潜在结果只有一个可以观测到
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 











