
****************************************
* Robustness checks with othe datasets *
****************************************

* ============================================================================ *
* Use different cutoffs for droping country pairs with few observations
* ============================================================================ *
*********************************************************************************
** R10: drop country pairs with less than 1 application per quarter on average **
*********************************************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 1 application per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 1

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R10.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R10_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R10.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R10_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R10_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R10.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R10_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R10.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R10_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R10_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



**********************************************************************************
** R11: drop country pairs with less than 3 applications per quarter on average **
**********************************************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 3 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 3

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R11.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R11_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R11.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R11_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R11_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R11.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R11_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R11.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R11_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R11_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do




* ============================================================================ *
* Use different defintions for cabinet position 
* ============================================================================ *

**********************************************
**    R12: use normalized cabinet position  **
**********************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_normalized_cabinet.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R12.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R12_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R12.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R12_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R12_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R12.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R12_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R12.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R12_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R12_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



******************************************
**    R13: split cabinet dummies at 5   **
******************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_cabinet_split_at_5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R13.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R13_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R13.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R13_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R13_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R13.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R13_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R13.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R13_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R13_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



* ============================================================================ *
* Use different quarters around the election
* ============================================================================ *

*******************************************************
**    R14: use only 5 quarters around the election   **
*******************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_Q5.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 5 quarters
do ./src/analysis/modules/globals_interactions_Q5.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R14.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R14_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R14.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R14_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R14_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R14.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R14_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R14.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R14_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R14_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_Q5.do
do ./src/analysis/modules/graph_2_coef_table_Q5.do


*******************************************************
**    R15: use only 4 quarters around the election   **
*******************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_Q4.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Adjust globals for interaction terms to include only 5 quarters
do ./src/analysis/modules/globals_interactions_Q4.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R15.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R15_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R15.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R15_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R15_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R15.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R15_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R15.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R15_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R15_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2_Q4.do
do ./src/analysis/modules/graph_2_coef_table_Q4.do



* ============================================================================ *
* Do not impute first-time application data
* ============================================================================ *

*******************************************************
**    R16: do not impute first-time application data **
*******************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_non_imputed_fta.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* use non-imputed first time applications as dependent variable
global dependent_variable log_firsttimeapp_NI_pc

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R16.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R16_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R16.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R16_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R16_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R16.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R16_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R16.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R16_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R16_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



* ============================================================================ *
* Include more years
* ============================================================================ *

*****************************************
**    R17: use all years 2002 - 2016   **
*****************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_2016.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R17.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R17_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R17.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R17_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R17_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R17.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R17_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R17.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R17_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R17_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



* ============================================================================ *
* Use other destination country samples
* ============================================================================ *

***********************************************************************
** R18: Use all destination countries with less than 2 missing years ** 				
***********************************************************************

* Specify data set to be used *
use ./out/data/final_application/all_max_two_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R18.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R18_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R18.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R18_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R18_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R18.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R18_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R18.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R18_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R18_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



******************************************************************************
** R19: Use only countries that report first time applications in all years ** 				
******************************************************************************

* Specify data set to be used *
use ./out/data/final_application/no_missing_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R19.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R19_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R19.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R19_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R19_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R19.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R19_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R19.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R19_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R19_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do



*****************************************************************
** R20: add Cyprus to baseline sample of destination countries ** 				
*****************************************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_plus_Cyprus.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R20.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R20_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R20.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R20_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R20_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R20.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R20_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R20.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R20_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R20_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do


*****************************************************************************
** R21: use only countries that are also in the baseline decision analysis ** 				
*****************************************************************************

* Specify data set to be used *
use ./out/data/final_application/only_decision_countries.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter_NI < 2

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R21.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R21_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R21.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R21_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R21_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R21.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R21_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R21.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R21_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R21_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do
do ./src/analysis/modules/graph_1_coef_table.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do
do ./src/analysis/modules/graph_2_coef_table.do
