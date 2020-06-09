* B7_panel: introduction to fixed effects model

clear
set obs 60
set seed 13599

egen id= seq(), from(1) to(3) block(20)
bysort id : gen t = _n + 1990

gen x =  2*rnormal() 
gen e = rnormal()

gen y = .

replace x = x+3 if 1.id
replace x = x-5 if 3.id

replace y = -2 + 0.4*x + e if id==1
replace y =  0 + 0.4*x + e if id==2
replace y =  2 + 0.4*x + e if id==3

order id t y x
tsset id t

		#delimit 
		  twoway (scatter y x if id==1, mcolor(green*0.4) msymbol(T)) 
		         (scatter y x if id==2, mc(blue*0.6) ms(O))
				 (scatter y x if id==3, mc(yellow*1.2) ms(d))
				 (lfit y x, lcolor(red) lw(*2))    
                 (lfit y x if id==1, lc(blue) lw(*1.5))
                 (lfit y x if id==2, lc(blue))
                 (lfit y x if id==3, lc(blue)),  
				 xlabel(none)
				 ylabel(none)				 
                 legend(off)  ;
		#delimit cr
cap graph export "$Out/panel_Zero.png", replace

    * 回归分析
	  tab id, gen(a)
      reg y x
        est store ols
	  reg y x a2 a3
	    est store ols_dum
      tsset id t
      xtreg y x, fe  
        est store fe
      esttab ols ols_dum fe, b(%6.3f) stat(r2) nogap
	  
	  
