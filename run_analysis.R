library(dplyr)
library(tidyverse)

# read input files
featuresMap<-read.table("features.txt", header = FALSE)
featuresMap$V2_unique <- make.names(featuresMap$V2,unique = TRUE)
# featuresMap[featuresMap$V2 == "fBodyAcc-bandsEnergy()-1,8",] # label occurs many times
activitiesMap<-read.table("activity_labels.txt", header = FALSE)
colnames(activitiesMap) <- c("ActivityId" , "Activity")

dfTrainX<-read.table("./train/X_train.txt", header = FALSE)
dfTrainY<-read.table("./train/Y_train.txt", header=FALSE)
dfTrainX2<-read.table("./train/subject_train.txt", header=FALSE)
dfTestX<-read.table("./test/X_test.txt", header = FALSE)
dfTestY<-read.table("./test/Y_test.txt", header=FALSE)
dfTestX2<-read.table("./test/subject_test.txt", header=FALSE)

colnames(dfTrainX)<-featuresMap$V2_unique
colnames(dfTestX)<-featuresMap$V2_unique
colnames(dfTrainY)<-"ActivityId"
colnames(dfTestY)<-"ActivityId"
colnames(dfTrainX2)<-"Subject"
colnames(dfTestX2)<-"Subject"

#-----------------------------------------------------------------------
# 1. Merge the training and the test sets to create one data set. 
dfTrain <- cbind(dfTrainY, dfTrainX2, dfTrainX)
dfTest <-cbind(dfTestY, dfTestX2, dfTestX)
dfAllData <- rbind(dfTrain, dfTest)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
dfMeanStd <- dfAllData %>% select(matches("mean|std|Subject|ActivityId"))

#3. Use descriptive activity names to name the activities in the data set
df <- inner_join(activitiesMap, dfMeanStd, by = "ActivityId")
df <-select(df, -ActivityId)

# 5. From the data set in step 4 (or 3), create a second, independent tidy data set 
# with the average of each variable for each activity and each subject. 
df_output <- df %>% group_by(Subject, Activity)%>% summarise_all(mean, na.rm = TRUE)
write.table(df_output, "Output.txt", row.name=FALSE)

