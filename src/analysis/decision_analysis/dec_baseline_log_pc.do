************************************************************
*** Decisions baseline specification with log per capita ***
************************************************************


foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'"

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

global y_scale (-0.3 -0.2 -0.1 0 0.1  0.2)

global 	destination_variables log_rGDPpc_dest unemployment ///
		cabinet_right

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_baseline.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_baseline_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_baseline.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_baseline_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_baseline_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_baseline.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_baseline_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_baseline.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_baseline_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_baseline_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*

* ================================================================================= *
* R01: Robustness including controls for total decisions and total dyadic decisions *
* ================================================================================= *

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'"

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

global y_scale (-0.3 -0.2 -0.1 0 0.1  0.2)

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R01.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R01_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R01.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R01_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R01_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R01.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R01_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R01.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R01_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R01_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*


* ======================================= *
* R02: Do not include cabinet right dummy *
* ======================================= *

foreach dec in log_totalpositive_pc log_refugeestatus_pc log_temporary_protection_pc{

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'"

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

global y_scale (-0.3 -0.2 -0.1 0 0.1  0.2)

global 	destination_variables log_rGDPpc_dest unemployment
		

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R02.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R02_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R02.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R02_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R02_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R02.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R02_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R02.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R02_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R02_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*
