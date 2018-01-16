* ======================== *
* FINAL ANALYSIS FOR PAPER *
* ======================== *

**************************
** APPLICATION ANALYSIS **
**************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do


* Table 1: Baseline plus main robustness checks *

eststo clear

* (Baseline)
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R1) Origin, destination and time fixed effects  
xtset O
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

* (R2) Origin * time and destination fixed effects  
xtset OT
eststo: quietly xtreg 	$dependent_variable ///
						$bilateral_variables $destination_variables ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

* (R3) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R4) Do not include cabinet right dummy 
global destination_variables log_rGDPpc_dest unemployment 
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables  ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R5) Add Hatton's policy index total
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables policy_index_total cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R6) Add Hatton's policy index access, welfare, processing
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						policy_index_access policy_index_processing ///
						policy_index_welfare cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"
 
esttab using "./out/analysis/final/paper/app_table1_paper.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $bilateral_variables $destination_variables log_av_app_pc ///
	  policy_index_total policy_index_access policy_index_processing  ///
	  policy_index_welfare  cabinet_right $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $bilateral_variables $destination_variables log_av_app_pc ///
	  policy_index_total policy_index_access policy_index_processing  ///
	  policy_index_welfare  cabinet_right $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


** Graph 1 bef - after for main specification **

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_baseline.gph"

* Produce graph 1 
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right_no_title.do
graph export "./out/analysis/final/paper/app_graph1_baseline.pdf", replace


** Graph 2 - 6 quarters before and after for main specification **

* Define gobals for output paths
global path_graph2_temp "./out/analysis/temp/app_graph2_baseline.gph"

* Produce graph 2 
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_no_title.do
graph export "./out/analysis/final/paper/app_graph2_baseline.pdf", replace


** Coefficients for graph 2 **

* Define gobals 
global left left
global right right

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left right ///
using ./out/analysis/final/paper/app_graph2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2")

***********************
** DECISION ANALYSIS **
***********************

* Table 1 - baseline results for log decisions per capita *

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do


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
 
esttab using "./out/analysis/final/paper/dec_table1_paper.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables ///
	  $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of asylum decisions per capita")

*******************
* Decision graphs *
*******************

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global graph_title "total positive decisons"
global coef_tab_title "total positive decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_pos.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_pos.gph"

* Produce graphs 
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_no_title.do
		

* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global graph_title "refugee status decisons"
global coef_tab_title "refugee status decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_ref.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_ref.gph"

* Produce graphs 
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_no_title.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc 
global graph_title "temporary protection decisons"
global coef_tab_title "temporary protection decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_temp.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_temp.gph"

* Produce graphs 
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_no_title.do


* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/dec_graph1_pos.gph ///
		./out/analysis/temp/dec_graph1_ref.gph ///
		./out/analysis/temp/dec_graph1_temp.gph ///
		./out/analysis/temp/dec_graph2_pos.gph ///
		./out/analysis/temp/dec_graph2_ref.gph ///
		./out/analysis/temp/dec_graph2_temp.gph, ///
		row(2) legendfrom(./out/analysis/temp/dec_graph2_pos.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/paper/dec_graphs_baseline.pdf", replace

****************************
* Coefficients for Graph 2 *
****************************

eststo clear

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global left left_pos
global right right_pos

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global left left_ref
global right right_ref

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc
global left left_temp
global right right_temp
do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_pos right_pos left_ref right_ref left_temp right_temp ///
using ./out/analysis/final/paper/dec_graph2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2 Decisions")
