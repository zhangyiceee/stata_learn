

*-Whithin, Between, and Pooled OLS

	  use "FE_simudata.dta", clear
	  egen yi_mean = mean(y), by(id)  //公司内部平均
      egen y_mean  = mean(y)          //样本平均
      egen xi_mean = mean(x), by(id)
      egen x_mean  = mean(x)
      gen dy = y - yi_mean + y_mean
      gen dx = x - xi_mean + x_mean 
	  
	*--------------------------------------------------begin-------  
  	  #delimit 
	   twoway (scatter y x if id==1, mcolor(green*0.6) msymbol(T) msize(*0.6)) 
		      (scatter y x if id==2, mc(black*0.6) ms(O) msize(*0.6))
			  (scatter y x if id==3, mc(red*0.8) ms(d) msize(*0.6))
			  (scatter yi xi, msize(*2.5) mc(blue) ms(O))
			  (lfit y   x, lcolor(red) lw(*1.3)) 
			  (lfit yi xi, lcolor(blue) lw(*1.3) lp(dash)) 
              (lfit y x if id==1, lc(black*0.6) lw(*1.2))
              (lfit y x if id==2, lc(black*0.6) lw(*1.2))
              (lfit y x if id==3, lc(black*0.6) lw(*1.2)), 
			   ylabel(0(5)20,angle(0))
               legend(off)
			   text( 7.4  10.3 "POLS")
			   text(17.5  3.5 "FE(Within)")
			   text(12.4 -1.9 "Between")
			   ;
	  #delimit cr
    *--------------------------------------------------over--------	  
	
	
	
	