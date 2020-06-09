
*学习did命令，了解背后的原理
*============================================================*
**       		  stata  
**Goal		:    学习did命令，了解背后的原理
**Data		:    web data
**Author	:  	 ZhangYi zhangyiceee@163.com 15592606739
**Created	:  	 20200308  
**Last Modified: 2020
*============================================================*
	capture	clear all 
	capture log close
	set	more off
	set scrollbufsize 2048000
	capture log close 

* diff outcome_var [if] [in] [weight] ,[ options]
	*1案例
	 use "http://fmwww.bc.edu/repec/bocode/c/CardKrueger1994.dta"
	 diff fte,treated(treated) period(t)

	 *for bootstrapped std.err
	 diff fte,treated(treated) period(t) bs rep(50)

	 *2 with covariates
	 diff fte,treated(treated) period(t) cov(bk kfc roys)
	 diff fte,treated(treated) period(t) cov(bk kfc roys) report



*计量经济圈的教案
	webuse nlswork.dta,clear


