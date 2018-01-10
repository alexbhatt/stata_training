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
