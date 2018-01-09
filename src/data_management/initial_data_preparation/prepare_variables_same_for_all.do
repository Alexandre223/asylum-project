******************************
** Prepare asylum variables **
******************************

clear
set more off, permanently


use ./out/data/temp/combined_data.dta, clear


* 1, Calculate log yearly total and dyadic decisions per capita in destination 
* 		use mean of current quarter and past 3 quarters

* DAYADIC DECISIONS
sort destination origin year quarter

* generate lags of dyadic decisions
by destination origin: gen lag1_totaldecisions = totaldecisions[_n-1]
by destination origin: gen lag2_totaldecisions = totaldecisions[_n-2]
by destination origin: gen lag3_totaldecisions = totaldecisions[_n-3]

* generate sum of decisions in the past year (includuing current quarter)
egen yearly_dyadic_decisions_mean = ///
		rowmean(totaldecisions lag1_totaldecisions ///
				lag2_totaldecisions lag3_totaldecisions)

* calculate average per capita
gen yearly_dyadic_decisions_pc = (yearly_dyadic_decisions_mean / pop_destination)*100000
label variable yearly_dyadic_decisions_pc "Average dyadic quarterly decisions per 100,000 inhabitants in the previous year"
								
**gen log per capita*
gen yearly_dyadic_decisions_pc_plus1 = (yearly_dyadic_decisions_mean / pop_destination) + 1
gen log_dyadic_decisions_pc = log(yearly_dyadic_decisions_pc_plus1)


* TOTAL DECISIONS AT DESTINATION

* genrate total quarterly decisions in destination + lags** 
bysort destination year quarter: egen sum_dest_decisions = total(totaldecisions)

sort origin destination year quarter

by origin destination: gen lag1_sum_dest_decisions = sum_dest_decisions[_n-1]
by origin destination: gen lag2_sum_dest_decisions = sum_dest_decisions[_n-2]
by origin destination: gen lag3_sum_dest_decisions = sum_dest_decisions[_n-3]

* generate sum of decisions in the past year (includuing current quarter)
egen yearly_dest_decisions_mean = ///
		rowmean(sum_dest_decisions lag1_sum_dest_decisions  ///
				lag2_sum_dest_decisions lag3_sum_dest_decisions)

* calculate average per capita
gen yearly_dest_decisions_pc = (yearly_dest_decisions_mean / pop_destination)*100000
label variable yearly_dest_decisions_pc "Average total quarterly decisions per 100,000 inhabitants in the previous year"

* generate logs 
gen yearly_dest_decisions_pc_plus1 = (yearly_dest_decisions_mean / pop_destination) + 1
gen log_dest_decisions_pc = log(yearly_dest_decisions_pc_plus1)



* 2, Calculate log yearly total and dyadic decisions per capita in destination
*                     with non-imputed total decisions  

* DAYADIC DECISIONS
sort destination origin year quarter

* generate lags of dyadic decisions
by destination origin: gen lag1_totaldecisions_NI = totaldecisions_NI[_n-1]
by destination origin: gen lag2_totaldecisions_NI = totaldecisions_NI[_n-2]
by destination origin: gen lag3_totaldecisions_NI = totaldecisions_NI[_n-3]

* generate sum of decisions in the past year (includuing current quarter)
egen yearly_dyadic_decisions_mean_NI = ///
	rowmean(totaldecisions_NI lag1_totaldecisions_NI ///
			lag2_totaldecisions_NI lag3_totaldecisions_NI)

			
* calculate average per capita
gen yearly_dyadic_decisions_pc_NI = (yearly_dyadic_decisions_mean_NI / pop_destination)*100000
label variable yearly_dyadic_decisions_pc_NI "Average dyadic quarterly decisions per 100,000 inhabitants in the previous year"
								
**gen log per capita*
gen yearly_dyadic_dec_pc_plus1NI = (yearly_dyadic_decisions_mean_NI / pop_destination) + 1
gen log_dyadic_decisions_pc_NI = log(yearly_dyadic_dec_pc_plus1NI)
			

			
* TOTAL DECISIONS AT DESTINATION

**generate total quarterly decisions in destination + lags** 
bysort destination year quarter: egen sum_dest_decisions_NI = total(totaldecisions_NI)

sort origin destination year quarter

by origin destination: gen lag1_sum_dest_decisions_NI = sum_dest_decisions_NI[_n-1]
by origin destination: gen lag2_sum_dest_decisions_NI = sum_dest_decisions_NI[_n-2]
by origin destination: gen lag3_sum_dest_decisions_NI = sum_dest_decisions_NI[_n-3]

**generate sum of decisions in the past year (includuing current quarter)**
egen yearly_dest_decisions_mean_NI = ///
		rowmean(sum_dest_decisions_NI lag1_sum_dest_decisions_NI ///
				lag2_sum_dest_decisions_NI lag3_sum_dest_decisions_NI)
				
* calculate average per capita
gen yearly_dest_decisions_pc_NI = (yearly_dest_decisions_mean_NI / pop_destination)*100000
label variable yearly_dest_decisions_pc_NI "Average total quarterly decisions per 100,000 inhabitants in the previous year"

* generate logs 
gen yearly_dest_dec_pc_plus1NI = (yearly_dest_decisions_mean_NI / pop_destination) + 1
gen log_dest_decisions_pc_NI = log(yearly_dest_dec_pc_plus1NI)


* 3, generate log variables
gen temporary_protection = totalpositive - refugeestatus

foreach v in firsttimeapp applications firsttimeapp_NI totalpositive ///
			 totaldecisions refugeestatus temporary_protection {
	gen `v'_plus1 = `v' + 1
	gen log_`v'_pc = log(`v'_plus1 / pop_destination)
}
*	
gen log_firsttimeapp_pc_origin = log(firsttimeapp_plus1 / pop_origin)

gen imm_stock_2000_plus1 = imm_stock_2000 + 1
gen log_imm_stock_2000 = log(imm_stock_2000_plus1)

gen log_kmdist=log(kmdist)

gen log_av_app_pc=log(av_app_pc)

gen log_rGDPpc_dest = log(rGDPpc)


* 4, generate rescaled variables and post 2007 dummy

gen firsttimeapp_pc =(firsttimeapp / pop_destination) * 100000
gen firsttimeapp_pc_origin = (firsttimeapp / pop_origin) * 100000
gen applications_pc = (applications / pop_destination) * 100000

gen death_thousands_ucdp = battle_death_ucdp / 1000
gen death_thousands_vdc = battle_death_vdc / 1000

gen death_thousands_ucdp_average = battle_death_ucdp_average / 1000
gen death_thousands_vdc_average = battle_death_vdc_average / 1000

gen post_2007 = 0
replace post_2007 = 1 if year > 2007


* 5, lable variables

label variable log_dest_decisions_pc "Log average past total asylum decisions per capita"
label variable log_dyadic_decisions_pc "Log average past dyadic asylum decisions per capita"

label variable log_dest_decisions_pc_NI "Log average past total asylum decisions per capita"
label variable log_dyadic_decisions_pc_NI "Log average past dyadic asylum decisions per capita"

label variable acceptance_rate "Acceptance rate"
label variable otherpositive_rate "Temporary protection"
label variable refugeestatus_rate "Refugee status rate"

label variable acceptance_rate_NI "Acceptance rate"
label variable otherpositive_rate_NI "Temporary protection"
label variable refugeestatus_rate_NI "Refugee status rate"

label variable firsttimeapp "Quarterly fist-time asylum applications"
label variable firsttimeapp_pc "Quarterly first-time asylum applications per 100,000 inhabitants"

label variable pop_destination "Destination country population"

label variable unemployment "Quarterly unemployment rate at destination"

label variable post_2007 "after 2007"

foreach var of varlist 	death_thousands_ucdp ///
						death_thousands_vdc ///
						death_thousands_ucdp_average ///
						death_thousands_vdc_average {

	label variable `var' "Quarterly civil war battle death (000s)"
}
*

label variable log_kmdist "Log distance from origin to destination"
label variable kmdist "Distance from origin to destination"

label variable log_imm_stock_2000 "Log migrant stock in 2000/1"
label variable imm_stock_2000 "Migrant stock in 2000/1"

label variable log_rGDPpc_orig "Log origin country real GDP per capita"
label variable log_rGDPpc_orig_average "Log origin country real GDP per capita"
label variable realGDPpc "Yearly real GDP per capita at origin"

label variable log_rGDPpc_dest "Log destination country real GDP per capita"
label variable rGDPpc "Quarterly real GDP per capita at destination"

label variable log_av_app_pc "Log average past asylum applications at destination per capita"

label variable PR "Political Rights (FHI)"
label variable PR_average "Political Rights (FHI)"

label variable CL "Civic Liberty (FHI)"
label variable CL_average "Civic Liberty (FHI)"

label variable PTS "Political Terror Scale"
label variable PTS_average "Political Terror Scale"

label variable pop_origin "Origin country population"

label variable Africa "Other African countries"
label variable MENA "Middle East and North Africa"
label variable ECA "Europe and Central Asia"
label variable SEA "South and East Asia"

local t=1
while `t'<=6 {
label variable bef`t' " `t' quarters before the election"
 local t=`t'+1
 }
*
local t=1
while `t'<=6 {
label variable post`t' " `t' quarters after the election"
 local t=`t'+1
 }
*


* 6, drop origin countries that are not in the top 90% of any sample used at the moment

drop if origin=="Bulgaria" | origin=="Liberia" | ///
		origin=="Senegal" | origin=="Tunisia"


save ./out/data/temp/combined_data_for_final_adjustments.dta, replace
