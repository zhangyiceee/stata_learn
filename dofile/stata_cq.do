
/*=======================================================*
Purpose 	:	学习计量
Data		:	陈强stata视频学习*伍德里奇计量经济学导论学习
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200126
*=======================================================*/
	clear all 
	set more off
	cd  "/Users/zhangyi/Documents/数据集/book_dta/chenqiang/"
	global outdir "/Users/zhangyi/Documents/GitHub/stata_learn/output"
*一元线性回归
	use grilic,clear
	twoway scatter lnw s || lfit lnw s

*OLS估计量的推导
*OLS 的正交性 残差向量和常数向量1正交，残差向量也与解释向量x正交
*平方和分解公式
*拟合优度


*15：固定效应
	use "traffic.dta",clear 
	xtset state year

	xtdes
	xtsum fatal beertax spircons unrate perinck state year
	xtline fatal

	*混合回归
	reg fatal beertax spircons unrate perinck,vce(cluster state)
	estimates store OLS

	*固定效应
	xtreg fatal beertax spircons unrate perinck ,fe r
	estimates store FE_robust

	*不加 r 
	xtreg fatal beertax spircons unrate perinck ,fe 
	estimates store FE


	xtreg fatal beertax spircons unrate perinck  i.state ,vce(cluster state)
	estimates store LSDV

	*使用一阶差分法，对组内自相关进行检验。

	xtserial fatal beertax spircons unrate perinck ,output

*Help 文件
	h xtreg

	webuse nlswork,clear


	h areg 
	sysuse auto,clear
	areg price weight length, absorb(rep78)
*PSMDID
	use cardkrueger1994,clear










