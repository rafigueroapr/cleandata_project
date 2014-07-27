## About this CodeBook
======================================

This CodeBook describes the data sets, the variables, and the work performed to clean up the data sets and create a tidy data set.  Part of this CodeBook is from the original source: 
Human Activity Recognition Using Smartphones Data Set 

*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*


## Data Set Description:
======================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The dataset includes the following files:
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

#### Notes: 
======

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


## Work to get tidy data set

### Downloading necessary data sets

First set the working directory to download the files. Then the data was downloaded from the following Url and using the unzip function to extract the zip file to the working directory:


    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    download.file(fileurl, destfile = "Dataset.zip", method = "curl")
    unzip("Dataset.zip")


Then set the working directory again, this time to the new unzipped folder named **UCI HAR Dataset**.


### Install and load necessary package

In this case install the `data.table` package with these functions.


    install.packages("data.table”)
    library(data.table)

### Load data sets, including activities


The function `read.table` is used to load the data into R. The data do not have column names so use `header = FALSE`.

    testdata <- read.table("./test/X_test.txt",sep = "", header=FALSE)
    testdata_activ <- read.table("./test/y_test.txt",sep = "", header=FALSE)
    testdata_subject <- read.table("./test/subject_test.txt",sep = "", header=FALSE)
    traindata <- read.table("./train/X_train.txt",sep = "", header=FALSE)
    traindata_activ <- read.table("./train/y_train.txt",sep = "", header=FALSE)
    traindata_subject <- read.table("./train/subject_train.txt",sep = "", header=FALSE)




### Use the value labels to name the activities in the data set

The value labels for the activities are in the file named `activity_labels.txt`. The label of the activities will substitute the numbers in the `testdata_activ` and `traindata_activ` data frames created in the previous step.

    activ_labels <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
    testdata_activ$V1 <- factor(testdata_activ$V1,levels=activ_labels$V1,labels=activ_labels$V2)
    traindata_activ$V1 <- factor(traindata_activ$V1,levels=activ_labels$V1,labels=activ_labels$V2)

#### Label the data sets with descriptive names

Using the `features.txt`, label each of the variables in the data frames. In this step, the `Subject` and `Activity` are also labeled before merging all the data frames in a complete data set.

    feature <- read.table("./features.txt",header=FALSE,colClasses="character")
    colnames(testdata)<-feature$V2
    colnames(traindata)<-feature$V2
    colnames(testdata_activ)<-c("Activity")
    colnames(traindata_activ)<-c("Activity")
    colnames(testdata_subject)<-c("Subject")
    colnames(traindata_subject)<-c("Subject")



### Merge all the data sets into one
In this step, the training and test data is merged into a single data frame with the `Subject` and `Activity` columns appended.  The new data frame is called `completedata`.

    testdata<-cbind(testdata,testdata_activ)
    testdata<-cbind(testdata,testdata_subject)
    traindata<-cbind(traindata,traindata_activ)
    traindata<-cbind(traindata,traindata_subject)
    completedata<-rbind(testdata,traindata)

### Extract the measurements on the mean and standard deviation

To extract the mean and standard deviation use the `sapply()` function on the `compledata`. Must be used two times one with `mean` and the other with the `sd`.  Important to use the `na.rm=TRUE` argument.


    completedata_mean<-sapply(completedata,mean,na.rm=TRUE)
    completedata_sd<-sapply(completedata,sd,na.rm=TRUE)


Is possible that a warning will come up.  This is because the function will try to calculate the mean of the `Activity` variable that is not numeric.  This will not affect the rest of the calculation and should be ignored.

### Create tidy data set
The last step is the creation of the tidy data set. This step us the `data.table package` to create the tidy data set and use the `write.table` function to save the new data set as`tidydata.txt`. 


    DT <- data.table(completedata)
    tidydata<-DT[,lapply(.SD,mean),by="Subject,Activity"]
    write.table(tidydata,file="tidydata.txt",sep=",",row.names = FALSE)