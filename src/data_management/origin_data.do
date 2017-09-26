**********************************************************
*** Combine all control variables for origin countries ***
**********************************************************
clear
set more off, permanently
cd F:/research/asylum-project


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

merge m:1 origin using ./bld/out/data/temp/list_of_origin_countries.dta
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

save ./bld/out/data/temp/political_terror_scale.dta, replace


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

merge 1:1 origin using ./bld/out/data/temp/list_of_origin_countries.dta

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

save ./bld/out/data/temp/freedom_house_index.dta, replace


*********************
** Data for region **
*********************
import excel ./src/original_data/origin_country/origin_areas.xlsx, sheet("Tabelle1") firstrow clear
save ./bld/out/data/temp/origin_areas.dta, replace



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

save ./bld/out/data/temp/population_wb_temp.dta, replace

* Sum population of Serbia, Montenegro + Kosovo 
* to get population for Former Serbia Montenegro until 2006
use ./bld/out/data/temp/population_wb_temp.dta
keep if origin == "Serbia" | origin == "Montenegro" | origin == "Kosovo"
drop if year > 2006
replace origin = "Former Serbia Montenegro" 
collapse (sum) pop_origin, by(origin year)

save ./bld/out/data/temp/population_wb_fsm.dta, replace


* add population of Kosovo to population of Serbia in 2007 and 2008
use ./bld/out/data/temp/population_wb_temp.dta
keep if origin == "Serbia" | origin == "Kosovo"
drop if year < 2007
replace pop_origin = . if origin == "Kosovo" & year > 2008
replace origin = "Serbia" 
collapse (sum) pop_origin, by(origin year)

save ./bld/out/data/temp/population_wb_serbia.dta, replace


* prepare world bank data for other countries**
use ./bld/out/data/temp/population_wb_temp.dta, replace

merge m:1 origin using ./bld/out/data/temp/list_of_origin_countries.dta
keep if _merge == 3
drop _merge
drop if origin == "Eritrea" | origin == "Serbia"
drop if origin == "Kosovo" & year <=2008

* add data for Serbia and Former Serbia Montenegro

append using ./bld/out/data/temp/population_wb_fsm.dta
append using ./bld/out/data/temp/population_wb_serbia.dta

save ./bld/out/data/temp/population_wb.dta, replace

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

save ./bld/out/data/temp/population_un_2016.dta, replace

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

append using ./bld/out/data/temp/population_un_2016.dta
append using ./bld/out/data/temp/population_wb.dta

save ./bld/out/data/temp/origin_population.dta, replace



*****************************
** Combine all origin data **
*****************************
use ./bld/out/data/temp/battle_death_quarterly_01_16.dta, clear

merge m:1 origin year using ./bld/out/data/temp/political_terror_scale.dta, nogen

merge m:1 origin year using ./bld/out/data/temp/freedom_house_index.dta, nogen 

merge m:1 origin using ./bld/out/data/temp/origin_areas.dta, nogen

drop if origin=="Kosovo" & year<=2008
drop if origin=="Former Serbia Montenegro" & year>=2007
drop if origin=="Serbia" & year<=2006

merge m:1 origin year using ./bld/out/data/temp/origin_population.dta, nogen

merge m:1 origin year using ./bld/out/data/temp/origin_rGDP_pc.dta, nogen

save ./bld/out/data/temp/origin_data.dta, replace
