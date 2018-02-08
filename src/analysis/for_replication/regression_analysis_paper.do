
cd "F:\research\asylum-project\src\analysis\for_replication"

** APPLICATION ANALYSIS **


*************************************************************
*** Table 1: Baseline plus main robustness checks R1 - R6 ***
*************************************************************

* Specify data set to be used *
use application_data.dta, clear

* Define globals for baseline analysis *
do ./modules/app_baseline_globals.do

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
						$origin_variables $destination_variables log_av_app5_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R4) Include cabinet right dummy 
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables cabinet_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R5) Add Hatton's policy index total
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables policy_index_total ///
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
						policy_index_welfare ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"
 
esttab using "app_table1_base-R6.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $bilateral_variables $destination_variables log_av_app5_pc ///
	  policy_index_total policy_index_access policy_index_processing  ///
	  policy_index_welfare  cabinet_right $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $bilateral_variables $destination_variables log_av_app5_pc ///
	  policy_index_total policy_index_access policy_index_processing  ///
	  policy_index_welfare  cabinet_right $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)

*********************
** Graphs Baseline **
*********************

* Define globals for baseline analysis *
do .modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "app_graph1_baseline.gph"
global path_graph2_temp "app_graph2_baseline.gph"

global graph_title1 "Baseline"
global graph_title2 ""

global left1 left1
global right1 right1
global diff1 diff1

global left2 left2
global right2 right2
global diff2 diff2

* Produce graphs and coefficents
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef.do

* Combine Graphs *
grc1leg app_graph1_baseline.gph ///
		app_graph2_baseline.gph, ///
		row(2) legendfrom(app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(3) xsize(2) 		 
graph export  "app_graphs_baseline.pdf", replace


*Coefficients graph2
esttab left2 right2 diff2 ///
using app_graph2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2")

/* Continue adjusting the file from here and add decision analysis - don't produce coefficient tables

** ===================================== **
** GRAPHS FOR RUBUSTNESS CHECKS R1 - R6  **
** ===================================== **

* (R1) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D

global graph_title1 "(R1)"
global graph_title2 ""

global left1 left1_R1
global right1 right1_R1
global diff1 diff1_R1

global left2 left2_R1
global right2 right2_R1
global diff2 diff2_R1

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R1.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R1.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D

global graph_title1 "(R2)"
global graph_title2 ""

global left1 left1_R2
global right1 right1_R2
global diff1 diff1_R2

global left2 left2_R2
global right2 right2_R2
global diff2 diff2_R2

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R2.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_av_app5_pc

global graph_title1 "(R3)"
global graph_title2 ""

global left1 left1_R3
global right1 right1_R3
global diff1 diff1_R3

global left2 left2_R3
global right2 right2_R3
global diff2 diff2_R3

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R3.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R4) Include cabinet right dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right

global graph_title1 "(R4)"
global graph_title2 ""

global left1 left1_R4
global right1 right1_R4
global diff1 diff1_R4

global left2 left2_R4
global right2 right2_R4
global diff2 diff2_R4

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R4.gph"

* Produce graphs

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do
do ./src/analysis/modules/graph_1_coef_cabinet_right.do
do ./src/analysis/modules/graph_2_coef_cabinet_right.do


* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  policy_index_total

global graph_title1 "(R5)"
global graph_title2 ""

global left1 left1_R5
global right1 right1_R5
global diff1 diff1_R5

global left2 left2_R5
global right2 right2_R5
global diff2 diff2_R5

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R5.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  ///
							  policy_index_access policy_index_processing ///
							  policy_index_welfare  

global graph_title1 "(R6)"
global graph_title2 ""

global left1 left1_R6
global right1 right1_R6
global diff1 diff1_R6

global left2 left2_R6
global right2 right2_R6
global diff2 diff2_R6

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R6.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/app_graph1_R1.gph ///
		./out/analysis/temp/app_graph1_R2.gph ///
		./out/analysis/temp/app_graph1_R3.gph ///
		./out/analysis/temp/app_graph2_R1.gph ///
		./out/analysis/temp/app_graph2_R2.gph ///
		./out/analysis/temp/app_graph2_R3.gph ///
		./out/analysis/temp/app_graph1_R4.gph ///
		./out/analysis/temp/app_graph1_R5.gph ///
		./out/analysis/temp/app_graph1_R6.gph ///
		./out/analysis/temp/app_graph2_R4.gph ///
		./out/analysis/temp/app_graph2_R5.gph ///
		./out/analysis/temp/app_graph2_R6.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(7) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R1-R6.pdf", replace


* COEFFICIENTS GRAPH 1 *

** Coefficient Table R1 - R2 **
esttab left1_R1 right1_R1 diff1_R1 left1_R2 right1_R2 diff1_R2 ///
using ./out/analysis/applications/app_graph1_R1-R2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R1 - R2")

** Coefficient Table R3 - R4 **
esttab left1_R3 right1_R3 diff1_R3 left1_R4 right1_R4 diff1_R4 ///
using ./out/analysis/applications/app_graph1_R3-R4_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R3 - R4")

** Coefficient Table R5 - R6 **
esttab left1_R5 right1_R5 diff1_R5 left1_R6 right1_R6 diff1_R6 ///
using ./out/analysis/applications/app_graph1_R5-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model R5 - R6")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table R1 - R2 **
esttab left2_R1 right2_R1 diff2_R1 left2_R2 right2_R2 diff2_R2 ///
using ./out/analysis/applications/app_graph2_R1-R2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R1 - R2")

** Coefficient Table R3 - R4 **
esttab left2_R3 right2_R3 diff2_R3 left2_R4 right2_R4 diff2_R4 ///
using ./out/analysis/applications/app_graph2_R3-R4_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R3 - R4")

** Coefficient Table R5 - R6 **
esttab left2_R5 right2_R5 diff2_R5 left2_R6 right2_R6 diff2_R6 ///
using ./out/analysis/applications/app_graph2_R5-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model R5 - R6")
