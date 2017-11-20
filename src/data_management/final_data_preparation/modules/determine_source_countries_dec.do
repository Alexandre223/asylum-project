****************************************************************
** Determine biggest destination countries for a given sample **
**       of destination countries and time period             **
****************************************************************

collapse (sum) totaldecisions, by (origin)

egen total=total(totaldecisions)

gen share=totaldecisions/total

drop if origin=="Unknown" | origin=="Stateless" | origin=="Recognised non-citizens"

gsort -share

gen sum_share=sum(share)

drop if sum_share>=0.903

list origin share sum_share 

keep origin
