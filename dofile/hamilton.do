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
	tab 	  decade ,sum(penalty)
	correlate boats men penalty
	graph twoway connected men year ,yaxis(1) || connected penalty year ,yaxis(2)
	tab
	search 	  rc 100

*2 数据管理
* 创建一个新数据
	use 	canada1,clear
	gen 	gap = flife - mlife
	label 	var gap "Female-Male gap life expectancy"
	des
	list 	place flife mlife gap //但发现小数点后不用太长
	format  gap %4.1f
	list if gap == 5.9
*replace 能完成gen一样的各类计算，但是它不是创建一个新的变量，而是替代现有变量的数值
	 
	replace pop = pop * 1000


	use canada1.dta,clear
	gen type = 1
	replace type = 2  if place == "Yukon" | place == "Northwest Territories" 
	replace type = 3  if place =="Canada"
	label var type "Province,territory or nation"
	label values type typeb1
	label define typeb1 1"Province" 2"Territory" 3"Nation"
	list place flife mlife  type

	use    canada2 , clear
	list   place type
	list   place type,nolabel
	encode place , gen(placenumber)
	codebook placenumber
	decode type, gen(typestr) //decode 命令可以使用添加了取值标
		//签的数值型变量的值创建字符串变量
	list place placenumber type typestr,nolabel
	sum  place placenum type typestr

*创建新的分类变量和定序变量
	tab type
	tab type , gen(type) //将多分类变量重新表达成一组编码为1或0 的虚拟变量
	des
	list 	  place type type1-type3
	summarize unemp if type != 3
	drop if type == 3
	gen 	unemp2 = 0 if unemp < 12.26
	replace unemp = 1  if unemp>=12.26 & unemp <.
	gen unemp3 = autocode(unemp,3,5,20) 
*创建一个新的定序变量unemp3，使它将unemp从5到20 的取值区间分成等宽的三组
 	list place unemp unemp2 unemp3
	drop if unemp >=.
	sort unemp
	gen unemp5 = group(5)
	list place unemp unemp2 unemp3 unemp5

*============================================================*
*===================合并两个或多个stata文件=====================*
*==========================page 40===========================*
	use newf2,clear
	des
	list 
	append using newf1
	list
	sort year
	list
	save newf3,replace

	use newf4,clear
	des
	list
	sort year 
	merge year using newf3
	des
	//当两个数据集中存在相同的变量时，主数据中的那些将被保留下来，调用数据中的那些将被忽略

	merge year using newf5, update replace
	drop _merge 
	merge year using newf5 newf6 newf7 newf8
*============================================================*
*======================数据的转置、变换或分析====================*
*============================================================*
	use growth1 , clear
	des
	list
	xpose , clear varname
	des
	correlate v1-v5 in 2/5
	use growth1 , clear
	reshape long grow , i(provinc2) j(year)
	list , sepby(provinc2)
	label data "Eastern Canadian growth--long"
	label var grow  "Population growth in 1000s"
	save growth2,replace
	pwd
*page 47
	use growth3 , clear
	list , sepby (provinc2)
*将该数据转换成宽格式
	reshape wide grow , i(provinc2) j(year) 
	list
*改变数据结构
	use growth3 , clear
	list , sepby(provinc2)
*为每一个省份汇总出不同年份的平均增长率，在分拆数据中，每条观测案例将对应着by()变量的一个取值
	collapse (mean) grow , by(provinc2)
	list 

*=======================================================*
*===================观测案例的加权========================*
*=======================================================*
	use nfschool.dta,clear
	







 












