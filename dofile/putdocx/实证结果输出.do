! taskkill /F /IM WINWORD.EXE /T
clear all
cd d:/陕西师大

clear all
putdocx begin 
putdocx paragraph, halign(center)
putdocx text ("学霸vs学渣：院长对学院产出的影响"), ///
   linebreak font("华文楷体",20,black) bold  
putdocx text ("李白耶夫斯基"), linebreak ///
  font("华文楷体",12,green) bold 
putdocx text ("翰林院大学管理学院"), linebreak ///
  font("华文楷体",12,purple) bold 
putdocx text ("Email:"), ///
  font("Arial",12,blue) bold 
putdocx text ("libai@hlu.edu.cn"), ///
  font("Arial",12,blue) bold underline(single) linebreak
putdocx text ("孟浩然正气"), linebreak ///
  font("华文楷体",12,green) bold 
putdocx text ("烟花大学青楼文学院"), linebreak ///
  font("华文楷体",12,purple) bold 
putdocx text ("Email:"), ///
  font("Arial",12,blue) bold   
putdocx text ("haoran@fu.edu.cn"), ///
  font("Arial",12,blue) bold underline(single) linebreak
local a1 ABSTRACT: 
local a2 院长在人才招聘、人才晋升和制定游戏规则中有着重要的话语权，
local a3 其对学院的发展至关重要。院长的能力不仅表现在学术成就方面，
local a4 也表现在其社会交际能力方面。学术界对究竟什么样的人适合做
local a5 院长还尚无定论，本文利用中国大学学院院长变更带来的自然试验，
local a6 利用双重差分方法，研究了院长学术成就对学院学术产出的影响。
local a7 研究中，我们把那些学术成就平平的院长成为学渣院长，
local a8 把那些有一定学术成就的院长定义为学霸院长，研究发现，
local a9 学渣院长上任后，学院的学术产出显著提升。为了解释这种匪夷所思
local a10 的结果，我们进一步考察了文章的影响因子，发现学渣院长上任后，
local a11 学院的教师更倾向于在学渣类期刊发表论文，
local a12 甚至出现论文灌水的现象。学霸院长虽然不能显著提高发表的数量，
local a13 但是能显著地提高发表的质量。改变学霸和学渣的定义后进行
local a14 的一系列稳健性检验进一步证实了以上的结论。

putdocx paragraph, halign(both)
putdocx text ("`a1'`a2'`a3'`a4'`a5'`a6'`a7'`a8'`a9'`a10'`a11'`a12'`a13'`a14'"), ///
  font("Arial",12,blue) bold underline(single) 
putdocx paragraph, halign(both)

putdocx save "d:/陕西师大/实证分析.docx",replace 

putdocx begin 
putdocx pagebreak
putdocx save 实证分析.docx, append


sysuse auto, clear
rename weight 车重
sum2docx price mpg 车重 length foreign turn trunk ///
	using 实证分析.docx, append ///
	stats(N mean(%9.3f) sd(%9.3f) min(%8.0g) median(%8.0g) max(%8.0g)) ///
	title("Table 1: summary statistics")

putdocx begin 
putdocx pagebreak
putdocx save 实证分析.docx, append

t2docx price mpg 车重 length turn trunk using 实证分析.docx, append ///
	by(foreign) fmt(%9.2f) title("Table 2: t-test table") ///
	note("依据变量foreign分组") font("黑体",9,blue)
	
putdocx begin 
putdocx pagebreak
putdocx save 实证分析.docx, append

corr2docx price mpg 车重 length foreign turn trunk ///
	using 实证分析.docx, append ///
	fmt(%4.2f) nodiagonal title("Table 3: Correlation Coefficient") ///
	note("By 爬虫俱乐部")

putdocx begin 
putdocx pagebreak
putdocx save 实证分析.docx, append

tab rep78, gen(rep78_)

reg mpg 车重 length gear_ratio trunk foreign 
est store m1
reg mpg 车重 length gear_ratio trunk foreign rep78_*
est store m2
reg mpg 车重 length gear_ratio trunk turn foreign 
est store m3
reg mpg 车重 length gear_ratio trunk turn foreign rep78_*
est store m4

reg2docx m1 m2 m3 m4 using 实证分析.docx, append ///
	indicate("rep78 = rep78_*") drop(trunk turn) ///
	scalars(N r2(%9.3f) r2_a(%9.2f)) ///
	order(foreign 车重 length) b(%9.3f) t(%7.2f) ///
	title(表4: OLS回归结果) ///
	mtitles("model 1" "model 2" "model 3" "model 4")
		
putdocx begin 
putdocx pagebreak
putdocx save 实证分析.docx, append

ivregress 2sls mpg gear_ratio trunk turn foreign rep78_* (车重 = headroom)
est store m1
ivregress 2sls mpg gear_ratio trunk turn foreign (车重 = headroom)
est store m2
ivregress 2sls mpg gear_ratio trunk turn (车重 = headroom)
est store m3
ivregress 2sls mpg gear_ratio trunk turn rep78_* (车重 = headroom)
est store m4

reg2docx m1 m2 m3 m4 using 实证分析.docx, append ///
	indicate("rep78 = rep78_*") drop(trunk turn) ///
	scalars(N r2(%9.3f) r2_a(%9.2f)) ///
	order(foreign 车重) b(%9.3f) t(%7.2f) ///
	title(表5: 最小二乘回归结果) ///
	mtitles("model 1" "model 2" "model 3" "model 4")

shellout 实证分析.docx
