local extract_num 	= 2
local data_levels 	  ind occ
local yr_start		= 2010
local yr_end		= 2010

// directories
	global dir_root "C:\Users\kbp2w\Box Sync\Adam\Occupation & Industry Stats\"
	global dir_raw "${dir_root}\data\raw\Extract `extract_num'"
	global dir_clean "${dir_root}\data\clean\Extract `extract_num'"

// create base dataset
	use "${dir_raw}\usa_0000`extract_num'.dta", clear

	// employment status, if in the labor force 
		recode empstat (0=.) (1=1) (2=0) (3=.), gen(xempstat_iflabforce)
			// 0 = n/a 					-> .
			// 1 = employed				-> 1 = employed
			// 2 = unemployed 			-> 0 = unemployed
			// 3 = not in labor force 	-> .
		label define xempstat_iflabforce 0 "unemployed" 1 "employed"
		label values xempstat_iflabforce empstat_iflabforce
		label var xempstat_iflabforce "Employment status, if in the labor force"
	
	// labor force, for counting purposes
		recode labforce (0=.) (1=.) (2=1), gen(xlabforce)
			// 0 = n/a 							-> .
			// 1 = no, not in the labor force	-> .
			// 2 = yes, in the labor force		-> 1 = yes, in the labor force
		label define xlabforce 1 "yes, in the labor force"
		label values xlabforce xlabforce
		label var xlabforce "=1 if in the labor force; . otherwise"
	
		tempfile base
		save "`base'"

// create single level datasets
	foreach data_level of local data_levels {
		use "`base'", clear
		keep `data_level' xempstat_iflabforce xlabforce
		collapse (mean) xempstat_iflabforce (sum) xlabforce, by(`data_level')
	
		rename xempstat_iflabforce 	perc_employed
		rename xlabforce 			num_labforce

		gen perc_unemployed = 1 - perc_employed
		order perc_unemployed, after(perc_employed)

		label var perc_employed 	"Percentage of workers EMPLOYED in `data_level'"
		label var perc_unemployed	"Percentage of workers UNEMPLOYED in `data_level'"
		label var num_labforce		"Total number of workers in `data_level' in the labor force"
	
		save "${dir_clean}\\`data_level'.dta", replace
		saveold "${dir_clean}\\`data_level'_v12.dta", version(12) replace
	}

// create industry-occupation level dataset
		use "`base'", clear
		keep ind occ xempstat_iflabforce xlabforce
		collapse (mean) xempstat_iflabforce (sum) xlabforce, by(ind occ)
	
		rename xempstat_iflabforce 	perc_employed
		rename xlabforce 			num_labforce

		gen perc_unemployed = 1 - perc_employed
		order perc_unemployed, after(perc_employed)

		label var perc_employed 	"Percentage of workers EMPLOYED in ind occ"
		label var perc_unemployed	"Percentage of workers UNEMPLOYED in ind occ"
		label var num_labforce		"Total number of workers in ind occ in the labor force"
	
		save "${dir_clean}\ind_occ.dta", replace
		saveold "${dir_clean}\ind_occ_v12.dta", version(12) replace

