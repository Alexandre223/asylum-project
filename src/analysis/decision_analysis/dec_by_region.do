***************************
*** Decisions by region ***
***************************


* Specify data set to be used *
use ./out/data/final_decision/baseline_data.dta, clear

* Drop country pairs with less than 2 decisions per quarter on average *
drop if mean_dyadic_decisions_pq < 2


foreach dec in acceptance_rate refugeestatus_rate otherpositive_rate{

* Define global for dependent variable
global dependent_variable `dec'

* Define globals for graph and table titles
global tab_title "Determinants of `dec'"
global graph_title "Predicted pattern `dec'"
global coef_tab_title "Predicted pattern `dec'"

* Define globals for baseline analysis *
do ./src/analysis/modules/dec_baseline_globals.do

* Adjust scale of y-axis
global y_scale (-0.05 -0.025 0 0.025  0.05)

* Define gobals for output paths for figures and tables
global path_tab1 ./out/analysis/decisions/tables/`dec'_table1_by_region.tex
global path_tab1_paper ./out/analysis/decisions/tables/`dec'_table1_by_region_paper.tex
global path_graph1 ./out/analysis/decisions/figures/`dec'_graph1_by_region.pdf

global path_graph2 ./out/analysis/decisions/figures/`dec'_graph2_by_region.pdf


* Create table 1 by region 
eststo clear
xtset DO 

foreach var in MENA Africa SEA ECA {
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m1 $interactions_right_m1 ///
							i.T ///
							if `var'==1 , ///
							fe vce(cluster $se_clus)
	estadd local FE "D x O"
	estadd local DE "No"
	estadd local TI "Yes"
	estadd local AREA `var'
	}
	*

esttab using $path_tab1, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" ///
				"TI Quarter-Year dummies" "AREA Area of origin") ///
se ar2 label number nomtitle nodepvars nogaps fragment ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)

esttab using $path_tab1_paper, ///
replace scalars("FE Fixed Effects" "DE Destination dummies" ///
				"TI Quarter-Year dummies" "AREA Area of origin") ///
se ar2 label number nomtitle nodepvars  ///
keep($origin_variables $destination_variables ///
	 $interactions_left_m1 $interactions_right_m1) ///
title($tab_title)


** Create graph 1 and corresponding coefficient tables 
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
	
	esttab left right using ./out/analysis/decisions/tables/`dec'_graph1_`var'_coef.tex, ///
	replace se label mtitle nodepvars nogaps fragment ///
	keep($time_m1) title($coef_tab_title)

	esttab  left  right using ./out/analysis/decisions/tables/`dec'_graph1_`var'_coef_paper.tex, ///
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
				ylabel $y_scale  ///
				ytitle(estimated coefficient) ///
				title(`var')
				
	graph save ./out/analysis/temp/`dec'_graph1_`var'.gph, replace
}
*				

grc1leg ./out/analysis/temp/`dec'_graph1_MENA.gph ///
		./out/analysis/temp/`dec'_graph1_Africa.gph ///
		./out/analysis/temp/`dec'_graph1_ECA.gph ///
		./out/analysis/temp/`dec'_graph1_SEA.gph, ///
		row(2) col(2) legendfrom(./out/analysis/temp/`dec'_graph1_MENA.gph) ///
		ycommon graphregion(color(white)) ///
		title("Predicted Pattern `dec' by region")
graph export $path_graph1, replace


** Create graph 2 and corresponding coefficient tables 
foreach var in MENA Africa SEA ECA {
	eststo clear
	xtset DO 
	eststo: quietly xtreg 	$dependent_variable ///
							$origin_variables $destination_variables ///
							$interactions_left_m2 $interactions_right_m2 ///
							i.T ///
							if `var'==1 , ///
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
							i.T ///
							if `var'==1 , ///
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
	
	esttab left right using ./out/analysis/decisions/tables/`dec'_graph2_`var'_coef.tex, ///
	replace se label mtitle nodepvars nogaps fragment ///
	keep($time_m2) title($coef_tab_title)

	esttab  left  right using ./out/analysis/decisions/tables/`dec'_graph2_`var'_coef_paper.tex, ///
	replace se label mtitle nodepvars  ///
	keep($time_m2) title($coef_tab_title)
	
	coefplot 	(left, keep($time_m2) label(cabinet left) msymbol(S) mcolor(maroon) lcolor(maroon)) ///
				(right, keep($time_m2) label(cabinet right) msymbol(T) mcolor(navy) lcolor(navy))   ///
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
				title(`var')
				
	graph save ./out/analysis/temp/`dec'_graph2_`var'.gph, replace
}
*				

grc1leg ./out/analysis/temp/`dec'_graph2_MENA.gph ///
		./out/analysis/temp/`dec'_graph2_Africa.gph ///
		./out/analysis/temp/`dec'_graph2_ECA.gph ///
		./out/analysis/temp/`dec'_graph2_SEA.gph, ///
		row(2) col(2) legendfrom(./out/analysis/temp/`dec'_graph2_MENA.gph) ///
		ycommon graphregion(color(white)) ///
		title("Predicted Pattern `dec' by region")
graph export $path_graph2, replace

}
*
