****************************************
* Robustness checks with baseline_data *
****************************************

* Specify data set to be used *
use ./out/data/final_application/baseline_data.dta, clear

* Drop country pairs with less than 2 applications per quarter on average *
drop if mean_dyadic_FTapp_per_quarter < 2


****************************************************
** R1: Origin, destination and time fixed effects **
****************************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change globals for xtset and fixed effects
global xt_main O
global fe_var i.T i.D

* Define gobals for output paths for figures and tables
global path_graph1 "./out/analysis/applications/figures/app_graph1_R1.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R1_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R1_coef_paper.tex"

global path_graph2 "./out/analysis/applications/figures/app_graph2_R1.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R1_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R1_coef_paper.tex"


* Run do files to create tables and figures

do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/graph_2.do



*****************************************************
** R2: Origin * time and destination fixed effects **
*****************************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change globals for xtset and fixed effects
global xt_main OT
global fe_var i.D

* Define gobals for output paths for figures and tables
global path_graph1 "./out/analysis/applications/figures/app_graph1_R2.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R2_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R2_coef_paper.tex"

global path_graph2 "./out/analysis/applications/figures/app_graph2_R2.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R2_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R2_coef_paper.tex"

* Run do files to create tables and figures
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/graph_2.do


**********************************************
** R3: Control for past asylum applications **
**********************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* add past applications to destination globals
global destination_variables log_rGDPpc_dest unemployment log_av_app_pc 

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R3.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R3_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R3.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R3_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R3_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R3.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R3_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R3.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R3_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R3_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



**************************************
** R4:  Include cabinet right dummy **
**************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* add cabinet right dummy to destination globals
global destination_variables log_rGDPpc_dest unemployment cabinet_right 

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R4.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R4_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R4.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R4_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R4_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R4.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R4_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R4.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R4_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R4_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



********************************************************************************************
** R5: Use log first-time applications per capita in origin country as dependent variable **
********************************************************************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change dependent variable to log_firsttimeapp_pc_origin
global dependent_variable log_firsttimeapp_pc_origin

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R5.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R5_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R5.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R5_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R5_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R5.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R5_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R5.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R5_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R5_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



******************************************************
** R6: Do not use lags for origin country variables **
******************************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change origin country globals 
global origin_variables PTS CL PR death_thousands_ucdp log_rGDPpc_orig

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R6.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R6_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R6.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R6_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R6_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R6.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R6_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R6.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R6_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R6_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



***********************************************
** R7: Use Syrain battle death data from VDC **
***********************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change variable for battle death data in origin globals 
global origin_variables ///
		PTS_average CL_average PR_average ///
		death_thousands_vdc_average log_rGDPpc_orig_average 

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R7.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R7_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R7.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R7_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R7_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R7.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R7_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R7.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R7_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R7_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



*************************************
*** R8: Include a post 2007 dummy ***
*************************************
* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* add a post 2007 dummy to destination globals
global destination_variables log_rGDPpc_dest unemployment post_2007 

* Define gobals for output paths for figures and tables
global path_tab1 "./out/analysis/applications/tables/app_table1_R8.tex"
global path_tab1_paper "./out/analysis/applications/tables/app_table1_R8_paper.tex"
global path_graph1 "./out/analysis/applications/figures/app_graph1_R8.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R8_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R8_coef_paper.tex"

global path_tab2 "./out/analysis/applications/tables/app_table2_R8.tex"
global path_tab2_paper "./out/analysis/applications/tables/app_table2_R8_paper.tex"
global path_graph2 "./out/analysis/applications/figures/app_graph2_R8.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R8_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R8_coef_paper.tex"


* Run do files to create tables and figures
do ./src/analysis/modules/table_1.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/table_2.do
do ./src/analysis/modules/graph_2.do



**************************************************************************
**    R9: cluster standard errors on destination * origin country level **
**************************************************************************

* use same globals as in the baseline analysis
do ./src/analysis/modules/app_baseline_globals.do

* change global for standard error clustering to DO
global se_clus DO 

* Define gobals for output paths for figures and tables
global path_graph1 "./out/analysis/applications/figures/app_graph1_R9.pdf"
global path_coef_tab1 "./out/analysis/applications/tables/app_graph1_R9_coef.tex"
global path_coef_tab1_paper "./out/analysis/applications/tables/app_graph1_R9_coef_paper.tex"

global path_graph2 "./out/analysis/applications/figures/app_graph2_R9.pdf"
global path_coef_tab2 "./out/analysis/applications/tables/app_graph2_R9_coef.tex"
global path_coef_tab2_paper "./out/analysis/applications/tables/app_graph2_R9_coef_paper.tex"


* Run do files to create tables and figures
* Note exclude specification with OT & D fixed effects because 
* in this specification clustering on DO level is not possible
do ./src/analysis/modules/table_1_just_DO_specification.do
do ./src/analysis/modules/graph_1.do

do ./src/analysis/modules/graph_2.do
