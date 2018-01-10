
# Stata basics

### Before you start

File structure on your computer is important. By having a good folder structure, you will be able to find files easier, and your code will be cleaner to read for both yourself and others. It also helps to differentiate about where you data is coming from. For most projects, I recommend having a project directory with the following subfolders as a minimum:

**Table 1. Minimum folder structure when working with data and code.**

| Folder            | Subfolder | Contents                                 |
| :---------------- | :-------- | :--------------------------------------- |
| project directory |           | this is the main folder                  |
|                   | \data     | data files (`.dta`, original import data `.csv` `.xlsx`) |
|                   | \exports  | data you export from Stata               |
|                   | \code     | `.do` files                              |



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

**Table 2. Differences between numeric and string data in Stata**

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
**Table 3. Stata command parts.**

| Stata code          | What is it for                           |
| :------------------ | :--------------------------------------- |
| `bysort [varlist]:` | You are telling the program to run the command, but grouping your data according to the listed variables |
| `command`           | This is the main command, the functions you will use in Stata; each command has a help file which tells you how to use that specific command |
| `[if]`              | These allow you to selectively run a command on a subset of data based on the evaluation of certain criteria or an expression |
| `[,options]`        | Almost every command in Stata has options, which allow you to change how to main command works, this may change the functionality, or simply just display extra information |

To run code in Stata, only the command is required, the other three parts are optional, however you will use them extensively. The help file for every Stata command will tell you exactly how to use that command, including its syntax and if it allows if-statements and what its options are.



#### Operators

Operators are the commands which you can use to evaluate expressions. Like math, an expression is a line of code which will be evaluated for a result. Remember your order of operations from math, same order applies (Brackets, Exponents, Multiplication/Division,Addition/Subtraction). But, we also have AND and OR. 

**Table 4. Operators in Stata.**

| Stata code          | Operator                                 | Example                                 | Purpose                                  |
| :------------------ | :--------------------------------------- | :-------------------------------------- | :--------------------------------------- |
| `=`                 | Assignment                               | `gen x=1`                               | only used when generating a new variable |
| `==`                | Equals to                                | `gen x=1 if 2==2`                       | assess if left side equals right side    |
| `!=`                | Not equal to                             | `gen x=1 if 2!=3`                       | assess if left side does not equal right side |
| `>=` `>` `<=` `<`   | Greater than/ <br />less than <br />(or equal to) | `gen x=1 if 2<=3`                       | as it sounds<br />only works with numbers |
| `&`                 | AND                                      | `gen x=1 if y==2 & z==3`                | to evaluate 2+ things, BOTH side of `&` must be TRUE |
| \|                | OR                                       | `gen x=1 if y==2` \| `z==2`                | to evaluate 2+ things, only ONE side of \| must be TRUE |
| `+` `-` `*` `/` `^` | Add, subtract, <br />multiply, divide, exponent | `gen x=1*3/3+2^2-4`                     | math, order is important<br />numbers only |
| `()`                | Brackets                                 | `gen x=1 if y==2` \| `(2^2==4 & a=="red")` | everything in the bracket must <br />be considered, this allows you to group expressions |

AND/OR are different from equals or not equals. These rely on TRUE/FALSE outcomes. For example, `2+2==4` and `2+2!=5` are both TRUE. Conversely, `5<4` is FALSE.

Don't worry if you don't fully understand all of this yet. You will.

