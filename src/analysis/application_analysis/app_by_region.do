******************************
*** Applications by region ***
******************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_by_region.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_by_region_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_by_region.pdf"

global path_graph2 "./out/analysis/applications/figures/app_graph2_by_region.pdf"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1_by_region.do
do ./src/analysis/modules/graph_1_by_region.do
do ./src/analysis/modules/graph_1_coef_table_by_region.do

do ./src/analysis/modules/graph_2_by_region.do
do ./src/analysis/modules/graph_2_coef_table.do
