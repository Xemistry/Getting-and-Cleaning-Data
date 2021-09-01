Features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","Functions"))
Activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Activity"))
Activities$Activity <- as.factor(Activities$Activity)

Subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = Features$Functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Code")
Subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = Features$Functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(Subject_Train, Subject_Test)
Merged_Data <- cbind(Subject, Y, X)

TidyData <- Merged_Data %>% select(Subject, Code, contains("mean"), contains("std"))

TidyData$Code <- Activities[TidyData$Code, 2]


names(TidyData)[2] = "Activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

EzData <- TidyData %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean))
write.table(FinalData, "EzData.txt", row.name=FALSE)
