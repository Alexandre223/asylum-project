** Calculate number of elections and cabinet changes *

* number of elections
bysort destination origin: egen n_elections = total(election)
bysort destination: egen n_elections_max = max(n_elections)

tab n_elections_max destination 

label variable n_elections_max "Number of elections per destination country"


* number of cabinet changes
sort destination origin year quarter
gen cabinet = .
replace cabinet = 1 if cabinet_right == 1 
replace cabinet = 2 if cabinet_left == 1

by destination origin: gen diff = cabinet - cabinet[_n-1]
replace diff = 1 if diff == -1

by destination origin: egen n_cabinet_changes =total(diff)
bysort destination: egen n_cabinet_changes_max = max(n_cabinet_changes)

label variable n_cabinet_changes_max "Number of cabinet changes per destination country"
