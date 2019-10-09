/*=======================================================*
	learn textbook example
	**Goal:    		improve stata skills
	**Data:    		Hamilton data 
	**Author:  		ZY 
	**Created:     	20191009
	**Last Modified: 

*=======================================================*/

	clear all 
	set more off 

	cd "/Users/zhangyi/Documents/数据集/bookdata/SWS9_datasets/"

*一个stata操作的例子
	use "lofoten.dta" , clear  
	des 
	list 
	tab decade ,sum(penalty)
	correlate boats men penalty
	graph twoway connected men year ,yaxis(1) || connected penalty year ,yaxis(2)
	tab
	search rc 100

*2 数据管理
	
	

	



