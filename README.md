# Coursera Data Science - Getting and Cleaning Data Project

## Instructions for the project
This section displays the instructions for the project as provided by the course project description.

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following:

1.  Merges the training and the test sets to create one data set. 
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set. 
4.  Appropriately labels the data set with descriptive variable names. 
5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Cleaning script information
This section explains the solution `run_analysis.R` script and what actions it takes to clean up the data.

1.  Prework: check if the files/directories already exist and if not, download the data file from the assigned URL
2.  Step 1: Read in the data (X_train.txt, Y_train.txt, subject_train.txt, X_test.txt, Y_test.txt, subject_test.txt) and combine them by rows.  Assign proper variable names for *subject* and *activity* columns.
3.  Step 2: Read in the `features.txt` features table and set second column to character type.  Then grep for mean() or std() to extract just these features.  Tidy the names by capitalizing *Mean* and *Std* and removing "-" signs.  Scope the data by just mean and std features, set the column names to be the feature names, and combine all data by columns (subject + activity + mean and std feature dat).
4.  Step 3: Read in `activity_labels.txt` activity lables table and set second column to character type.  Clean up the names by removing "_" and setting to all lowercase.  Then set the activity and subject columns in the combined data set to factors.
5.  Step 4: Load library `reshape2` to help with data frame transformations.  First, melt the combined data by *subject* and *activity*.  Then, use `dcast` to cast the data into a data frame that takes the mean for each variable for each activity and subject.  Finally, write out the new tidy table `tidy.txt`.
