********************
***BILATERAL DATA***
********************

clear 
set more off, permanently


***********************************
**Data on immigrant stock in 2000**
***********************************

* 1, prepare data for Kosovo and Serbia
	**Kosovo and Serbia not yet existant as separate countries in 2000 **
	**use data for Serbia and Montengro for both Kosovo and Serbia and former Serbia and Montenegro**

foreach v in Kosovo Serbia {

	import excel ./src/original_data/bilateral_data/immigrant_stock.xlsx, sheet("2000") firstrow clear
		label variable Total "Total immigrant stock 2000"
		rename Total imm_stock_2000
		drop year OECD Observed Lesseduc College
	
	replace origin="`v'" if origin=="Serbia and Montenegro"
	
	merge m:m origin destination using ./out/data/temp/origin_destination_help.dta
	keep if _merge==3 & origin=="`v'" 
	drop _merge
	
	save ./out/data/temp/imm_stock_`v'.dta, replace
}
*

* 2, select data for all other countries and append data for Kosovo and Serbia	

import excel ./src/original_data/bilateral_data/immigrant_stock.xlsx, sheet("2000") firstrow clear
	label variable Total "Total immigrant stock 2000"
	rename Total imm_stock_2000
	drop year OECD Observed Lesseduc College

replace origin="Democratic Republic of the Congo" if origin=="Congo, Dem. Rep. of the"
replace origin="Gambia" if origin=="Gambia, The"
replace origin="Côte d'Ivoire" if origin=="Cote d'Ivoire"
replace origin="Congo" if origin=="Congo, Rep. of the"
replace origin="Former Serbia Montenegro" if origin=="Serbia and Montenegro" 

merge m:m origin destination using ./out/data/temp/origin_destination_help.dta
keep if _merge==3
drop _merge


append using ./out/data/temp/imm_stock_Kosovo.dta
append using ./out/data/temp/imm_stock_Serbia.dta

* Note Bulgaria, Romania and Slovakia are both origin and destination countries
foreach v in Bulgaria Romania Slovakia {
	drop if origin == "`v'" & destination == "`v'"
}
*

save ./out/data/temp/bilateral_immigrant_stock.dta, replace


****************************************
**Data Distance between capital cities**
****************************************

*1, Create help files to convert three letter codes into country names**

* Country codes for origin countries 
import excel ./src/original_data/bilateral_data/ida.xlsx, sheet("Tabelle2") firstrow clear
	replace origin="Gambia" if origin=="Gambia, The"
	replace origin="China" if origin=="China (including Hong Kong)"
	replace origin="Macedonia" if origin=="Former Yugoslav Republic of Macedonia, the"
	replace origin="Kosovo" if origin=="Kosovo (under United Nations Security Council Resolution 1244/99)"
	replace origin="Belarus" if origin=="Belarus (Byelorussia)"
	replace origin="Former Serbia Montenegro" if origin=="Yugoslavia"

merge 1:1 origin using ./out/data/temp/list_of_origin_countries.dta
keep if _merge==3
drop _merge

save ./out/data/temp/country_codes_origin.dta, replace


* Country codes for destination countries
import excel ./src/original_data/bilateral_data/idb.xlsx, sheet("Tabelle2") firstrow clear
	replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

merge 1:1 destination using ./out/data/temp/list_of_destination_countries.dta
keep if _merge==3
drop _merge

save ./out/data/temp/country_codes_destination.dta, replace


* 2, prepare data for Kosovo (own data collection because Kosovo is missing)

import excel ./src/original_data/bilateral_data/kmdist_Kosovo.xlsx, sheet("Tabelle1") firstrow clear
save ./out/data/temp/kmdist_Kosovo.dta, replace

* 3, select relevant countries from kmdist data set and add data for Kosovo

import delimited ./src/original_data/bilateral_data/capdist.csv, clear

merge m:1 ida using ./out/data/temp/country_codes_origin.dta
keep if _merge==3
drop _merge

merge m:1 idb using ./out/data/temp/country_codes_destination.dta
keep if _merge==3
drop _merge

keep origin destination kmdist

append using ./out/data/temp/kmdist_Kosovo.dta

save ./out/data/temp/bilateral_distance_data.dta, replace



****************************
** Combine bilateral data **
****************************
use ./out/data/temp/bilateral_immigrant_stock.dta, clear

merge 1:1 origin destination using ./out/data/temp/bilateral_distance_data.dta, nogen

* Note: no combination Switzerland & Former Serbia Montenegro
drop if origin == "Former Serbia Montenegro" & destination == "Switzerland"

save ./out/data/temp/bilateral_data.dta, replace
 
