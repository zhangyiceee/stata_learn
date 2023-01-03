*总练习do
	clear all 
	set more off

*note ：每次做练习请先运行下面两行；run the next two row first
	cd "/Users/zhangyi/Documents/GitHub/stata_learn/data"
	global outdir "/Users/zhangyi/Documents/GitHub/statagraph/output"

*page2
	use allstates.dta ,clear
	graph twoway scatter propval100 ownhome,msymbol(Sh)

*page5
	graph twoway scatter propval100 popden

	twoway lfit propval100 popden //line fit line predicting propval100 from popden

*page6
	twoway (scatter propval100 popden) (lfit propval100 popden)
	twoway (scatter propval100 popden) (lfit propval100 popden)(qfit propval100 popden) //with a quadratic fit line 

	twoway (scatter propval100 popden) (mspline propval100 popden) ///
		(fpfit propval100 popden) (mband propval100 popden) ///
		(lowess propval100 popden)

*page 7
	twoway (lfitci propval100 popden) (scatter propval100 popden) //加入置信区间

	use spjanfeb2001.dta,clear 
	twoway dropline close tradeday
	twoway spike close tradeday
	twoway dot close tradeday

*page8
	twoway line close tradeday ,sort
	twoway connected close tradeday ,sort

*page9
	use sp2001ts.dta,clear
	twoway tsline close ,sort //tsline(time series line)

	twoway tsrline high low ,sort //将高价和低价放在一起

	use spjanfeb2001.dta,clear 
	twoway area close tradeday ,sort //the area under the line is shaded.

*page9 
	twoway bar close tradeday

	twoway rarea high low tradeday,sort //fill the area between high and low price 
	twoway rconnected high low tradeday,sort

*page 11
	use spjanfeb2001.dta,clear
	twoway rcap high low tradeday ,sort

	twoway rbar high low tradeday,sort


	use allstates.dta,clear
	twoway histogram popk,freq
	twoway kdensity popk

*twoway function y=normden(x),range(-4 4) //做不出来

	graph matrix propval100 rent700 popden

*page 13
	graph hbar popk,over(division)

	graph hbox popk,over(division)
	graph dot popk ,over(division)




*page 15
	use allstates.dta,clear
	twoway scatter propval100 rent700 ownhome


	use nlsw.dta,clear
	graph hbox wage ,over(grade) asyvar nooutsides legend(row(2))
/*
中间有很大一部分是图形的颜色讲解，在此先掠过
*/


*page 20   1.4 options 
	use allstates.dta,clear
	twoway scatter propval100 rent700
	twoway scatter propval100 rent700 ,title("This is a title for the graph")
	twoway scatter propval100 rent700 ,title("This is a title for the graph",box)
	twoway scatter propval100 rent700 ,title("This is a title for the graph",box size(small))
	twoway scatter propval100 rent700 ,title("This is a title for the graph",box size(small)) msymbol(S) //make the marker symbol to be displayed as a square


	twoway scatter propval100 rent700
	twoway scatter propval100 rent700 ,xlabel(0(5)40) //label the x_axis from 0 to 40 ,incrementing by 5
	twoway scatter propval100 rent700,xlabel(0(5)40,labsize(huge)) //increase the size of labels for the x_axis

	use allstates.dta ,clear
	twoway scatter propval100 rent700 popden
	twoway scatter propval100 rent700 popden ,legend(cols(1))

	twoway scatter propval100 rent700 popden ,legend(cols(1) label (1 "Property Values")) //change the label for the first var

	twoway scatter propval100 rent700 popden , ///
		legend(cols(1) label (1 "Property Values") label(2 "Rent")) 

	twoway (scatter propval100 popden) (lfit propval100 popden)


*page 26
	twoway (scatter propval100 popden,msymbol(S))(lfit propval100 popden,clwidth(vthick))

	twoway (scatter propval100 popden,msymbol(S))(lfit propval100 popden,clwidth(vthick)) ///
		,title("This is the title of the graph")


	twoway scatter propval100 rent700 popden ,legend(position(1)) //make the legend display in the one o'clock
	graph bar propval100 rent700 ,over(nsw) legend(position(1))

	graph matrix propval100 rent700 popden,legend(position(1))


*page 29 1.5 building graphs
	use allstates.dta,clear 
	graph bar propval100 ,over(nsw) over(division)

*page 30
	graph bar propval100 ,over(nsw) over(division) nofill

	graph bar propval100 ,over(nsw) over(division) nofill asyvars

	graph bar propval100 ,over(nsw) over(division) nofill asyvars ytitle("% homes over $100K") //ytitle() for putting a title on the y_axis

*page31
	graph bar propval100 ,over(nsw) over(division) nofill asyvars ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) 
*angle() option to change the angle of the label,逆时针旋转相应度数

	graph bar propval100 ,over(nsw) over(division) nofill asyvars ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) b1title(Region) 
	*b1title() to put a title below the graph

	graph bar propval100 ,over(nsw) over(division) nofill asyvars ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) ///
		b1title(Region) legend(rows(1) position(1) ring(0)) 
	*rows() option make the lengend appear in one row ,position() option put the lengend in 1 o'clock position

	graph bar propval100 ,over(nsw) over(division) nofill asyvars ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) ///
		b1title(Region) legend(rows(1) position(1) ring(0)) blabel(bar)
	*blabel() (bar label) option to label the bars in lieus of legend


	graph bar propval100 ,over(nsw) over(division) nofill asyvars ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) ///
		b1title(Region) legend(rows(1) position(1) ring(0)) blabel(bar ,format(%4.2f))
	*format these numbers as we wish


*page 33

	graph bar propval100 ,over(nsw) over(division,label(angle(45))) nofill  ///
		ytitle("% homes over $100K") ylabel(0(10)80,angle(0)) ///
		b1title(Region) legend(rows(1) position(1) ring(0)) blabel(bar ,format(%4.2f)) asyvars


*======================*
*======================*
*======================*

















