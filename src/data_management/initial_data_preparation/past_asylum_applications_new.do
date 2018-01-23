
*********************************************
*** ===================================== ***
*** TOTAL LAG LOG APPLICATIONS PER CAPITA ***
*** ===================================== ***
*********************************************

clear 
set more off, permanently


* 2, combine yearly application and firs time applications data from 1995 - 2016

use ./out/data/temp/applications-total-95-07-y.dta, clear

append using ./out/data/temp/applications-total-08-16-y.dta

merge 1:1 destination year using ///
	./out/data/temp/first-time-applications-total-08-16-y.dta, nogen

	
* Note:  for UK 2008 total applications missing but 
*		total first time applications availible - use as proxy
replace applications_total = firsttimeapp_total if applications_total == . & destination == "United Kingdom"

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

save ./out/data/temp/applications-total-95-16-y.dta, replace


* 3, add population size

merge 1:1 destination year using ./out/data/temp/destination_population_all.dta, nogen

* 4, calculate average past applications per capita 
*   (previous year & average of past 2 years)

* PROBLEM Norway 2007 missing -> Proxy 2007 as average of 2006 and 2008
sort destination year
replace applications_total = (applications_total[_n-1] + applications_total[_n+1])/2 if destination=="Norway" & year==2007

egen id = group (destination)
tsset id year

generate av_app1 = L1.applications_total 
generate av_app2 = (L1.applications_total + L2.applications_total)/2
generate av_app3 = (L1.applications_total + L2.applications_total + L3.applications_total)/3
generate av_app4 = (L1.applications_total + L2.applications_total + L3.applications_total + L4.applications_total)/4
generate av_app5 = (L1.applications_total + L2.applications_total + L3.applications_total + L4.applications_total + L5.applications_total)/5


drop if year<2002

local t=1
while `t'<=5 {
gen log_av_app_pc`t'=log((av_app`t' + 1)/pop_destination)
 local t=`t'+1
 }
*

keep destination year log_av_app_pc1 log_av_app_pc2 log_av_app_pc3 ///
		log_av_app_pc4 log_av_app_pc5

label variable log_av_app_pc1 "Log total asylum applications per capita in previous year"

local t=2
while `t'<=5 {
label variable log_av_app_pc`t' "Log total average asylum applications per capita in previous `t' years"
 local t=`t'+1
 }
*

save ./out/data/temp/lag_total_applications.dta, replace



********************************************************
*** ================================================ ***
*** TOTAL LAG LOG FIRST-TIME APPLICATIONS PER CAPITA ***
*** ================================================ ***
********************************************************

* 1. Combine all data
use ./out/data/temp/applications-total-08-16-m.dta, clear

merge 1:1 destination year month using ///
	./out/data/temp/first-time-applications-total-08-16-m.dta, nogen

append using ./out/data/temp/first-time-applications-total-00-07-m.dta

* 2. Collapse the data

  * a, Make sure that if one months is missing in first time applications 
  *    /applications the entire quarter is coded as missing 

	foreach var of varlist firsttimeapp_total applications_total {
		* identify non-missing quarters
		sort destination year quarter month
		by destination year quarter: egen non_missing_`var' = count(`var')
		
		* create a variable that contains only non-missing quarters
		gen `var'_nmq = .
		replace `var'_nmq = `var' if non_missing_`var' == 3
		
		* calculate total within one quarter, use mean *3 
		* in order to avoid having zeros in those quarters with missing data
		by destination year quarter: egen `var'_q = mean(`var'_nmq)
		replace `var' = `var'_q*3
}
*
   * b, collapse to quarterly data
	collapse (mean) firsttimeapp_total applications_total, by (destination year quarter)

* 3, Impute missing data on first-time applications_total after 2007 
*	 		from application data from these years 

* Calculate share of first-time applications_total in total applications_total
* use only values until 2014 because during the refugee crisis values might be different
gen share_ftapp = firsttimeapp_total/ applications_total
replace share_ftapp = . if year > 2015

* Note 104 cases where first- time applications_total > applications_total 
* Must be mistakes in the data because applications_total should include first-time applications_total
* replace share with 1 if it is larger than 1
replace share_ftapp = 1 if share_ftapp > 1 & share_ftapp != .

sort destination year quarter
by destination: egen share_average = mean(share_ftapp)

* calcuate first-time applications_total from applications_total 
* when firsttime applications_total are not available
gen firsttimeapp_total_NI = firsttimeapp_total
replace firsttimeapp_total =(applications_total * share_average) if firsttimeapp_total == .

* replace first-time applications_total with 0 if applications_total are zero**
replace firsttimeapp_total = 0 if firsttimeapp_total == . & applications_total == 0

* Use applications_total as proxy for first time applications_total if no share is available
* because applications_total are 0 in all years where first time applications_total are available

replace firsttimeapp_total = applications_total if firsttimeapp_total == . & applications_total != .

replace firsttimeapp_total = round(firsttimeapp_total)		

replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"

keep destination year quarter firsttimeapp_total

* 4, add population size

merge m:1 destination year using ./out/data/temp/destination_population_all.dta
keep if _merge == 3

* 5, calculate 6 quarter lags average first-time applications
sort destination year quarter

* generate lags of total first-time applications
local t=1
while `t'<=6 {
	by destination: gen lag`t'_firsttimeapp_total = firsttimeapp_total[_n-`t']
	local t=`t'+1
 }
*

* calculate rowmean of past 6 quarters of first-time applications
egen firsttimeapp_total_mean6 = rowmean (lag1_firsttimeapp_total ///
										 lag2_firsttimeapp_total ///
										 lag3_firsttimeapp_total ///
										 lag4_firsttimeapp_total ///
										 lag5_firsttimeapp_total ///
										 lag6_firsttimeapp_total)
							
**gen log per capita*
gen log_lag1_firsttimeapp_total_pc = log((lag1_firsttimeapp_total + 1) / pop_destination[_n-1])
gen log_firsttimeapp_total_pc_mean6 = log((firsttimeapp_total_mean6 + 1) / pop_destination)

label variable log_lag1_firsttimeapp_total_pc ///
			"quarterly total first-time applications per capita in previous quarter"
label variable log_firsttimeapp_total_pc_mean6 ///
			"log average total first-time applications in the previous 6 quarters"

drop if year < 2002

keep destination year quarter  log_firsttimeapp_total_pc_mean6

save ./out/data/temp/lag_total_first-time-applications.dta, replace



*********************************************************
*** ================================================= ***
*** DYADIC LAG LOG FIRST-TIME APPLICATIONS PER CAPITA ***
*** ================================================= ***
*********************************************************


* 1. Combine all data
use ./out/data/temp/applications-08-16-m.dta, clear

merge 1:1 destination origin year month using ///
	./out/data/temp/first-time-applications-08-16-m.dta, nogen

append using ./out/data/temp/first-time-applications-00-07-m.dta

* rename certain countries to match with list of source and destination countries later on   
replace origin = "Former Serbia Montenegro" if origin == "Former Serbia and Montenegro (before 2006) / Total components of the former Serbia and Montenegro"
replace origin = "Kosovo" if origin == "Kosovo (under United Nations Security Council Resolution 1244/99)"
replace origin = "Macedonia" if origin == "Former Yugoslav Republic of Macedonia, the"
replace origin = "China" if origin == "China (including Hong Kong)"
replace origin = "China" if origin == "China including Hong Kong"
replace origin = "Gambia" if origin == "Gambia, The"

replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"


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



keep destination origin year quarter firsttimeapp

* 4, add population size

merge m:1 destination year using ./out/data/temp/destination_population_all.dta
keep if _merge == 3

* 5, calculate 6 quarter lags average first-time applications
sort destination origin year quarter

* generate lags of total first-time applications
local t=1
while `t'<=6 {
	by destination origin: gen lag`t'_firsttimeapp = firsttimeapp[_n-`t']
	local t=`t'+1
 }
*

* calculate rowmean of past 6 quarters of first-time applications
egen firsttimeapp_dyadic_mean6 = rowmean (lag1_firsttimeapp ///
											 lag2_firsttimeapp ///
											 lag3_firsttimeapp ///
											 lag4_firsttimeapp ///
											 lag5_firsttimeapp ///
											 lag6_firsttimeapp)
							
**gen log per capita*
gen log_lag1_firsttimeapp_pc = log((lag1_firsttimeapp + 1)/pop_destination)
gen log_firsttimeapp_dyadic_pc_mean6 = log((firsttimeapp_dyadic_mean6 + 1)/pop_destination)

label variable log_lag1_firsttimeapp_pc ///
			"quarterly dyadic first-time applications per capita in previous quarter"
label variable log_firsttimeapp_dyadic_pc_mean6 ///
			   "log average dyadic first-time applications in the previous 6 quarters"

drop if year < 2002

keep destination origin year quarter lag1_firsttimeapp log_firsttimeapp_dyadic_pc_mean6

save ./out/data/temp/lag_dyadic_first-time-applications.dta, replace

