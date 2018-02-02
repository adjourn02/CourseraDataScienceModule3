## load libraries
library(plyr)
library(dplyr)

## 1. Merge the training and test sets to create one dataset
## load UCI HAR Dataset train data
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## load UCI HAR Dataset test data
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## 3. Use descriptive activity names to name activities in dataset
## load activity_labels.txt
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
## replace test and train activity data with its respective labels
trainmergedLabels <- join(trainActivity,activityLabels,by="V1")
trainActivityLabels <- trainmergedLabels$V2
testmergedLabels <- join(testActivity,activityLabels,by="V1")
testActivityLabels <- testmergedLabels$V2
  
## (1) continuation
## bind activity wrt corresponding test and train data
trainSetActivity <- cbind(trainActivityLabels,trainSet)
colnames(trainSetActivity)[1] <- "activity"
testSetActivity <- cbind(testActivityLabels,testSet)
colnames(testSetActivity)[1] <- "activity"
## bind subject wrt corresponding merged train and test activity&set data  
trainData <- cbind(subject=trainSubject,trainSetActivity)
colnames(trainData)[1] <- "subject"
testData <- cbind(subject=testSubject,testSetActivity)
colnames(testData)[1] <- "subject"
## bind test and train data
data <- rbind(trainData,testData)

## 2. Extract only the mean and standard deviation for each measurement
## load features.txt file to dataframe
features <- read.table("./UCI HAR Dataset/features.txt")
## get row indices where the mean and standard deviation are measured 
meanIdx <- grep("mean",features$V2)+2 ## added offset to accommodate binded subject and activity column
stdIdx <- grep("std",features$V2)+2 ## added offset to accommodate binded subject and activity column
idx <- sort(c(meanIdx,stdIdx))
## extract mean and standard deviation from the dataset in (1)
meanStd <- data[,idx]

## 4. Label dataset with descriptive variable names
## load features.txt
features <- read.table("./UCI HAR Dataset/features.txt")
## replace dataset columns wrt features
colnames(data)[3:length(data)] <- as.character(features$V2)

## 5. create a dataset with the average of each variable for each activity and subject
Data <- tbl_df(rbind(trainData,testData))
cond <- TRUE
for (i in seq_along(unique(data$subject))) {
  for (act in activityLabels$V2) {
    ## subset wrt activity and subject
    sample <- filter(Data,subject==i,activity==act)
    ## compute average for each feature
    ave <- sapply(sample[-(1:2)],mean)
    if (cond) {
      cond <- FALSE
      ## create dataframe "aveData"
      aveData <- cbind(subject=i,activity=act,data.frame(t(ave)))
    }
    else {
      ## append measurements to "aveData"
      newData <- cbind(subject=i,activity=act,data.frame(t(ave)))
      aveData <- rbind(aveData,newData)
    }
  }
}
## replace dataset columns wrt features
colnames(aveData)[3:length(aveData)] <- as.character(features$V2)
## write dataframe to text file
write.table(aveData,"AverageData.txt",row.names=FALSE)