**********************************lecture 3作图**********************************
*-3.共同选项 
 note("#")                                     //可应用于在图的左下角标出数据来源
 title("#")                                    //给图像添加标题
 sutitle("#")                                  //给图像添加副标题
 xtitle("#")                                   //x轴加标题
 
 xlable(0(5)30)                              //x轴上标数字从0开始以5为间隔到30进行标示
 ylable(0(0.1)1)                             //y轴上的数字从0开始以0.1为间隔到1进行标示
 xlabel(1 2 3 4)                             //在x轴上面标出数字1,2,3,4
 xlabel(# "#")                               //在x轴的#处标出#
 
 xline(# #)                                  
 xline(1 2 3)                                //画出x=1,2,3的图像
 
 text(y x "#")                               //在纵坐标为y横坐标为x的地方写上文本#
 range(x1 x2)                                //在区间为(x1,x2)的范围内画函数图
 
 legend(off)
 plotregion(margins(0))
 
 *保存图片,作为选项跟在后面
 saving(#)                                    //保存在硬盘中切命名为#
 name(#)                                      //保存在内存中切命名为#
 
*-3.储存、删除以及调出图片
 dir                                          //查看当前文件夹里面有什么文件
 graph dir                                    //查看所有保存的图片名称
 graph drop p2                                //只能删除内存里面的图
 
 graph drop p1.pgh                            //drop删不了硬盘里的图
 erase p1.gph                                 //erase可以删除硬盘里面的图
 
 graph use p1.gph                             //调出硬盘里面的图
 graph display p2                             //调出内存里面的图


*-3.1直方图(histogram)
 sysuse sp500, clear
 
 *density,frequency,fraction,percent
 histogram volum                          //默认作密度图像与"hist wage, density"一致
 histogram volum, density
 
 hist volum, frequency                    //高度是出现在一个间隔里面的数的多少个
 histogram volum, fraction addlabels      //做频率图,每一个间隔里面包含的数的数量占总数的比例
 histogram volum, addlabels               //在柱子上面标出density值
 hist volum, percent addlabels            //柱子的高度代表一个间隔里面的数的多少站总数的多少的比
 
 hist volum, kdensity                     //根据数据画一个核心密度图,画出来的核密度图与柱子多少柱子宽度没有关系
 hist volum, normal                       //在画的图中加一个标准正态分布的概率密度图
 
 hist volum, bin(40)                      //bin(#)指定柱子的个数
 hist volum, width(2000)                  //width(#)指定柱子的宽度
 
 "stata里面选项采用逗号","隔开,数字用空格" "隔开表示区间"

 *标注的设定
 hist volum, note("source:national statistics bureau")  ///    //可用于在图像的下方标记出数据来源
             title("kdensity")     ///                         //在图像上方加上标题   
			 subtitle("detailkdensity")  ///                   //加上副标题
			 xtitle("volum") ytitle("frequancy")  ///          //x轴标题设为volum,纵轴标题设为frequency 
			 xlabels(4000(2500)25000)                          //x轴上标记4000到25000以2500为间隔数字
			 
			 ylabels(0(#)8)                                    //y轴上以#为间隔标记数字
			 ylabels(1 2 3 4)                                  //y轴上标记出1,2,3,4
			 
 hist volum, xlabels(6000 "hello")	                           //在x轴6000处标记出hello		 
 hist volum, xline(6000 10000) yline(2.0e-04)                  //可以同时画多条线  
 //stata可以识别科学计数法,这里e代表10这样只是为了怕10和其他数字看混了采用e代替10
 
 hist volu, xline(6000) yline(2.0e-04) text(2.0e-04 6000 "焦点")  //在坐标为(2.0e-04 6000)的地方写文字		 
			 
 hist volum, saving(p1)                                        //把这个图命名为p1并且储存到硬盘中,后缀为.gph
 hist volum, name(p1)                                          //把这个图命名为p1并且储存到内存中没有后缀
 
 su volum
 local mean1 = int(r(mean))
 dis `mean1'
 hist volum, frequency ///
             xaxis(1 2)  ///                          //上下各生成一个x轴,y也可以,必须要先生成两个x轴才能进行两个咒的操作
			 ylabels(0(10)60) ///
			 xlabels(`mean1' "mean", axis(2)) ///       //在上面的x轴的12321处标记mean)	
			 xline(`mean1') text(60 `mean1' "mean") ///
			 xtitle("镜像", axis(2)) ///                 //在上面的x轴上放标题
			 xtitle("实体", axis(1)) ///
			 xlabels(4000(2500)25000, axis(2))          //不标注axis(2)就默认对axis1操作
			 
"axis(1 2)这个选项只有histogram才可以使用"
			 
*-3.2散点图(twoway scatter)
 import excel "/Users/mac/Desktop/stata/cps4_small.xlsx", sheet("Data") firstrow clear
 twoway (scatter y x)                                       //纵轴在前横轴在后
 twoway (scatter wage educ, msize(small))                   //msize(#)控制画出来的点的大小
 //点的尺寸有vtiny,tiny,vsmall,small.stata默认是small
 twoway (scatter wage educ, msize(vtiny) color(black)) ///  //color(#)调节点的色彩
        (lfit wage educ, lcolor(black))                     //lcolor(#)调节线的色彩
		
 twoway scatter wage educ, msize(vtiny) color(black) ///
     || lfit wage educ, lcolor(black)		                //lfit加一条拟合线 
	   
 twoway (scatter wage educ, msize(vtiny) color(black)) ///  //color(#)调节点的色彩
     || (lfit wage educ, lcolor(black)) 
"这里括号可加也可以不加"	


 
*-3.3函数图(twoway function)
 twoway function y = exp(x), range(-10 10) lcolor(black)     //在-10到10的范围画出exp(x)的图像
 twoway function y = exp(x), range(-10 10) recast(area) color(orange)        //把画出的在y一下的区域填满,不写颜色默认蓝色
 
 local right_bound = invnormal(0.975)
 local left_bound = -invnormal(0.975)
 twoway function pdf = normalden(x,2,5), lcolor(black) range(-100 100) ///
     || function pdf = normalden(x,2,5), lcolor(black) range(`right_bound' 100) recast(area) color(black)  ///
     || function pdf = normalden(x,2,5), lcolor(black) range(-100 `left_bound') recast(area) color(black)
	 
 twoway (function PDF=normalden(x), lcolor(red))  
 
 "twoway (function PDF=normalden(x), lcolor(red) xline(exp(-4)))//会报错,可以用macro解决,这里面不能用计算，只能用数"
 local up = exp(-2)/sqrt(2* _pi)
 twoway function pdf = normalden(x,0,1), lcolor(black) range(2 8) yline(`up')

 
*-3.4 conncetd:连点
 twoway connected high volum ///
    ||  lfit high volum  
 
 
 
 
*-3.5把几张图放在一块
 graph combine p1 p2 p1.gph
 graph combine p1 p2 p1.gph, r(4) //r代表row排成四行
 graph combine p1 p2 p1.gph, c(4) //c代表colum排成四列
 
 














