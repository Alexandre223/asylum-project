
destring time, replace
destring value, ignore(":" ",") replace

rename time year
rename geo destination
rename citizen origin

keep origin destination year value
