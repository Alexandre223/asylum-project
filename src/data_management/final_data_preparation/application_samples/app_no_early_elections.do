
*			   No early elections sample                              *
* =================================================================== *
* SAMPLE: France, Ireland, Norway, Sweden and UK (no early elections) *
* YEARS: 2002 - 2014                                                  *
* CABINET POSITION: left, right, split at median                      *
* QUARTERS: 6 quarters around the election                            *
* =================================================================== *

clear
set more off, permanently

use ./out/data/temp/combined_data_for_final_adjustments.dta, clear


* 1,  destination and origin countries

*select countries with no early elections
keep if destination == "France" | destination == "Ireland" | ///
		destination == "Norway" | destination == "Sweden" | ///
		destination == "United Kingdom"

tab destination
	
* Match with top 90% origin countries
merge m:1 origin using ./out/data/temp/source_countries_app_no_early_elections.dta
keep if _merge == 3
drop _merge

		
* 2, Calculate mean dyadic first-time applications per quarter
do ./src/data_management/final_data_preparation/modules/calc_mean_dyadic_ft_applications.do

* 3, Create two dummies for cabinet position split at the median
do ./src/data_management/final_data_preparation/modules/cabinet_position_median.do

* 4, Create before after dummies and all interaction terms 
*    for 6 quarters around the election
global q = 6
do ./src/data_management/final_data_preparation/modules/dummies_and_interactions.do

* 5, Generate indicator variables
do ./src/data_management/final_data_preparation/modules/indicator_variables.do

* 6, Calculate number of elections and cabinet positions
do ./src/data_management/final_data_preparation/modules/number_elections_and_cabinet_changes.do


save ./out/data/final_application/no_early_elections.dta, replace

