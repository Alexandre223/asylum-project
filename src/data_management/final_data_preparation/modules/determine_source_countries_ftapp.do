****************************************************************
** Determine biggest destination countries for a given sample **
**       of destination countries and time period             **
****************************************************************

collapse (sum) firsttimeapp, by (origin)

egen total=total(firsttimeapp)

gen share=firsttimeapp/total

drop if origin=="Unknown" | origin=="Stateless" | origin=="Recognised non-citizens"

gsort -share

gen sum_share=sum(share)

drop if sum_share>=0.905

list origin share sum_share 

keep origin
