
// preamble: resets existing settings 
	clear all
	label  drop _all
	matrix drop _all
	macro  drop _all
	set more off		

// directories
	global dir_root "C:/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats"
	global dir_raw "${dir_root}/data/raw/"
	global dir_clean "${dir_root}/data/clean/"
	global dir_output "${dir_root}/output/"

// switches
	local switch_install 		= 0
	local switch_build_base 	= 0
	local switch_build_occ_ind 	= 1
	local switch_build_occind 	= 1
	local switch_output_rmd		= 0
	
***********************************************

// install special Stata packages
	if `switch_install' {
	}

// generate datasets
	#delimit ;
	foreach step in 
		build_base 
		build_occ_ind
		build_occind  
		{ ;
			if `switch_`step'' { ;
				do "${dir_root}/code/occ_ind/build//`step'" ;
			} ;
		} ;
	#delimit cr 

// generate output
	if `switch_output_rmd' {
		do "${dir_root}/code/occ_ind/output/occ_ind_graphs_markdown.Rmd"
	}

***********************************************
