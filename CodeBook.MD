###Getting & Cleansing Data Course Project 

Abstract: The Course Project is to create a tidy dataset from the HAR Smartphone dataset described in the link below. The specific requirements are to produce a single dataset with the mean of all variables that contain a mean or frequency for each Subject & Activity.

The description of the source data can be found here 

    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
    
##Tidy Data Set Description



Column    |    Variable Name    |    Values or Explanation
----------|---------------------|-------------------------
1|SubjectID|1 to 30
2|Activity|Laying, Sitting, Standing, Walking, Walking Downstairs, Walking Upstairs
3 thru 81	|Means|Mean of all mean or frequency variables from original data sets. See features_info.txt  for further explanation.



##R Script

The script **run_analysis.R** was used to create the tidy data set. Creating the tidy dataset required merging the train and test datasets. Each of these were actually comprised of 3 datasets whose names are in the following table.

Data|train|test
----|-----|----
Activity Codes|	Y_train	| Y_test
Subjects|	subject_train	| subject_test
Measurements & Calculations |	X_train	|X_test


##Processing Overview

Separate train and test datasets were created using **cbind** to combine the 3 separate files for each dataset.

A single dataset (notTidy) merging test and train was created with **rbind**.

Measurement and Calculation variable names were loaded from the **features.txt** file provided.

Columns containing mean or freq were selected using **grep** and all other columns were deleted.

Activity names were **merged** into the data using the **activity_labels.txt** file provided.

The tidy dataset was created using the **group_by** and **summarise_each** functions. The **summarise_each** function allows generation of the means for all of the variables with a single line of code.
