******************************************************************
** COEFFICIENT TABLE GRAPH 2 FOR 5 QUARTERS AROUND THE ELECTION **
******************************************************************

eststo clear

xtset DO 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef5: _b[bef5_left]) ///
		(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		(post5: _b[post5_left]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						i.T, ///
						fe vce(cluster $se_clus)
nlcom 	(bef5: _b[bef5_right] ) ///
		(bef4: _b[bef4_right] ) ///
		(bef3: _b[bef3_right] ) ///
		(bef2: _b[bef2_right] ) ///
		(bef1: _b[bef1_right] ) ///
		(election: _b[elec_right] ) ///
		(post1: _b[post1_right] ) ///
		(post2: _b[post2_right] ) ///
		(post3: _b[post3_right] ) ///
		(post4: _b[post4_right] ) ///
		(post5: _b[post5_right] ) ///
		,post
est sto right

esttab left right using $path_coef_tab2, ///
replace se label mtitle nodepvars nogaps fragment /// 
keep($time_m2) title($coef_tab_title)

esttab left right using $path_coef_tab2_paper, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title($coef_tab_title)
