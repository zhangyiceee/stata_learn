
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
*     直击面板数据模型
*
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>


*------------- Outline ---------------

  - 简介：面板数据结构、优势和挑战
  
  - 什么是「固定效应」？辛普森悖论
  
  - 一维和二维固定效应模型
  
  - 估计方法对比分析：POLS，DVLS，Within-FE
  
  - 聚类标准误：一维聚类和多维聚类
  
  - 实证分析中的主要陷阱
  
  - 动态面板和面板门限模型简介

  
  
*--------------------------------------

*-注意：执行后续命令之前，请先执行如下命令
  global path "D:\Lec\Lian_Panel"  //定义课程目录,可以酌情修改
  global D    "$path\data"      //范例数据
  global R    "$path\refs"      //参考文献
  global Out  "$path\out"       //结果：图形和表格
  cd "$D"
  set scheme s2color  

	
	


*-----------
*- 参考资料
  
   shellout "$R\连玉君(2011)_Panel_Data.pdf"  //连玉君讲义	
   
   * Stata: 面板数据模型-一文读懂
     view browse "https://www.jianshu.com/p/e103270ce674"
     
   * [reghdfe：多维面板固定效应估计]
     view browse "https://www.jianshu.com/p/e0c02607e82b"
     
   * [Frisch-Waugh定理与部分回归图：图示多元线性回归的系数]
     view browse "https://blog.csdn.net/arlionn/article/details/96779492"
	  
  *-Good Review of various FE models
    *-McCaffrey, D.F., Lockwood, J., Mihaly, K., Sass, T.R., 2012. 
	* A review of Stata commands for fixed-effects estimation in 
	* normal linear models. Stata Journal 12(3): 406-432
    shellout "$R\SJ12-3-ReviewFE.pdf" //一维面板,二维面板,标准误
	
  *-多维固定效应模型
    *-Rios-Avila, F., 2015. 
	* Feasible fitting of linear models with N fixed effects. 
	* Stata Journal 15(3): 881-898.
	shellout "$R\Rios_2015_SJ_15-3_FE.pdf"
	help regxfe //Fit a linear high-order fixed-effects model
   
   
  *---------  
  *-应用  
   
  *-Fixed Effect Model, FE 
  *-Flannery, M. J., K. P. Rangan, 2006, 
  *   Partial adjustment toward target capital structures, 
  *   Journal of Financial Economics, 79 (3): 469-506.  
	shellout "$R\Flannery_2006_FE.pdf"
	
  * 叶德珠,连玉君,黄有光,李东辉.                  
  *    "消费文化、认知偏差与消费行为偏差".        
  *    经济研究, 2012(2): 80-92.                     
    shellout "$R\连玉君_2012_消费文化.pdf" 
  
  *-SE of Panel data models
  *-Petersen, M. A., 2009, 
  * Estimating standard errors in finance panel data sets: Comparing approaches, 
  * Review of Financial Studies, 22 (1): 435-480.
    shellout "$R\Petersen-2009.pdf"
    *-Stata 实现 codes:
    view browse "http://www.kellogg.northwestern.edu/faculty/petersen/htm/papers/se/se_programming.htm"

	
	
	
*--------------------
*-1. 面板数据的结构  (兼具截面资料和时间序列资料的特征)
    
	use "nlswork.dta", clear  // 大 N 小 T
	replace year = 1900+year
	keep if year>1980
    browse idcode year ln_wage wks_work collgrad race 
	list idcode year ln_wage wks_work collgrad race in 1/40, sepby(idcode)
/*
  +----------------------------------------------------------------+
  | idcode   year    ln_wage   hours    ttl_exp   collgrad    race |
  |----------------------------------------------------------------|
  |      1     83   2.420261      49   5.294872          0   black |
  |      1     85   2.614172      42   7.160256          0   black |
  |      1     87   2.536374      45    8.98718          0   black |
  |      1     88   2.462927      48   10.33333          0   black |
  |----------------------------------------------------------------|
  |      2     82   1.808289      38   7.666667          0   black |
  |      2     83   1.863417      38   8.583333          0   black |
  |      2     85   1.789367      38   10.17949          0   black |
  |      2     87    1.84653      40   12.17949          0   black |
  |      2     88   1.856449      40   13.62179          0   black |
  |----------------------------------------------------------------|
  |      3     82   1.603419      40      11.75          0   black |
  |      3     83   1.614229      40   12.61539          0   black |
  |      3     85   1.730799      40   14.61539          0   black |
  |      3     87   1.525765      40   16.34615          0   black |
  |      3     88   1.612777      40   17.73077          0   black |
  |                 ... ...                                        |
  +----------------------------------------------------------------+	
*/

    xtset id year  //告诉 Stata: 我的数据是面板数据
    * panel variable:  idcode (unbalanced)
    *  time variable:  year, 68 to 88, but with gaps
    *          delta:  1 unit
	
    xtdes  // 数据特征描述
/*
  idcode:  1, 2, ..., 5159                    n =       4711
    year:  68, 69, ..., 88                    T =         15
           Delta(year) = 1 unit                  
           Span(year)  = 21 periods
           (idcode*year uniquely identifies each observation)

Distribution of T_i: min  5%  25%  50%  75%  95%  max
                       1   1    3    5    9   13   15

     Freq.  Percent    Cum. |  Pattern
 ---------------------------+-----------------------
      136      2.89    2.89 |  1....................
      114      2.42    5.31 |  ....................1
       89      1.89    7.20 |  .................1.11
       87      1.85    9.04 |  ...................11
       86      1.83   10.87 |  111111.1.11.1.11.1.11
       61      1.29   12.16 |  ..............11.1.11
       56      1.19   13.35 |  11...................
       54      1.15   14.50 |  ...............1.1.11
       54      1.15   15.64 |  .......1.11.1.11.1.11
     3974     84.36  100.00 | (other patterns)
 ---------------------------+-----------------------
     4711    100.00         |  XXXXXX.X.XX.X.XX.X.XX
*/
	
    use "invest2.dta", clear  // 小 N 大 T
    browse
    xtset id t
    xtdes	
	
	
	
	
*--------------------------
*-2.1 静态面板数据模型简介
*--------------------------

     *     ==本节目录==
     
     *-2.1.1 简介
     *-2.1.2 固定效应模型
       *-2.1.2.1 FE模型的基本原理
       *-2.1.2.2 stata的估计方法解析
       *-2.1.2.3 解读 xtreg,fe 的估计结果
                 *-R^2     
                 *-个体效应是否显著？
                 *-如何得到调整后的 adj-R2 ？?
                 *-拟合值和残差 
     *-2.1.3 随机效应模型 
       *-2.1.3.1 RE 与 FE 的异同
       *-2.1.3.2 解读 xtreg,re 的估计结果
	   
	   
*---------------------------
*-2.1.1 面试中的辛普森悖论：个体效应是什么？


    *-问题描述

      use "FE_mark.dta", clear  //do FE_mark_DGP.do 数据生成过程
      list, sep(6)  //面试成绩

           +-------------------+
           | group   id   mark |
           |-------------------|
        1. |   A组    1     75 |
        2. |   A组    2     73 |
        3. |   A组    3     85 |
        4. |   A组    4     81 |
        5. |   A组    5     79 |
        6. |   A组    6     87 |
           |-------------------|
        7. |   B组    1     85 |
        8. |   B组    2     83 |
        9. |   B组    3     95 |
       10. |   B组    4     92 |
       11. |   B组    5     88 |
       12. |   B组    6     97 |
           +-------------------+
  
      gsort -mark   //排名情况
      list, sep(6)

           +-------------------+
           | group   id   mark |
           |-------------------|
        1. |   B组    6     97 |
        2. |   B组    3     95 |
        3. |   B组    4     92 |
        4. |   B组    5     88 |
        5. |   A组    6     87 |
        6. |   B组    1     85 |
           |-------------------|
        7. |   A组    3     85 |
        8. |   B组    2     83 |
        9. |   A组    4     81 |
       10. |   A组    5     79 |
       11. |   A组    1     75 |
       12. |   A组    2     73 |
           +-------------------+

      tabstat mark, by(group) s(mean sd min max) f(%4.2f)
      
       group |      mean        sd       min       max
      -------+----------------------------------------
         A组 |     80.00      5.48     73.00     87.00
         B组 |     90.00      5.59     83.00     97.00
      -------+----------------------------------------
       Total |     85.00      7.42     73.00     97.00
      ------------------------------------------------
	
      do "XT_FE_fig1.do"   //图示
	
    *-讨论:
    
	*------------------------------------------------------
	*
    *-面试成绩 = 面试官的偏好 + 个人实际能力 + 运气
	*            ------------    ------------   ----
	*
	*    Y[it] =     a[i]     +    X[it]     + e[it]         (1)
	*
	* i = 1,2      表示面试组别
	*
	* t = 1,2,...6 表示面试者序号
	*
	*------------------------------------------------------
	
	
	*-Question: 如何去除 a[i] ?
	*
	*   Y[i]_m   =   a[i]    +    X[i]_m    + e[i]_m        (2)
	*
	* (1)-(2)
	*
	* Y[it]-Y[i]_m =         + X[it]-X[i]_m + e[it]-e[i]_m  (3) 
	
	*-处理方法: 组内去心, 组内差分
	
	
	 
    *-面试成绩初步调整后图示
  
      do "XT_FE_fig2.do"
	
	
    *-调整后的最终面试成绩
  
      do "XT_FE_fig3.do" 
	
      gsort -mark_FE   //最终排名情况
      list group id mark_FE, sep(6)    
		   
    *-最终调整方案：
    *
    *  -------------------------------------------
    *   最终成绩 = 原始成绩 - 组内均值 + 样本均值
    *  -------------------------------------------
    
    *-Comments:
    *
    * (1)应用面板数据模型的一个主要目的就是控制不可观测的个体效应
    *    即本例中的：面试评委偏好
    *
    * (2)公司研究中，个体效应包括：公司文化, CEO 特征等；
    *
    * (3)个人消费行为研究中，个体效应包括：个人习惯, 能力, 消费理念等；
	*
	* (4)上述处理方法就是大名鼎鼎的「组内估计量 Within Estimator」

    


	

*--------------------
*-2.1.2 固定效应模型 (Fixed Effect Model)
  
  *-2.1.2.1 基本思想
  
    * 实质上就是在传统的线性回归模型中加入 N-1 个虚拟变量，
    * 使得每个截面都有自己的截距项，
    * 截距项的不同反映了个体的某些不随时间改变的特征
    * 
    * 例如： lny = a_i + b1*lnK + b2*lnL + e_it
    * 考虑中国28个省份的C-D生产函数
	*
	* Q: a_i 代表什么意思？包含了哪些因素？

    * OLS 估计的偏误
      * 一份模拟数据
        
        use "FE_simudata.dta", clear
        twoway (scatter y x) (lfit y x) 
        reg y x
		
	  *---------------------------------------begin-------------------- 	
		#delimit 
		  twoway (scatter y x if id==1, mcolor(green*0.5) msymbol(T)) 
		         (scatter y x if id==2, mc(blue*0.5) ms(O))
				 (scatter y x if id==3, mc(red*0.5) ms(d))
				 (lfit y x, lcolor(black))    
                 (lfit y x if id==1, lc(green))
                 (lfit y x if id==2, lc(blue))
                 (lfit y x if id==3, lc(red)),    
                 legend(off)  ;
		#delimit cr
      *---------------------------------------over---------------------    

    *-回归分析
	  tab id, gen(dum)
	  
      reg y x                   // Pooled OLS
        est store OLS
		
	  reg y x dum2 dum3         // FE: OLS with Dummy varibles 
	    est store OLS_dum2
		
	  reg y x dum1-dum3, nocons // FE: OLS with Dummy varibles, no constant 
	    est store OLS_dum3
		
      xtset id t //声明面板数据的结构, 这一步必须做，注意变量的先后顺序
	  xtdes      //这一步可以忽略
      xtreg y x, fe             // FE: (withi-group estimator)
        est store FE
		
	  local m "OLS OLS_dum2 OLS_dum3 FE"
      esttab `m', mtitle(`m')  r2(%4.2f) b(%3.1f) not nogap ///
	              star(* 0.1 ** 0.05 *** 0.01) compress
				  
/*
      ------------------------------------------------------
               (1)          (2)          (3)          (4)   
               OLS     OLS_dum2     OLS_dum3           FE   
      ------------------------------------------------------
      x       -0.2*         0.4***       0.4***       0.4***
      dum2                    6***         9***             
      dum3                   15***        18***             
      dum1                                 3***             
      _cons     10***         3***                     10***
      ------------------------------------------------------
      N         60           60           60           60   
      R-sq    0.05         0.96         0.99         0.72   
      ------------------------------------------------------
      * p<0.1, ** p<0.05, *** p<0.01
	  * Note: dum* 的估计系数进行了四舍五入调整
*/
	  
    * 真实的数据生成过程
      doedit "FE_simudata_00.do"
	  
	*-Note: 
	* [1]Pooled OLS 主要反映了截面差异;
	* [2]对于 x 的系数而言，OLS+dummies 与 FE 结果无异;
	* [3]如果关注 R2, 则 OLS_dum2 对应的 R2 是最完整的 R2; 
	*    而 FE 的 R2 仅仅反映了 x 对 y 的解释力度, 没有考虑个体效应的贡献,
	*    本质上是 "squared partial-correlation" (self-reading)
	
	
  *-2.1.2.2 FE: Stata的估计方法解析  
   
    * 目的：如果截面的个数非常多，那么采用虚拟变量的方式运算量过大
    *       因此，要寻求合理的方式去除掉个体效应
    *       因为，我们关注的是 x 的系数，而非每个截面的截距项
    * 处理方法：
    
	  shellout "$R\XT_FE_RE.pptx"
	
    * y_it = a + u_i + x_it*b + e_it  (1)
	*
    * ym_i = a + u_i + xm_i*b + em_i  (2)  组内平均
    *
	* ym   = a + um  + xm*b   + em    (3)  样本平均
	
	*        um = (u1+u2+...+uN)/N
	
    * (1)-(2), 可得：
    * (y_it - ym_i) = (x_it - xm_i)*b + (e_it - em_i) (4)  //组内去心
	
    * (4)+(3), 可得：
    * (y_it-ym_i+ym) = (a+um) + (x_it-xm_i+xm)*b + (e_it-em_i+em)  
	
    * 可重新表示为： 
	*
    * Y_it = a_0 + X_it*b + E_it
	*
    * 对该模型执行 OLS 估计，即可得到 b 的无偏估计量
	  use "FE_simudata.dta", clear
	  xtreg y x, fe
	  est store xtreg
	  
      egen y_meanw = mean(y), by(id)  /*公司内部平均*/
      egen y_mean  = mean(y)          /*样本平均*/ 
      egen x_meanw = mean(x), by(id)
      egen x_mean  = mean(x)
      gen dy = y - y_meanw + y_mean
      gen dx = x - x_meanw + x_mean 
      reg dy dx 
      est store OLS_demean

      esttab xtreg OLS_demean, r2 b(%6.3f)nogap ///
	     star(* 0.1 ** 0.05 *** 0.01) compress
/*
      ------------------------------------
                       (1)          (2)   
                         y           dy   
      ------------------------------------
      x              0.380***             
                   (12.10)                
      dx                          0.380***
                                (12.31)   
      _cons          9.633***     9.633***
                   (66.97)      (68.16)   
      ------------------------------------
      N                 60           60   
      R-sq           0.723        0.723   
      ------------------------------------
      t statistics in parentheses, * p<0.1, ** p<0.05, *** p<0.01
*/
  
	  
  *-2.1.2.3 解读 xtreg,fe 的估计结果
  
    . use "invest2.dta", clear
    . xtset id t
    . browse
    . xtreg market invest stock, fe
	
/*
--------------------------Output----------------------------------	
Fixed-effects (within) regression       Number of obs     =    100
Group variable: id                      Number of groups  =      5
    
R-sq:                                   Obs per group:
     within  = 0.4168                                 min =     20
     between = 0.6960                                 avg =   20.0
     overall = 0.6324                                 max =     20
    
                                        F(2,93)           =  33.23
corr(u_i, Xb)  = 0.5256                 Prob > F          = 0.0000

------------------------------------------------------------------
  market |    Coef.  Std. Err.    t    P>|t|  [95% Conf. Interval]
---------+--------------------------------------------------------
  invest |    3.053     0.458   6.67   0.000     2.144       3.962
   stock |   -0.676     0.222  -3.05   0.003    -1.116      -0.236
   _cons | 1372.613    76.964  17.83   0.000  1219.776    1525.449
---------+--------------------------------------------------------
 sigma_u |1023.5914
 sigma_e | 370.9569
     rho |.88390837  (fraction of variance due to u_i)
------------------------------------------------------------------
F test that all u_i=0: F(4, 93) = 97.68          Prob > F = 0.0000
*/

    *-- R^2
	
	*-model
    *   y_it = a_0       + x_it*b_o + e_it   (1)  pooled OLS        
    *   y_it = a_0 + u_i + x_it*b_w + e_it   (2)  within  estimator 
    *   ym_i = a_0 + u_i + xm_i*b_b + em_i   (3)  between estimator 
   
    *-- R^2
    * -> R-sq: within   模型(2)对应的 R2，x 的解释力, 个体效应的贡献未包含进来
    * -> R-sq: between  corr{xm_i*b_w,ym_i}^2
    * -> R-sq: overall  corr{x_it*b_w,y_it}^2
	*
	*-Note: 
	*                                               T
	*   ym_i 表示 y_it 的组内均值, 即 ym_i = (1/T)SUM(y_it)
	*                                              t=1 
    
    *-- F(2,93) = 33.23 检验除常数项外其他解释变量的联合显著性
    *       93 = 100-2-5
    
    *-- corr(u_i, Xb)  = 0.5256 
    
    *-- sigma_u, sigma_e, rho 
    *   rho = sigma_u^2 / (sigma_u^2 + sigma_e^2)
	*   个体效应的波动占总波动的比重
        dis e(sigma_u)^2 / (e(sigma_u)^2 + e(sigma_e)^2)
        dis 1023.5914^2 / (1023.5914^2 + 370.9569^2)
    
	
    *-- 个体效应是否显著？（假设检验）
    *   F(4, 93) = 97.68  H0: a1 = a2 = a3 = a4 = 0
    *   Prob > F = 0.0000  表明，固定效应高度显著
  
  
    *-- 如何得到调整后的 R2,即 adj-R2 ？
       
	*-Stata 13 以后的版本会直接计算 R2_adj   
	  use "invest2.dta", clear
	  reg   market invest stock i.id
		est store LSDV
      xtreg market invest stock     , fe
	    est store FE
	  
	  *-对比呈现
		. local m "LSDV FE"
		. esttab `m', mtitle(`m') s(r2 r2_w r2_a) nogap	
/*
        --------------------------------------------
                              (1)             (2)   
                             LSDV              FE   
        --------------------------------------------
        invest              3.053***        3.053***
                           (6.67)          (6.67)   
        stock              -0.676**        -0.676** 
                          (-3.05)         (-3.05)   
        1.id                    0                   
                              (.)                   
        2.id              -2404.0***                
                         (-12.40)                   
        3.id              -1016.6***                
                          (-4.59)                   
        4.id              -2318.4***                
                         (-11.30)                   
        5.id              -1979.4***                
                         (-15.50)                   
        _cons              2916.3***       1372.6***
                          (14.99)         (17.83)   
        --------------------------------------------
        r2                  0.936           0.417   
        r2_w                                0.417   
        r2_a                0.932           0.379   
        --------------------------------------------
*/

    *-- 拟合值和残差
       
        * y_it = u_i + x_it*b + e_it
        * predict newvar, [option]                      
                                                       /*
        xb           xb, fitted values; the default
        stdp         calculate standard error of the fitted values
        ue           u_i + e_it, the combined residual
        xbu          xb + u_i, prediction including effect
        u            u_i, the fixed- or random-error component
        e            e_it, the overall error component */
 
        xtreg market invest stock, fe
        predict y_hat, xbu //真正意义的拟合值，y_hat = u_i + x_it*b 
        predict a   , u    //得到每家公司的截距项
        predict res , e    //真正意义的随机干扰项,用这个来估计过度投资
        predict cres, ue
        gen ares = a + res
      . list ares cres in 1/5  
/*
            +-----------------------+
            |      ares        cres |
            |-----------------------|
         1. | 738.23406   738.23406 |
         2. | 2128.6036   2128.6036 |
         3. | 2867.1548   2867.1548 |
         4. | 774.38981   774.38981 |
         5. | 2068.3128   2068.3128 |
            +-----------------------+
*/

   *-Notes：
   * [1] 不要用 predict yhat 来计算拟合值
   * [2] 不能用 predict e, res 来计算残差
		
		
*-------------------------------
*-2.1.3 FE 与其他估计方法的关系
      
  *-2.1.3.1 视角不同：横看成岭侧成峰
  
	*-POLS, FE 之间的关系
	    
	/* Case I   */ 	do "FE_OLS_Negative.do"
		
	/* Case II  */	do "FE_OLS_Positive.do"
		
	/* Case III */	do "FE_OLS_Zero.do"
		
	/* Case IV  */	do "FE_OLS_Nodiff.do"
		
	*-FE 能控制个体效应，却无法估计出个体效应;
	*-POLS+Dummies 可以实现与 FE 相同的效果，且能估计出个体效应;
		
		
  *-2.1.3.2  R2 不同: 组内去心，到底去掉了什么?
  
    help xtdata
	help center
    help xtcenter
	
	
  *-2.1.3.3  POLS, FE, BE 之间的关系
	
	  use "FE_simudata.dta", clear
	  egen yi_mean = mean(y), by(id)  //公司内部平均
      egen y_mean  = mean(y)          //样本平均
      egen xi_mean = mean(x), by(id)
      egen x_mean  = mean(x)
      gen dy = y - yi_mean + y_mean
      gen dx = x - xi_mean + x_mean 
	  
	*--------------------------------------------------begin-------  
  	  #delimit 
	   twoway (scatter y x if id==1, mcolor(green*0.6) msymbol(T) msize(*0.6)) 
		      (scatter y x if id==2, mc(black*0.6) ms(O) msize(*0.6))
			  (scatter y x if id==3, mc(red*0.8) ms(d) msize(*0.6))
			  (scatter yi xi, msize(*2.5) mc(blue) ms(O))
			  (lfit y   x, lcolor(red) lw(*1.3)) 
			  (lfit yi xi, lcolor(blue) lw(*1.3) lp(dash)) 
              (lfit y x if id==1, lc(black*0.6) lw(*1.2))
              (lfit y x if id==2, lc(black*0.6) lw(*1.2))
              (lfit y x if id==3, lc(black*0.6) lw(*1.2)), 
			   ylabel(0(5)20,angle(0))
               legend(off)
			   text( 7.4  10.3 "POLS")
			   text(17.5  3.5 "FE(Within)")
			   text(12.4 -1.9 "Between")
			   ;
	  #delimit cr
    *--------------------------------------------------over--------	
	 
	 
	
*--------------------
*-2.1.4 随机效应模型 


  *--------
  *-2.1.4.1 RE 与 FE 的异同

    *-RE的模型设定：
    *  y_it = x_it*b + (a_i + u_it)
    *       = x_it*b +  v_it 
  
    * 基本思想：将随机干扰项分成两种
    *           一种是不随时间改变的，即个体效应 a_i
    *           另一种是随时间改变的，即通常意义上的干扰项 u_it 
  
    shellout "$R\XT_FE_RE.pptx"
  
    * 估计方法：FGLS
    *           Var(v_it) = sigma_a^2 + sigma_u^2
    *           Cov(v_it,v_is) = sigma_a^2
    *           Cov(v_it,v_js) = 0 
    * 利用Pooled OLS，Within Estimator, Between Estimator
    * 可以估计出sigma_a^2和sigma_u^2,进而采用GLS或FGLS
    * Re估计量是Fe估计量和Be估计量的加权平均
    *  yr_it = y_it - theta*ym_i
    *  xr_it = x_it - theta*xm_i
    *  theta = 1 - sigma_u / sqrt[(T*sigma_a^2 + sigma_u^2)]  


  *--------
  *-2.1.4.2 解读 xtreg,re 的估计结果
    
    use "invest2.dta", clear
    xtreg market invest stock, re
/*
    Random-effects GLS regression        Number of obs     =        100
    Group variable: id                   Number of groups  =          5
      
    R-sq:                                Obs per group:
         within  = 0.4163                              min =         20
         between = 0.7054                              avg =       20.0
         overall = 0.6380                              max =         20
      
                                         Wald chi2(2)      =      95.98
    corr(u_i, X)   = 0 (assumed)         Prob > chi2       =     0.0000
    
    -------------------------------------------------------------------
      market |     Coef.  Std. Err.    z    P>|z|  [95% Conf. Interval]
    ---------+---------------------------------------------------------
      invest |     3.847     0.483   7.96   0.000     2.899       4.795
       stock |    -0.798     0.257  -3.11   0.002    -1.301      -0.295
       _cons |  1212.764   154.621   7.84   0.000   909.712    1515.815
    ---------+---------------------------------------------------------
     sigma_u |  223.80826
     sigma_e |   370.9569
         rho |  .26686395   (fraction of variance due to u_i)
    -------------------------------------------------------------------
*/

    *-- R2 
    * -> R-sq: within   corr{(x_it-xm_i)*b_r, y_it-ym_i}^2
    * -> R-sq: between  corr{xm_i*b_r,ym_i}^2
    * -> R-sq: overall  corr{x_it*b_r,y_it}^2
    * 上述R2都不是真正意义上的R2，因为Re模型采用的是GLS估计。
  
    *-- rho = sigma_u^2 / (sigma_u^2 + sigma_e^2)
        dis e(sigma_u)^2 / (e(sigma_u)^2 + e(sigma_e)^2)
  
    *-- corr(u_i, X) = 0 (assumed)  
    *   这是随机效应模型的一个最重要，也限制该模型应用的一个重要假设
    *   然而，采用固定效应模型，我们可以粗略估计出corr(u_i, X)
        xtreg market invest stock, fe
    
    *-- Wald chi2(2) = 95.98   Prob> chi2 = 0.0000

    


*------------------------------------
*-2.2 时间效应、模型的筛选和常见问题
*------------------------------------

     *     ==本节目录==
 
     *-2.2.1 时间效应
       *-2.2.1.1 时间虚拟变量的设定
       *-2.2.1.2 检验时间效应是否显著
     *-2.2.2 模型的筛选
       *-2.2.2.1 固定效应模型还是Pooled OLS？
       *-2.2.2.2 随机效应模型还是Pooled OLS？
       *-2.2.2.3 固定效应模型还是随机效应模型？Hausman检验 
     *-2.2.3 一些常见问题
       *-2.2.3.1 为何xtset命令总是报告错误信息？
       *-2.2.3.2 为何有些变量会被drop掉？
       *-2.2.3.3 unbalance —> balance
       *-2.2.3.4 得到连续的公司编号


*----------------------------------
*-2.2.1 时间效应: 双向固定效应模型  (很常用) 

  *-2.2.1.1 时间虚拟变量的设定

    * 单向固定效应模型
    * y_it = u_i       + x_it*b + e_it
    * 双向固定效应模型
    * y_it = u_i + f_t + x_it*b + e_it
   
    * 固定效应模型中的时间效应 (Two-way FE)
      use "xtcs.dta", clear
	  xtreg tl size ndts tang tobin npr i.year, fe
	  dis _b[1999.year]  //估计系数的引用方法
/*
      -----------------------------------------------
           tl |   Coef.   Std. Err.      t    P>|t|  
      --------+--------------------------------------
         size |   0.134      0.006    22.93   0.000  
         ndts |  -0.093      0.031    -2.99   0.003  
         tang |   0.086      0.015     5.71   0.000  
        tobin |  -0.013      0.004    -3.04   0.002  
          npr |  -0.158      0.015   -10.84   0.000  
              
         year 
        1999  |  -0.014      0.005    -2.62   0.009  
        2000  |  -0.019      0.006    -3.23   0.001  
        2001  |  -0.023      0.006    -3.78   0.000  
        2002  |  -0.026      0.006    -4.12   0.000  
        2003  |  -0.022      0.007    -3.34   0.001  
        2004  |  -0.020      0.007    -2.80   0.005  
              
        _cons |  -2.359      0.124   -18.97   0.000  
      --------+--------------------------------------
*/
    
    * 随机效应模型中的时间效应
      xtreg tl size ndts tang tobin npr i.year, re
    
    
  *-2.2.1.2 检验时间效应是否显著

      xtreg tl size ndts tang tobin npr       , fe  
        est store fe
      xtreg tl size ndts tang tobin npr i.year, fe  
        est store fe_dumt 
	  esttab fe fe_dumt, nogap s(N r2 ll)
		
      lrtest fe fe_dumt   // LR test, LR = -2*(LL1-LL2)

      * Likelihood-ratio test                 LR chi2(6)  =  23.23
      * (Assumption: fe nested in fe_dumt)    Prob > chi2 = 0.0007
	  
        dis -2*(3838.1-3849.7)  //手动计算
		
		
		
*-----------------
*-2.2.2 模型的筛选

    	shellout "$R\XT_FE_RE.pptx"

	* Stata: 面板数据模型-一文读懂
	  view browse "https://www.jianshu.com/p/e103270ce674"
	  
	  
  *-2.2.2.1 固定效应模型还是Pooled OLS？(不重要)
  
    * Wald 检验
	*
	*  FE:  y_it = a + u_i + x_it*b + e_it  (1)
	*
	* H0: u_i=0  (u1 = u2 = ... = uN = 0)
	
      use "invest2.dta", clear
      xtreg market invest stock, fe   
    
	  *-F test that all u_i=0: F(4, 93) = 97.68   Prob > F = 0.0000
	  
	  
  *-2.2.2.2 随机效应模型还是Pooled OLS？(不重要)
  
	*  RE:  y_it = a + x_it*b + u_i + e_it  (1)  u~N(0, Var(u)) 
	*
    * H0: Var(u) = 0
	
      xtreg market invest stock, re mle  //LR test 
  
    * LR test of sigma_u=0: chibar2(01) = 135.69   Prob >= chibar2 = 0.000
  
	  
	  
  *-2.2.2.3 固定效应模型还是随机效应模型？Hausman检验 (也不重要)
  
    shellout "$R\XT3_Hausman.pptx"
	
	*- FE v.s. RE
	*--------------------------------------
	*                   FE
	*	           --解释变量--
	*              ------------
	*  y_it = a0 + x_it*b + u_i + e_it
	*                       -----------
    *                       --干扰项---
	*                           RE 
	*--------------------------------------
	
	* 假设条件的区别:
	*   FE: corr(x,u)=0
	*   RE: corr(x,u)=0 | corr(x,a_i)=0 
    
    * 基本思想：
	*  如果 Corr(u_i,x_it) = 0, FE 和 RE 都是无偏的，但 RE 更有效
    *  如果 Corr(u_i,x_it)!= 0, FE 仍然无偏，但 RE 却是有偏的
	
    * 基本步骤
      use "xtcs.dta", clear
      xtreg tl size ndts tang tobin npr, fe
        est store fe
      xtreg tl size ndts tang tobin npr, re
        est store re
      hausman fe re
	  
/*
              ---- Coefficients ----
            |    (b)          (B)         (b-B)     sqrt(diag(V_b-V_B))
            |     fe           re      Difference          S.E.
      ------+-----------------------------------------------------------
       size |  .1197523     .0952139     .0245384        .0018098
       ndts | -.1312198    -.2086307     .0774109        .0109313
       tang |   .087448     .0788076     .0086405        .0028921
      tobin | -.0178802     -.021615     .0037348               .
        npr | -.1472081    -.1983802     .0511721         .001267
      ------------------------------------------------------------------
                     b = consistent under Ho and Ha; obtained from xtreg
      B = inconsistent under Ha, efficient under Ho; obtained from xtreg

      Test:  Ho:  difference in coefficients not systematic

                  chi2(5) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =      166.58
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)
*/

      
    * Hausman 检验值为负怎么办？
     
      * 通常是因为RE模型的基本假设 Corr(x,u_i)=0 无法得到满足
        use "invest2.dta", clear
        xtreg market invest stock, fe
          est store m_fe
        xtreg market invest stock, re
          est store m_re
        hausman m_fe m_re
    	
/*
                ---- Coefficients ----
            |    (b)          (B)         (b-B)     sqrt(diag(V_b-V_B))
            |    m_fe         m_re     Difference          S.E.
    --------+-----------------------------------------------------------
     invest |   3.05273     3.847014     -.794284               .
      stock | -.6763434    -.7981618     .1218184               .
    --------------------------------------------------------------------
    Test:  Ho:  difference in coefficients not systematic
                  chi2(2) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =   -47.57   chi2<0 ==> model fitted on these
                                       data fails to meet the asymptotic
                                       assumptions of the Hausman test;
                                       see suest for a generalized test
*/

     
      * 检验过程中两个模型的方差-协方差矩阵都采用Fe模型的 
        hausman m_fe m_re, sigmaless 
/*
                  chi2(2) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       63.63
                Prob>chi2 =      0.0000
*/
        
      * 两个模型的方差-协方差矩阵都采用Re模型的   
        hausman m_fe m_re, sigmamore  
/*
                  chi2(2) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       38.91
                Prob>chi2 =      0.0000
*/
  
    * 如果 Hausman 检验拒绝 RE 模型，怎么办？
      * (1) FE  
      * (2) IV 估计


    *- xtoverid 命令
    
    * 基本思想：过度识别检验(over-identification restrictions)
	*   FE: corr(x,u)=0
	*   RE: corr(x,u)=0 | corr(x,a_i)=0    
        xtreg market invest stock, re
        xtoverid // Cameron and Trivedi (2009, pp.261), 
		         // Wooldridge (2002, pp. 290-91)
/*
      Test of overidentifying restrictions: fixed vs random effects
      Cross-section time-series model: xtreg re   
      Sargan-Hansen statistic  63.633  Chi-sq(2)    P-value = 0.0000
*/

		
    *-Bootstrap Hausman Test
	
	  help rhausman  // See Camerion and Trivedi (2005, pp. 717)
	  help hausmanxt // Given by Lian Yujun
	  
      use "invest2.dta", clear
      xtreg market invest stock, fe
          est store m_fe
      xtreg market invest stock, re
          est store m_re
      rhausman m_fe m_re, reps(200) cluster
/*
      Cluster-Robust Hausman Test
      (based on 200 bootstrap repetitions)
      
      b1: obtained from xtreg market invest stock, fe                                 
      b2: obtained from xtreg market invest stock, re                                 
      
          Test:  Ho:  difference in coefficients not systematic
      
            chi2(2) = (b1-b2)' * [V_bootstrapped(b1-b2)]^(-1) * (b1-b2)
                    =        0.44
          Prob>chi2 =      0.8007
*/

    *-小结：
	*
	*  传统的 Hausman 检验不适用于 Panel data，因为它没有考虑异方差和序列相关
	*
	*  应该使用 -xtoverid- 或 -rhausman-
	*
	* 参见：  -- CM2015 --  pp.16, 倒数第三段最后一句                     
    *-Cameron, C. A., D. L. Miller, 2015, 
    *  A practitioner’s guide to cluster-robust inference, 
    *  Journal of Human Resources, 50 (2): 317-372.  
      shellout "$R\Cameron_2015_ClusterSE_JHR.pdf" //cluster SE 使用手册
  
	*-相关论文和推文
	  
	  *-连玉君, 王闻达, 叶汝财. 
	  *  Hausman 检验统计量有效性的Monte Carlo模拟分析[J]. 
	  *  数理统计与管理, 2014, 33(5):830-841.
	  shellout "$R\连玉君_2014_Hausman检验.pdf"
	  
	  *-Stata连享会推文： Stata: 面板数据模型-一文读懂
	  view browse "https://www.jianshu.com/p/e103270ce674"
	  
	  
  *-2.2.2.4 如何控制年度和行业效应 	
  
    *-Gormley, T. A., D. A. Matsa, 2014, 
    *  Common errors: How to (and not to) control for unobserved heterogeneity, 
    *  Review of Financial Studies, 27 (2): 617-661.
	shellout "$R\Gormley_2014_RFS_FE.pdf"
	
  
  
*---------------------
*-2.2.4 一些常见问题

  *-2.2.4.1 为何xtset命令总是报告错误信息？
  
    use invest3.dta, clear
    xtset id t               // 错误
    xtdes
    duplicates drop id t, force
    xtset id t

    
  *-2.2.4.2 为何有些变量会被drop掉？
  
    use "nlswork.dta", clear
    xtset idcode year
	label define race 1 "white" 2 "black" 3 "other"
	label value  race race
 	
    xtreg ln_wage hours tenure ttl_exp, fe  // 正常执行
    
    *-加入种族虚拟变量
      
      xtreg ln_wage hours tenure ttl_exp i.race, fe
/*
      -----------------------------------------------
       ln_wage |  Coef.   Std. Err.      t    P>|t|  
      ---------+-------------------------------------
         hours | -0.000      0.000    -1.03   0.305  
        tenure |  0.012      0.001    13.77   0.000  
       ttl_exp |  0.025      0.001    35.64   0.000  
               |
          race |
        black  |  0.000  (omitted)                   
        other  |  0.000  (omitted)                   
               |
         _cons |  1.494      0.009   161.20   0.000  
      ---------+-------------------------------------
*/
      
      * 为何会被 dropped ?
	  
      * 固定效应模型的设定：y_it = u_i + x_it*b + e_it  (1)
      * 由于个体效应 u_i 不随时间改变，
      * 因此若 x_it 包含了任何不随时间改变的变量，
      * 都会与 u_i 构成多重共线性，Stata会自动删除之。
      * 使用 FE 时，所有不随时间变化的变量都会被 drop (性别,出生地,星座等)
	  *
	  * 简言之，FE 可以控制个体效应，但无法估计其系数
	  
	  
	*-----------------------------  
	*-如何估计不随时间变化的因素？
	*-----------------------------
	
	  *- a_i 其实是个黑盒子，里面包含了所有不随时间变化的因素
	  *  我们只需要把这个黑盒子里的东西拆出来放回模型即可
	  *  把那些不随时间变化，以及随时间变化很慢的因素都放回 POLS 即可
	  
	  use "nlswork.dta", clear
	  global dummies "i.occ_code south collgrad union not_smsa"
	  reg ln_wage hours tenure ttl_exp i.race $dummies
/*
      --------------------------------------------------
        ln_wage |    Coef.   Std. Err.      t    P>|t|  
      ----------+---------------------------------------
          hours |   -0.001      0.000    -2.74   0.006  
         tenure |    0.017      0.001    20.98   0.000  
        ttl_exp |    0.019      0.001    25.62   0.000  
                |
           race |
         black  |   -0.066      0.006   -10.55   0.000  
         other  |    0.008      0.025     0.31   0.759  
                |
       occ_code |
             2  |   -0.036      0.013    -2.85   0.004  
                |        ... ...
            13  |   -0.267      0.013   -20.65   0.000  
                |
          south |   -0.091      0.006   -15.97   0.000  
       collgrad |    0.244      0.008    29.10   0.000  
          union |    0.162      0.007    24.88   0.000  
       not_smsa |   -0.170      0.006   -28.54   0.000  
          _cons |    1.823      0.014   130.52   0.000  
      --------------------------------------------------
*/
	  


* ----------------------------------
* ------------几点评论--------------
* ----------------------------------   
* (1) 多数实证研究都采用固定效应模型或双向固定效应模型
* (2) 随机效应模型有两个突出的优点：
*     一是比较有效；
*     二是可以分析不随时间改变的变量的影响，如性别、种族、教育程度等



 
*--------------------------------
*-2.3 异方差、序列相关和截面相关
*--------------------------------

     *     ==本节目录==
     
     *-2.3.1 简介
     *-2.3.3 估计方法
       *-2.3.2.1 异方差-序列相关稳健型估计
       *-2.3.2.2 采用 Bootstrap 标准误
       *-2.3.2.3 一个综合的处理方法：xtscc 命令
       *-2.3.2.4 二维聚类标准误
	   *-2.3.2.5 截面相关和共同因素问题

*-------------
*-2.3.1 简介

  *  y_it = x_it*b + u_i + e_it 
  
  *  由于面板数据同时兼顾了截面数据和时间序列的特征，
  *  所以异方差和序列相关必然会存在于面板数据中；
  *  同时，由于面板数据中每个截面（公司、个人、国家、地区）
  *  之间还可能存在内在的联系，
  *  所以，截面相关性也是一个需要考虑的问题。

  *  此前的分析依赖三个假设条件：
  * （1） Var[e_it] = sigma^2     同方差假设
  *  (2)  Corr[e_it, e_it-s] = 0  序列无关假设
  *  (3)  Corr[e_it, e_jt] = 0    截面不相关假设
  
  *  当这三个假设无法得到满足时，
  *  便分别出现 异方差、序列相关和截面相关问题；
  *  我们一方面要采用各种方法来检验这些假设是否得到了满足；
  *      另一方面，也要在这些假设无法满足时寻求合理的估计方法。

     
*-----------------
*-2.3.2 估计方法        

  *-2.3.2.1 异方差-序列相关稳健型估计 (多数文献都用这个)
  
      use "xtcs.dta", clear 
      xtreg tl size ndts tang tobin npr, fe robust  
      est store fe_rb
	  
	*-等价于(在公司层面上的聚类调整标准误)
	  xtreg tl size ndts tang tobin npr, fe cluster(code)
	  
	  *-含义：
	  * (1) 组内(公司内部)各年度的干扰项可以彼此相关；
	  * (2) 组间(不同公司之间)的干扰项彼此不相关(同期不相关，跨期也不相关)
	  * (3) 组间存在异方差 (A 公司干扰项的方差不同于 B 公司)
	  
      * Q: cluster(industry), cluster(year), cluster(province) 分别是什么含义？
  
  
  *-2.3.2.2 采用Bootstrap标准误
    
    *-优点：统计推断并不依赖具体的分布假设
    
      xtreg tl size ndts tang tobin npr, fe vce(bootstrap, reps(500)) 
      est store fe_bs500
       
    *-原理：
      *      y_it = u_i + x_it*b + v_it        (1)
	  *
      * 估计完毕后，将得到b和u_i的估计值，设为 b0 和 u0_i,则
      *
	  *      ybs_it = u0_i + x_it*b0 + vbs_it  (2)  Bootstrap样本
      *
	  * 估计(2)，得到 b_bs1, b_bs2,......b_bs300
      * 计算这300个系数的标准差，便可以得到系数 b 的标准误
      
    *-结果对比
      xtreg tl size ndts tang tobin npr, fe
      est store fe
	  
	  local s "using $Out\Table01.csv"
      local m "fe fe_rb fe_bs500"      
      esttab `m' `s', mtitle(`m') b(%6.3f) t(%4.2f) nogap ///
	         replace star(* 0.1 ** 0.05 *** 0.01) 
			 
/*
      --------------------------------------------------
                  (1)             (2)             (3)   
                   fe           fe_rb        fe_bs500   
      --------------------------------------------------
      size      0.120***        0.120***        0.120***
              (28.24)         (17.48)         (17.38)   
      ndts     -0.131***       -0.131***       -0.131***
              (-4.60)         (-2.76)         (-2.71)   
      tang      0.087***        0.087***        0.087***
               (5.80)          (3.79)          (3.63)   
      tobin    -0.018***       -0.018***       -0.018***
              (-4.73)         (-3.31)         (-3.19)   
      npr      -0.147***       -0.147***       -0.147***
             (-10.30)         (-7.37)         (-7.42)   
      _cons    -2.074***       -2.074***       -2.074***
             (-22.37)        (-14.18)        (-14.02)   
      --------------------------------------------------
      N          3066            3066            3066   
      --------------------------------------------------
      t statistics in parentheses
      * p<0.1, ** p<0.05, *** p<0.01
 */


         
  *-2.3.2.3 一个综合的处理方法：xtscc 命令 
   
    * 详见 Stata Journal，2007(3): 281-312.
	* Daniel Hoechle, 2007, 
	*   Robust Standard Errors for Panel Regressions 
	*   with Cross-Sectional Dependence, 
	*   Stata Journal, 7(3): 281–312. 
	  shellout "$R\Daniel_2007_xtscc.pdf"
	
    * 当异方差、序列相关以及截面相关性质未知时
    * xtscc相当于White/Newey估计扩展到Panel的情形
    * Driscoll and Kraay (1998) 
      use "xtcs.dta", clear
      xtscc tl size ndts tang tobin npr, fe     
      est store fe_scc
      xtscc tl size ndts tang tobin npr, fe lag(1)    
      est store fe_scc_lag1      
      xtreg tl size ndts tang tobin npr, fe     
      * 结果对比
        xtreg tl size ndts tang tobin npr, fe
        est store fe
		
	    local s "using $Out\Table_xtscc.csv"
        local m "fe fe_scc fe_scc_lag1"
        esttab `m' `s', b(%6.3f) t(%4.2f) nogap  ///
              mtitle(`m') r2 sca(N r2_w r2_a) replace 
     
	 
  *-2.3.2.4 二维聚类标准误

    *  -- Petersen2009 --                 cluter2.ado
    *-Petersen, M. A., 2009, 
    *  Estimating standard errors in finance panel data sets: 
    *  Comparing approaches, 
    *  Review of Financial Studies, 22 (1): 435-480.
      shellout "$R\Petersen-2009.pdf"     //Petersen2009, 面板 SE
      * Stata commnd for 2way clutered S.E.:  cluster2
    
    *  -- CM2015 --                       
    *-Cameron, C. A., D. L. Miller, 2015, 
    *  A practitioner’s guide to cluster-robust inference, 
    *  Journal of Human Resources, 50 (2): 317-372.  
      shellout "$R\Cameron_2015_ClusterSE_JHR.pdf" //cluster SE 使用手册
    
    *  -- CGM2011 --                      cgmreg.ado |  vce2way.ado
    *-Cameron, A. C., J. B. Gelbach, D. L. Miller, 2011, 
    *  Robust inference with multiway clustering, 
    *  Journal of Business & Economic Statistics, 29 (2): 238-249.  
      shellout "$R\Cameron_2011_ClusterSE.pdf"     //多维
      shellout "$R\Cameron_2011_ClusterSE_PPT.pdf" // Robust SE PPT 
      help cgmreg 
      help vce2way
    
    *  -- IM2010 --                       clustse.ado | clustbs.ado
    *-Ibragimov, Rustam and Ulrich K. Muller. 2010. 
    *  t-Statistic Based Correlation and Heterogeneity Robust Inference.
    *  Journal of Business and Economic Statistics 28(4):453-468.
      shellout "$R\Ibragimov_2010_clustse.pdf"
      help clustse  // 基于 Bootstrap 的聚类标准误 
      
    *  -- IM2010 --                       clustbs.ado 
    *-Cameron, A., J. Gelbach and D. Miller. 2008. 
    *  Bootstrap-based improvements for inference with clustered errors.
    *  Review of Economics and Statistics 90(3): 414-427.
      shellout "$R\Cameron_2008_RES_bsClusterSE.pdf" // 基于 Bootstrap 的 SE
      help clustbs   
	
	*  --Thompson2011--
    *-Thompson, S. B. (2011). 
    * Simple formulas for standard errors that cluster by both firm and time.
    * Journal of Financial Economics 99(1): 1-10.   
	  shellout "$R\Thompson-2011.pdf"
	  
	*  -Abadie 2017--
	* Alberto Abadie, Susan Athey, Guido W. Imbens, Jeffrey Wooldridge (2017).
	* When Should You Adjust Standard Errors for Clustering?, working paper
	  shellout "$R\Abadie_2017_adjust_SE.pdf"
      
	  
  *----------
  *-应用范例：
      
	*-数据和模型基本设定
	  use "nlswork.dta", clear
	  xtset id year
	  gen age2 = age*age
	  global x "age age2 ttl_exp tenure hours i.year"
	  
    *-一维 clustered S.E. 公司层面聚类
	  *-FE (within Estimator)
      xtreg ln_wage $x, fe vce(cluster id) //写法1  }
	  xtreg ln_wage $x, fe robust          //写法2  } --> 三种写法等价
	  xtreg ln_wage $x, fe cluster(id)     //写法3  } 
	   
	  *-LSDV (Least Square Dummy Variable estimator) 
	  areg ln_wage $x, absorb(id) cluster(id) //系数估计值相同，但计算 SE 时的自由度调整不同
      est store SE_id
      
    *-一维 clustered S.E. 年度层面聚类 (很少用)
	  * xtreg ln_wage $x, fe cluster(year) //错误命令
	  areg ln_wage $x, absorb(id) cluster(year)	
	  est store SE_year
		
    *-二维 clustered S.E. 公司-年度层面聚类 (比较常用)
      help vce2way // CGM2011, 支持 Panel data, xtreg 等命令
	  
	  *-正确命令
      vce2way areg ln_wage $x, absorb(id) cluster(id year)	
      est store SE_id_year
	  
	  /*********   二维聚类标准误错误陷阱 ！！！错误命令 I
	  vce2way xtreg ln_wage $x, fe cluster(id year)	 	  
                                                  */
	  *-Note: A4_regress.do, Section 4.2.3 中介绍的 
	  *       cluster2 和 cgmreg 都不支持 xtreg
      
	*-特别注意：这是错误的二维聚类标准误
	  egen IDYEAR = group(id year)
	  areg ln_wage $x, absorb(id) cluster(IDYEAR) // [EM1]
	  est store SE2way_Wrong
	  areg ln_wage $x, absorb(id) robust          // [EM2] robust <==> cluster()
      est store SE_white
	  
	  *-上述两条命令(EM1, EM2)本质上等价于如下命令 EM3 
	  gen obsid = _n
	  areg ln_wage $x, absorb(id) cluster(obsid)  // [EM3]
	  
    *-对比
      local m  "SE_id SE_year SE_id_year SE2way_Wrong SE_white"
      esttab `m', mtitle(`m') nogap b(%4.3f) t(%4.2f) brackets ///
    	          star(* 0.1 ** 0.05 *** 0.01) s(N r2) compress ///
				  drop(68.year)
/*
  ---------------------------------------------------------------------------
                   (1)          (2)          (3)          (4)          (5)   
                 SE_id      SE_year    SE_id_year    SE2way_Wrong   SE_white   
  ---------------------------------------------------------------------------
  age            0.078***     0.078***     0.078***     0.078***     0.078***
                [5.29]       [7.70]       [5.89]       [6.49]       [6.49]   
  age2          -0.001***    -0.001***    -0.001***    -0.001***    -0.001***
              [-10.08]     [-11.67]      [-8.66]     [-15.92]     [-15.92]   
  ttl_exp        0.034***     0.034***     0.034***     0.034***     0.034***
               [12.84]      [12.48]      [10.04]      [19.14]      [19.14]   
  tenure         0.011***     0.011***     0.011***     0.011***     0.011***
                [6.68]       [7.71]       [5.78]       [9.94]       [9.94]   
  hours         -0.000       -0.000       -0.000       -0.000       -0.000   
               [-0.83]      [-0.64]      [-0.56]      [-1.10]      [-1.10]   
  Year dumm                        ... ...
  _cons          0.329        0.329*       0.329        0.329        0.329   
                [1.23]       [1.85]       [1.43]       [1.47]       [1.47]   
  ---------------------------------------------------------------------------
  N            2.8e+04      2.8e+04      2.8e+04      2.8e+04      2.8e+04   
  r2             0.688        0.688        0.688        0.688        0.688   
  ---------------------------------------------------------------------------
  Note: t statistics in brackets, * p<0.1, ** p<0.05, *** p<0.01  
*/
		
		
    *-二维聚类标准误的计算方法
	  shellout "$R\Thompson-2011.pdf"  // PP.2
	* 方差-协方差矩阵计算公式为： 	  
	*    V(2way) = V(Firm) + V(Year) - V(White)
	
	  scalar Var2way = (0.0148)^2 + (0.0101)^2 - (0.0120)^2  
	  scalar  se2way = sqrt(Var2way)
	  dis "se2way = " %6.4f  se2way


    *-Comments:
	*
    * 1. 考虑异方差后的 SE 通常会比同方差(Homo)下的 SE 大一些; 但并不绝对如此;
    * 2. 聚类调整后的 SE 要比 Homo SE 大, 如本例中 SE[_cons] 
    * 3. 本例中，二维聚类 SE 约为 Homo SE 的两倍 
    * 4. 在截面数据或面板数据中，通常都要使用聚类 SE
    * 5. cluster(industry) 同时考虑了行业层面的异方差, 
    *    以及行业内部不同公司之间的相关性;
    * 6. Q: cluster(firm) 是什么含义？    
	
	 
  *-2.3.2.5 截面相关和共同因素问题
    
	help xtcce  // Common Correlated Effects Estimation for 
	            // Static Panels with Cross-Sectional Dependence.
		   
    
	

	  
*--------------
*-其他相关命令
  
  *-统计分析和绘图
    help panell      //display panel length for a given set of variables
	help paverage    //calculate p-period-average series in a panel dataset
    help mkdensity   //graph kernel densities of several variables
    help xtgraph     //
  
  *-假设检验
    help xthrtest    //Born&Breitung(2016)纠偏高阶稳健性序列相关检验
	
  *-面板滚动回归	
	help rolloing2   //rolling window and recursive estimation
	help rolloing3   //compute predicted values for rolling regressions
	help rollreg     //perform rolling regression estimation
	help rollstat    //rolling-window statistics for time series or panel data
    help asrol       //Gen rolling-window statistics in TS or panel data
  
  *-高维固定效应模型
	help areg        //自动消除一维固定效应
	help gpreg       //消除二维固定效应 
	help regwls      //estimate Weighted Least Squares with factor variables
	help fese        //Standard errors for fixed effects
	help reg2hdfe    //Two High Dimensional Fixed Effects
	help twfe        //Two-way fixed effects or match effects
    help a2reg       //Models with two fixed effects
	help reg3hdfe    //Three high dimensional fixed effects
	help hdfe        // xtdata命令的升级版, 
	                 // Partial-out variables with fixed-effects
   
  *-变系数模型
    help xtmg        //panel time series models with heterogeneous slopes
	help xtnptimevar //Non-parametric time-varying coefficients panel data
	                 //models with fixed effects
	help xtfixedcoeftvcu //Panel Data Models with Coefficients that Vary over Time and Firm

  *-共同因子模型  
	help xtcce       //the Common Correlated Effects estimator	 
	
  *-面板分位数回归	
	help qregpd      //Quantile Regression for Panel Data
	
  *-聚类分组FE   
	help xtregcluster //partially heterogeneous linear panel data with fixed effects
  
  *-假设检验	
	help resetxt     //Panel Data REgression Specification Error Tests
	use "resetxt.dta", clear
