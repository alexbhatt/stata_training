# Stata Training: Data Cleaning, Management and Manipulation

## Intro
This is a self-directed training to teach you how to manipulate and clean data in Stata like a data wizard. Your own level of experience prior to starting will determine how long this training will take.  
For each task, you’ll be provided with the key Stata commands you'll want to use for each task. Importantly, the code/commands I've suggested are not the only way to solve each problem, just one way.  
Always remember to write lots of comments within your do file. Explain what and why you've done something.

### Before you start
This training requires Stata v12.0 or higher.

File structure on your computer is important. By having a good folder structure, you will be able to find files easier, and your code will be cleaner and easier. Also, it helps to differentiate where you data is coming from (import versus export data). For most projects, I recommend having a project directory with the following subfolders as a minimum:

| Folder | Subfolder | Contents |
| :--- | :--- | :--- |
| project directory |  | this is the main folder |
|  | \data | data files \(`.dta`, original import data `.csv` `.xlsx`\) |
|  | \exports | data you export from Stata |
|  | \code | `.do` files |


## Training materials
<a href="https://github.com/alexbhatt/stata_training/blob/master/stata_training_materials.zip?raw=true" target="_blank">Click here to download the training files project directory</a>. Unzip the contents into a project folder on your computer. 

### The dataset
These data contain simulated laboratory surveillance data of incident cases of bacterial bloodstream infections in England from 2015 to 2017. There is only one record per infection episode, however, an individual can have multiple infection episodes over time. The raw data can be found in the `\data` subfolder in the project directory (<a href="https://github.com/alexbhatt/stata_training/blob/master/stata_training_materials.zip?raw=true" target="_blank">stata_training_materials.zip</a>)

### The do file
Within the `\code` subfolder, you will find a template do file which contains some of the hints found within the manual, and all the tasks. Complete your code in this do file. 

### The answers
In the `\exports` subfolder, you will find a file called `summary.xlsx`. This contains the final result outputs. If you have completed the training correctly, your results will be similar to the ones found in the `summary.xlsx`. However, your result values may be slightly different (+/- 10%). That's okay, it will be due to how you have chosen to do a few steps. 

You do not get a copy of the code. Sorry, no copy/paste for you. This training will enable you to independently create your own multi-stage do files. 

### Evaluation and Certificate of Completion
Upon completing the course, you can download a Certificate of Completion if you complete a quick evaluation survey. The results of which will be used to improve the course. The evaluation/certificate link is found at the bottom of the training manual.

## GitBook comments
You should be viewing this training <a href="https://alexbhatt.gitbooks.io/stata-training/">via GitBook</a>. If you are, you will see a `[+]` in a box to the right of the text as you see in the image below. Clicking the `[+]` icon will toggle the comments on or off. You can start a new discussion or respond to existing comments from your colleagues. This feature can be used to ask questions, or work together to solve problems. 
To use the comments you will need to sign in or register for a free account.  ![Comments box to the right of text, click the + to toggle on/off](/assets/gitbook_comment.png)  


## Contact info
Author: Alex Bhattacharya  
Email: alex.bhattacharya@phe.gov.uk  
Updated: 22 Jan 2018  
Version: 3.0
