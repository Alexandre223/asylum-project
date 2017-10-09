******************************
** Destination country data **
******************************

clear 
set more off, permanently


*********************
** Population size **
*********************
import delimited ./src/original_data/destination_country/population_destination.csv, ///
				encoding(UTF-8)clear

rename time year
rename geo destination
rename value pop_destination

drop age sex unit

destring pop_destination, ignore(",") replace

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

drop if year < 2002

save ./out/data/temp/destination_population.dta, replace



*************************************
** Destination real GDP per capita **
*************************************

* Note: Use quarterly real GDP and divide by population size because 
* 		no per capita values are available for Switzerland and Romania  
                                                                                     
import delimited F:\research\asylum-project\src\original_data\destination_country\real_gdp_destination.csv, ///
		varnames(1) encoding(UTF-8) clear

rename geo destination
rename value rGDP
destring rGDP, ignore(",:") replace

split time, parse(Q) destring ignore( `"Q"')
rename time1 year
rename time2 quarter

keep destination year quarter rGDP

label variable rGDP "quarterly GDP Chain linked volumes (2010), million euro"

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"


**Add population size data**
merge m:1 destination year using ./out/data/temp/destination_population.dta, nogen


**Generate real GDP per capita**
gen rGDPpc=(rGDP*1000000)/pop_destination

label variable rGDPpc "real GDP per capita in destination country"

drop if year < 2002

save ./out/data/temp/destination_gdp.dta, replace



**************************************************
** Unemployment rate according to ILO defintion **
**************************************************

**Note: unemployment rate for Germany, France and Switzerland
** 		 not available on EUROSTAT 

	
*Prepare data for Switzerland**

import excel ./src/original_data/destination_country/unemployment_rate_Switzerland.xls, ///
 sheet("Quartalswerte") cellrange(A4:DA7) firstrow clear

drop if A == ""
drop A - AS
gen destination = "Switzerland"


* rename variables
foreach v of varlist AT - DA {
   local x : variable label `v'
   rename `v' unemployment_`x'
}
*

reshape long unemployment, i(destination) j(quarteryear) string
split quarteryear, parse(_)

rename quarteryear2 year
gen quarter = .
replace quarter = 1 if quarteryear3 == "I"
replace quarter = 2 if quarteryear3 == "II"
replace quarter = 3 if quarteryear3 == "III"
replace quarter = 4 if quarteryear3 == "IV"

drop quarteryear1 quarteryear3 quarteryear

destring year, replace

save ./out/data/temp/unemployment_Switzerland.dta, replace


**Prepare OECD data for Germany and France**

import excel ./src/original_data/destination_country/unemployment_OECD.xlsx, sheet("data") firstrow clear
rename LOCATION destination
rename Value unemployment
keep destination unemployment TIME
split TIME, parse(-) destring ignore( `"-"')
rename TIME1 year
rename TIME2 month
drop TIME

gen quarter = .
replace quarter = 1 if month < 4
replace quarter = 2 if month > 3 & month < 7
replace quarter = 3 if month > 6 & month < 10
replace quarter = 4 if month > 9 

replace destination="Germany" if destination=="DEU"
replace destination="France" if destination=="FRA"

keep if destination=="Germany" | destination=="France" 
drop if year < 2002 | year > 2016

collapse (mean) unemployment, by (destination year quarter)

save ./out/data/temp/unemployment_germany_france.dta, replace

* prepare data for other countries**

import delimited ./src/original_data/destination_country/quarterly_unemployment_EUROSTAT.csv, ///
 varnames(1) encoding(UTF-8) clear

rename geo destination
rename value unemployment

split time, parse("Q") destring 

rename time1 year
rename time2 quarter
 
drop if destination == "Germany (until 1990 former territory of the FRG)"
drop if destination == "France"

destring unemployment, replace

keep destination year quarter unemployment

drop if year < 2002

append using ./out/data/temp/unemployment_germany_france.dta

append using ./out/data/temp/unemployment_Switzerland.dta


save ./out/data/temp/destination_unemployment.dta, replace


**********************************
** Combine all destination data **
**********************************

use ./out/data/temp/destination_unemployment.dta, clear

merge 1:1 destination year quarter using ///
	./out/data/temp/destination_gdp.dta, nogen

merge 1:1 destination year quarter using ///
	./out/data/temp/election_data_quarterly.dta, nogen

merge m:1 destination year using ///
	./out/data/temp/past_applications.dta, nogen
	

* Note: no asylum Data from Eurostat for Switzerland before 2008
drop if destination == "Switzerland" & year < 2008

save ./out/data/temp/destination_data.dta, replace

