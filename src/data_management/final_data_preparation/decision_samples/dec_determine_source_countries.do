*****************************************************
*****************************************************
***  Determine most important source countries    ***
*** for different samples of decision analysis    ***
*****************************************************
*****************************************************

clear
set more off, permanently

*******************
* Baseline sample *
*******************
use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select destination sample
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

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_dec_baseline.dta, replace


******************************
* Baseline sample up to 2016 *
******************************
use ./out/data/temp/decision-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 52 out of 60 quarters**
	bysort origin destination: egen non_missing = count(totaldecisions)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 52

	* Determine big destination countries
	bysort destination: egen total_dec = total(totaldecisions)
	drop if total_dec < 30000

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_dec_baseline2016.dta, replace

	
	
**************************************************************************	
* Sample with all destination countries with max 2 years of missing data *
**************************************************************************
use ./out/data/temp/decision-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(totaldecisions)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_dec_all_max_two_missing.dta, replace

	
	
**********************************************************	
* Sample with all destination countries with no missings *
**********************************************************
use ./out/data/temp/decision-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only countries that have a first-time applications in all years
	* Determine countries that have data in all 52 quarters**
	bysort origin destination: egen non_missing = count(totaldecisions)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 52

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_dec_no_missing.dta, replace



**************************************************************
* Sample of countries which are also in application analysis *
**************************************************************
use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select destination sample
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


* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_dec_only_application.dta, replace
	

*****************************************************
* Sample of countries with only few early elections *
*****************************************************
use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select destination sample
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

	* Drop countries which have more than one early election
	drop if destination == "Austria" | destination == "Denmark" | ///
			destination == "Greece"
	
* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_few_early_elections.dta, replace	

	
***********************************************
* Sample of countries with no early elections *
***********************************************
use ./out/data/temp/decision-data-02-16-q.dta, clear

* Select destination sample
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

	* Drop countries which have more than one early election
	drop if destination == "Austria" | destination == "Denmark" | ///
			destination == "Greece" | destination == "Germany" | ///
			destination == "Poland" | destination == "Spain"
	
* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_dec.do
	save  ./out/data/temp/source_countries_no_early_elections.dta, replace	
