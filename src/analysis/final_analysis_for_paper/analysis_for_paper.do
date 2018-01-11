* ======================== *
* FINAL ANALYSIS FOR PAPER *
* ======================== *
clear 
set more off, permanently
cd F:/research/asylum-project

**************************
** APPLICATION ANALYSIS **
**************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do


* Table 1: Baseline plus main robustness checks *

eststo clear

xtset O
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset OT
eststo: quietly xtreg 	$dependent_variable ///
						$bilateral_variables $destination_variables ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables policy_index_total ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						policy_index_access policy_index_processing ///
						policy_index_welfare  ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"
 
esttab using "./src/results/final/paper/app_table1_paper.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_av_app_pc cabinet_right ///
	 policy_index_total policy_index_access policy_index_processing ///
	 policy_index_welfare $bilateral_variables $interactions_left_m1 ///
	 $interactions_right_m1) ///
order($origin_variables $bilateral_variables $destination_variables log_av_app_pc cabinet_right ///
	  policy_index_total policy_index_access policy_index_processing ///
	  policy_index_welfare  $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


** Graph 1 bef - after for main specification **

eststo clear

xtset DO 

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(before: _b[left_bef]) ///
		(after: _b[left_post]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(before:  _b[right_bef] ) ///
		(after: _b[right_post] ) ///
		,post
est sto right

esttab  left  right using "./src/results/final/paper/app_graph1_baseline_coef.tex", ///
replace se label mtitle nodepvars  ///
keep($time_m1) title($coef_tab_title)

coefplot 	(left, keep($time_m1) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m1) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))   ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lcolor(black)) ///
			graphregion(color(white)) ///
			legend (rows(1)) ///
			xscale(range(1 (1) 2)) ///
			xlabel(1 "before the election"  2 "after the election") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
						
graph export "./src/results/final/paper/app_graph1_baseline.pdf", replace



** Graph 2 - 6 quarters before and after for main specification **


eststo clear
xtset $xt_main 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right] ) ///
		(bef5: _b[bef5_right] ) ///
		(bef4: _b[bef4_right] ) ///
		(bef3: _b[bef3_right] ) ///
		(bef2: _b[bef2_right] ) ///
		(bef1: _b[bef1_right] ) ///
		(election: _b[elec_right] ) ///
		(post1: _b[post1_right] ) ///
		(post2: _b[post2_right] ) ///
		(post3: _b[post3_right] ) ///
		(post4: _b[post4_right] ) ///
		(post5: _b[post5_right] ) ///
		(post6: _b[post6_right] ) ///
		,post
est sto right

esttab left right using "./src/results/final/paper/app_graph2_baseline_coef.tex", ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title($coef_tab_title)

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lcolor(black)) ///
			graphregion(color(white)) ///
			legend (rows(1)) ///
			xscale(range(1 (1) 13)) ///
			xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3"  5 "-2" 6 "-1" 7 "0" ///
				   8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///
						
graph export "./src/results/final/paper/app_graph2_baseline.pdf", replace


***********************
** DECISION ANALYSIS **
***********************

* Table 1 - baseline results for log decisions per capita *

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

global y_scale (-0.3 -0.2 -0.1 0 0.1  0.2)

global 	destination_variables log_rGDPpc_dest unemployment ///
		cabinet_right

eststo clear		
foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

}
*
 
esttab using "./src/results/final/paper/dec_table1_paper.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables ///
	  $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of asylum decisions per capita")


* Decision graphs *

* total positive decisions
eststo clear
xtset DO 
eststo: quietly xtreg 	log_totalpositive_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
local r = _b[cabinet_right]

nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	log_totalpositive_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right] + _b[cabinet_right]) ///
		(bef5: _b[bef5_right] + _b[cabinet_right]) ///
		(bef4: _b[bef4_right] + _b[cabinet_right]) ///
		(bef3: _b[bef3_right] + _b[cabinet_right]) ///
		(bef2: _b[bef2_right] + _b[cabinet_right]) ///
		(bef1: _b[bef1_right] + _b[cabinet_right]) ///
		(election: _b[elec_right] + _b[cabinet_right]) ///
		(post1: _b[post1_right] + _b[cabinet_right]) ///
		(post2: _b[post2_right] + _b[cabinet_right]) ///
		(post3: _b[post3_right] + _b[cabinet_right]) ///
		(post4: _b[post4_right] + _b[cabinet_right]) ///
		(post5: _b[post5_right] + _b[cabinet_right]) ///
		(post6: _b[post6_right] + _b[cabinet_right]) ///
		,post
est sto right

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lpattern(dash) lcolor(maroon) lwidth(vthin)) ///
			yline(`r', lpattern(dash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(small)) ///
			xscale(range(1 (1) 13)) ///
			xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3"  5 "-2" 6 "-1" 7 "0" ///
				   8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///
			title(total positive decisons)
			
graph save ./out/analysis/temp/dec_graph2_pos.gph, replace			

* refugee status *
eststo clear
xtset DO 
eststo: quietly xtreg 	log_refugeestatus_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
local r = _b[cabinet_right]

nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	log_refugeestatus_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right] + _b[cabinet_right]) ///
		(bef5: _b[bef5_right] + _b[cabinet_right]) ///
		(bef4: _b[bef4_right] + _b[cabinet_right]) ///
		(bef3: _b[bef3_right] + _b[cabinet_right]) ///
		(bef2: _b[bef2_right] + _b[cabinet_right]) ///
		(bef1: _b[bef1_right] + _b[cabinet_right]) ///
		(election: _b[elec_right] + _b[cabinet_right]) ///
		(post1: _b[post1_right] + _b[cabinet_right]) ///
		(post2: _b[post2_right] + _b[cabinet_right]) ///
		(post3: _b[post3_right] + _b[cabinet_right]) ///
		(post4: _b[post4_right] + _b[cabinet_right]) ///
		(post5: _b[post5_right] + _b[cabinet_right]) ///
		(post6: _b[post6_right] + _b[cabinet_right]) ///
		,post
est sto right

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lpattern(dash) lcolor(maroon) lwidth(vthin)) ///
			yline(`r', lpattern(dash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(small)) ///
			xscale(range(1 (1) 13)) ///
			xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3"  5 "-2" 6 "-1" 7 "0" ///
				   8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///
			title(refugee status decisons)
			
graph save ./out/analysis/temp/dec_graph2_ref.gph, replace	

* Temporary protection *
eststo clear
xtset DO 
eststo: quietly xtreg 	log_temporary_protection_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
local r = _b[cabinet_right]

nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	log_temporary_protection_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right] + _b[cabinet_right]) ///
		(bef5: _b[bef5_right] + _b[cabinet_right]) ///
		(bef4: _b[bef4_right] + _b[cabinet_right]) ///
		(bef3: _b[bef3_right] + _b[cabinet_right]) ///
		(bef2: _b[bef2_right] + _b[cabinet_right]) ///
		(bef1: _b[bef1_right] + _b[cabinet_right]) ///
		(election: _b[elec_right] + _b[cabinet_right]) ///
		(post1: _b[post1_right] + _b[cabinet_right]) ///
		(post2: _b[post2_right] + _b[cabinet_right]) ///
		(post3: _b[post3_right] + _b[cabinet_right]) ///
		(post4: _b[post4_right] + _b[cabinet_right]) ///
		(post5: _b[post5_right] + _b[cabinet_right]) ///
		(post6: _b[post6_right] + _b[cabinet_right]) ///
		,post
est sto right

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lpattern(dash) lcolor(maroon) lwidth(vthin)) ///
			yline(`r', lpattern(dash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(small)) ///
			xscale(range(1 (1) 13)) ///
			xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3"  5 "-2" 6 "-1" 7 "0" ///
				   8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///
			title(temporary protection decisons)
			
graph save ./out/analysis/temp/dec_graph2_temp.gph, replace

* Combine graphs *
grc1leg ./out/analysis/temp/dec_graph2_pos.gph ///
		./out/analysis/temp/dec_graph2_ref.gph ///
		./out/analysis/temp/dec_graph2_temp.gph, ///
		row(3) legendfrom(./out/analysis/temp/dec_graph2_pos.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(3) scale (*1,5)		 
graph export "./src/results/final/paper/dec_graph2_baseline.pdf", replace


* Coefficient tables *

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{

eststo clear
xtset $xt_main 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						$fe_var, ///
						fe vce(cluster $se_clus)

nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right]) ///
		(bef5: _b[bef5_right]) ///
		(bef4: _b[bef4_right]) ///
		(bef3: _b[bef3_right]) ///
		(bef2: _b[bef2_right]) ///
		(bef1: _b[bef1_right]) ///
		(election: _b[elec_right]) ///
		(post1: _b[post1_right]) ///
		(post2: _b[post2_right]) ///
		(post3: _b[post3_right]) ///
		(post4: _b[post4_right]) ///
		(post5: _b[post5_right]) ///
		(post6: _b[post6_right]) ///
		,post
est sto right

esttab left right using "./src/results/final/paper/dec_graph2_coeff_`dec'.tex", ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("`dec'")
}
*
