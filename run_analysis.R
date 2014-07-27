## Script produced using R Studio Version 0.98.953
## and R for Mac Version 3.1.1

## Set the working directory

setwd("~/Documents/Coursera Project")

## Download data sets
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")

## Change working directory after download

setwd("~/Documents/Coursera Project/UCI HAR Dataset")

## Install and load necessary package
install.packages("data.table")
library(data.table)

## Load data sets from working directory
testdata <- read.table("./test/X_test.txt",sep = "", header=FALSE)
testdata_activ <- read.table("./test/y_test.txt",sep = "", header=FALSE)
testdata_subject <- read.table("./test/subject_test.txt",sep = "", header=FALSE)
traindata <- read.table("./train/X_train.txt",sep = "", header=FALSE)
traindata_activ <- read.table("./train/y_train.txt",sep = "", header=FALSE)
traindata_subject <- read.table("./train/subject_train.txt",sep = "", header=FALSE)

## Label the activities with value labels
activ_labels <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
testdata_activ$V1 <- factor(testdata_activ$V1,levels=activ_labels$V1,labels=activ_labels$V2)
traindata_activ$V1 <- factor(traindata_activ$V1,levels=activ_labels$V1,labels=activ_labels$V2)

## Label the data sets variables
feature <- read.table("./features.txt",header=FALSE,colClasses="character")
colnames(testdata)<-feature$V2
colnames(traindata)<-feature$V2
colnames(testdata_activ)<-c("Activity")
colnames(traindata_activ)<-c("Activity")
colnames(testdata_subject)<-c("Subject")
colnames(traindata_subject)<-c("Subject")

## merge training and test datasets in one
testdata<-cbind(testdata,testdata_activ)
testdata<-cbind(testdata,testdata_subject)
traindata<-cbind(traindata,traindata_activ)
traindata<-cbind(traindata,traindata_subject)
completedata<-rbind(testdata,traindata)

## Extract the measurements on the mean and standard deviation
completedata_mean<-sapply(completedata,mean,na.rm=TRUE)
completedata_sd<-sapply(completedata,sd,na.rm=TRUE)

## Create tidy data set
DT <- data.table(completedata)
tidydata<-DT[,lapply(.SD,mean),by="Subject,Activity"]
write.table(tidydata,file="tidydata.txt",sep=",",row.names = FALSE)