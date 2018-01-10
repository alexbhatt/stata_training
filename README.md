# Stata Training: Data Cleaning, Management and Manipulation

## Intro

This is a self-directed training to teach you how to manipulate and clean data in Stata like a data wizard. Your own level of experience prior to starting will determine how long this training will take.  
For each task, you’ll be provided with the key Stata commands you'll want to use for each task. Importantly, the code/commands I've suggested are not the only way to solve each problem, just one way.  
Always remember to write lots of comments within your do file. Explain what and why you've done something.

### Before you start

File structure on your computer is important. By having a good folder structure, you will be able to find files easier, and your code will be cleaner to read for both yourself and others. It also helps to differentiate about where you data is coming from. For most projects, I recommend having a project directory with the following subfolders as a minimum:

| Folder | Subfolder | Contents |
| :--- | :--- | :--- |
| project directory |  | this is the main folder |
|  | \data | data files \(`.dta`, original import data `.csv` `.xlsx`\) |
|  | \exports | data you export from Stata |
|  | \code | `.do` files |

Download the [training files project directory](https://github.com/alexbhatt/stata_training/blob/master/stata_training_materials.zip) and unzip the folders on your computer. 

This training requires Stata v12.0 or higher.

### The dataset

These data contain simulated routine laboratory surveillance data of incident cases of bacterial bloodstream infections in England from 2015 to 2017. There is only one record per infection episode, however, an individual can have multiple infection episodes over time.

#### Contact info

Author:     Alex Bhattacharya  
Email:       alex.bhattacharya@phe.gov.uk  
Updated:  10 Jan 2018  
Version:    3.0

