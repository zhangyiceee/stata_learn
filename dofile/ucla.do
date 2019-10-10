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
	list age if sex == "female" & pain > 8 ,clean
	//conditional selection is handled in stata by the "if" operator
*Appending files - adding more rows of observations 
	*append:append data files when we need to add more rows of observations of the same variables
	append using https://stats.idre.ucla.edu/stat/data/patient_pt2_stata_dm
	des
	tab nmorphine , miss
*Merge data --adding colums of variables 
	*merge_type : 1:1 ; 1:m ; m:1 ; m:m
	describe using https://stats.idre.ucla.edu/stat/data/doctor_stata_dm
	merge m:1 docid using https://stats.idre.ucla.edu/stat/data/doctor_stata_dm
	*_merge =1:the observation's merge id was unique to the master file
		   *=2:the observation's merge id was uniqe to the using file
		   *=3:the observation's merge id was matched
	drop if _merge == 2
*Handling duplicated data 
	*Count the number of duplicates
	duplicates report
	duplicates report _all
	duplicates report hospid 
	*Tag duplicates for inspecton
	duplicates tag , gen(dup)
	tab dup
	*Dropping duplicates 
	duplicates drop
*Missing Data
	*Missing values
	*Detecting missing data codes
	sum
	graph box co2 lungcapacity test1 test2
	tab smokinghx, missing
	tab familyhx, missing
	*use mvdecode to convert user-defined missing data codes to missing values
	mvdecode _all , mv(-99)
	*use replace to convert "-99" to "" for string variables familyhx and smokinghk
	replace familyhx = "" if  familyhx == "-99"
	replace smokinghx = "" if smokinghx == "-99"

	tab familyhx , m
	tab smokinghx , m

	mvdecode  lungcapacity co2 , mv(-98=.a)
	tab co2 , m
	tab lungcapacity , m

	summ age
	replace age = .b if age > 120
	

















