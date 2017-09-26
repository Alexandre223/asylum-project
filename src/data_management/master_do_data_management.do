******************************************
*** Master do file for data management ***
******************************************

clear 
set more off, permanently
cd F:/research/asylum-project/src/data_management

* Create help files with all origin and destination countries *
do help_files.do

* Merge all asylum application and decision data to one quarterly file *
do merge_asylum_data_do.do

* Combine all bilateral control variables *
do bilateral_data.do
