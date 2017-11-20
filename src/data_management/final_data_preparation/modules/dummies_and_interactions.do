***************************************************************
** 		Create before after dummies and interaction terms    **
** for the respective number of quarters around the election **
***************************************************************

*local q = 6

* 1, generate one dummy before and one dummy after the election

gen bef_dummy = 0
local t = 1
local l = $q - 1
while `t' <= `l' {
replace bef_dummy = 1 if bef`t' == 1
 local t = `t' + 1
 }
*

replace bef_dummy = 1 if election == 1


gen post_dummy = 0
local t = 1
while `t' <= $q {
replace post_dummy = 1 if post`t' == 1
 local t = `t' + 1
 }
*


label variable bef_dummy "Time period before the election"
label variable election "Quarter of the election"
label variable post_dummy "Time period after the election"



* 2, Create Interaction Terms with the aggregated bef and after dummy

* Left 
gen left_bef = cabinet_left * bef_dummy
gen left_post = cabinet_left * post_dummy

* Right
gen right_bef = cabinet_right * bef_dummy
gen right_post = cabinet_right * post_dummy


label variable left_bef "Cabinet position left * Before the election"
label variable left_post "Cabinet position left * After the election"
label variable right_bef "Cabinet position right * Before the election"
label variable right_post "Cabinet position right * After the election"


*, 3 create interaction terms with all before, after and election dummies
sort destination origin year quarter

* Left
local t = 1
while `t' <= $q {
	by destination: gen bef`t'_left = bef`t'*cabinet_left
	label variable bef`t'_left "Cabinet position left * `t' quarters before the election" 
	local t = `t' + 1
 }
*

gen elec_left = election * cabinet_left
label variable elec_left "Cabinet position left * election quarter"

local t = 1
while `t' <= $q {
	by destination: gen post`t'_left = post`t' * cabinet_left
	label variable post`t'_left "Cabinet position left * `t' quarters after the election" 
	local t = `t' + 1
 }
*

* Right
local t = 1
while `t' <= $q {
	by destination: gen bef`t'_right = bef`t'*cabinet_right
	label variable bef`t'_right "Cabinet position right * `t' quarters before the election" 
	local t = `t' + 1
 }
*

gen elec_right = election*cabinet_right
label variable elec_right "Cabinet position right * election quarter"

local t = 1
while `t' <= $q {
	by destination: gen post`t'_right = post`t'*cabinet_right
	label variable post`t'_right "Cabinet position right * `t' quarters after the election"
	local t =`t' + 1
 }
*


