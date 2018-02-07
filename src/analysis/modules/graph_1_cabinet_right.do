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
nlcom 	(before: _b[left_bef] ) ///
		(after: _b[left_post] ) ///
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

coefplot 	(left, keep($time_m1) label(left-wing cabinet) ///
			msymbol(S) mcolor(red) lcolor(red)) ///
			(right, keep($time_m1) label(right-wing cabinet) ///
			msymbol(T) mcolor(navy) lcolor(navy))   ///
			, connect(l) noci nooffset vertical ///
			yline(0, lcolor(black) lwidth(vthin)) ///
			yline(`r', lpattern(longdash) lcolor(navy) lwidth(vthin)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(vsmall)) ///
			xscale(range(1 (1) 2)) ///
			xlabel(1 "before the election"  2 "after the election", labsize(small)) ///
			yscale(range($y_scale)) ///
			ylabel ($y_scale , labsize(small)) ///
			ytitle(estimated coefficient, size(small)) ///
			title($graph_title1)
			
graph save $path_graph1_temp, replace
