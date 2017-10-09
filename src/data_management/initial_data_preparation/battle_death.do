*********************************
** Quarterly battle death data **
*********************************

clear 
set more off, permanently


***********************************************************************
** Quarterly battle death data from UCDP for all countries but SYRIA **
***********************************************************************

* 1, convert excel file from UCDP into dta file

import excel ./src/original_data/origin_country/ged171.xlsx, sheet("ged171") firstrow clear
	
	destring year best, replace
	drop if year<2001
	keep country id date_start date_end best

	gen start_date = date(date_start, "YMD")
	gen end_date = date(date_end, "YMD")
	drop date_start date_end
	
	gen start_year = year(start_date)
	gen start_quarter = quarter(start_date)
	gen end_year = year(end_date)
	gen end_quarter = quarter(end_date)

save ./out/data/temp/ged171.dta, replace

* 2, sum deaths per quarter and country if event is within a quarter

use ./out/data/temp/ged171.dta, clear

keep if start_quarter == end_quarter

rename start_quarter quarter
rename start_year year

collapse (sum) best, by(country year quarter)

save ./out/data/temp/deaths_prel.dta, replace

* 3, sum deaths per quarter and country if event goes beyond a quarter
	* (no events go beyond a year)

use ./out/data/temp/ged171.dta, clear

* check whether any events go beyond one year**
compare start_year end_year
* check how many events go beyond one quarter**
compare start_quarter end_quarter

* select events that cross quarters 
rename start_year year
drop end_year
keep if start_quarter ~= end_quarter 
drop if best == 0

* generate average per quarter deaths
gen best_pq=best/(end_quarter-start_quarter+1)

* generate variables for the quarters 
* that need to be added between start and end quarter
gen add_quarter1=.
gen add_quarter2=.

replace add_quarter1=start_quarter+1 if end_quarter-start_quarter==2
replace add_quarter1=start_quarter+1 if end_quarter-start_quarter==3
replace add_quarter2=start_quarter+2 if end_quarter-start_quarter==3

save ./out/data/temp/death_quarter_temp.dta, replace

* create a file for each of the four quarters and append it to one file

use ./out/data/temp/death_quarter_temp.dta, clear
keep country year best_pq start_quarter
rename start_quarter quarter
save ./out/data/temp/death_quarter_temp1.dta, replace

foreach var in end_quarter add_quarter1 add_quarter2 {

	use ./out/data/temp/death_quarter_temp.dta, clear
	keep country year best_pq `var'
	rename `var' quarter
	append using ./out/data/temp/death_quarter_temp1.dta
	save ./out/data/temp/death_quarter_temp1.dta, replace
}
*
	
drop if quarter==.

collapse (sum) best_pq, by(country year quarter)

* 4, combine with death data from events that happen within a quarter

merge 1:1 country year quarter using ./out/data/temp/deaths_prel.dta

egen battle_death_ucdp=rowtotal(best best_pq)

drop best best_pq _merge

rename country origin
replace origin="Zimbabwe" if origin=="Zimbabwe (Rhodesia)"
replace origin="Former Serbia Montenegro" if origin=="Serbia (Yugoslavia)"
replace origin="Russia" if origin=="Russia (Soviet Union)"
replace origin="Macedonia" if origin=="Macedonia, FYR"
replace origin="Côte d'Ivoire" if origin=="Ivory Coast"
replace origin="Democratic Republic of the Congo" if origin=="DR Congo (Zaire)"

* 5, prepare for matching with different data sources for Syria

gen battle_death_vdc=battle_death_ucdp

save ./out/data/temp/quarterly_deaths_01_16_no_Syria.dta, replace



*******************************************
** quarterly battle death data for Syria **
*******************************************

***Note Syria is missing in the data** 
**two solutions**
* 1. Use data from VDC, available quarterly but not complete*
* 2. Use yearly data from the Uppsala website
* 	 and assign it to quarters by using the share 
*    calculated with the VDC data** 

import excel ./src/original_data/origin_country/Syria_death.xlsx, sheet("data") firstrow clear

bysort year: egen death_y_ucdp = total(death)
bysort year: egen death_y_vdc = total(deathbyvdc)

gen share_vdc = deathbyvdc / death_y_vdc

gen battle_death_ucdp=death_y_ucdp*share_vdc
rename deathbyvdc battle_death_vdc

keep origin year quarter battle_death_ucdp battle_death_vdc


***************************************************************
** Combine data for Syria with data for all other countries ***
***************************************************************

append using ./out/data/temp/quarterly_deaths_01_16_no_Syria.dta


******************************************************************
** Scale up to contain all origin countries, quarters and years **
******************************************************************
merge 1:1 origin year quarter using ./out/data/temp/origin_quarter_help.dta

drop if _merge == 1
drop _merge

replace battle_death_ucdp=0 if battle_death_ucdp==.
replace battle_death_vdc=0 if battle_death_vdc==.

save ./out/data/temp/battle_death_quarterly_01_16.dta, replace
