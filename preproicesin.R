library(caret)
library(kernlab)
data(spam)
inTrain<-createDataPartition(y=spam$type, p=0.75, list=FALSE)
training<-spam[inTrain,]
testing<-spam[-inTrain,]
hist(training$capitalAve,main="")
###########################################
library(ISLR)
library(ggplot2)
library(caret)
data(Wage)
Wage<-subset(Wage,select = -c(logwage))
summary(Wage)
inTrain<-createDataPartition(y=Wage$wage,p=0.7,list = FALSE)
training<-Wage[inTrain,]
testing<-Wage[-inTrain,]