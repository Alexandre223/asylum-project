*** ============================ ***
*** ADDITIONAL ROBUSTNESS CHECKS ***
*** ============================ ***


**  Try different versions of past applications **

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
						$origin_variables $destination_variables log_av_app_pc1 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (2) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc2 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (3) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc3 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (4) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc4 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (5) Control for past asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_av_app_pc5 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/applications/additional_robustness/app_table1_past_applications.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_av_app_pc1 ///
	  log_av_app_pc2 log_av_app_pc3 log_av_app_pc4 log_av_app_pc5 $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $destination_variables log_av_app_pc1 ///
	  log_av_app_pc2 log_av_app_pc3 log_av_app_pc4 log_av_app_pc5 $interactions_left_m1 ///
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
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc1
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
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc2
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
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc3
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
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc4
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
global destination_variables log_rGDPpc_dest unemployment  log_av_app_pc5
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





**  Try different versions of past first-time applications **

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
						$origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (2) Control for past 6 quarters dyadic first-time asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_dyadic_pc_mean6 ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

* (3) Control for past 6 quarters total and dyadic first-time asylum applications
xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 ///
						log_firsttimeapp_dyadic_pc_mean6 $interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

 
esttab using "./out/analysis/applications/additional_robustness/app_table1_past_ft-applications.tex", ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables log_firsttimeapp_total_pc_mean6 ///
		log_firsttimeapp_dyadic_pc_mean6 $interactions_left_m1 ///
	  $interactions_right_m1) ///
order($origin_variables $destination_variables  log_firsttimeapp_total_pc_mean6 ///
		log_firsttimeapp_dyadic_pc_mean6 $interactions_left_m1 ///
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
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_total_pc_mean6
global graph_title1 "(lag total)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_total.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_total.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (2) Control for past asylum applications lag 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment log_firsttimeapp_dyadic_pc_mean6
global graph_title1 "(lag dyadic)"
global graph_title2 ""


* Define gobals for output paths
global path_graph1_temp "./out/analysis/temp/app_graph1_lag_dyadic.gph"
global path_graph2_temp "./out/analysis/temp/app_graph2_lag_dyadic.gph"

* Produce graphs
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_2.do

* (3) Control for past asylum applications lag 3

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define globals
global destination_variables log_rGDPpc_dest unemployment ///
		log_firsttimeapp_total_pc_mean6 log_firsttimeapp_dyadic_pc_mean6
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
