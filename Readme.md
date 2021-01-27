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

\[1\] Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H.
Qualitative Activity Recognition of Weight Lifting Exercises.
Proceedings of 4th International Conference in Cooperation with SIGCHI
(Augmented Human ’13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Read more:
<a href="http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa" class="uri">http://groupware.les.inf.puc-rio.br/har#ixzz6kmFRRrJa</a>
