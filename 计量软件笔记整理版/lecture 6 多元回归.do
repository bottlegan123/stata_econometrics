*******************************lecture 9 多元回归*********************************

 use "/Users/mac/Desktop/stata/nerlove.dta"
 *-9.1 约束检验
  *9.1.1 线性约束检验
 reg tc q-pk
 test _b[q]+_b[pl]+_b[pf]=1                              //test跟在回归后做的是wald检验
 
 reg tc q-pk
 test q+pl+pf=0                                          //这里必须加上=多少
 
 reg tc q-pk
 test (_b[q]+_b[pl]=1) (_b[pl]+_b[pf]+_b[pk]=1)          //可以施加多个约束
 
 reg tc q-pk
 lincom _b[q]+_b[pl]+_b[pf]-1                            //与上面的约束检验等价,检验是否为0

 *9.1.2 非线性约束检验
 reg tc q-pk
 testnl _b[pk]*_b[pf]=1  
 
 reg tc q-pk
 testnl _b[pk]=_b[pf]^2
 
 reg tc q-pk
 nlcom _b[pk]-(1/_b[pf])-0                               //非线性约束和线性约束命令不同
 reg tc q-pk
 nlcom _b[pk]*_b[pf]-1     
 
 reg tc q-pk
 nlcom _b[pk]-_b[pf]^2-0 


 
 *-9.2 带约束回归
 constrain 1 _b[pl]+_b[pf]=1                             //先定义约束
 constrain 2 _b[pl]*_b[pk]=1
 cnreg tc q-pk, c(1 2)                                   //可以同时施加多个约束       
 
 *-9.3 LPM--线性概率模型:用回归做有缺陷
 use "/Users/mac/Desktop/stata/mroz.dta"                 //导致妇女就业的原因
 
 reg inlf educ age c.exper##c.exper                      //引入平方项可以引入边际贡献递减的规律.倒U型关系最好二次项系数为负数
 //对于inlf只有两个选择,那么变量的系数怎么解释呢？系数变化一单位妇女就业的概率如何变化
 
 predict inlf_hat, xb
 gen f_inlf = inlf_hat > 0.5                             //这里的0.5是自己取的看情况而定,表示如果预测的inlf大于0.5就看做就业了
 gen equal = f_inlf==inlf                                //看预测出来的就业的和真实就业的是不是大部分相合
 su equal
 dis r(mean)                                             //相合的占总的比例,比例越大就表示自己选的0.5挺好
 
 
 *-9.4 partialing out--控制变量的作用
 use "/Users/mac/Desktop/stata/nerlove.dta", clear
 
 reg tc q-pk
 *方法1
 global control pl-pk
 reg q $control                                          //核心解释变量对控制变量做回归
 predict e, r                                            //把核心解释变量中能用控制变量解释的部分去除掉
 reg tc e                                                //去除掉控制变量能解释的部分后的核心解释变量能解释的部分
 
 *方法2
 //吧模型中所有控制变量能解释的部分全部剔除出去
 reg q $control
 predict e_q, r
 reg tc $control
 predict e_tc, r
 reg e_tc e_q
 

 *-9.5 模型检验
 *-9.5.1 异方差检验
 * 9.5.1.1 画图检验:检验效果不太好肉眼难以辨别是否异方差
 drop e
 reg q-pk
 predict e, r
 gen e_2=e^2
 twoway scatter e_2 pk
 twoway scatter e_2 q
 
 * 9.5.1.2 BP检验
 //estat hettest 默认正态分布 estimates statistics
 //estat hettest, iid 可以非正太但是需要大样本 
 reg tc q-pk                                            //原假设是同方差
 estat hettest q-pk                                     //相当于reg e^2 q-pk
 estat hettest q-pk, mtest                              //结果和上面相同
 
 estat hettest q-pk, iid
 
 
 * 9.5.1.2 white检验
 reg tc q-pk 
 estat imtest, white                                    //信息矩阵white检验
 estat hettest (c.q-pk)##(c.q-pk)                       //手动white检验,相当于reg e^2 (c.q-pk)##(c.q-pk)
 drop e
 predict e, r
 gen e_2=e9^2
 reg e_2 (c.q-pk)##(c.q-pk)

 
 
 *-9.5.2 消除异方差
 * 9.5.2.1 取对数  有时候变量不能取对数:(1)可能会有负数的变量 (2)有限的正整数
 foreach v of varlist _all{
	gen ln_`v' = log(`v')
	}
 reg price lotsize-bdrms
 estat imtest, white
 
 reg ln_price ln_lotsize-ln_bdrms
 estat imtest, white                                     //取对数之后异方差没了
 
 
 
 * 9.5.2.2 FGLS——feasible generalized least square
 reg price-bdrms
 predict e, r
 gen e_2 = e^2
 reg e_2 (c.lotsize-bdrms)##(c.lotsize-bdrms) 
 
 * 加权最小二乘的命令写法
 reg price-bdrms [aw=1/lotsize]                     //加权最小二乘用命令写
 estat imtest, white                                //stata不支持加权最小二乘的white检验,那就用BP手动
 estat hettest lotsize-bdrms
 
 * 加权最小二乘具体步骤写法
 foreach v of varlist _all{                         //手动写加权最小二乘
	gen w_`v' = `v'/sqrt(lotsize)
	}
 gen w_1 = 1/sqrt(lotsize)
 reg w_*, nocons                                    //*星号是通配符
 estat imtest, white                                //再检验一下异方差
 
  reg price-bdrms, nocons r                                  //若稳健标准误和加权过后的估计差距不大那么就说明加权后处理异方差效果很好
  
  
 * 9.5.2.3 用稳健标准误 vce(robust)来避开异方差带来的t检验不准确,样本量大的时候比较好
 reg ln_price-ln_sqrft bdrms, vce(robust)           //与简单的reg相比就是标准误变了,估计的系数不变
 reg ln_price-ln_sqrft bdrms, r                     //r是robust的简写
 
 
 *-9.5.2 序列相关检验
 use "/Users/mac/Desktop/stata/消费data.dta", clear
 tsset year                                         //time series set 告诉stata这是时间序列数据, year就是你的时间
 
 * 时间序列特有的回归
 twoway (connect cons-r year)                       //最后一个放时间
 tsline lcons lw linc r, lpattern(dot solid dash)   //自动识别时间序列
 
 *-9.5.2.1 图示法
 reg lcons-linc r
 predict e, r
 twoway scatter e L1.e ///                          //用L1.e时必须是时间序列数据,先让stata知道是时间序列
    ||  lfit e L1.e
 
 *-9.5.2.2 DW检验:只能检验一阶自相关,但是比起BG检验更加准确
 //宏观时间序列很多时候是一阶自相关的
 reg lcons lw linc r
 estat dwatson
 
 
 *-9.5.2.3 BG/LM检验
 reg lcons lw linc r
 estat bgodfrey                      //一阶BG检验
 estat bgodfrey, lags(2)             //二阶BG检验,bgodfrey检验中用到两个滞后项
 estat bgodfrey, lags(1/10)          //1到10阶的BG检验
 
 reg e L1.e lw linc r                //一阶BG检验的辅助回归,这个L1.e系数显著
 reg e L2.e  lw linc r               //二阶BG检验的辅助回归,这个L2.e系数不显著,这个时候可以初步判断为一阶自相关
 //初步判断是一阶自相关后再用DW检验如果DW检验也是一阶那么就更加确认是一阶
 
 reg e L(1/2).e lw linc r            //一起检验,相当于reg e L1.e lw linc r和reg e L2.e  lw linc r一起
 

 *-9.5.3 序列相关的消除
 * 9.5.3.1 F-GLS
 * (1) CO迭代法:科克伦奥科特迭代
 prais lcons lw linc r               //prais-winsten提出的
 prais lcons lw linc r, corc         // prais后面跟上回归里面的被解释变量和解释变量
 
 * (2)Durbin两步法
 "先找出是几阶的序列相关"
 
 
 
 * 9.5.3.2 异方差-序列相关稳健标准误(HAC):hete-ar-consistent 规避序列相关和异方差的后果使得t检验仍然准确
 //有异方差或者序列相关就规避如果没有就和普通回归没啥区别
 newey lcons lw linc r, lag(3)  //括号里面是你自己认为的可能最高阶数,这里的lag不加s,因为这里是你认为的最大值只是一个值
 //lags(#)中#建议选择为N^0.25或者0.75*N^(1/3)
 dis _N^0.25
 dis 0.75*_N^(1/3)
 newey lcons lw linc r, lag(3) 
 
 "当用好几种方法估计时一个办法系数显著而另一个系数不显著,那么看系数是不是很接近于0"





















