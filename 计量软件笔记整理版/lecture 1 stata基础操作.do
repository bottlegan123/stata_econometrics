***************************lecture 1 stata基本操作*******************************

*-1.路径
 pwd                                     //显示当前工作路径
 cd "/Users/mac/desktop/stata"           //更换工作目录，就可以直接读这个路径下的文件了
 dir                                     //显示当前路径下的文件
 
*-2.帮助
 help reg                                //已经知道命令是什么，找命令怎么写
 search linear regression                //不知道命令是什么，但是知道是什么名字
 ssc hot                                 //寻找最近用的火的方法
 ssc new                                 //寻找最近新的方法
 ssc install                             //直接下载ssc网站的外部命令
 findit dynamic panel                    //搜索关键词，下载外部命令
                                         //findit is equivalent to search
 db                                      //弹出窗口进行了相关操作
 
*-3.变量创建与修改
 generate ln_mpg=log(mpg)                //产生新变量
 gen price_2=price^2, after(mpg)         //产生新变量，并且在mpg变量的后面
 gen price_2=price^2, before(mpg)        //产生新变量，并且在mpg变量的前面
 gen dif= edu!=exp                       //dif 不等时等于为1,相等时为0
 
 
 gen int = int(wage), after(wage)         //舍去小数点后的部分,既不是向上取整数也不是向下取整数
 gen below = floor(wage)                  //向下取整数
 gen up = ceil(wage)                      //向上取整数
 gen sishewuru = round(wage), after(wage) //四舍五入保留整数
 
 
 dis sum(wage)                            //这不能对sishewuru求和
 "怎么对wage求和呢？"
 import excel "/users/mac/desktop/stata/cps4_small.xlsx", firstrow clear
 scalar sum = 0
 foreach j of numlist 1/1000{
	scalar sum = wage[`j'] + sum
	}
 scalar list sum
 su wage
 dis r(mean)*1000==sum                   //这个不想等是为什么
 
 
 gen wage_4=wage^4, before(edu)          //edu本来是educ没有写全,但stata自动匹配唯一能对应上的变量
 replace wage_3=wage^0                   //替换掉原来的已经定义的
 
                              "mean是指令不是函数，不能用于计算"                            
                              "max,min是函数"                              
 mean wage                              //显示wage的均值
 max(wage)  "报错"                       //报错,因为max是函数而stata每一行命令必须以指令开头
 dis max(wage)   "报错"                  //max作为函数只能计算具体数值,不能算变量
                                        //su wage 中已经有最大最小值了,和,标准差,分位数都出存在rclass中
 dis max(1,2,3,4)
 
 gen mean_wage=r(mean), after(wage)
 gen mean_wage=mean(wage)               //会报错
 egen                                   //egen new_var_name = fcn(#) [if] [in] [, options]
 egen mean_wage=mean(wage)              //这个不会报错,egen后面可以用function()不可以跟具体的函数
 egen wage4=wage^4                      //会报错,egen不能包含gen的功能, egen newvar = fcn(arguments)
 
 bysort educ: su wage
 bysort educ: gen meanwage = r(mean)    //r(mean)只会取到离自己最近的r(mean)
 
 sysuse auto.dta, clear
 rename old_varname new_varname         //修改变量名
 rename (price mpg) (pri mp)            //批量修改变量名,批量修改要加上括号来识别哪些是要修改的
 rename (v1-v3) (price mpg rep78).      //批量修改连续挨着的变量名
 "变量连续用-,数连续用/,或者连续等差数用1(3)9"
 
 import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", sheet("Data") firstrow clear
 label var var_name "new_label"         //给变量贴标签，变量标签可以中文也可以英文
 label var educ "教育年限"
 label var wage "工资/年度/元"            //汉字的时候最好用""表示字符串
 label var wage "w"                     //英文既可以用""也可以不用""
 //所以综上,贴标签一律加上""以表示字符串
 
 keep var_name                           //保留变量,其他变量全部删掉
 keep wage - married                     //保留从wage到married连着的
 drop var_name                           //去掉变量
 drop wage - married                     //去掉从wage到married连着的
 
 scatter educ wage, msize(tiny)          //作图时会显示出标签,如果没有标签就会用变量名
 
*-生成判断语句的值
 gen hedu=1 if edu > 16
 replace hedu=0 if edu<=16               //两行一起执行，edu大于16的为1，小于等于16的为0
 
 gen hedu9=cond(edu>16,1,0)              //条件，满足条件时的值，不满足条件的值
 
 gen hedu5 = edu > 16                    //等号后面用判断语句
 ".表示的缺失值,也表示正无穷"
 gen heduc_hwage = wage>20 & educ>16     //可以跟多个判断
 
 
 *产生一个0,1,2,3的虚拟变量
 drop dwage
 gen dwage = 2 if wage >=30, after(wage)
 replace dwage = 1 if wage>=20 & wage<30
 replace dwage = 0 if wage<20

*-4.贴值标签:分为两步
 *这个只对于比较少的值标签好用,多了就不好用了,把红色的字变为蓝色的字,stata不能操作字符串
 label define gender 1 "male" 0 "female"   //定义值标签,这里gender只是一种表示可以用任意的,但需要前后对应上
 label value female gender                 //贴上值标签
 
 
 *编码字符串
 encode varname, gen(new_varname)          //这会产生一个新变量
 
*-5.描述数据
 describe                                  //des 描述数据形态,作用不大
 des2                                      //比describe好用一点,有链接可以跳转
 des [varlist]                             //描述某一个或者多个变量
 
 su wage                                   //对wage进行统计描述 su [varlist]
 su wage educ
 summarize wage, detail                    //更加详细的price的统计描述
 codebook                                  //描述数据，数据的分位数，最大最小值，均值等,codebook [varlist]
 
 tabulate                                  //频数统计,tab最多写两个变量
 tabulate wage educ                        //每一个工资下的教育年限
 
 tabulate educ wage                        //观测值太多还列不出来
 tab female, sum(educ)                      
 tab female , sum(exper) mean              //只列出mean不列出频数
 sort wage in f/5                          //f代表first序号为1
 su wage in 4/l                            //对变量price的第四个元素到最后一个元素summarize         

 
*-6.数据处理
 order educ wage black                     //把变量拿到最前面并排序
 append using filename                     //数据纵向相加      
 merge using filename                      //数据横向相加
 
 sort wage                                 //wage升序排列,顺序排列是向量的变化,整行都变化             
 sort wage educ                            //只会对wage排序
 gsort -wage                               //gsort表示广义排列既可以升序也可以降序
 gsort wage
 //综上干脆只用gsort算了,但是gsort不能在逗号后面不能作为选项
 drop if married==1                      //删除married等于1时的观测，对行操作
 "drop wage if married==1                //会报错，stata做向量变化"
 keep if _n > 9                          //保留10号位及10号位之后的所有观测值
 
 *by的用法,by前缀作为分类
 "_n表示从第一个观测值到最后一个进行按顺序编号,_N表示观测值的个数"
 by exper, sort: gen i = _n, after(exper)    //先对exper按大小升序排,然后相同序号位置的作为一类,再在每一类里面进行gen 操作
 "by exper, gsort: gen i = _n, after(exper)" //会报错,gsort不能作为选项
 by exper, sort: gen j = _N, before(exper)   //新变量_N表示观测值个数
 by wage, sort: gen k = wage[1], after(wage) 
 
 "怎么得到按照educ分好后找到每一个educ分类下的最大值"
 by educ, sort: su wage                     
 
 "[]用于索引,索引某一个变量的第几号位的值"
 
 by female, sort: sum wage                 //对female排序在相同序号位置进行su price操作
 bysort female: sum wage                   //bysort实现的作用和上面一样
 
*-7.dis的计算器功能
 display
 dis log(10)
 dis 2<3                                   //<,>,==,!=判断的计算结果是布尔数true为1,false为0
 dis 2>3 | 3>2      "|"代表或
 dis 3>2 & 1<4      "&"代表且
 
*—8.日志
 log using filename,replace                //执行之后后台就会记录我们的操作了
 log off                                   //暂停log的使用
 log on                                    //重新启用log
 log close
 "日志不会记录窗口操作,只会记录显示窗口里面的结果"
 
 log using filename, replace  
 bysort female: sum wage   
 log close
 
*-9.保存数据
 save newdata.dta                        //这样保存知道自己把着一数据保存成了什么名字
 use newdata.dta                         //使用当前路径下的dta文件
 
*-10.通配符 "*" "?"                       //*能表示很多，？只能表示一个
 keep w*                                 //保留w开头的所有变量
 drop *t                                 //去掉t结尾的变量
 drop sou?h                              //中间有一个字母不记得,或者只有这一个字母不通其他字母都相同的变量全部去掉
 
*-11.索引,索引用方括号
 _n                                      //表示1,2,3,4,...,N
 dis wage[_N]                            //索引出最后一个观测值
 dis wage[1]                             //索引wage中第一个数
 
 local x = 13
 dis wage[`x']
 
 sclar x = 13
 dis wage[x]
 
 replace wage=2 in 1                     //把wage变量的1号位用2替换
 
 
 
 
 
 
 
 
 
 
