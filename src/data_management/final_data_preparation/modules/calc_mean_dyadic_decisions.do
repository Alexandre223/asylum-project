********************************************************
** Calculate mean dyadic asylum decisions per quarter **
********************************************************

* Note: some destination and some origin countries don't have data for all years
* Calculate how many quarters are non missing and 
* divide sum of dyadic first time applications by number of non-missing quarters

egen sum_dyadic_decisions = sum(totaldecisions), by (destination origin)

egen not_missing = count(totaldecisions), by (destination origin)

gen mean_dyadic_decisions_pq = sum_dyadic_decisions / not_missing


** Calculate mean dyadic decisions with imputed totaldecisions (rejected + totalpositive)

egen sum_dyadic_decisions_IM = sum(totaldecisions_IM), by (destination origin)

egen not_missing_IM = count(totaldecisions_IM), by (destination origin)

gen mean_dyadic_decisions_pq_IM = sum_dyadic_decisions_IM / not_missing_IM
