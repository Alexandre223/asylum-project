*****************************************************************
** TABLE 1: regression with just before and after the election **
**          by region    									   **
*****************************************************************

eststo clear
xtset DO 

foreach var in MENA Africa SEA ECA {
	eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						if `var'==1
						fe vce(cluster $se_clus)
	estadd local FE "D x O"
	estadd local DE "No"
	estadd local TI "Yes"
	estadd local AREA `var'
	}
	*

esttab using $path_tab1,
replace scalars("FE Fixed Effects" "DE Destination dummies" ///
				"TI Quarter-Year dummies" "AREA Area of origin") ///
se ar2 label number nomtitle nodepvars nogaps fragment ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)

esttab using $path_tab1_paper, 
replace scalars("FE Fixed Effects" "DE Destination dummies" ///
				"TI Quarter-Year dummies" "AREA Area of origin") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)
