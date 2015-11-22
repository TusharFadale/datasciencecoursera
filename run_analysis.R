# Getting and Cleaning Data
# Week 3 Course Project
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
## The goal is to prepare tidy data that can be used for later analysis.
## You will be graded by your peers on a series of yes/no questions related to the project.
## You will be required to submit:
##     1) a tidy data set as described below,
##     2) a link to a Github repository with your script for performing the analysis, and
##     3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
## You should also include a README.md in the repo with your scripts.
## This repo explains how all of the scripts work and how they are connected. 

## One of the most exciting areas in all of data science right now is wearable computing - see for example this article .
## Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
## The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
## A full description is available at the site where the data was obtained:
##     http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Here are the data for the project:
##     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#print(sessionInfo())

# Load data.table library
library(data.table)
library(dplyr)
library(tidyr)
library(Hmisc)

# Definition datasets
act_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
feature <- read.table("./UCI HAR Dataset/features.txt")

# Test datasets
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Train datasets
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# 1. Merges the training and the test sets to create one data set.
subject_merge <- rbind(subject_train, subject_test)
x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
l1 <- grep("mean", feature$V2)
l2 <- grep("std", feature$V2)
l3 <- c(l1,l2)

x_extract <- x_merge[,l3]

# 3. Uses descriptive activity names to name the activities in the data set
x_extract$actLabels <- act_label$V2[y_merge$V1]

# 4. Appropriately labels the data set with descriptive variable names. 

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
itd <- aggregate(x_extract, by=list(x_extract$actLabels), FUN=mean)

write.table(itd, file = "run_analysis.csv", row.names = FALSE)