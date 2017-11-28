*****************************************************
*****************************************************
***  Determine most important source countries    ***
*** for different samples of application analysis ***
*****************************************************
*****************************************************

clear
set more off, permanently

*******************
* Baseline sample *
*******************
use ./out/data/temp/application-data-02-16-q.dta, clear

* Select destination sample
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

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_baseline.dta, replace


******************************
* Baseline sample up to 2016 *
******************************
use ./out/data/temp/application-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only big countries that have a maximum of two missing years
	* Determine countries that have data in at least 52 out of 60 quarters**
	bysort origin destination: egen non_missing = count(firsttimeapp_NI)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 52

	* Determine big destination countries
	bysort destination: egen total_FTapp = total(firsttimeapp)
	drop if total_FTapp < 30000

	* exclude Cyprus because of irregular cabinet changes
	drop if destination == "Cyprus"

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_baseline2016.dta, replace

	
	
**************************************************************************	
* Sample with all destination countries with max 2 years of missing data *
**************************************************************************
use ./out/data/temp/application-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only countries that have a maximum of two missing years
	* Determine countries that have data in at least 44 out of 52 quarters**
	bysort origin destination: egen non_missing = count(firsttimeapp_NI)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 44

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_all_max_two_missing.dta, replace

	
	
**********************************************************	
* Sample with all destination countries with no missings *
**********************************************************
use ./out/data/temp/application-data-02-16-q.dta, clear
	
* Select destination sample
	* Use only 2002-2014
	drop if year > 2014

	* Use only countries that have a first-time applications in all years
	* Determine countries that have data in all 52 quarters**
	bysort origin destination: egen non_missing = count(firsttimeapp_NI)
	bysort destination: egen max_non_missing = max(non_missing) 
	keep if max_non_missing >= 52

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_no_missing.dta, replace

	
*******************************
* Baseline sample plus Cyprus *
*******************************
use ./out/data/temp/application-data-02-16-q.dta, clear

* Select destination sample
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

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_baseline_plus_cyprus.dta, replace

	
***********************************************************
* Sample of countries which are also in decision analysis *
***********************************************************
use ./out/data/temp/application-data-02-16-q.dta, clear

* Select destination sample
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
	* exlcude Belgium, Norway, Netherlands because of not being in decision analysis
	drop if destination == "Cyprus"| destination=="Belgium" | ///
			destination=="Netherlands" | destination=="Norway"

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_only_decision.dta, replace
	
	
***********************************************************
* Sample of countries with at maximum one early elections  *
***********************************************************
use ./out/data/temp/application-data-02-16-q.dta, clear

* Select destination sample
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
	* exlcude Netherlands and Denmark because of many early elections
	drop if destination == "Cyprus"| ///
			destination=="Netherlands" | destination=="Denmark"

* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_few_early_elections.dta, replace

	
	
************************************************
* Sample of countries with no early elections  *
************************************************
use ./out/data/temp/application-data-02-16-q.dta, clear

* Select destination sample
	* Use only 2002-2014
	drop if year > 2014

	*select countries with no early elections
	keep if destination == "France" | destination == "Ireland" | ///
			destination == "Norway" | destination == "Sweden" | ///
			destination == "United Kingdom"
			
* Determine most important source countries
	do ./src/data_management/final_data_preparation/modules/determine_source_countries_ftapp.do
	save  ./out/data/temp/source_countries_app_no_early_elections.dta, replace
