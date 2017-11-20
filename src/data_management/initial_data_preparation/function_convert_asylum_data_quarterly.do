
split time, parse(Q)

destring time2, replace
destring time1, replace
destring value, ignore(":" ",") replace

rename time1 year
rename time2 quarter
rename geo destination
rename citizen origin

keep origin destination year quarter value
