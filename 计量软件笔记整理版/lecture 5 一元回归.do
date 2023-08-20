********************************lecture 5一元回归********************************
*-1.导入Excel文件
 import excel "/Users/mac/Desktop/stata/food.xlsx", sheet("Data") firstrow clear


*-2.导入txt文件
"整数型数据后面的tab键隔开的比较短,浮点型数据会大一些"

 import delimited "/Users/mac/Desktop/stata/gdp出口.txt", clear //delimited表示有分隔符的数据

 tsset year  //告诉stata我这是时间序列数据,这样之后时间序列操作才能用,ts:time series

*-3.导入宽型数据
 rename 季度年份 year
 reshape long Q, i(year) j(year_q)                             //把宽型数据变为长型数据
 reshape wide                                                  //把变为长型的数据变为宽型的数据
 
*-4.导入面板数据
 import excel "/Users/mac/Desktop/stata/面板数据示例.xlsx", sheet("Sheet1") firstrow clear
 
"stata是无法操作非数据的,处理字符串需要先把字符串转变为带值的数据,字符串在数据表格里面是红色的,蓝色的是值"
 
 import excel "/Users/mac/Desktop/stata/副本宽型数据.xlsx", sheet("Sheet1") firstrow clear
 encode varname [if] [in] , generate(newvar)                   //编码变量
 encode provinceyear, gen(py)
 drop provinceyear                     
 
 decode varname [if] [in] , generate(newvar)                   //把编码后的值变量变为字符串
 decode py, gen(prvy)

 import excel "/Users/mac/Desktop/stata/副本宽型数据.xlsx", sheet("Sheet1") firstrow clear
 encode varname [if] [in] , generate(newvar)                   //编码变量
 encode provinceyear, gen(py)
 drop provinceyear  

 xtset province year                                           //告诉stata我这个是面板数据
 
*-5.一元回归

 *5.1 数据描述与输出
 import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", sheet("Data") firstrow clear
 ssc install logout
 
 su wage 
 logout, save(wage) word                                       //把刚才运行的结果输出并保存为word可以打开的文件
 logout, save(wage) replace:su                                 //必须要加上文件的格式word或者Excel等,不然不能输出为文件
 logout, save(wage1) word replace:su                           //replace选项表示把原来的文件替代掉
 
 *5.2 回归
 *5.2.1 save and use results from disk
 reg wage educ
 estimates save model1                                         //把刚运行的估计结果以文件名为model1存在磁盘里面
 estimates use model1                                          //激活磁盘里面的文件名为model1的文件里面储存的结果
 dis e(mss)                                                    //reg的结果存在e类里面
 "dis不可以显示矩阵"
 
 dis e(df_m)                                                   //模型的自由度
 dis e(df_r)                                                   //残差的自由度
 
 *5.2.2 store and restore estimates in memory                  //磁盘里面的文件和内存里面的文件重名没关系,自己能区分开就好
 reg wage exper
 estimates store model1                                        //把刚输出的结果以model1的名储存在内存中
 estimates replay model1                                       //就是把文件名model1的在内存里面的拿出来看一看,仅仅是拿出来看一看呐
 
 
 reg wage hrswk 
 estimates store model2
 estimates replay model1                                      
 dis e(mss)                                                    //输出的会是reg wage hrswk的e(mss),而不是model1的e(mss)
 
 estimates restore model1                                      //再次激活model2
 dis e(mss)                                                    //现在会显示model1的e(mss),因为重新激活了model1
 
 reg wage educ in 1/50                                         //_est_model3为1表示这用到了一行的观测值
 est store model3

 "************************************"
 su wage
 reg wage educ if wage > r(mean)                               //这里会显示无观测值,if后面只能用具体的数
 
 reg food linc if income > r(mean)                             //恶心,reg不能和r(mean)一起用
 su wage
 gen p1 = 1 if wage>r(mean)                                    //这样也不能达到让wage大于wage平均值的生成1
 su wage
 gen p2 = wage>r(mean)                                         //这样也不可以
 "************************************8"
 
 local wmean = r(mean)
 reg wage educ if wage > `wmean'                               //用macro可以解决刚才的问题
 
 drop id
 su wage
 local wmean = r(mean)
 gen id = wage>`wmean', after(wage)                            //生成判断变量
 bysort id: reg wage educ                                      //按照id变量分类进行回归
 
 *5.3把输出的结果表格化
 
 estimate stats model1 model2
 estimates table model1 model2, b(%7.4f) se(%6.2f) stats(aic r2) //aic.bic:赤池信息准则和贝叶斯信息准则
 //默认输出b也就是估计的参数,b(%7.4f)占7位小数点后保留4位,f:float,se(%6.2f):标准差浮点数保留两位有效数字
 
 estimate table model1 model2, star(0.1 0.05 0.01) se(%7.3f)   //会报错,因为显著性水平和其他t检验的指标不能共存
 
 estimates table model1, drop(_cons) se(%7.3f)                 //drop去掉不想要的系数 
 
 estimates table model1 model2, star(0.1 0.05 0.01) b(%12.3f) se(%12.3f) nogap compress s(N r2 ar2)
 
 *5.4 找信息
 help su                                                       //su输出的结果都储存在r类中
 help reg
 est restore model1
 help reg                                                      //reg输出的值都储存在e类中,scalar和matrix都储存在e类中
 dis e(N)
 dis e(mss)                                                    //mss表示模型能解释的部分,也叫做解释平方和、回归平方和或模型平方和
 "标量用dis或者scalar list,但是scalar只能列出自己定义的不能列出系统自己定义的"
 matrix list e(b)
 matrix list e(V)                                              //系数的方差协方差矩阵的估计
 
 matrix list r(table)                                          //把众多统计量列为矩阵     
 matrix table_trans = r(table)'                                //把r(table)阵转置之后赋table_trans
 "dis table_trans dis不能用于矩阵"
 matrix list table_trans                                       //显示矩阵用matrix list
 
 dis table_trans[1,1]                                          //显示矩阵table_trans阵中第一行一列的元素
 //table_trans[1,1]就直接代表了矩阵table_trans第一行一列的元素
 dis table_trans[1,1]/table_trans[1,2]                         //算出的就是exper的系数的t统计量
 dis e(rmse)                                                   //sigma hat
 
 estimates restore model1
 dis _b[exper]                                                 //_b就是表示系数向量,这里不能用数字索引
 dis _b[_cons]
 dis _se[exper]                                                //_se表示系数标准差向量,这里不能用数字索引
 
 dis table_trans[1,1]/table_trans[1,2] == _b[exper]/_se[exper] 
 
 reg educ wage
 estimates replay model2                                       //这个只能把原来输出的结果拿出来看一看
 matrix list e(b)                                              //这里会展示最近的一个运算里面储存的值,这里也就是reg educ wage的e(b)
 
 
 *5.5 导出数据为表格
 ssc install estout                                            //安装了estout才可以用esttab
 
 esttab model1 model2 using reg1.rtf, replace b(%12.3f) se(%12.3f) nogap compress   ///
 s(N r2 r2_a aic bic) star(* 0.1 ** 0.05 *** 0.01) title("收入") mtitle("m1" "m2") //加replace替换原来的文件
 //这里s代表统计量

 esttab m1 m2 m3 m4 using reg1.rtf, replace b(%12.3f) se(%12.3f) nogap compress noconstant ///
 indicate("年份效应 =*.year" "行业效应 =*.industry" "省份效应 =*.province", label("控制" "不控制")) ///   //indicate会在表格下面形成固定效应的显示
 s(N r2 r2_a aic bic) star(* 0.1 ** 0.05 *** 0.01) title("发明家高管对企业研发投入的影响")

 
 
 *5.6 虚拟变量,因子变量
 *虚拟变量
 drop educ_h
 su educ, detail
 gen educ_h = educ>13
 reg wage educ_h
 
 su wage if educ>13 
 dis _b[_cons]+_b[educ_h]                                      //与r(mean)几乎相当,不一样是因为计算的问题
 
 su educ, detail 
 gen educ_1 = educ>=16
 gen educ_2 = educ<16 & educ>=12
 gen educ_3 = educ<12
 reg wage educ_1 educ_2 educ_3                                 //会省略educ_3因为共线性了,而不是省略常熟项
 reg wage educ_1 educ_2 educ_3, noconstant                     //这个会省略常数项                              

 predict varname, xb                                           //预测拟合值
 predict varname, r                                            //预测残差
 
 *因子变量
 drop class
 gen class = 1 if educ_1
 replace class = 2 if educ_2
 replace class = 3 if educ_3
 list i.class                                                  //因子变量直接生成0和1虚拟变量
 list i.class educ_1 educ_2 educ_3
 
 reg wage i.class
 su wage if educ_1
 dis r(mean)
 dis _b[_cons]
 
 list c.wage wage

 reg wage exper exper^2                                         //会报错reg中不能运算
 reg wage c.exper c.exper#c.exper                               //c. 表示连续变量的运算符而i. 表示离散变量的运算符
 
                                                                
 list c.wage#c.educ in 1/5			                            //只含有两个变量的交乘项												 
 list c.wage##c.wage in 1/5				                        //有wage和wage^2											
 list c.wage##c.wage if _n<=5&_n>=1	
 list c.wage##c.educ                                            //包含他们本身和他们的交叉项














