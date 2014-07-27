## Getting  and Cleaning Data Project

This repository is hosting the documents of the project for the **Getting and Cleaning Data** course. 

The purpose of this project according to the description is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

### Data Sets

The data sets were provided in the course. The original source is:

***Human Activity Recognition Using Smartphones Data Set ***

*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

### Files in repository and purpose

The Data Sets were downloaded directly using R and stored in a local directory in the computer.


The `run_analysis.R` is the script use to produce a tidy dataset suitable for analysis. The script was produced using **R Studio Version 0.98.953 and R for Mac Version 3.1.1**.

The `CodeBook.md` describes the data sets, the variables, and the steps to obtain and clean the data and produce the script and the tidy data set. The CodeBook was produced using **MarkDrop for Mac version 1.1**. 

The `tidydata.txt` file was created using the `run_analysis.R` script and using the software mentioned above. This data set ready for analysis contain the mean and standard deviation of each measurement per subject and activity.