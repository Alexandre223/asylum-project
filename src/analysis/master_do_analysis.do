*******************************
*** Master do file analysis ***
*******************************

clear 
set more off, permanently
cd F:/research/asylum-project


************************
** Summary statistics **
************************
do ./src/analysis/application_analysis/app_summary_statistics.do


**************************
** Application analysis **
**************************

* Baseline specification *
do ./src/analysis/application_analysis/app_baseline.do

* Robustness checks with baseline data *
do ./src/analysis/application_analysis/app_robustness_with_baseline_data.do

* Robustness checks with other datasets/samples *
do ./src/analysis/application_analysis/app_robustness_with_other_data.do

* Analysis by origin country region *
do ./src/analysis/application_analysis/app_by_region.do


/*
***********************
** Decision analysis **
***********************

** Acceptance rate **

* Baseline specification *
do ./src/analysis/decision_analysis/acceptance_baseline.do

* Robustness checks with baseline data *
do ./src/analysis/decision_analysis/dec_robustness_with_baseline_data.do

* Robustness checks with other datasets/samples *
do ./src/analysis/decision_analysis/dec_robustness_with_other_data.do

* Analysis by origin country region *
do ./src/analysis/decision_analysis/dec_by_region.do


