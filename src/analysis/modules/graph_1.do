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

coefplot 	(left, keep($time_m1) label(left-wing cabinet) ///
			msymbol(S) mcolor(red) msize(medium) lcolor(red)) ///
			(right, keep($time_m1) label(right-wing cabinet) ///
			msymbol(T) mcolor(navy) msize(medium) lcolor(navy))   ///
			, connect(l) noci nooffset vertical ///
			yline(0, lcolor(black)) ///
			graphregion(color(white)) ///
			legend (rows(1) size(vsmall)) ///
			xscale(range(1 (1) 2)) ///
			xlabel(1 "before the election"  2 "after the election", labsize(small)) ///
			yscale(range($y_scale)) ///
			ylabel ($y_scale , labsize(small)) ///
			ytitle(estimated coefficient, size(small)) ///
			title($graph_title1)
			
graph save $path_graph1_temp, replace
