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
drop if log_totaldecisions_pc == .


sutex2 	all_decisions_dest 	all_decisions_dest_pc totaldecisions totaldecisions_pc ///
		totalpositive totalpositive_pc ///
		refugeestatus refugeestatus_pc temporary_protection temporary_protection_pc ///
		n_elections_max n_cabinet_changes_max cabinet_left_right ///
		PTS CL PR death_thousands_vdc realGDPpc ///
		kmdist imm_stock_2000 rGDPpc unemployment, minmax varlabels digits(2) ///
		saving(./out/analysis/decisions/dec_summary_statistics.tex) replace
		

************************************************************
** DECISION ANALYSIS BASELINE + R3(include cabinet right) **
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

* (R4) Include cabinet right dummy
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
order($origin_variables $destination_variables cabinet_right ///
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

global left1 left1_pos
global right1 right1_pos
global diff1 diff1_pos

global left2 left2_pos
global right2 right2_pos
global diff2 diff2_pos

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_pos.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_pos.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do
		

* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 

global graph_title1 "refugee status decisons"
global graph_title2 ""

global left1 left1_ref
global right1 right1_ref
global diff1 diff1_ref

global left2 left2_ref
global right2 right2_ref
global diff2 diff2_ref

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_ref.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_ref.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc 

global graph_title1 "temporary protection decisons"
global graph_title2 ""

global left1 left1_temp
global right1 right1_temp
global diff1 diff1_temp

global left2 left2_temp
global right2 right2_temp
global diff2 diff2_temp

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_temp.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_temp.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


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


*Coefficients graph 1
esttab left1_pos right1_pos diff1_pos left1_ref right1_ref diff1_ref ///
left1_temp right1_temp diff1_temp ///
using ./out/analysis/decisions/dec_graph1_baseline_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model decisions baseline")

*Coefficients graph2
esttab left2_pos right2_pos diff2_pos left2_ref right2_ref diff2_ref ///
left2_temp right2_temp diff2_temp ///
using ./out/analysis/decisions/dec_graph2_baseline_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model decisions baseline")


*****************************************
* Decision graphs R4 with cabinet right *
*****************************************
global destination_variables log_rGDPpc_dest unemployment ///
			log_totaldecisions_pc cabinet_right

* TOTAL POSITIVE DECISIONS*
* Define globals
global dependent_variable log_totalpositive_pc

global graph_title1 "total positive decisons"
global graph_title2 ""

global left1 left1_pos
global right1 right1_pos
global diff1 diff1_pos

global left2 left2_pos
global right2 right2_pos
global diff2 diff2_pos

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R4_pos.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R4_pos.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do		

* REFUGEE STATUS DECISIONS *
* Define globals
global dependent_variable log_refugeestatus_pc 

global graph_title1 "refugee status decisons"
global graph_title2 ""

global left1 left1_ref
global right1 right1_ref
global diff1 diff1_ref

global left2 left2_ref
global right2 right2_ref
global diff2 diff2_ref

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R4_ref.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R4_ref.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do	


* TEMPORARY PROTECTION DECISIONS *
* Define globals
global dependent_variable log_temporary_protection_pc 

global graph_title1 "temporary protection decisons"
global graph_title2 ""

global left1 left1_temp
global right1 right1_temp
global diff1 diff1_temp

global left2 left2_temp
global right2 right2_temp
global diff2 diff2_temp

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/dec_graph1_R4_temp.gph"
global path_graph2_temp "./out/analysis/temp/dec_graph2_R4_temp.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do	


* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/dec_graph1_R4_pos.gph ///
		./out/analysis/temp/dec_graph1_R4_ref.gph ///
		./out/analysis/temp/dec_graph1_R4_temp.gph ///
		./out/analysis/temp/dec_graph2_R4_pos.gph ///
		./out/analysis/temp/dec_graph2_R4_ref.gph ///
		./out/analysis/temp/dec_graph2_R4_temp.gph, ///
		row(2) legendfrom(./out/analysis/temp/dec_graph1_R4_pos.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) 		 
graph export "./out/analysis/decisions/dec_graphs_cabinet_right.pdf", replace


*Coefficients graph 1
esttab left1_pos right1_pos diff1_pos left1_ref right1_ref diff1_ref ///
left1_temp right1_temp diff1_temp ///
using ./out/analysis/decisions/dec_graph1_cabinet_right_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model decisions - include cabinet right dummy")

*Coefficients graph2
esttab left2_pos right2_pos diff2_pos left2_ref right2_ref diff2_ref ///
left2_temp right2_temp diff2_temp ///
using ./out/analysis/decisions/dec_graph2_cabinet_right_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model decisions - include cabinet right dummy")



** ================================== **
** DECISION FURTHER ROBUSTNESS CHECKS **
** ================================== **

*******************************
** ROBUSTNESS CHECKS R1 - R6 **
*******************************

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc {


******************************
* ROBUSTNESS TABLE 1 R1 - R6 *
******************************

eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* (R1) Origin, destination and time fixed effects 
		
xtset O
eststo: quietly xtreg 	`dec' ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

* (R2) Origin * time and destination fixed effects 

xtset OT
eststo: quietly xtreg 	`dec' ///
						$bilateral_variables $destination_variables  ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"


* (R3) Control for past asylum applications

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_av_app5_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R4) Include cabinet right dummy

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R5) Add Hatton's policy index total

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						policy_index_total ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R6) Add Hatton's policy index access, welfare, processing

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						policy_index_access policy_index_processing ///
						policy_index_welfare  ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/decisions/`dec'_table1_R1-R6.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables $bilateral_variables  ///
	 log_av_app5_pc policy_index_total  ///
	 policy_index_access policy_index_processing policy_index_welfare ///
	 $interactions_left_m1 $interactions_right_m1)  ///
order($origin_variables $destination_variables $bilateral_variables ///
	 log_av_app5_pc policy_index_total  ///
	 policy_index_access policy_index_processing policy_index_welfare ///
	 $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec' - R1 - R6")


************************************
** Robustness Graphs  for R1 - R6 **
************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R1) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D 
global dependent_variable `dec' 

global graph_title1 "(R1)"
global graph_title2 ""

global left1 left1_R1
global right1 right1_R1
global diff1 diff1_R1

global left2 left2_R1
global right2 right2_R1
global diff2 diff2_R1


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R1.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R1.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global dependent_variable `dec'

global graph_title1 "(R2)"
global graph_title2 ""

global left1 left1_R2
global right1 right1_R2
global diff1 diff1_R2

global left2 left2_R2
global right2 right2_R2
global diff2 diff2_R2

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R2.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc log_av_app5_pc
		
global dependent_variable `dec'
global graph_title1 "(R3)"
global graph_title2 ""

global left1 left1_R3
global right1 right1_R3
global diff1 diff1_R3

global left2 left2_R3
global right2 right2_R3
global diff2 diff2_R3

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R3.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R4) Include cabinet_right dummy

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc cabinet_right
		
global dependent_variable `dec'
global graph_title1 "(R4)"
global graph_title2 ""

global left1 left1_R4
global right1 right1_R4
global diff1 diff1_R4

global left2 left2_R4
global right2 right2_R4
global diff2 diff2_R4

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R4.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do


* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc policy_index_total 
		
global dependent_variable `dec'
global graph_title1 "(R5)"
global graph_title2 ""

global left1 left1_R5
global right1 right1_R5
global diff1 diff1_R5

global left2 left2_R5
global right2 right2_R5
global diff2 diff2_R5

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R5.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc policy_index_access ///
		policy_index_processing policy_index_welfare
		
global dependent_variable `dec'
global graph_title1 "(R6)"
global graph_title2 ""

global left1 left1_R6
global right1 right1_R6
global diff1 diff1_R6

global left2 left2_R6
global right2 right2_R6
global diff2 diff2_R6

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R6.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

	 
* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/`dec'_graph1_R1.gph ///
		./out/analysis/temp/`dec'_graph1_R2.gph ///
		./out/analysis/temp/`dec'_graph1_R3.gph ///
		./out/analysis/temp/`dec'_graph2_R1.gph ///
		./out/analysis/temp/`dec'_graph2_R2.gph ///
		./out/analysis/temp/`dec'_graph2_R3.gph ///
		./out/analysis/temp/`dec'_graph1_R4.gph ///
		./out/analysis/temp/`dec'_graph1_R5.gph ///
		./out/analysis/temp/`dec'_graph1_R6.gph ///
		./out/analysis/temp/`dec'_graph2_R4.gph ///
		./out/analysis/temp/`dec'_graph2_R5.gph ///
		./out/analysis/temp/`dec'_graph2_R6.gph, ///
		row(4) legendfrom(./out/analysis/temp/`dec'_graph1_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/decisions/`dec'_graphs_R1-R6.pdf", replace

* COEFFICIENTS GRAPH 1 *

** Coefficient Table R1 - R2 **
esttab left1_R1 right1_R1 diff1_R1 left1_R2 right1_R2 diff1_R2 ///
using ./out/analysis/decisions/`dec'_graph1_R1-R2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R1 - R2")

** Coefficient Table R3 - R4 **
esttab left1_R3 right1_R3 diff1_R3 left1_R4 right1_R4 diff1_R4 ///
using ./out/analysis/decisions/`dec'_graph1_R3-R4_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R3 - R4")

** Coefficient Table R5 - R6 **
esttab left1_R5 right1_R5 diff1_R5 left1_R6 right1_R6 diff1_R6 ///
using ./out/analysis/decisions/`dec'_graph1_R5-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R5 - R6")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table R1 - R2 **
esttab left2_R1 right2_R1 diff2_R1 left2_R2 right2_R2 diff2_R2 ///
using ./out/analysis/decisions/`dec'_graph2_R1-R2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R1 - R2")

** Coefficient Table R3 - R4 **
esttab left2_R3 right2_R3 diff2_R3 left2_R4 right2_R4 diff2_R4 ///
using ./out/analysis/decisions/`dec'_graph2_R3-R4_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R3 - R4")

** Coefficient Table R5 - R6 **
esttab left2_R5 right2_R5 diff2_R5 left2_R6 right2_R6 diff2_R6 ///
using ./out/analysis/decisions/`dec'_graph2_R5-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R5 - R6")

}
*


********************************
** ROBUSTNESS CHECKS R7 - R10 **
********************************

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{


*******************************
* ROBUSTNESS TABLE 1 R7 - R10 *
*******************************

eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do
global 	destination_variables log_rGDPpc_dest unemployment

* (R7) Control for total decisions at destinations instead of total dyadic decisions 
 		
xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $bilateral_variables $destination_variables ///
						log_all_decisions_dest_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R8) Control for both dyadic and total decisions at destination 

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$bilateral_variables $destination_variables  ///
						log_totaldecisions_pc log_all_decisions_dest_pc  ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R9) Use also other big countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do
global 	destination_variables log_rGDPpc_dest unemployment

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_totaldecisions_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R10) Include a post 2007 dummy

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_totaldecisions_pc post_2007 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/decisions/`dec'_table1_R7-R10.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables log_totaldecisions_pc ///
	 log_all_decisions_dest_pc post_2007 ///
	 $interactions_left_m1 $interactions_right_m1)  ///
order($origin_variables $destination_variables log_totaldecisions_pc ///
	 log_all_decisions_dest_pc post_2007 ///
	 $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec' - R7 - R10")


*************************************
** Robustness Graphs  for R7 - R10 **
*************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R7) Control for total decisions at destinations instead of total dyadic decisions 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment log_all_decisions_dest_pc

global dependent_variable `dec' 
global graph_title1 "(R7)"
global graph_title2 ""

global left1 left1_R7
global right1 right1_R7
global diff1 diff1_R7

global left2 left2_R7
global right2 right2_R7
global diff2 diff2_R7

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R7.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R7.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R8) Control for both dyadic and total decisions at destination 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc log_all_decisions_dest_pc

global dependent_variable `dec'
global graph_title1 "(R8)"
global graph_title2 ""

global left1 left1_R8
global right1 right1_R8
global diff1 diff1_R8

global left2 left2_R8
global right2 right2_R8
global diff2 diff2_R8

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R8.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R8.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R9) Use also other big countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global dependent_variable `dec'
global graph_title1 "(R9)"
global graph_title2 ""

global left1 left1_R9
global right1 right1_R9
global diff1 diff1_R9

global left2 left2_R9
global right2 right2_R9
global diff2 diff2_R9

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R9.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R9.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R10) Include a post 2007 dummy
* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2
* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_totaldecisions_pc post_2007
		
global dependent_variable `dec'
global graph_title1 "(R10)"
global graph_title2 ""

global left1 left1_R10
global right1 right1_R10
global diff1 diff1_R10

global left2 left2_R10
global right2 right2_R10
global diff2 diff2_R10

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R10.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R10.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

	 
* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/`dec'_graph1_R7.gph ///
		./out/analysis/temp/`dec'_graph1_R8.gph ///
		./out/analysis/temp/`dec'_graph2_R7.gph ///
		./out/analysis/temp/`dec'_graph2_R8.gph ///
		./out/analysis/temp/`dec'_graph1_R9.gph ///
		./out/analysis/temp/`dec'_graph1_R10.gph ///
		./out/analysis/temp/`dec'_graph2_R9.gph ///
		./out/analysis/temp/`dec'_graph2_R10.gph, ///
		row(4) legendfrom(./out/analysis/temp/`dec'_graph1_R7.gph) ///
		 graphregion(color(white)) 

graph display, ysize(8) xsize(6) 		 
graph export "./out/analysis/decisions/`dec'_graphs_R7-R10.pdf", replace


* COEFFICIENTS GRAPH 1 *

** Coefficient Table R7 - R8 **
esttab left1_R7 right1_R7 diff1_R7 left1_R8 right1_R8 diff1_R8 ///
using ./out/analysis/decisions/`dec'_graph1_R7-R8_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R7 - R8")

** Coefficient Table R9 - R10 **
esttab left1_R9 right1_R9 diff1_R9 left1_R10 right1_R10 diff1_R10 ///
using ./out/analysis/decisions/`dec'_graph1_R9-R10_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R9 - R10")



* COEFFICIENTS GRAPH 2 *

** Coefficient Table R7 - R8 **
esttab left2_R7 right2_R7 diff2_R7 left2_R8 right2_R8 diff2_R8 ///
using ./out/analysis/decisions/`dec'_graph2_R7-R8_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R7 - R8")

** Coefficient Table R9 - R10 **
esttab left2_R9 right2_R9 diff2_R9 left2_R10 right2_R10 diff2_R10 ///
using ./out/analysis/decisions/`dec'_graph2_R9-R10_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R9 - R10")

}
*


*********************************
** ROBUSTNESS CHECKS R11 - R16 **
*********************************

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{


********************************
* ROBUSTNESS TABLE 1 R11 - R16 *
********************************

eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do
global 	destination_variables log_rGDPpc_dest unemployment

* (R11) Control for total decisions in previous year
*		 instead of log_totaldecisions_pc
		
xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_yearly_all_decisions_dest_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R12) Control for dyadic decisions in previous year 
*		instead of log_totaldecisions_pc

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_yearly_dyadic_decisions_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R13) Control for total and dyadic decisions in previous year 
*		instead of log_totaldecisions_pc

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_yearly_all_decisions_dest_pc  log_yearly_dyadic_decisions_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R14) Control for total first-time applications in previous 2 quarters
*		 instead of log_totaldecisions_pc
		
xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_firsttimeapp_total_sum2_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R15) Control for dyadic first-time applications in previous 2 quarters 
*		instead of log_totaldecisions_pc

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						 log_firsttimeapp_dyadic_sum2_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R16) Control for total and dyadic first-time applications in previous 2 quarters
*		instead of log_totaldecisions_pc

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_firsttimeapp_total_sum2_pc   log_firsttimeapp_dyadic_sum2_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/decisions/`dec'_table1_R11-R16.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables ///
	 log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc ///
	 log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc ///
	 $interactions_left_m1 $interactions_right_m1)  ///
order($origin_variables $destination_variables ///
	 log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc ///
	 log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc ///
	 $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec' - R11 - R16")


**************************************
** Robustness Graphs  for R11 - R16 **
**************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R11) Control for total decisions in previous year
*		 instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_yearly_all_decisions_dest

global dependent_variable `dec' 
global graph_title1 "(R11)"
global graph_title2 ""

global left1 left1_R11
global right1 right1_R11
global diff1 diff1_R11

global left2 left2_R11
global right2 right2_R11
global diff2 diff2_R11

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R11.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R11.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R12) Control for dyadic decisions in previous year 
*		instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_yearly_dyadic_decisions_pc
		
global dependent_variable `dec'
global graph_title1 "(R12)"
global graph_title2 ""

global left1 left1_R12
global right1 right1_R12
global diff1 diff1_R12

global left2 left2_R12
global right2 right2_R12
global diff2 diff2_R12

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R12.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R12.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R13) Control for dyadic decisions in previous year 
*		instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_yearly_all_decisions_dest log_yearly_dyadic_decisions_pc
		
global dependent_variable `dec'
global graph_title1 "(R13)"
global graph_title2 ""

global left1 left1_R13
global right1 right1_R13
global diff1 diff1_R13

global left2 left2_R13
global right2 right2_R13
global diff2 diff2_R13

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R13.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R13.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R14) Control for total first-time applications in previous 2 quarters
*		 instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_sum2_pc
		
global dependent_variable `dec'
global graph_title1 "(R14)"
global graph_title2 ""

global left1 left1_R14
global right1 right1_R14
global diff1 diff1_R14

global left2 left2_R14
global right2 right2_R14
global diff2 diff2_R14

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R14.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R14.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R15) Control for dyadic first-time applications in previous 2 quarters
*		 instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_dyadic_sum2_pc
		
global dependent_variable `dec'
global graph_title1 "(R15)"
global graph_title2 ""

global left1 left1_R15
global right1 right1_R15
global diff1 diff1_R15

global left2 left2_R15
global right2 right2_R15
global diff2 diff2_R15

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R15.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R15.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R16) Control for total and dyadic first-time applications in previous 2 quarters
*		 instead of log_totaldecisions_pc

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc
		
global dependent_variable `dec'
global graph_title1 "(R16)"
global graph_title2 ""

global left1 left1_R16
global right1 right1_R16
global diff1 diff1_R16

global left2 left2_R16
global right2 right2_R16
global diff2 diff2_R16

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R16.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R16.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

	 
* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/`dec'_graph1_R11.gph ///
		./out/analysis/temp/`dec'_graph1_R12.gph ///
		./out/analysis/temp/`dec'_graph1_R13.gph ///
		./out/analysis/temp/`dec'_graph2_R11.gph ///
		./out/analysis/temp/`dec'_graph2_R12.gph ///
		./out/analysis/temp/`dec'_graph2_R13.gph ///
		./out/analysis/temp/`dec'_graph1_R14.gph ///
		./out/analysis/temp/`dec'_graph1_R15.gph ///
		./out/analysis/temp/`dec'_graph1_R16.gph ///
		./out/analysis/temp/`dec'_graph2_R14.gph ///
		./out/analysis/temp/`dec'_graph2_R15.gph ///
		./out/analysis/temp/`dec'_graph2_R16.gph, ///
		row(4) legendfrom(./out/analysis/temp/`dec'_graph1_R11.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/decisions/`dec'_graphs_R11-R16.pdf", replace


* COEFFICIENTS GRAPH 1 *

** Coefficient Table R11 - R12 **
esttab left1_R11 right1_R11 diff1_R11 left1_R12 right1_R12 diff1_R12 ///
using ./out/analysis/decisions/`dec'_graph1_R11-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R11 - R12")

** Coefficient Table R13 - R14 **
esttab left1_R13 right1_R13 diff1_R13 left1_R14 right1_R14 diff1_R14 ///
using ./out/analysis/decisions/`dec'_graph1_R13-R14_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R13 - R14")

** Coefficient Table R15 - R16 **
esttab left1_R15 right1_R15 diff1_R15 left1_R16 right1_R16 diff1_R16 ///
using ./out/analysis/decisions/`dec'_graph1_R15-R16_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R15 - R16")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table R11 - R12 **
esttab left2_R11 right2_R11 diff2_R11 left2_R12 right2_R12 diff2_R12 ///
using ./out/analysis/decisions/`dec'_graph2_R11-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R11 - R12")

** Coefficient Table R13 - R14 **
esttab left2_R13 right2_R13 diff2_R13 left2_R14 right2_R14 diff2_R14 ///
using ./out/analysis/decisions/`dec'_graph2_R13-R14_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R13 - R14")

** Coefficient Table R15 - R16 **
esttab left2_R15 right2_R15 diff2_R15 left2_R16 right2_R16 diff2_R16 ///
using ./out/analysis/decisions/`dec'_graph2_R15-R16_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R15 - R16")


}
*


*********************************
** ROBUSTNESS CHECKS R17 - R20 **
*********************************

foreach dec in acceptance_rate refugeestatus_rate temporary_protection_rate {


***************************************************************
* ROBUSTNESS TABLE 1 R17 - R20  - use rates instead of log pc *
***************************************************************

eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do
global y_scale (-0.1 -0.05 0 0.05 0.1)
global 	destination_variables log_rGDPpc_dest unemployment 

* (R17) Rate baseline - no additional controls
 		
xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R18) Rate cabinet right

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$bilateral_variables $destination_variables  ///
						cabinet_right  ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R19) Rate control for total and dyadic decisions in previous year 

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R20) Rate control for total and dyadic first-time applications in previous 2 quarters

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						firsttimeapp_total_sum2 firsttimeapp_dyadic_sum2 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/decisions/`dec'_table1_R17-R20.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables cabinet_right ///
	 log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc ///
	 log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc ///
	 $interactions_left_m1 $interactions_right_m1)  ///
order($origin_variables $destination_variables cabinet_right ///
	 log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc ///
	 log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc ///
	 $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec' - R17 - R20")


*************************************
** Robustness Graphs  for R17 - R20 **
*************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_pc_baseline_globals.do
global y_scale (-0.1 -0.05 0 0.05 0.1)

* (R17) Rate baseline - no additional controls

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment 

global dependent_variable `dec' 
global graph_title1 "(R17)"
global graph_title2 ""

global left1 left1_R17
global right1 right1_R17
global diff1 diff1_R17

global left2 left2_R17
global right2 right2_R17
global diff2 diff2_R17

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R17.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R17.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R18) Rate cabinet right

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment cabinet_right

global dependent_variable `dec'
global graph_title1 "(R18)"
global graph_title2 ""

global left1 left1_R18
global right1 right1_R18
global diff1 diff1_R18

global left2 left2_R18
global right2 right2_R18
global diff2 diff2_R18

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R18.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R18.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do


* (R19) Rate control for total and dyadic decisions in previous year 

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_yearly_all_decisions_dest_pc log_yearly_dyadic_decisions_pc
		
global dependent_variable `dec'
global graph_title1 "(R19)"
global graph_title2 ""

global left1 left1_R19
global right1 right1_R19
global diff1 diff1_R19

global left2 left2_R19
global right2 right2_R19
global diff2 diff2_R19

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R19.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R19.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R20) Rate control for total and dyadic first-time applications in previous 2 quarters

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_sum2_pc log_firsttimeapp_dyadic_sum2_pc
		
global dependent_variable `dec'
global graph_title1 "(R20)"
global graph_title2 ""

global left1 left1_R20
global right1 right1_R20
global diff1 diff1_R20

global left2 left2_R20
global right2 right2_R20
global diff2 diff2_R20

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R20.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R20.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

	 
* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/`dec'_graph1_R17.gph ///
		./out/analysis/temp/`dec'_graph1_R18.gph ///
		./out/analysis/temp/`dec'_graph2_R17.gph ///
		./out/analysis/temp/`dec'_graph2_R18.gph ///
		./out/analysis/temp/`dec'_graph1_R19.gph ///
		./out/analysis/temp/`dec'_graph1_R20.gph ///
		./out/analysis/temp/`dec'_graph2_R19.gph ///
		./out/analysis/temp/`dec'_graph2_R20.gph, ///
		row(4) legendfrom(./out/analysis/temp/`dec'_graph1_R17.gph) ///
		 graphregion(color(white)) 

graph display, ysize(8) xsize(6) 		 
graph export "./out/analysis/decisions/`dec'_graphs_R17-R20.pdf", replace


* COEFFICIENTS GRAPH 1 *

** Coefficient Table R17 - R18 **
esttab left1_R17 right1_R17 diff1_R17 left1_R18 right1_R18 diff1_R18 ///
using ./out/analysis/decisions/`dec'_graph1_R17-R18_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R17 - R18")

** Coefficient Table R19 - R20 **
esttab left1_R19 right1_R19 diff1_R19 left1_R20 right1_R20 diff1_R20 ///
using ./out/analysis/decisions/`dec'_graph1_R19-R20_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model `dec' R19 - R20")



* COEFFICIENTS GRAPH 2 *

** Coefficient Table R17 - R18 **
esttab left2_R17 right2_R17 diff2_R17 left2_R18 right2_R18 diff2_R18 ///
using ./out/analysis/decisions/`dec'_graph2_R17-R18_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R17 - R18")

** Coefficient Table R19 - R20 **
esttab left2_R19 right2_R19 diff2_R19 left2_R20 right2_R20 diff2_R20 ///
using ./out/analysis/decisions/`dec'_graph2_R19-R20_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model `dec' R19 - R20")

}
*

