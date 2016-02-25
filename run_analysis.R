# Step 0: Prework
print("Step 0: check for prerequisite files")

# set global variables
zipFile <- "getdata-projectfiles-UCI HAR Dataset.zip"
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
unzippedDir <- "UCI HAR Dataset"

# check if unzipped dir exists, otherwise unzip zip file
if (!file.exists(unzippedDir)) { 
    
    # check if zip file exists, otherwise download
    if (!file.exists(zipFile)){
        download.file(zipFileUrl, zipFile)
    }  
    
    unzip(zipFile) 
}

# Step 1: Merge the training and the test sets to create one data set.

print("Step 1: read in data and combine by rows")

#read all data
trainData <- read.table(paste("./",unzippedDir,"/train/X_train.txt",sep=""))
trainLabel <- read.table(paste("./",unzippedDir,"/train/Y_train.txt",sep=""))
trainSubject <- read.table(paste("./",unzippedDir,"/train/subject_train.txt",sep=""))

testData <- read.table(paste("./",unzippedDir,"/test/X_test.txt",sep=""))
testLabel <- read.table(paste("./",unzippedDir,"/test/Y_test.txt",sep=""))
testSubject <- read.table(paste("./",unzippedDir,"/test/subject_test.txt",sep=""))

# combine data by rows
mergedData <- rbind(trainData, testData)
mergedLabel <- rbind(trainLabel, testLabel)
mergedSubject <- rbind(trainSubject, testSubject)

#set variable names of subject and activity
names(mergedSubject) <- "subject"
names(mergedLabel) <- "activity"

# Step 2: Extract only the measurements on the mean and standard deviation for 
# each measurement.

print("Step 2: extract mean and std dev measurements")

# read in features table
features <- read.table(paste("./",unzippedDir,"/features.txt",sep=""))
features[,2] <- as.character(features[,2])

# get indices where mean or std exists
extractedFeatureIndex <- grep("mean\\(\\)|std\\(\\)", features[, 2])

# clean up names by removing - and capitalizing Mean and Std
extractedFeatureNames <- features[extractedFeatureIndex, 2]
extractedFeatureNames <- gsub("-mean\\(\\)", "Mean", extractedFeatureNames)
extractedFeatureNames <- gsub("-std\\(\\)", "Std", extractedFeatureNames)
extractedFeatureNames <- gsub("-", "", extractedFeatureNames)

# scope data by just columns with mean and std
mergedData <- mergedData[, extractedFeatureIndex]

# set names to be new clean names
names(mergedData) <- extractedFeatureNames

# combine all data by columns (subject + activity + mean and std data)
combinedData <- cbind(mergedSubject, mergedLabel, mergedData)

# Step 3: Use descriptive activity names to name the activities in the data set.

print("Step 3: apply descriptive activity names to data set")

# read in activities table
activities <- read.table(paste("./",unzippedDir,"/activity_labels.txt",sep=""))
activities[,2] <- as.character(activities[,2])

# clean up activities names
activities[,2] <- gsub("_", "", activities[,2])
activities[,2] <- tolower(activities[,2])

# set activity and subject to factors in combined data frame
combinedData$activity <- factor(combinedData$activity, levels = activities[,1], labels = activities[,2])
combinedData$subject <- as.factor(combinedData$subject)

# Step 4: Appropriately label the data set with descriptive variable names.
# (already done in previous steps)

print("Step 4: appropriately label data set with descriptive variable names")

# print the names to see that they are descriptive
print(head(names(combinedData)))

# Step 5: From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

print("Step 5: create data set with average of each variable for each activity
      and subject")

# load reshape2 library
library(reshape2)

# melt combined data frame to subject and activity
meltedData <- melt(combinedData, id = c("subject", "activity"), na.rm = TRUE)

# cast melted data into data frame that does the mean for each variable for 
# each activity and subject
meanData <- dcast(meltedData, subject + activity ~ variable, mean)

# write out the new tidy table
write.table(meanData, "tidy.txt", row.names = FALSE, quote = FALSE)