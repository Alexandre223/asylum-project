**************************************
**************************************
*** MERGE ASYLUM AND DECISION DATA ***
**************************************
**************************************

clear
set more off, permanently
cd F:/research/asylum-project/bld/out/data/temp

****************************************************************
** Merge monthly asylum data and collapse it to quarterly data *
****************************************************************

* 1. Combine all data
use applications-08-16-m.dta, clear

merge 1:1 origin destination year month using first-time-applications-08-16-m.dta
drop _merge

append using first-time-applications-02-07-m.dta

* 2. Collapse the data

  * a, Make sure that if one months is missing in first time applications 
  *    /applications the entire quarter is coded as missing 

	foreach var of varlist firsttimeapp applications {
		* identify non-missing quarters
		sort origin destination year quarter month
		by origin destination year quarter: egen non_missing_`var'=count(`var')
		
		* create a variable that contains only non-missing quarters
		gen `var'_nmq=.
		replace `var'_nmq=`var' if non_missing_`var'==3
		
		* calculate total within one quarter, use mean *3 
		* in order to avoid having zeros in those quarters with missing data
		by origin destination year quarter: egen `var'_q=mean(`var'_nmq)
		replace `var'=`var'_q*3
}
*
   * b, collapse to quarterly data
	collapse (mean) firsttimeapp applications, by (destination origin year quarter)

* 3. rename certain countries to match with list of source and destination countries later on   

replace origin="Former Serbia Montenegro" if origin=="Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin="Kosovo" if origin=="Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin="Macedonia" if origin=="Former Yugoslav Republic of Macedonia, the"
replace origin="China" if origin=="China (including Hong Kong)"
replace origin="Gambia" if origin=="Gambia, The"

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"


save application-data-02-16-q.dta, replace

*******************************
*** Merge all decision data ***
*******************************

** 1. Merge decision data 2002 - 2007

use total-decisions-02-07-m.dta, clear
merge 1:1 origin destination month year using total-positive-02-07-m.dta, nogen
merge 1:1 origin destination month year using refugee-status-02-07-m.dta, nogen
merge 1:1 origin destination month year using other-positive-02-07-m.dta, nogen
merge 1:1 origin destination month year using rejected-02-07-m.dta, nogen 
merge 1:1 origin destination month year using humanitarian-status-02-07-m.dta, nogen
merge 1:1 origin destination month year using other-non-status-02-07-m.dta, nogen


** 2. Recalculate total decisions
	* Note email from Eurostat:
	* othernonstatus decisions =  neither positive nor rejected
	* --> deduct othernonstatus decisions from total decisions

replace totaldecisions=totaldecisions-othernonstatus if othernonstatus!=.


** 3. Collapse data to quarterly data

  * a, Make sure that if one months is missing in any variable
  *    the entire quarter is coded as missing 

  	foreach var of varlist totaldecisions totalpositive refugeestatus ///
							otherpositive rejected othernonstatus ///
							humanitarian {
		* identify non-missing quarters
		sort origin destination year quarter month
		by origin destination year quarter: egen non_missing_`var'=count(`var')
		
		* create a variable that contains only non-missing quarters
		gen `var'_nmq=.
		replace `var'_nmq=`var' if non_missing_`var'==3
		
		* calculate total within one quarter, use mean *3 
		* in order to avoid having zeros in those quarters with missing data
		by origin destination year quarter: egen `var'_q=mean(`var'_nmq)
		replace `var'=`var'_q*3
}
*

  * b, collapse to quarterly data
	collapse (mean) totaldecisions totalpositive refugeestatus ///
					otherpositive rejected othernonstatus ///
					humanitarian, by (destination origin year quarter)

	save decision-data-02-07-q.dta, replace

** 4. Merge decision data 2008 - 2016
	
use total-decisions-08-16-q.dta, clear
merge 1:1 origin destination quarter year using total-positive-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using refugee-status-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using rejected-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using humanitarian-status-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using temporary-protection-08-16-q.dta, nogen
merge 1:1 origin destination quarter year using subsidiary-protection-08-16-q.dta, nogen

** 5. Combine with 2002 - 2007 decision data

append using decision-data-02-07-q.dta

** 6. rename certain countries to match with list of source and destination countries later on   

replace origin="Former Serbia Montenegro" if origin=="Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin="Kosovo" if origin=="Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin="Macedonia" if origin=="Former Yugoslav Republic of Macedonia, the"
replace origin="China" if origin=="China (including Hong Kong)"
replace origin="Gambia" if origin=="Gambia, The"

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

save decision-data-02-16-q.dta, replace

*********************************************
*** Combine decision and application data ***
*********************************************

use application-data-02-16-q.dta, clear
merge 1:1 origin destination year quarter using decision-data-02-16-q.dta

save combined-asylum-data-02-16-q.dta, replace
