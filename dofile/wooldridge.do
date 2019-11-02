*伍德里奇计量经济学导论学习
/*=======================================================*
Purpose 	:	学习计量基础
Data		:	伍德里奇导论数据 bcuse
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20191020
*=======================================================*/
	clear all 
	set more off
*ex2.3
	bcuse ceosal1 , clear
	reg salary roe
*ex2.4
	bcuse wage1 , clear
	reg wage educ
*ex2.5
	bcuse vote1,clear
	reg voteA shareA
	*某些时候回归分析不是用来确定因果关系，而是像标准的相关分析一样，仅仅用于判断两个变量是正相关还是负相关
*ex2.8
	bcuse ceosal1 , clear
	reg salary roe
*ex2.10
	bcuse wage1 , clear
	reg lwage educ
*当u包含着影响y且与x也相关的因素时，使用简单回归就会导致伪相关
*ex2.12
	bcuse meap93,clear
	reg math10 lnchprg
	