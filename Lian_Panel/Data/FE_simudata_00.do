
* FE_panel: introduction to fixed effects model

	clear
	set obs 60
	set seed 13599

	egen id= seq(), from(1) to(3) block(20)
	bysort id : gen t = _n + 1990

	gen x1 = 3*rnormal() 
	gen e = 1*rnormal()

	gen y = .

	gen x = x1
	replace x = x1+4 if 1.id
	replace x = x1-5 if 3.id

	replace y = 5  + 0.4*x + e if id==1
	replace y = 10 + 0.4*x + e if id==2
	replace y = 15 + 0.4*x + e if id==3


	order id t y x
	tsset id t
		  
	keep id t y x   
		  
/*
    save "FE_simudata.dta", replace	  
*/
