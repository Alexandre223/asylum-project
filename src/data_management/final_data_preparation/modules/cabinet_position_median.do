*********************************
** Cabinet Position Left-Right **
*********************************

* Create two dummies for cabinet position, left and right
* split of the median of all cabinet positions in the sample
egen split=xtile(cabinet_left_right), n(2)

gen cabinet_left=0
replace cabinet_left=1 if split==1

gen cabinet_right=0
replace cabinet_right=1 if split==2

label variable cabinet_left "Weighted cabinet position left"
label variable cabinet_right "Weighted cabinet position right"
