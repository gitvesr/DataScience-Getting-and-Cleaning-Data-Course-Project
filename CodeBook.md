# Code Book

This document describes the code inside `run_analysis.R`.

##  This script does the following:
##Input Data Set

The input data containts the following data files:

X_train.txt contains variable features that are intended for training.
y_train.txt contains the activities corresponding to X_train.txt.
subject_train.txt contains information on the subjects from whom data is collected.
X_test.txt contains variable features that are intended for testing.
y_test.txt contains the activities corresponding to X_test.txt.
subject_test.txt contains information on the subjects from whom data is collected.
activity_labels.txt contains metadata on the different types of activities.
features.txt contains the name of the features in the data sets.

##Transformations

Following are the transformations that were performed on the input dataset:

X_train.txt is read into featuresTrain.
y_train.txt is read into activityTrain.
subject_train.txt is read into subjectTrain.
X_test.txt is read into featuresTest.
y_test.txt is read into activityTest.
subject_test.txt is read into subjectTest.
features.txt is read into featureNames.
activity_labels.txt is read into activityLabels.
The subjects in training and test set data are merged to form subject.
The activities in training and test set data are merged to form activity.
The features of test and training are merged to form features.
The name of the features are set in features from featureNames.
features, activity and subject are merged to form completeData.
Indices of columns that contain std or mean, activity and subject are taken into requiredColumns .

Acronyms in variable names in extractedData, like 'Acc', 'Gyro', 'Mag', 't' and 'f' are replaced with descriptive labels such as 'Accelerometer', 'Gyroscpoe', 'Magnitude', 'Time' and 'Frequency'.
tidyData is created as a set with average for each activity and subject of extractedData. Entries in tidyData are ordered based on activity and subject.
Finally, the data in tidyData is written into Tidy.txt.

##Output Data Set

The output data Tidy.txt is a a space-delimited value file. The header line contains the names of the variables. It contains the mean and standard deviation values of the data contained in the input files. The header is restructued in an understandable manner.


## Detailed Step by Step Description: --

## Read tables for test and train data 


Unzip the data into a folder called "UCI HAR Dataset" within the working directory "UCI HAR Dataset" to
folder will then have a "test" and "train" subfolder

    featureNames <- read.table("C:/Data Science/Data Cleaning/UCI HAR Dataset/features.txt")
    activityLabels <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/activity_labels.txt", header = FALSE)

    subjectTrain <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
    activityTrain <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/train/y_train.txt", header = FALSE)
    featuresTrain <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/train/X_train.txt", header = FALSE)

    subjectTest <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
    activityTest <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/test/y_test.txt", header = FALSE)
    featuresTest <- read.table("C:/Sridharan/Others/Data Science/Data Cleaning/UCI HAR Dataset/test/X_test.txt", header = FALSE)


## Concatinate Files
* subjectTrain,  subjectTest

* Concatinate activityTrain, activityTest 

* Concatinate featureTrain,  featuretTest

<!-- -->

    subject <- rbind(subjectTrain, subjectTest)

    activity <- rbind(activityTrain, activityTest)

    features <- rbind(featuresTrain, featuresTest)



The following function calculates the mean of the special "vector"

## Extract the column names from features file
* Set column name as Activity for activity    
* Set column name as Subject for subject
* Combine the columns and get combinedData

<!-- -->

      colnames(features) <- t(featureNames[2])
      colnames(activity) <- "Activity"
      colnames(subject) <- "Subject"
      combinedData <- cbind(features,activity,subject)



## Grep the column names required - either the Mean or Standard deviation   
* columns containing either Mean or std on the combinedData dataset
* Ignore the uppercase or lowercase differences

<!-- -->
    columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(combinedData), ignore.case=TRUE)
    filteredColumns <- c(columnsWithMeanSTD, 562, 563)


## Create the extracted data only for required columns  

<!-- -->

    selectColData <- combinedData[,filteredColumns]

## Convert to character data to accept Activity

<!-- -->
    selectColData$Activity <- as.character(selectColData$Activity)
    for (i in 1:6){
     selectColData$Activity[selectColData$Activity == i] <- as.character(activityLabels[i,2])
    }


## Convert to Factor data to accept Activity
<!-- -->

      selectColData$Activity <- as.factor(selectColData$Activity)
      names(selectColData)


## Rename columns to have a better headers

<!-- -->
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

<!-- -->

       names(selectColData)

## Create factor table with Subject
<!-- -->

      selectColData$Subject <- as.factor(selectColData$Subject)
      selectColData <- data.table(selectColData)

## Create Tidy table with mean from selectColData
* Write it to a file

<!-- -->

    tidyData <- aggregate(. ~Subject + Activity, selectColData, mean)
    tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
    write.table(tidyData, file = "c:/Tidy.txt", row.names = FALSE)

