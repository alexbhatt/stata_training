
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
