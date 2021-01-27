Context
=======

One thing that people regularly do is quantify how much of a particular
activity they do, but they rarely quantify how well they do it. In this
project, your goal will be to use data from accelerometers on the belt,
forearm, arm, and dumbell of 6 participants.

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now
possible to collect a large amount of data about personal activity
relatively inexpensively. These type of devices are part of the
quantified self movement – a group of enthusiasts who take measurements
about themselves regularly to improve their health, to find patterns in
their behavior, or because they are tech geeks. One thing that people
regularly do is quantify how much of a particular activity they do, but
they rarely quantify how well they do it. In this project, your goal
will be to use data from accelerometers on the belt, forearm, arm, and
dumbell of 6 participants. They were asked to perform barbell lifts
correctly and incorrectly in 5 different ways. More information is
available from the website here:
<a href="http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har" class="uri">http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har</a>
(see the section on the Weight Lifting Exercise Dataset). \[1\]

Analisis
========

I have loaded the data and analized it as follows:

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

So there is a data set for training and another that will be used to
fill a test in coursera, so in this paper the analysis is focused in the
training data set which I split in order to get a training and a test
data set.

    dataTrainingAndTesting$classe<-as.factor(dataTrainingAndTesting$classe)
    dataTrainingAndTesting<-dataTrainingAndTesting[,c(160,grep(pattern = "_x$|_y$|_z$",x=names(dataTrainingAndTesting)))]

    dataValidation<-dataValidation[,c(grep(pattern = "_x$|_y$|_z$",x=names(dataValidation)))]

    set.seed(3304)

    inTrain=createDataPartition(dataTrainingAndTesting$classe,p=0.7,list = FALSE)

    dataTraining<-dataTrainingAndTesting[inTrain,]
    dataTesting<-dataTrainingAndTesting[-inTrain,]

I transform the classe variable in a factor just for convenience and
split the data set also I get out some variables, my thesis is that
(after have reviewed the data set) the meaningful variables are those
that give information about the acceleration of the movement, and these
are those that finish with \_x, \_y, and \_z, so the ones that describes
acceleration on the three axis, I have run some exercises using all the
variables and I have found that my thesis is in practice true or at
least true enough to build a good model (besides it is the time factor
because some models last a lot of time in training using all the
variables).

After that I construct the models, I will use GBM, Forest and Random
Forest to compare them.

    modelForest<-train(classe~.,data = dataTraining,method="rpart")
    #modelGBM<-train(classe~.,data = dataTraining,method="gbm")
    #I got a freez using train, or it is so intensive that I though it was a freez so I used randomForest.
    modelRandomForest<-randomForest(classe~.,data=dataTraining,type="class")

I get the results for the accuracy of the models.

    predForest<-predict(modelForest,newdata=dataTesting)
    predRandomTree<-predict(modelRandomForest,newdata=dataTesting,type="class")
    #predGBM<-predict(modelGBM,newdata=dataTesting)

    matrixForest<-confusionMatrix(predForest, dataTesting$classe)
    matrixRandomForest<-confusionMatrix(predRandomTree, dataTesting$classe)
    #matrixGBM<-confusionMatrix(predGBM, dataTesting$classe)

These are the accuracies for forest:

    matrixForest

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1107  437  455  199  161
    ##          B    0    0    0    0    0
    ##          C    0    0    0    0    0
    ##          D  561  702  571  765  607
    ##          E    6    0    0    0  314
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.3715          
    ##                  95% CI : (0.3591, 0.3839)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.2011          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.6613   0.0000   0.0000   0.7936  0.29020
    ## Specificity            0.7027   1.0000   1.0000   0.5040  0.99875
    ## Pos Pred Value         0.4693      NaN      NaN   0.2386  0.98125
    ## Neg Pred Value         0.8392   0.8065   0.8257   0.9257  0.86199
    ## Prevalence             0.2845   0.1935   0.1743   0.1638  0.18386
    ## Detection Rate         0.1881   0.0000   0.0000   0.1300  0.05336
    ## Detection Prevalence   0.4008   0.0000   0.0000   0.5448  0.05438
    ## Balanced Accuracy      0.6820   0.5000   0.5000   0.6488  0.64448

Random forest:

    matrixRandomForest

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1670    8    0    1    0
    ##          B    3 1123   24    0    0
    ##          C    0    8 1002   18    3
    ##          D    0    0    0  945    7
    ##          E    1    0    0    0 1072
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9876          
    ##                  95% CI : (0.9844, 0.9903)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.9843          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.9976   0.9860   0.9766   0.9803   0.9908
    ## Specificity            0.9979   0.9943   0.9940   0.9986   0.9998
    ## Pos Pred Value         0.9946   0.9765   0.9719   0.9926   0.9991
    ## Neg Pred Value         0.9990   0.9966   0.9951   0.9961   0.9979
    ## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    ## Detection Rate         0.2838   0.1908   0.1703   0.1606   0.1822
    ## Detection Prevalence   0.2853   0.1954   0.1752   0.1618   0.1823
    ## Balanced Accuracy      0.9977   0.9901   0.9853   0.9894   0.9953

and GBM:

\[1\] Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
Qualitative Activity Recognition of Weight Lifting Exercises.
Proceedings of 4th International Conference in Cooperation with SIGCHI
(Augmented Human ’13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Read more:
<a href="http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa" class="uri">http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa</a>
