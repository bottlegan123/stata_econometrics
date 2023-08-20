*---------lec9 hetero--
use price2023.5.dta,clear
reg price-bdrms

//1.检验异方差
（1）graph
（2）BP检验
estat hettest   //het--hetero
estat hettest,iid  //非正态

estat hettest lotsize-bdrms
estat hettest lotsize-bdrms,mtest

（3）White检验
estat imtest,white
estat hettest (c.lotsize-bdrms)##(c.lotsize-bdrms),iid

//2.消除异方差
（1）对数法
foreach v of varlist price-sqrft{
		gen l`v' =log(`v')
}
//不取log的情况：有负数，利率/收益率/通胀率，有限的整数值
reg lprice-lsqrft bdrms
estat imtest,white

(2)vce(robust)异方差稳健标准误
reg price-bdrms

reg price-bdrms,vce(robust)
reg price-bdrms,r  //robust

(3)FGLS——feasible generalized least square
//WLS
reg price-bdrms
predict e,r
gen e2 = e^2
reg e2 (c.lotsize-bdrms)##(c.lotsize-bdrms)

reg price-bdrms [aw=1/lotsize] 
estat imtest,white

foreach v of varlist price-bdrms{
	gen w_`v' = `v'/sqrt(lotsize)
}
gen  w_c = 1/sqrt(lotsize)

reg w_*,noc
estat imtest,white

reg w_*,noc r



















