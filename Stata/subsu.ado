program subsu
	foreach v of varlist _all{
	sort `v'
	qui:replace `v'=. if _n==_N | _n==1
}
su
end
