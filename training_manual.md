# Stata Training: Data Cleaning, Management and Manipulation



### Objectives

Participants should have a basic working knowledge of how to use the Stata program prior to starting this training. This includes general program use and how to create do files.

By the end of this training, participants will:

* Develop the ability to independently learn how to use commands in Stata using help files

* Understand the basic steps required for data cleaning, manipulation and management

* Create a data cleaning, manipulation and management do file

* Understand the importance of proper data cleaning, manipulation and management prior to statistical analysis

* Learn how to export Stata datasets to excel

* Become at least a level 2 data wizard




# Stata basics

### Coding best practice

**Always code in a do file.** Do files enable you to save and script a logical flow of commands to run on your data. This is how you will ensure reproducibility in your work, for yourself and others. Within a do file, you can leave comments. These will make your life easier.

Comments work in Stata by either putting a `*` at the beginning of the line, or `//` after code, see the example below. Alternatively, to comment a block of code over several lines use `/* */`, everything between the `*` will be commented. Comments allow you to annotate in your do file, and will not be read as code, even if there is actual code within the comment. This means you can use comments to "silence" code that you're still working on or testing.

* write lots of comments so you remember what and why you've done something
  * leave a header comment at the top of your file containing the following:
    * project title
    * description outlining the overall purpose of the code
    * your name
    * date the code was last edited
    * look at the template file for an example of what to include in your header
  * within the code itself, leave comments for what you're trying to do, sometimes you'll come back to it with a new improved method
  * separate out your code into sections, put a comment line to demonstrate that everything in that section relates to the same purpose eg. data import, data cleaning, data management
* use tabs to indent code, indented code implies that it relates to the code above, this makes code much easier to read; for example: the replace lines are reliant on the results of the gen line
  * this has no impact on how to code functions, but simply makes your code neater, and means it's easier to read and edit for both you and others

```stata
*i 	training program based on location
	gen program="EPIET" // creating a new categorical variable
		replace program="UK FETP" if country=="ENGLAND"
		replace program="PAE" if country=="GERMANY"
```

* make your code as simple and efficient as possible, you'll always learn better ways in the future, thats okay, but never make your code more complicated than it needs to be
* save your code often, if you've made major changes in methods, save a new version, never delete old methodology/completed code, you may have been right the first time
* save your working files (`.dta`) at each stage, *eg. raw import, cleaned, ready for analysis*
* if your file has become too long to manage, perhaps its better to split it over two or more do files
  * this is often very helpful when its a complicated process and you want to focus on one stage per file or your're troubleshooting why the process isn't working as expected
    * *remember*: you can run a do file as a command (within another do file)




### Stata Data types

Stata has two data types. String and numeric. The way Stata deals with each is different. 

**Table 1. Differences between numeric and string data in Stata**

|                      | numeric                                  | strings                                  |
| :------------------- | :--------------------------------------- | :--------------------------------------- |
| **contains**         | any real number (+ / -)                  | any characters                           |
| **example value**    | `3.28`                                   | `"ALEX"`                                 |
| **missing value**    | *full stop*: `.`                         | *blank*:  `""`                           |
| **functions**        | evaluate magnitude (>= / <=)<br />add, subtract, multiply, divide | string functions and regular expressions |
| **example function** | `di 3*28`                                | `di substr("ALEX",1,1)`                  |

You cannot combine a string and a numeric variable. Likewise, the missing characters are specific to the data type. Attempting either will result in an error message. You can always convert a number to a string, but you cannot always convert a string to a number. 

Note that all dates, even when they're formatted in Stata format are still numeric. Likewise, you can label number values. This will display a string value instead of the numeric value, but like dates, the actual data is still a number. We'll get to this later.

When working with strings, the string value must be in double quotes `"string goes here"`.  When using the string variable name, it does not require quotes. 

#### Formatting

Stata allows you to format variables and change how to they are presented in the display and outputs. With numeric variables, formatting does not change the true value (including all its decimal points), it simply displays a rounded number. Dates work the same way, you can set your date format to whatever you're comfortable with, it does not change how Stata does calculations with the value.




### Stata commands

As a reference, Stata commands always follow this general format. The commands have four parts:


```stata
	bysort [varlist]: command [if] [, options]
```
**Table 2. Stata command parts.**

| Stata code          | What is it for                           |
| :------------------ | :--------------------------------------- |
| `bysort [varlist]:` | You are telling the program to run the command, but grouping your data according to the listed variables |
| `command`           | This is the main command, the functions you will use in Stata; each command has a help file which tells you how to use that specific command |
| `[if]`              | These allow you to selectively run a command on a subset of data based on the evaluation of certain criteria or an expression |
| `[,options]`        | Almost every command in Stata has options, which allow you to change how to main command works, this may change the functionality, or simply just display extra information |

To run code in Stata, only the command is required, the other three parts are optional, however you will use them extensively. The help file for every Stata command will tell you exactly how to use that command, including its syntax and if it allows if-statements and what its options are.



#### Operators

Operators are the commands which you can use to evaluate expressions. Like math, an expression is a line of code which will be evaluated for a result. Remember your order of operations from math, same order applies (Brackets, Exponents, Multiplication/Division,Addition/Subtraction). But, we also have AND and OR. 

**Table 3. Operators in Stata.**

| Stata code                      | Operator                                 | Example                                 | Purpose                                  |
| :------------------------------ | :--------------------------------------- | :-------------------------------------- | :--------------------------------------- |
| `=`                             | Assignment                               | `gen x=1`                               | only used when generating a new variable |
| `==`                            | Equals to                                | `gen x=1 if 2==2`                       | assess if left side equals right side    |
| `!=`                            | Not equal to                             | `gen x=1 if 2!=3`                       | assess if left side does not equal right side |
| `>=` `>` `<=` `<`               | Greater than/ <br />less than <br />(or equal to) | `gen x=1 if 2<=3`                       | as it sounds<br />only works with numbers |
| `&`                             | AND                                      | `gen x=1 if y==2 & z==3`                | to evaluate 2+ things, BOTH side of `&` must be TRUE |
| `¦` (solid line pipe character) | OR                                       | `gen x=1 if y==2 ¦ z==2`                | to evaluate 2+ things, only ONE side of ¦ must be TRUE |
| `+` `-` `*` `/` `^`             | Add, subtract, <br />multiply, divide, exponent | `gen x=1*3/3+2^2-4`                     | math, order is important<br />numbers only |
| `()`                            | Brackets                                 | `gen x=1 if y==2 ¦ (2^2==4 & a=="red")` | everything in the bracket must <br />be considered, this allows you to group expressions |

AND/OR are different from equals or not equals. These rely on TRUE/FALSE outcomes. For example, `2+2==4` and `2+2!=5` are both TRUE. Conversely, `5<4` is FALSE.

Don't worry if you don't fully understand all of this yet. You will.



# Introduction

This training will teach you how to clean, manipulate and manage data like a wizard. Importantly, the suggested code/commands are just one way to solve each problem, not the only way, you may find another way which gives the same results, and you prefer. This method will improve your ability to work in Stata autonomously.

The framework and principles used in this training can be broadly applied to most datasets you encounter. However, each dataset is unique and will present its own challenges. The principles outlined here can be transferred to other statistical data programs such as R.

This training does not cover any graphical outputs. Stata outputs are often not of publication quality, but are very helpful for data exploration. Final published tables and graphs are recommended to be made in other programmes such as Microsoft Excel, or R.

Throughout this document, `Stata code will be formatted like this`. Within the template Stata do file, where you see `*T#` at the start of a line, I've put tasks for you solve; where you see `*i`, I've put information and hints.

The `help` command displays help information about the specified command or topic. For each task, you'll be provided with the key Stata commands you'll want to use, but you have to figure out how to use the command and its syntax properly using the help files. The help command does not execute the command, it simply teaches you how to use that specific command. In the help file, you'll see the command name, sometimes with part of it underlined. This is the short form of the command; eg. for <u>di</u>splay the short form is `di`. 

If you ever want to use the command line as a calculator, or test out a string, use `di`. This will print out the result of your calculation or string function.

```stata
	help help 
	help di
	
 *i	paste the two lines below in the command line in Stata
	di "this will print out in the display"
	di 2+2
```



### The dataset

This practice dataset is simulated and does not contain any actual patient or laboratory data.

These simulated data contain routine laboratory surveillance data of incident cases of bacterial bloodstream infections in England from 2015 to 2017. There is only one record per infection episode; however, an individual can have multiple infection episodes over time. Each infection episode is considered a new infection.

**Table 4. The core dataset with variables names and contents.**

| Variable        | Contents                                 |
| :-------------- | :--------------------------------------- |
| `healthcare_id` | a unique healthcare ID number per patient |
| `hospital_id`   | a hospital based ID number per patient   |
| `sex`           | the sex of the individual                |
| `soundex`       | an anonymised surname field for a patient |
| `birth_date`    | patient date of birth                    |
| `lab`           | a unique ID number for the lab which supplied the data |
| `specimen_id`   | an ID number created by the lab for the blood specimen |
| `specimen_date` | the date the specimen was taken          |
| `species`       | the species isolated from the blood culture |
| `area_name`     | the region in which this infection occurred |
| `area_code`     | the code for the region                  |

The required files for this training are already in the above format. Download the project directory here:

Extract the contents of the zip file to your chosen project directory. The project directory is wherever you choose to save the unzipped folder. Open the PDF manual and the do file `code\StataTraining_dCMM.do` in Stata (v12.0 or higher required). Compete your code in the provided template do file.


# Import Data

>**TASK 1: set the working directory to your project folder**

```stata
	help cd
```

This should always be in the first set of commands within your do file. It is how you will navigate around the different files that you will be accessing or creating. It also means that if someone wants to use your code, and they have the files, they only have to change the directory here, and not every time a file is referenced within the code.

In Stata, you can only have one dataset in memory at a time. Before a new dataset can be loaded in, you will need to clear the memory. This can be done with either the first using the command `clear` or using the `,clear` option when loading a new dataset.

### Importing spreadsheets

Stata imports excel files [`.xls`/`.xlsx`] differently than text delimited files [`.csv`/`.txt`]. Read about the different syntax needed. Always spend a little time looking at your data, particularly when it's fragmented like this. How you look at your data will be a personal preference, however, there are several tools within Stata available to you to aid this exploration. 

When you explore your data: 
* take a look at the structure of the data. 
* what are the names of the variables 
* are they of the same type (string vs numeric) 
* sometimes it can be helpful to import your data as all string as Stata and Excel sometimes play tricks with dates.



>**TASK 2: import the spreadsheets from the data folder into Stata without making any modifications in excel**

>**TASK 3: explore the tables, note any differences and modify the tables so that they have the same structure, save each of your modified tables**

We are going to import and explore each of the tables separately. Remember you'll need to `clear` the memory each time. By saving your imported datasets as `.dta` they can be safely cleared from the memory and brought back in later with all your changes and formatting. Recall that our project directory `cd` is set to our current  directory, but we want to save the file into our `data` folder.  Use `data/filename` in with  save command. We will have three separate `.dta` files, each containing one year of data. Look back at the variable names listed in the Table 1 and what we learned previously about data types. Make the three tables consistent. We are **not** changing any of the data within the tables at this stage.
```stata
	help import 	// read the import options
	help describe 	// look at the data types
	help codebook
	help browse
	help rename
	help tostring 	// destring is the opposite
	help save		// read about the replace option
```


>**TASK 4: append the tables**

```stata
	help append 	// this is a top:bottom join, it adds observations into the dataset
```
We have 3 similar tables, but we want one. Join them top to bottom. Stata will report an error if you attempt to append a table where the variable types are different (eg. In one table `healthcare_id` is string and in the other its numeric). Whichever data type was there first is what Stata will assume is correct. If you specify the option `,force`, it will result in all type-mismatched data being replaced with a missing value.




>**TASK 5: save your new appended dataset with all three years data in your data subfolder**

```stata
	help save
```

This is our base original dataset. We've made no real changes other than to amalgamate the data. Save it and don't change it. 



# Data cleaning

### What is data cleaning

This is when you modify your data by changing the original values within the dataset. It is important to record any and all changes in the do file, to ensure that you and others can reproduce the results in the future. Always leave comments as to why changes were made. Remember, we **never** change the original dataset; we will save these changes as a new version of the dataset.

The purpose of data cleaning is to make our data as consistent as possible in preparation for analysis. This may include activities such as: formatting or recoding data, removing duplicate entries and accounting for missing data. This may also be referred to as having "tidy" data. Simply put, a clean dataset is easier to work with and a tidy dataset is easier to manage. Combined, having a a clean and tidy dataset will result in fewer mistakes in your code and therefore, your results.

In a <a href="https://en.wikipedia.org/wiki/Tidy_data" target="_blank">clean/tidy dataset</a>:

* each variable has its own column
* each observation of that variable is in a different row (this is long format data; we'll get to this later)
* if you have multiple related tables, they should include a column in the table that allows them to be linked

Remember, Stata can work with both numbers and strings. However, Stata codes a missing value differently depending on what format it's in. In numeric variables, missing values are represented with a full stop `.`; for string variables, a missing value is represented with back-to-back double quotes `""`. If you have a choice, I recommend that variables containing all numbers are converted to numeric, and not kept as strings. They are easier to work with.



### String functions and regular expressions

String variables in Stata can be messy and infuriating. As they can contain literally any character, they have have text, numbers or symbols, sometimes all three. Luckily, its okay.

String functions are your friend. These are a set of inbuilt commands within Stata to enable you to systematically work with strings. Using these, you can search part of a string, do replacements, or more simple things like change a string to be all upper case. You can use these edit strings, or to make evaluations in if-statements. Often when working with strings, its helpful to change them all or upper or lowercase as `"CASE"!="case"`. 

Remember, that unless you're putting a variable name in the `str` position for these commands, it needs to be in `""`; `di` is used to print out results in the display. Test out the example code in your command line.


**Table 5. String functions and regular expressions in Stata.**

| **Command**                 | **What does it do**                      | Example                                  | Result            |
| :-------------------------- | :--------------------------------------- | :--------------------------------------- | :---------------- |
| `length(str)`               | returns number of characters in `str`    | `di length("ALEX")`                      | `4`               |
| `word(str,n)`               | returns nth word from `str` (if n<0 starts counting from right) | `di word("ALEX SAID LEARN STATA",2)`     | `SAID`            |
| `reverse(str)`              | returns `str` reversed                   | `di reverse("LEARN")`                    | `NRAEL`           |
| `trim(str)`                 | removes spaces on beginning and end of `str` | `di trim(" STATA ")`                     | `STATA`           |
| `lower(str)`                | returns `str` without lowercase letters only | `di lower("STRING")`                     | `string`          |
| `upper(str)`                | converts all letters to uppercase        | `di upper("functions")`                  | `FUNCTIONS`       |
| `proper(str)`               | capitalizes all letters not preceded by letters | `di proper("for real")`                  | `For Real`        |
| `strpos(str1,str2)`         | returns position of `str2` in `str1`     | `di strpos("STRINGS","R")`               | `3`               |
| `substr(str,n1,n2)`         | extracts characters n1 through n2 from `str`; n1<0 starts from right | `di substr("IN STATA",1,2)`<br /> `di substr("IN STATA",-5,5)` | `IN`<br />`STATA` |
| `subinstr(str,sub1,sub2,.)` | replaces all instances of `str1` with `str2` in `str` | `di subinstr("STATA","T","7")`           | `S7A7A`           |
| `regexm(str,re)`            | evaluates whether `str` matches regular expression `regex`; results in a 1/0 output meaning TRUE/FALSE | `di regexm("ARE OKAY","A")`              | `1`               |
| `regexr(str1, re, str2)`    | replaces the first substring of `str1` that matches reg. exp. `re` with `str2` | `di regexr("STATA","T","7")`             | `S7ATA`           |

Regular expression match, or `regexm`, is a powerful string tool which can be used in an evaluation as it outputs a TRUE/FALSE result as 1/0, respectively. For example, say I had a dataset where the `travel_abroad` variable was completed as an open source field, and people entering data had input: "UNK", "UNKNOWN", "unk", "unknwn" and "Unknown" when they didn't know.

```stata 
*i	this will capture all the variations that contain "unk" anywhere, ignoring case
	replace travel_abroad="Unknown" if lower(regexm(travel_abroad,"unk"))
```

Regular expressions are more powerful then regular string functions. They have added function which allow you to search if a string starts, or ends with a set of characters, or to use wildcards. <a href="https://www.stata.com/support/faqs/data-management/regular-expressions/" target="_blank">For more detail on regular expressions, and how to use *all* the wildcards, click here.</a>

```stata
	gen x=1 if regexm(forename,"^A")	// if the forename variable starts with "A"
	gen y=1 if regexm(surname,"A$")		// if the surname ends with "A"
	
*i	just say we have Steve, Stephen, Stefen, and Steven in our dataset but we want them all.
	replace forename=upper(forename)
	gen steve=1 if regexm(forename,"STE*E")
```

Note the key difference in results between regexr and subinstr. This one is important. String functions can be combined as well. Remember, order and brackets matter. Paste these into Stata to see:

```stata
	di regexr("ALEX WANTS YOU TO LEARN STATA STRING FUNCTIONS","A","4")
	di subinstr("SERIOUSLY. LEARN STATA STRING FUNCTIONS","S","5",.)

	di "`c(username)'"
	di proper("hello "+substr("`c(username)'",1,strpos("`c(username)'",".")))
```




### Generate and Replace

`gen` and`replace` are the bread and butter of data cleaning in Stata.  Sometimes we want to make a new variable (`gen`) based on the contents of another, other times we want to `replace` the contents of an existing variable. When you're cleaning data, its often better to create a new variable and then modify the new variable instead of the original one, this adds a sense check element to data cleaning. You can always `drop` the "dirty" variable later.

```stata
	help tab	// use this to list out the contents of a variable. read about option missing
	help gen
	help replace
	help drop
	
*i	example code of cleaning up a variable, coding the new variable as numeric for analysis
	tab patient_sex,m			// explore the variable contents, note values and type
	gen 	sex=0 if sex=="F"	// create a new variable instead of changing existing	
	replace sex=1 if sex=="M"	// replace the values based on criteria
	replace sex=9 if sex=="U"
	replace sex=9 if sex==""	// dont forget missing ones
	tab patient_sex sex			// check that your cleaning changes made sense
	drop patient_sex			// we dont need the "dirty" one anymore
```



### If-statements

If-statements are qualifiers for a command which allow you to selectively evaluate or change your data, `command [if], [options]`. Remember your operators, here and elsewhere, we will use logical operators AND (A AND B must be true) `&` OR (A OR B must be true) `|` and brackets `()`. These will be the basis for your if-statements. The full if-statement must be true for the command to proceed. 

For example, just say we know that unknown dates of birth were categorised as missing with age 99 or as 01/01/1900 and we wanted to recode those ages as missing.

```stata
*i	the replace commands will only affect observations where the full if-statement is true
*i	this way we don't accidently remove the age on someone who is legitimately 99
*i	without the brackets, Stata would not group the first two items of the if-statement
*	the OR would apply evaluate age==99 | dateofbirth==td(01jan1900)

	replace age=. if (dateofbirth==. & age==99) | dateofbirth==td(01jan1900)
```



> **TASK 6: investigate the dataset. are there missing or inconsistent data? if so, are these random or systematic errors? do we have variables where values are given in multiple formats? use these prompts to clean your data**

```stata
	help if
	help cond 		// a simplified if/else function used with gen or replace
```




>**TASK 7: format your dates in Stata format**

```stata
	help date
	help format
	help datetime_display_formats		// pick what you like, its personal preference.
```

Sometimes your dates may be in multiple formats, even within a single variable, eg. 2017-12-25, 25dec2017, 12/25/2017. While this is frustrating, it can be dealt with. When you create your date variables from a string, you must define the format your dates (in their string variable) are in. One way to deal with this is to redefine your Stata date variable several times, or you can format your dates during your import stage. In this exercise, the other option would have been to modify the dates before appending them; this is often easier. Here is the beauty of a do file. If you want, you can go back and change that now and re-run, or just continue.

There is no correct way that you should format display your dates. Use whatever date display format you prefer. Stata default `%td` will display dates in the format `01jan2018`. 

```stata
*i	replacing the date variables with different date formats.

	gen date=date(string_date,"YMD")
		replace date=date(string_date,"DMY") if date==.
		replace date=date(string_date,"MDY") if date==.
		format date %td_D/N/CY	// after the %td_ lets you choose how you format the date
```



### Duplicates

>**TASK 8: check for any duplicates records and remove them**

```stata
	help duplicates // read about drop, tag and force
```

Many datasets are plagued by issues of duplicate data. This is especially true of surveillance datasets, where data may be coming in from multiple sources. Depending on your dataset, and the specifics of the data being collected, this can be a relatively simple or very complex step. Often it will take you several stages to deduplicate your data. There are many ways to remove (or flag) duplicates, however the simplest way uses the `duplicates` command.

This dataset contains laboratory surveillance data. In some cases a lab may run a blood sample more than once, and therefore we may have multiple records of the same infection episode. Alternatively, a hospital could send a blood sample to more than one lab; to address this, you'll need to deduplicate based on a subset of variables within the dataset. You will need to use two different deduplication criteria (2 lines) to remove all the records.

Never change the original dataset. Seriously. Don't do it. Save your cleaned dataset as a new file. Feel free to make any and all changes to this one. Use the cleaned dataset going forwards. If you ever make a mistake, just fix and rerun your do-file.


>**TASK 9: save your cleaned dataset**





# Data management

We've cleaned the dataset. Now let's modify it so it has what we need for further analysis. During this stage, we are going to create extra variables using the existing data which will be helpful for further analysis. 

### Derived variables

Derived variables use the existing data to create new variables which summarise your results in a more meaningful way. Or they may be flag variables. A flag variable is a variable coded 0/1 which helps to tell you something about your dataset and is used for manipulation or analysis. 

For example, sometimes you don't want to drop records, but flag which ones should be omitted from analysis. So you could make a variable `_drop` in which you flag records `1` which should be omitted; you will need to ensure that you account for this in your code. Or perhaps your data contains onset and exposure dates, but you are going to be doing your analysis only on those with  <72 hour incubation time; create a flag variable for these individuals. 



>**TASK 10: create a new variable for year, using specimen_date**

```stata
	help gen
	help dates
```



>**TASK 11: calculate age in years at time of specimen**

You can perform math functions with dates in Stata. Remember, Stata stores dates as the number of days since 01jan1960. This is important, as when you subtract two dates that are on the same day, the result will be `0`. 

```stata
	help round
```



>**TASK 12: calculate age groups [<1, 1-4, 5-14, 15-29, 30-49, 50-74, 75+], label the variable values using the groups above and check the new categorical variable against the continuous one**

```stata
	help egen 	// read about [type] cut and option ic
	help label
	help tab
```



### Bysort and index numbers

`bysort` is a prefix command that groups observations, allowing you to perform functions *within* the group. It is super powerful and has many practical uses, a few of which we will cover later in this section.  First, you need to understand how it works.

```stata
*i	REMEMBER:
	bysort [varlist]: command [if], [options]
	
	help bysort
```

Within each `bysort`, each observation is temporarily assigned an index number within the group, starting with `1`. When `bysort` runs, it will start with the first observation within the group (index number `[1]`), perform the function, then move to the next observation within the group `[2]`, repeating for each observation, until the last observation `_N`. 

You can perform manipulations according to these numbers. Importantly, these numbers are not actually displayed anywhere; but you can generate a new variable to display the index number if you wish. To use index numbers, put the index number within square brackets `[]` directly after the variable, without any spaces. 



**Table 6. Overview of index numbers within `bysort`.**

| index number | which observation during the `bysort` does the index number relate to? |
| :----------- | :--------------------------------------- |
| `[1]`        | first observation                        |
| `[2]`        | second observation                       |
| `[_n]`       | current observation                      |
| `[_N]`       | last observation                         |
| `[_n+1]`     | next observation / one observation after the current |
| `[_N-2]`     | third-last observation / two observations from last |

You can also use `_n` and `_N` without the `[]`. In this case, `_n` refers to the current index number, and `_N` refers to the maximum number. They can be used in if-statement evaluations. 

```stata
*i	create a new var count which would have the total number of observations per id
*i	only label the last observation per id with the count of observations

	bysort id: gen count=_N
	bysort id (specimen_date): replace count=. if _n!=_N
	list if _n<10 & count!=. 	// shows the first 9 observations with counts

*i	in bysort the variables in the () are not included in the group, but determine sort order
*i	sorting is not mandatory, but necessary if you're working with index numbers

	bysort id (specimen_date): gen index=_n	

	bysort id (specimen_date): gen days1=specimen_date-specimen_date[1]
	bysort id (specimen_date): gen days2=specimen_date-specimen_date[_n-1]
```

**Table 7. Results after `bysort id (specimen_date)` for`count `,`index`, `days1` and `days2`.**

| id   | specimen_date | count | index | days1 | days2 |
| :--- | :------------ | :---- | :---- | :---- | :---- |
| 5448 | 29may2017     | 3     | 1     | 0     | .     |
| 5448 | 23jun2017     | 3     | 2     | 25    | 25    |
| 5448 | 27jul2017     | 3     | 3     | 59    | 34    |
| 4040 | 08jun2017     | 3     | 1     | 0     | .     |
| 4040 | 16jun2017     | 3     | 2     | 8     | 8     |
| 4040 | 04aug2017     | 3     | 3     | 57    | 49    |

Compare the results of the two `bysort` commands for `days1` and `days2`. Look at the differences between the results of these two columns. Use the results to help you interpret how the function works. Why would the first value `index==1` for both `id` be equal to `.` in `days2`? Which observation is the index number pointing at during the `bysort`?

In `days1`,  it would give you the number of days since the first observation per `id`, and in `days2`, the number of days between the observation and the one directly above it per `id`. In both examples, the data has been sorted in ascending order by `specimen_date`, with the earliest date as the first observation per `id` group. In `days2`, the first observation per group is missing because there is no previous record.



### Practical use of `bysort`
#### patientID

We can use `bysort` to group patient records. Often in a dataset, especially a surveillance dataset, some patients may have multiple records. It is important to capture these. This may be a preliminary step for further deduplication or simply to calculate a mean number of infections/person. Often a dataset will have multiple patient identifiers, but these may be incomplete.

For example, just say we had 2 variables, for forename and surname and we wanted to group these records to create a patient id, we could try the following:

```stata	
	gen id=_n 
```

**Table 8a. Results before `bysort`.**

| forename | surname   | id   |
| :------- | :-------- | :--- |
| Alex     | Batman    | 1    |
| Alex     | Batman    | 2    |
| Beth     | Smile     | 3    |
| Simon    | Darling   | 4    |
| Matt     | D'Swing   | 5    |
| Simon    | Darling   | 6    |
| Rebecca  | Humbug    | 7    |
| Kazim    | Bumblebee | 8    |
| Rebecca  | Humbug    | 9    |
| Kazim    | Bumblebee | 10   |
| Matt     | D'Swing   | 11   |
| Beth     | Smiles    | 12   |


```stata
	bysort forname surname (id): replace id=id[1]
```

**Table 8b. Comparison of results after `bysort`.**

| forename | surname   | id   |
| :------- | :-------- | :--- |
| Alex     | Batman    | 1    |
| Alex     | Batman    | 1    |
| Beth     | Smiles    | 3    |
| Beth     | Smiles    | 3    |
| Kazim    | Bumblebee | 8    |
| Kazim    | Bumblebee | 8    |
| Matt     | D'Swing   | 5    |
| Matt     | D'Swing   | 5    |
| Rebecca  | Humbug    | 7    |
| Rebecca  | Humbug    | 7    |
| Simon    | Darling   | 6    |
| Simon    | Darling   | 6    |

Compare Table 7a and 7b. Note that everyone that the `id` value was replaced with each persons lowest `id` value. This is because we sorted the grouping by `id` and replaced with the first observation in the group `[1]`. Remember, variables within the `() ` brackets are not included in the group, but determine the sort order of the observations, thus the index number.

Lets try that again, however, this time, consider what would happen if some of the values were missing, as shown in Table 8a. We can avoid inappropriate groupings by using the `if` command after our `replace`. This is a more realistic scenario, as it is rare that you will have a fully 100% complete dataset. This is also why in practice, you will often use a sequential set of parameters to group records when you have missing data.


**Table 9a. Results with missing data.**

| forename | surname   | id   |
| :------- | :-------- | :--- |
| Alex     | Batman    | 1    |
| Alex     |           | 2    |
| Beth     | Smile     | 3    |
| Simon    | Darling   | 4    |
| Matt     |           | 5    |
| Simon    | Darling   | 6    |
| Rebecca  | Humbig    | 7    |
| Kazim    | Bumblebee | 8    |
| Rebecca  | Humbug    | 9    |
|          | Bumblebee | 10   |
| Matt     |           | 11   |
| Beth     | Smiles    | 12   |


```stata
	bysort forename surname (id): replace id=id[1] if forename!="" & surname!=""
```


**Table 9b. Results after `bysort `when there is missing data.**

| forename | surname   | id   |
| :------- | :-------- | :--- |
|          | Bumblebee | 10   |
| Alex     |           | 2    |
| Alex     | Batman    | 1    |
| Beth     | Smiles    | 3    |
| Beth     | Smiles    | 3    |
| Kazim    | Bumblebee | 8    |
| Matt     |           | 5    |
| Matt     |           | 5    |
| Rebecca  | Humbig    | 7    |
| Rebecca  | Humbug    | 9    |
| Simon    | Darling   | 4    |
| Simon    | Darling   | 4    |

By adding in exclusion criteria, we can prevent incorrect matches. If we run these lines afterwards, it will capture the individuals with missing data together. Producing similar results to those in in Table 7b. However, in reality, you would rarely use a single identifier as a grouping for patient data unless the quality and reliability of that specific data is known and confirmed in your data to be very high. For example, you would never use `date_birth` and `sex` together without a third variable to further group the observations. However, just say you have a standardised national health number, this may be a strong and accurate patient identifier, but it still requires exclusion criteria! If its not clear from the data, ask someone who might know.

```stata
	bysort surname (id): 	replace id=id[1] if surname!=""
	bysort forename (id): 	replace id=id[1] if forename!=""
```



#### Combine observations

Just say a patient had two records and you wished to deduplicate and retain the first observation. If you deduplicate at this stage, you would lose the information in surname and sex, as you would only keep the first record.

Once you understand `bysort` and index numbers as how their used in this section, you can use it as an alternative method to flag duplicate records for removal. Helpfully, `bysort` combined with `[_n-1]` or `[_n+1]` will allow you to capture information from an observation before or after, respectively. This is can often be helpful before deduplicating.

**Table 10a. There is missing information in the primary record which has the outcome (cholera). Note that the index number `[_n]` value is not actually shown in Stata**

| [_n] | id   | forename | surname | sex  | specimen_date | cholera |
| :--- | :--- | :------- | :------ | :--- | :------------ | :------ |
| 1    | 3    | John     |         |      | 25dec2017     | 1       |
| 2    | 3    | John     | Snow    | Male | 25dec2017     | .       |


```stata
	bys id (specimen_date): replace surname=surname[_n+1] if surname==""
	bys id (specimen_date): replace sex=sex[_n+1] if sex==""
	bys id specimen_date: gen _drop=1 if _n!=1
```

**Table 10b. Using the `bysort` commands above replace the missing values in `[1]` with the information from the next (`[2]`)**

| _n   | id   | forename | surname | sex  | specimen_date | cholera | _drop |
| :--- | :--- | :------- | :------ | :--- | :------------ | :------ | :---- |
| 1    | 3    | John     | Snow    | Male | 25dec2017     | 1       | .     |
| 2    | 3    | John     | Snow    | Male | 25dec2017     | .       | 1     |

There were only 2 observations within this `bysort` (`_N==2`) . The code captured surname and sex from the second record `[2]` within the `bysort`, then created a new variable, which flaged all subsequent records (matched on `id` and `specimen_date`), with a flag (`_drop`) to help  deduplicate further records.



### Apply your learning!

>**TASK 13: create a patientID**

```stata
	help bysort
	help _n
	help replace
```

**HINT**: start with `gen id=_n` and look at the output. Because it was run without `bysort` what does the value represent? You'll use `bysort` and `replace` with index numbers for this part. 

You will use multiple steps; each line will be a different set of criteria that you want to `bysort` on. I suggest using different combinations of the patient identifiers. 

For this exercise, let's try four combinations. When creating a patient ID using identifiers, also think of when we would *not* want to group that record. Look at your dataset. Think about combinations of identifiers which you can use. Always consider at least two variables to be used together in the grouping, the exclusions, and always sort the data in a consistent and logical way. Depending on what variables you choose, and the order, you may get different results from your colleagues. Another reason why it's important to document everything in your do file.



>**TASK 14: using your patientID, create a new variable which contains the total number of infections per person ID and a second variable which flags the first time an individual had an infection per organism each year**

```stata
	help bysort
	help _N
```

**HINT**: you're going to want to use the `_N` for one, and an `if`-statement using `_n` for the other.




>**TASK 15: using your patientID and total infections variable, generate a new variable which tags records where the individual had a concurrent infection with more than one organism on the same specimen date**

```stata
	help duplicates // read about tag
```

How do you interpret these results? What does 0 mean, what does a number ≥1 mean? Use the `browse` command to look at the results in a line list to help you answer these questions. The `duplicates` command is not just for dropping records.



>**TASK 16: save your dataset**

At this stage you can replace your previous cleaned dataset, or you can create a new file which captures these changes. It's up to your personal preference.






# Data manipulation

Data manipulation is when you change the structure of your dataset. Depending on what your analysis requires, you may need to summarise your data, append or merge other datasets, or reshape your data. Here we will do all of these. Remember, Stata does not have an undo function, this is why we saved our base dataset, a deduplicated, cleaned line list.

In this next part, we are going to create a summary table for the number of infections, and calculate the yearly incidence rates per 100,000 population. Then we are going to export our result table to excel. These are the tables seen in the `exports\summary.xlsx` file.



### Long versus wide data: `reshape` 

This section requires that you understand data structures. What does your data table look like? How is it organised? Is it in wide or long format, and why? Recall our discussion of "tidy" data; that is long format, with each variable having a column, and each observation of that variable having a row. For example, see Table 10a. For each area and year, there is a separate observation. Wide data breaks that, and allows for multiple variables of like data per observation (Table 10b/c). 

Shape your data according to your needs. There is no "one shape fits all".  Feel free to `reshape` multiple times throughout an analysis. A structure may work for one part but may not work for another. Think about your code, and your objective. What shape is necessary for any joins or merges (more on that coming up)? What makes your life easiest (meaning the most simple code)? Am I exporting a table, what shape is best for reading the data?

```stata
	help reshape
```

In Stata, `reshape` requires an index key `i()`, and what you would like to reshape on `j()`. In the example below, starting with the long data, they key is area in the top table, and we have reshaped wide on year, and in the second they key is year, and we have reshaped wide on area. You can restructure your data multiple times. Your key cannot have missing observations. You can reshape from wide to long, or long to wide. Reshaping can be done multiple times if you dataset allows it.

**Table 11a. Long format data**

| area | year | count |
| :--- | :--- | :---- |
| A    | 2001 | 17    |
| A    | 2002 | 82    |
| A    | 2003 | 6     |
| B    | 2001 | 654   |
| B    | 2002 | 798   |
| B    | 2003 | 312   |


```stata
	reshape wide count, i(area) j(year)				
```

**Table 11b. Wide format, by year.**

| area | count2001 | count2002 | count2003 |
| :--- | :-------- | :-------- | :-------- |
| A    | 17        | 82        | 6         |
| B    | 654       | 798       | 312       |

```stata
*i	reverts the reshape back, can be used once per reshape.
	reshape long	
	
*i	string option required when its string variable
	reshape wide count, i(year) j(area) string
```



**Table 11c. Wide format, by area.**

| year | countA | countB |
| :--- | :----- | :----- |
| 2001 | 17     | 654    |
| 2002 | 798    | 82     |
| 2003 | 6      | 312    |



### Creating summary datasets: `collapse`

We are going to be joining the following dataset to our data. If you've setup your file structure and downloaded data files, run the code below. `preserve` takes a snapshot of your current data, and sends it to memory. When you use the command `restore`, it reverts back to the preserved dataset. You can only preserve one dataset to memory at a time.

```stata
	help preserve
	
	preserve
		use data\area_population, clear
		list
	restore
```

Take a look at this dataset. What have you observed? Look at the variables, observations and structure of the data. How does it compare to your current dataset?



>**TASK 17: summarise your dataset to give counts of the number of infection episodes in each area per organism per year**

```stata
	help table
	help collapse // read about sum and count
```

`table` allows you to print out tables in your Stata display, while `collapse` changes your dataset. For exploration `table` is easier but temporary; `collapse` has more functionality, and is considerably more powerful as we will see. Use the `table` command first. Compare that to the results of your `collapse`. Remember, you cannot undo a `collapse`. Make sure your dataset is saved beforehand.



>**TASK 18: summarise your dataset to give the national counts of the number of infection episodes per year**

After you `collapse` your national dataset, what have you noticed? Are all the variables from the regional table there? When we join the two tables, will there be any missing data? Can we correct that? If we need to, when do we need to make these changes and what are they for?



> **TASK 19: join the two summary tables (area level and national)**

```stata
	help append
```

Recall earlier when we were creating our dataset, we used `append`, joining data top to bottom making our dataset longer by adding observations. Here we are doing that again, but on a much smaller scale.



> **TASK 20: reshape your data in preparation to join to population data**

```stata
	help reshape

*i	to jog your memory...
	preserve
		use data\area_population, clear
		list
	restore
```

Being able to `reshape` data is an important and powerful set of skills. Data can be presented in many different formats, but they may be unsuitable for use in their original form. Compare the shape of your new summary data to the population table. They are different, and therefore will be unable to join with each other in a meaningful way. By giving both datasets a similar structure, we will be able to join them together for further analysis. Reshape one dataset to match the other.



### Joining datasets: `merge` 

`merge` is a left-right join making our dataset wider by adding variables. When we `merge`, we select a key (a variable or combination of variables) which allows both datasets to identify what we are going to join on. 

* **master** data is the base dataset currently in memory (on the left)

* **using** data is what we are bringing in (on the right) 

The advantage of merging datasets is that it allows us to enrich our data with more information. When we merge data, we're making the dataset wider, however we may also change the total number of observations within the dataset, depending on the type of merge. 

**Table 12. Merge types in Stata**

| merge type              | what does it mean                        | example                                  |
| :---------------------- | :--------------------------------------- | :--------------------------------------- |
| `1:1`<br />one-to-one   | all observations between both datasets must be unique; only one possible match from master to using | 2 patient level datasets containing no duplicates |
| `m:1`<br />many-to-one  | the using data only has 1 unique observation per key; each observation of the using data can merge onto the master multiple times | merging a death register (U) onto a surveillance dataset (M) |
| `1:m`<br />one-to-many  | the master data only has 1 unique observation per key; each observation of the using data can merge onto the master multiple times (this is the least common merge) | merging a treatment register (U) onto patient cancer registry dataset (M) |
| `m:m`<br />many-to-many | both datasets contain duplicates; all matches from both side merge (these are highly discouraged as they can result in errors, but are still sometime necessary) | merging a treatment dataset (U) onto a hospital admissions dataset (M) |



Recall we want to calculate incidence rates/100,000 population. Looking back at the population data, what key do we have available to us in both datasets? What type of merge do we want to perform? Which merge results do we want to keep, and what variables do we need from our using data?



>**TASK 21: join the population data onto your dataset**

```stata
	help merge // read about merge types and keep options
```



### Macros

Macros are Statas way of letting you use values that do not exist. In Stata, there are two types of macros, locals and globals. A local macro exists only for a short time, for example, within a loop or a chunk of code, and then disappears. Local macros are defined using `local macroname` and called up using ``macroname'` with the funny tick mark and a single quote around whatever the name of the macro is. A global macro exists from when you define it until you exit Stata. Global macros defined using `global macroname` are called using `$macroname` with a dollar sign followed by the macro name. With all macros, you set the name.

Whenever you run a command, Stata is generating hidden values storing the results as macros. Run a `sum` of your count variable from your summary table, then type `return list` in the console. This brings up a list of hidden values from the `sum` command you just ran, which have been stored as local macros. You can use these values to undertake further analysis. If you want to store the value for later use, you can redefine it as a global macro. 

```stata
	help macro 		// read this
	help levelsof
	
	sum count
	return list
```



A macro can be a string, a variable name, or a numerical value, in some cases a macro can be a list of things `help levelsof`. How you define the macro will determine the format of the value. Note the difference in how the local macro ``four'` is defined; copy/paste the example into the command lines in Stata.

```stata
	local four=2+2
		di "`four'"
	
	local four 2+2
		di "`four'"
```

In the first example, the macro contained a value for the evaluated equation, as defined using the assignment operator (`=`), for `2+2`. In the second example, the assignment operator was omitted, and was therefore not evaluated and the macro was defined as a string containing the characters `"2+2"`.



### Looping

Looping is a way of repeating code over something using macros. `foreach` loop over variables, strings, or lists. `forval` loops over numbers, these numbers can be values or as part of a variable name. Loops always follow the same general syntax. If you find yourself copy/pasting code, you should have written a loop. Once understood, loops simplify code, are more concise and are easier to maintain or make changes to.

See how the local macro has been called within the loop. Run the following loop code in your command line or do file to get an idea of the output.

```stata
	help foreach 					// looping over strings/variables/list
	help forval 					// looping over numbers, read about ranges
	
*i	_all = stata code for all variables in dataset

	foreach v of varlist _all { 
		di "looping over variable: `v'"
	}
	
	forval i=1/10 {
		di "looping over number: `i'"
	}
```
**Table 13. Understanding the parts of a loop**

| loop type | macroname | looping over      | in english                  | command                               |
| :-------- | :-------- | :---------------- | :-------------------------- | :------------------------------------ |
| `foreach` | `v`       | `of varlist _all` | each variable in dataset    | ```di "looping over variable: `v'"``` |
| `forval`  | `i`       | `=1/10`           | number 1 to 10 sequentially | ```di "looping over number: `i'"```   |


You will always define all three parts: the loop type, macroname and what you are looping over. The opening curly bracket always goes on the end of the first line `{`, and the closing bracket goes alone on the last line of the loop `}`. Whatever commands are within the curly brackets are run on every iteration of the loop. As good practice, it's very helpful to include a ```di "`macroname'"``` in loops as it makes the output easier to read. There is no limit to how big a loop can be or how many commands can be within (that I have ever encountered).



>**TASK 22: calculate annual incidence rates per 100,000 population**

```stata
	help forval
```

Don't worry about confidence intervals for this. Just calculate a simple rate. Just say your dataset had 15 years and not just 3. Depending on how your data is shaped, it's often easier to do this with a loop and it makes future changes easier to manage.



>**TASK 23: order and sort and label your variables in a logical way and export data to a new xlsx file in 3 sheets called inc_genusname**

```stata
	help order
	help sort
	help label
	help forval 		// use this for the labelling
	help levelsof 		// this creates a local macro
	help foreach 		// read about "of local" loops
	help export excel 	// read about export_excel_options
```

Ensure the table is in the shape and order you want with just the variables that you need, with the columns in the correct logical order. Just export what you need. When Stata exports data to excel, it will do is in the sorted order currently set in your viewer. For example, do you want the area_code or the area_name for a final output table? Do you want your data sorted by year or by species?

In our dataset now have a count, population and rate variable with a year after its name, eg. n2015, pop2015, rate2015. Use a `forval` loop to label these appropriately.

`export` each species to its own sheet called `"INC_genusname"`. Bonus points if you can use figure out how to use `levelsof` and a `foreach` loop to do this. Use string functions to extract the genus from the species name.

Don't forget to `save` your dataset so you can return to it later!



>**TASK 24: create a new summary table of infection episodes per year and month for each organism**

```stata
	help use
	help collapse
```

We changed our data with our last collapse, so we have to go back to our saved cleaned deduplicated dataset before we can create new summary tables.



>**TASK 25: shape your data in a format that excel would allow you to make a graph/epicurve and export the monthly counts for each of the species in 2017 to your xlsx file in a new sheet called monthly_species**

As this is surveillance data, it may be that you want to create a line graph or epicurve for comparison against other data. Using the steps above, you should be able to create summary tables and export them as necessary.



>**TASK 26: create a table which gives the agegroup:sex breakdown by sex proportions for each of the species per year. Export these to new sheets by species.**

Remember, we made a derived variable earlier which captured the first time an individual had an infection per organism per year. Let's use that to prevent overestimations due to some individuals having repeat infections.

This one requires everything we've talked about above. You'll need to `collapse`, `drop` missing data, `sort` and `reshape` your data, `generate` new derived variables and `export` subsets of your results.



>**TASK 27: compare your final results against the file in `outputs\summary.xlsx`**

Compare your final `xlsx` file to the reference file. You may have slightly different numbers based on how you did your deduplication and patientID, that's okay. Compare your methods against your colleagues or the reference file. It is important you document everything in your do file, this include extensive comments on why you have made certain decisions.

# Achievement Unlocked: Level 2 Data Wizard
Congratulations. You can completed the training and can now clean, manage and manipulate data in Stata.

To help improve this training module and for a Certificate of Completion, please take a few minutes to **[complete the evaluation/feedback for this training](https://surveys.phe.org.uk/stata_training_eval){:target="_blank"}**. 
