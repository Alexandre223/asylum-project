* =============================== *
* Create datasets for replication *
* =============================== *

** Note these datasets can only be used to replicate the regression results in the paper, not those in the online appendix


** Data for application analysis **

use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

keep destination origin year quarter ///
	 log_firsttimeapp_pc  ///
	 log_av_app5_pc  ///
	 cabinet_right ///
	 left_bef left_post right_bef right_post ///
	 bef1_left bef2_left bef3_left bef4_left bef5_left bef6_left elec_left ///
	 post1_left post2_left post3_left post4_left post5_left post6_left ///
	 bef1_right bef2_right bef3_right bef4_right bef5_right bef6_right elec_right ///
	 post1_right post2_right post3_right post4_right post5_right post6_right ///
	 PTS_average PR_average CL_average realGDPpc_average log_rGDPpc_orig_average ///
	 death_thousands_vdc_average ///
	 unemployment log_rGDPpc_dest ///
	 policy_index_total policy_index_access ///
	 policy_index_welfare policy_index_processing ///	 
	 log_imm_stock_2000 log_kmdist  ///
	 T D O DO OT

save ./src/analysis/for_replication/application_data.dta, replace


** Data for decision analysis **
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

keep destination origin year quarter ///
	 acceptance_rate refugeestatus_rate temporary_protection_rate  ///
	 left_bef left_post right_bef right_post ///
	 bef1_left bef2_left bef3_left bef4_left bef5_left bef6_left elec_left ///
	 post1_left post2_left post3_left post4_left post5_left post6_left ///
	 bef1_right bef2_right bef3_right bef4_right bef5_right bef6_right elec_right ///
	 post1_right post2_right post3_right post4_right post5_right post6_right ///
	 PTS_average PR_average CL_average realGDPpc_average log_rGDPpc_orig_average ///
	 death_thousands_vdc_average ///
	 unemployment log_rGDPpc_dest /// 
	 T D O DO OT

save ./src/analysis/for_replication/decision_data.dta, replace
