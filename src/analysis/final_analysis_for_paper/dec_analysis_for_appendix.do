** ======================================== **
** DECISION ROBUSTNESS CHECKS FOR APPENDIX  **
** ======================================== **

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
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

global 	destination_variables log_rGDPpc_dest unemployment

* (R1) Origin, destination and time fixed effects 
		
xtset O
eststo: quietly xtreg 	`dec' ///
						$origin_variables $bilateral_variables $destination_variables cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

* (R2) Origin * time and destination fixed effects 

xtset OT
eststo: quietly xtreg 	`dec' ///
						$bilateral_variables $destination_variables cabinet_right ///
					  	$interactions_left_m1 $interactions_right_m1 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

* (R3) Control for log total decisions per capita

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						log_dest_decisions_pc log_dyadic_decisions_pc cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R4) Do not include cabinet right dummy

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R5) Include a post 2007 dummy

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables post_2007 cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R6) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

global 	destination_variables log_rGDPpc_dest unemployment

xtset DO 
eststo: quietly xtreg 	`dec' ///
						$origin_variables $destination_variables cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using "./out/analysis/final/appendix/`dec'_table1_R1-R6.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number depvars   ///
keep($origin_variables $destination_variables log_dest_decisions_pc log_dyadic_decisions_pc post_2007 cabinet_right ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables log_dest_decisions_pc log_dyadic_decisions_pc post_2007 cabinet_right ///
	  $interactions_left_m1 $interactions_right_m1) ///
title("Determinats of `dec'")


************************************
** Robustness Graph 2 for R1 - R6 **
************************************

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R1) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D 
global dependent_variable `dec' 
global graph_title "(R1)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R1.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R1.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global dependent_variable `dec'
global graph_title "(R2)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R2.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R3) Control for log total decisions per capita

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc log_dyadic_decisions_pc cabinet_right
global dependent_variable `dec'
global graph_title "(R3)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R3.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R4) Do not include cabinet right dummy

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment
global dependent_variable `dec'
global graph_title "(R4)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R4.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2.do


* (R5) Include a post 2007 dummy

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment cabinet_right post_2007
global dependent_variable `dec'
global graph_title "(R5)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R5.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R6) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global dependent_variable `dec'
global graph_title "(R6)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/`dec'_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/`dec'_graph2_R6.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do

* COMBINE GRAPHS *

* Graph 1 *
grc1leg ./out/analysis/temp/`dec'_graph1_R1.gph ///
		./out/analysis/temp/`dec'_graph1_R2.gph ///
		./out/analysis/temp/`dec'_graph1_R3.gph ///
		./out/analysis/temp/`dec'_graph1_R4.gph ///
		./out/analysis/temp/`dec'_graph1_R5.gph ///
		./out/analysis/temp/`dec'_graph1_R6.gph, ///
		row(2) legendfrom(./out/analysis/temp/`dec'_graph1_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/`dec'_R1-R6_graph1.pdf", replace

* Graph 2 *
grc1leg ./out/analysis/temp/`dec'_graph2_R1.gph ///
		./out/analysis/temp/`dec'_graph2_R2.gph ///
		./out/analysis/temp/`dec'_graph2_R3.gph ///
		./out/analysis/temp/`dec'_graph2_R4.gph ///
		./out/analysis/temp/`dec'_graph2_R5.gph ///
		./out/analysis/temp/`dec'_graph2_R6.gph, ///
		row(2) legendfrom(./out/analysis/temp/`dec'_graph2_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/`dec'_R1-R6_graph2.pdf", replace


********************************************
** Coefficient tables for Graph 2 R1 - R3 **
********************************************
eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R1) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D 
global dependent_variable `dec' 
global left left_R1
global right right_R1

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global dependent_variable `dec'
global left left_R2
global right right_R2

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R3) Control for log total decisions per capita

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc log_dyadic_decisions_pc cabinet_right
global dependent_variable `dec'
global left left_R3
global right right_R3

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R1 right_R1 left_R2 right_R2 left_R3 right_R3 ///
using ./out/analysis/final/appendix/`dec'_graph2_R1-R3_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients `dec' R1 - R3")



********************************************
** Coefficient tables for Graph 2 R4 - R6 **
********************************************
eststo clear

* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* (R4) Do not include cabinet right dummy

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment
global dependent_variable `dec' 
global left left_R4
global right right_R4

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coefficients.do


* (R5) Include post 2007 dummy

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global 	destination_variables log_rGDPpc_dest unemployment cabinet_right post_2007
global dependent_variable `dec' 
global left left_R5
global right right_R5

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R6) Use all big destination countries for which data is available

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/dec_pc_baseline_globals.do

* Define globals
global dependent_variable `dec'
global left left_R6
global right right_R6

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


esttab left_R4 right_R4 left_R5 right_R5 left_R6 right_R6 ///
using ./out/analysis/final/appendix/`dec'_graph2_R4-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients `dec' R4 - R6")



}
*
 
