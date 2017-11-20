
*		INCLUDE ALSO SMALL COUNTRIES WITH MAX TWO YEARS MISSING       *
* =================================================================== *
* SAMPLE: all countries that have a maximum of two missing years  	  *
*		  in total decision data                                      *
* YEARS: 2002 - 2014                                                  *
* CABINET POSITION: left, right, split at median                      *
* QUARTERS: 6 quarters around the election                            *
* =================================================================== *

clear
set more off, permanently

use ./out/data/temp/combined_data_for_final_adjustments.dta, clear


* 1, select years, destination and origin countries
  
* Use only 2002-2014
drop if year > 2014

* Use only countries that have a maximum of two missing years
* Determine countries that have data in at least 44 out of 52 quarters**
bysort origin destination: egen non_missing = count(totaldecisions)
bysort destination: egen max_non_missing = max(non_missing) 
tab destination if max_non_missing >= 44
keep if max_non_missing >= 44

	* Match with top 90% origin countries
merge m:1 origin using ./out/data/temp/source_countries_dec_all_max_two_missing.dta
keep if _merge == 3
drop _merge 
		
* 2, Calculate mean dyadic first-time applications per quarter
do ./src/data_management/final_data_preparation/modules/calc_mean_dyadic_decisions.do

* 3, Create two dummies for cabinet position  split at the median
do ./src/data_management/final_data_preparation/modules/cabinet_position_median.do

* 4, Create before after dummies and all interaction terms 
*    for 6 quarters around the election
global q = 6
do ./src/data_management/final_data_preparation/modules/dummies_and_interactions.do

* 5, Generate indicator variables
do ./src/data_management/final_data_preparation/modules/indicator_variables.do


save ./out/data/final_decision/all_max_two_missing_data.dta, replace

