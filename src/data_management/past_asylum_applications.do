******************************************************************
***TOTAL LAG APPLICATIONS per 1000 inhabitants 5-year averages****
******************************************************************

clear 
set more off, permanently

* 1, prepare yearly application data on total applications and first time applications

* total applications 1995 - 2007
import delimited ./src/original_data/asylum_data/applications-total-95-07-y.csv, clear

rename time year
rename geo destination
rename value applications

keep year destination applications

destring applications, ignore(", :") replace

save ./out/data/temp/applications-total-95-07-y.dta, replace


* total applications 2008 - 2016
import delimited ./src/original_data/asylum_data/applications-total-08-16-y.csv, clear

rename time year
rename geo destination
rename value applications

keep year destination applications

destring applications, ignore(", :") replace

save ./out/data/temp/applications-total-08-16-y.dta, replace

* total first time applications 2008 - 2016
import delimited ./src/original_data/asylum_data/first-time-applications-total-08-16-y.csv, clear

rename time year
rename geo destination
rename value firsttimeapp

keep year destination firsttimeapp

destring firsttimeapp, ignore(", :") replace

save ./out/data/temp/first-time-applications-total-08-16-y.dta, replace


* 2, combine yearly application and firs time applications data from 1995 - 2016

use ./out/data/temp/applications-total-95-07-y.dta, clear

append using ./out/data/temp/applications-total-08-16-y.dta

merge 1:1 destination year using ///
	./out/data/temp/first-time-applications-total-08-16-y.dta, nogen

* Note:  for UK 2008 total applications missing but 
*		total first time applications availible - use as proxy
replace applications = firsttimeapp if applications == .

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

save ./out/data/temp/applications-total-95-16-y.dta, replace


* 3, add population size

import delimited ./src/original_data/destination_country/population_destination.csv, ///
				encoding(UTF-8)clear

rename time year
rename geo destination
rename value pop_size

drop age sex unit

destring pop_size, ignore(",") replace

replace destination="Germany" if destination=="Germany (until 1990 former territory of the FRG)"

merge 1:1 destination year using ./out/data/temp/applications-total-95-16-y.dta, nogen

* 4, calculate past average applications per 1000 inhabitants

gen applications_pc= (applications/pop_size)*1000

* Calculate 5-year averages
egen id = group (destination)
tsset id year

generate av_app_pc=(L1.applications_pc + L2.applications_pc+ L3.applications_pc + L4.applications_pc + L5.applications_pc)/5

* PROBLEM Norway 2007 missing -> Solution ignore 2007 value in calculations
replace av_app_pc=(L2.applications_pc+ L3.applications_pc + L4.applications_pc + L5.applications_pc)/4 if destination=="Norway" & year==2008
replace av_app_pc=(L1.applications_pc+ L3.applications_pc + L4.applications_pc + L5.applications_pc)/4 if destination=="Norway" & year==2009
replace av_app_pc=(L1.applications_pc+ L2.applications_pc + L4.applications_pc + L5.applications_pc)/4 if destination=="Norway" & year==2010
replace av_app_pc=(L1.applications_pc+ L2.applications_pc + L3.applications_pc + L5.applications_pc)/4 if destination=="Norway" & year==2011
replace av_app_pc=(L1.applications_pc+ L2.applications_pc + L3.applications_pc + L4.applications_pc)/4 if destination=="Norway" & year==2012

drop if year<2002

keep destination year av_app_pc

label variable av_app_pc "past 5 year avarage total asylum applications per 1000 inhabitants in destination countries"


save ./out/data/temp/past_applications.dta, replace


