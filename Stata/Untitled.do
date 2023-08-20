drop female_wage female_educ
local w_h wage educ exper hrswk
foreach v of local w_h{
	gen female_`v' = female*`v'
	}
	
	
scalar x=0	
foreach j of numlist 1/20{
	scalar l = 2^`j'
	scalar x = x+l
	}
 dis x
 
 foreach j of numlist 1/50{
	if female==1 & black==1 in `j'{
	dis "黑人女性"
	}
	else{
	drop if _n==`j'
	}
	}
 
 
 
 
 scalar s=0
 scalar j=0
 while s<7{
	scalar j = j + 1
	scalar r = 2^j
	scalar s = s + r
	}
 scalar list j
 
 scalar x=0
 foreach j of numlist 1/14{
	scalar x=x+`j'
	}
dis x
 
 
foreach j of numlist 1/6{
	if `j'==5{
	continue break
	}
	else{
	foreach i of numlist 1 3 5{
	if `i'==5{
	continue break
	}
	else{
	dis `i' is `i'
	}
	}
	}
	} 
 
foreach j of numlist 1/10{
	dis "`j' is `j'"
	foreach i of numlist 1(2)9{
	if `i'==5{
	continue,break
	}
	else{
	dis "`i' is `i'"
	}
	}
	}
 
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
 
 capture program drop summation 
 program summation, rclass                        
	args a b
	return scalar s = `a'+`b'  
 end 
 capture program drop s
 program s
	args a b
	summation `a' `b'
	dis r(s)
 end

 
 capture program drop summation
 program summation, rclass                        
	args a b
	return scalar s = `a'+`b' 
	dis r(s)
 end 
 
  capture program drop summation
 program summation, rclass                        //把返还的值存在r类中,并名为s
	args a b
	dis "这两个数的和="`a'+`b'
	return scalar s = `a'+`b'                     //返还的值存在标量s中,必须是return scalar
	dis r(s)
 end                                              //只有return scalar才能出存在r类中
 summation 2 3
 
 clear
 set obs 10000
 set seed 120
 gen x = runiform(0,1)
 gen y = runiform(0,1)
 gen inner = y<sqrt(1-x^2) //这个sqrt(1-x^2)是四分之一圆的表达式
 su inner
 dis "圆周率="r(mean)*4
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
