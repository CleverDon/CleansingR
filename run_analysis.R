library(dplyr)

## Read in the input files
xtest <- read.table("UCI HAR Dataset/test/x_test.txt")
xtrain <- read.table("UCI HAR Dataset/train/x_train.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("id","activity"))

## parentheses are not valid in data frame column names, so
##     substituting dashes for them now and will remove all dashes
##     pulling out all dashes later
features$V2 <- gsub("\\(","--",features$V2)
features$V2 <- gsub("\\)","--",features$V2)

## Combine the subject, activity, and observation datasets then 
##    combine the test and training sets together
test <- cbind(subjecttest,ytest,xtest)
train <- cbind(subjecttrain,ytrain,xtrain)
obs <- rbind(train, test)

## Set the column names for the observations (obs)
meancol = c("subject","activityid",features$V2)
names(obs) <- tolower(meancol)

## Take out the columns exceot for the mean and std,  
##    set the subject to be a factor
##    and lookup the activity name
meanobs <- obs[,grep("(subject|activityid|mean--|std--)",meancol)]
meanobs$subject <- factor(meanobs$subject)
meanobs <- merge(meanobs,activities,by.x = "activityid", by.y = "id",all.x = TRUE)

## Clean up observations by removing all dashes and removing
##    the activity id
names(meanobs) <- gsub("-","",names(meanobs))
meanobs$activityid <- NULL

## Create the groups and summarizes the averages for activities and subjects

grp <- group_by(meanobs,activity,subject)
activityavg <- summarize_each(grp,funs(mean))

## Write the activityavg and tidydata out to files:

write.table(meanobs,"tidydata.csv")
write.table(activityavg,"tidyactivityavg.csv")
