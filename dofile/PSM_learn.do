/*=======================================================*
Purpose 	:	学习计量的匹配法
Data		:	陈强
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20191010
*=======================================================*/
	clear all 
	set more off
	cd "/Users/zhangyi/Documents/数据集/book_dta/chenqiang"
	use ldw_exper.dta,clear
	reg re78 t,r
	reg re78 t age educ black hisp married re74 re75 u74 u75 , r

	set seed 10101
	gen ranorder = runiform()
	sort ranorder
	psmatch2 t age educ black hisp married re74 re75 u74 u75 ,outcome (re78) n(1) ate ties logit common 




