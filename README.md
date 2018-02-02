# CourseraDataScienceModule3
course project for module 3 of the Coursera Data Science course

## This repository includes the following files:
1. "README.md"
2. "run_analysis.R": script to produce a tidy data set with the average of each variable (mean and standard deviation) for each activity and each subject from the UCI HAR dataset
3. "codebook.pdf": describes the variables of the output text file from "run_analysis.R" 

## For each record of the output from 'run_analysis.R', it is provided:
- an identifier of the subject who carried out the experiment
- its activity label
- means of a mean&std-feature vector with time and frequency variables corresponding to its respective subject and activity

## What 'run_analysis.R' does:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
