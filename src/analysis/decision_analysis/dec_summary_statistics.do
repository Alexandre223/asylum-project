************************************
*** Decisions summary statistics ***
************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

***********************
***********************
**Summmary Statistics**
***********************
***********************

drop if acceptance_rate==.

sutex2 	acceptance_rate refugeestatus_rate otherpositive_rate ///
		n_elections_max n_cabinet_changes_max cabinet_left_right ///
		PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/decisions/tables/dec_summary_statistics.tex) replace
