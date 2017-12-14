
clear 
set more off, permanently
cd F:/research/asylum-project

use "F:\research\asylum-project\out\data\final_application\baseline_data.dta"

collapse (sum) firsttimeapp, by (destination year quarter)

replace firsttimeapp = . if firsttimeapp == 0

gen yearquarter = year * 10 + quarter 
drop year quarter

reshape wide firsttimeapp, i(destination) j(yearquarter)

export excel using "G:\PROJ\Marcus + Martina\christmas-conference\presentation\descriptives.xlsx", sheetreplace firstrow(variables)
