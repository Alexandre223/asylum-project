********************************************************
** Calculate mean dyadic asylum decisions per quarter **
********************************************************

* Note: some destination and some origin countries don't have data for all years
* Calculate how many quarters are non missing and 
* divide sum of dyadic first time applications by number of non-missing quarters

egen sum_dyadic_decisions = sum(totaldecisions), by (destination origin)

egen not_missing = count(totaldecisions), by (destination origin)

gen mean_dyadic_decisions_pq = sum_dyadic_decisions / not_missing


** Calculate mean dyadic decisions with npn-imputed totaldecisions

egen sum_dyadic_decisions_NI = sum(totaldecisions_NI), by (destination origin)

egen not_missing_NI = count(totaldecisions_NI), by (destination origin)

gen mean_dyadic_decisions_pq_NI = sum_dyadic_decisions_NI / not_missing_NI
