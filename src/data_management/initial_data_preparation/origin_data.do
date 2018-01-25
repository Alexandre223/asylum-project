**********************************************************
*** Combine all control variables for origin countries ***
**********************************************************
clear
set more off, permanently

****************************
***Political Terror Scale***
****************************

import excel ./src/original_data/origin_country/political_terror_scale.xlsx, sheet("Sheet1") firstrow clear

rename Country origin
rename Year year

replace origin="Côte d'Ivoire" if origin=="Cote d'Ivoire"
replace origin="Democratic Republic of the Congo" if origin=="Congo, the Democratic Republic of the"
replace origin="Macedonia" if origin=="Macedonia, the former Yugoslav Republic of"
replace origin="Iran" if origin=="Iran, Islamic Republic of"
replace origin="Moldova" if origin=="Moldova, Republic of"
replace origin="Russia" if origin=="Russian Federation"
replace origin="Syria" if origin=="Syrian Arab Republic"
replace origin="Vietnam" if origin=="Viet Nam"
replace origin="Former Serbia Montenegro" if origin=="Serbia and Montenegro"

* note before 2004 no Former Serbia Montenegro, but Yugoslavia
* use score for Yugoslavia for Fromer Serbia Montenegro
drop if origin=="Yugoslavia" & year>2003
drop if origin=="Former Serbia Montenegro" & year<2004
replace origin="Former Serbia Montenegro" if origin=="Yugoslavia"

merge m:1 origin using ./out/data/temp/list_of_origin_countries.dta
keep if _merge==3

keep origin year PTS_A PTS_S
drop if year <=2000

foreach v of varlist PTS_A PTS_S {
	replace `v' = "" if `v' == "NA"
	destring `v', replace
}
*
egen PTS = rowmean(PTS_A PTS_S)

drop PTS_A PTS_S

save ./out/data/temp/political_terror_scale.dta, replace


*************************
***Freedom House Index***
*************************
import excel ./src/original_data/origin_country/freedom_house_index.xlsx, sheet("Tabelle1") firstrow clear

replace origin="Côte d'Ivoire" if origin=="Cote d'Ivoire"
replace origin="Democratic Republic of the Congo" if origin=="Congo (Kinshasa)"
replace origin="Former Serbia and Montenegro" if origin=="Yugoslavia (Serbia & Montenegro)"
replace origin="Gambia" if origin=="Gambia, The"
replace origin="Bosnia and Herzegovina" if origin=="Bosnia Herzegovina"
replace origin="Congo" if origin=="Congo (Brazzaville)"
replace origin="Congo" if origin=="Congo (Brazzaville)"
replace origin="Former Serbia Montenegro" if origin=="Former Serbia and Montenegro"

merge 1:1 origin using ./out/data/temp/list_of_origin_countries.dta

keep if _merge==3
drop _merge

destring PR* CL*, replace

reshape long PR CL Status, i(origin) j(year)
drop Status

drop if year <=2000

***Note: Value for former Serbia Montenegro in 2006 missing**
**PR 2005 and Serbia 2006 = 3
**CL 2005 and Serbia 2006 = 2
***replace missing value for 2006 with these numbers

replace PR=3 if origin=="Former Serbia Montenegro" & year==2006
replace CL=2 if origin=="Former Serbia Montenegro" & year==2006

save ./out/data/temp/freedom_house_index.dta, replace


*********************
** Data for region **
*********************
import excel ./src/original_data/origin_country/origin_areas.xlsx, sheet("Tabelle1") firstrow clear

label variable Africa "Other African countries"
label variable MENA "Middle East and North Africa"
label variable ECA "Europe and Central Asia"
label variable SEA "South and East Asia"

save ./out/data/temp/origin_areas.dta, replace



*******************************
** Origin country population **
*******************************

* 1, World Bank Data *
	* Notes: 
	* data for Serbia, Montenegro, Kosovo separate for the enire time
	* -> sum population data of Serbia, Montenegro and Kosovo to get data
	*    for former Serbia Montenegro until 2006
	* -> add population of Kosovo to population of Serbia in 2007 and 2008
	* data for Eritrea missing from 2012 onwards
	* -> use UN data for Eritrea
	
	
import delimited .\src\original_data\origin_country\population_wb.csv, ///
		varnames(4) clear 

rename countryname origin
drop countrycode indicatorname indicatorcode
drop v5-v45 v62
		
local i = 2000		
foreach x of varlist v46 - v61{
	local i = `i' +1
	rename `x' pop_origin`i'
}
*

reshape long pop_origin, i(origin) j(year)

replace origin="Congo" if origin=="Congo, Rep."
replace origin="Côte d'Ivoire" if origin=="Cote d'Ivoire"
replace origin="Democratic Republic of the Congo" if origin=="Congo, Dem. Rep."
replace origin="Egypt" if origin=="Egypt, Arab Rep."
replace origin="Macedonia" if origin=="Macedonia, FYR"
replace origin="Iran" if origin=="Iran, Islamic Rep."
replace origin="Russia" if origin=="Russian Federation"
replace origin="Syria" if origin=="Syrian Arab Republic"
replace origin="Gambia" if origin=="Gambia, The"
replace origin="Slovakia" if origin=="Slovak Republic"

save ./out/data/temp/population_wb_temp.dta, replace

* Sum population of Serbia, Montenegro + Kosovo 
* to get population for Former Serbia Montenegro until 2006
use ./out/data/temp/population_wb_temp.dta
keep if origin == "Serbia" | origin == "Montenegro" | origin == "Kosovo"
drop if year > 2006
replace origin = "Former Serbia Montenegro" 
collapse (sum) pop_origin, by(origin year)

save ./out/data/temp/population_wb_fsm.dta, replace


* add population of Kosovo to population of Serbia in 2007 and 2008
use ./out/data/temp/population_wb_temp.dta
keep if origin == "Serbia" | origin == "Kosovo"
drop if year < 2007
replace pop_origin = . if origin == "Kosovo" & year > 2008
replace origin = "Serbia" 
collapse (sum) pop_origin, by(origin year)

save ./out/data/temp/population_wb_serbia.dta, replace


* prepare world bank data for other countries**
use ./out/data/temp/population_wb_temp.dta, replace

merge m:1 origin using ./out/data/temp/list_of_origin_countries.dta
keep if _merge == 3
drop _merge
drop if origin == "Eritrea" | origin == "Serbia"
drop if origin == "Kosovo" & year <=2008

* add data for Serbia and Former Serbia Montenegro

append using ./out/data/temp/population_wb_fsm.dta
append using ./out/data/temp/population_wb_serbia.dta

save ./out/data/temp/population_wb.dta, replace

* 2, UN data for Erirea

* get data from 2016 from medium variant estimate 
import excel .\src\original_data\origin_country\population_un.xlsx, ///
			sheet("MEDIUM VARIANT") cellrange(A17:BS290) firstrow clear
			
rename Regionsubregioncountryorar origin

keep if origin=="Eritrea"

keep origin G
rename G pop_origin
replace pop_origin=pop_origin*1000
gen year = 2016

save ./out/data/temp/population_un_2016.dta, replace

* get data for years 2001 - 2015
import excel .\src\original_data\origin_country\population_un.xlsx, ///
			sheet("ESTIMATES") cellrange(A17:BS290) firstrow clear
			
rename Regionsubregioncountryorar origin

keep if origin=="Eritrea"

keep origin BE - BS
local i = 2000		
foreach x of varlist BE - BS{
	local i = `i' +1
	rename `x' pop_origin`i'
}
*
destring pop_origin*, replace
reshape long pop_origin, i(origin) j(year)
replace pop_origin=pop_origin*1000

append using ./out/data/temp/population_un_2016.dta
append using ./out/data/temp/population_wb.dta

label variable pop_origin "Origin country population"

save ./out/data/temp/origin_population.dta, replace



*****************************
** Combine all origin data **
*****************************
use ./out/data/temp/battle_death_quarterly_01_16.dta, clear

merge m:1 origin year using ./out/data/temp/political_terror_scale.dta, nogen

merge m:1 origin year using ./out/data/temp/freedom_house_index.dta, nogen 

merge m:1 origin using ./out/data/temp/origin_areas.dta, nogen

drop if origin=="Kosovo" & year<=2008
drop if origin=="Former Serbia Montenegro" & year>=2007
drop if origin=="Serbia" & year<=2006

merge m:1 origin year using ./out/data/temp/origin_population.dta, nogen

merge m:1 origin year using ./out/data/temp/origin_rGDP_pc.dta, nogen



**********************************************************************
** Impute missing values for real GDP pc and political terror scale **
**********************************************************************

* Impute missing information for real GDP pc
* Somalia missing 2011-2016, Kosovo missing 2016
* Syria missing 2015 and 2016

* Use value of last observed year for missing years
sort origin year quarter
replace realGDPpc = realGDPpc[_n-1] if realGDPpc == .
gen log_rGDPpc_orig = log(realGDPpc)

* Impute missing information for political terror scale

* Use 2015 value also for 2016**
sort origin year quarter
replace PTS = PTS[_n-1] if PTS == .


*********************************************************
** Calculate lagged variables for all yearly variables **
**          and quarterly battle death 				   **
*********************************************************

* Note all origin country variables are yearly - 
* idea use moving averages  - mean of current quarter and past 3 quarters**

***Generate quarterly averages**
sort  origin year quarter

foreach var of varlist ///
		PTS PR CL battle_death_vdc battle_death_ucdp log_rGDPpc_orig {
	
	* generate lags
	by  origin: gen lag1_`var'=`var'[_n-1]
	by  origin: gen lag2_`var'=`var'[_n-2]
	by  origin: gen lag3_`var'=`var'[_n-3]
	
	* generate sum of decisions in the past year (includuing current quarter)
	egen `var'_average=rowmean(`var' lag1_`var' lag2_`var' lag3_`var')
}
*

drop if year==2001

* Rescale variables 
gen death_thousands_ucdp = battle_death_ucdp / 1000
gen death_thousands_vdc = battle_death_vdc / 1000

gen death_thousands_ucdp_average = battle_death_ucdp_average / 1000
gen death_thousands_vdc_average = battle_death_vdc_average / 1000

* Label variables
foreach var of varlist 	death_thousands_ucdp ///
						death_thousands_vdc ///
						death_thousands_ucdp_average ///
						death_thousands_vdc_average {

	label variable `var' "Quarterly civil war battle death (000s)"
}
*
label variable log_rGDPpc_orig "Log origin country real GDP per capita"
label variable log_rGDPpc_orig_average "Log origin country real GDP per capita"
label variable realGDPpc "Yearly real GDP per capita at origin"

label variable PTS "Political Terror Scale"
label variable PTS_average "Political Terror Scale"

label variable PR "Political Rights (FHI)"
label variable PR_average "Political Rights (FHI)"

label variable CL "Civic Liberty (FHI)"
label variable CL_average "Civic Liberty (FHI)"

save ./out/data/temp/origin_data.dta, replace
