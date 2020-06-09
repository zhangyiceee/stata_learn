/*=======================================================*
Purpose 	:	学习计量的匹配法
Data		:	
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
//一对一的匹配，又放回的匹配

	set seed 10101
	bootstrap r(att)r(atu)r(ate),reps(100) :psmatch2 t age educ black hisp married re74 re75 u74 u75 ,outcome(re78)n(1)ate ties logit common
	quietly psmatch2 t age educ black hisp married re74 re75 u74 u75 ,outcome(re78) n(1) ate logit common
	pstest age educ black hisp married re74 re75 u74 u75 ,both graph
	psgraph

	*双重差分与PSM
	use cardkrueger1994.dta,clear
	diff fte ,t(treated) p(t) kernel id(id) logit cov(bk kfc roys) report support
	diff fte ,t(treated) p(t) kernel id(id) logit cov(bk kfc roys) report support test



	*连享会的选择匹配变量 
	cd "/Users/zhangyi/Documents/GitHub/stata_learn/data"
	*ssc install psestimate,replace
	h psestimate
	use nswre74.dta,clear
	psestimate treat ed,totry(age black hisp nodeg)
	*一阶的协变量 nodeg hisp 
	*二阶的协变量 c.nodeg#c.ed
	*最终 ：ed nodeg hisp c.nodeg#c.ed

	*可以分两步操作，第一步跳过二阶，第二步跳过一阶
	psestimate treat ed,totry(age black hisp nodeg) noquad
	psestimate treat ed,totry(age black hisp nodeg) nolin

	* psmatch2 基于筛选出的匹配变量进行PSM匹配
	psmatch2 treat ed nodeg hisp c.nodeg#c.ed, logit ate neighbor(1) common caliper(.05)
	pstest ed nodeg hisp c.nodeg#c.ed,t(treat)
	psgraph

