  
*-XT_FE_fig3：最终面试成绩
  
  use FE_mark.dta, clear
  bysort group: egen mean = mean(mark)
  gen mark_dem = mark - mean
  gen mark_str = string(mark)
  	 
  gen mark_dem_str0  = string(mark) + "-" + string(mean) 
  gen mark_dem_str1  = string(mark_dem)
  replace mark_dem_str1 = "+" + string(mark_dem) if mark_dem>0
  gen mark_dem_str2 = string(mark) + "-" + string(mean) + "=" + mark_dem_str1
  
 
  gen mark_FE = mark_dem + 85
  gen mark_FE_str0 = string(mark_FE)
  gen mark_FE_str1 =  mark_dem_str0 + "+" + "85" + "=" + mark_FE_str0
  
  local marker "mark_FE_str1"
  twoway ///
     (function y= 8, range(0.9 1.8) recast(area) color(red*0.1))  ///
	 (function y=-8, range(0.9 1.8) recast(area) color(red*0.1))  ///
	 (function y= 8, range(1.9 2.75) recast(area) color(blue*0.1)) ///
	 (function y=-8, range(1.9 2.75) recast(area) color(blue*0.1)) ///
	 (scatter mark_dem group if group==1, m(T) mlabel(`marker') mlabsize(*1.3))  ///
     (scatter mark_dem group if group==2, m(D) mlabel(`marker') mlabsize(*1.3)) ///
	 ,   ylabel(-10 " " 0 "85" 10 " ", angle(0)) ///
		 xlabel(0.5 " " 1.25 "A组" 2.3 "B组" 3 " ") ///
		 ytitle(" ") ysize(6) legend(off)

		 
		 
		 
