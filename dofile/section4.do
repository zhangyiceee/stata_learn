
*=========================
**section 4
**Bar graphs
*=========================
	clear all 
	set more off
*======================*
*note ：每次做练习请先运行下面两行；run the next two row first
	cd "/Users/zhangyi/Documents/GitHub/statagraph/data"
	global outdir "/Users/zhangyi/Documents/GitHub/statagraph/output"


	use nlsw.dta,clear
	graph bar ttl_exp
	
*page 108
	graph  bar prev_exp tenure ttl_exp
	

	graph bar (median) prev_exp tenure ttl_exp

*page 109
	graph bar (mean) meanwage=wage (median) medwage=wage

	graph bar prev_exp tenure ttl_exp hours


*page 110
	graph bar prev_exp tenure ttl_exp hours,ascategory

	graph bar prev_exp tenure ,over(occ5)

	graph bar prev_exp tenure ,over(occ5) percentages

*page 111
	graph bar prev_exp tenure ,over(occ5) stack

	graph bar prev_exp tenure ,over(occ5) stack percentages
	

*4.2 grephing bars over groups
*page 112
	use nlsw.dta,clear
	graph hbar wage ,over(occ5)
*graph hbar to produce horizontal rather than vertical

	graph hbar wage ,over(occ5) over(collgrad)
*use the over() option twice to show the wages broken down by occupation and whether one graduated college

	graph hbar wage ,over(urban2) over(occ5) over(collgrad)

*page 113
	graph hbar prev_exp tenure ttl_exp
	graph hbar prev_exp tenure ttl_exp ,over(occ5)
	graph hbar prev_exp tenure ttl_exp ,over(occ5) over(union)

	graph bar wage ,over(occ5) over(union) 

*page 115
	clear all
	use nlsw.dta,clear
	graph bars wage ,over(occ5) over(union) asyvar
*add the asyvars option ,then the first over() variable(occ5) is graphed  as if there were five y_vars corresponding to the five levels of occ5
	graph bar wage ,over(occ5) over(union) asyvars percentages

	graph bar wage ,over(occ5) over(union) asyvars percentages stack
*page 116
	graph hbar wage ,over(urban3) over(union)
	graph hbar wage ,over(urban3) over(union) missing
	graph hbar wage ,over(urban3) over(union) missing
	graph bar wage ,over(grade) over(collgrad)
	graph bar wage ,over(grade) over(collgrad) nofill

*page 117
*4.3 Options for groups, over options
	use nlsw.dta,clear
	graph hbar wage ,over(grade4) over(union)

	graph hbar wage ,over(grade4, gap(*3)) over(union)

	graph hbar wage ,over(grade4, gap(*.3)) over(union)


*page 119
	graph hbar wage ,over(grade4,gap(*.2)) over(union,gap(*3))

	graph hbar wage ,over(occ7,descending)
*using the descending option switches the order of the bars 
	
*page 120
	graph hbar wage ,over(occ7,sort(occ7alpha))
*sort(occ7alpha) option has the effect of alphabetizing the bars.
	graph hbar wage ,over(occ7,sort(1))
*sort(1) means to sort the bars according to the height of the first y_var,in this case ,the mean of wage

	graph hbar wage ,over(occ7,sort(1) descending) 

*page 121
	graph hbar wage hours,over(occ7,sort(1))
*sort(1) option sorts the bars according to the mean of wage since that is the first y_var
	
	graph hbar wage hours,over(occ7,sort(2))
*changing sort(1) to sort(2) sorts the bars according to the second y_var,the mean of hours .

	graph hbar wage hours ,over(occ7,sort(1)) over(married)

	graph hbar wage wage hours ,over(occ7,sort(2)) over(married,descending)
*page 122
	graph hbar (sum) wage ,over(collgrad) over(occ7) asyvars stack

	graph hbar (sum) wage ,over(collgrad) over(occ7,sort((sum) wage)) asyvars stack
*here we add sort((sum) wage) to the over() option for icc7,and then the bars are sorted on the sum of wages at each level of occ7,sorting the bars on their total height.
	
*page 123	
	graph hbar (sum) wage ,over(collgrad) over(occ7,sort((sum)wage) descending) asyvars stack
	

*4.4controlling the categorical axis
*page 123
	use nlsw.dta,clear
	graph bar wage ,over(grade6) over(south) asyvars
*adding the asyvars option graphs the levels of education level as differently colored bars,as though they were different y_vars

*page 124
	graph bar wage ,over(grade6) over(south,relabel(1 "N & W" 2"South")) asyvars
*the relabel() option is used to change the labels displayed for the levels of south,giving the x_axis more meaningful labels.
*Note that we worte relabel(1 "N & W") and not relabel(0 "N & W") since these numbers do not represent the actual levels of south but the ordinal position of the levels,first and second.
	
	graph bar wage, over(grade6) over(union,relabel(3 "missing")) missing asyvars

	graph hbar wage , over(grade6) over(south,relabel(1 "N & W" 2 "South")) over(smsa,relabel(1"Non Metro" 2"metro"))
	
	*page 125
	graph hbar prev_exp tenure ttl_exp, ascategory over(age3)
	
	graph hbar prev_exp tenure ttl_exp , ascategory over(age3) yvaroptions(relabel(1"Previous Exp"2"Current Exp"3"Total Exp"))

	graph hbar prev_exp tenure ttl_exp ,ascategory over(age,relabel(1"34-37 yrs"2"38-41 yrs"3"42-46 yrs")) yvaroptions(relabel(1"Previous Exp"2"Current Exp"3"Total Exp"))

	*page126
	use nlsw.dta,clear
	graph hbar prev_exp tenure ttl_exp , ascategory xalternate ///
	over(age3,relabel(1 "34-37 yrs" 2 "38-41yrs" 3 "42-46yrs")) ///
	yvaroptions(relabel(1 "Previous Exp" 2 "Current Exp" 3 "Total Exp"))

	graph bar wage , over(occ7,label(nolabel))

	*page 127
	graph bar wage , over(occ7 ,label(nolabels)) blabel(group)

	graph bar wage , over(occ7 , label(angle(45))) over(collgrad)
	*label(angel(45))option is added to rotate the labels for occupation by 45 degrees
	







	
	
	
	