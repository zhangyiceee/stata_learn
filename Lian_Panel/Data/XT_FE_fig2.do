
*-XT_FE_fig2：初步调整后的成绩

  use FE_mark.dta, clear
  bysort group: egen mean = mean(mark)
  gen mark_dem = mark - mean
  gen mark_str = string(mark)
  	 
  gen mark_dem_str0  = string(mark) + "-" + string(mean) 
  gen mark_dem_str1  = string(mark_dem)
  replace mark_dem_str1 = "+" + string(mark_dem) if mark_dem>0
  gen mark_dem_str2 = string(mark) + "-" + string(mean) + "=" + mark_dem_str1
  
  local marker "mark_dem_str2"
  twoway ///
     (function y= 8, range(0.8 1.6) recast(area) color(red*0.05)) ///
	 (function y=-8, range(0.8 1.6) recast(area) color(red*0.05)) ///
	 (function y= 8, range(1.8 2.6) recast(area) color(blue*0.05)) ///
	 (function y=-8, range(1.8 2.6) recast(area) color(blue*0.05)) ///
     (scatter mark_dem group if group==1, m(T) mlabel(`marker') mlabsize(*1.3)) ///
     (scatter mark_dem group if group==2, m(D) mlabel(`marker') mlabsize(*1.3)), ///
		 xlabel(0 " " 1.15 "A组" 2.2 "B组" 3 " ") ysize(6) ///
		 ylabel(-10 " " 0 10 " ", angle(0)) ///
		 ytitle(" ") legend(off)
