********************************************
** Normalized Cabinet Position Left-Right **
********************************************

* Create two dummies for cabinet position, left and right
* split of the median of all cabinet positions in the sample
* normalize cabinet position at the country level before splitting

bysort destination: egen mean_cabinet= mean(cabinet_left_right)
bysort destination: egen sd_cabinet= sd(cabinet_left_right)

gen norm_cabinet=(cabinet_left_right - mean_cabinet)/sd_cabinet

egen split=xtile(norm_cabinet), n(2)

gen cabinet_left=0
replace cabinet_left=1 if split==1

gen cabinet_right=0
replace cabinet_right=1 if split==2

label variable cabinet_left "Weighted cabinet position left"
label variable cabinet_right "Weighted cabinet position right"
