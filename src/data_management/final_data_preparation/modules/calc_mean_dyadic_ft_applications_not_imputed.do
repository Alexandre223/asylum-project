***************************************************************
** Calculate mean dyadic first-time applications per quarter **
**     use only non-imputed first time application data 	 **
***************************************************************

* Note: some destination and some origin countries don't have data for all years
* Calculate how many quarters are non missing and 
* divide sum of dyadic first time applications by number of non-missing quarters

egen sum_dyadic_FTapplications_NI = sum(firsttimeapp_NI), by (destination origin)

egen not_missing=count(firsttimeapp_NI), by (destination origin)

gen mean_dyadic_FTapp_per_quarter_NI=sum_dyadic_FTapplications_NI/not_missing

