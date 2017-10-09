*********************************************
** real GDP per capita in origin countries **
*********************************************
clear
set more off, permanently


** 1, Calculate Growth rates from IMF World Economic Outlook **
**Note Somalia, Kosovo missing**

* convert data to dta file
import excel .\src\original_data\origin_country\WEOAPr2017all.xlsx, ///
			sheet("WEOApr2017all") firstrow clear

rename Country origin
keep origin WEOSubjectCode AE - AT

save ./out/data/temp/world_economic_outlook.dta, replace

* extract data for different variables
foreach v in PPPPC NGDP_D {
	
	use ./out/data/temp/world_economic_outlook.dta, clear

	keep if WEOSubjectCode == "`v'"

	local i = 2000		
	foreach x of varlist AE - AT{
		local i = `i' +1
		rename `x' `v'`i'
	}
	*
	
	reshape long `v', i(origin) j(year)
	
	drop WEOSubjectCode
	destring `v', ignore ("n/a") replace
	
	save ./out/data/temp/weo_`v'.dta, replace
}
*

* Combine two datasets
use ./out/data/temp/weo_PPPPC.dta, clear 
merge 1:1  origin year using ./out/data/temp/weo_NGDP_D.dta, nogen

rename PPPPC GDPpcPPP
rename NGDP_D GDPdeflator

replace origin="Macedonia" if origin=="FYR Macedonia"
replace origin="Iran" if origin=="Islamic Republic of Iran"
replace origin="Gambia" if origin=="The Gambia"
replace origin="Congo" if origin=="Republic of Congo"
replace origin="Slovakia" if origin=="Slovak Republic"

replace origin="Former Serbia Montenegro" if origin=="Serbia" & year<2007	

merge m:1 origin using ./out/data/temp/list_of_origin_countries.dta
keep if _merge==3
drop if origin == "Kosovo"
drop _merge


***Compute growth rates of real per capita GDP in PPP***
**GDP deflator basis year 2010**
gen deflator_2010=.
replace deflator_2010=GDPdeflator if year==2010

egen GDP_deflator_2010=sum(deflator_2010), by (origin)
drop deflator_2010

gen GDPdeflator_base2010= GDPdeflator/GDP_deflator_2010
drop GDP_deflator_2010

*Compute real GDP per capita in PPP*
gen realGDPpcPPP=GDPpcPPP/GDPdeflator_base2010
sort origin year

*Calculate Growth rates*
bysort origin: gen IMF_rGDPpc_growth=(realGDPpcPPP[_n]-realGDPpcPPP[_n-1])/realGDPpcPPP[_n-1]

save ./out/data/temp/IMF_GDPpcPPP_growth.dta, replace


* 2, use Penn World Tables to get data on real GDP per capita in PPP

** Version 9.0 **
** Note Somalia, Eritrea, Afghanistan, Libya, Former Serbia + Montenegro, Kosovo missing

use .\src\original_data\origin_country\pwt90.dta, clear

drop if year<=2000

rename country origin

keep origin year rgdpe pop

replace origin="Democratic Republic of the Congo" if origin=="D.R. of the Congo"
replace origin="Iran" if origin=="Iran (Islamic Republic of)"
replace origin="Moldova" if origin=="Republic of Moldova"
replace origin="Russia" if origin=="Russian Federation"
replace origin="Sudan" if origin=="Sudan (Former)"
replace origin="Syria" if origin=="Syrian Arab Republic"
replace origin="Macedonia" if origin=="TFYR of Macedonia"
replace origin="Vietnam" if origin=="Viet Nam"

merge m:1 origin using ./out/data/temp/list_of_origin_countries.dta

keep if _merge==3 | origin=="Montenegro"
drop _merge

save ./out/data/temp/PWT9_01_14_temp.dta, replace

* Use Serbia and Montenegro before 2007 to calculate real GDP and population
* for Former Serbia Montenegro
 
keep if origin=="Serbia" | origin=="Montenegro" 

replace origin = "Former Serbia Montenegro" if origin=="Serbia"
replace origin = "Former Serbia Montenegro" if origin=="Montenegro"

collapse (sum) rgdpe pop, by (origin year)
replace rgdpe=. if year>=2007
replace pop=. if year>=2007

append using ./out/data/temp/PWT9_01_14_temp.dta

drop if origin=="Montenegro"

* Generate real GDP per capita in PPP
	* Note pop = population in millions**
	* and also GDP is expressed in million 2011 US $**
gen rGDPpcPPP=rgdpe/pop

save ./out/data/temp/PWT9_01_14.dta, replace 



** Version 7.1 **
** Note: use to get data for Somalia, Eritrea, Libya and Afghanistan

import delimited ./src/original_data/origin_country/pwt71.csv, encoding(UTF-8) clear	

keep if isocode == "AFG" | isocode == "ERI" | isocode == "SOM" | isocode == "LBY"

rename isocode origin
replace origin = "Afghanistan" if origin == "AFG"
replace origin = "Eritrea" if origin == "ERI"
replace origin = "Somalia" if origin == "SOM"
replace origin = "Libya" if origin == "LBY"

drop if year<=2000

rename rgdpch rGDPpcPPP
destring rGDPpcPPP, replace

replace pop = pop/1000

keep origin year pop rGDPpcPPP

save ./out/data/temp/PWT71_01_10.dta, replace


* 3, use World Bank data to get rGDPpcPPP data for Kosovo**
import delimited ./src/original_data/origin_country/world_bank_data.csv, clear

rename ïcountryname origin
rename time year

drop if year<=2000

keep if origin=="Kosovo" & seriesname=="GDP per capita, PPP (constant 2011 international $)"

drop countrycode seriescode timecode seriesname

rename value rGDPpcPPP

save ./out/data/temp/WB_rGDPpcPPP_Kosovo.dta, replace


* 4, Combine real GDP per capita in PPP data

use ./out/data/temp/PWT9_01_14.dta, clear
append using ./out/data/temp/PWT71_01_10.dta
append using ./out/data/temp/WB_rGDPpcPPP_Kosovo.dta

* Merge with IMF data**
merge 1:1 origin year using ./out/data/temp/IMF_GDPpcPPP_growth.dta
drop _merge


* 5, Replace missings for more recent years with growths rates from IMF data**

sort origin year
gen PW_IMF_rGDPpc =rGDPpcPPP
replace PW_IMF_rGDPpc = PW_IMF_rGDPpc[_n-1]*(1+IMF_rGDPpc_growth) if missing(PW_IMF_rGDPpc)

keep origin year PW_IMF_rGDPpc
rename PW_IMF_rGDPpc realGDPpc
label variable realGDPpc "Expenditure-side real GDP at chained PPPs (in mil. 2011US$)"

drop if origin=="Kosovo" & year<=2008
drop if origin=="Former Serbia Montenegro" & year>=2007
drop if origin=="Serbia" & year<=2006

save ./out/data/temp/origin_rGDP_pc.dta, replace

* Note: no data for Somalia after 2010
*		no data for Kosovo 2016
*		no data for Syria 2015 and 2016
