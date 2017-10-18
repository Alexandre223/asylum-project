***********************
***DO FILE ELECTIONS***
***********************

clear 
set more off, permanently

* Create quarterly election data from parlgov data 
* on elections, party positions, parliament and cabinet


* 1, perpare file with future electins dates in 2017/2018

import excel ./src/original_data/destination_country/election_dates_17_18.xlsx, sheet("Tabelle1") firstrow clear
destring, replace

gen quarter = .
replace quarter = 1 if month < 4
replace quarter = 2 if month > 3 & month < 7
replace quarter = 3 if month > 6 & month < 10
replace quarter = 4 if month > 9

save ./out/data/temp/election_dates_17-18.dta, replace

* 2, prepare file with all election dates up to 2016 from parlgov and append 2017/2018 dates
import excel ./src/original_data/destination_country/parlgov_upto_2016.xlsx, sheet("election") firstrow clear

rename election_date temp_election_date
gen election_date=date(temp_election_date, "YMD")
drop temp_election_date

gen year = year(election_date)
gen quarter = quarter(election_date)
gen month = month(election_date)

drop if year<1991

drop if country_name == "Turkey" | country_name == "Australia" | ///
		country_name == "Canada" | country_name == "Iceland" | ///
		country_name == "Israel"  | country_name == "Japan" | ///
		country_name == "New Zealand" | country_name == "Croatia"

keep country_name election_date year quarter month election_type 
	
keep if election_type=="parliament"

*Create dummy for election month**
gen election=1

collapse year quarter month election,  by (country_name election_date)

* add electin dates in 2017 and 2018
rename country_name destination
append using ./out/data/temp/election_dates_17-18.dta

merge 1:1 destination month quarter year using ///
		./out/data/temp/destination_month_year_91_18.dta
drop _merge

save ./out/data/temp/parlgov_election_dates.dta, replace


* 3, calculate cabinet left-right position from parlgov data

import excel ./src/original_data/destination_country/parlgov_upto_2016.xlsx, sheet("cabinet") firstrow clear

keep if cabinet_party==1 

foreach var of varlist election_date start_date {
	rename `var' temp_`var' 
	gen `var' = date(temp_`var', "YMD")
	drop temp_`var' 
}
*

gen year = year(start_date)
gen quarter = quarter(start_date)
gen month = month(start_date)

drop if country_name == "Turkey" | country_name == "Australia" | ///
		country_name == "Canada" | country_name == "Iceland" | ///
		country_name == "Israel"  | country_name == "Japan" | ///
		country_name == "New Zealand" | country_name == "Croatia"
		
drop if year < 1991

* Note Lithuania 1991 two cabinets in same months, keep only 2nd,
* otherwise not uniquely identified**
duplicates list country_name year quarter month party_id cabinet_id
drop if country_name=="Lithuania" & cabinet_id==267

* Calculate the weighted average of party characteristics for cabinets

egen cabinet_count=group(cabinet_id)

gen position_left_right = left_right*seats
sort cabinet_id
by cabinet_id: egen seats_left_right = total(seats) if position_left_right != ., missing
by cabinet_id: egen position_left_right_sum = total(position_left_right) if position_`var'!=., missing
gen cabinet_left_right = position_left_right_sum / seats_left_right

sum cabinet_count
forvalues num=1/`r(max)' {
	qui sum cabinet_left_right if cabinet_count==`num' 
	replace cabinet_left_right=r(max) if cabinet_count==`num'
	}	
*

sum cabinet_left_right

* collapse data to cabinet level**
collapse (mean) year quarter month election_date start_date  ///
		cabinet_left_right,  by (country_name cabinet_id cabinet_name)
		
rename country_name destination


* merge with help file with all years and quarters
merge 1:1 destination month quarter year using ///
		./out/data/temp/destination_month_year_91_18.dta
drop _merge

merge 1:1 destination month quarter year using ./out/data/temp/parlgov_election_dates.dta

* fill up data to all month & years
replace election=0 if election==.
sort destination year quarter month
by destination: replace cabinet_left_right = cabinet_left_right[_n-1] ///
				if cabinet_left_right == . 


* create lagged cabinet position variables to use as instruments later on
sort destination year quarter month
by destination: gen past_cabinet_left_right=cabinet_left_right[_n-60] 
	
tab year if past_cabinet_left_right==.


* 3, collapse data to quarterly election data

sort destination year quarter month
by destination year quarter: egen election_quarter=max(election)

collapse (first) election_quarter past_cabinet_left_right cabinet_left_right, ///
		 by (destination year quarter)

rename election_quarter election

label variable cabinet_left_right "average left - right position of the cabinet"


* 4, create before and after dummies and correct for early elections

***Generate quarterly bef after dummies - 6 quarters before and 6 quarters after***
local i = 1
while `i' <= 6{
gen post`i'=0
by destination: replace post`i' = 1 if election[_n-`i'] == 1
local i = `i' + 1
}
*

local i = 1
while `i' <= 6{
gen bef`i'=0
by destination: replace bef`i' = 1 if election[_n+`i'] == 1
local i = `i' + 1
}
*

* Correct for early elections

sort destination year quarter
egen K=group(destination year quarter) 

**AUSTRIA**

**early election in Austria on 14th November 2002 (Q4 2002), announced in September 2002 (Q3 2002)**
**code only 1 quarter before the election as before election**
list K if destination=="Austria" & quarter==4 & year==2002

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==48-`t'
	 local t=`t'+1
	 }
	 * 	 

**early election in Austria on 1st October 2006 (Q4 2006), announced on 14th July 2006 (Q3 3016)**
**However initial election planned for November 2006 (Q4 2006) - do not code as early election**
 

**early election in Austria on 28th September 2008 (Q3 2008) and announced on 9th July 2008 (Q3 2008)**
**code no quarters before the election as before election**
list K if destination=="Austria" & quarter==3 & year==2008

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==71-`t'
	 local t=`t'+1
	 }
	 * 	 

	 
**BELGIUM**

**early election in Belgium on 13th June 2010 (Q2 2010) announced on 26th April 2010 (Q2 2010)**
**code no quarters before the election as before election**
list K if destination=="Belgium" & quarter==2 & year==2010

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==190-`t'
	 local t=`t'+1
	 }
	 *

	 
**BULGARIA***	 
	 
***Bulgaria early elections on 12th May 2013 (Q2 2013) announced on 28th of February (Q1 2013)**
**Note: elections were held 2 month ahead of schedule (initially planned in July, also Q2 2013)**
**As elections happen in the same quarter as expected do not change any before quarters***
	 
**Note: next early election already on 5th October 2014 (Q4 2014), announced on July 23rd (Q3 2014)**
**Code only Q3 2013 to Q2 2014 as post periods, only 4 quarters**
list K if destination=="Bulgaria" & quarter==2 & year==2013

 local t=5
	while `t'<=6 {
	by destination: replace post`t'=0 if K==314+`t'
	 local t=`t'+1
	 }
	 *

***Note: no inbetween periods**
	 
***Bulgaria early elections on 5th October 2014 (Q4 2014) announced on 23rd of July (Q3 2014)**
**code only 1 quarter before the election as before election**

list K if destination=="Bulgaria" & quarter==4 & year==2014

local t=2
	while `t'<=6{
	by destination: replace bef`t'=0 if K==320-`t'
	 local t=`t'+1
	 }
	 * 

***Bulgaria early elections on 26th March 2017 announced on 20th December 2016**
**Delete election in 2017 in Bulgaria**
	 
**CROATIA**	 
**Do not code early elections for Croatia**

**CYPRUS**
**no early elections in Cyprus**
	 
**CZECH REPUBLIC**
**early election in Czech Republic on 25th October 2013 (Q4 2013) and announced on 20th August 2013 (Q3 2013)**
**code only 1 quarter before the election as before election**
list K if destination=="Czech Republic" & quarter==4 & year==2013

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==540-`t'
	 local t=`t'+1
	 }
	 * 

**DENMARK**

**early election in Denmark on 8th February 2005 (Q1 2005) and announced on 18th January 2005 (Q1 2005)**
**code no quarters before the election as before election**
list K if destination=="Denmark" & quarter==1 & year==2005

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==617-`t'
	 local t=`t'+1
	 }
	 * 

**note election had to happen before 20th November 2005 (Q4 2005) (4 years after previous election)**
**code 6 quarters before Q4 2005 up to Q1 2005 as before the election**
list K if destination=="Denmark" & quarter==4 & year==2005

local t=4
	while `t'<=6 {
	by destination: replace bef`t'=1 if K==620-`t'
	 local t=`t'+1
	 }
	 * 
	
**early election in Denmark on 13th November 2007 (Q4 2007) and announced on 24th October 2007 (Q4 2007)**
**code no quarters before the election as before election**
list K if destination=="Denmark" & quarter==4 & year==2007

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==628-`t'
	 local t=`t'+1
	 }
	 * 	
	
***ESTONIA**
*no early elections in Estonia**
	
**FINLAND**
*no early elections in Finland**

**FRANCE**	
*no early elections in France**	
	
**GERMANY**
*no early elections in Germany**


***GREECE***	 
	 
**early election in Greece on 4th October 2009 (Q4 2009) and announced on 2nd September 2009 (Q3 2009)**
**code only 1 quarter before the election as before election**
list K if destination=="Greece" & quarter==4 & year==2009

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1196-`t'
	 local t=`t'+1
	 }
	 *	 

	 
**early election in Greece on 6th May 2012 (Q2 2012) and announced on 4th November 2011 (Q4 2011)**
**Note: all attempts to form a new givernment failed and therefore the new **
**      elected parliament was dissolved on May 19th and new elections were **
**      called for 17th June 2012 (Q2 2012)**
**TWO ELECTIONS IN Q2 2012
**code only 2 quarters before the election as before election**
**don't code any quarters after the election as after the election**
list K if destination=="Greece" & quarter==2 & year==2012

local t=3
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1206-`t'
	 local t=`t'+1
	 }
	 *		 
	 

	 
**early election in Greece on 25th January 2015 (Q1 2015) and announced on 29th December 2014 (Q4 2014)**
**code only 1 quarter before the election as before election**
**Note: next election already on 20th of September 2015 (Q3 2015), announced in on 20th August 2015 (Q3 2015)**
** code only 1 quarter after the election as post election** 
list K if destination=="Greece" & quarter==1 & year==2015

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1217-`t'
	 local t=`t'+1
	 }
	 *	
**Note: next election already on 20th of September 2015 (Q3 2015), announced in on 20th August 2015 (Q3 2015)**
** code only 1 quarter after the election as post election**
local t=2
	while `t'<=6 {
	by destination: replace post`t'=0 if K==1217+`t'
	 local t=`t'+1
	 }
	 *		 

**early election Greece on 20th of September 2015 (Q3 2015), announced in on 20th August 2015 (Q3 2015)**
**code no quarters before the election as before election**
list K if destination=="Greece" & quarter==3 & year==2015

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1219-`t'
	 local t=`t'+1
	 }
	 *


**HUNGARY**
*no early elections in Hungary**


**IRELAND**
*no early elections in Ireland**
*Election in 2011 was some month earlier than it had to be by the consitution, however it was expected to be like that**


**ITALY***
**early election in Italy on 9th April 2006 announced on 18th October 2005**
**election initially would have taken place in June**
**very close together and anounced well in advance, code as normal election**

**early election in Italy on 14th April 2008 (Q2 2008) announced on 6th February 2008 (Q1 2008)**
**code only 1 quarter before the election as before election**
list K if destination=="Italy" & quarter==2 & year==2008

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1526-`t'
	 local t=`t'+1
	 }
	 *

**LATVIA**	 
	 
**early election in Latvia 17th September 2011 (Q3 2011) announced on 23rd July 2011 (Q3 2011)**
**code no quarters before the election as before election**
list K if destination=="Latvia" & quarter==3 & year==2011

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1651-`t'
	 local t=`t'+1
	 }
	 *

**Previous election in Latvia was only on 2nd October 2010 (Q4 2010)**
**Code only quarters Q1 and Q2 2011 as after the election**
list K if destination=="Latvia" & quarter==4 & year==2010

local t=3
	while `t'<=6 {
	by destination: replace post`t'=0 if K==1648+`t'
	 local t=`t'+1
	 }
	 *
	 
**LITHUANIA**
*no early elections in Lithuania**

**LUXEMBOURG**
*early election in Luxembourg on 20th October 2013 (Q4 2013), announced on 19th July 2013 (Q3 2013)**
**code only 1 quarter before the election before 
list K if destination=="Luxembourg" & quarter==4 & year==2013

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==1884-`t'
	 local t=`t'+1
	 }
	 *	 

**Elections would initially have been in June 2014 (Q2 2014)**
**Code 6 quarters before planned election in Q2 2014
**up to the announcement of the early election in July2013 as before the election** 
list K if destination=="Luxembourg" & quarter==2 & year==2014

local t=3
	while `t'<=6 {
	by destination: replace bef`t'=1 if K==1886-`t'
	 local t=`t'+1
	 }
	 *	 
 
**MALTA**
*no early elections in Malta**

 
**NETHERLANDS**

**early election in Netherlands on 22nd January 2003(Q1 2003) announced on 16th October 2002 (Q4 2002)**
**Code only 1 quarter before the election as before election**
list K if destination=="Netherlands" & quarter==1 & year==2003

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2065-`t'
	 local t=`t'+1
	 }
	 *

**Note: the election before was only on May 15th 2002 (Q2 2002)**
**Code only 1 quarter after the election in May 2002 (Q2 2002) as after the election, 
**because in October (Q4 2002) already the new elections are announced
list K if destination=="Netherlands" & quarter==2 & year==2002

local t=2
	while `t'<=6 {
	by destination: replace post`t'=0 if K==2062+`t'
	 local t=`t'+1
	 }
	 *
	 
**early election in Netherlands on 22nd November 2006 (Q4 2006) announced on 30th June 2006 (Q2 2006)**
**Code only 2 quarters before the election as before election**
list K if destination=="Netherlands" & quarter==4 & year==2006

local t=3
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2080-`t'
	 local t=`t'+1
	 }
	 *	 

**Election was initially planed for 15th May 2007 (Q2 2007)**
**Code before regular election up to the announcement of the early elections**
list K if destination=="Netherlands" & quarter==2 & year==2007

local t=5
	while `t'<=6 {
	by destination: replace bef`t'=1 if K==2082-`t'
	 local t=`t'+1
	 }
	 *		 
	 
	 
**early election in Netherlands 9th June 2010 (Q2 2010) announced on 23rd February 2010 (Q1 2010)**
**code only 1 quarter before the election as before election**
list K if destination=="Netherlands" & quarter==2 & year==2010

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2094-`t'
	 local t=`t'+1
	 }
	 *

**early election in Netherlands 12th September 2012 (Q3 2012) announced on 23rd April 2012 (Q2 2012)**
**code only 1 quarter before the election as before election**
list K if destination=="Netherlands" & quarter==3 & year==2012

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2103-`t'
	 local t=`t'+1
	 }
	 *


**NORWAY**
*no early elections in Norway**

**POLAND**
**early election in Poland on 21st October 2007 (Q4 2007) announced on September 7th 2007 (Q3 2007)**
**code only 1 quarter before the election before election
list K if destination=="Poland" & quarter==4 & year==2007

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2308-`t'
	 local t=`t'+1
	 }
	 *
	 

**PORTUGAL**
**early election in Portugal on 17th March 2002 (Q1 2002) and announced on 28th December 2001 (Q4 2001)**
**code only 1 quarter before the election as before election**
list K if destination=="Portugal" & quarter==1 & year==2002

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2397-`t'
	 local t=`t'+1
	 }
	 * 	

**early election in Portugal on 20th February 2005 (Q1 2005) and announced on 30th November 2004 (Q4 2004)**
**code only 1 quarter before the election as before election**
list K if destination=="Portugal" & quarter==1 & year==2005

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2409-`t'
	 local t=`t'+1
	 }
	 * 	 

	
**early election in Portugal on 5th June 2011 (Q2 2011) and announced on 1st April 2011 (Q2 2011)**
**code no quarters before the election as before election**
list K if destination=="Portugal" & quarter==2 & year==2011

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2434-`t'
	 local t=`t'+1
	 }
	 * 	 

** No inbetween quarters between this election and the election before**
** Previous election in Portugal in September 2009 (Q3 2009) - 6 quarters after is Q1 2011**
** in Q2 2011 already before next early election**


**ROMANIA**
*no early elections in Romania**

**SLOVAKIA**
***Slovakia early election on 17th June 2006 (Q2 2006) announce on 13th February 2006 (Q1 2006)**
**Code only 1 quarter before the election as before months**
list K if destination=="Slovakia" & quarter==2 & year==2006

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2638-`t'
	 local t=`t'+1
	 }
	 *  

**Election initially planned for 16th September 2006 (Q3 2006)**
**Code quarters before Q3 2006 as before the election until new date was announced in Q1**
list K if destination=="Slovakia" & quarter==3 & year==2006

local t=3
	while `t'<=6 {
	by destination: replace bef`t'=1 if K==2639-`t'
	 local t=`t'+1
	 }
	 * 
	 
***Slovakia early election on 10th March 2012 (Q1 2012) announce on 13th October 2011 (Q4 2011)**
**Code only 1 quarter before the election as before months**
list K if destination=="Slovakia" & quarter==1 & year==2012

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2661-`t'
	 local t=`t'+1
	 }
	 *  

**The election before was only on 12th June 2010 (Q2 2010), less than 6 quarters before
** the new election was announced
list K if destination=="Slovakia" & quarter==2 & year==2010

local t=6
	while `t'<=6 {
	by destination: replace post`t'=0 if K==2654+`t'
	 local t=`t'+1
	 }
	 *  

	 
**SLOVENIA**

**early election in Slovenia on 4th December 2011 (Q4 2011) and announced on 21st October 2011 (Q4 2011)**
**code no quarters before the election as before election**
list K if destination=="Slovenia" & quarter==4 & year==2011

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2772-`t'
	 local t=`t'+1
	 }
	 * 

**early election in Slovenia on 13th July 2014 (Q3 2014) and announced on 1st June 2014 (Q2 2014)**
**code only 1 quarter before the election as before election**
list K if destination=="Slovenia" & quarter==3 & year==2014

local t=2
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2783-`t'
	 local t=`t'+1
	 }
	 * 	 

	 
***SPAIN***	 
	 
**Spain early election on 20th November 2011 (Q4 2011) announced 29th July 2011 (Q2 2011)**
**Election initially would have been schedueled 9th April 2012 (Q2 2012)**
**Code only 2 quarters before the November election as before** 	 
list K if destination=="Spain" & quarter==4 & year==2011

local t=3
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2884-`t'
	 local t=`t'+1
	 }
	 *  

**code 6 quarters up to Q2 2011 as before planned election in April 2012 (Q2 2012)**
list K if destination=="Spain" & quarter==2 & year==2012

local t=5
	while `t'<=6 {
	by destination: replace bef`t'=1 if K==2886-`t'
	 local t=`t'+1
	 }
	 *

** regular election in Spain on December 20th 2015 (Q4 2015), however unabled to form a government **
** therefore next early election already on 26th June 2016 (Q2 2016) announced on 3rd May 2016 (Q2 2016)
**Code only 1 quarter after the election as post periods**
list K if destination=="Spain" & quarter==4 & year==2015

local t=2
	while `t'<=6 {
	by destination: replace post`t'=0 if K==2900+`t'
	 local t=`t'+1
	 }
	 *  

	 
**Spain early election on 26th June 2016 (Q2 2016) announced on 3rd May 2016 (Q2 2016)**
**code no quarters before the election as before election** 
list K if destination=="Spain" & quarter==2 & year==2016

local t=1
	while `t'<=6 {
	by destination: replace bef`t'=0 if K==2902-`t'
	 local t=`t'+1
	 }
	 *  	 	 
	 
	 
**SWEDEN**
**no early elections in Sweden**	 
	

**SWITZERLAND**
*no early elections in Switzerland**
	
**UK**
	 
**UK early elections 8th June 2017 announced in April 2017**
**UK early election not included in the 2017/2018 elections file **


drop if year<2002
drop if year>2016


save ./out/data/temp/election_data_quarterly.dta, replace
