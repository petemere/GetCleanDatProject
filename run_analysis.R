## This script:
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each
##      measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
## 

## The current working directory is assumed to be the 'UCI HAR Dataset' 
## directory at the head of the unzipped directory tree containing the data.
setwd('C:/Users/mere_p/Desktop/PM/DS Specialisation/03 Getting Cleaning Data/ClassProject/UCI HAR Dataset')


## Set the file names and load the necessary libraries.
if(!require('data.table')){
        print("trying to install data.table")
        install.packages('data.table')
        if(!require(data.table)){
                stop("could not install data.table")
        }
}
if(!require('reshape2')){
        print("trying to install reshape2")
        install.packages('reshape2')
        if(!require(reshape2)){
                stop("could not install reshape2")
        }
}

testSetFile <- './test/X_test.txt'
testActFile <- './test/y_test.txt'
testSubjFile <- './test/subject_test.txt'

trainSetFile <- './train/X_train.txt'
trainActFile <- './train/y_train.txt'
trainSubjFile <- './train/subject_train.txt'

featuresFile <- 'features.txt'
activitiesFile <- 'activity_labels.txt'


## Read in the files, appending the activity and subject IDs on the way.
testSetData <- read.table(testSetFile, stringsAsFactors = FALSE)
testActData <- read.table(testActFile, stringsAsFactors = FALSE)
testSubjData <- read.table(testSubjFile, stringsAsFactors = FALSE)
testSetData <- cbind(testSetData, testActData, testSubjData)

trainSetData <- read.table(trainSetFile, stringsAsFactors = FALSE)
trainActData <- read.table(trainActFile, stringsAsFactors = FALSE)
trainSubjData <- read.table(trainSubjFile, stringsAsFactors = FALSE)
trainSetData <- cbind(trainSetData, trainActData, trainSubjData)

#features <- read.table(featuresFile, stringsAsFactors = FALSE)
featuresDT <- fread(featuresFile)
#activities <- read.table(activitiesFile, stringsAsFactors = FALSE)
activitiesDT <- fread(activitiesFile)


## 1. Merge the training and the test sets to create one data set.
allDataDT <- as.data.table(rbind(testSetData, trainSetData))


## 2. Extract only the mean and standard deviation for each measurement. 
# Name the variables to clarify what's going on.  (This is step 4.)
# Remove characters that will cause problems with the data.table mean()s below.
noBracketNames <- gsub(x = featuresDT$V2, pattern = ',|-|\\(|\\)', 
                       replacement = '_')
setnames(allDataDT, c(noBracketNames, 'activityID', 'subjectID'))

# Also retain the activity and subject IDs in variables 562 and 563.
allDataDT <- allDataDT[,c(featuresDT[V2 %like% 'mean\\(\\)' | 
                                     V2 %like% 'std\\(\\)']$V1, 562, 563),
                       with = FALSE]


## 3. Use descriptive activity names to name the activities in the data set
allDataDT[, activity := activitiesDT[V1 == activityID]$V2]
# Remove the activity IDs.
allDataDT[, activityID := NULL]


## 4. Appropriately label the data set with descriptive variable names. 
# This is completed in code above.


## From the data set in step 4, create a second, independent tidy data set with
## the average of each variable for each activity and each subject.
allDataMELT <- allDataDT[, sapply(.SD, mean), by = list(subjectID, activity),
          .SDcols=names(allDataDT)[1:66]]

# Cast this so that the different variables each have a column.
# First need to put the variable names in, and reorder the columns to make it 
# look like it was melted.
allDataMELT$varName <- names(allDataDT)[1:66]
setnames(allDataMELT, c('subjectID', 'activity', 'avgVal', 'varName'))
setcolorder(allDataMELT, c('subjectID', 'activity', 'varName', 'avgVal'))
allDataTidy <- dcast.data.table(allDataMELT, subjectID + activity ~ varName)



