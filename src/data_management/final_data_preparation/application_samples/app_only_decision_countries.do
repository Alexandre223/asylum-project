
*	             USE ONLY COUNTRIES THAT ARE BOTH IN                  *
*             BASELINE APPLICATION AND DECISION ANALYSIS              *
* =================================================================== *
* SAMPLE: all big countries that have a maximum of two missing years  *
*		  in first-time application data                              *
*		  exclude Cyprus because of several irregular cabinet changes *
*         exclude Norway, Beglium, Netherlands because countries are  * 
*         not in decision analysis 
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

* Use only big countries that have a maximum of two missing years
* Determine countries that have data in at least 44 out of 52 quarters**
bysort origin destination: egen non_missing = count(firsttimeapp_NI)
bysort destination: egen max_non_missing = max(non_missing) 
tab destination if max_non_missing >= 44
keep if max_non_missing >= 44

* Determine big destination countries
bysort destination: egen total_FTapp = total(firsttimeapp)
tab destination total_FTapp
drop if total_FTapp < 30000

* exclude Cyprus because of irregular cabinet changes
drop if destination == "Cyprus"| destination=="Belgium" | ///
		destination=="Netherlands" | destination=="Norway"

tab destination
	
* Use 49 most important source countries for these countries 
*(together more than 90% of first time applications during the period)
drop if origin=="Sierra Leone" | origin=="Uganda" | ///
		origin=="Burundi" |  origin=="Rwanda"|  ///
		origin=="Slovakia" |	origin=="Togo" | ///
		origin=="Uzbekistan"
		
* 2, Calculate mean dyadic first-time applications per quarter
do ./src/data_management/final_data_preparation/modules/calc_mean_dyadic_ft_applications.do

* 3, Create two dummies for cabinet position  split at the median
do ./src/data_management/final_data_preparation/modules/cabinet_position_median.do

* 4, Create before after dummies and all interaction terms 
*    for 6 quarters around the election
global q = 6
do ./src/data_management/final_data_preparation/modules/dummies_and_interactions.do

* 5, Generate indicator variables
do ./src/data_management/final_data_preparation/modules/indicator_variables.do


save ./out/data/final_application/only_decision_countries.dta, replace

