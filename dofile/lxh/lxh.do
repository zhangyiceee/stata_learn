/*======================================================*
Purpose 	:	学习计量
Data		:	连享会网站命令学习
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200604
*=======================================================*/
	clear all 
	set more off

*Stata: 如何快速合并 3500 个无规则命名的数据文件？
	cd "/Users/zhangyi/Documents/data"
	global output "/Users/zhangyi/Documents/GitHub/stata_learn/output"

	local s : dir"/Users/zhangyi/Documents/data" files "*.dta",respectcase
	

