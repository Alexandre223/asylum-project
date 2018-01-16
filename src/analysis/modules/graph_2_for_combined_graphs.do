*****************************************************************
** GRAPH 2: graph with 6 before and after the election dummies **
*****************************************************************

eststo clear
xtset $xt_main 
eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_left]) ///
		(bef5: _b[bef5_left]) ///
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
		(post6: _b[post6_left]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(bef6: _b[bef6_right] ) ///
		(bef5: _b[bef5_right] ) ///
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
		(post6: _b[post6_right] ) ///
		,post
est sto right

esttab left right using $path_coef_graph2, ///
replace se label mtitle nodepvars  /// 
keep($time_m2) title($coef_tab_title)

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lcolor(black)) ///
			graphregion(color(white)) ///
			legend (rows(1)) ///
			xscale(range(1 (1) 13)) ///
			xlabel(1 "-6" 2 "-5" 3 "-4" 4 "-3"  5 "-2" 6 "-1" 7 "0" ///
				   8 "1" 9 "2" 10 "3" 11 "4" 12 "5" 13 "6") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///

			
graph save $path_graph2_temp, replace
