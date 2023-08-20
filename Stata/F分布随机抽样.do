clear
set obs 100000
set seed 100
gen x = rchi2(10)

set seed 101
gen y = rchi2(25)

gen z = x/y

histogram z, kdensity

********
set seed 3456
gen i = runiform(0,1)

gen rf = invF(10,25,i)

histogram rf,kdensity

//运行出来的图像并不太相同，那我可不可以，随机很多次，取平均再画图呢，但是循环不会写。



