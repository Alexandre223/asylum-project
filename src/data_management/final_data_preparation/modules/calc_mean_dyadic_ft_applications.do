***************************************************************
** Calculate mean dyadic first-time applications per quarter **
***************************************************************

* Note: some destination and some origin countries don't have data for all years
* Calculate how many quarters are non missing and 
* divide sum of dyadic first time applications by number of non-missing quarters

egen sum_dyadic_FTapplications = sum(firsttimeapp), by (destination origin)

egen not_missing=count(firsttimeapp), by (destination origin)

gen mean_dyadic_FTapp_per_quarter=sum_dyadic_FTapplications/not_missing

