##This script is dependant on the dplyr package being installed and loaded




##Reads in all necessary files to merge

train <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainS <- read.table("train/subject_train.txt") 
test <- read.table("test/X_test.txt")
testY <- read.table("test/Y_test.txt")
testS <- read.table("test/subject_test.txt") 
feature <- read.table("features.txt", colClasses = "character")
labels <- read.table("activity_labels.txt", colClasses = "character")

##This merges the Subject data and the Activity data to both the train and test data found in X_test and x_train files
##This uses a column bind to do merge the data into 2 data frames one containing test and the other containing train data

testM <- cbind(testS, testY, test)
trainM <- cbind(trainS, trainY, train)

##Uses row bind to merge the testM and trainM data sets
##This creates a "complete" data set that is asked for in question 1

mData <- rbind(testM,trainM)

##Renames the Variables as Subject, Activity and the data found in the features.txt file
##This is what Question 4 is asking for.  I felt the values found in features.txt were descriptive enough

names(mData) [1]<- c("Subject")
names(mData) [2]<- c("Activity")
names(mData) [3:563]<- c(feature$V2)

## Extracts the the measurements on mean and std.  The grep functions returns the where the
## columns have "mean" and "std" and store those in the temp1 and temp2 variables
## I chose to filter using "mean" and "std" to incude all Varaibles that relate to them.
## I chose this over "std()" and "mean()" because I rather have the data there and be 
## able to remove it later when if needed than to not include it all.

temp1 <- grep("mean", names(mData), ignore.case= TRUE)
temp2 <- grep("std", names(mData),ignore.case= TRUE)

   

##Concatonates temp1 and temp2 to get the variables found in bothe grep functions above along with the first two columns
##fData is the data set asked for in question 2
fData <- mData[,(c(1,2,temp1,temp2))]


##This answers question 3
##Uses a for loop to go through the labels data frame and replaces each value in the fData Activity column with its corresponding text description
for (i in 1:nrow(labels)){
  fData$Activity[fData$Activity == i ] <- labels[i,2]
}    


## This answers question 5 and writes the tidyDataSet into a txt file
## Using fData this creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
summary.data <- ddply(fData, .(Subject,Activity), colwise(mean))
write.table(summary.data, file = "tidyDataSet.txt" , row.name=FALSE) 

