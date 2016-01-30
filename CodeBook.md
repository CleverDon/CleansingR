Code Book
====================================================================
The variables and files used are as follows:

xtest <- /UCI HAR Dataset/test/x_test.txt
  - This is the observations of the measurements of the variables (30% of them)

xtrain <- /UCI HAR Dataset/train/x_train.txt
  - This is the observations of the measurements of the variables (70% of them)

ytest <- /UCI HAR Dataset/test/y_test.txt
  - This is the activity that was being done during each observation (1 to 1 correlation to observation for the test ones - 30% of data)

ytrain <- /UCI HAR Dataset/train/y_train.txt
  - This is the activity that was being done during each observation (1 to 1 correlation to observation for the train ones - 70% of data)

subjecttest <- /UCI HAR Dataset/test/subject_test.txt
  - This is the subject for each observation (1 to 1 correlation to observation for the test ones - 30% of data)

subjecttrain <- /UCI HAR Dataset/train/subject_train.txt
  - This is the subject for each observation (1 to 1 correlation to observation for the train ones - 70% of data)

features <- /UCI HAR Dataset/features.txt
  - This is the names of the features or variables that are the measurements

activities <- /UCI HAR Dataset/activity_labels.txt
  - This is the names of the activities that is a lookup for the names
  
===============================================================  
The other variables and transformations are:

### 1.  First we replace the parentheses with dahses in the feature text. Parentheses are invalid as a column name, so it will have dashes for now.  The dashes make it so we can distinguish between mean and meanFrew later for removal.

-- parentheses are not valid in data frame column names, so
--     substituting dashes for them now and will remove all dashes
--     pulling out all dashes later
features$V2 <- gsub("\\(","--",features$V2)
features$V2 <- gsub("\\)","--",features$V2)

### 2.  Next we have to join all these files together.  so we put the subject and activity data as two columns on the left side.  The we append the test and training sets together to make one dataset (observations).

-- Combine the subject, activity, and observation datasets then 
--    combine the test and training sets together
test <- cbind(subjecttest,ytest,xtest)
train <- cbind(subjecttrain,ytrain,xtrain)
obs <- rbind(train, test)

### 3.  Next we set the column names for the observations

-- Set the column names for the observations (obs)
meancol = c("subject","activityid",features$V2)
names(obs) <- tolower(meancol)

### 4.  Then we keep only the columns with mean and std.  We make the subjects a factor, because the were numeric.  And we join the activities file to the observations, so we get the names.

-- Take out the columns exceot for the mean and std,  
--    set the subject to be a factor
--    and lookup the activity name
meanobs <- obs[,grep("(subject|activityid|mean--|std--)",meancol)]
meanobs$subject <- factor(meanobs$subject)
meanobs <- merge(meanobs,activities,by.x = "activityid", by.y = "id",all.x = TRUE)

### 5.  Then we just do some final cleanup on the observation tidy data.  We drop the column with the activity id numbers, since we now have the names.  We also remove the dashes from the column names so they are all just lower case letters and numbers. 

-- Clean up observations by removing all dashes and removing
--    the activity id
names(meanobs) <- gsub("-","",names(meanobs))
meanobs$activityid <- NULL

### 6.  We create the grouping for the average requirement.  Then summarize it in order to calculate the mean.

-- Create the groups and summarizes the averages for activities and subjects
grp <- group_by(meanobs,activity,subject)
activityavg <- summarize_each(grp,funs(mean))

### 7.  Write the two datasets to a file

-- Write the activityavg and tidydata out to files:
write.table(meanobs,"tidydata.csv")
write.table(activityavg,"tidyactivityavg.csv")

===================================================================
The information about the data is contained here from the previous codebook:

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

