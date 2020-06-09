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
	

*第四版 
*Chapter 13
	bcuse fertil1.dta,clear
	reg  kids educ age agesq black east northcen west farm othrural town smcity y74 y76 y78 y80 y82 y84

	bcuse cps78_85,clear
	reg lwage y85 educ y85educ exper expersq union female y85fem

	bcuse kielmc,clear
	reg rprice y81 nearinc y81nrinc
	reg rprice y81 nearinc y81nrinc age agesq


	*例13.4
	bcuse injury.dta,clear
	reg ldurat afchnge highearn afhigh


	*13.3 两时期面板数据分析
	bcuse crime2,clear
	reg crmrte unem if year==87

	*例13.5睡眠与工作的比较
	bcuse slp75_81,clear
	reg cslpnap ctotwrk ceduc cmarr cyngkid cgdhlth


	*例13.7禁止酒后驾驶法对交通伤亡事故的影响
	bcuse traffic1,clear



	*例14.2 教育回报随着时间而发生了变化吗？ 没看懂要跑什么回归
	bcuse wagepan,clear
	foreach v of varlist d81-d87{
		gen `v'_edu=`v'*educ
	}
	reg lwage  expersq d81_edu-d87_edu
	test 	d81_edu= d82_edu= d83_edu= d84_edu= d85_edu= d86_edu= d87_edu











