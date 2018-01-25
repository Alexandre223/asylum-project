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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (1) Control for past asylum applications lag 1

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app1_pc
global graph_title1 "(lag 1)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag1.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag1.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (2) Control for past asylum applications lag 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app2_pc
global graph_title1 "(lag 2)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag2.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag2.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (3) Control for past asylum applications lag 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app3_pc
global graph_title1 "(lag 3)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag3.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag3.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (4) Control for past asylum applications lag 4

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app4_pc
global graph_title1 "(lag 4)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag4.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag4.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (5) Control for past asylum applications lag 5

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment  log_av_app5_pc
global graph_title1 "(lag 5)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag5.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag5.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

*******************************************************
** COEFFICIENT TABLES, past applications lag1 - lag4 **
*******************************************************

eststo clear

* (1) Control for past asylum applications lag 1
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_av_app1_pc
global left left_lag1
global right right_lag1

do ./src/analysis/modules/graph_2_coef.do


* (2) Control for past asylum applications lag 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_av_app2_pc
global left left_lag2
global right right_lag2

do ./src/analysis/modules/graph_2_coef.do


* (3) Control for past asylum applications lag 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_av_app3_pc
global left left_lag3
global right right_lag3

do ./src/analysis/modules/graph_2_coef.do


* (4) Control for past asylum applications lag 4

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_av_app4_pc
global left left_lag4
global right right_lag4

do ./src/analysis/modules/graph_2_coef.do

esttab left_lag1 right_lag1 left_lag2 right_lag2 left_lag3 right_lag3 left_lag4 right_lag4 ///
using ./out/analysis/applications/additional_robustness/app_graph2_past_applications_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - total applications lag1 - lag4")



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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (1) Control for past 6 quarters total first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_mean6_pc
global graph_title1 "(lag total)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_total.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_total.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (2) Control for past 6 quarters dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_dyadic_mean6_pc
global graph_title1 "(lag dyadic)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_dyadic.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_dyadic.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (3) Control for past 6 quarters total and dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_mean6_pc log_firsttimeapp_dyadic_mean6_pc
global graph_title1 "(lag both)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_both.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_both.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

eststo clear

* (1) Control for past 6 quarters total first-time asylum applications
* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_mean6_pc
global left left_lag_total
global right right_lag_total

do ./src/analysis/modules/graph_2_coef.do


* (2) Control for past 6 quarters dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_dyadic_mean6_pc
global left left_lag_dyadic
global right right_lag_dyadic

do ./src/analysis/modules/graph_2_coef.do


* (3) Control for past 6 quarters total and dyadic first-time asylum applications

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_mean6_pc log_firsttimeapp_dyadic_mean6_pc
global left left_lag_both
global right right_lag_both

do ./src/analysis/modules/graph_2_coef.do


esttab left_lag_total right_lag_total left_lag_dyadic right_lag_dyadic left_lag_both right_lag_both ///
using ./out/analysis/applications/additional_robustness/app_graph2_past_ft-applications_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - past first-time applications")



* ========================================== *
**********************************************
**  Try different country samples and years **
**********************************************
* ========================================== *

***************
*** Table 1 ***
***************

eststo clear

* (1) Include years 2015 and 2016

* Specify data set to be used *
use ./out/data/final_application/baseline_2016.dta, clear

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

* (1) Include years 2015 and 2016

* Specify data set to be used *
use ./out/data/final_application/baseline_2016.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_2016.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_2016.gph"
global graph_title1 "2002 - 2016"
global graph_title2 ""

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do


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

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

grc1leg ./out/analysis/temp/app_graph1_2016.gph ///
		./out/analysis/temp/app_graph1_max_two_missings.gph ///
		./out/analysis/temp/app_graph1_no_missings.gph ///
		./out/analysis/temp/app_graph2_2016.gph ///
		./out/analysis/temp/app_graph2_max_two_missings.gph ///
		./out/analysis/temp/app_graph2_no_missings.gph ///
		./out/analysis/temp/app_graph1_plus_Cyprus.gph ///
		./out/analysis/temp/app_graph1_few_early_elections.gph ///
		./out/analysis/temp/app_graph1_no_early_elections.gph ///
		./out/analysis/temp/app_graph2_plus_Cyprus.gph ///
		./out/analysis/temp/app_graph2_few_early_elections.gph ///
		./out/analysis/temp/app_graph2_no_early_elections.gph, ///
		row(4) legendfrom(./out/analysis/temp/app_graph1_2016.gph) ///
		 graphregion(color(white)) 

graph display, ysize(5) xsize(6) 		 
graph export "./out/analysis/applications/additional_robustness/app_graphs_other_samples.pdf", replace



*****************************************
** COEFFICIENT TABLES, other samples 1 **
*****************************************

eststo clear

* (1) Include years 2015 and 2016

* Specify data set to be used *
use ./out/data/final_application/baseline_2016.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_2016
global right right_2016

do ./src/analysis/modules/graph_2_coef.do



* (2) Use all countries with maxiumum 2 years missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/all_max_two_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_max_two_missings
global right right_max_two_missings

do ./src/analysis/modules/graph_2_coef.do


* (3) Use only countries which have no missing first-time application data

* Specify data set to be used *
use ./out/data/final_application/no_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_no_missings
global right right_no_missings

do ./src/analysis/modules/graph_2_coef.do

esttab left_2016 right_2016 left_max_two_missings right_max_two_missings left_no_missings right_no_missings ///
using ./out/analysis/applications/additional_robustness/app_graph2_past_other_samples_1_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - other samples 1 - 3")


*****************************************
** COEFFICIENT TABLES, other samples 2 **
*****************************************

eststo clear

* (4) Add Cyprus to baseline sample

* Specify data set to be used *
use ./out/data/final_application/baseline_plus_Cyprus.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_Cyprus
global right right_Cyprus

do ./src/analysis/modules/graph_2_coef.do


* (5) Use only countries that have at most 1 early election

* Specify data set to be used *
use ./out/data/final_application/few_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_few_early
global right right_few_early

do ./src/analysis/modules/graph_2_coef.do


* (6) Use only countries that have no early elections

* Specify data set to be used *
use ./out/data/final_application/no_early_elections.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global left left_no_early
global right right_no_early

do ./src/analysis/modules/graph_2_coef.do

esttab left_Cyprus right_Cyprus left_few_early right_few_early left_no_early right_no_early ///
using ./out/analysis/applications/additional_robustness/app_graph2_past_other_samples_2_coef.tex, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title("Coefficients quarterly model - other samples 4 - 6")
