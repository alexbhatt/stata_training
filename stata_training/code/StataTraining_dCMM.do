/*******************************************************************************
	Stata training: Data cleaning, manipulation and management
	
	work your way through this do file and complete your own code.
	
	add lots of your own comments. and i recommend that you use tabs when coding.
		it make code much easier to read
		as you know line this is now a related to the lines above
	
		where you see *T# at the start of a line, i've put questions for you solve
	where you see *i i've put information and hints

*******************************************************************************/
set more off, perm

*T1		set the working directory
cd ""

/*******************************************************************DATA_IMPORT*

	check out your spreadsheets. sometimes a quick look in excel is helpful
		what do you see?
	its in 3 seperate spreadsheets, what kind of animal provides data like this!?
	import and save (as .dta files) the 3 tables seperately
	inspect your data, what do they contain and what format are they in [describe]
		did stata read your dates correctly?
			sometimes its safer to use the -all- option for importing excel, this turns everything into strings
			compare your data types, when appending, data types must both be string or numeric
			if your dates are in different formats, its easier to format before appending
	are the three tables simliar? do they have the same variable names?
	do you need to make any changes to them first?
	once they're standardised, append the tables (add them together)
		tables will result in errors if you append them and they're different
		eg 	id numbers are string format in one table and numerical in another
			will result in a loss of data
			
	useful helpfiles:
		help import // read import_options for excel (xls/xlsx) and delimited (csv)
		help describe
		help codebook
		help rename
		help tostring // destring
		help append
		
*******************************************************************************/

*T2 import spreadsheets
*T3	explore the imports seperately, modify them to make them simliar


*i	note the differences between a CSV and a XLS[X] import
*i	careful of dates, i recommend using the ,all option
*i	decide on your variable names, consistency is king (or queen).
*i	HINT: you'll need to save each one seperately



*T4	append your tables 
*i	before you can append, you need to start with a dataset [use data\line_list_2015,clear]
*i	if variables are different data types, when you append the later ones will be removed
*i 	,force will cause errors with mismatched data types (string vs numeric) try it and see


*T5 save your appended line list in the data subfolder


/*****************************************************************DATA_CLEANING*
	
	now you have a full line list of data. now what. 
	you gotta check and clean it. you can be sure its got issues.
	
	1.	is all the data there, if not where is it missing or inconsistent?
			are these random or systematic?
	
	2. 	are observations given in multiple formats?
	
	3. 	are dates in a STATA workable format?
	
	4. 	are there duplicates in the data? drop them like their hot.
	
	useful stuff:
		help tab
		help gen
		help replace
		help cond // this is an IF/ELSE function
		help if
		help label
		help duplicates
	
	string commands, these are really helpful. learn how to use them.
	a string can be input manually using "" or can refer to a string variable
	---------------------------+------------------------------------------------
	command				   	   | what does it do
	---------------------------+------------------------------------------------
	length(str)					returns number of characters in str
	word(str,n)					returns nth word from str (if n<0 starts counting from right)
	reverse(str)				returns str reversed
	trim(str)					removes both leading and trailing spaces
	lower(str)					returns str without lowercase letters only
	upper(str)					converts all letters to uppercase
	proper(str)					capitalizes all letters not preceded by letters
	regexm(str,re)				evaluates whether str matches regular expression re
	regexr(str1, re, str2)		replaces the first substring of str1 that matches reg. exp. re with str2
	strmatch(str1,str2)			tests whether str1 matches pattern str2
	strpos(str1,str2)			returns position of str2 in str1
	substr(str,n1,n2)			extracts characters n1 through n2 from str
	subinstr(str,sub1,sub2,.)	replaces all instances of str1 with str2 in str
	---------------------------+------------------------------------------------
	
	look at the difference in results between these (run them):
		di regexr("ALEX WANTS YOU TO LEARN STATA STRING FUNCTIONS","A","4")
		di subinstr("SERIOUSLY. LEARN STATA STRING FUNCTIONS","S","5",.)

*******************************************************************************/
*i	load in your raw dataset.

*T6	investigate data: age, sex, identifiers
*i	decide how you want your final variable to look, what is easiest for you?
*i	whatever you choose, assimilate them, resistance is futiile.
*i	sex can be "Unknown" or missing
*i	date of birth can be missing or in some cases unknown is listed as 01/01/1900
*i	numeric variabels are almost always easier to work with than string. 
*i	take a look at [healthcare_id] play with the format function
*i	do we have any missing, what does that mean, what other info do we have?
*i	how many different species do we have listed

	
*T7	stata those dates. do you have multiple date formats, how do you deal with that?

	

*T8	check for duplicates and remove them
*i	in this dataset a hospital may send a blood sample to more than one lab
*	or a single lab may submit their own sample more than once to the surveillance
*i	deduplicate igoring the lab and any overall duplicates (2 lines)



	

/*******************************************************************************	
	ok now what.
	lets do some management. we'll create some new variables which will help
	with further analysis or manipulation of the data. what information do we
	want thats not immediately provided, but can be derived from existing data 
	and could be useful?
			
	helpful commands:
		help egen			// there are lots of [type] choices, start with cut
		help round
		help label
		help inlist
		help bysort
		help replace
		help _n
		help duplicates		// read about drop and tag
*******************************************************************************/

*T10 create a year variable, use the date functions to extract the year


*T11 calculate age in years at the time the specimen was taken
*i	 remember, stata saves dates as a counter of days, how do we turn these into years?


*T12 calculate age groups [<1, 1-4, 5-14, 15-29, 30-49, 50-74, 75+]
*i	 create a label for the values, did you use the ,ic option?
*i	 compare your categorical result against the continuous one for validation



*T13 we're going to construct a patientID
*i	 what criteria (and exclusions!) would you want to use to group a patient?
*i	 in this dataset: 
*		a missing hospital_id can be classified as: missing, 0, 123456789, 999999999
*		invalid dates of birth are either blank or set at 01jan1900
*		what other vars are you using, and what are their "unknown" or "missing" values?
*i		sometimes its easier to create a flag variable to store this, especially if you'll be using it a few times

* 	exclusion criteria (heres one for an example)
gen _dob=1 if birth_date==. | birth_date==td(01jan1900)

*i 	start with [gen id=_n] and look at the output.
*i	you'll use bysort and replace with index numbers for this part.
*i	you can use multiple steps, each line will be a different set of criteria
gen id=_n

*i	bysort steps for patientID, try using 4 of patient identifiers for the ID
*i	don't forget to include the exclusions as if-statements for each one


*T14 create a new var which has the total number of infections per person 
*	 and a second which flags (1/0) the first time a patient had an infection/species/year
*i	 HINT: this uses bysort and _N[max number of observations] or _n[index number]
*i	 what are the max, min and mean number of infections/patient
*i	 how many patients had more than one infection?
*i	 how many E. coli infections were there in 2016
*i	 how many patients had an E. coli infection in 2016


*T15 of those with more than one infection, how many had a simultaneous infection from more than one organism
*i	 for the purpose of this, two species on the same specimen_date per person
*i	 HINT: use duplicates tag, and an if statement.
*i	 how do you interpret these results, what does a 0 mean?
*i	 browse your results to help understand


*T16 save your deduplicated prepared dataset.


/*******************************************************************************

	ok so you have cleaned, prepped and managed your data. time to do stuff and things.
	lets change the dataset. we will be creating new tables.
		
		collapse, reshape, append, merge: data transformations.
	
	this is why you save your data BEFORE doing these parts. there is no undo.
	
	collapse: this creates a new dataset of summary data from your existing dataset.
		help collapse
	
	reshape: this takes a dataset and reforms it from long-wide or vice-versa.
		long data is often easier for analysis, but wide is often easier for presentation
	
		help reshape	// read and understand the difference between wide and long
		
	merge: this is a left:right join, take a table, and attach another table to it based on a unique key
		read about the different join types (1:1, m:1, 1:m, m:m), and keep() options
		
		help merge
	
	loops: there are two main types of loops
		help macro		// loops use local macros, you call a macro using `macroname'
		help foreach 	// these are for looping over variables
		help forval 	// these are for looping over numbers
		
		general syntax (highlight and run these to see the outputs)
		
			foreach v of varlist area_name area_code {
				di "looping over variable: `v'"
			}
			forval i=1/10 {
				di "looping over number: `i'"
			}
	
	preserve/restore: takes snapshots of your data and allows you to return to it
		help preserve
		
	help export excel	// export your current data table or a subset to excel
	
*******************************************************************************/

*i	load your dataset

*i	run this, this is a second data table.
*i	preserve/restore work a bit like a use once undo, but you set the "save" point
*i	look at this data table. we are going to join on it in a minute.
*i	how does this table differ from our collapsed dataset?
*i	what variable is shared and allows a join
*i	what type of join would we use?
preserve
	use data\area_population, clear
	list
restore


*T17 summarise the data using collapse for counts of infection episodes per area per year
*i	 for ease i like to create a sum variable [gen n=1] for collapsing on.
*i	 what do you want to collapse on, play with a few options
*i	 is your data in WIDE or LONG format?
*i	 sometimes its helpful to create a count variable for collapses

*T18 summarise your regional dataset to give a national picture
*i	 are any variables missing, can we correct for that?
*i	looking at the population table, create a variable with the correct key value 

*T19 join the regional and national summary tables

*i	 note the differences between your dataset and the population data
*T20 reshape your data to match the population dataset in preparation for a join
*i	 once datasets are both wide or both long, they can be joined.

*T21 join the population data onto your dataset
*i	 what kind of join should you be using here?
*i	 what is the index key variable(s)?




*T22 calculate annual incidence rates for each organism per 100,000 population
*i	 use a forval loop to loop over the years.


*i	now you have a new dataset, save it
save data\, replace


*T23 order your data, and export it to excel sheet called INC_`GENUS'
*i	 is your data shaped how you want it
*i	 do you need all the variables in the dataset to be exported?
*i	 extract the genus from the species name using string functions
*i	 use variable labels when you export to excel
*i	 loop using levelsof, create the macro then foreach loop over its values


*T24 create a new summary table of infection episodes per year and month per organism
use data\, clear

*T25 export monthly counts of infection episodes by species and year
*i	 import your data, collapse and reshape, generate new vars and sort as needed
*i	 try using levelsof and a foreach loop for your export


*T26 export an agegroup:sex breakdown with sex presented as proportions for each species by year
*i	 what happens when you collapse but have missing data?
*i	 for the purpose of this, remove all missing/unknown data after your collapse.
*i	 collapse, reshape, generate new vars and sort as needed
*i	 loop your export.
