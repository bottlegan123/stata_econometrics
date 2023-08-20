******************************lecture 2 分布函数*********************************
"四大分布中只有正态没有尾部分布函数"
"正态分布参数在后,其他三大分布参数在前"

*-1.正态分布 

 *分布函数值  F~(EX,sigma)
 "dis normal(0,0,1)                      //会报错,通过{(x-EX)/sigma}转换为标准正态分布求 "                            
 display normal(0)                       //F(X<=0)的值,F=N求分布值
 scalar phi = normal(0)                  //把算出的normal(0)的值存在scalar中
 dis phi
 
 dis "p(z<=-2)=" phi                     //这个显示字符串p(z<=-2)=加上先前存在phi中的数
 dis "p(z<=-2)=phi"                      //这个显示直接是字符串的p(z<=-2)=phi
 
 *概率密度值 f(x,Ex,sigma)                 //这里是标准差
 normalden(x)                            //表示标准正态分布密度函数
 dis normalden(x,Ex,sigma)
 dis normalden(0)                        //不告诉期望方差时默认是标准正态
 dis normalden(1,0,9)                    //normalden()没办法转化为标准正态求,所以这里可以表明期望方和差 
 
 dis normalden(x,sigma)                  //默认均值为零
 dis normalden(0,1) 
 
 dis 1/sqrt(2*_pi)                       //_pi表示兀
 
 *分位数                                  //也只能对标准正态使用因为非标准正态可以转化为标准正态进行计算
 dis invnormal(0.975)                    //使得F(X<=x)=0.975满足的x的值
 dis invnormal(0.975)*5+2                //使得F(X<=x)=0.975满足的x的值,此时F服从于均值为2标准差为5的正态分布
                                         //F((X-2)/5)<=(x-2)/5)=0.975,(X-2)/5服从于标准正态
										 
 *模拟:随机取数,但是这一随机并不是真正的随机它只是用电脑程序模拟出来的为随机数
 "由于这里没办法进行进行分布的转换再取随机,所以必须要知道具体正态分布的均值和标准差"
 dis rnormal(2,5)                        //在服从均值为2标准差为5的正态分布的总体中随机取一个值
 
 clear
 set obs 1000
 set seed 100                            //由于取的是随机数所以每次抽取可能抽取出不同的数,设置种子数就能让下一次抽取和上次抽取到同样的数值
 gen x = rnormal()
 histogram x                             //画出直方图,直方图的高度代表在这一区域中的样本书占总体数的比例
 histogram x, kdensity                   //选项kdensity是在图中加上和密度图
 
 set obs 1000
 set obs 20                              //对于已经设置好的观测值个数,在设置时只能增加不能减少,stata也不知道要减少哪些
 set obs 2000
 
 
*-2.卡方分布 F~chi2(r,x)
 *分布函数
 dis chi2(1,8)                           //服从于自由度为1的卡方分布在x=8处的分布函数值,F~chi2(1),F(8)=P(X<=8)
 dis chi2tail(1,8)                       //服从于自由度为1的卡方分布F~chi2(1),P(X>8)的值
 dis chi2(1,8)+chi2tail(1,8)             //是等于1的
 
 *概率密度函数
 dis chi2den(2,9)                        //服从于自由度为2的卡方分布在x=9处的概率密度值
 twoway function p=chi2(x,7)             //这里面必须用x
 "twoway function p=chi2(x,7)             //会报错"

 *分位数
 dis invchi2(1,0.9953)                   //使得F(x)=0.9953的x值,F~chi2(1)
 dis invchi2tail(1,0.0047)               //使得P(X>x)=0.0047的x值
 dis invchi2(1,0.9953)==invchi2tail(1,0.0047)
 
 *模拟
 dis rchi2(1)
 clear
 set obs 100
 set seed 11110
 gen j = rchi2(1)
 
 set seed 101
 replace j = rt(2) in 1/6
 
 replace j = rt(2) if _n<=6
 
 
*-3.t分布 t(r, )
 *分布函数值
 dis t(2,0)                             //F~t(2)服从于自由度为2的t分布,F(0)=P(X<=0),t分布是关于y轴对称的所以F(0)=0.5
 dis ttail(2,0)                         //尾部分布
 
 *概率密度函数
 dis tden(1,0)                          //F~t(1)服从于自由度为1的t分布,f(0)概率密度函数在0处的取值
 
 *分位数
 dis invt(2,0.5)                        //使得F(x)=0.5的x值,其中F~t(1)
 dis invttail(2,0.5)                    //尾部概率为0.5对应的x的值
 dis invt(2,0.8)==invttail(2,0.2)
 
 *模拟
 dis rt(3)
 
 set seed 102
 gen i = rt(4)

 
*-4.F分布 F(r1,r2,x)
 *分布函数
 dis F(1,2,9)                               //P(X<=9)
 dis Ftail(1,2,9)                           //P(X>9)
 dis F(1,2,9) + Ftail(1,2,9)==1 
 
 *概率密度函数
 dis Fden(1,2,9)                             //服从第一自由度为1第二自由度为2的F分布的f(9)的值
 
 *分位数
 dis invF(1,2,0.9045)
 dis -0.1<invF(1,2,0.9045)-9 & invF(1,2,0.9045)-9<0.1 
 dis invFtail(1,2,0.0955)                    //使得F(X>x)=0.0955的x值
 dis invF(1,2,0.9045)==invFtail(1,2,0.0955)
 
 *模拟
 dis rF(1,2)                                 //会报错,为什么F分布不能直接取随机呢?
 
 F分布取随机数
 clear
 set obs 1000
 set seed 103
 gen z = runiform(0,1)
 gen rf = invF(1,2,z)
 histogram rf if rf<5, kdensity              //限制在一定范围内
 
 histogram rf, kdensity                      //这会画出看不出F分布的图,因为rf范围太大


 "自由度写在前面x写在后面;正太分布x写在前面参数写在后面"
 
"造一个线性回归y=beta0+beta1*x1+mu"
clear
set obs 3000
set seed 104
gen x = rnormal(4,6)
gen y = 2 + 48*x + rnormal()
reg y x

reg y x in 1/100
reg y x if _n<=100                            //这两行同样效果
 
*-5.产生判断变量
 *方法1
 gen inner = 1 if pointx^2+pointy^2 < 1
 replace inner = 0 if pointx^2+pointy^2 > 1
 
 *方法2
 gen inner = cond(pointx^2+pointy^2 < 1,1,0)
 
 *方法3
 gen inner = pointx^2+pointy^2 < 1           //直接输出判断，true为1，false为0
 
 
 

 
 
 
 
 
 
 
 
 
 
 
 
