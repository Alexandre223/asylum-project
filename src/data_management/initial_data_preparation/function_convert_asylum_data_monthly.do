
split time, parse(M)

destring time2, replace
destring time1, replace
destring value, ignore(":" ",") replace

rename time1 year
rename time2 month
rename geo destination
rename citizen origin

gen quarter = .
replace quarter = 1 if month <= 3
replace quarter = 2 if month >= 4 & month <= 6
replace quarter = 3 if month >=7 & month <= 9
replace quarter = 4 if month >= 10

keep origin destination year quarter month value
