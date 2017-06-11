library(data.table)
library(dplyr)

##  This script does the following:
##  1.  Merges the training and the test sets to create one data set.
##  2.  Extracts only the measurements on the mean and standard deviation 
##      for each measurement
##  3.  Uses descriptive activity names to name the activities in the data set.
##  4.  Appropriately labels the data set with descriptive variable names.
##  5.  Creates a second, independent tidy data set with the average of each
##      variable for each activity and each subject.
##



## Read tables for test and train data
##       Unzip the data into a folder called "UCI HAR Dataset" within the working directory
##       The "UCI HAR Dataset" folder will then have a "test" and "train" subfolder



featureNames <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/features.txt")
activityLabels <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/activity_labels.txt", header = FALSE)

subjectTrain <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/train/X_train.txt", header = FALSE)

subjectTest <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Concatinate subjectTrain,  subjectTest
## Concatinate activityTrain, activityTest     
## Concatinate featureTrain,  featuretTest      


subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)


## Extract the column names from features file
## Set column name as Activity for activity    
## Set column name as Subject for subject
## Combine the columns and get combinedData

colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
combinedData <- cbind(features,activity,subject)


## Grep the column names required - either the Mean or Standard deviation   
## columns containing either Mean or std on the combinedData dataset
## Ignore the uppercase or lowercase differences

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(combinedData), ignore.case=TRUE)
filteredColumns <- c(columnsWithMeanSTD, 562, 563)



## Create the extracted data only for required columns  

selectColData <- combinedData[,filteredColumns]

## Convert to character data to accept Activity

selectColData$Activity <- as.character(selectColData$Activity)
for (i in 1:6){
  selectColData$Activity[selectColData$Activity == i] <- as.character(activityLabels[i,2])
}


## Convert to Factor data to accept Activity
selectColData$Activity <- as.factor(selectColData$Activity)
names(selectColData)


## Rename columns to have a better headers

names(selectColData)<-gsub("-mean()", "Mean", names(selectColData), ignore.case = TRUE)
names(selectColData)<-gsub("-std()", "STD", names(selectColData), ignore.case = TRUE)
names(selectColData)<-gsub("-freq()", "Frequency", names(selectColData), ignore.case = TRUE)
names(selectColData)<-gsub("angle", "Angle", names(selectColData))
names(selectColData)<-gsub("gravity", "Gravity", names(selectColData))
names(selectColData)<-gsub("Acc", "Accelerometer", names(selectColData))
names(selectColData)<-gsub("Gyro", "Gyroscope", names(selectColData))
names(selectColData)<-gsub("BodyBody", "Body", names(selectColData))
names(selectColData)<-gsub("Mag", "Magnitude", names(selectColData))
names(selectColData)<-gsub("^t", "Time", names(selectColData))
names(selectColData)<-gsub("^f", "Frequency", names(selectColData))
names(selectColData)<-gsub("tBody", "TimeBody", names(selectColData))


## Check selectColData names of the varaiable 

names(selectColData)

## Create factor table with Subject

selectColData$Subject <- as.factor(selectColData$Subject)
selectColData <- data.table(selectColData)

## Create Tidy table with mean from selectColData

tidyData <- aggregate(. ~Subject + Activity, selectColData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "c:/Tidy.txt", row.names = FALSE)

