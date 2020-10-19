*****************
**Stata 手册学习**
*****************

	clear all 
	set more off
	use http://www.stata-press.com/data/r15/auto2,clear
	reg mpg weight gear_ratio b5.rep78
	areg  mpg weight gear_ratio ,absorb(rep78) r




