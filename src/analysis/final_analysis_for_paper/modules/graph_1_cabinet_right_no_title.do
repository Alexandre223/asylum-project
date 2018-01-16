************************************************************
** GRAPH 1: graph with just before and after the election **
**          including a cabinet right dummy               **
************************************************************

eststo clear

xtset $xt_main 

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
local r = _b[cabinet_right]
nlcom 	(before: _b[left_bef]) ///
		(after: _b[left_post]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables  ///
						$interactions_left_m1 $interactions_right_m1 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(before:  _b[right_bef] + _b[cabinet_right]) ///
		(after: _b[right_post] + _b[cabinet_right]) ///
		,post
est sto right

coefplot 	(left, keep($time_m1) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m1) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))   ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lpattern(dash) lcolor(maroon) lwidth(vthin)) ///
			yline(`r', lpattern(dash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(small)) ///
			xscale(range(1 (1) 2)) ///
			xlabel(1 "before the election"  2 "after the election") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			
graph save $path_graph1_temp, replace
