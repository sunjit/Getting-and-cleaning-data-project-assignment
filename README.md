# Getting-and-cleaning-data-project-assignment
Repository contains the R code to generate tidy data for week 4 project assignment getting and cleaning data course.
The R code run_analysis does following:

- set the working directory
- Download the dataset if it is not present in working diectory
- load the activity and feature info
- Loads both the training and test datasets, keeping only  columns which reflect a mean or standard deviation
- Loads the activity and subject data for each dataset, and merges those columns with the dataset
- Merges the two datasets
- Converts the activity and subject columns into factors
- Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
The end result is shown in the file tidy.txt.
