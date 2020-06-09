  
  
*-XT_FE_fig1  
  
  twoway ///
	 (function y=88, range(0.8 1.3) recast(area) color(red*0.05)) ///
	 (function y=98, range(1.8 2.3) recast(area) color(blue*0.05)) ///
	 (function y=82, range(1.6 3) recast(area) color(blue*0)) ///
     (scatter mark group if group==1, ml(mark) mlabsize(*1.3)) ///
     (scatter mark group if group==2, m(D) ml(mark) msize(*0.9) mlabsize(*1.3))  ///
	 , ///
     xlabel(0 " " 1 "A组" 2 "B组" 3 " ")    ///
     ylabel(72 " " 80 90 99 " ", angle(0))  ///
     yline(80,lp(dash) lc(blue) noextend)   ///
     yline(90,lp(dash) lc(pink) noextend)   ///
	 legend(off) ysize(6)
	 *text(80.5 0.7 "Mean1") text(90.5 2.3 "Mean2") ///
