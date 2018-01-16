************************************************************
** GRAPH 1: graph with just before and after the election **
************************************************************

eststo clear

xtset $xt_main 

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(before: _b[left_bef]) ///
		(after: _b[left_post]) ///
		,post
est sto left

eststo: quietly xtreg 	$dependent_variable ///
						$origin_variables $destination_variables ///
						$interactions_left_m1 $interactions_right_m1 ///
						$fe_var, ///
						fe vce(cluster $se_clus)
nlcom 	(before:  _b[right_bef] ) ///
		(after: _b[right_post] ) ///
		,post
est sto right

esttab  left  right using $path_coef_graph1, ///
replace se label mtitle nodepvars  ///
keep($time_m1) title($coef_tab_title)

coefplot 	(left, keep($time_m1) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
			(right, keep($time_m1) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))   ///
			,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
			yline(0, lcolor(black)) ///
			graphregion(color(white)) ///
			legend (rows(1)) ///
			xscale(range(1 (1) 2)) ///
			xlabel(1 "before the election"  2 "after the election") ///
			yscale(range$y_scale) ///
			ylabel $y_scale ///
			ytitle(estimated coefficient) ///
			title($graph_title)
			
graph save $path_graph1__temp, replace
