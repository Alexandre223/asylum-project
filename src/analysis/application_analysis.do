**************************
** ==================== **
** APPLICATION ANALYSIS **
** ==================== **
**************************

*************************************************************
*** Table 1: Baseline plus main robustness checks R1 - R6 ***
*************************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

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
 
esttab using "./out/analysis/applications/app_table1_base-R6.tex", ///
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
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_baseline.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_baseline.gph"

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
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* Combine Graphs *
grc1leg ./out/analysis/temp/app_graph1_baseline.gph ///
		./out/analysis/temp/app_graph2_baseline.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(3) xsize(2) 		 
graph export  "./out/analysis/applications/app_graphs_baseline.pdf", replace

*Coefficients graph 1
esttab left1 right1 diff1 ///
using ./out/analysis/applications/app_graph1_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients Graph 1")

*Coefficients graph2
esttab left2 right2 diff2 ///
using ./out/analysis/applications/app_graph2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients Graph 2")



** ===================================== **
** GRAPHS FOR RUBUSTNESS CHECKS R1 - R6  **
** ===================================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


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



** ========================= **
** ROBUSTNESS TABLE 1 R7-R12 **
** ========================= **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

eststo clear

* (R7) Use log first-time applications per capita in origin country as dependent variable
xtset DO 
eststo: quietly xtreg 	log_firsttimeapp_pc_origin ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R8) Do not use lags for origin country variables 
global origin_variables1 PTS CL PR death_thousands_vdc log_rGDPpc_orig
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables1 $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R9) Use Syrian battle death data from UCDP
global origin_variables2 ///
		PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables2 $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R10) Include a post 2007 dummy
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables post_2007 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R11) Cluster standard errors on destination*origin level
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster DO)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R12) Do not impute first-time application data for 2008 and 2009
* Specify data set to be used *
use ./out/data/final_application/baseline_non_imputed_fta.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

xtset DO 
eststo: quietly xtreg 	log_firsttimeapp_NI_pc ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes" 

 
esttab using "./out/analysis/applications/app_table1_R7-R12.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $origin_variables1 $origin_variables2 $destination_variables post_2007 $interactions_left_m1 ///
	 $interactions_right_m1) ///
order($origin_variables $origin_variables1 $origin_variables2 $destination_variables post_2007  $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


*************************
** Graphs for R7 - R12 **
*************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R7) Use log first-time applications per capita in origin country as dependent variable

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_pc_origin 

global graph_title1 "(R7)"
global graph_title2 ""

global left1 left1_R7
global right1 right1_R7
global diff1 diff1_R7

global left2 left2_R7
global right2 right2_R7
global diff2 diff2_R7

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R7.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R7.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R8) Do not use lags for origin country variables 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig

global graph_title1 "(R8)"
global graph_title2 ""

global left1 left1_R8
global right1 right1_R8
global diff1 diff1_R8

global left2 left2_R8
global right2 right2_R8
global diff2 diff2_R8

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R8.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R8.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R9) Use Syrian battle death data from UCDP

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 

global graph_title1 "(R9)"
global graph_title2 ""

global left1 left1_R9
global right1 right1_R9
global diff1 diff1_R9

global left2 left2_R9
global right2 right2_R9
global diff2 diff2_R9

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R9.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R9.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R10) Include a post 2007 dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  post_2007

global graph_title1 "(R10)"
global graph_title2 ""

global left1 left1_R10
global right1 right1_R10
global diff1 diff1_R10

global left2 left2_R10
global right2 right2_R10
global diff2 diff2_R10

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R10.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R10.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R11) Cluster standard errors on destination*origin level

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global se_clus DO 

global graph_title1 "(R11)"
global graph_title2 ""

global left1 left1_R11
global right1 right1_R11
global diff1 diff1_R11

global left2 left2_R11
global right2 right2_R11
global diff2 diff2_R11

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R11.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R11.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R12) Do not impute first-time application data for 2008 and 2009

* Specify data set to be used *
use ./out/data/final_application/baseline_non_imputed_fta.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_NI_pc

global graph_title1 "(R12)"
global graph_title2 ""

global left1 left1_R12
global right1 right1_R12
global diff1 diff1_R12

global left2 left2_R12
global right2 right2_R12
global diff2 diff2_R12

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R12.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R12.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/app_graph1_R7.gph ///
		./out/analysis/temp/app_graph1_R8.gph ///
		./out/analysis/temp/app_graph1_R9.gph ///
		./out/analysis/temp/app_graph2_R7.gph ///
		./out/analysis/temp/app_graph2_R8.gph ///
		./out/analysis/temp/app_graph2_R9.gph ///
		./out/analysis/temp/app_graph1_R10.gph ///
		./out/analysis/temp/app_graph1_R11.gph ///
		./out/analysis/temp/app_graph1_R12.gph ///
		./out/analysis/temp/app_graph2_R10.gph ///
		./out/analysis/temp/app_graph2_R11.gph ///
		./out/analysis/temp/app_graph2_R12.gph, ///		
		row(4) legendfrom(./out/analysis/temp/app_graph1_R7.gph) ///
		 graphregion(color(white)) 

graph display, ysize(7) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R7-R12.pdf", replace

* COEFFICIENTS GRAPH 1 *

** Coefficient Table R7 - R8 **
esttab left1_R7 right1_R7 diff1_R7 left1_R8 right1_R8 diff1_R8 ///
using ./out/analysis/applications/app_graph1_R7-R8_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R7 - R8")

** Coefficient Table R9 - R10 **
esttab left1_R9 right1_R9 diff1_R9 left1_R10 right1_R10 diff1_R10 ///
using ./out/analysis/applications/app_graph1_R9-R10_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R9 - R10")

** Coefficient Table R11 - R12 **
esttab left1_R11 right1_R11 diff1_R11 left1_R12 right1_R12 diff1_R12 ///
using ./out/analysis/applications/app_graph1_R11-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model R11 - R12")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table R7 - R8 **
esttab left2_R7 right2_R7 diff2_R7 left2_R8 right2_R8 diff2_R8 ///
using ./out/analysis/applications/app_graph2_R7-R8_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R7 - R8")

** Coefficient Table R9 - R10 **
esttab left2_R9 right2_R9 diff2_R9 left2_R10 right2_R10 diff2_R10 ///
using ./out/analysis/applications/app_graph2_R9-R10_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R9 - R10")

** Coefficient Table R11 - R12 **
esttab left2_R11 right2_R11 diff2_R11 left2_R12 right2_R12 diff2_R12 ///
using ./out/analysis/applications/app_graph2_R11-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model R11 - R12")



** ========================== **
** ROBUSTNESS TABLE 1 R13-R18 **
** ========================== **

eststo clear

* (R13) Use normalized cabinet position to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster DO)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R14) Split cabinet position at 5 to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_cabinet_split_at_5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster DO)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R15) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R16) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"


* (R17) Control for lag total first-time applications in the previous 6 quarters

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R18) use only countries that are also in decision analysis
* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"
 
esttab using "./out/analysis/applications/app_table1_R13-R18.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
	  $interactions_left_m1 $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


*************************
** Graphs for R13- R18 **
*************************

* (R13) Use normalized cabinet position to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global graph_title1 "(R13)"
global graph_title2 ""

global left1 left1_R13
global right1 right1_R13
global diff1 diff1_R13

global left2 left2_R13
global right2 right2_R13
global diff2 diff2_R13

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R13.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R13.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R14) Slpit cabinet position at 5 to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_cabinet_split_at_5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global graph_title1 "(R14)"
global graph_title2 ""

global left1 left1_R14
global right1 right1_R14
global diff1 diff1_R14

global left2 left2_R14
global right2 right2_R14
global diff2 diff2_R14

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R14.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R14.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R15) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global graph_title1 "(R15)"
global graph_title2 ""

global left1 left1_R15
global right1 right1_R15
global diff1 diff1_R15

global left2 left2_R15
global right2 right2_R15
global diff2 diff2_R15

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R15.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R15.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* (R16) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global graph_title1 "(R16)"
global graph_title2 ""

global left1 left1_R16
global right1 right1_R16
global diff1 diff1_R16

global left2 left2_R16
global right2 right2_R16
global diff2 diff2_R16

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R16.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R16.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R17) Control for lag of dependent variable

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_mean6_pc

global graph_title1 "(R17)"
global graph_title2 ""

global left1 left1_R17
global right1 right1_R17
global diff1 diff1_R17

global left2 left2_R17
global right2 right2_R17
global diff2 diff2_R17

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R17.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R17.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (R18) use only countries that are also in the baseline decision analysis
* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

global graph_title1 "(R18)"
global graph_title2 ""

global left1 left1_R18
global right1 right1_R18
global diff1 diff1_R18

global left2 left2_R18
global right2 right2_R18
global diff2 diff2_R18

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R18.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R18.gph"

* Produce graphs and coefficients
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/app_graph1_R13.gph ///
		./out/analysis/temp/app_graph1_R14.gph ///
		./out/analysis/temp/app_graph1_R15.gph ///
		./out/analysis/temp/app_graph2_R13.gph ///
		./out/analysis/temp/app_graph2_R14.gph ///
		./out/analysis/temp/app_graph2_R15.gph ///
		./out/analysis/temp/app_graph1_R16.gph ///
		./out/analysis/temp/app_graph1_R17.gph ///
		./out/analysis/temp/app_graph1_R18.gph ///
		./out/analysis/temp/app_graph2_R16.gph ///
		./out/analysis/temp/app_graph2_R17.gph ///
		./out/analysis/temp/app_graph2_R18.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_R13.gph) ///
		 graphregion(color(white)) 

graph display, ysize(7) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R13-R18.pdf", replace

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* COEFFICIENTS GRAPH 1 *

** Coefficient Table R13 - R14 **
esttab left1_R13 right1_R13 diff1_R13 left1_R14 right1_R14 diff1_R14 ///
using ./out/analysis/applications/app_graph1_R13-R14_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R13 - R14")

** Coefficient Table R15 - R16 **
esttab left1_R15 right1_R15 diff1_R15 left1_R16 right1_R16 diff1_R16 ///
using ./out/analysis/applications/app_graph1_R15-R16_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - R15 - R16")

** Coefficient Table R17 - R18 **
esttab left1_R17 right1_R17 diff1_R17 left1_R18 right1_R18 diff1_R18 ///
using ./out/analysis/applications/app_graph1_R17-R18_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model R17 - R18")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table R13 - R14 **
esttab left2_R13 right2_R13 diff2_R13 left2_R14 right2_R14 diff2_R14 ///
using ./out/analysis/applications/app_graph2_R13-R14_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R13 - R14")

** Coefficient Table R15 - R16 **
esttab left2_R15 right2_R15 diff2_R15 left2_R16 right2_R16 diff2_R16 ///
using ./out/analysis/applications/app_graph2_R15-R16_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - R15 - R16")

** Coefficient Table R17 - R18 **
esttab left2_R17 right2_R17 diff2_R17 left2_R18 right2_R18 diff2_R18 ///
using ./out/analysis/applications/app_graph2_R17-R18_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model R17 - R18")

