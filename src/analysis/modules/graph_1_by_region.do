

foreach var in MENA Africa SEA ECA {
	eststo clear
	xtset DO 
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m1 $interactions_right_m1 ///
							i.T, ///
							if `var'==1
							fe vce(cluster $se_clus)
	nlcom 	(before: _b[left_bef]) ///
			(after: _b[left_post]) ///
			,post
	est sto left
	
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m1 $interactions_right_m1 ///
							i.T, ///
							if `var'==1
							fe vce(cluster $se_clus)
	nlcom 	(before:  _b[right_bef] ) ///
			(after: _b[right_post] ) ///
			,post
	est sto right
	
	coefplot 	(left, keep($time_m1) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
				(right, keep($time_m1) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))   ///
				,connect (l) ciopts(recast(rline) lp(dash)) noci nooffset vertical ///
				yline(0, lcolor(black)) ///
				graphregion(color(white)) ///
				legend (rows(1)) ///
				xscale(range(1 (1) 2)) ///
				xlabel(1 "before the election"  2 "after the election") ///
				yscale(range(-0.2 -0.1 0 0.1 0.2)) ///
				ylabel(-0.2 -0.1 0 0.1 0.2) ///
				ytitle(estimated coefficient) ///
				title(`var')
	graph save ./out/analysis/temp/app_graph1_`var'.gph, replace
}*				


grc1leg ./out/analysis/temp/app_Graph1_MENA.gph ///
		./out/analysis/temp/app_Graph1_Africa.gph ///
		./out/analysis/temp/app_Graph1_ECA.gph ///
		./out/analysis/temp/app_Graph1_SEA.gph, ///
		row(2) col(2) legendfrom(app_Graph1_MENA.gph) ///
		ycommon graphregion(color(white)) ///
		title("Log First Time Applications per Capita: Predicted Pattern")
graph export ./out/analysis/applications/figures/app_graph1_by_region.pdf, replace
