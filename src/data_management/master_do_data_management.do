******************************************
*** Master do file for data management ***
******************************************

clear 
set more off, permanently
cd F:/research/asylum-project

* Create help files with all origin and destination countries *
do ./src/data_management/help_files.do

* Merge all asylum application and decision data to one quarterly file *
do ./src/data_management/merge_asylum_data.do

* Combine all bilateral control variables *
do ./src/data_management/bilateral_data.do

* Perpare battle death data to use in source country do file *
do ./src/data_management/battle_death.do

* Perpare origin GDP data to use in source country do file *
do ./src/data_management/gdp_origin.do

* Combine all origin country data *
do ./src/data_management/origin_data.do

* Prepare election data *
do ./src/data_management/election_data.do

* Prepare data on past asylum applications per capita *
do ./src/data_management/past_asylum_applications.do

* Combine all destination data *
do ./src/data_management/destination_data.do

* Combine origin, destination, bilateral and election data *
do ./src/data_management/combine_all_data.do
