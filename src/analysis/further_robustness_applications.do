*** ============================ ***
*** ADDITIONAL ROBUSTNESS CHECKS ***
*** ============================ ***


* ============================================== *
**************************************************
**  Try different versions of past applications **
**************************************************
* ============================================== *
 

************************************************************
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

* (1) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app1_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (2) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app2_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (3) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app3_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (4) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app4_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (5) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app5_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/applications/additional_robustness/app_table1_past_applications.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_av_app1_pc ///
	  log_av_app2_pc log_av_app3_pc log_av_app4_pc log_av_app5_pc $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $destination_variables log_av_app1_pc ///
	  log_av_app2_pc log_av_app3_pc log_av_app4_pc log_av_app5_pc $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


** ===================================================================== **
** GRAPHS FOR RUBUSTNESS CHECKS WITH DIFFERENT LAGS OF PAST APPLICATIONS **
** ===================================================================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* Baseline

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_baseline.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_baseline.gph"
global graph_title1 "Baseline"
global graph_title2 ""

global left1 left1_base
global right1 right1_base
global diff1 diff1_base

global left2 left2_base
global right2 right2_base
global diff2 diff2_base

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (1) Control for past asylum applications lag 1

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app1_pc
global graph_title1 "(lag 1)"
global graph_title2 ""

global left1 left1_lag1
global right1 right1_lag1
global diff1 diff1_lag1

global left2 left2_lag1
global right2 right2_lag1
global diff2 diff2_lag1

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag1.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag1.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (2) Control for past asylum applications lag 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app2_pc
global graph_title1 "(lag 2)"
global graph_title2 ""

global left1 left1_lag2
global right1 right1_lag2
global diff1 diff1_lag2

global left2 left2_lag2
global right2 right2_lag2
global diff2 diff2_lag2

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag2.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag2.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (3) Control for past asylum applications lag 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app3_pc
global graph_title1 "(lag 3)"
global graph_title2 ""

global left1 left1_lag3
global right1 right1_lag3
global diff1 diff1_lag3

global left2 left2_lag3
global right2 right2_lag3
global diff2 diff2_lag3

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag3.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag3.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (4) Control for past asylum applications lag 4

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app4_pc
global graph_title1 "(lag 4)"
global graph_title2 ""

global left1 left1_lag4
global right1 right1_lag4
global diff1 diff1_lag4

global left2 left2_lag4
global right2 right2_lag4
global diff2 diff2_lag4

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag4.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag4.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (5) Control for past asylum applications lag 5

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app5_pc
global graph_title1 "(lag 5)"
global graph_title2 ""

global left1 left1_lag5
global right1 right1_lag5
global diff1 diff1_lag5

global left2 left2_lag5
global right2 right2_lag5
global diff2 diff2_lag5

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag5.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag5.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/app_graph1_baseline.gph ///
		./out/analysis/temp/app_graph1_lag1.gph ///
		./out/analysis/temp/app_graph1_lag2.gph ///
		./out/analysis/temp/app_graph2_baseline.gph ///
		./out/analysis/temp/app_graph2_lag1.gph ///
		./out/analysis/temp/app_graph2_lag2.gph ///
		./out/analysis/temp/app_graph1_lag3.gph ///
		./out/analysis/temp/app_graph1_lag4.gph ///
		./out/analysis/temp/app_graph1_lag5.gph ///
		./out/analysis/temp/app_graph2_lag3.gph ///
		./out/analysis/temp/app_graph2_lag4.gph ///
		./out/analysis/temp/app_graph2_lag5.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/additional_robustness/app_graphs_past_applications.pdf", replace

********************************************
** COEFFICIENT TABLES, past applications  **
********************************************

* COEFFICIENTS GRAPH 1 *

** Coefficient Table base - lag1 **
esttab left1_base right1_base diff1_base left1_lag1 right1_lag1 diff1_lag1 ///
using ./out/analysis/applications/additional_robustness/app_graph1_base-lag1_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - base - lag1")

** Coefficient Table lag2 - lag3 **
esttab left1_lag2 right1_lag2 diff1_lag2 left1_lag3 right1_lag3 diff1_lag3 ///
using ./out/analysis/applications/additional_robustness/app_graph1_lag2-lag3_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - lag2 - lag3")

** Coefficient Table lag4 - lag5 **
esttab left1_lag4 right1_lag4 diff1_lag4 left1_lag5 right1_lag5 diff1_lag5 ///
using ./out/analysis/applications/additional_robustness/app_graph1_lag4-lag5_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model lag4 - lag5")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table base - lag1 **
esttab left2_base right2_base diff2_base left2_lag1 right2_lag1 diff2_lag1 ///
using ./out/analysis/applications/additional_robustness/app_graph2_base-lag1_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - base - lag1")

** Coefficient Table lag2 - lag3 **
esttab left2_lag2 right2_lag2 diff2_lag2 left2_lag3 right2_lag3 diff2_lag3 ///
using ./out/analysis/applications/additional_robustness/app_graph2_lag2-lag3_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - lag2 - lag3")

** Coefficient Table lag4 - lag5 **
esttab left2_lag4 right2_lag4 diff2_lag4 left2_lag5 right2_lag5 diff2_lag5 ///
using ./out/analysis/applications/additional_robustness/app_graph2_lag4-lag5_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model lag4 - lag5")



* ========================================================= *
*************************************************************
**  Try different versions of past first-time applications **
*************************************************************
* ========================================================= *

***************
*** Table 1 ***
***************

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

* (1) Control for past 6 quarters total first-time asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (2) Control for past 6 quarters dyadic first-time asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_dyadic_mean6_pc ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (3) Control for past 6 quarters total and dyadic first-time asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
						log_firsttimeapp_dyadic_mean6_pc $interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/applications/additional_robustness/app_table1_past_ft-applications.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_firsttimeapp_total_mean6_pc ///
		log_firsttimeapp_dyadic_mean6_pc $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $destination_variables  log_firsttimeapp_total_mean6_pc ///
		log_firsttimeapp_dyadic_mean6_pc $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita)


** =============================================================================== **
** GRAPHS FOR RUBUSTNESS CHECKS WITH PAST TOTAL AND DYADIC FIRST-TIME APPLICATIONS **
** =============================================================================== **

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


* Baseline

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_baseline.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_baseline.gph"
global graph_title1 "Baseline"
global graph_title2 ""

global left1 left1_base
global right1 right1_base
global diff1 diff1_base

global left2 left2_base
global right2 right2_base
global diff2 diff2_base

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (1) Control for past 6 quarters total first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_mean6_pc
global graph_title1 "(lag total)"
global graph_title2 ""

global left1 left1_total
global right1 right1_total
global diff1 diff1_total

global left2 left2_total
global right2 right2_total
global diff2 diff2_total

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_total.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_total.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (2) Control for past 6 quarters dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_dyadic_mean6_pc
global graph_title1 "(lag dyadic)"
global graph_title2 ""

global left1 left1_dyadic
global right1 right1_dyadic
global diff1 diff1_dyadic

global left2 left2_dyadic
global right2 right2_dyadic
global diff2 diff2_dyadic

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_dyadic.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_dyadic.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (3) Control for past 6 quarters total and dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_mean6_pc log_firsttimeapp_dyadic_mean6_pc
global graph_title1 "(lag both)"
global graph_title2 ""

global left1 left1_both
global right1 right1_both
global diff1 diff1_both

global left2 left2_both
global right2 right2_both
global diff2 diff2_both

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_both.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_both.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do


* COMBINE GRAPHS *

grc1leg ./out/analysis/temp/app_graph1_baseline.gph ///
		./out/analysis/temp/app_graph1_lag_total.gph ///
		./out/analysis/temp/app_graph2_baseline.gph ///
		./out/analysis/temp/app_graph2_lag_total.gph ///
		./out/analysis/temp/app_graph1_lag_dyadic.gph ///
		./out/analysis/temp/app_graph1_lag_both.gph ///
		./out/analysis/temp/app_graph2_lag_dyadic.gph ///
		./out/analysis/temp/app_graph2_lag_both.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(4) 		 
graph export "./out/analysis/applications/additional_robustness/app_graphs_past_ft-applications.pdf", replace



**************************************************************************
** COEFFICIENT TABLES, past first-time applications total, dyadic, both **
**************************************************************************


* COEFFICIENTS GRAPH 1 *

** Coefficient Table base - total**
esttab left1_base right1_base diff1_base left1_total right1_total diff1_total ///
using ./out/analysis/applications/additional_robustness/app_graph1_base-total_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - base - lag1")

** Coefficient Table dyadic- both **
esttab left1_dyadic right1_dyadic diff1_dyadic left1_both right1_both diff1_both ///
using ./out/analysis/applications/additional_robustness/app_graph1_dyadic-both_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - dyadic- both")



* COEFFICIENTS GRAPH 2 *

** Coefficient Table base - total**
esttab left2_base right2_base diff2_base left2_total right2_total diff2_total ///
using ./out/analysis/applications/additional_robustness/app_graph2_base-total_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - base - lag1")

** Coefficient Table dyadic- both **
esttab left2_dyadic right2_dyadic diff2_dyadic left2_both right2_both diff2_both ///
using ./out/analysis/applications/additional_robustness/app_graph2_dyadic-both_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - dyadic- both")




* ================================ **
*************************************
**  Try different country samples  **
*************************************
* ================================ **

***************
*** Table 1 ***
***************

eststo clear

* (1) Baseline
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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

* (2) Use all countries with maxiumum 2 years missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/all_max_two_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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

* (3) Use only countries which have no missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/no_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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

* (4) Add Cyprus to baseline sample

* Specify data set to be used *
use ./out/data/final_application/baseline_plus_Cyprus.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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


* (5) Use only countries that have at most 1 early election

* Specify data set to be used *
use ./out/data/final_application/few_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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

* (6) Use only countries that have no early elections

* Specify data set to be used *
use ./out/data/final_application/no_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

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

esttab using "./out/analysis/applications/additional_robustness/app_table1_other_samples.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $destination_variables $interactions_left_m1 ///
	  $interactions_right_m1) ///
title(Determinants of first-time asylum applications per capita - other samples)


** ===================================================================== **
** GRAPHS FOR RUBUSTNESS CHECKS WITH OTHER DESTINATION SAMPLES AND YEARS **
** ===================================================================== **


* Baseline

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_baseline.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_baseline.gph"
global graph_title1 "Baseline"
global graph_title2 ""

global left1 left1_base
global right1 right1_base
global diff1 diff1_base

global left2 left2_base
global right2 right2_base
global diff2 diff2_base

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do



* (2) Use all countries with maxiumum 2 years missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/all_max_two_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_max_two_missings.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_max_two_missings.gph"
global graph_title1 "max two missings"
global graph_title2 ""

global left1 left1_max_two_missings
global right1 right1_max_two_missings
global diff1 diff1_max_two_missings

global left2 left2_max_two_missings
global right2 right2_max_two_missings
global diff2 diff2_max_two_missings

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (3) Use only countries which have no missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/no_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_no_missings.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_no_missings.gph"
global graph_title1 "no missings"
global graph_title2 ""

global left1 left1_no_missings
global right1 right1_no_missings
global diff1 diff1_no_missings

global left2 left2_no_missings
global right2 right2_no_missings
global diff2 diff2_no_missings

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (4) Add Cyprus to baseline sample

* Specify data set to be used *
use ./out/data/final_application/baseline_plus_Cyprus.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_plus_Cyprus.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_plus_Cyprus.gph"
global graph_title1 "plus Cyprus"
global graph_title2 ""

global left1 left1_Cyprus
global right1 right1_Cyprus
global diff1 diff1_Cyprus

global left2 left2_Cyprus
global right2 right2_Cyprus
global diff2 diff2_Cyprus

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (5) Use only countries that have at most 1 early election

* Specify data set to be used *
use ./out/data/final_application/few_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_few_early_elections.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_few_early_elections.gph"
global graph_title1 "max 1 early election"
global graph_title2 ""

global left1 left1_few_early
global right1 right1_few_early
global diff1 diff1_few_early

global left2 left2_few_early
global right2 right2_few_early
global diff2 diff2_few_early

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

* (6) Use only countries that have no early elections

* Specify data set to be used *
use ./out/data/final_application/no_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_no_early_elections.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_no_early_elections.gph"
global graph_title1 "no early elections"
global graph_title2 ""

global left1 left1_no_early
global right1 right1_no_early
global diff1 diff1_no_early

global left2 left2_no_early
global right2 right2_no_early
global diff2 diff2_no_early

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_1_coef.do
do ./src/analysis/modules/graph_2_coef.do

grc1leg ./out/analysis/temp/app_graph1_baseline.gph ///
		./out/analysis/temp/app_graph1_max_two_missings.gph ///
		./out/analysis/temp/app_graph1_no_missings.gph ///
		./out/analysis/temp/app_graph2_baseline.gph ///
		./out/analysis/temp/app_graph2_max_two_missings.gph ///
		./out/analysis/temp/app_graph2_no_missings.gph ///
		./out/analysis/temp/app_graph1_plus_Cyprus.gph ///
		./out/analysis/temp/app_graph1_few_early_elections.gph ///
		./out/analysis/temp/app_graph1_no_early_elections.gph ///
		./out/analysis/temp/app_graph2_plus_Cyprus.gph ///
		./out/analysis/temp/app_graph2_few_early_elections.gph ///
		./out/analysis/temp/app_graph2_no_early_elections.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_baseline.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/additional_robustness/app_graphs_other_samples.pdf", replace



*****************************************
** COEFFICIENT TABLES, other samples   **
*****************************************

* COEFFICIENTS GRAPH 1 *

** Coefficient Table base - max_two_missings **
esttab left1_base right1_base diff1_base left1_max_two_missings right1_max_two_missings diff1_max_two_missings ///
using ./out/analysis/applications/additional_robustness/app_graph1_base-max_two_missings_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - base - max_two_missings")

** Coefficient Table no_missings - Cyprus **
esttab left1_no_missings right1_no_missings diff1_no_missings left1_Cyprus right1_Cyprus diff1_Cyprus ///
using ./out/analysis/applications/additional_robustness/app_graph1_no_missings-Cyprus_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model - no_missings - Cyprus")

** Coefficient Table few_early - no_early **
esttab left1_few_early right1_few_early diff1_few_early left1_no_early right1_no_early diff1_no_early ///
using ./out/analysis/applications/additional_robustness/app_graph1_few_early-no_early_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m1) title("Coefficients before after model few_early - no_early")


* COEFFICIENTS GRAPH 2 *

** Coefficient Table base - max_two_missings **
esttab left2_base right2_base diff2_base left2_max_two_missings right2_max_two_missings diff2_max_two_missings ///
using ./out/analysis/applications/additional_robustness/app_graph2_base-max_two_missings_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - base - max_two_missings")

** Coefficient Table no_missings - Cyprus **
esttab left2_no_missings right2_no_missings diff2_no_missings left2_Cyprus right2_Cyprus diff2_Cyprus ///
using ./out/analysis/applications/additional_robustness/app_graph2_no_missings-Cyprus_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - no_missings - Cyprus")

** Coefficient Table few_early - no_early **
esttab left2_few_early right2_few_early diff2_few_early left2_no_early right2_no_early diff2_no_early ///
using ./out/analysis/applications/additional_robustness/app_graph2_few_early-no_early_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model few_early - no_early")




