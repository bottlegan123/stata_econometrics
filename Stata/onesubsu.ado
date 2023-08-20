
capture program drop onesubsu
program onesubsu
 args v
 sort `v'
 local l_1 = _N-1
 su `v' in 2/`l_1'
 dis r(mean)
 end
