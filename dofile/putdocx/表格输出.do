
clear all
sysuse auto 

putdocx begin
putdocx paragraph 
putdocx text ("表 1: 前30行样本"), ///
   linebreak font("华文楷体",20,red) ///
   bold underline(dash) shading(yellow)
putdocx table t1 = data(make mpg weight length price) ///
 in 1/30, varnames layout(autofitw) /// 
 border(insideH, nil) /// 
 border(insideV, nil) ///
 border(start, nil) ///
 border(end, nil) ///
 border(top,triple,blue) ///
 border(bottom, triple,blue)
 
 putdocx table t1(1,.),border(bottom,single,red)
 putdocx table t1(21,.),border(top,single,red)
 
 
  putdocx table t1(.,1),border(end,single,purple)
 
putdocx pagebreak  
putdocx save d:/陕西师大/表1.docx, replace 

putdocx begin
putdocx paragraph 
putdocx text ("表 2: 31-60行样本"), ///
   linebreak font("华文楷体",20,blue) bold ///
    underline(dash) shading(yellow)
putdocx table t1 = data(make mpg weight length price) ///
 in 41/60, varnames layout(autofitw) ///
 border(insideH, nil) /// 
 border(insideV, nil) ///
 border(start, nil) ///
 border(end, nil) ///
 border(top,triple,blue) ///
 border(bottom, triple,blue)
 
 putdocx table t1(1,.),border(bottom,single,red)
 putdocx table t1(21,.),border(top,single,red)
 
 putdocx table t1(.,1),border(end,single,purple)
 putdocx pagebreak 
putdocx save d:/陕西师大/表2.docx, replace 

putdocx append d:/陕西师大/表1.docx d:/陕西师大/表2.docx, ///
	saving(d:/陕西师大/表格输出.docx, replace)
shellout d:/陕西师大/表格输出.docx
