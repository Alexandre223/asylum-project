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

save ./out/data/temp/destination_population_all.dta, replace

drop if year < 2002

label variable pop_destination "Destination country population"

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

drop if year < 2002

gen log_rGDPpc_dest = log(rGDPpc)

label variable log_rGDPpc_dest "Log destination country quarterly real GDP per capita"
label variable rGDPpc "Quarterly real GDP per capita at destination"

save ./out/data/temp/destination_gdp.dta, replace



***************************************************************************
** Unemployment rate as share of active population - seasonally adjusted **
***************************************************************************

**Note: unemployment rate for Switzerland not available on EUROSTAT 
**		not a problem because at the moment we don't use Switzerland as a destination country

import delimited ./src/original_data/destination_country/une_rt_q_1_Data.csv, ///
 varnames(1) encoding(UTF-8) clear

rename geo destination
rename value unemployment

split time, parse("Q") destring 

rename time1 year
rename time2 quarter
 
replace destination = "Germany" if destination == "Germany (until 1990 former territory of the FRG)"

destring unemployment, replace

keep destination year quarter unemployment

drop if year < 2002
drop if destination == "Croatia"

label variable unemployment "Quarterly unemployment rate at destination"

save ./out/data/temp/destination_unemployment.dta, replace


*************************************
** Hatton asylum policy index data **
*************************************

foreach i in total processing welfare access {
import excel .\src\original_data\destination_country\Hatton_policy_index.xlsx, sheet(`i') firstrow clear

reshape long policy_index_`i', i(destination) j(time) string
	split time, parse(_) destring ignore( `"_"')
	rename time1 year
	rename time2 quarter
	drop time

	drop if year < 2002

save ./out/data/temp/policy_index_`i'.dta, replace
}
*

use ./out/data/temp/policy_index_total.dta

merge 1:1 destination year quarter using ///
	./out/data/temp/policy_index_access.dta, nogen

merge 1:1 destination year quarter using ///
	./out/data/temp/policy_index_welfare.dta, nogen

merge 1:1 destination year quarter using ///
	./out/data/temp/policy_index_processing.dta, nogen	
	
label variable policy_index_total "Asylum policy index overall"
label variable policy_index_access "Policy on access"
label variable policy_index_welfare "Policy on welfare"
label variable policy_index_processing "Policy on processing"

	
save ./out/data/temp/hatton_index.dta, replace

	
**********************************
** Combine all destination data **
**********************************

use ./out/data/temp/destination_unemployment.dta, clear

merge 1:1 destination year quarter using ///
	./out/data/temp/destination_gdp.dta, nogen

merge 1:1 destination year quarter using ///
	./out/data/temp/election_data_quarterly.dta, nogen

merge 1:1 destination year quarter using ///
	./out/data/temp/hatton_index.dta, nogen

* No asylum data for Switzerland before 2008 *	
drop if destination == "Switzerland" & year <2008

save ./out/data/temp/destination_data.dta, replace

