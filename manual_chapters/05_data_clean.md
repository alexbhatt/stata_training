# Data cleaning

### What is data cleaning

This is when you modify your data by changing the original values within the dataset. It is important to record any and all changes in the do file, to ensure that you and others can reproduce the results in the future. Always leave comments as to why changes were made. Remember, we **never** change the original dataset; we will save these changes as a new version of the dataset.

The purpose of data cleaning is to make our data as consistent as possible in preparation for analysis. This may include activities such as: formatting or recoding data, removing duplicate entries and accounting for missing data. This may also be referred to as having "tidy" data. Simply put, a clean dataset is easier to work with and a tidy dataset is easier to manage. Combined, having a a clean and tidy dataset will result in fewer mistakes in your code and therefore, your results.

In a [clean/tidy dataset](https://en.wikipedia.org/wiki/Tidy_data):

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

Regular expressions are more powerful then regular string functions. They have added function which allow you to search if a string starts, or ends with a set of characters, or to use wildcards. [For more detail on regular expressions, and how to use *all* the wildcards, click here.](https://www.stata.com/support/faqs/data-management/regular-expressions/)

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
