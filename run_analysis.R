## The data for the project are in: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Once it downloaded the file is decompressed by internal directory structure

## I assume that the data set is already extracted in to the folder "UCI HAR Dataset" in the working directory


## The dplyr package is used for managing datasets
library(dplyr)

##  Read the types of activity

activity_labels <- read.table("activity_labels.txt", col.names = c("id_activity", "activity"))

## Read the features
## Are selected only those that are mean and standard deviation
## with the criterion of taking those containing in its name
## 'mean ()' or 'std ()'
features <- read.table("features.txt", col.names = c("idfeature", "feature"))
features <- filter(features, grepl("mean()", feature) | grepl("std()", feature))


## Read data from the test folder

    ## Read the subjects
    subject_test <- read.table("./test/subject_test.txt", col.names = "id_subject")

    ## Read the activities (y file)
    ## Get the 'activity descriptive names'
    y_test <- read.table("./test/y_test.txt", col.names = "id_activity")
    y_test <- left_join(y_test, activity_labels, "id_activity")

    ## Read the test data (x file)
    ## Select only the data corresponding to 'mean ()' of 'std ()'
    ## Label the data set with descriptive variable names
    x_test <- read.table("./test/X_test.txt")
    x_test <- select(x_test, features$idfeature)        
    names(x_test) <- features$feature

    ## Create global test dataset     
    data_test <- cbind(subject_test, activity = y_test$activity, x_test)


## Read data from the train folder

    ## Read the subjects
    subject_train <- read.table("./train/subject_train.txt", col.names = "id_subject")

    ## Read the activities (y file)
    ## Get the 'activity descriptive names'
    y_train <- read.table("./train/y_train.txt", col.names = "id_activity")
    y_train <- left_join(y_train, activity_labels, "id_activity")

    ## Read the test data (x file)
    ## Select only the data corresponding to 'mean ()' of 'std ()'
    ## Label the data set with descriptive variable names
    x_train <- read.table("./train/X_train.txt")
    x_train <- select(x_train, features$idfeature)        
    names(x_train) <- features$feature

    ## Create global train dataset   
    data_train <- cbind(subject_train, activity = y_train$activity, x_train)

## Create the tidy training and test dataset (merge)
data_train_test <- rbind(data_train, data_test)


## Group data for each activity and each subject
## Calculate the average of each variable (in each group)
data_train_test_group <- group_by(data_train_test, activity, id_subject)
data_train_test_avg <- summarise_each(data_train_test_group, funs(mean))

## Generate the new output file - Tidy data
## You must access it with read.table (header = TRUE)
write.table(data_train_test_avg, "data_train_test_avg.txt", row.names = FALSE)