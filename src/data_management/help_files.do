*************************************************************
** Create help files with origin and destination countries **
*************************************************************

clear 
set more off, permanently
cd F:/research/asylum-project

* 1, help file with all relevant origin countries

import excel ./src/original_data/help/list_of_origin_countries.xlsx, sheet("Tabelle1") firstrow clear
save ./bld/out/data/temp/list_of_origin_countries.dta, replace

* 2, help file with all relevant destination countries

import excel ./src/original_data/help/list_of_destination_countries.xlsx, sheet("Tabelle1") firstrow clear
save ./bld/out/data/temp/list_of_destination_countries.dta, replace

* 3, help file with all relevant origin and destination countries

import excel ./src/original_data/help/origin_destination_countries.xlsx, sheet("Tabelle1") firstrow clear

reshape long help_, i(origin) j(destination) string
drop help_

replace destination="United Kingdom" if destination=="UnitedKingdom"
replace destination="Czech Republic" if destination=="CzechRepublic"

save ./bld/out/data/temp/origin_destination_help.dta, replace

* 4, help file for all relevent origin countries and all quarters

import excel ./src/original_data/help/origin_quarter.xlsx, sheet("Tabelle1") firstrow clear

reshape long test, i(origin) j(quarteryear) string
	split quarteryear, parse(_) destring ignore( `"_"')
	rename quarteryear1 quarter
	rename quarteryear2 year
	drop test quarteryear
	sort origin year quarter
	
save ./bld/out/data/temp/origin_quarter_help.dta, replace

