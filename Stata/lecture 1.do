***************************lecture 1 stata基本操作*******************************

*-1.路径
 pwd                                    //显示当前工作路径
 cd "/Users/mac/desktop/stata"          //更换工作目录，就可以直接读这个路径下的文件了
 dir                                    //显示当前路径下的文件
 
*-2.帮助
 help reg                               //已经知道命令是什么，找命令怎么写
 search linear regression               //不知道命令是什么，但是知道是什么名字
 ssc hot                                //寻找最近用的火的方法
 ssc new                                //寻找最近新的方法
 ssc install                            //直接下载ssc网站的外部命令
 findit dynamic panel                   //搜索关键词，下载外部命令
 db                                     //弹出窗口进行了相关操作

*-3.变量创建与修改
 generate ln_mpg=log(mpg)               //产生新变量
 gen price_2=price^2, after(mpg)        //产生新变量，并且在mpg变量的后面
 gen price_2=price^2, before(mpg)       //产生新变量，并且在mpg变量的前面
 gen dif= edu!=exp                       //dif 不等时等于为1,相等时为0
 
 gen wage_4=wage^4, before(edu)          //edu本来是educ没有写全,但stata自动匹配唯一能对应上的变量
 replace wage_3=wage^0                   //替换掉原来的已经定义的
 
                              "mean是指令不是函数，不能用于计算"                            
                              "max,min是函数"                              
 mean wage                              //显示wage的均值
 max(wage)  "报错"                       //报错,因为max是函数而stata每一行命令必须以指令开头
 dis max(wage)                          //max作为函数只能计算具体数值,不能算变量
 dis max(1,2,3,4)
 
 gen mean_wage=mean(wage)               //会报错
 egen mean_wage=mean(wage)              //这个不会报错,egen后面可以用function()不可以跟具体的函数
 egen wage4=wage^4                      //会报错
 
 rename old_varname new_varname         //修改变量名
 rename (price mpg) (pri mp)            //批量修改变量名,批量修改要加上括号来识别哪些是要修改的
 rename (v1-v3) (price mpg rep78).      //批量修改连续挨着的变量名
 "变量连续用-,数连续用/,或者连续等差数用1(3)9"
 
 label var var_name "new_label"         //给变量贴标签，变量标签可以中文也可以英文
 label var educ "教育年限"
 label var wage "工资/年度/元"            //汉字的时候必须要用""表示字符串
 label var wage "w"                     //英文既可以用""也可以不用""
 //所以综上,贴标签一律加上""以表示字符串
 
 keep var_name                           //保留变量,其他变量全部删掉
 keep wage - married                     //保留从wage到married连着的
 drop var_name                           //去掉变量
 drop wage - married                     //去掉从wage到married连着的
 
 scatter educ wage                      //作图时会显示出标签

*-4.贴值标签:分为两步
 label define gender 1 "male" 0 "female"   //定义值标签,这里gender只是一种表示可以用任意的,但需要前后对应上
 label value female gender                 //贴上值标签
 
*-5.描述数据
 describe                                  //des 描述数据形态,作用不大
 des2                                      //比describe好用一点,有链接可以跳转
 des var_name                              //描述某一个或者多个变量
 su price                                  //对price进行统计描述
 summarize price, detail                   //更加详细的price的统计描述
 
*-6.数据处理
 order educ wage black                     //把变量拿到最前面并排序
 sort wage                                 //wage升序排列,顺序排列是向量的变化,整行都变化             
 sort wage educ                            //只会对wage排序
 gsort -wage                               //gsort表示广义排列既可以升序也可以降序
 gsort wage
 //综上干脆只用gsort算了,但是gsort不能在逗号后面不能作为选项
 
 *by的用法,by前缀作为分类
 "_n表示从第一个观测值到最后一个进行按顺序编号,_N表示观测值的个数"
 by exper, sort: gen i = _n, after(exper)  //先对exper按大小升序排,然后相同序号位置的作为一类,再在每一类里面进行gen 操作
 by exper, sort: gen j = _N, before(exper) //新变量_N表示观测值个数
 by wage, sort: gen k = wage[1], after(wage) 
 
 "[]用于索引,索引某一个变量的第几号位的值"
 
 by female, sort: sum wage                 //对female排序在相同序号位置进行su price操作
 bysort female: sum wage                   //bysort实现的作用和上面一样
 
*-7.dis的计算器功能
 display
 dis log(10)
 dis 2<3                                   //<,>,==,!=判断的计算结果是布尔数true为1,false为2
 dis 2>3 | 3>2      "|"代表或
 dis 3>2 & 1<4      "&"代表且
 
*—8.日志
 log using filename,replace              //执行之后后台就会记录我们的操作了
 log off                                 //暂停log的使用
 log on                                  //重新启用log
 log close
 "日志不会记录窗口操作,只会记录显示窗口里面的结果"
 
*-9.保存数据
 save newdata.dta                        //这样保存知道自己把着一数据保存成了什么名字
 use newdata.dta                         //使用当前路径下的dta文件
 
 
 
 
 
 
 
 
