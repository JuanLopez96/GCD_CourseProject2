## This R Script:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for 
## each activity and each subject.

Features <- read.table("./UCI HAR Dataset/features.txt")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=Features[,2])
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=Features[,2])
X <- rbind(XTest, XTrain)
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
Y <- rbind(YTest, YTrain)

ExtFeatures <- Features[grep("(mean|std)\\(", Features[,2]),]
MeanStd <- X[,ExtFeatures[,1]]

Labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
for (i in 1:nrow(Labels)) {
     Code <- as.numeric(Labels[i, 1])
     Name <- as.character(Labels[i, 2])
     Y[Y$activity == Code, ] <- Name
}

XWLabels <- cbind(Y, X)
MeanStdWLabels <- cbind(Y, MeanStd)

STest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
STrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
S <- rbind(STest, STrain)
TidyDataSet <- aggregate(MeanStdLabels, by = list(activity = Y[,1], subject = S[,1]), mean)
write.table(TidyDataSet, file='./tidydataset.txt', row.names=FALSE)