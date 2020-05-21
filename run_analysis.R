library(dplyr)

#READING TEST DATA

xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#READING TRAIN DATA

xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#READING ACTIVITY LABELS

actLabelData <- read.table("./UCI HAR Dataset/activity_labels.txt")

#READ FEATURES DATA

featuresData <- read.table("./UCI HAR Dataset/features.txt")

#1. MERGE TRAINING AND TEST DATA SETS

xMerge <- rbind(xTrain, xTest)
yMerge <- rbind(yTrain, yTest)
subMerge <- rbind(subjectTrain, subjectTest)

#2. EXTRACT THE DATA CONTAINING ONLY MEAN AND STANDARD DEVIATION

extractData <- featuresData[grep("mean\\(\\)|std\\(\\)", featuresData[,2]),]
xMerge <- xMerge[,extractData[,1]]


#3. NAME THE ACTIVITIES IN DATA SET USING DESCRIPTIVE NAMING

colnames(yMerge) <- "activity"
yMerge$activityLab <- factor(yMerge$activity,labels = as.character(actLabelData[,2])) 
activityLab <- yMerge[,-1]

#4. NAMING THE DATA SETS

colnames(xMerge) <- featuresData[extractData[,1],2]

#5. CREATING A TIDY DATA SET HAVING AVERAGE OF THE VALUE CALCULATED IN #4


colnames(subMerge) <- "Subject"
allData <- cbind(xMerge, activityLab, subMerge)
allDataMean <- allData %>% group_by(activityLab, Subject) %>% summarize_each(funs(mean))
write.table(allDataMean, file = "./UCI HAR Dataset/finalTidyData.txt", row.names = FALSE, col.names = TRUE)

