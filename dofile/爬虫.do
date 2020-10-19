/*======================================================*
Purpose 	:	练习爬虫
Data		:	李春涛团队
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200616
原文URL：https://mp.weixin.qq.com/s/YRoHKlSqVKX8HS4gyGRlTA
*=======================================================*/
	
	clear all 
	set obs 1
	gen url="https://api.bilibili.com/x/v2/reply?type=1&oid=795637027&pn=1&sort=2"
	gen v=fileread(url)
	split v,p("hots")
	keep v1 
	split v1,p(`""rpid""')
	drop v1
	sxpose ,clear
	keep if ustrregexm(_var1,`""parent":0"',.)

	split _var1,p(`""content":{"message":""')
	split _var12,p(`"","plat""')
	rename _var121 content
	gen like = ustrregexs(1) if ustrregexm(_var11,`""like":(\d+)"')
	gen name = ustrregexs(1) if ustrregexm(_var11,`""uname":"(.*?)""')
	drop _var*
	
	clear 
	cap mkdir "/Users/zhangyi/Documents/GitHub/stata_learn/output"
	cd "/Users/zhangyi/Documents/GitHub/stata_learn/output"
	copy "https://movie.douban.com/subject/30295905/reviews?start=0" temp.txt,replace //把网页源代码拷贝到temp.txt中
	infix strL v 1-100000 using temp.txt, clear //读入到当前dta里



