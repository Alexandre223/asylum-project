*********************************************
** real GDP per capita in origin countries **
*********************************************
clear
set more off, permanently


* 1, use Penn World Tables to get data on real GDP per capita in PPP

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

keep origin year rGDPpcPPP

save ./out/data/temp/PWT9_01_14.dta, replace 



** Version 7.1 **
** Note: use to get data for Somalia

import delimited ./src/original_data/origin_country/pwt71.csv, encoding(UTF-8) clear	

keep if  isocode == "SOM" 

rename isocode origin
replace origin = "Somalia" if origin == "SOM"

drop if year<=2000

rename rgdpch rGDPpcPPP
destring rGDPpcPPP, replace


keep origin year rGDPpcPPP

save ./out/data/temp/PWT71_01_10_Somalia.dta, replace


* 2, use IMF World Economic Outlook data to get rGDPpcPPP data for 
*    Eritrea, Afghanistan, Libya and Kosovo **
import excel .\src\original_data\origin_country\imf_weo.xlsx, sheet(weoreptc.aspx) firstrow clear

rename Country origin
		
local i = 2000		
foreach x of varlist B - O{
	local i = `i' +1
	rename `x' rGDPpcPPP`i'
}
*

reshape long rGDPpcPPP, i(origin) j(year)
destring rGDPpcPPP, replace ignore(",")

save ./out/data/temp/imf_weo.dta, replace


* 2, Combine data

use ./out/data/temp/PWT9_01_14.dta, clear
append using ./out/data/temp/PWT71_01_10_Somalia.dta
append using ./out/data/temp/imf_weo.dta


rename rGDPpcPPP realGDPpc
label variable realGDPpc "Expenditure-side real GDP at chained PPPs (in mil. 2011US$)"

drop if origin=="Kosovo" & year<=2008
drop if origin=="Former Serbia Montenegro" & year>=2007
drop if origin=="Serbia" & year<=2006


save ./out/data/temp/origin_rGDP_pc.dta, replace



