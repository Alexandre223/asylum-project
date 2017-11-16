****************************************
* Robustness checks with baseline_data *
****************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2


****************************************************
** R1: Origin, destination and time fixed effects **
****************************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* change globals for xtset and fixed effects
global xt_main O
global fe_var i.T i.D

* Define gobals for output paths for figures and tables
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R1.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R1_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R1_coef_paper.tex

global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R1.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R1_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R1_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/graph_2_cabinet_right.do
}
*



*****************************************************
** R2: Origin * time and destination fixed effects **
*****************************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* change globals for xtset and fixed effects
global xt_main OT
global fe_var i.D

* Define gobals for output paths for figures and tables
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R2.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R2_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R2_coef_paper.tex

global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R2.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R2_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R2_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/graph_2_cabinet_right.do
}
*



**********************************************
** R3: Control for past asylum applications **
**********************************************
foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Add past applications to destination globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc  log_dyadic_decisions_pc log_av_app_pc 

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R3.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R3_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R3.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R3_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R3_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R3.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R3_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R3.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R3_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R3_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*


*********************************************
** R4:  Do not include cabinet right dummy **
*********************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Add cabinet right dummy to destination globals
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc  log_dyadic_decisions_pc

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R4.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R4_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R4.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R4_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R4_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R4.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R4_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R4.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R4_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R4_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*


******************************************************
** R5: Do not use lags for origin country variables **
******************************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Change origin country globals 
global origin_variables PTS CL PR death_thousands_vdc log_rGDPpc_orig

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R5.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R5_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R5.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R5_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R5_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R5.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R5_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R5.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R5_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R5_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*


************************************************
** R6: Use Syrain battle death data from UCDP **
************************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Change variable for battle death data in origin globals 
global origin_variables ///
		PTS_average CL_average PR_average ///
		death_thousands_ucdp_average log_rGDPpc_orig_average 

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R6.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R6_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R6.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R6_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R6_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R6.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R6_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R6.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R6_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R6_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*



*************************************
*** R7: Include a post 2007 dummy ***
*************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Add a post 2007 dummy to destination globals 
global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc  log_dyadic_decisions_pc ///
		post_2007 

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R7.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R7_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R7.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R7_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R7_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R7.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R7_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R7.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R7_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R7_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1_no_OT_specification.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_cabinet_right.do
}
*



**************************************************************************
**    R8: cluster standard errors on destination * origin country level **
**************************************************************************

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* change global for standard error clustering to DO
global se_clus DO 

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R8.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R8_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R8.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R8_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R8_coef_paper.tex

global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R8.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R8_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R8_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1_just_DO_specification.do
do ./src/analysis/modules/graph_1_cabinet_right.do

do ./src/analysis/modules/graph_2_cabinet_right.do
}
*

