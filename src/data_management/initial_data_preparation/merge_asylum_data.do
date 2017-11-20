**************************************
**************************************
*** PREPARE AND MERGE ASYLUM AND DECISION DATA ***
**************************************
**************************************

clear
set more off, permanently

***********************************************
** Convert asylum data from csv to dta files **
***********************************************

* First time asylum applications monthly 2002 - 2007
import delimited .\src\original_data\asylum_data\first-time-applications-02-07-m.csv, varnames(1) clear 

do ./convert_asylum_data_monthly.do

rename value firsttimeapp

save ./out/data/temp/first-time-applications-02-07-m.dta

****************************************************************
** Merge monthly asylum data and collapse it to quarterly data *
****************************************************************

* 1. Combine all data
use ./out/data/temp/applications-08-16-m.dta, clear

merge 1:1 origin destination year month using ///
	./out/data/temp/first-time-applications-08-16-m.dta, nogen

append using ./out/data/temp/first-time-applications-02-07-m.dta

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

* rename certain countries to match with list of source and destination countries later on   
replace origin = "Former Serbia Montenegro" if origin == "Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin = "Kosovo" if origin == "Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin = "Macedonia" if origin == "Former Yugoslav Republic of Macedonia, the"
replace origin = "China" if origin == "China (including Hong Kong)"
replace origin = "Gambia" if origin == "Gambia, The"
replace origin = "Côte d'Ivoire" if origin == "C%XF4te d'Ivoire"

replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"


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
replace origin = "Côte d'Ivoire" if origin == "C%XF4te d'Ivoire"

replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"

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

save ./out/data/temp/combined-asylum-data-02-16-q.dta, replace
