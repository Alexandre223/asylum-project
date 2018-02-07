******************************************
*** Master do file for data management ***
******************************************

clear 
set more off, permanently
cd F:/research/asylum-project

*****************************************************
** Prepare and combine data from different sources **
*****************************************************

* Create help files with all origin and destination countries *
do ./src/data_management/initial_data_preparation/help_files.do

* Merge all asylum application and decision data to one quarterly file *
do ./src/data_management/initial_data_preparation/asylum_data.do

* Combine all bilateral control variables *
do ./src/data_management/initial_data_preparation/bilateral_data.do

* Perpare battle death data to use in source country do file *
do ./src/data_management/initial_data_preparation/battle_death.do

* Perpare origin GDP data to use in source country do file *
do ./src/data_management/initial_data_preparation/gdp_origin.do

* Combine all origin country data *
do ./src/data_management/initial_data_preparation/origin_data.do

* Prepare election data *
do ./src/data_management/initial_data_preparation/election_data.do

* Combine all destination data *
do ./src/data_management/initial_data_preparation/destination_data.do

* Prepare data on past asylum applications per capita *
do ./src/data_management/initial_data_preparation/past_asylum_variables.do

* Combine origin, destination, bilateral and election data *
do ./src/data_management/initial_data_preparation/combine_all_data.do

* Prepare all variables that are the same in all samples *
do ./src/data_management/initial_data_preparation/prepare_variables_same_for_all.do



************************************************************
** Prepare different samples for the application analysis **
************************************************************
* Determine most important source countries for different samples 
do ./src/data_management/final_data_preparation/application_samples/app_determine_source_countries.do

* Prepare data for the baseline sample *
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample.do

* Prepare data for the baseline sample of countries using only 5 quarters
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_5_quarters.do

* Prepare data for the baseline sample of countries using only 4 quarters
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_4_quarters.do

* Prepare data for the baseline sample with normalized cabinet position
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_normalized_cabinet.do

* Prepare data for the baseline sample with cabinet position slpit at 5
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_cabinet_split_at_5.do

* Prepare data for a sample of all destination countries with max 2 years of missing data
do ./src/data_management/final_data_preparation/application_samples/app_all_max_two_missing.do

* Prepare data for a sample of all destination countries with 
* data on first time applications in all years
do ./src/data_management/final_data_preparation/application_samples/app_no_missings.do

* Prepare data for baseline sample + Cyprus
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_plus_Cyprus.do

* Prepare data for a sample of all destination countries that are both in the decision
* and the application analysis (overlapping baseline sample)
do ./src/data_management/final_data_preparation/application_samples/app_only_decision_countries.do

* Prepare data for baseline sample minus Denmark and Netherlands because of early elections
do ./src/data_management/final_data_preparation/application_samples/app_few_early_elections.do

* Prepare data for countries with no early elections (France, Ireland, Norway, Sweden, UK)
do ./src/data_management/final_data_preparation/application_samples/app_no_early_elections.do

* Prepare data for the baseline sample with non imputed first-time applications
do ./src/data_management/final_data_preparation/application_samples/app_baseline_sample_non_imputed_fta.do



*********************************************************
** Prepare different samples for the decision analysis **
*********************************************************
* Determine most important source countries for different samples 
do ./src/data_management/final_data_preparation/decision_samples/dec_determine_source_countries.do

* Prepare data for the baseline sample *
do ./src/data_management/final_data_preparation/decision_samples/dec_baseline_sample.do

* Prepare data for the baseline sample of countries using only 5 quarters
do ./src/data_management/final_data_preparation/decision_samples/dec_baseline_sample_5_quarters.do

* Prepare data for the baseline sample of countries using only 4 quarters
do ./src/data_management/final_data_preparation/decision_samples/dec_baseline_sample_4_quarters.do

* Prepare data for the baseline sample with normalized cabinet position
do ./src/data_management/final_data_preparation/decision_samples/dec_baseline_sample_normalized_cabinet.do

* Prepare data for the baseline sample with cabinet position slpit at 5
do ./src/data_management/final_data_preparation/decision_samples/dec_baseline_sample_cabinet_split_at_5.do

* Prepare data for a sample of all destination countries with max 2 years of missing data
do ./src/data_management/final_data_preparation/decision_samples/dec_all_max_two_missing.do

* Prepare data for a sample of all destination countries with 
* data on decisions in all years
do ./src/data_management/final_data_preparation/decision_samples/dec_no_missings.do

* Prepare data for a sample of all destination countries that are both in the decision
* and the application analysis (overlapping baseline sample)
do ./src/data_management/final_data_preparation/decision_samples/dec_only_application_countries.do

* Prepare data for a sample of all destination countries that are both in the decision
* and the application analysis (overlapping baseline sample) with normalized cabinet position
do ./src/data_management/final_data_preparation/decision_samples/dec_only_application_normalized_cabinet.do

* Prepare data for a sample with a maximum of one early elections
do ./src/data_management/final_data_preparation/decision_samples/dec_few_early_elections.do

* Prepare data for countries with no early elections
do ./src/data_management/final_data_preparation/decision_samples/dec_no_early_elections.do

