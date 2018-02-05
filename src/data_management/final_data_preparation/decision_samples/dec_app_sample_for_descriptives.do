** Create Dataset for descriptives at destination level**
use ./out/data/final_decision/only_application_countries.dta, clear

collapse all_decisions_dest all_decisions_dest_pc ///
		allpositive allpositive_pc ///
		allrefugee allrefugee_pc ///
		alltemporary alltemporary_pc /// 
		n_elections_max n_cabinet_changes_max ///
		cabinet_left_right rGDPpc unemployment, by (destination year quarter)

save ./out/data/final_decision/only_app_descriptives_destination.dta, replace


** Create Dataset for descriptives at origin level**
use ./out/data/final_decision/only_application_countries.dta, clear

collapse PTS CL PR death_thousands_vdc realGDPpc, by (origin year quarter)

save ./out/data/final_decision/only_app_descriptives_origin.dta, replace


** Create Dataset for descriptives at bilateral level - time invariant**
use ./out/data/final_decision/only_application_countries.dta, clear

collapse kmdist imm_stock_2000, by (destination origin)

save ./out/data/final_decision/only_app_descriptives_bilateral.dta, replace
