/*======================================================*
Purpose 	:	练习爬虫
Data		:	李春涛团队
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200616
原文URL：https://mp.weixin.qq.com/s/YRoHKlSqVKX8HS4gyGRlTA
*=======================================================*/
	
	clear all 
	set obs 1
	gen url="http://paper.jyb.cn/zgjyb/html/2021-09/26/content_599826.htm?div=-1"
	gen v=fileread(url)


	split v,p("")


