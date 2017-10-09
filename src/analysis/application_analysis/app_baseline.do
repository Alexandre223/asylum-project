*******************************************
*** Applications baseline specification ***
*******************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* Define globals for baseline analysis *
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_baseline.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_baseline_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_baseline.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_baseline_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_baseline_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_baseline.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_baseline_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_baseline.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_baseline_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_baseline_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do
