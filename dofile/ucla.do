/*=======================================================*
Purpose 	:	improve my stata skills
Data		:	from UCLA 
Created by	:	YiZhang zhangyiceee@163.com
Last Modify : 	20191010
*=======================================================*/
*https://stats.idre.ucla.edu/other/mult-pkg/seminars/
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
	tab 	  co2 , m
	tab 	  lungcapacity , m

	summ    age
	replace age = .b if age > 120 | age < 18
	*Report counts of missing values with missyable summarize
	misstable summarize lungcapacity test1 test2
	*Profile how variables are missing together(missing data patterns) with misstable patterns
	misstable patterns
*Creating and transforming variables
	*Use generate and replace for simple arithmetic or logical operations
	gen     average = (test1 + test2)/2
	misstable patterns average test1 test2
	*Be careful with logical operations when working with missing values 
	gen     above50_wrong = 0
	replace above50_wrong = 1 if  age > 50
	misstable summarize age above50_wrong
	gen     above50 = age > 50
	replace above50 = age if age >=.
	misstable summarize age above50
	*Functions to transform variables
	gen  marsum = sum(married) //累加
	gen  random = runiform()
	list married marsum random in 1/10
	*The egen command extends variables generation with even more functions
	*egen == extended generate
	egen mean  = rowmean  (test1 test2)  //行的均值
	bro  test1 test2 mean 
	egen total = rowtotal (test1 test2) //行的数值加总
	*rowmiss & rownomiss ,count the number of missing and non_missing values across a specified set of variables
	egen numiss = rowmiss(lungcapacity test1 test2 familyhx smokinghx)
	list lungcapacity test1 test2 familyhx smokinghx numiss in 1/10
	egen bmi_cat = cut(bmi) , at(0,15,16,18.5,25,30,35,40,500) label
	tab  bmi_cat , nolabel 
	egen family_smoking = group(familyhx smokinghx) ,label
	tab  family_smoking  , miss
*Change variable coding with recode 
	tab bmi_cat , nolabel
	recode bmi_cat (0 1 2=3)(6 7=5)
	tab bmi_cat , nolabel
*Renaming variables and groups of variables with rename 
	*change var name with rename 
	rename test1 il6
	rename test2 crp
	rename (experience school) d_=
	des    d_*
	rename d_* doc_*
	des    doc_*
*Managing string variables 
	*Values for string variables are always enclosed in quotes, "" 
	tab sex , m 
	replace sex = "" if sex== "12.2"
	tab sex , miss
 	*String functions 
 	/*
 	strtrim： removing leading and trailing spaces
	substr ： extract substring
	strlen ：length of string 
	strpos ：the position in a string where a substring is found
	strofreal：convert number to string with a specified format
	*/
	tab hospital
	replace hospital = strtrim(hospital) 
	tab hospital
	
	tab docid
	gen doc_id = substr(docid,3,3)
	tab doc_id
	*Concatenate strings with +
	gen newdocid = string(hospid) + "-" +doc_id
	list newdocid hospid doc_id  in 1/10
	*Regural expressions 正则表达式
	gen regxdocid = regexs(1) if regexm(docid,"[0-9]-([0-9]+)")
	*Encoding strings into numeric variables
	encode cancerstage , gen(stage)
	bro cancerstage stage
	des stage
	*Convert number variables stored as strings to numeric with destring 
	tab wbc
	replace wbc = "" if wbc == "not assessed"
	destring wbc,replace
	des wbc
*Labels
	*variable labels
	label list //list the names and contents of existing value labels 
	
















** STATISTICAL COMPUTING SEMINARSREGRESSION WITH STATA***



