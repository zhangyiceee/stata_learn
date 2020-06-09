/*======================================================*
Purpose 	:	学习计量
Data		:	连享会面板数据
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200604
*=======================================================*/
	clear all 
	set more off
	cd "/Users/zhangyi/Documents/stata/连玉君/高级教程数据/Net_course/B7_Panel"
	global output "/Users/zhangyi/Documents/GitHub/stata_learn/output"

*如何估计固定效应模型
	use B7_introFe,clear
	tab id,gen(dum)
	*M1 加入三个虚拟变量
	reg y x dum*,nocons
	est store m_pooldum3

	*M2 放入两个虚拟变量，三家公司有一个共同的截距
	reg y x dum2 dum3
	est store m_pooldum2

	*M3 面板固定效应
	tsset id t 
	xtreg y x ,fe
	est store m_fe
	est table m_*,b(%6.3f) star(0.1 0.05 0.01)


	*stata估计方法解析
/*
如果截面的个数非常多，那么采用虚拟变量的方式运算量过大
因此需要寻求更合理的方式去除掉个体效应，因为关注的主要是x的系数
y_it = u_i + x_it*b + e_it  (1)
ym_i = u_i + xm_it*b + em_i	 (2) 组内平均
ym = um + xm*b + em 		(3)样本平均
y_it-ym_i=(x_it-xm_it)b +(e_it-em_i) (4) 
(3)+(4) 进行估计
Y_it= a_0 +X_it * b +E_it
*/

	egen y_meanw=mean(y) ,by(id) //样本内部平均
	egen y_mean=mean(y)  //样本平均

	egen x_meanw=mean(x) ,by(id) //样本内部平均
	egen x_mean=mean(x)  //样本平均

	gen dy=y - y_meanw +y_mean
	gen dx=x - x_meanw +x_mean
	reg dy dx
	est store m_stata
	est table m_*,b(%6.3f) star(0.1 0.05 0.01)

*解读固定效应结果xtreg ,fe
	use invest2,clear
	tsset id t
	xtreg market invest stock ,fe 




