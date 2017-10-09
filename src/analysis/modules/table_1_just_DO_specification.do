*****************************************************************
** TABLE 1: regression with just before and after the election **
*****************************************************************

eststo clear

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

esttab using $path_tab1, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number varwidth (40) modelwidth (10 10 10) nomtitle nodepvars nogaps fragment ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab1_title)

esttab using $path_tab1_paper, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)
