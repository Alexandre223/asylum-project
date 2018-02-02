********************************************************************
** Prepare and lable variables that are independent of the sample **
********************************************************************

clear
set more off, permanently


use ./out/data/temp/combined_data.dta, clear


* 1, GENERATE LOG PC VARIABLES 

foreach v in ///
	firsttimeapp applications firsttimeapp_NI ///
	totalpositive totaldecisions refugeestatus temporary_protection ///
	applications_total av_app1 av_app2 av_app3 av_app4 av_app5  ///
	lag1_firsttimeapp_total firsttimeapp_total_mean6 firsttimeapp_total_sum2 ///
	lag1_firsttimeapp firsttimeapp_dyadic_mean6 firsttimeapp_dyadic_sum2 ///
	all_decisions_dest lag1_all_decisions_dest yearly_all_decisions_dest ///
	lag1_totaldecisions yearly_dyadic_decisions {
			 
		gen log_`v'_pc = log((`v' + 1) / pop_destination)
}
*		

label variable log_applications_total_pc ///
		"Log total asylum applications per capita in current year"
label variable log_av_app1_pc ///
		"Log total asylum applications per capita in previous year"

local t=2
while `t'<=5 {
label variable log_av_app`t'_pc ///
		"Log total average asylum applications per capita in previous `t' years"
 local t=`t'+1
 }
*

label variable log_lag1_firsttimeapp_total_pc ///
		"Log quarterly total first-time applications per capita in previous quarter"
label variable log_firsttimeapp_total_mean6_pc ///
		"Log average total first-time applications in the previous 6 quarters"
label variable log_firsttimeapp_total_sum2_pc ///
		"Log total first-time applications in the previous 2 quarters"	

label variable log_lag1_firsttimeapp_pc ///
		"Log quarterly dyadic first-time applications per capita in previous quarter"
label variable log_firsttimeapp_dyadic_mean6_pc ///
		"Log average dyadic first-time applications in the previous 6 quarters"
label variable log_firsttimeapp_dyadic_sum2_pc ///
		"Log dyadic first-time applications in the previous 2 quarters"

label variable log_all_decisions_dest_pc ///
		"Log total decisions at destination per capita"
label variable log_lag1_all_decisions_dest_pc ///
		"Log total decisions at destination per capita in previous quarter"
label variable log_yearly_all_decisions_dest_pc ///
		"Log total decisions per capita in previous year"

label variable log_lag1_totaldecisions_pc ///
		"Log dyadic decisions at destination per capita in previous quarter"
label variable log_yearly_dyadic_decisions_pc ///
		"Log dyadic decisions at destination per capita in previous year"


gen log_firsttimeapp_pc_origin = log((firsttimeapp +1) / pop_origin)


* 2, GENERATE RESCALED VARIABLES AND POST 2007 DUMMY

gen firsttimeapp_pc =(firsttimeapp / pop_destination) * 100000
label variable firsttimeapp "Dyadic quarterly fist-time asylum applications"
label variable firsttimeapp_pc "Dyadic quarterly first-time asylum applications per 100,000 inhabitants"

gen firsttimeapp_total_pc =(firsttimeapp_total / pop_destination) * 100000
label variable firsttimeapp_total "Total quarterly fist-time asylum applications"
label variable firsttimeapp_total_pc "Total quarterly first-time asylum applications per 100,000 inhabitants"

gen totaldecisions_pc = (totaldecisions / pop_destination) * 100000
label variable totaldecisions "Dyadic quarterly fist-instance asylum decisions"
label variable totaldecisions_pc "Dyadic quarterly fist-instance asylum decisions per 100,000 inhabitants"

gen all_decisions_dest_pc = (all_decisions_dest / pop_destination) * 100000
label variable all_decisions_dest "Total quarterly fist-instance asylum decisions"
label variable all_decisions_dest_pc "Total quarterly fist-instance asylum decisions per 100,000 inhabitants"

gen totalpositive_pc = (totalpositive / pop_destination) * 100000
label variable totalpositive "Dyadic quarterly positive fist-instance asylum decisions"
label variable totalpositive_pc "Dyadic quarterly positive fist-instance asylum decisions per 100,000 inhabitants"

gen refugeestatus_pc = (refugeestatus / pop_destination) * 100000
label variable refugeestatus "Dyadic quarterly fist-instance asylum decisions for refugee status"
label variable refugeestatus_pc "Dyadic quarterly fist-instance asylum decisions for refugee status per 100,000 inhabitants"

gen temporary_protection_pc = (temporary_protection / pop_destination) * 100000
label variable temporary_protection "Dyadic quarterly fist-instance asylum decisions for temporary protection"
label variable temporary_protection_pc "Dyadic quarterly fist-instance asylum decisions for temporary protection per 100,000 inhabitants"


gen post_2007 = 0
replace post_2007 = 1 if year > 2007

label variable post_2007 "Years after 2007"


* 3, drop origin countries that are not in the top 90% of any sample used at the moment

drop if origin=="Bulgaria" | origin=="Liberia" | ///
		origin=="Senegal" | origin=="Tunisia"


save ./out/data/temp/combined_data_for_final_adjustments.dta, replace
