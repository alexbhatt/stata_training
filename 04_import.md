### Importing spreadsheets

Stata imports excel files [`.xls`/`.xlsx`] differently than text delimited files [`.csv`/`.txt`]. Read about the different syntax needed. Always spend a little time looking at your data, particularly when it's fragmented like this. How you look at your data will be a personal preference, however, there are several tools within Stata available to you to aid this exploration. 

When you explore your data: 
* take a look at the structure of the data. 
* what are the names of the variables 
* are they of the same type (string vs numeric) 
* sometimes it can be helpful to import your data as all string as Stata and Excel sometimes play tricks with dates.
  ​



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

