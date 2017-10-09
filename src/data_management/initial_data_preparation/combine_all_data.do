***************************************************
*** Combine all data and prepare final data set ***
***************************************************
clear
set more off, permanently


* use asylum data
use ./out/data/temp/combined-asylum-data-02-16-q.dta, clear

* match destination country data
merge m:1 destination year quarter using ///
		./out/data/temp/destination_data.dta, nogen

* match bilateral data
merge m:1 origin destination using ///
		./out/data/temp/bilateral_data.dta, nogen

* match origin country data		
merge m:1 origin year quarter using ///
		./out/data/temp/origin_data.dta, nogen

		
save ./out/data/temp/combined_data.dta, replace
		






		

