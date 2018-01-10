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



### Joining datasets:  `merge` 

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
	help foreach 							// looping over strings/variables/list
	help forval 							// looping over numbers, read about ranges
	
*i	_all = stata code for all variables in dataset

	foreach v of varlist _all { 
		di "looping over variable: `v'"
	}
	
	forval i=1/10 {
		di "looping over number: `i'"
	}
```
** Table 13. Understanding the parts of a loop**

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
