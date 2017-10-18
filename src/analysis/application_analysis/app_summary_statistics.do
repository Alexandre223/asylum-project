***************************************
*** Applications summary statistics ***
***************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

***********************
***********************
**Summmary Statistics**
***********************
***********************

drop if log_firsttimeapp_pc==.

sutex2 	firsttimeapp firsttimeapp_pc cabinet_left_right PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(1) ///
		saving(./out/analysis/applications/tables/app_summary_statistics.tex) replace
