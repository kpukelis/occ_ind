local extract_num 	= 3
local data_levels 	  ind occ
local yr_start		= 2010
local yr_end		= 2015
local indcodelength = 3
local occcodelength = 3

// directories
	global dir_root "C:\Users\kbp2w\Box Sync\Adam\Occupation & Industry Stats\"
	global dir_raw "${dir_root}\data\raw\Extract `extract_num'"
	global dir_clean "${dir_root}\data\clean\Extract `extract_num'"

// create base dataset
	use "${dir_raw}\usa_0000`extract_num'.dta", clear

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
		
		tempfile base
		save "`base'"

// create single level datasets
	foreach data_level of local data_levels {
		use "`base'", clear
		keep `data_level' xempstat_iflabforce* xlabforce*
		collapse (mean) xempstat_iflabforce* (sum) xlabforce*, by(`data_level')
	
		rename xempstat_iflabforce			perc_employed
		rename xlabforce 					num_labforce
		rename xempstat_iflabforce_noflag	perc_employed_noflag
		rename xlabforce_noflag				num_labforce_noflag

		gen perc_unemployed = 1 - perc_employed
		gen perc_unemployed_noflag = 1 - perc_employed_noflag
		
		label var perc_employed 			"Percentage of workers EMPLOYED in `data_level'"
		label var perc_unemployed			"Percentage of workers UNEMPLOYED in `data_level'"
		label var num_labforce				"Total number of workers in `data_level' in the labor force"
		label var perc_employed_noflag 		"Percentage of workers EMPLOYED & no flag in `data_level'"
		label var perc_unemployed_noflag	"Percentage of workers UNEMPLOYED & no flag in `data_level'"
		label var num_labforce_noflag		"Total number of workers in `data_level' in the labor force & no flag"
		
		order `data_level' perc_employed perc_unemployed num_labforce perc_employed_noflag perc_unemployed_noflag num_labforce_noflag
			
		save "${dir_clean}\\`data_level'.dta", replace
		saveold "${dir_clean}\\`data_level'_v12.dta", version(12) replace
	}

// create industry-occupation level dataset
		use "`base'", clear
		keep ind occ xempstat_iflabforce* xlabforce*
		
		tostring ind occ, replace
		//make strings of uniform length 4
		foreach var in ind occ {
			replace `var' = "000" + `var' if strlen(`var')==1
			replace `var' = "00"  + `var' if strlen(`var')==2
			replace `var' = "0"   + `var' if strlen(`var')==3
		}
		replace ind = substr(ind,1,`indcodelength')
		replace occ = substr(occ,1,`occcodelength')
		*destring ind occ, replace
		
		collapse (mean) xempstat_iflabforce* (sum) xlabforce*, by(ind occ)
	
		rename xempstat_iflabforce			perc_employed
		rename xempstat_iflabforce_noflag	perc_employed_noflag
		rename xlabforce 					num_labforce
		rename xlabforce_noflag				num_labforce_noflag
		
		gen perc_unemployed = 1 - perc_employed
		gen perc_unemployed_noflag = 1 - perc_employed_noflag
		
		label var perc_employed 			"Percentage of workers EMPLOYED in `data_level'"
		label var perc_unemployed			"Percentage of workers UNEMPLOYED in `data_level'"
		label var num_labforce				"Total number of workers in `data_level' in the labor force"
		label var perc_employed_noflag 		"Percentage of workers EMPLOYED & no flag in `data_level'"
		label var perc_unemployed_noflag	"Percentage of workers UNEMPLOYED & no flag in `data_level'"
		label var num_labforce_noflag		"Total number of workers in `data_level' in the labor force & no flag"
	
		order ind occ perc_employed perc_unemployed num_labforce perc_employed_noflag perc_unemployed_noflag num_labforce_noflag
	
		save "${dir_clean}\ind_occ.dta", replace
		saveold "${dir_clean}\ind_occ_v12.dta", version(12) replace

