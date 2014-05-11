library(stringr)
## TASK 1: Merges the training and the test sets to create one data set.

# Read in features labels
features <- read.table(file="features.txt")
colnames(features) <- c("id", "feature")

# Read test data
yTest <- read.table(file="test/Y_test.txt")
xTest <- read.table(file="test/X_test.txt")
subjectTest <- read.table(file="test/subject_test.txt")

# Amend column names
colnames(subjectTest) <- c("Subject")
colnames(yTest) <- c("ActivityID")
colnames(xTest) <- features$feature

# Merge test tables
test <- cbind(subjectTest, yTest)
test <- cbind(test, xTest)

# Read train data
yTrain <- read.table(file="train/Y_train.txt")
xTrain <- read.table(file="train/X_train.txt")
subjectTrain <- read.table(file="train/subject_train.txt")

# Amend column names
colnames(subjectTrain) <- c("Subject")
colnames(yTrain) <- c("ActivityID")
colnames(xTrain) <- features$feature

# Merge train tables
train <- cbind(subjectTrain, yTrain)
train <- cbind(train, xTrain)

# Merge both test and train
clean <- rbind(test, train)

## TASK 2: Extracts only the measurements on the mean and standard 
## deviation for each measurement. 

# Finds relevant variables; note mean only, not meanFreq
stdevVars <- grepl("std", features$feature)
meanVars <- grepl("mean[^F]", features$feature)

extraction <- stdevVars | meanVars
extraction <- append(c(TRUE, TRUE), extraction)

cleanSmaller <- clean[,extraction]

## TASK 3. Uses descriptive activity names to name the activities in the data set

# Reads activity labels
activities <- read.table(file="activity_labels.txt")
colnames(activities) <- c("ActivityID", "ActivityDescription")

# Convert labels to lowercase, remove underscores and convert to factors
activities$ActivityDescription <- gsub("_", "", tolower(activities$ActivityDescription))
activities$ActivityDescription <- factor(tolower(activities$ActivityDescription))


# Merges with the clean data set and drops unused column
cleanNewActivity <- merge(cleanSmaller, activities, by=c("ActivityID"))
cleanNewActivity <- cleanNewActivity[, 
                                     !(colnames(cleanNewActivity) %in% c("ActivityID"))]

## TASK 4: Appropriately labels the data set with descriptive activity names

colnames(cleanNewActivity) <- gsub("-",".",colnames(cleanNewActivity))
colnames(cleanNewActivity) <- gsub("\\(","",colnames(cleanNewActivity))
colnames(cleanNewActivity) <- gsub("\\)","",colnames(cleanNewActivity))

for (colId in seq(along=colnames(cleanNewActivity))) {
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"^f","Frequency")
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"^t","Time")
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"Mag","Magnitude")
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"Acc","Acceleration")
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"mean","Mean")
  colnames(cleanNewActivity)[colId] <- str_replace(colnames(cleanNewActivity)[colId],"std","StdDev")
  
}




## TASK 5: Creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject. 

secondTidyData <- aggregate(. ~ ActivityDescription + Subject, 
                            data=cleanNewActivity, mean)
write.table(secondTidyData, "tidyData.txt", sep="\t", row.names=F)
