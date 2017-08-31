local extract_num 	= 3
local yr_start		= 2010
local yr_end		= 2015

// create base dataset
	use "${dir_raw}/usa_0000`extract_num'.dta", clear

	//use data for years `yr_start' - `yr_end' (note: data is pooled across years)
	keep if year>=`yr_start' & year<=`yr_end'

	// employment status, if in the labor force 
		recode empstat (0=.) (1=1) (2=0) (3=.), gen(xempstat_iflabforce)
			// 0 = n/a 					-> .
			// 1 = employed				-> 1 = employed
			// 2 = unemployed 			-> 0 = unemployed
			// 3 = not in labor force 	-> .

		// gen var that includes only observations with no flag
			gen xempstat_iflabforce_noflag = xempstat_iflabforce if qempstat==0

		label define xempstat_iflabforce 0 "unemployed" 1 "employed"
		label values xempstat_iflabforce* empstat_iflabforce
		label var xempstat_iflabforce "Employment status, if in the labor force"
		label var xempstat_iflabforce_noflag "Employment status, if in the labor force & no flag"
	
	// labor force, for counting purposes
		recode labforce (0=.) (1=.) (2=1), gen(xlabforce)
			// 0 = n/a 							-> .
			// 1 = no, not in the labor force	-> .
			// 2 = yes, in the labor force		-> 1 = yes, in the labor force

		// gen var that includes only observations with no flag
			gen xlabforce_noflag = xlabforce if qempstat==0

		label define xlabforce 1 "yes, in the labor force"
		label values xlabforce* xlabforce
		label var xlabforce "=1 if in the labor force; . otherwise"
		label var xlabforce_noflag "=1 if in the labor force & no flag; . otherwise"
		
		save "${dir_root}/data/build/base.dta", replace
