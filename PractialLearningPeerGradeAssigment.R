library(caret)
library(randomForest)

urlPMLTraining<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
filePMLTraining<-"pml-training.csv"

urlPMLValidation<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
filePMLValidation<-"pml-validation.csv"

if(!file.exists(filePMLTraining)){
  download.file(urlPMLTraining,filePMLTraining)
}

if(!file.exists(filePMLValidation)){
  download.file(urlPMLValidation,filePMLValidation)
}


dataTrainingAndTesting<-read.csv(filePMLTraining)
dataValidation<-read.csv(filePMLValidation)

dataTrainingAndTesting$classe<-as.factor(dataTrainingAndTesting$classe)
dataTrainingAndTesting<-dataTrainingAndTesting[,c(160,grep(pattern = "_x$|_y$|_z$",x=names(dataTrainingAndTesting)))]

dataValidation<-dataValidation[,c(grep(pattern = "_x$|_y$|_z$",x=names(dataValidation)))]

set.seed(3304)

inTrain=createDataPartition(dataTrainingAndTesting$classe,p=0.7,list = FALSE)

dataTraining<-dataTrainingAndTesting[inTrain,]
dataTesting<-dataTrainingAndTesting[-inTrain,]

modelForest<-train(classe~.,data = dataTraining,method="rpart")
modelGBM<-train(classe~.,data = dataTraining,method="gbm")
modelRandomForest<-randomForest(classe~.,data=dataTraining,type="class")

predForest<-predict(modelForest,newdata=dataTesting)
predRandomTree<-predict(modelRandomForest,newdata=dataTesting,type="class")
predGBM<-predict(modelGBM,newdata=dataTesting)

matrixForest<-confusionMatrix(predForest, dataTesting$classe)
matrixRandomForest<-confusionMatrix(predRandomTree, dataTesting$classe)
matrixGBM<-confusionMatrix(predGBM, dataTesting$classe)


#dataok<-training[,c(160,grep(pattern = "_x$|_y$|_z$",x=names(training)))]

#modelTree<-train(classe~.,data = dataok,method="rpart")
#randomTree<-randomForest(classe~.,data=dataok,type="class")

#predRandomTree<-predict(randomTree,newdata=dataok[,c(-1)],type="class")

predTotRandmForest<-predict(modelRandomForest,newdata=dataValidation,type="class")




