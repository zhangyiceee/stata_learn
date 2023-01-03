/*======================================================*
Purpose 	:	练习爬虫
Data		:	李春涛团队
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20200616
原文URL：https://mp.weixin.qq.com/s/YRoHKlSqVKX8HS4gyGRlTA
*=======================================================*/
	
	clear all 
	set obs 1
	gen url="https://apps.webofknowledge.com/summary.do?product=UA&parentProduct=UA&search_mode=GeneralSearch&parentQid=&qid=1&SID=6AkyYoRrRihnHX8sx2e&&update_back2search_link_param=yes&page=2"
	gen v=fileread(url)

	split v,p("")


