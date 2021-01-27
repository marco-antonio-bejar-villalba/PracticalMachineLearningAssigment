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

Analysis
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
    modelGBM<-train(classe~.,data = dataTraining,method="gbm")

    #I got a freeze using train, or it is so intensive that I though it was a freez so I used randomForest.
    modelRandomForest<-randomForest(classe~.,data=dataTraining,type="class")

I get the results for the accuracy of the models.

    predForest<-predict(modelForest,newdata=dataTesting)
    predRandomTree<-predict(modelRandomForest,newdata=dataTesting,type="class")
    predGBM<-predict(modelGBM,newdata=dataTesting)

    matrixForest<-confusionMatrix(predForest, dataTesting$classe)
    matrixRandomForest<-confusionMatrix(predRandomTree, dataTesting$classe)
    matrixGBM<-confusionMatrix(predGBM, dataTesting$classe)

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
    ##          A 1668   11    0    4    0
    ##          B    3 1121   20    0    0
    ##          C    0    7 1006   15    3
    ##          D    2    0    0  945    6
    ##          E    1    0    0    0 1073
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9878          
    ##                  95% CI : (0.9846, 0.9904)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.9845          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.9964   0.9842   0.9805   0.9803   0.9917
    ## Specificity            0.9964   0.9952   0.9949   0.9984   0.9998
    ## Pos Pred Value         0.9911   0.9799   0.9758   0.9916   0.9991
    ## Neg Pred Value         0.9986   0.9962   0.9959   0.9961   0.9981
    ## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    ## Detection Rate         0.2834   0.1905   0.1709   0.1606   0.1823
    ## Detection Prevalence   0.2860   0.1944   0.1752   0.1619   0.1825
    ## Balanced Accuracy      0.9964   0.9897   0.9877   0.9893   0.9957

and GBM:

    matrixGBM 

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1611   75   31   24    8
    ##          B   22  965   61   11   31
    ##          C   18   76  909   65   29
    ##          D   22   14   17  847   48
    ##          E    1    9    8   17  966
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9003          
    ##                  95% CI : (0.8923, 0.9078)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.8737          
    ##                                           
    ##  Mcnemar's Test P-Value : < 2.2e-16       
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.9624   0.8472   0.8860   0.8786   0.8928
    ## Specificity            0.9672   0.9737   0.9613   0.9795   0.9927
    ## Pos Pred Value         0.9211   0.8853   0.8286   0.8935   0.9650
    ## Neg Pred Value         0.9848   0.9637   0.9756   0.9763   0.9762
    ## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    ## Detection Rate         0.2737   0.1640   0.1545   0.1439   0.1641
    ## Detection Prevalence   0.2972   0.1852   0.1864   0.1611   0.1701
    ## Balanced Accuracy      0.9648   0.9104   0.9236   0.9291   0.9428

So, the best performance is with the random forest using only 36
variables.

Using this model for the data to answer the test in coursera:

    predTotRandmForest<-predict(modelRandomForest,newdata=dataValidation,type="class")
    predTotRandmForest

    ##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
    ##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
    ## Levels: A B C D E

\[1\] Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
Qualitative Activity Recognition of Weight Lifting Exercises.
Proceedings of 4th International Conference in Cooperation with SIGCHI
(Augmented Human ’13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Read more:
<a href="http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa" class="uri">http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa</a>
