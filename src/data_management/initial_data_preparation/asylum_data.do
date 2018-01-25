**************************************************
**************************************************
*** PREPARE AND MERGE ASYLUM AND DECISION DATA ***
**************************************************
**************************************************


clear
set more off, permanently

***********************************************
** Convert asylum data from csv to dta files **
***********************************************

* =========================== *
* Application data up to 2007 *
* =========================== *

* First time asylum applications monthly 2000 - 2007
	import delimited ./src/original_data/asylum_data/first-time-applications-00-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value firsttimeapp
	save ./out/data/temp/first-time-applications-00-07-m.dta, replace

* First time asylum applications total monthly 2000 - 2007
	import delimited ./src/original_data/asylum_data/first-time-applications-total-00-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value firsttimeapp_total
	drop origin
	save ./out/data/temp/first-time-applications-total-00-07-m.dta, replace	
	
* First time asylum applications monthly 2002 - 2007
	import delimited ./src/original_data/asylum_data/first-time-applications-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value firsttimeapp
	save ./out/data/temp/first-time-applications-02-07-m.dta, replace

* Total asylum applications yearly 1995 - 2007 by origin country
	import delimited ./src/original_data/asylum_data/applications-95-07-y.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value applications
	save ./out/data/temp/applications-95-07-y.dta, replace
	
* Total asylum applications yearly 1995 - 2007 - total per destination country
	import delimited ./src/original_data/asylum_data/applications-total-95-07-y.csv, varnames(1) clear
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value applications_total
	drop origin
	save ./out/data/temp/applications-total-95-07-y.dta, replace
	
	
* ============================ *
* Application data 2008 - 2016 *
* ============================ *

* First-time asylum applications monthly 2008 - 2016
	import delimited ./src/original_data/asylum_data/first-time-applications-08-16-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value firsttimeapp
	save ./out/data/temp/first-time-applications-08-16-m.dta, replace

* First time asylum applications total monthly 2008 - 2016
	import delimited ./src/original_data/asylum_data/first-time-applications-total-08-16-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value firsttimeapp_total
	drop origin
	save ./out/data/temp/first-time-applications-total-08-16-m.dta, replace	

* First-time asylum applications yearly 2008 - 2016
	import delimited ./src/original_data/asylum_data/first-time-applications-08-16-y.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value firsttimeapp
	save ./out/data/temp/first-time-applications-08-16-y.dta, replace

* First-time asylum applications yearly 2008 - 2016 total per destination country
	import delimited ./src/original_data/asylum_data/first-time-applications-total-08-16-y.csv, varnames(1) clear
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value firsttimeapp_total
	drop origin
	save ./out/data/temp/first-time-applications-total-08-16-y.dta, replace

* Total asylum applications monthly 2008 - 2016 by origin country
	import delimited ./src/original_data/asylum_data/applications-08-16-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value applications
	save ./out/data/temp/applications-08-16-m.dta, replace

* Total asylum applications monthly 2008 - 2016 total per destination country
	import delimited ./src/original_data/asylum_data/applications-total-08-16-m.csv, varnames(1)  clear
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value applications_total
	drop origin
	save ./out/data/temp/applications-total-08-16-m.dta, replace	
	
* Total asylum applications yearly 2008 - 2016 by origin country
	import delimited ./src/original_data/asylum_data/applications-08-16-y.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value applications
	save ./out/data/temp/applications-08-16-y.dta, replace	

* Total asylum applications yearly 2008 - 2016 total per destination country
	import delimited ./src/original_data/asylum_data/applications-total-08-16-y.csv, varnames(1) clear
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_yearly.do
	rename value applications_total
	drop origin
	save ./out/data/temp/applications-total-08-16-y.dta, replace
	
	
* ========================= *	
* Decision data 2002 - 2007 *
* ========================= *

* Total decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/total-decisions-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value totaldecisions
	save ./out/data/temp/total-decisions-02-07-m.dta, replace

* Total positive decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/total-positive-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value totalpositive
	save ./out/data/temp/total-positive-02-07-m.dta, replace
	
* Total positive decisions monthly 2002 - 2007 on destination level
	import delimited ./src/original_data/asylum_data/all-positive-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value allpositive
	drop origin
	save ./out/data/temp/all-positive-02-07-m.dta, replace

* Refugee status decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/refugee-status-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value refugeestatus
	save ./out/data/temp/refugee-status-02-07-m.dta, replace

* Rejected decisions monthly 2002 - 2007 daydic
	import delimited ./src/original_data/asylum_data/rejected-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value rejected
	save ./out/data/temp/rejected-02-07-m.dta, replace

* Rejected decisions monthly 2002 - 2007 on destination level
	import delimited ./src/original_data/asylum_data/all-rejected-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value allrejected
	drop origin
	save ./out/data/temp/all-rejected-02-07-m.dta, replace

* Other positive decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/other-positive-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value otherpositive
	save ./out/data/temp/other-positive-02-07-m.dta, replace

* Other non-status decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/other-non-status-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value othernonstatus
	save ./out/data/temp/other-non-status-02-07-m.dta, replace
	
* Humanitarian status decisions monthly 2002 - 2007 dyadic
	import delimited ./src/original_data/asylum_data/humanitarian-status-02-07-m.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_monthly.do
	rename value humanitarian
	save ./out/data/temp/humanitarian-status-02-07-m.dta, replace

	
* ========================= *	
* Decision data 2008 - 2016 *	
* ========================= *	
	
* Total decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/total-decisions-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value totaldecisions
	save ./out/data/temp/total-decisions-08-16-q.dta, replace	
		
* Total positive decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/total-positive-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value totalpositive
	save ./out/data/temp/total-positive-08-16-q.dta, replace		

* Total positive decisions quarterly 2008 - 2016 on destination level
	import delimited ./src/original_data/asylum_data/all-positive-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value allpositive
	drop origin
	save ./out/data/temp/all-positive-08-16-q.dta, replace	
	
* Refugee status decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/refugee-status-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value refugeestatus
	save ./out/data/temp/refugee-status-08-16-q.dta, replace		

* Rejected decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/rejected-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value rejected
	save ./out/data/temp/rejected-08-16-q.dta, replace	

* Rejected decisions quarterly 2008 - 2016 on destination level
	import delimited ./src/original_data/asylum_data/all-rejected-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value allrejected
	drop origin
	save ./out/data/temp/all-rejected-08-16-q.dta, replace	

* Humanitarian status decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/humanitarian-status-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value humanitarian
	save ./out/data/temp/humanitarian-status-08-16-q.dta, replace	
	
* Temporary protection decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/temporary-protection-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value temporary
	save ./out/data/temp/temporary-protection-08-16-q.dta, replace		
	
* Subsidiary protection decisions quarterly 2008 - 2016 dyadic
	import delimited ./src/original_data/asylum_data/subsidiary-protection-08-16-q.csv, varnames(1) clear 
	do ./src/data_management/initial_data_preparation/function_convert_asylum_data_quarterly.do
	rename value subsidiary
	save ./out/data/temp/subsidiary-protection-08-16-q.dta, replace	
	
	

****************************************************************
** Merge monthly asylum data and collapse it to quarterly data *
****************************************************************

* 1. Combine all data
use ./out/data/temp/applications-08-16-m.dta, clear

merge 1:1 origin destination year month using ///
	./out/data/temp/first-time-applications-08-16-m.dta, nogen

append using ./out/data/temp/first-time-applications-02-07-m.dta

* rename certain countries to match with list of source and destination countries later on   
replace origin = "Former Serbia Montenegro" if origin == "Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin = "Kosovo" if origin == "Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin = "Macedonia" if origin == "Former Yugoslav Republic of Macedonia, the"
replace origin = "China" if origin == "China (including Hong Kong)"
replace origin = "Gambia" if origin == "Gambia, The"

replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"


* 2. Collapse the data

  * a, Make sure that if one months is missing in first time applications 
  *    /applications the entire quarter is coded as missing 

	foreach var of varlist firsttimeapp applications {
		* identify non-missing quarters
		sort origin destination year quarter month
		by origin destination year quarter: egen non_missing_`var' = count(`var')
		
		* create a variable that contains only non-missing quarters
		gen `var'_nmq = .
		replace `var'_nmq = `var' if non_missing_`var' == 3
		
		* calculate total within one quarter, use mean *3 
		* in order to avoid having zeros in those quarters with missing data
		by origin destination year quarter: egen `var'_q = mean(`var'_nmq)
		replace `var' = `var'_q*3
}
*
   * b, collapse to quarterly data
	collapse (mean) firsttimeapp applications, by (destination origin year quarter)

* 3, Impute missing data on first-time applications after 2007 
*	 		from application data from these years 

* Calculate share of first-time applications in total applications
* use only values until 2014 because during the refugee crisis values might be different
gen share_ftapp = firsttimeapp/ applications
replace share_ftapp = . if year > 2015

* Note 104 cases where first- time applications > applications 
* Must be mistakes in the data because applications should include first-time applications
* replace share with 1 if it is larger than 1
replace share_ftapp = 1 if share_ftapp > 1 & share_ftapp != .

sort destination origin year quarter
by destination origin: egen share_average = mean(share_ftapp)

* calcuate first-time applications from applications 
* when firsttime applications are not available
gen firsttimeapp_NI = firsttimeapp
replace firsttimeapp =(applications * share_average) if firsttimeapp == .

* replace first-time applications with 0 if applications are zero**
replace firsttimeapp = 0 if firsttimeapp == . & applications == 0

* Use applications as proxy for first time applications if no share is available
* because applications are 0 in all years where first time applications are available

replace firsttimeapp = applications if firsttimeapp == . & applications != .

replace firsttimeapp = round(firsttimeapp)		

save ./out/data/temp/application-data-02-16-q.dta, replace


*******************************
*** Merge all decision data ***
*******************************

** 1. Merge decision data 2002 - 2007

use ./out/data/temp/total-decisions-02-07-m.dta, clear
merge 1:1 origin destination month year using ///
	./out/data/temp/total-positive-02-07-m.dta, nogen
merge 1:1 origin destination month year using ///
	./out/data/temp/refugee-status-02-07-m.dta, nogen
merge 1:1 origin destination month year using ///
	./out/data/temp/other-positive-02-07-m.dta, nogen
merge 1:1 origin destination month year using ///
	./out/data/temp/rejected-02-07-m.dta, nogen 
merge 1:1 origin destination month year using ///
	./out/data/temp/humanitarian-status-02-07-m.dta, nogen
merge 1:1 origin destination month year using ///
	./out/data/temp/other-non-status-02-07-m.dta, nogen


** 2. Recalculate total decisions
	* Note email from Eurostat:
	* othernonstatus decisions =  neither positive nor rejected
	* --> deduct othernonstatus decisions from total decisions

replace totaldecisions = totaldecisions - othernonstatus if othernonstatus != .


** 3. Collapse data to quarterly data

  * a, Make sure that if one months is missing in any variable
  *    the entire quarter is coded as missing 

  	foreach var of varlist totaldecisions totalpositive refugeestatus ///
							otherpositive rejected othernonstatus ///
							humanitarian {
		* identify non-missing quarters
		sort origin destination year quarter month
		by origin destination year quarter: egen non_missing_`var' = count(`var')
		
		* create a variable that contains only non-missing quarters
		gen `var'_nmq = .
		replace `var'_nmq = `var' if non_missing_`var' == 3
		
		* calculate total within one quarter, use mean *3 
		* in order to avoid having zeros in those quarters with missing data
		by origin destination year quarter: egen `var'_q = mean(`var'_nmq)
		replace `var' = `var'_q*3
}
*

  * b, collapse to quarterly data
	collapse (mean) totaldecisions totalpositive refugeestatus ///
					otherpositive rejected othernonstatus ///
					humanitarian, by (destination origin year quarter)

	save ./out/data/temp/decision-data-02-07-q.dta, replace

** 4. Merge decision data 2008 - 2016
	
use ./out/data/temp/total-decisions-08-16-q.dta, clear
merge 1:1 origin destination quarter year using ./out/data/temp/total-positive-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using ./out/data/temp/refugee-status-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using ./out/data/temp/rejected-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using ./out/data/temp/humanitarian-status-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using ./out/data/temp/temporary-protection-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using ./out/data/temp/subsidiary-protection-08-16-q.dta, nogen

** 5. Combine with 2002 - 2007 decision data

append using ./out/data/temp/decision-data-02-07-q.dta

* rename certain countries to match with list of source and destination countries later on   
replace origin = "Former Serbia Montenegro" if origin == "Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin = "Kosovo" if origin == "Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin = "Macedonia" if origin == "Former Yugoslav Republic of Macedonia, the"
replace origin = "China" if origin == "China (including Hong Kong)"
replace origin = "Gambia" if origin == "Gambia, The"


replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"


* Calculate different recognition rates

* Note: many cases where rejected + total positive is not equal to totaldecisions
*       and some cases where totaldecisions = 5 and rejected = 0 and totalpositive = 0,
*		probably due to rounding to the neares five
 
* Calculate total decisions as sum of rejected and total positive and 
* then calculate different recognition rates
rename totaldecisions totaldecisions_NI

gen totaldecisions = rejected + totalpositive

gen acceptance_rate = totalpositive / totaldecisions
replace acceptance_rate = 1 if acceptance_rate > 1 & acceptance_rate != .

gen rejection_rate = rejected / totaldecisions
replace rejection_rate = 1 if rejection_rate > 1 & rejection_rate != .

gen refugeestatus_rate = refugeestatus / totaldecisions
replace refugeestatus_rate = 1 if refugeestatus_rate > 1 & refugeestatus_rate != .

gen temporary_protection = totalpositive - refugeestatus

gen temporary_protection_rate = temporary_protection / totaldecisions
replace temporary_protection_rate = 1 if temporary_protection_rate > 1 & temporary_protection_rate != .

label variable acceptance_rate "Acceptance rate"
label variable temporary_protection_rate "Temporary protection rate"
label variable refugeestatus_rate "Refugee status rate"


* Calculate average dyadic decisions in the previous year
sort destination origin year quarter

* generate lags of dyadic decisions
by destination origin: gen lag1_totaldecisions = totaldecisions[_n-1]
by destination origin: gen lag2_totaldecisions = totaldecisions[_n-2]
by destination origin: gen lag3_totaldecisions = totaldecisions[_n-3]

* generate mean of decisions in the past year (includuing current quarter)
egen yearly_dyadic_decisions = ///
		rowmean(totaldecisions lag1_totaldecisions ///
				lag2_totaldecisions lag3_totaldecisions)

				
save ./out/data/temp/decision-data-02-16-q.dta, replace


*********************************************
*** Combine decision and application data ***
*********************************************

use ./out/data/temp/application-data-02-16-q.dta, clear

* match decision data
* Note: Former Serbia Montenegro and Hong Kong missing in decision data
merge 1:1 origin destination year quarter using ./out/data/temp/decision-data-02-16-q.dta, nogen


* match with relevant origin and destination countries
merge m:1 origin destination using ./out/data/temp/origin_destination_help.dta
* note: no data for the combination Switzerland and Former Serbia Montenegro, 
* 		because data for Switzerland is only available from 2008 onwards
keep if _merge == 3
drop _merge

* Note Bulgaria, Romania and Slovakia are both origin and destination countries
foreach v in Bulgaria Romania Slovakia {
	drop if origin == "`v'" & destination == "`v'"
}
*

* delete irrelevant years for Kosovo, Former Serbia Montenegro and Serbia
drop if origin == "Kosovo" & year <= 2008
drop if origin == "Former Serbia Montenegro" & year >= 2007
drop if origin == "Serbia" & year <= 2006

* add data from


save ./out/data/temp/combined-asylum-data-02-16-q.dta, replace
