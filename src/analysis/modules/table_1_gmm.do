*****************************************************************
** TABLE 1: regression with just before and after the election **
*****************************************************************

eststo clear

xtset DO T

xtabond2 log_firsttimeapp_pc L.log_firsttimeapp_pc PTS_average CL_average PR_average death_thousands_vdc_average log_rGDPpc_orig_average log_rGDPpc_dest unemployment left_bef left_post right_bef right_post i.DO i.T, artests(3) gmm(L.log_firsttimeapp_pc, laglimits(3 10)) iv(PTS_average CL_average PR_average death_thousands_vdc_average log_rGDPpc_orig_average log_rGDPpc_dest unemployment left_bef left_post right_bef right_post i.T i.DO) robust

xtabond2 log_firsttimeapp_pc L.log_firsttimeapp_pc PTS_average CL_average PR_average death_thousands_vdc_average log_rGDPpc_orig_average log_rGDPpc_dest unemployment left_bef left_post right_bef right_post i.DO i.T, artests(3) gmm(L.log_firsttimeapp_pc, laglimits(3 10)) iv(PTS_average CL_average PR_average death_thousands_vdc_average log_rGDPpc_orig_average log_rGDPpc_dest unemployment left_bef left_post right_bef right_post i.T i.OT) robust



stop


estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"




stop


eststo: xtabond  $dependent_variable ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"





stop


xtset DO 
eststo: quietly xtabond $dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
*						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset OT
eststo: quietly xtabond	$dependent_variable ///
						$bilateral_variables $destination_variables ///
					  	$interactions_left_m1 $interactions_right_m1 ///
*						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

esttab using $path_tab1, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number varwidth (40) modelwidth (10 10 10) nomtitle nodepvars nogaps fragment ///
keep($origin_variables $destination_variables $bilateral_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)

esttab using $path_tab1_paper, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables $bilateral_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)
