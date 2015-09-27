### Getting & Cleansing Data Course Project

### You will be required to submit:
###	1) a tidy data set as described below
###     2) a link to a Github repository with your script for performing the analysis, and 
###	3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
###	4) You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

### The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
### A full description is available at the site where the data was obtained:

### 		http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Here are the data for the project:

### 		https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### You should create one R script called run_analysis.R that does the following. 
###    1. Merges the training and the test sets to create one data set.
###    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
###    3. Uses descriptive activity names to name the activities in the data set
###    4. Appropriately labels the data set with descriptive variable names. 
###    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Housekeeping

setwd("~/RWD")


library(data.table)
library(dplyr)
library(reshape2)

### STEP 1 Merge the training and the test sets to create one data set.
###     STEPS 2 & 4 will be done concurrently during STEP 1


### The readme.txt explains which are the correct files to use.
### Basic info about the data
### There were 30 subjects and each performed 6 activities.
### 70% of the data is in the train dataset and 30% in the test dataset.

### Each dataset actually comprises 3 files as follows.
###   1. Y_....txt contains the Activity# for the data
###   2. subject_....txt contains the subject# of the data
###   3. X_.....txt contains the actual data observations

### So to merge the 2 datasets first we have to combine these 3 datasets for
### each of test and train. First do the test set.
### Note that descriptive variable names (Step 4) will be done at the same time.


### Load the subjects data and give a descriptive name

  subject_test <- read.table('./data/HAR/test/subject_test.txt')

  names(subject_test) <- "SubjectID"


### Load Activity Data and give a descriptive name

  Y_test <- read.table('./data/HAR/test/Y_test.txt')

  names(Y_test) <- c("ActivityID")


### combine Activity and Subjects using Column Bind function.

  temp <- cbind(subject_test, Y_test)


### Load the data measurements and calculations

  X_test <- read.table('./data/HAR/test/X_test.txt')    

### The column names are stored in feastures.txt. Use that to define column names

  X_names <- read.table('./data/HAR/features.txt')      

  names(X_test) <- C(X_names[,2])      


### save only columns containing mean OR std in the header name.

  cols <- grep("mean|std",X_names$V2) ### creates list of col nums to keep

  X_test <- X_test[,cols] 


### combine data with activity/subject data stored in temp

  test <- cbind(temp, X_test)

####################################

## Now repeat the same steps for the train datasets

  subject_train <- read.table('./data/HAR/train/subject_train.txt')

  names(subject_train) <- c("SubjectID")


  Y_train <- read.table('./data/HAR/train/Y_train.txt')

  names(Y_train) <- c("ActivityID")


  temp <- cbind(subject_train, Y_train)

  X_train <- read.table('./data/HAR/train/X_train.txt')

### Already have features.txt loaded into X_names so don't need to read again

  names(X_train) <- C(X_names[,2])

### also can reuse cols from before

  X_train <- X_train[,cols] ### subset data by colnums

  train <- cbind(temp, X_train)


### Now we actually have 2 datasets that can be combined
### Append the two tables together using rowbind function

  notTidy <- rbind(test,train)

### STEP 3 - Add Activiy Description 

  activity_labels <- read.table('./data/HAR/activity_labels.txt') ### read descriptions

  names(activity_labels) <- c("ActivityID", "Activity") ### Give descriptive names

  notTidy <- merge(notTidy, activity_labels, by="ActivityID")  ### Merge

### get rid of ActivityID

  notTidy$ActivityID <- NULL


### STEP 5 - Write tidy dataset with means for each Subject / Activity

### write to file so you can open it in Excel and use Pivot Table to validate 
### against the actual tidy file.

  write.csv(notTidy, file = "notTidy.csv")


### group_by sets columns to group
### summarize_each applies functions to all columns except those that are grouped.


  notTidy <- group_by(notTidy,SubjectID, Activity)

  tidy <- summarise_each(notTidy,funs(mean))

  write.table(tidy,"tidy.txt", row.name=FALSE)


### The End
