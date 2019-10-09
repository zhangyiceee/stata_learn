*=========================
**scatterplot matrix graph
*=========================
	clear all 
	set more off
*======================*
*note ：每次做练习请先运行下面两行；run the next two row first
	cd "/Users/zhangyi/Documents/GitHub/statagraph/data"
	global outdir "/Users/zhangyi/Documents/GitHub/statagraph/output"

	use allstates.dta,clear
	graph matrix propval100 ownhome borninstate,msymbol(Sh)

	use citytemp.dta,clear
	graph matrix heatdd cooldd tempjan tempjuly,msymbol(p)


	use allstates.dta,clear
	graph matrix propval100 ownhome borninstate,msize(vlarge)
	graph matrix propval100 ownhome borninstate,mcolor(gs10)
*among the color we can chose 16 gray-scale color named gs0(black) to gs16(white)

*page97
	graph matrix propval100 ownhome borninstate,msize(vlarge) mfcolor(gs13) mcolor(gs1)

	graph matrix propval100 ownhome borninstate,mlabel(stateab)

	graph matrix propval100 ownhome borninstate , mlabel(stateab) mlabsize(small)

*3.2 controlling axes
	use allstates.dta,clear
	graph matrix urban propval100 borninstate

	graph matrix urban propval100 borninstate , xlabel(30(10)100,axis(1)) ylabel(30(10)100,axis(2))

*page 99
	graph matrix urban propval100 borninstate,xlabel(0(20)100,axis(2)) ylabel(0(20)100,axis(2))

	graph matrix urban propval100 borninstate, /*
		*/ xlabel(0(20)100,axis(1)) ylabel(0(20)100,axis(1)) /*
		*/ xlabel(0(20)100,axis(2)) ylabel(0(20)100,axis(2)) /*
		*/ xlabel(0(20)100,axis(3)) ylabel(0(20)100,axis(3)) 


*page 100
	use allstates.dta,clear
	graph matrix urban propval100 borninstate,maxes(xlabel(0(20)100) ylabel(0(20)100))

	graph matrix urban propval100 borninstate,maxes(xlabel(0(20)100) ylabel(0(20)100)) xlabel(20(20)100,axis(1)) ylabel(20(20)100,axis(1))

	graph matrix urban propval100 borninstate,maxes(xlabel(0(20)100) ylabel(0(20)100) xtick(0(10)100)ytick(0(10)100))
*place three options within the maxes() option ,and they apply to all of the axes

*page 101
	use allstates.dta,clear
	graph matrix urban propval100 borninstate,diagonal("%Urban" "% Home Over $100K" "% Born in States")
*use the diagonal() option to change the titiles for all variables.

	graph matrix urban propval100 borninstate,diagonal("%Urban" . "% Born in States")
*we change the titles for the first and third variables but leave the second as is .

	graph matrix urban propval100 borninstate,diagonal("%Urban" . "% Born in States",bfcolor(eggshell))
*bfcolor(eggshell) make the background color of the text area eggshell 

*3.3 Matrix option 
*page 102

	use allstates.dta,clear
	graph matrix propval100 ownhome region ,half
*use the half option to display just the lower diagonal of the scatter matrix

	graph matrix propval100 ownhome region ,half jitter(3)
*not clear

*page 103
	graph matrix propval100 ownhome region ,scale(1.5)
*scale() option can be used to magnify the contents of the graph ,including the marker ,labels, and lines but not the overall size of the graph


*3.4 Graphing by groups
	graph matrix propval100 ownhome borninstate ,by(north)
	graph matrix propval100 ownhome borninstate ,by(north,compact)
*use the compact option to display the graphs closer together.

	twoway scatter propval100 ownhome,by(north,compact)

	graph matrix propval100 ownhome borninstate,by(north, compact) maxes(ylabel(,nolabels))
//跑不了

*page 105
	graph matrix propval100 ownhome borninstate ,by(north,compact scale(*1.3)) maxes(ylabel(,nolabels))















