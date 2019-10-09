	clear all 
	set more off
*======================*
*note ：每次做练习请先运行下面两行；run the next two row first
	cd "/Users/zhangyi/Documents/GitHub/statagraph/data"
	global outdir "/Users/zhangyi/Documents/GitHub/statagraph/output"

*2 Twoway graph     ///page 35

	use allstates.dta,clear
	graph twoway scatter ownhome propval100
*上述可以精简到直接用 scatter

	twoway scatter ownhome propval100 ,msymbol(Oh) //control the marker symbol with the mysymbol() 
*see help symbolstyle


*page 37
	twoway scatter ownhome propval100 ,mcolor(mint) 
		vgcolormap ,quietly //show difference standard colors 

	twoway scatter ownhome propval100 ,mcolor(mint) msize(vlarge)
*msize() :control the marker size 

	twoway scatter ownhome propval100 [aweight=rent700],msize(small) 

	twoway scatter ownhome propval100,mlabel(stateab)
	twoway scatter ownhome propval100,mlabel(stateab) mlabsize(vlarge)
*mlabel(stateab) option can be used to add a marker label with state abbreviation

	twoway scatter ownhome propval100,mlabel(stateab) mlabposition(12)
*mlabposition() option controls the marker label position with respect to the marker


*page 39
	use allstates.dta,clear
	twoway scatter ownhome propval100 ,mlabel(stateab) mlabposition(0) msymbol(i)
*mlabposition(0) places the marker label in the center position

	regress ownhome propval100
	predict fv
	twoway scatter fv propval100

	twoway scatter fv propval100,connect(1) sort
*sort option is generally recommended when you connect observations and the data are not already sorted on the x_variable

	twoway scatter fv ownhome propval100,connect(1 i) sort
*connect(1 i) specificies that the first y_var should be coonnected with straight lines and the second y_var should not be connected

	twoway scatter fv ownhome propval100,msymbol(i .) connect(1 i)  sort
/*msymbol(i .):the first y_var should not have symbols displayed
(i for invisible symbol) and that the second y_var should have default symbols displayed
*/
	twoway scatter fv ownhome propval100,msymbol(i .) connect(1 i)  sort legend(label(1 Pred. Prec. Own))

*page 41
	twoway scatter fv ownhome propval100,msymbol(i .) connect(1 i)  sort legend(label(1 Pred. Prec. Own) order(2 1))
*the order() option can be used to specify the order in which the items in the legend are displayes

	twoway scatter ownhome propval100 ///
		,xtitle("Percent homes over $100K")  ytitle("Percent who ownhome")

	twoway scatter ownhome propval100 ///
		,xtitle("Percent homes over $100K")  ytitle("Percent who ownhome",size(huge))


	twoway scatter ownhome propval100 ,xlabel(0(10)100) ylabel(40(5)80)

	twoway scatter ownhome propval100 ,xlabel(#10) ylabel(#5)
*xlabel(#10) to ask stata to use approximately 10 nice labels 

*page 43 
	use allstates.dta,clear
	twoway scatter ownhome propval100 ,xlabel(#10) ylabel(#5,nogrid)
/*
using nogrid option,we can supress the display of the grid.
Note that this option is placed within the ylabel() option 
*/

	twoway scatter ownhome propval100 ,xlabel(#10) ylabel(#5,nogrid) ///
		yline(55 60 75,lwidth(thin) lcolor(black) lpattern(dash))


	twoway scatter ownhome propval100 ,xscale(alt)
*use the xscale() option to request that the x_axis be placed in its alternate position

*page 44
	twoway scatter ownhome propval100,by(nsw)
*the by(nsw) option is used here to make separate graph for statas in the North South and West

	twoway scatter ownhome propval100 ,by(nsw,total)
*the total option can be used within the by() option to add an additional graph showing all the observations

	twoway scatter ownhome propval100 ,by(nsw,total compact)
*紧凑选项

*page45 
	twoway scatter ownhome propval100 ,text(47 62 "Washington,DC",size(large) ///
		margin(medsmall) blwidth(vthick) box)

	twoway (scatter ownhome propval100 )(scatteri 42.6 62.1 "DC")

	twoway (scatter ownhome propval100) (scatteri 42.6 62.1 "DC" 55.9 89 (8) "HI") ,legend(off)
*legend(off) option supresses the legend

	use allstates.dta,clear
	twoway scatter r yhat





*page 49 
*Regression fits and splines
	use allstates.dta,clear
	twoway (scatter ownhome pcturban80)(lfit ownhome pcturban80)
	twoway (scatter ownhome pcturban80)(lfit ownhome pcturban80)(qfit ownhome pcturban80)

	twoway (scatter ownhome pcturban80)(mspline ownhome pcturban80)(fpfit ownhome pcturban80) (lowess ownhome pcturban80)
*mspline(median spline) fpfit(fractional polynomial fit)


*2.3 Regression cofidence interval(CI) fits
*page 51
	use allstates.dta,clear
	twoway (lfitci ownhome pcturban80) (scatter ownhome pcturban80) 
*lfitci command to produce a liner fit with confidence interval

	twoway (scatter ownhome pcturban80) (lfitci ownhome pcturban80)
*注意上下的区别，先后顺序不同

	twoway (lfitci ownhome pcturban80,stdf) (scatter ownhome pcturban80) 

*page 52
	twoway (lfitci ownhome pcturban80,stdf level(90)) (scatter ownhome pcturban80) 
*level() to set the confidence level for the confidence interval

	twoway (lfitci ownhome pcturban80,nofit) (scatter ownhome pcturban80) 
*supress the display of the fit line 

	twoway (lfitci ownhome pcturban80,clpattern(dash) clwidth(thick)) (scatter ownhome pcturban80) 

*page 53
	twoway (lfitci ownhome pcturban80,bcolor(stone))(scatter ownhome pcturban80)

	twoway (lfitci ownhome pcturban80,ciplot(rline))(scatter ownhome pcturban80)
*display the confidence interval as two lines without any filled areas

	twoway (lfitci ownhome pcturban80,ciplot(rline) blcolor(green) blpattern(dash) blwidth(thick))(scatter ownhome pcturban80)




*2.4 Line plots
*page 54
	use spjanfeb2001.dta ,clear
	twoway line close tradeday,sort //注意连线时需要sort，sort X

	twoway line close tradeday,sort clwidth(vthick) clcolor(maroon)
* clwidth(connect line width)  clcolor(connect line color)

*page 55 
	twoway connected close tradeday,sort 
	twoway scatter close tradeday,connect(1) sort
*same output

	twoway connected close tradeday ,sort msymbol(Sh) mcolor(blue) msize(large)
*msymbol mcolor msize to control the marker symbols

*page 56
	twoway connected close tradeday ,sort clcolor(cranberry) clpattern(dash) clwidth(thick)
*clcolor() clpattern() clwidth() connect line pattern
	twoway connected high low tradeday,sort

	twoway connected high low tradeday,sort clwidth(thin thick) msymbol(Sh O)


*page 57
	use sp2001ts.dta,clear
	twoway tsline close 
*time_series_line

	twoway tsrline low high
*time_series_range

*page 58
	twoway tsline close ,clwidth(thick) clcolor(navy)

	twoway tsline close if (date >= mdy(1,1,2001)) & (date <= mdy(3,31,2001))
*加条件

	twoway tsline close if  tin(01jan2001,31mar2001)
*tin() time in between


*page59
	twoway tsline close,ttitle(day of year)
	twoway tsline close,xtitle(day of year)
*在时间为横轴的情况下，ttitle(time title)和xtitle相同

	twoway tsline close,tlabel(01jan2001 31mar2001 21jun2001 30sep2001 01jan2002)

	twoway tsline close ,tlabel(01jan2001 30jun2001 01jan2002) tmlabel(31mar2001 30sep2001)
*use tmlabel() option to include minor labels


*page 60 
	use sp2001ts.dta,clear
	twoway tsline close ,tlabel(01jan2001 30jun2001 01jan2002) tmtick(31mar2001  30sep2001)
	twoway tsline close,tline(01apr2001 01jul2001 01oct2001)

	twoway tsline close,ttext(1035 01apr2001 "Start of Q2",orientation(vertical))
*use the ttext() option to add text to the graph


*2.5 Area plots 
*page 61
* "twoway area" is similar to "twoway line",expect that the area under the line is shaded.


	use spjanfeb2001.dta,clear
	twoway area close tradeday,sort
*if the data are not sorted ,and the sort option is not specified,
*then the points are connected in the order they appear in data file
*and will generally not be the graph you desire

	twoway area close tradeday ,horizontal sort xtitle(Title for X_axis) ytitle(Title for Y_axis)

	twoway area close tradeday,sort base(1320)

	twoway area close tradeday,sort bcolor(red)


*2.6 Bar Plots
*page 63
	use spjanfeb2001.dta,clear
	twoway (bar close tradeday)(line close tradeday,sort)

	twoway bar close tradeday ,base(1200)

*page 64
	twoway bar close tradeday ,barwidth(.5)
*making the width of the bars .5

	twoway bar close tradeday ,bfcolor(gs15) blcolor(gs5)

*2.7 Range plots
*page 65
	use spjanfeb2001.dta,clear
	twoway rconnected high low tradeday,sort
*rconnected(range connected)

	twoway rscatter high low tradeday
*same as rconected

	twoway rline high low tradeday ,sort
*sort is needed if the data were not already sorted on tradeday

*page 66
	twoway rarea high low tradeday ,sort
*fille the color of the area between the high and low values

	twoway rcap high low tradeday
*the rcap graph shows a spike ranging from the low to high values
*and puts a cap at the top and bottom of each spike

	twoway rspike high low tradeday
*rspike is similar to the rcap graph,expect that no caps are 
*placed on the spikes

	twoway rcapsym high low tradeday ,msymbol(Sh)


	twoway rbar high low tradeday

*page 68

	use spjanfeb2001.dta,clear
	twoway rconnected high low tradeday,sort

*page69
	twoway rconnected high low tradeday,sort blwidth(thick) bcolor(mint) blpattern(longdash)
*linepattern :solid dash longdash_dot dot longdash dash_dot shortdash shortdash_dot 
*(vgcolormap,quietly ) 此命令查看颜色表

	twoway rconnected high low tradeday,sort msymbol(S) msize(large) mcolor(lavender)

	twoway rconnected high low tradeday,sort msymbol(S) msize(large) mcolor(lavender)

	twoway rscatter high low tradeday ,sort msymbol(Sh) msize(medium) mlwidth(thick)

	twoway rline high low tradeday ,sort blwidth(thick) blcolor(blue)

	twoway rarea high low tradeday ,sort bcolor(red)
* use the bcolor() option to make the color of the line and the area teal


	twoway rarea high low tradeday ,sort blcolor(emerald) bfcolor(teal) blwidth(thick)
*make the color of the line emereald with the blcolor() 
*fill color teal with the bfcolor()



*page 71
	use spjanfeb2001.dta,clear
	twoway rcap high low tradeday 

	twoway rcap high low tradeday,msize(small)

	twoway rcap high low tradeday ,blcolor(cranberry) blwidth(thick)

	twoway rspike high low tradeday ,blcolor(cranberry) blwidth(thick)

	twoway rcapsym high low tradeday ,msymbol(Sh) msize(large)

*page 73
	twoway rbar high low tradeday
	twoway rbar high low tradeday ,barwidth(.7)


*page 74
	twoway rbar high low tradeday ,bcolor(sienna)
*bcolor() bar color

*2.8 Distribution plots
*page 75
	use nlsw.dta,clear
	twoway histogram ttl_exp

	twoway histogram ttl_exp,bin(10)
*use the bin() option to control the number of bins that are used to display 

	twoway histogram ttl_exp ,width(5)

*page 76
	twoway histogram ttl_exp,start(-2.5) width(5)

	twoway histogram ttl_exp ,fraction width(1)

	twoway histogram ttl_exp ,fraction width(1)


	twoway histogram ttl_exp ,gap(20)
*by default the gap is 0

	twoway histogram ttl_exp,barwidth(.5)

	twoway histogram ttl_exp ,bfcolor(mint) blcolor(red) blwidth(thick)
*bfcolor() bar fill color // blcolor() bar line color

*page 79
	twoway histogram ttl_exp,horizontal
	twoway histogram grade,discrete

	twoway histogram grade,discrete width(2)

	twoway (histogram ttl_exp)(kdensity ttl_exp) 

*page 81
	twoway kdensity ttl_exp,biweight

	twoway kdensity ttl_exp,range(0 40)

	twoway (histogram ttl_exp ,width(1) frequency)(kdensity ttl_exp ,area(2246))

*page 82
	twoway kdensity ttl_exp,clwidth(thick) clpattern(dash_dot) clcolor(mint)

*2.9 Optons 
*page 83
	use allstates.dta,clear
	twoway scatter ownhome propval100

	twoway scatter ownhome propval100,msymbol(Sh)
*msymbol() control the marker symbols

	twoway scatter ownhome propval100,msymbol(S) mlabel(stateab)
*mlabel() control the marker labels

*page 84
	twoway scatter fv ownhome  propval100 ,connect(1 .) sort
*using connect(1 .) option to connect the values of ownhome

	twoway scatter propval100 rent700 ownhome,xtitle(Percent of households that their own home)

	twoway scatter propval100 rent700 ownhome,xtitle(Percent of households that their own home) ylabel(0(10)100)

	twoway scatter propval100 rent700 ownhome,ylabel(0(50)100) yscale(alt)
*yscale(alt) to move the y_axis to its alternate position

	twoway (scatter propval100 ownhome) (scatter rent700 ownhome,yaxis(2))
*we put the y_axis on the second y-axis with the yaxis(2)

	twoway scatter propval100 rent700 ownhome,ylabel(0(10)100) yscale(alt) by(north)
*the by() option allows you to see a graph broken down by one or more by() var 

*page 86
	twoway scatter propval100 rent700 ownhome,legend(cols(1))
*legend 图例，变成一列

	twoway scatter propval100 ownhome ,text(62 45 "DC")

	twoway scatter propval100 ownhome ,title(this is a title ,box bfcolor(dimgray)) blcolor(green) blwidth(thick)
*title() bfcolor(box fill color) blcolor(box line color) 

*2.10 Overlaying plots
*page 87
	use allstates.dta,clear
	twoway (scatter propval100 urban)(scatter rent700 urban ,yaxis(2))

	twoway scatter propval100 rent700 urban,msymbol(Sh t)

*page88
	twoway scatter propval100 rent700 urban,mstyle(p2 p8)
*mstyle(maker style) option can be used to choose among marker styles 

	use spjanfeb2001.dta,clear 
	twoway line high low close tradeday ,sort

	twoway line high low close tradeday ,sort clwidth(thick thick .)
*use the clwidth() option to change the width of the line 

*page 89
	twoway line high low close tradeday ,sort clstyle(p1 p1 p4)
*clstyle(connected line style)

	twoway line high low close tradeday ,sort clstyle(p1 p1 p4) clwidth(thick thick .)


	use allstates.dta,clear
	twoway (scatter propval100 urban) (lfit propval100 urban)
	twoway (scatter propval100 urban) (lfit propval100 urban) (qfit propval100 urban)

	twoway (scatter propval100 urban,msymbol(Sh)) ///
		(lfit propval100 urban,clpattern(dash_dot)) ///
		(qfit propval100 urban,clwidth(thick))

*page 91
	twoway (scatter propval100 urban) (lfit propval100 urban) ///
		(qfit propval100 urban) ,legend(label(2 Liner fit) label(2 quad fit))

	twoway (qfitci propval100 urban) (scatter propval100 urban)
//此处存在上下叠放问题，后写的在上面


*page 92
	use sp2001ts.dta,clear
	twoway (rarea high low date) (spike volmil date)
*volmil volume in millions

	twoway (rarea high low date)(spike volmil date,yaxis(2)),legend(span)

	twoway (rarea high low date)(spike volmil date,yaxis(2)),legend(span) /*
		*/ yscale(range(500 1400)axis(1)) yscale(range(0 5) axis(2))
 
*page 93
	use allstates.dta,clear
	twoway scatter propval100 urban || lfit propval100 urban

	twoway scatter propval100 urban || lfit propval100 urban || qfit propval100 urban

	twoway scatter propval100 urban ,msymbol(Sh)|| lfit propval100 urban,clwidth(thick) || qfit propval100 urban,clwidth(medium) ///
		legend(label(2 Linear Fit) label(3 Quad Fit))











