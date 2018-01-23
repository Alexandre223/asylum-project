**************************
** ==================== **
** APPLICATION ANALYSIS **
** ==================== **
**************************

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
		saving(./out/analysis/applications/app_summary_statistics.tex) replace



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
						$origin_variables $destination_variables log_av_app_pc5 ///
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
keep($origin_variables $bilateral_variables $destination_variables log_av_app_pc5 ///
	  policy_index_total policy_index_access policy_index_processing  ///
	  policy_index_welfare  cabinet_right $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $bilateral_variables $destination_variables log_av_app_pc5 ///
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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* Combine Graphs *
grc1leg ./out/analysis/temp/app_graph1_baseline.gph ///
		./out/analysis/temp/app_graph2_baseline.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(3) xsize(1.5) 		 
graph export  "./out/analysis/applications/app_graphs_baseline.pdf", replace



******************************
** Coefficients for graph 2 **
******************************

* Define gobals 
global left left
global right right

do ./src/analysis/modules/graph_2_coef.do

esttab left right ///
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


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R1.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R1.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global graph_title1 "(R2)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R2.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc5
global graph_title1 "(R3)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R3.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (R4) Include cabinet right dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right
global graph_title1 "(R4)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R4.gph"

* Produce graphs
do ./src/analysis/modules/graph_1_cabinet_right.do
do ./src/analysis/modules/graph_2_cabinet_right.do

* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  policy_index_total
global graph_title1 "(R5)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R5.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  ///
							  policy_index_access policy_index_processing ///
							  policy_index_welfare  
global graph_title1 "(R6)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R6.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R1-R6.pdf", replace



*********************************
** COEFFICIENT TABLES, R1 - R3 **
*********************************

eststo clear

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
global left left_R1
global right right_R1

do ./src/analysis/modules/graph_2_coef.do

* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global left left_R2
global right right_R2

do ./src/analysis/modules/graph_2_coef.do


* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc5
global left left_R3
global right right_R3

do ./src/analysis/modules/graph_2_coef.do

esttab left_R1 right_R1 left_R2 right_R2 left_R3 right_R3 ///
using ./out/analysis/applications/app_graph2_R1-R3_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R1 - R3")


*********************************
** COEFFICIENT TABLES, R4 - R6 **
*********************************

eststo clear

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R4) Do not include cabinet right dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right
global left left_R4
global right right_R4

do ./src/analysis/modules/graph_2_coef_cabinet_right.do

* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  policy_index_total
global left left_R5
global right right_R5

do ./src/analysis/modules/graph_2_coef.do


* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  ///
							  policy_index_access policy_index_processing ///
							  policy_index_welfare  
global left left_R6
global right right_R6

do ./src/analysis/modules/graph_2_coef.do

esttab left_R4 right_R4 left_R5 right_R5 left_R6 right_R6 ///
using ./out/analysis/applications/app_graph2_R4-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R4 - R6")



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


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R7.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R7.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R8) Do not use lags for origin country variables 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig
global graph_title1 "(R8)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R8.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R8.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R9) Use Syrian battle death data from UCDP

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 
global graph_title1 "(R9)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R9.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R9.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R10) Include a post 2007 dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  post_2007
global graph_title1 "(R10)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R10.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R10.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R11) Cluster standard errors on destination*origin level

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global se_clus DO 
global graph_title1 "(R11)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R11.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R11.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R12.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R12.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R7-R12.pdf", replace



*********************************
** COEFFICIENT TABLES, R7 - R9 **
*********************************

eststo clear

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R7) Use log first-time applications per capita in origin country as dependent variable

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_pc_origin 
global left left_R7
global right right_R7

do ./src/analysis/modules/graph_2_coef.do


* (R8) Do not use lags for origin country variables 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig
global left left_R8
global right right_R8

do ./src/analysis/modules/graph_2_coef.do


* (R9) Use Syrian battle death data from UCDP

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 
global left left_R9
global right right_R9

do ./src/analysis/modules/graph_2_coef.do

esttab left_R7 right_R7 left_R8 right_R8 left_R9 right_R9 ///
using ./out/analysis/applications/app_graph2_R7-R9_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R7 - R9")


***********************************
** COEFFICIENT TABLES, R10 - R12 **
***********************************

eststo clear

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R10) Include a post 2007 dummy 

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  post_2007
global left left_R10
global right right_R10

do ./src/analysis/modules/graph_2_coef.do


* (R11) Cluster standard errors on destination*origin level

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global se_clus DO 
global left left_R11
global right right_R11

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
global left left_R12
global right right_R12

do ./src/analysis/modules/graph_2_coef.do

esttab left_R10 right_R10 left_R11 right_R11 left_R12 right_R12 ///
using ./out/analysis/applications/app_graph2_R10-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R10 - R12")



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

* (R17) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 5 quarters
do ./src/analysis/modules/globals_interactions_Q5.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R18) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 4 quarters
do ./src/analysis/modules/globals_interactions_Q4.do

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
keep($origin_variables $destination_variables $interactions_left_m1 ///
	 $interactions_right_m1) ///
order($origin_variables $destination_variables $interactions_left_m1 ///
	  $interactions_right_m1) ///
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

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R13.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R13.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

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

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R14.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R14.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R15.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R15.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R16.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R16.gph"

* Produce graphs  
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R17) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/modules/globals_interactions_Q5.do 
global graph_title1 "(R17)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R17.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R17.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2_Q5.do


* (R18) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/modules/globals_interactions_Q4.do 
global graph_title1 "(R18)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R18.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R18.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2_Q4.do


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

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R13-R18.pdf", replace


***********************************
** COEFFICIENT TABLES, R13 - R15 **
***********************************

eststo clear
* (R13) Use normalized cabinet position to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_R13
global right right_R13

do ./src/analysis/modules/graph_2_coef.do


* (R14) Slpit cabinet position at 5 to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_cabinet_split_at_5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_R14
global right right_R14

do ./src/analysis/modules/graph_2_coef.do

* (R15) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_R15
global right right_R15

do ./src/analysis/modules/graph_2_coef.do

esttab left_R13 right_R13 left_R14 right_R14 left_R15 right_R15 ///
using ./out/analysis/applications/app_graph2_R13-R15_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R13 - R15")



***********************************
** COEFFICIENT TABLES, R16 - R18 **
***********************************
eststo clear

* (R16) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_R16
global right right_R16

do ./src/analysis/modules/graph_2_coef.do


* (R17) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/modules/globals_interactions_Q5.do 
global left left_R17
global right right_R17

do ./src/analysis/modules/graph_2_coef_Q5.do


* (R18) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/modules/globals_interactions_Q4.do 
global left left_R18
global right right_R18

do ./src/analysis/modules/graph_2_coef_Q4.do

esttab left_R16 right_R16 left_R17 right_R17 left_R18 right_R18 ///
using ./out/analysis/applications/app_graph2_R16-R18_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep(bef6 bef5 bef4 bef3 bef2 bef1 election ///
	post1 post2 post3 post4 post5 post6) ///
	title("Coefficients R16 - R18")



** ========================== **
** ROBUSTNESS TABLE 1 R19-R22 **
** ========================== **

eststo clear

* (R19) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables parl_nationalist ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R20) Add share of seats of right-wing parties in parliament

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables share_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R21) Control for lag total first-time applications in the previous 6 quarters

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R22) use only countries that are also in decision analysis
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

 
esttab using "./out/analysis/applications/app_table1_R19-R22.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 parl_nationalist share_right ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 parl_nationalist share_right ///
	  $interactions_left_m1 $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


**************************
** Graphs for R19 - R22 **
**************************

* (R19) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  parl_nationalist
global graph_title1 "(R19)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R19.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R19.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R20) Add dummy for right-wing party in parliament 

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  share_right
global graph_title1 "(R20)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R20.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R20.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R21) Control for lag of dependent variable

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_pc_mean6
global graph_title1 "(R21)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R21.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R21.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* (R22) use only countries that are also in the baseline decision analysis
* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global graph_title1 "(R22)"
global graph_title2 ""

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R22.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R22.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


* COMBINE GRAPHS *
grc1leg ./out/analysis/temp/app_graph1_R19.gph ///
		./out/analysis/temp/app_graph1_R20.gph ///
		./out/analysis/temp/app_graph2_R19.gph ///
		./out/analysis/temp/app_graph2_R20.gph ///
		./out/analysis/temp/app_graph1_R21.gph ///
		./out/analysis/temp/app_graph1_R22.gph ///
		./out/analysis/temp/app_graph2_R21.gph ///
		./out/analysis/temp/app_graph2_R22.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_R19.gph) ///
		 graphregion(color(white)) 

graph display, ysize(8) xsize(6) 		 
graph export "./out/analysis/applications/app_graphs_R19-R22.pdf", replace


***********************************
** COEFFICIENT TABLES, R19 - R22 **
***********************************

eststo clear

* (R19) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  parl_nationalist
global left left_R19
global right right_R19

do ./src/analysis/modules/graph_2_coef.do


* (R20) Add dummy for right-wing party in parliament 

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  share_right
global left left_R20
global right right_R20

do ./src/analysis/modules/graph_2_coef.do


* (R21) Control for lag of dependent variable

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_firsttimeapp_total_pc_mean6
global left left_R21
global right right_R21

do ./src/analysis/modules/graph_2_coef.do


* (R22) use only countries that are also in the baseline decision analysis

* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_R22
global right right_R22

do ./src/analysis/modules/graph_2_coef.do

esttab left_R19 right_R19 left_R20 right_R20 left_R21 right_R21 left_R22 right_R22 ///
using ./out/analysis/applications/app_graph2_R19-R22_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R19 - R22")

