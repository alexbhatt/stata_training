# Stata Training: Data Cleaning, Management and Manipulation

## Intro

Learn how to manipulate and clean data in Stata like nobodies business.  
For each task, you’ll be provided with the key commands you'll want to use in each part.   
Importantly, the code/commands I've suggested are not the only way to solve each problem, just one way.  
Always remember to write lots of comments. Explain what and why you've done something.

## Before you start

File structure on your computer is important. By having a good folder structure, you will be able to find files easier, and your code will be cleaner to read for both yourself and others. It also helps to differentiate about where you data is coming from. For most projects, I recommend having a project directory with the following subfolders as a minimum:

| Folder            | Subfolder | Contents                                 |
| :---------------- | :-------- | :--------------------------------------- |
| project directory |           | this is the main folder                  |
|                   | \data     | data files (`.dta`, original import data `.csv` `.xlsx`) |
|                   | \exports  | data you export from Stata               |
|                   | \code     | `.do` files                              |

Download the [training files project directory](https://github.com/alexbhatt/stata_training/tree/master/stata_training) and unzip the folders into your project drive  

This training requires Stata v12.0 or higher

## The dataset

These data contain routine laboratory surveillance data of incident cases of bacterial bloodstream infections in England from 2015 to 2017.   
There is only one record per infection episode, however, an individual can have multiple infection episodes over time.  
This practice dataset does not contain any actual patient or laboratory data.

Author:     Alex Bhattacharya  
Email:      alex.bhattacharya@phe.gov.uk  
Updated:    10 Jan 2018

