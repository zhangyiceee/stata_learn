/*=======================================================*
Purpose 	:	improve my stata skills
Data		:	from UCLA 
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20191010
*=======================================================*/
*http://stats.idre.ucla.edu/stata/
	clear all 
	set more off
** UCLA IDRE STATA DATA MANAGEMENT SEMINAR***
*Inputting data into stata
	*Clear memory for new datasets
	*Excel and .csv files 
	import excel "https://stats.idre.ucla.edu/stat/data/hsb2.xls" , firstrow clear
	*firstrow tells stata that the first row of the excel files have var names
	*clear clears memory of any datasets before importing 
	import delimited "https://stats.idre.ucla.edu/stat/data/hsb2.csv" ,clear
	*stata assumes that variable names are the first row of data in text files
	*so no firstrow option for import delimited
	*Stata data files 
*Data for this seminar
	use https://stats.idre.ucla.edu/stat/data/patient_pt1_stata_dm, clear
	d
*View the dataset

	list  
*list followed by variable names will display only those variables
	list hospital-pain
*browse 
	bro
*describe :provides the following information about how variables are stored
	des
*codebook :for more datailed information about the values of each variable
	codebook 
	*codebook command can be followed by specific variable names,or specificed
	// by itself to process all variables
*Selecting observations
	*Selecting by observation number with in
	list age in 1/10
	list age in -10/L //(-10 is 10 observations from the end ;L mean the last observation)
	*Selecting by condition with if
	











