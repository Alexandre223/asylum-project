****************************************
*** Decisions baseline specification ***
****************************************


*acceptance_rate refugeestatus_rate otherpositive_rate

foreach dec in totalpositive refugeestatus otherpositive {

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
