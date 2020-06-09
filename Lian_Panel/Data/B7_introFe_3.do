* B7_panel: introduction to fixed effects model

clear
set obs 60
set seed 1357911

egen id= seq(), from(1) to(3) block(20)
bysort id : gen t = _n + 1990

gen x = invnorm(uniform())
gen e = 0.6*invnorm(uniform())

gen y = .

replace y = 3 + 0.8*x + e if id==1
replace y = 5 + 0.8*x + e if id==2
replace y = 9 + 0.8*x + e if id==3

order id t y x
tsset id t

		#delimit 
		  twoway (scatter y x if id==1, mcolor(green*0.5) msymbol(T)) 
		         (scatter y x if id==2, mc(blue*0.5) ms(O))
				 (scatter y x if id==3, mc(red*0.5) ms(d))
				 (lfit y x, lcolor(black))    
                 (lfit y x if id==1, lc(green))
                 (lfit y x if id==2, lc(blue))
                 (lfit y x if id==3, lc(red)),    
                 legend(off)  ;
		#delimit cr


    * 回归分析
	  tab id, gen(dum)
      reg y x
        est store ols
	  reg y x dum2 dum3
	    est store ols_dum
      tsset id t
      xtreg y x, fe  
        est store fe
      est table ols ols_dum fe, b(%6.3f) stat(r2) star(0.1 0.05 0.01) 
	  
	  
