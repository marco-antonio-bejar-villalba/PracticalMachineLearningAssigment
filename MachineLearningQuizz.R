library(AppliedPredictiveModeling)
library(caret)
library(rattle)

data(segmentationOriginal)
set.seed(125)
inTrain<-createDataPartition(y=segmentationOriginal$Case,p=0.7,list = FALSE)
training<-segmentationOriginal[inTrain,]
testing<-segmentationOriginal[-inTrain,]
cart<-train(Class~.,data=training,method="rpart")
fancyRpartPlot(cart$finalModel)

library(pgmm)
data(olive)
olive = olive[,-1]
oil<-train(Area~.,data=olive,method="rpart")
newdata = as.data.frame(t(colMeans(olive)))
predict(oil,newdata)

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)

chd<-train(chd~age+)