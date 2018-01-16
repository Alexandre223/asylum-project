
** =============================== **
** Applications summary statistics **
** =============================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


drop if log_firsttimeapp_pc==.

sutex2 	firsttimeapp firsttimeapp_pc n_elections_max n_cabinet_changes_max ///
		cabinet_left_right  PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/final/paper/app_summary_statistics.tex) replace

		
** ============================ **
** Decisions summary statistics **
** ============================ **

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

sutex2 	totaldecisions totaldecisions_pc totalpositive totalpositive_pc ///
		refugeestatus refugeestatus_pc temporary_protection temporary_protection_pc ///
		n_elections_max n_cabinet_changes_max cabinet_left_right ///
		PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/final/paper/dec_summary_statistics.tex) replace
