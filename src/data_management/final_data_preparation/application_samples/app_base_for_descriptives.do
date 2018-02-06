** Create Dataset for descriptives at destination quarter level**
use ./out/data/final_application/baseline_data.dta, clear

collapse firsttimeapp_total firsttimeapp_total_pc  ///
		cabinet_left_right rGDPpc unemployment, by (destination year quarter)

label variable firsttimeapp_total "Quarterly first-time applications at destination"
label variable firsttimeapp_total_pc "Quarterly first-time applications at destination per 100,000 inhabitants"

label variable cabinet_left_right "Average left-right position of the cabinet"
label variable rGDPpc "Quarterly destination real GDP per capita"
label variable unemployment "Quarterly unemployment rate at destination"		
		
save ./out/data/final_application/base_descriptives_DQ.dta, replace

** Create Dataset for descriptives at destination level**
use ./out/data/final_application/baseline_data.dta, clear

collapse n_elections_max n_cabinet_changes_max, by (destination)

label variable n_elections_max "Number of elections per destination"
label variable n_cabinet_changes_max "Number of cabinet changes per destination"
		
save ./out/data/final_application/base_descriptives_D.dta, replace



** Create Dataset for descriptives at origin quarter level**
use ./out/data/final_application/baseline_data.dta, clear

collapse death_thousands_vdc, by (origin year quarter)

label variable death_thousands_vdc "Quarterly civil war battle death (000s)"

save ./out/data/final_application/base_descriptives_OQ.dta, replace

** Create Dataset for descriptives at origin year level**
use ./out/data/final_application/baseline_data.dta, clear

collapse PTS CL PR realGDPpc, by (origin year)

label variable PTS "Political terror scale"
label variable CL "Civic liberty (FHI)"
label variable PR "Political rights (FHI)"
label variable realGDPpc "Yearly origin country real GDP per capita"

save ./out/data/final_application/base_descriptives_OY.dta, replace



** Create Dataset for descriptives at bilateral level - time invariant**
use ./out/data/final_application/baseline_data.dta, clear

* use only the country pairs that we actually use in the analysis
drop if mean_dyadic_FTapp_per_quarter < 2

collapse kmdist imm_stock_2000, by (destination origin)

label variable kmdist "Distance from origin to destination"
label variable imm_stock_2000 "Migrant stock in 2000/1"

save ./out/data/final_application/base_descriptives_DO.dta, replace
