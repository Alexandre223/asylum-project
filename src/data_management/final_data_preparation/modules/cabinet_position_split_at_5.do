*********************************
** Cabinet Position Left-Right **
*********************************

* Create two dummies for cabinet position, left and right split at 5
gen cabinet_left=0
replace cabinet_left=1 if cabinet_left_right<5

gen cabinet_right=0
replace cabinet_right=1 if cabinet_left_right>=5
