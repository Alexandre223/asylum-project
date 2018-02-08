**********************
** Baseline globals **
**********************

* Define globals that are similar in both models *
global dependent_variable log_firsttimeapp_pc

global origin_variables ///
		PTS_average CL_average PR_average ///
		death_thousands_vdc_average log_rGDPpc_orig_average 
	
global destination_variables log_rGDPpc_dest unemployment
 
global bilateral_variables log_imm_stock_2000 log_kmdist

* Define globals for interaction terms
do ./modules/globals_interactions.do

* Define globals for graph and table titles
global tab_title "Determinants of log(First time asylum applications per capita)"
global graph_title " "Log First Time Applications per Capita:" "Predicted Pattern" "
global coef_tab_title " Log First Time Applications per Capita: Predicted Pattern "

* Define global for standard error clustering
global se_clus O

* Define global for panel variable xtset in main specification
global xt_main DO

* Define global for fixed effects
global fe_var i.T

* Define global for the scale of the y-axis in the graph
global y_scale -0.2 -0.1 0 0.1 0.2

