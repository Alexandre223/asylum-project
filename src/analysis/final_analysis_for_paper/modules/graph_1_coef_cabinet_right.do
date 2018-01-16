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
nlcom 	(before:  _b[right_bef]) ///
		(after: _b[right_post]) ///
		,post
est sto right

