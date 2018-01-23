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
local r = _b[cabinet_right]

nlcom 	(bef4: _b[bef4_left]) ///
		(bef3: _b[bef3_left]) ///
		(bef2: _b[bef2_left]) ///
		(bef1: _b[bef1_left]) ///
		(election: _b[elec_left]) ///
		(post1: _b[post1_left]) ///
		(post2: _b[post2_left]) ///
		(post3: _b[post3_left]) ///
		(post4: _b[post4_left]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m2 $interactions_right_m2 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(bef4: _b[bef4_right] + _b[cabinet_right]) ///
		(bef3: _b[bef3_right] + _b[cabinet_right]) ///
		(bef2: _b[bef2_right] + _b[cabinet_right]) ///
		(bef1: _b[bef1_right] + _b[cabinet_right]) ///
		(election: _b[elec_right] + _b[cabinet_right]) ///
		(post1: _b[post1_right] + _b[cabinet_right]) ///
		(post2: _b[post2_right] + _b[cabinet_right]) ///
		(post3: _b[post3_right] + _b[cabinet_right]) ///
		(post4: _b[post4_right] + _b[cabinet_right]) ///
		,post
est sto right

coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))                    ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lcolor(black) lwidth(vthin)) ///
			yline(`r', lpattern(dash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(vsmall)) ///
			xscale(range(1 (1) 9)) ///
			xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1"  5 "0" 6 "1" 7 "2" 8 "3" 9 "4") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			xtitle (quarters around the election) ///
			title($graph_title2)
			
graph save $path_graph2_temp, replace



