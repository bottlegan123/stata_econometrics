sysuse auto.dta, clear
graph set window fontface "Time New Roman"
graph set window fontfacesans "宋体"
twoway (kdensity rep78, lcolor(black)         ///
			xtitle("{stSans:价格}") ///
			ytitle("{stSans:核密度}") ///
			scheme(s1color) ///   //去掉背景色
			plotregion(lcolor(white))  /// 
			lcolor(black) lpattern(dash) /// 
			legend(off) ///
			ylabel(,nogrid) ///  //去掉背景中的刻度线
			ylabel(,labsize(medlarge)) xlabe(,labsize(medlarge)) /// //刻度大小
			saving(p11, replace))
graph export "p11.png", replace

twoway kdensity price

twoway(kdensity price,                                                                   /// 
             xline(889.6715 , lpattern(solid) lcolor(black))       ///                          
             scheme(qleanmono)        ///                                                       
             xtitle("{stSans:系数}"                        , size(medlarge))   ///              
             ytitle("{stSans:核}""{stSans:密}""{stSans:度}", size(medlarge) orientation(h)) /// 
             saving(placebo_test_Coefficient1, replace)),  ///                                  
         xlabel(, labsize(medlarge))   ///                                                      
         ylabel(, labsize(medlarge) format(%05.4f))  // 绘制1,000次回归rep78的系数的核密度图

  graph export "placebo_test_Coefficient1.png", replace 
			
