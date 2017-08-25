use "C:\Users\kbp2w\Box Sync\Adam\Occupation & Industry Stats\data\ACS Downloads\Extract 2\usa_00002.dta\usa_00002.dta", clear

//employment status, if in the labor force 
	recode empstat (0=.) (1=1) (2=0) (3=.), gen(empstat_iflabforce)
		// 0 = n/a 					-> .
		// 1 = employed				-> 1 = employed
		// 2 = unemployed 			-> 0 = unemployed
		// 3 = not in labor force 	-> .
	label define empstat_iflabforce 0 "unemployed" 1 "employed"
	label values empstat_iflabforce empstat_iflabforce
	label var empstat_iflabforce "Employment status, if in the labor force"

	tempfile temp
	save "`temp'"

//create industry level dataset
	use "`temp'", clear
	keep ind empstat_iflabforce
	collapse (mean) empstat_iflabforce, by(ind)

	tempfile ind
	save "`ind'"





