
****************************************
* Robustness checks with othe datasets *
****************************************

* ============================================================================ *
* Use different cutoffs for droping country pairs with few observations
* ============================================================================ *
*********************************************************************************
** R9: drop country pairs with less than 1 decisions per quarter on average **
*********************************************************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 1 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 1

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R9.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R9_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R9.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R9_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R9_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R9.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R9_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R9.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R9_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R9_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*


*******************************************************************************
** R10: drop country pairs with less than 3 decisions per quarter on average **
*******************************************************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 3 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 3

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R10.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R10_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R10.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R10_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R10_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R10.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R10_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R10.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R10_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R10_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*




* ============================================================================ *
* Use different defintions for cabinet position 
* ============================================================================ *

**********************************************
**    R11: use normalized cabinet position  **
**********************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R11.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R11_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R11.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R11_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R11_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R11.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R11_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R11.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R11_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R11_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*


******************************************
**    R12: split cabinet dummies at 5   **
******************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_cabinet_split_at_5.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R12.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R12_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R12.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R12_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R12_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R12.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R12_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R12.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R12_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R12_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*


* ============================================================================ *
* Use different quarters around the election
* ============================================================================ *

*******************************************************
**    R13: use only 5 quarters around the election   **
*******************************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_Q5.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Adjust globals for interaction terms to include only 5 quarters
do ./src/analysis/modules/globals_interactions_Q5.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R13.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R13_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R13.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R13_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R13_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R13.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R13_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R13.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R13_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R13_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_Q5.do
}
*

*******************************************************
**    R14: use only 4 quarters around the election   **
*******************************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_Q4.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Adjust globals for interaction terms to include only 4 quarters
do ./src/analysis/modules/globals_interactions_Q4.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R14.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R14_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R14.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R14_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R14_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R14.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R14_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R14.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R14_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R14_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_Q4.do
}
*



* ================================================================================ *
* Use non-imputed data on total decisions
* ================================================================================ *

******************************************************
**    R15: Use non-imputed data on total decisions  **
******************************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq_NI < 2

foreach dec in acceptance_rate_NI refugeestatus_rate_NI otherpositive_rate_NI{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

global 	destination_variables log_rGDPpc_dest unemployment ///
		log_dest_decisions_pc_NI  log_dyadic_decisions_pc_NI

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R15.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R15_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R15.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R15_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R15_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R15.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R15_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R15.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R15_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R15_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*



* ============================================================================ *
* Include more years
* ============================================================================ *

*****************************************
**    R16: use all years 2002 - 2016   **
*****************************************

* Specify data set to be used *
use ./out/data/final_decision/baseline_2016.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R16.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R16_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R16.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R16_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R16_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R16.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R16_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R16.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R16_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R16_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*



* ============================================================================ *
* Use other destination country samples
* ============================================================================ *

***********************************************************************
** R17: Use all destination countries with less than 2 missing years ** 				
***********************************************************************

* Specify data set to be used *
use ./out/data/final_decision/all_max_two_missing_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R17.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R17_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R17.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R17_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R17_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R17.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R17_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R17.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R17_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R17_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*


*********************************************************************************
** R18: Use only very big destination countries with less than 2 missing years ** 				
*********************************************************************************

* Specify data set to be used *
use ./out/data/final_decision/max_two_missing_very_big.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R18.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R18_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R18.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R18_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R18_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R18.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R18_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R18.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R18_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R18_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*



****************************************************************
** R19: Use only countries that report decisions in all years ** 				
****************************************************************

* Specify data set to be used *
use ./out/data/final_decision/no_missing_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R19.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R19_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R19.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R19_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R19_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R19.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R19_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R19.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R19_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R19_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*



********************************************************************************
** R20: use only countries that are also in the baseline application analysis ** 				
********************************************************************************
* Specify data set to be used *
use ./out/data/final_decision/only_application_countries.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2

foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'" 

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_R20.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_R20_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_R20.pdf
global path_coef_tab1 ./out/analysis/decisions/tables/`dec'_graph1_R20_coef.tex
global path_coef_tab1_paper ./out/analysis/decisions/tables/`dec'_graph1_R20_coef_paper.tex

global path_tab2 ./out/analysis/decisions/tables/`dec'_table2_R20.tex
global path_tab2_paper ./out/analysis/decisions/tables/`dec'_table2_R20_paper.tex
global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_R20.pdf
global path_coef_tab2 ./out/analysis/decisions/tables/`dec'_graph2_R20_coef.tex
global path_coef_tab2_paper ./out/analysis/decisions/tables/`dec'_graph2_R20_coef_paper.tex


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
}
*
