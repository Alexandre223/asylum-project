** ========================================== **
** APPLICATION ROBUSTNESS CHECKS FOR APPENDIX **
** ========================================== **

** ===================================== **
** GRAPHS FOR RUBUSTNESS CHECKS IN PAPER **
** ===================================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R1) Origin, destination and time fixed effects 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D
global graph_title "(R1)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R1.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R1.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global graph_title "(R2)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R2.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R2.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right log_av_app_pc
global graph_title "(R3)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R3.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R3.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R4) Do not include cabinet right dummy 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment
global graph_title "(R4)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R4.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R4.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2.do


* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right policy_index_total
global graph_title "(R5)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R5.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R5.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right ///
							  policy_index_access policy_index_processing ///
							  policy_index_welfare  
global graph_title "(R6)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R6.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R6.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* COMBINE GRAPHS *

* Graph 1 *
grc1leg ./out/analysis/temp/app_graph1_R1.gph ///
		./out/analysis/temp/app_graph1_R2.gph ///
		./out/analysis/temp/app_graph1_R3.gph ///
		./out/analysis/temp/app_graph1_R4.gph ///
		./out/analysis/temp/app_graph1_R5.gph ///
		./out/analysis/temp/app_graph1_R6.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R1-R6_graph1.pdf", replace

* Graph 2 *
grc1leg ./out/analysis/temp/app_graph2_R1.gph ///
		./out/analysis/temp/app_graph2_R2.gph ///
		./out/analysis/temp/app_graph2_R3.gph ///
		./out/analysis/temp/app_graph2_R4.gph ///
		./out/analysis/temp/app_graph2_R5.gph ///
		./out/analysis/temp/app_graph2_R6.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph2_R1.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R1-R6_graph2.pdf", replace


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
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global xt_main O
global fe_var i.T i.D
global left left_R1
global right right_R1

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

* (R2) Origin * time and destination fixed effects  

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global xt_main OT
global fe_var i.D
global left left_R2
global right right_R2

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R3) Control for past asylum applications

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right log_av_app_pc
global left left_R3
global right right_R3

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R1 right_R1 left_R2 right_R2 left_R3 right_R3 ///
using ./out/analysis/final/appendix/app_graph2_R1-R3_coef.tex, ///
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
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment
global left left_R4
global right right_R4

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coefficients.do

* (R5) Add Hatton's policy index total

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right policy_index_total
global left left_R5
global right right_R5

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R6) Add Hatton's policy index access, welfare, processing

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right ///
							  policy_index_access policy_index_processing ///
							  policy_index_welfare  
global left left_R6
global right right_R6

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R4 right_R4 left_R5 right_R5 left_R6 right_R6 ///
using ./out/analysis/final/appendix/app_graph2_R4-R6_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R4 - R6")



** ================================== **
** ROBUSTNESS TABLE APPENDIX 1 R7-R12 **
** ================================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

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

* (R11) Use normalized cabinet position to determine cabinet left-right dummies 
* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

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
 
esttab using "./out/analysis/final/appendix/app_tableR7-R12_appendix.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $origin_variables1 $origin_variables2 $destination_variables post_2007 $interactions_left_m1 ///
	 $interactions_right_m1) ///
order($origin_variables $origin_variables1 $origin_variables2 $destination_variables post_2007  $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


********************************************
** Graphs for Robustness Table 1 R7 - R12 **
********************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R7) Use log first-time applications per capita in origin country as dependent variable

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_pc_origin 
global graph_title "(R7)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R7.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R7.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R8) Do not use lags for origin country variables 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig
global graph_title "(R8)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R8.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R8.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R9) Use Syrian battle death data from UCDP

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 
global graph_title "(R9)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R9.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R9.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R10) Include a post 2007 dummy 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right post_2007
global graph_title "(R10)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R10.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R10.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R11) Use normalized cabinet position to determine cabinet left-right dummies 

* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global graph_title "(R11)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R11.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R11.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R12) Do not impute first-time application data for 2008 and 2009

* Specify data set to be used *
use ./out/data/final_application/baseline_non_imputed_fta.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_NI_pc
global graph_title "(R12)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R12.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R12.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* COMBINE GRAPHS *

* Graph 1 *
grc1leg ./out/analysis/temp/app_graph1_R7.gph ///
		./out/analysis/temp/app_graph1_R8.gph ///
		./out/analysis/temp/app_graph1_R9.gph ///
		./out/analysis/temp/app_graph1_R10.gph ///
		./out/analysis/temp/app_graph1_R11.gph ///
		./out/analysis/temp/app_graph1_R12.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_R7.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R7-R12_graph1.pdf", replace

* Graph 2 *
grc1leg ./out/analysis/temp/app_graph2_R7.gph ///
		./out/analysis/temp/app_graph2_R8.gph ///
		./out/analysis/temp/app_graph2_R9.gph ///
		./out/analysis/temp/app_graph2_R10.gph ///
		./out/analysis/temp/app_graph2_R11.gph ///
		./out/analysis/temp/app_graph2_R12.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph2_R7.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(9) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R7-R12_graph2.pdf", replace


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
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_pc_origin 
global left left_R7
global right right_R7

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R8) Do not use lags for origin country variables 

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig
global left left_R8
global right right_R8

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R9) Use Syrian battle death data from UCDP

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global origin_variables PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 
global left left_R9
global right right_R9

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R7 right_R7 left_R8 right_R8 left_R9 right_R9 ///
using ./out/analysis/final/appendix/app_graph2_R7-R9_coef.tex, ///
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
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right post_2007
global left left_R10
global right right_R10

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R11) Use normalized cabinet position to determine cabinet left-right dummies 

* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global left left_R11
global right right_R11

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R12) Do not impute first-time application data for 2008 and 2009

* Specify data set to be used *
use ./out/data/final_application/baseline_non_imputed_fta.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global dependent_variable log_firsttimeapp_NI_pc 
global left left_R12
global right right_R12

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R10 right_R10 left_R11 right_R11 left_R12 right_R12 ///
using ./out/analysis/final/appendix/app_graph2_R10-R12_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R10 - R12")



** =================================== **
** ROBUSTNESS TABLE APPENDIX 2 R13-R16 **
** =================================== **

eststo clear

* (R13) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R14) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R15) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 5 quarters
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q5.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R16) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 4 quarters
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q4.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/final/appendix/app_tableR13-R16_appendix.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables $interactions_left_m1 ///
	 $interactions_right_m1) ///
order($origin_variables $destination_variables $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


*************************
** Graphs for R13- R16 **
*************************

* (R13) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global graph_title "(R13)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R13.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R13.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R14) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global graph_title "(R14)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R14.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R14.gph"

* Produce graphs  
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R15) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q5.do 
global graph_title "(R15)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R15.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R15.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_Q5.do


* (R16) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q4.do 
global graph_title "(R16)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R16.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R16.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right_Q4.do


* COMBINE GRAPHS *

* Graph 1 *
grc1leg ./out/analysis/temp/app_graph1_R13.gph ///
		./out/analysis/temp/app_graph1_R14.gph ///
		./out/analysis/temp/app_graph1_R15.gph ///
		./out/analysis/temp/app_graph1_R16.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_R13.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R13-R16_graph1.pdf", replace

* Graph 2 *
grc1leg ./out/analysis/temp/app_graph2_R13.gph ///
		./out/analysis/temp/app_graph2_R14.gph ///
		./out/analysis/temp/app_graph2_R15.gph ///
		./out/analysis/temp/app_graph2_R16.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph2_R13.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R13-R16_graph2.pdf", replace


***********************************
** COEFFICIENT TABLES, R13 - R16 **
***********************************

eststo clear

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* (R13) drop country pairs with less than 1 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global left left_R13
global right right_R13

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R14) drop country pairs with less than 3 application per quarter on average
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* Define globals for baseline analysis *
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global left left_R14
global right right_R14

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R15) use only 5 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q5.do 
global left left_R15
global right right_R15

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right_Q5.do


* (R16) use only 4 quarters around the election
* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
do ./src/analysis/final_analysis_for_paper/modules/globals_interactions_Q4.do 
global left left_R16
global right right_R16

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right_Q4.do

esttab left_R13 right_R13 left_R14 right_R14 left_R15 right_R15 left_R16 right_R16 ///
using ./out/analysis/final/appendix/app_graph2_R13-R16_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R13 - R16")



** =================================== **
** ROBUSTNESS TABLE APPENDIX 3 R17-R20 **
** =================================== **

eststo clear

* (R17) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables parl_nationalist ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R18) Add share of seats of right-wing parties in parliament

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables share_right ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R19) Cluster standard errors on destination*origin level
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster DO)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (R20) use only countries that are also in decision analysis
* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/final/appendix/app_tableR17-R20_appendix.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables parl_nationalist share_right ///
	 $interactions_left_m1 $interactions_right_m1) ///
order($origin_variables $destination_variables parl_nationalist share_right ///
	  $interactions_left_m1 $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


**************************
** Graphs for R17 - R20 **
**************************

* (R17) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right parl_nationalist
global graph_title "(R17)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R17.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R17.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R18) Add dummy for right-wing party in parliament 

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right share_right
global graph_title "(R18)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R18.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R18.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R19) Cluster standard errors on destination*origin level

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global se_clus DO 
global graph_title "(R19)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R19.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R19.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do


* (R20) use only countries that are also in the baseline decision analysis
* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global graph_title "(R20)"

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_R20.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_R20.gph"

* Produce graphs
do ./src/analysis/final_analysis_for_paper/modules/graph_1_cabinet_right.do
do ./src/analysis/final_analysis_for_paper/modules/graph_2_cabinet_right.do



* COMBINE GRAPHS *

* Graph 1 *
grc1leg ./out/analysis/temp/app_graph1_R17.gph ///
		./out/analysis/temp/app_graph1_R18.gph ///
		./out/analysis/temp/app_graph1_R19.gph ///
		./out/analysis/temp/app_graph1_R20.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph1_R17.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R17-R20_graph1.pdf", replace

* Graph 2 *
grc1leg ./out/analysis/temp/app_graph2_R17.gph ///
		./out/analysis/temp/app_graph2_R18.gph ///
		./out/analysis/temp/app_graph2_R19.gph ///
		./out/analysis/temp/app_graph2_R20.gph, ///
		row(2) legendfrom(./out/analysis/temp/app_graph2_R17.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) scale (*1,5)		 
graph export "./out/analysis/final/appendix/app_R17-R20_graph2.pdf", replace


***********************************
** COEFFICIENT TABLES, R17 - R20 **
***********************************

eststo clear

* (R17) Add dummy for right-wing party in parliament 
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right parl_nationalist
global left left_R17
global right right_R17

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R18) Add dummy for right-wing party in parliament 

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right share_right
global left left_R18
global right right_R18

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R19) Cluster standard errors on destination*origin level

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global se_clus DO  
global left left_R19
global right right_R19

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do


* (R20) use only countries that are also in the baseline decision analysis

* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/final_analysis_for_paper/modules/app_baseline_globals.do

* Define globals
global left left_R20
global right right_R20

do ./src/analysis/final_analysis_for_paper/modules/graph_2_coef_cabinet_right.do

esttab left_R17 right_R17 left_R18 right_R18 left_R19 right_R19 left_R20 right_R20 ///
using ./out/analysis/final/appendix/app_graph2_R17-R20_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients R17 - R20")
