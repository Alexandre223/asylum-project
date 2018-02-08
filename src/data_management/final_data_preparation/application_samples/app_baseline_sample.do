
*							BASELINE SAMPLE                           *
* =================================================================== *
* SAMPLE: all big countries that have a maximum of two missing years  *
*		  in first-time application data                              *
*		  exclude Cyprus because of several irregular cabinet changes *
* YEARS: 2002 - 2014                                                  *
* CABINET POSITION: left, right, split at median                      *
* QUARTERS: 6 quarters around the election                            *
* =================================================================== *

clear
set more off, permanently

use ./out/data/temp/combined_data_for_final_adjustments.dta, clear


* 1, destination and origin countries

* Use only big countries that have a maximum of two missing years
* Determine countries that have data in at least 44 out of 52 quarters**
bysort origin destination: egen non_missing = count(firsttimeapp_NI)
bysort destination: egen max_non_missing = max(non_missing) 
tab destination if max_non_missing >= 44
keep if max_non_missing >= 44

* Determine big destination countries
bysort destination: egen total_FTapp = total(firsttimeapp)
tab destination total_FTapp
drop if total_FTapp < 30000

* exclude Cyprus because of irregular cabinet changes
drop if destination == "Cyprus"

tab destination
	
* Match with top 90% origin countries
merge m:1 origin using ./out/data/temp/source_countries_app_baseline.dta
keep if _merge == 3
drop _merge

		
* 2, Calculate mean dyadic first-time applications per quarter
do ./src/data_management/final_data_preparation/modules/calc_mean_dyadic_ft_applications.do

* 3, Create two dummies for cabinet position  split at the median
do ./src/data_management/final_data_preparation/modules/cabinet_position_median.do

* 4, Create before after dummies and all interaction terms 
*    for 6 quarters around the election
global q = 6
do ./src/data_management/final_data_preparation/modules/dummies_and_interactions.do

* 5, Generate indicator variables
do ./src/data_management/final_data_preparation/modules/indicator_variables.do

* 6, Calculate number of elections and cabinet positions
do ./src/data_management/final_data_preparation/modules/number_elections_and_cabinet_changes.do


keep destination origin year quarter ///
	 firsttimeapp firsttimeapp_pc firsttimeapp_total_pc  ///
	 log_firsttimeapp_pc log_firsttimeapp_NI_pc log_firsttimeapp_pc_origin ///
	 log_firsttimeapp_dyadic_mean6_pc log_firsttimeapp_total_mean6_pc  ///
	 log_av_app5_pc mean_dyadic_FTapp_per_quarter ///
	 cabinet_left_right cabinet_left cabinet_right ///
	 n_elections_max n_cabinet_changes_max ///
	 election  post1 post2 post3 post4 post5 post6 ///
	 bef1 bef2 bef3 bef4 bef5 bef6  bef_dummy post_dummy ///	 
	 left_bef left_post right_bef right_post ///
	 bef1_left bef2_left bef3_left bef4_left bef5_left bef6_left elec_left ///
	 post1_left post2_left post3_left post4_left post5_left post6_left ///
	 bef1_right bef2_right bef3_right bef4_right bef5_right bef6_right elec_right ///
	 post1_right post2_right post3_right post4_right post5_right post6_right ///
	 PTS PR CL realGDPpc log_rGDPpc_orig death_thousands_ucdp death_thousands_vdc ///
	 PTS_average PR_average CL_average realGDPpc_average log_rGDPpc_orig_average ///
	 death_thousands_ucdp_average  death_thousands_vdc_average ///
	 unemployment rGDPpc log_rGDPpc_dest ///
	 policy_index_total policy_index_access ///
	 policy_index_welfare policy_index_processing ///	 
	 imm_stock_2000 log_imm_stock_2000 kmdist log_kmdist  ///
	 T D O DO OT post_2007 

save ./out/data/final_application/baseline_data.dta, replace

