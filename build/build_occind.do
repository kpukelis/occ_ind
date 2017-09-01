local indcode_min = 1
local indcode_max = 4
local occcode_min = 1
local occcode_max = 4

forvalues indcode_length = `indcode_min'/`indcode_max' {
	forvalues occcode_length = `occcode_min'/`occcode_max' {
		// create industry-occupation level dataset
			use "${dir_root}/data/build/base.dta", clear
			keep ind occ xempstat_iflabforce* xlabforce*
			
			tostring ind occ, replace
			//make strings of uniform length 4
			foreach var in ind occ {
				replace `var' = "000" + `var' if strlen(`var')==1
				replace `var' = "00"  + `var' if strlen(`var')==2
				replace `var' = "0"   + `var' if strlen(`var')==3
			}
			replace ind = substr(ind,1,`indcode_length')
			replace occ = substr(occ,1,`occcode_length')
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
		
			save "${dir_clean}/ind`indcode_length'_occ`occcode_length'.dta", replace
			saveold "${dir_clean}/ind`indcode_length'_occ`occcode_length'_v12.dta", version(12) replace
	}
}

