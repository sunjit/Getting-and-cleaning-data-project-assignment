library(reshape2)

filename <- "load_dataset.zip"
## check the working and set the working directory accordingly
WD <- getwd()
if (WD != "/Users/sudilkumar/Downloads"){
  setwd("/Users/sudilkumar/Downloads")
}

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load available activity label and  all features label to set the column name
act_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
act_Labels[,2] <- as.character(act_Labels[,2])
avl_features <- read.table("UCI HAR Dataset/features.txt")
avl_features[,2] <- as.character(avl_features[,2])

# Extract only the  mean and standard deviation column name from available feature
reqd_features <- grep(".*mean.*|.*std.*", avl_features[,2])
reqd_features.names <- avl_features[reqd_features,2]
reqd_features.names = gsub('-mean', 'Mean', reqd_features.names)
reqd_features.names = gsub('-std', 'Std', reqd_features.names)
reqd_features.names <- gsub('[-()]', '', reqd_features.names)


# Load the datasets
training_data <- read.table("UCI HAR Dataset/train/X_train.txt")[reqd_features]
trainingActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
training_data <- cbind(trainingSubjects, trainingActivities, training_data)

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")[reqd_features]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_data <- cbind(testSubjects, testActivities, test_data)

# merge datasets and add labels
completeData <- rbind(training_data, test_data)
colnames(completeData) <- c("subject", "activity", reqd_features.names)

# turn activities & subjects into factors
completeData$activity <- factor(completeData$activity, levels = act_Labels[,1], labels = act_Labels[,2])
completeData$subject <- as.factor(completeData$subject)

completeData.melted <- melt(completeData, id = c("subject", "activity"))
completeData.mean <- dcast(completeData.melted, subject + activity ~ variable, mean)

write.table(completeData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)