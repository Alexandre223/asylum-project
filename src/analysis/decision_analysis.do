***********************
** ================= **
** DECISION ANALYSIS **
** ================= **
***********************

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
		saving(./out/analysis/decisions/dec_summary_statistics.tex) replace
		

************************************************************
** DECISION ANALYSIS BASELINE + R1(include cabinet right) **
************************************************************

* use log pc and control for total decisions*

* Table 1 - baseline results for log decisions per capita *

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* (Baseline)
eststo clear		
foreach dec in log_totalpositive_pc ///
 log_refugeestatus_pc  log_temporary_protection_pc{

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

* (R1) Include cabinet right dummy
foreach dec in log_totalpositive_pc ///
 log_refugeestatus_pc  log_temporary_protection_pc{

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

}
*
 
esttab using "./out/analysis/decisions/dec_table1_baseline.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables cabinet_right ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables ///
	  $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of asylum decisions per capita")


****************************
* Decision graphs baseline *
****************************

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global graph_title1 "total positive decisons"
global graph_title2 ""
global coef_tab_title "total positive decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_pos.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_pos.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
		

* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global graph_title1 "refugee status decisons"
global graph_title2 ""
global coef_tab_title "refugee status decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_ref.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_ref.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc 
global graph_title1 "temporary protection decisons"
global graph_title2 ""
global coef_tab_title "temporary protection decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_temp.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_temp.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/dec_graph1_pos.gph ///
		./out/analysis/temp/dec_graph1_ref.gph ///
		./out/analysis/temp/dec_graph1_temp.gph ///
		./out/analysis/temp/dec_graph2_pos.gph ///
		./out/analysis/temp/dec_graph2_ref.gph ///
		./out/analysis/temp/dec_graph2_temp.gph, ///
		row(2) legendfrom(./out/analysis/temp/dec_graph1_pos.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) 		 
graph export "./out/analysis/decisions/dec_graphs_baseline.pdf", replace

****************************
* Coefficients for Graph 2 *
****************************

eststo clear

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global left left_pos
global right right_pos

do ./src/analysis/modules/graph_2_coef.do


* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global left left_ref
global right right_ref

do ./src/analysis/modules/graph_2_coef.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc
global left left_temp
global right right_temp
do ./src/analysis/modules/graph_2_coef.do

esttab left_pos right_pos left_ref right_ref left_temp right_temp ///
using ./out/analysis/decisions/dec_graph2_baseline_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2 Decisions")


*****************************************
* Decision graphs R1 with cabinet right *
*****************************************
global destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc cabinet_right


* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global graph_title1 "total positive decisons"
global graph_title2 ""
global coef_tab_title "total positive decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R1_pos.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R1_pos.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
		

* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global graph_title1 "refugee status decisons"
global graph_title2 ""
global coef_tab_title "refugee status decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R1_ref.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R1_ref.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc 
global graph_title1 "temporary protection decisons"
global graph_title2 ""
global coef_tab_title "temporary protection decisons"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R1_temp.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R1_temp.gph"

* Produce graphs 
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do


* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/dec_graph1_R1_pos.gph ///
		./out/analysis/temp/dec_graph1_R1_ref.gph ///
		./out/analysis/temp/dec_graph1_R1_temp.gph ///
		./out/analysis/temp/dec_graph2_R1_pos.gph ///
		./out/analysis/temp/dec_graph2_R1_ref.gph ///
		./out/analysis/temp/dec_graph2_R1_temp.gph, ///
		row(2) legendfrom(./out/analysis/temp/dec_graph1_R1_pos.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) 		 
graph export "./out/analysis/decisions/dec_graphs_R1.pdf", replace

****************************
* Coefficients for Graph 2 *
****************************

eststo clear

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc
global left left_pos
global right right_pos

do ./src/analysis/modules/graph_2_coef_cabinet_right.do


* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 
global left left_ref
global right right_ref

do ./src/analysis/modules/graph_2_coef_cabinet_right.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc
global left left_temp
global right right_temp
do ./src/analysis/modules/graph_2_coef_cabinet_right.do

esttab left_pos right_pos left_ref right_ref left_temp right_temp ///
using ./out/analysis/decisions/dec_graph2_R1_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2 Decisions")



** ================================== **
** DECISION FURTHER ROBUSTNESS CHECKS **
** ================================== **

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{


**********************
* ROBUSTNESS TABLE 1 *
**********************

eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* (R2) Origin, destination and time fixed effects 
		
xtset O
eststo: quietly xtreg 	`dec' ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

* (R3) Origin * time and destination fixed effects 

xtset OT
eststo: quietly xtreg 	`dec' ///
						$bilateral_variables $destination_variables  ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

* (R4) Control for past asylum applications

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_av_app_pc5 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R5) Control for first-time applications in previous quarter

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables lag_log_firsttimeapp_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R6) Include a post 2007 dummy

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables post_2007 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R7) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/decisions/`dec'_table1_R2-R7.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables log_av_app_pc5 lag_log_firsttimeapp_pc post_2007  ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables log_av_app_pc5 lag_log_firsttimeapp_pc post_2007  ///
	  $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec'")


************************************
** Robustness Graphs  for R2 - R7 **
************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R2) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D 
global dependent_variable `dec' 
global graph_title1 "(R2)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R2.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R3) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global dependent_variable `dec'
global graph_title1 "(R3)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R3.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R4) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc log_av_app_pc5
		
global dependent_variable `dec'
global graph_title1 "(R4)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R4.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R5) Control for first-time applications in previous quarter

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc lag_log_firsttimeapp_pc
global dependent_variable `dec'
global graph_title1 "(R5)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R5.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R6) Include a post 2007 dummy

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc post_2007
global dependent_variable `dec'
global graph_title1 "(R6)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R6.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R7) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global dependent_variable `dec'
global graph_title1 "(R7)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R7.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R7.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/`dec'_graph1_R2.gph ///
		./out/analysis/temp/`dec'_graph1_R3.gph ///
		./out/analysis/temp/`dec'_graph1_R4.gph ///
		./out/analysis/temp/`dec'_graph2_R2.gph ///
		./out/analysis/temp/`dec'_graph2_R3.gph ///
		./out/analysis/temp/`dec'_graph2_R4.gph ///
		./out/analysis/temp/`dec'_graph1_R5.gph ///
		./out/analysis/temp/`dec'_graph1_R6.gph ///
		./out/analysis/temp/`dec'_graph1_R7.gph ///
		./out/analysis/temp/`dec'_graph2_R5.gph ///
		./out/analysis/temp/`dec'_graph2_R6.gph ///
		./out/analysis/temp/`dec'_graph2_R7.gph, ///
		row(4) legendfrom(./out/analysis/temp/`dec'_graph1_R2.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/decisions/`dec'_graphs_R2-R7.pdf", replace


********************************************
** Coefficient tables for Graph 2 R2 - R4 **
********************************************
eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R2) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D 
global dependent_variable `dec' 
global left left_R2
global right right_R2

do ./src/analysis/modules/graph_2_coef.do


* (R3) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global dependent_variable `dec'
global left left_R3
global right right_R3

do ./src/analysis/modules/graph_2_coef.do


* (R4) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc log_av_app_pc5
		
global dependent_variable `dec'
global left left_R4
global right right_R4

do ./src/analysis/modules/graph_2_coef.do

esttab left_R2 right_R2 left_R3 right_R3 left_R4 right_R4 ///
using ./out/analysis/decisions/`dec'_graph2_R2-R4_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients `dec' R2 - R4")



********************************************
** Coefficient tables for Graph 2 R5 - R7 **
********************************************
eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R5) Control for first-time applications in previous quarter

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc lag_log_firsttimeapp_pc
global dependent_variable `dec' 
global left left_R5
global right right_R5

do ./src/analysis/modules/graph_2_coef.do


* (R6) Include post 2007 dummy

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc post_2007
global dependent_variable `dec' 
global left left_R6
global right right_R6

do ./src/analysis/modules/graph_2_coef.do


* (R7) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global dependent_variable `dec'
global left left_R7
global right right_R7

do ./src/analysis/modules/graph_2_coef.do


esttab left_R5 right_R5 left_R6 right_R6 left_R7 right_R7 ///
using ./out/analysis/decisions/`dec'_graph2_R5-R7_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients `dec' R5 - R7")

}
*
 
