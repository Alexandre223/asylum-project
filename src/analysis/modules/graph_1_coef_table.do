*******************************
** COEFFICIENT TABLE GRAPH 1 **
*******************************

* Table with combined coefficients of graph 1 and significance levels**

eststo clear
xtset $xt_main 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(before: _b[left_bef]) ///
		(after: _b[left_post]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(before:  _b[right_bef] ) ///
		(after: _b[right_post] ) ///
		,post
est sto right

esttab left right using $path_coef_tab1, ///
replace se label mtitle nodepvars nogaps fragment ///
keep($time_m1) title($coef_tab_title)

esttab  left  right using $path_coef_tab1_paper, ///
replace se label mtitle nodepvars  ///
keep($time_m1) title($coef_tab_title)
