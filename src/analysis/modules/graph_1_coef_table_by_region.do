

foreach var in MENA Africa SEA ECA {
	eststo clear
	xtset DO 
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m1 $interactions_right_m1 ///
							i.T ///
							if `var'==1 , ///
							fe vce(cluster $se_clus)
	nlcom 	(before: _b[left_bef]) ///
			(after: _b[left_post]) ///
			,post
	est sto left
	
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m1 $interactions_right_m1 ///
							i.T ///
							if `var'==1 , ///
							fe vce(cluster $se_clus)
	nlcom 	(before:  _b[right_bef] ) ///
			(after: _b[right_post] ) ///
			,post
	est sto right
	
esttab left right using ./out/analysis/applications/tables/app_graph1_`var'_coef, ///
replace se label mtitle nodepvars nogaps fragment ///
keep($time_m1) title($coef_tab_title)

esttab  left  right using ./out/analysis/applications/tables/app_graph1_`var'_coef_paper, ///
replace se label mtitle nodepvars  ///
keep($time_m1) title($coef_tab_title)
}
*				

