/*=======================================================*
Purpose 	:	主成分分析法
Data		:	from sysuse
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	2020616
*=======================================================*/


	clear all
	set more off
	set scrollbufsize 2048000

	sysuse auto,clear
	pca price mpg rep78 headroom weight length displacement foreign
	predict pc1 pc2 pc3
	pwcorr pc1 pc2 pc3 price mpg rep78 headroom weight length displacement foreign ,sig



	cd "/Users/zhangyi/Desktop/进步/计量及stata/stata/SWS9_datasets"
	use planets.dta,clear
	*取得主成分因子
	factor rings logdsun-logdense,pcf
	screeplot

	rotate