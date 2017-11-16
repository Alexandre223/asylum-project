***********************************************************
** TABEL 2: regression with 6 before and 6 after dummies **
***********************************************************

eststo clear

xtset O
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $bilateral_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T i.D, ///
						fe vce(cluster $se_clus) 
estadd local FE "O"
estadd local DE "Yes"
estadd local TI "Yes"

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
estadd local FE "D x O"
estadd local DE "No"
estadd local TI "Yes"

xtset OT
eststo: quietly xtreg 	$dependent_variable ///
						$bilateral_variables $destination_variables ///
					  	$interactions_left_m2 $interactions_right_m2 ///
						i.D, ///
						fe vce(cluster $se_clus)
estadd local FE "O x T"
estadd local DE "Yes"
estadd local TI "No"

esttab using $path_tab2, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars nogaps fragment   ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m2 $interactions_right_m2) ///
title($tab_title)


esttab using $path_tab2_paper, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" "TI Quarter-Year dummies") ///
se ar2 label number nomtitle nodepvars nogaps fragment   ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m2 $interactions_right_m2) ///
title($tab_title)
