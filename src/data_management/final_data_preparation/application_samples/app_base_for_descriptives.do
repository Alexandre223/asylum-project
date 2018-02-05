** Create Dataset for descriptives at destination level**
use ./out/data/final_application/baseline_data.dta, clear

collapse firsttimeapp_total n_elections_max n_cabinet_changes_max ///
		cabinet_left_right rGDPpc unemployment, by (destination year quarter)

save ./out/data/final_application/base_descriptives_destination.dta, replace


** Create Dataset for descriptives at origin level**
use ./out/data/final_application/baseline_data.dta, clear

collapse PTS CL PR death_thousands_vdc realGDPpc, by (origin year quarter)

save ./out/data/final_application/base_descriptives_origin.dta, replace


** Create Dataset for descriptives at bilateral level - time invariant**
use ./out/data/final_application/baseline_data.dta, clear

collapse kmdist imm_stock_2000, by (destination origin)

save ./out/data/final_application/base_descriptives_bilateral.dta, replace
