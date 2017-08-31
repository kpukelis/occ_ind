local data_levels 	  ind occ

// create single level datasets
	foreach data_level of local data_levels {
		use "${dir_root}/data/build/base.dta", clear
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
			
		save "${dir_clean}//`data_level'.dta", replace
		saveold "${dir_clean}//`data_level'_v12.dta", version(12) replace
	}
