* ============== *
******************
** DESCRIPTIVES **
******************
* ============== *

clear
set more off, permanently

** SUMMARY STATISTICS **

** =============================== **
** Applications summary statistics **
** =============================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


drop if log_firsttimeapp_pc==.

sutex2 	firsttimeapp_total firsttimeapp_total_pc n_elections_max n_cabinet_changes_max ///
		cabinet_left_right  PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/applications/app_summary_statistics.tex) replace

		
** ============================ **
** Decisions summary statistics **
** ============================ **

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2
drop if acceptance_rate == .


sutex2 	all_decisions_dest 	all_decisions_dest_pc ///
		acceptance_rate refugeestatus_rate temporary_protection_rate ///
		n_elections_max n_cabinet_changes_max cabinet_left_right ///
		PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/decisions/dec_summary_statistics.tex) replace
		
		
		
		
********************************************************
** TABLE WITH TOTAL NUMBER OF FIRST-TIME APPLICATIONS **
**    AND TOTAL NUMBER OF DECISIONS 2202 - 2014       **
********************************************************

** ======================================= **
** Total number of first-time applications **
** ======================================= **

use ./out/data/temp/application-data-02-16-q.dta, clear

* Select only destination countries in baseline sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(firsttimeapp_NI)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

	* Determine big destination countries
	bysort destination: egen total_FTapp = total(firsttimeapp)
	drop if total_FTapp < 30000

	* exclude Cyprus because of irregular cabinet changes
	drop if destination == "Cyprus"

	collapse (mean) total_FTapp, by (destination)

export excel using .\out\analysis\descriptives\total_ftapp_by_destination.xlsx, firstrow(variables) replace



** ========================= **
** Total number of decisions **
** ========================= **

use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select only destination countries in baseline sample of application analysis
	* Use only 2002-2014
	drop if year > 2014

	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(totaldecisions)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

	* Determine big destination countries
	bysort destination: egen total_dec = total(totaldecisions)
	drop if total_dec < 20000

	* exlcude Belgium, Norway, Netherlands because of not being in application analysis
	drop if destination=="Austria" | destination=="Finland" | ///
			destination=="Greece" | destination=="Hungary" 

	collapse (mean) total_dec, by (destination)

export excel using .\out\analysis\descriptives\total_dec_by_destination.xlsx, firstrow(variables) replace



****************************************************************************
** TOP SOURCE COUNTRIES AND THEIR SHARE IN TOTAL APPLICATIONS / DECISIONS **
****************************************************************************

** ================================================ **
** Share in total number of first-time applications **
** ================================================ **

use ./out/data/temp/application-data-02-16-q.dta, clear

* Select only destination countries in baseline sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(firsttimeapp_NI)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

	* Determine big destination countries
	bysort destination: egen total_FTapp = total(firsttimeapp)
	drop if total_FTapp < 30000

	* exclude Cyprus because of irregular cabinet changes
	drop if destination == "Cyprus"
	
	
* Determine most important source countries and their
*  share of total first-time applications	
	collapse (sum) firsttimeapp, by (origin)

	egen total=total(firsttimeapp)

	gen share=firsttimeapp/total

	drop if origin=="Unknown" | origin=="Stateless" | origin=="Recognised non-citizens"

	gsort -share

	gen sum_share=sum(share)

	drop if sum_share>=0.9032

	list origin share sum_share 

export excel using .\out\analysis\descriptives\source_countries_applications.xlsx, firstrow(variables) replace


** ================================== **
** Share in total number of decisions **
** ================================== **

use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select only destination countries in baseline sample of application analysis
	* Use only 2002-2014
	drop if year > 2014

	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(totaldecisions)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

	* Determine big destination countries
	bysort destination: egen total_dec = total(totaldecisions)
	drop if total_dec < 20000

	* exlcude Belgium, Norway, Netherlands because of not being in application analysis
	drop if destination=="Austria" | destination=="Finland" | ///
			destination=="Greece" | destination=="Hungary" 
			
* Determine most important source countries and their
*  share of total decisions				
	collapse (sum) totaldecisions, by (origin)

	egen total=total(totaldecisions)

	gen share=totaldecisions/total

	drop if origin=="Unknown" | origin=="Stateless" | origin=="Recognised non-citizens"

	gsort -share

	gen sum_share=sum(share)

	drop if sum_share>=0.903

	list origin share sum_share 
	
export excel using .\out\analysis\descriptives\source_countries_decisions.xlsx, firstrow(variables) replace
