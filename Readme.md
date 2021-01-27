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
    modelGBM<-train(classe~.,data = dataTraining,method="gbm")

    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0974
    ##      2        1.5463             nan     0.1000    0.0703
    ##      3        1.5020             nan     0.1000    0.0564
    ##      4        1.4654             nan     0.1000    0.0469
    ##      5        1.4361             nan     0.1000    0.0369
    ##      6        1.4109             nan     0.1000    0.0376
    ##      7        1.3865             nan     0.1000    0.0322
    ##      8        1.3651             nan     0.1000    0.0334
    ##      9        1.3440             nan     0.1000    0.0281
    ##     10        1.3263             nan     0.1000    0.0270
    ##     20        1.1899             nan     0.1000    0.0144
    ##     40        1.0305             nan     0.1000    0.0095
    ##     60        0.9284             nan     0.1000    0.0073
    ##     80        0.8545             nan     0.1000    0.0059
    ##    100        0.7962             nan     0.1000    0.0037
    ##    120        0.7462             nan     0.1000    0.0025
    ##    140        0.7054             nan     0.1000    0.0022
    ##    150        0.6873             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1441
    ##      2        1.5156             nan     0.1000    0.1106
    ##      3        1.4449             nan     0.1000    0.0870
    ##      4        1.3882             nan     0.1000    0.0802
    ##      5        1.3385             nan     0.1000    0.0618
    ##      6        1.2986             nan     0.1000    0.0578
    ##      7        1.2628             nan     0.1000    0.0487
    ##      8        1.2323             nan     0.1000    0.0428
    ##      9        1.2043             nan     0.1000    0.0409
    ##     10        1.1783             nan     0.1000    0.0407
    ##     20        1.0003             nan     0.1000    0.0193
    ##     40        0.8015             nan     0.1000    0.0112
    ##     60        0.6793             nan     0.1000    0.0072
    ##     80        0.5925             nan     0.1000    0.0039
    ##    100        0.5330             nan     0.1000    0.0030
    ##    120        0.4813             nan     0.1000    0.0029
    ##    140        0.4384             nan     0.1000    0.0027
    ##    150        0.4201             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1895
    ##      2        1.4896             nan     0.1000    0.1354
    ##      3        1.4058             nan     0.1000    0.1080
    ##      4        1.3396             nan     0.1000    0.0869
    ##      5        1.2855             nan     0.1000    0.0855
    ##      6        1.2312             nan     0.1000    0.0632
    ##      7        1.1901             nan     0.1000    0.0566
    ##      8        1.1531             nan     0.1000    0.0560
    ##      9        1.1167             nan     0.1000    0.0515
    ##     10        1.0841             nan     0.1000    0.0416
    ##     20        0.8740             nan     0.1000    0.0234
    ##     40        0.6587             nan     0.1000    0.0096
    ##     60        0.5423             nan     0.1000    0.0071
    ##     80        0.4598             nan     0.1000    0.0052
    ##    100        0.3953             nan     0.1000    0.0028
    ##    120        0.3484             nan     0.1000    0.0037
    ##    140        0.3099             nan     0.1000    0.0020
    ##    150        0.2931             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0936
    ##      2        1.5502             nan     0.1000    0.0667
    ##      3        1.5081             nan     0.1000    0.0551
    ##      4        1.4725             nan     0.1000    0.0455
    ##      5        1.4424             nan     0.1000    0.0396
    ##      6        1.4162             nan     0.1000    0.0383
    ##      7        1.3908             nan     0.1000    0.0329
    ##      8        1.3697             nan     0.1000    0.0332
    ##      9        1.3493             nan     0.1000    0.0286
    ##     10        1.3310             nan     0.1000    0.0237
    ##     20        1.1966             nan     0.1000    0.0147
    ##     40        1.0368             nan     0.1000    0.0102
    ##     60        0.9358             nan     0.1000    0.0069
    ##     80        0.8607             nan     0.1000    0.0040
    ##    100        0.8013             nan     0.1000    0.0029
    ##    120        0.7528             nan     0.1000    0.0018
    ##    140        0.7129             nan     0.1000    0.0020
    ##    150        0.6944             nan     0.1000    0.0012
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1391
    ##      2        1.5201             nan     0.1000    0.1059
    ##      3        1.4517             nan     0.1000    0.0890
    ##      4        1.3958             nan     0.1000    0.0786
    ##      5        1.3473             nan     0.1000    0.0645
    ##      6        1.3069             nan     0.1000    0.0576
    ##      7        1.2712             nan     0.1000    0.0448
    ##      8        1.2416             nan     0.1000    0.0476
    ##      9        1.2125             nan     0.1000    0.0384
    ##     10        1.1878             nan     0.1000    0.0433
    ##     20        1.0023             nan     0.1000    0.0195
    ##     40        0.8078             nan     0.1000    0.0076
    ##     60        0.6857             nan     0.1000    0.0059
    ##     80        0.6030             nan     0.1000    0.0043
    ##    100        0.5388             nan     0.1000    0.0033
    ##    120        0.4873             nan     0.1000    0.0034
    ##    140        0.4440             nan     0.1000    0.0025
    ##    150        0.4253             nan     0.1000    0.0013
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1805
    ##      2        1.4947             nan     0.1000    0.1333
    ##      3        1.4104             nan     0.1000    0.1044
    ##      4        1.3447             nan     0.1000    0.0937
    ##      5        1.2869             nan     0.1000    0.0866
    ##      6        1.2338             nan     0.1000    0.0669
    ##      7        1.1908             nan     0.1000    0.0666
    ##      8        1.1500             nan     0.1000    0.0518
    ##      9        1.1181             nan     0.1000    0.0515
    ##     10        1.0869             nan     0.1000    0.0452
    ##     20        0.8787             nan     0.1000    0.0207
    ##     40        0.6624             nan     0.1000    0.0079
    ##     60        0.5463             nan     0.1000    0.0069
    ##     80        0.4625             nan     0.1000    0.0039
    ##    100        0.4019             nan     0.1000    0.0038
    ##    120        0.3539             nan     0.1000    0.0020
    ##    140        0.3139             nan     0.1000    0.0015
    ##    150        0.2966             nan     0.1000    0.0009
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0906
    ##      2        1.5494             nan     0.1000    0.0672
    ##      3        1.5058             nan     0.1000    0.0508
    ##      4        1.4739             nan     0.1000    0.0477
    ##      5        1.4440             nan     0.1000    0.0434
    ##      6        1.4165             nan     0.1000    0.0393
    ##      7        1.3903             nan     0.1000    0.0338
    ##      8        1.3681             nan     0.1000    0.0273
    ##      9        1.3493             nan     0.1000    0.0300
    ##     10        1.3308             nan     0.1000    0.0277
    ##     20        1.1982             nan     0.1000    0.0130
    ##     40        1.0405             nan     0.1000    0.0088
    ##     60        0.9405             nan     0.1000    0.0072
    ##     80        0.8651             nan     0.1000    0.0051
    ##    100        0.8058             nan     0.1000    0.0035
    ##    120        0.7604             nan     0.1000    0.0025
    ##    140        0.7196             nan     0.1000    0.0018
    ##    150        0.7019             nan     0.1000    0.0029
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1413
    ##      2        1.5181             nan     0.1000    0.1088
    ##      3        1.4489             nan     0.1000    0.0880
    ##      4        1.3941             nan     0.1000    0.0769
    ##      5        1.3471             nan     0.1000    0.0677
    ##      6        1.3046             nan     0.1000    0.0601
    ##      7        1.2664             nan     0.1000    0.0483
    ##      8        1.2358             nan     0.1000    0.0469
    ##      9        1.2071             nan     0.1000    0.0389
    ##     10        1.1827             nan     0.1000    0.0377
    ##     20        1.0068             nan     0.1000    0.0211
    ##     40        0.8129             nan     0.1000    0.0096
    ##     60        0.6914             nan     0.1000    0.0083
    ##     80        0.6075             nan     0.1000    0.0037
    ##    100        0.5426             nan     0.1000    0.0036
    ##    120        0.4915             nan     0.1000    0.0021
    ##    140        0.4502             nan     0.1000    0.0017
    ##    150        0.4313             nan     0.1000    0.0033
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1791
    ##      2        1.4927             nan     0.1000    0.1338
    ##      3        1.4075             nan     0.1000    0.1059
    ##      4        1.3401             nan     0.1000    0.0915
    ##      5        1.2817             nan     0.1000    0.0841
    ##      6        1.2294             nan     0.1000    0.0642
    ##      7        1.1889             nan     0.1000    0.0639
    ##      8        1.1485             nan     0.1000    0.0560
    ##      9        1.1139             nan     0.1000    0.0421
    ##     10        1.0863             nan     0.1000    0.0400
    ##     20        0.8780             nan     0.1000    0.0171
    ##     40        0.6661             nan     0.1000    0.0123
    ##     60        0.5450             nan     0.1000    0.0056
    ##     80        0.4644             nan     0.1000    0.0027
    ##    100        0.4083             nan     0.1000    0.0042
    ##    120        0.3609             nan     0.1000    0.0030
    ##    140        0.3229             nan     0.1000    0.0015
    ##    150        0.3053             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0909
    ##      2        1.5493             nan     0.1000    0.0671
    ##      3        1.5056             nan     0.1000    0.0552
    ##      4        1.4706             nan     0.1000    0.0463
    ##      5        1.4409             nan     0.1000    0.0390
    ##      6        1.4155             nan     0.1000    0.0338
    ##      7        1.3943             nan     0.1000    0.0369
    ##      8        1.3706             nan     0.1000    0.0309
    ##      9        1.3507             nan     0.1000    0.0291
    ##     10        1.3323             nan     0.1000    0.0254
    ##     20        1.1985             nan     0.1000    0.0154
    ##     40        1.0410             nan     0.1000    0.0110
    ##     60        0.9402             nan     0.1000    0.0043
    ##     80        0.8670             nan     0.1000    0.0060
    ##    100        0.8069             nan     0.1000    0.0030
    ##    120        0.7588             nan     0.1000    0.0028
    ##    140        0.7177             nan     0.1000    0.0024
    ##    150        0.7001             nan     0.1000    0.0024
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1488
    ##      2        1.5171             nan     0.1000    0.1065
    ##      3        1.4505             nan     0.1000    0.0838
    ##      4        1.3975             nan     0.1000    0.0707
    ##      5        1.3511             nan     0.1000    0.0715
    ##      6        1.3071             nan     0.1000    0.0542
    ##      7        1.2720             nan     0.1000    0.0470
    ##      8        1.2430             nan     0.1000    0.0458
    ##      9        1.2148             nan     0.1000    0.0407
    ##     10        1.1888             nan     0.1000    0.0385
    ##     20        1.0024             nan     0.1000    0.0197
    ##     40        0.8096             nan     0.1000    0.0098
    ##     60        0.6828             nan     0.1000    0.0072
    ##     80        0.6001             nan     0.1000    0.0049
    ##    100        0.5403             nan     0.1000    0.0033
    ##    120        0.4884             nan     0.1000    0.0026
    ##    140        0.4454             nan     0.1000    0.0022
    ##    150        0.4268             nan     0.1000    0.0022
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1807
    ##      2        1.4933             nan     0.1000    0.1362
    ##      3        1.4092             nan     0.1000    0.1036
    ##      4        1.3437             nan     0.1000    0.0856
    ##      5        1.2911             nan     0.1000    0.0877
    ##      6        1.2370             nan     0.1000    0.0690
    ##      7        1.1930             nan     0.1000    0.0635
    ##      8        1.1527             nan     0.1000    0.0540
    ##      9        1.1193             nan     0.1000    0.0550
    ##     10        1.0849             nan     0.1000    0.0424
    ##     20        0.8721             nan     0.1000    0.0221
    ##     40        0.6589             nan     0.1000    0.0118
    ##     60        0.5410             nan     0.1000    0.0066
    ##     80        0.4612             nan     0.1000    0.0052
    ##    100        0.4005             nan     0.1000    0.0024
    ##    120        0.3547             nan     0.1000    0.0021
    ##    140        0.3155             nan     0.1000    0.0020
    ##    150        0.2968             nan     0.1000    0.0015
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0906
    ##      2        1.5493             nan     0.1000    0.0692
    ##      3        1.5057             nan     0.1000    0.0563
    ##      4        1.4700             nan     0.1000    0.0423
    ##      5        1.4417             nan     0.1000    0.0463
    ##      6        1.4114             nan     0.1000    0.0337
    ##      7        1.3890             nan     0.1000    0.0345
    ##      8        1.3668             nan     0.1000    0.0299
    ##      9        1.3472             nan     0.1000    0.0308
    ##     10        1.3276             nan     0.1000    0.0297
    ##     20        1.1893             nan     0.1000    0.0163
    ##     40        1.0291             nan     0.1000    0.0078
    ##     60        0.9286             nan     0.1000    0.0056
    ##     80        0.8544             nan     0.1000    0.0037
    ##    100        0.7950             nan     0.1000    0.0028
    ##    120        0.7476             nan     0.1000    0.0030
    ##    140        0.7063             nan     0.1000    0.0021
    ##    150        0.6882             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1439
    ##      2        1.5178             nan     0.1000    0.1120
    ##      3        1.4494             nan     0.1000    0.0910
    ##      4        1.3927             nan     0.1000    0.0731
    ##      5        1.3456             nan     0.1000    0.0628
    ##      6        1.3053             nan     0.1000    0.0627
    ##      7        1.2666             nan     0.1000    0.0510
    ##      8        1.2335             nan     0.1000    0.0449
    ##      9        1.2055             nan     0.1000    0.0377
    ##     10        1.1809             nan     0.1000    0.0391
    ##     20        0.9956             nan     0.1000    0.0197
    ##     40        0.7954             nan     0.1000    0.0109
    ##     60        0.6766             nan     0.1000    0.0053
    ##     80        0.5924             nan     0.1000    0.0056
    ##    100        0.5288             nan     0.1000    0.0036
    ##    120        0.4783             nan     0.1000    0.0026
    ##    140        0.4367             nan     0.1000    0.0009
    ##    150        0.4208             nan     0.1000    0.0020
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1886
    ##      2        1.4903             nan     0.1000    0.1434
    ##      3        1.4001             nan     0.1000    0.1078
    ##      4        1.3327             nan     0.1000    0.0842
    ##      5        1.2799             nan     0.1000    0.0734
    ##      6        1.2321             nan     0.1000    0.0783
    ##      7        1.1843             nan     0.1000    0.0552
    ##      8        1.1487             nan     0.1000    0.0545
    ##      9        1.1140             nan     0.1000    0.0443
    ##     10        1.0850             nan     0.1000    0.0433
    ##     20        0.8767             nan     0.1000    0.0216
    ##     40        0.6551             nan     0.1000    0.0093
    ##     60        0.5397             nan     0.1000    0.0068
    ##     80        0.4578             nan     0.1000    0.0047
    ##    100        0.3993             nan     0.1000    0.0034
    ##    120        0.3511             nan     0.1000    0.0017
    ##    140        0.3129             nan     0.1000    0.0016
    ##    150        0.2972             nan     0.1000    0.0008
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0899
    ##      2        1.5505             nan     0.1000    0.0686
    ##      3        1.5066             nan     0.1000    0.0516
    ##      4        1.4735             nan     0.1000    0.0427
    ##      5        1.4448             nan     0.1000    0.0425
    ##      6        1.4186             nan     0.1000    0.0347
    ##      7        1.3947             nan     0.1000    0.0321
    ##      8        1.3737             nan     0.1000    0.0337
    ##      9        1.3521             nan     0.1000    0.0264
    ##     10        1.3341             nan     0.1000    0.0253
    ##     20        1.1996             nan     0.1000    0.0146
    ##     40        1.0440             nan     0.1000    0.0078
    ##     60        0.9418             nan     0.1000    0.0051
    ##     80        0.8681             nan     0.1000    0.0035
    ##    100        0.8102             nan     0.1000    0.0030
    ##    120        0.7632             nan     0.1000    0.0026
    ##    140        0.7194             nan     0.1000    0.0027
    ##    150        0.7005             nan     0.1000    0.0018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1423
    ##      2        1.5188             nan     0.1000    0.1027
    ##      3        1.4540             nan     0.1000    0.0885
    ##      4        1.3990             nan     0.1000    0.0732
    ##      5        1.3537             nan     0.1000    0.0666
    ##      6        1.3123             nan     0.1000    0.0536
    ##      7        1.2776             nan     0.1000    0.0479
    ##      8        1.2466             nan     0.1000    0.0442
    ##      9        1.2193             nan     0.1000    0.0373
    ##     10        1.1956             nan     0.1000    0.0385
    ##     20        1.0147             nan     0.1000    0.0246
    ##     40        0.8158             nan     0.1000    0.0105
    ##     60        0.6949             nan     0.1000    0.0085
    ##     80        0.6079             nan     0.1000    0.0031
    ##    100        0.5445             nan     0.1000    0.0040
    ##    120        0.4929             nan     0.1000    0.0031
    ##    140        0.4476             nan     0.1000    0.0025
    ##    150        0.4291             nan     0.1000    0.0027
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1856
    ##      2        1.4925             nan     0.1000    0.1331
    ##      3        1.4086             nan     0.1000    0.0979
    ##      4        1.3463             nan     0.1000    0.0887
    ##      5        1.2932             nan     0.1000    0.0832
    ##      6        1.2423             nan     0.1000    0.0600
    ##      7        1.2033             nan     0.1000    0.0656
    ##      8        1.1619             nan     0.1000    0.0467
    ##      9        1.1312             nan     0.1000    0.0524
    ##     10        1.0983             nan     0.1000    0.0446
    ##     20        0.8858             nan     0.1000    0.0244
    ##     40        0.6642             nan     0.1000    0.0122
    ##     60        0.5467             nan     0.1000    0.0079
    ##     80        0.4652             nan     0.1000    0.0047
    ##    100        0.4043             nan     0.1000    0.0029
    ##    120        0.3532             nan     0.1000    0.0017
    ##    140        0.3121             nan     0.1000    0.0022
    ##    150        0.2944             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0894
    ##      2        1.5516             nan     0.1000    0.0671
    ##      3        1.5077             nan     0.1000    0.0542
    ##      4        1.4732             nan     0.1000    0.0407
    ##      5        1.4466             nan     0.1000    0.0434
    ##      6        1.4190             nan     0.1000    0.0386
    ##      7        1.3931             nan     0.1000    0.0303
    ##      8        1.3730             nan     0.1000    0.0325
    ##      9        1.3524             nan     0.1000    0.0270
    ##     10        1.3346             nan     0.1000    0.0268
    ##     20        1.2055             nan     0.1000    0.0146
    ##     40        1.0448             nan     0.1000    0.0090
    ##     60        0.9425             nan     0.1000    0.0050
    ##     80        0.8668             nan     0.1000    0.0045
    ##    100        0.8070             nan     0.1000    0.0038
    ##    120        0.7597             nan     0.1000    0.0029
    ##    140        0.7185             nan     0.1000    0.0026
    ##    150        0.7001             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1443
    ##      2        1.5179             nan     0.1000    0.1036
    ##      3        1.4514             nan     0.1000    0.0829
    ##      4        1.4001             nan     0.1000    0.0723
    ##      5        1.3535             nan     0.1000    0.0650
    ##      6        1.3127             nan     0.1000    0.0616
    ##      7        1.2752             nan     0.1000    0.0471
    ##      8        1.2454             nan     0.1000    0.0461
    ##      9        1.2169             nan     0.1000    0.0452
    ##     10        1.1889             nan     0.1000    0.0338
    ##     20        1.0089             nan     0.1000    0.0209
    ##     40        0.8089             nan     0.1000    0.0103
    ##     60        0.6889             nan     0.1000    0.0060
    ##     80        0.6066             nan     0.1000    0.0049
    ##    100        0.5411             nan     0.1000    0.0031
    ##    120        0.4905             nan     0.1000    0.0025
    ##    140        0.4470             nan     0.1000    0.0016
    ##    150        0.4280             nan     0.1000    0.0037
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1859
    ##      2        1.4933             nan     0.1000    0.1284
    ##      3        1.4121             nan     0.1000    0.1090
    ##      4        1.3441             nan     0.1000    0.0895
    ##      5        1.2884             nan     0.1000    0.0808
    ##      6        1.2374             nan     0.1000    0.0651
    ##      7        1.1959             nan     0.1000    0.0590
    ##      8        1.1578             nan     0.1000    0.0532
    ##      9        1.1242             nan     0.1000    0.0461
    ##     10        1.0943             nan     0.1000    0.0435
    ##     20        0.8822             nan     0.1000    0.0208
    ##     40        0.6652             nan     0.1000    0.0092
    ##     60        0.5454             nan     0.1000    0.0057
    ##     80        0.4630             nan     0.1000    0.0032
    ##    100        0.4019             nan     0.1000    0.0035
    ##    120        0.3569             nan     0.1000    0.0026
    ##    140        0.3178             nan     0.1000    0.0012
    ##    150        0.2994             nan     0.1000    0.0014
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0929
    ##      2        1.5489             nan     0.1000    0.0708
    ##      3        1.5029             nan     0.1000    0.0540
    ##      4        1.4686             nan     0.1000    0.0451
    ##      5        1.4400             nan     0.1000    0.0373
    ##      6        1.4151             nan     0.1000    0.0363
    ##      7        1.3923             nan     0.1000    0.0349
    ##      8        1.3692             nan     0.1000    0.0299
    ##      9        1.3498             nan     0.1000    0.0270
    ##     10        1.3320             nan     0.1000    0.0276
    ##     20        1.2004             nan     0.1000    0.0141
    ##     40        1.0448             nan     0.1000    0.0096
    ##     60        0.9440             nan     0.1000    0.0075
    ##     80        0.8684             nan     0.1000    0.0048
    ##    100        0.8108             nan     0.1000    0.0037
    ##    120        0.7631             nan     0.1000    0.0023
    ##    140        0.7224             nan     0.1000    0.0024
    ##    150        0.7036             nan     0.1000    0.0016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1422
    ##      2        1.5186             nan     0.1000    0.1044
    ##      3        1.4530             nan     0.1000    0.0883
    ##      4        1.3970             nan     0.1000    0.0740
    ##      5        1.3500             nan     0.1000    0.0726
    ##      6        1.3049             nan     0.1000    0.0532
    ##      7        1.2711             nan     0.1000    0.0499
    ##      8        1.2394             nan     0.1000    0.0457
    ##      9        1.2115             nan     0.1000    0.0383
    ##     10        1.1873             nan     0.1000    0.0374
    ##     20        1.0055             nan     0.1000    0.0198
    ##     40        0.8087             nan     0.1000    0.0103
    ##     60        0.6912             nan     0.1000    0.0081
    ##     80        0.6045             nan     0.1000    0.0068
    ##    100        0.5364             nan     0.1000    0.0049
    ##    120        0.4853             nan     0.1000    0.0031
    ##    140        0.4420             nan     0.1000    0.0018
    ##    150        0.4230             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1847
    ##      2        1.4909             nan     0.1000    0.1333
    ##      3        1.4074             nan     0.1000    0.0986
    ##      4        1.3452             nan     0.1000    0.0903
    ##      5        1.2899             nan     0.1000    0.0887
    ##      6        1.2344             nan     0.1000    0.0662
    ##      7        1.1916             nan     0.1000    0.0618
    ##      8        1.1534             nan     0.1000    0.0483
    ##      9        1.1209             nan     0.1000    0.0515
    ##     10        1.0882             nan     0.1000    0.0441
    ##     20        0.8800             nan     0.1000    0.0257
    ##     40        0.6690             nan     0.1000    0.0107
    ##     60        0.5489             nan     0.1000    0.0067
    ##     80        0.4669             nan     0.1000    0.0041
    ##    100        0.4068             nan     0.1000    0.0034
    ##    120        0.3574             nan     0.1000    0.0018
    ##    140        0.3184             nan     0.1000    0.0014
    ##    150        0.3017             nan     0.1000    0.0018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0907
    ##      2        1.5511             nan     0.1000    0.0684
    ##      3        1.5086             nan     0.1000    0.0554
    ##      4        1.4722             nan     0.1000    0.0483
    ##      5        1.4411             nan     0.1000    0.0439
    ##      6        1.4126             nan     0.1000    0.0356
    ##      7        1.3897             nan     0.1000    0.0341
    ##      8        1.3681             nan     0.1000    0.0321
    ##      9        1.3478             nan     0.1000    0.0278
    ##     10        1.3301             nan     0.1000    0.0247
    ##     20        1.1954             nan     0.1000    0.0171
    ##     40        1.0341             nan     0.1000    0.0077
    ##     60        0.9317             nan     0.1000    0.0053
    ##     80        0.8598             nan     0.1000    0.0039
    ##    100        0.8004             nan     0.1000    0.0033
    ##    120        0.7535             nan     0.1000    0.0032
    ##    140        0.7130             nan     0.1000    0.0022
    ##    150        0.6947             nan     0.1000    0.0022
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1413
    ##      2        1.5190             nan     0.1000    0.1074
    ##      3        1.4519             nan     0.1000    0.0890
    ##      4        1.3957             nan     0.1000    0.0801
    ##      5        1.3444             nan     0.1000    0.0634
    ##      6        1.3043             nan     0.1000    0.0554
    ##      7        1.2691             nan     0.1000    0.0465
    ##      8        1.2394             nan     0.1000    0.0495
    ##      9        1.2090             nan     0.1000    0.0442
    ##     10        1.1817             nan     0.1000    0.0388
    ##     20        1.0054             nan     0.1000    0.0181
    ##     40        0.8090             nan     0.1000    0.0093
    ##     60        0.6892             nan     0.1000    0.0066
    ##     80        0.6061             nan     0.1000    0.0049
    ##    100        0.5384             nan     0.1000    0.0036
    ##    120        0.4883             nan     0.1000    0.0027
    ##    140        0.4462             nan     0.1000    0.0026
    ##    150        0.4287             nan     0.1000    0.0025
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1783
    ##      2        1.4942             nan     0.1000    0.1325
    ##      3        1.4103             nan     0.1000    0.1065
    ##      4        1.3419             nan     0.1000    0.0924
    ##      5        1.2842             nan     0.1000    0.0896
    ##      6        1.2311             nan     0.1000    0.0681
    ##      7        1.1889             nan     0.1000    0.0643
    ##      8        1.1489             nan     0.1000    0.0551
    ##      9        1.1142             nan     0.1000    0.0465
    ##     10        1.0847             nan     0.1000    0.0476
    ##     20        0.8741             nan     0.1000    0.0243
    ##     40        0.6566             nan     0.1000    0.0131
    ##     60        0.5394             nan     0.1000    0.0064
    ##     80        0.4608             nan     0.1000    0.0041
    ##    100        0.3992             nan     0.1000    0.0029
    ##    120        0.3508             nan     0.1000    0.0017
    ##    140        0.3133             nan     0.1000    0.0021
    ##    150        0.2962             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0923
    ##      2        1.5508             nan     0.1000    0.0685
    ##      3        1.5072             nan     0.1000    0.0517
    ##      4        1.4722             nan     0.1000    0.0462
    ##      5        1.4420             nan     0.1000    0.0406
    ##      6        1.4158             nan     0.1000    0.0344
    ##      7        1.3941             nan     0.1000    0.0364
    ##      8        1.3707             nan     0.1000    0.0298
    ##      9        1.3515             nan     0.1000    0.0281
    ##     10        1.3336             nan     0.1000    0.0271
    ##     20        1.2011             nan     0.1000    0.0141
    ##     40        1.0432             nan     0.1000    0.0079
    ##     60        0.9436             nan     0.1000    0.0052
    ##     80        0.8682             nan     0.1000    0.0046
    ##    100        0.8088             nan     0.1000    0.0034
    ##    120        0.7600             nan     0.1000    0.0027
    ##    140        0.7182             nan     0.1000    0.0020
    ##    150        0.6991             nan     0.1000    0.0020
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1410
    ##      2        1.5183             nan     0.1000    0.1054
    ##      3        1.4514             nan     0.1000    0.0848
    ##      4        1.3965             nan     0.1000    0.0715
    ##      5        1.3507             nan     0.1000    0.0645
    ##      6        1.3102             nan     0.1000    0.0522
    ##      7        1.2758             nan     0.1000    0.0495
    ##      8        1.2442             nan     0.1000    0.0476
    ##      9        1.2137             nan     0.1000    0.0412
    ##     10        1.1879             nan     0.1000    0.0325
    ##     20        1.0115             nan     0.1000    0.0202
    ##     40        0.8115             nan     0.1000    0.0116
    ##     60        0.6919             nan     0.1000    0.0069
    ##     80        0.6080             nan     0.1000    0.0051
    ##    100        0.5432             nan     0.1000    0.0028
    ##    120        0.4924             nan     0.1000    0.0029
    ##    140        0.4501             nan     0.1000    0.0022
    ##    150        0.4313             nan     0.1000    0.0020
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1770
    ##      2        1.4963             nan     0.1000    0.1371
    ##      3        1.4101             nan     0.1000    0.1023
    ##      4        1.3458             nan     0.1000    0.0886
    ##      5        1.2924             nan     0.1000    0.0849
    ##      6        1.2403             nan     0.1000    0.0654
    ##      7        1.1987             nan     0.1000    0.0605
    ##      8        1.1605             nan     0.1000    0.0485
    ##      9        1.1287             nan     0.1000    0.0515
    ##     10        1.0973             nan     0.1000    0.0465
    ##     20        0.8850             nan     0.1000    0.0233
    ##     40        0.6719             nan     0.1000    0.0081
    ##     60        0.5499             nan     0.1000    0.0087
    ##     80        0.4658             nan     0.1000    0.0061
    ##    100        0.4069             nan     0.1000    0.0042
    ##    120        0.3561             nan     0.1000    0.0020
    ##    140        0.3136             nan     0.1000    0.0018
    ##    150        0.2980             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0899
    ##      2        1.5502             nan     0.1000    0.0685
    ##      3        1.5079             nan     0.1000    0.0513
    ##      4        1.4752             nan     0.1000    0.0476
    ##      5        1.4449             nan     0.1000    0.0412
    ##      6        1.4173             nan     0.1000    0.0377
    ##      7        1.3926             nan     0.1000    0.0334
    ##      8        1.3713             nan     0.1000    0.0318
    ##      9        1.3516             nan     0.1000    0.0265
    ##     10        1.3336             nan     0.1000    0.0291
    ##     20        1.1975             nan     0.1000    0.0166
    ##     40        1.0381             nan     0.1000    0.0065
    ##     60        0.9363             nan     0.1000    0.0046
    ##     80        0.8637             nan     0.1000    0.0051
    ##    100        0.8043             nan     0.1000    0.0028
    ##    120        0.7568             nan     0.1000    0.0029
    ##    140        0.7162             nan     0.1000    0.0033
    ##    150        0.6981             nan     0.1000    0.0020
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1415
    ##      2        1.5176             nan     0.1000    0.1069
    ##      3        1.4501             nan     0.1000    0.0880
    ##      4        1.3951             nan     0.1000    0.0782
    ##      5        1.3450             nan     0.1000    0.0649
    ##      6        1.3045             nan     0.1000    0.0577
    ##      7        1.2688             nan     0.1000    0.0550
    ##      8        1.2343             nan     0.1000    0.0405
    ##      9        1.2076             nan     0.1000    0.0409
    ##     10        1.1806             nan     0.1000    0.0382
    ##     20        1.0003             nan     0.1000    0.0204
    ##     40        0.8075             nan     0.1000    0.0110
    ##     60        0.6859             nan     0.1000    0.0063
    ##     80        0.6040             nan     0.1000    0.0036
    ##    100        0.5435             nan     0.1000    0.0038
    ##    120        0.4923             nan     0.1000    0.0024
    ##    140        0.4491             nan     0.1000    0.0022
    ##    150        0.4306             nan     0.1000    0.0022
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1861
    ##      2        1.4928             nan     0.1000    0.1398
    ##      3        1.4066             nan     0.1000    0.1073
    ##      4        1.3396             nan     0.1000    0.0845
    ##      5        1.2869             nan     0.1000    0.0904
    ##      6        1.2296             nan     0.1000    0.0618
    ##      7        1.1900             nan     0.1000    0.0639
    ##      8        1.1506             nan     0.1000    0.0532
    ##      9        1.1178             nan     0.1000    0.0486
    ##     10        1.0868             nan     0.1000    0.0448
    ##     20        0.8764             nan     0.1000    0.0222
    ##     40        0.6611             nan     0.1000    0.0110
    ##     60        0.5440             nan     0.1000    0.0072
    ##     80        0.4643             nan     0.1000    0.0050
    ##    100        0.4030             nan     0.1000    0.0034
    ##    120        0.3563             nan     0.1000    0.0027
    ##    140        0.3168             nan     0.1000    0.0020
    ##    150        0.2994             nan     0.1000    0.0019
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0920
    ##      2        1.5498             nan     0.1000    0.0672
    ##      3        1.5065             nan     0.1000    0.0514
    ##      4        1.4734             nan     0.1000    0.0465
    ##      5        1.4438             nan     0.1000    0.0470
    ##      6        1.4139             nan     0.1000    0.0341
    ##      7        1.3913             nan     0.1000    0.0336
    ##      8        1.3694             nan     0.1000    0.0328
    ##      9        1.3477             nan     0.1000    0.0275
    ##     10        1.3292             nan     0.1000    0.0254
    ##     20        1.1987             nan     0.1000    0.0188
    ##     40        1.0394             nan     0.1000    0.0086
    ##     60        0.9407             nan     0.1000    0.0072
    ##     80        0.8660             nan     0.1000    0.0037
    ##    100        0.8078             nan     0.1000    0.0034
    ##    120        0.7600             nan     0.1000    0.0031
    ##    140        0.7188             nan     0.1000    0.0021
    ##    150        0.7017             nan     0.1000    0.0027
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1422
    ##      2        1.5192             nan     0.1000    0.0991
    ##      3        1.4551             nan     0.1000    0.0905
    ##      4        1.3984             nan     0.1000    0.0761
    ##      5        1.3507             nan     0.1000    0.0608
    ##      6        1.3120             nan     0.1000    0.0556
    ##      7        1.2765             nan     0.1000    0.0529
    ##      8        1.2424             nan     0.1000    0.0450
    ##      9        1.2135             nan     0.1000    0.0402
    ##     10        1.1884             nan     0.1000    0.0372
    ##     20        1.0084             nan     0.1000    0.0211
    ##     40        0.8108             nan     0.1000    0.0123
    ##     60        0.6919             nan     0.1000    0.0038
    ##     80        0.6069             nan     0.1000    0.0046
    ##    100        0.5397             nan     0.1000    0.0029
    ##    120        0.4891             nan     0.1000    0.0021
    ##    140        0.4477             nan     0.1000    0.0027
    ##    150        0.4275             nan     0.1000    0.0025
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1855
    ##      2        1.4917             nan     0.1000    0.1323
    ##      3        1.4091             nan     0.1000    0.1064
    ##      4        1.3423             nan     0.1000    0.0939
    ##      5        1.2854             nan     0.1000    0.0826
    ##      6        1.2340             nan     0.1000    0.0647
    ##      7        1.1942             nan     0.1000    0.0616
    ##      8        1.1554             nan     0.1000    0.0581
    ##      9        1.1195             nan     0.1000    0.0470
    ##     10        1.0895             nan     0.1000    0.0438
    ##     20        0.8790             nan     0.1000    0.0221
    ##     40        0.6674             nan     0.1000    0.0099
    ##     60        0.5508             nan     0.1000    0.0063
    ##     80        0.4700             nan     0.1000    0.0049
    ##    100        0.4058             nan     0.1000    0.0030
    ##    120        0.3590             nan     0.1000    0.0038
    ##    140        0.3165             nan     0.1000    0.0012
    ##    150        0.3000             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0918
    ##      2        1.5498             nan     0.1000    0.0690
    ##      3        1.5066             nan     0.1000    0.0536
    ##      4        1.4730             nan     0.1000    0.0455
    ##      5        1.4431             nan     0.1000    0.0411
    ##      6        1.4160             nan     0.1000    0.0387
    ##      7        1.3901             nan     0.1000    0.0300
    ##      8        1.3708             nan     0.1000    0.0289
    ##      9        1.3515             nan     0.1000    0.0265
    ##     10        1.3337             nan     0.1000    0.0296
    ##     20        1.1999             nan     0.1000    0.0149
    ##     40        1.0428             nan     0.1000    0.0087
    ##     60        0.9419             nan     0.1000    0.0053
    ##     80        0.8675             nan     0.1000    0.0039
    ##    100        0.8094             nan     0.1000    0.0033
    ##    120        0.7598             nan     0.1000    0.0032
    ##    140        0.7187             nan     0.1000    0.0022
    ##    150        0.7009             nan     0.1000    0.0023
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1427
    ##      2        1.5178             nan     0.1000    0.1104
    ##      3        1.4498             nan     0.1000    0.0848
    ##      4        1.3964             nan     0.1000    0.0743
    ##      5        1.3498             nan     0.1000    0.0570
    ##      6        1.3133             nan     0.1000    0.0646
    ##      7        1.2731             nan     0.1000    0.0496
    ##      8        1.2423             nan     0.1000    0.0429
    ##      9        1.2144             nan     0.1000    0.0419
    ##     10        1.1872             nan     0.1000    0.0414
    ##     20        1.0058             nan     0.1000    0.0214
    ##     40        0.8099             nan     0.1000    0.0130
    ##     60        0.6878             nan     0.1000    0.0065
    ##     80        0.6033             nan     0.1000    0.0056
    ##    100        0.5374             nan     0.1000    0.0042
    ##    120        0.4872             nan     0.1000    0.0033
    ##    140        0.4431             nan     0.1000    0.0014
    ##    150        0.4242             nan     0.1000    0.0023
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1835
    ##      2        1.4945             nan     0.1000    0.1257
    ##      3        1.4139             nan     0.1000    0.1107
    ##      4        1.3444             nan     0.1000    0.0891
    ##      5        1.2888             nan     0.1000    0.0694
    ##      6        1.2439             nan     0.1000    0.0742
    ##      7        1.1977             nan     0.1000    0.0639
    ##      8        1.1569             nan     0.1000    0.0538
    ##      9        1.1233             nan     0.1000    0.0463
    ##     10        1.0936             nan     0.1000    0.0462
    ##     20        0.8869             nan     0.1000    0.0217
    ##     40        0.6707             nan     0.1000    0.0111
    ##     60        0.5473             nan     0.1000    0.0062
    ##     80        0.4603             nan     0.1000    0.0045
    ##    100        0.4020             nan     0.1000    0.0043
    ##    120        0.3506             nan     0.1000    0.0019
    ##    140        0.3127             nan     0.1000    0.0027
    ##    150        0.2946             nan     0.1000    0.0014
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0896
    ##      2        1.5500             nan     0.1000    0.0683
    ##      3        1.5055             nan     0.1000    0.0526
    ##      4        1.4715             nan     0.1000    0.0419
    ##      5        1.4445             nan     0.1000    0.0447
    ##      6        1.4167             nan     0.1000    0.0335
    ##      7        1.3946             nan     0.1000    0.0346
    ##      8        1.3719             nan     0.1000    0.0320
    ##      9        1.3512             nan     0.1000    0.0277
    ##     10        1.3331             nan     0.1000    0.0276
    ##     20        1.2005             nan     0.1000    0.0144
    ##     40        1.0416             nan     0.1000    0.0073
    ##     60        0.9408             nan     0.1000    0.0051
    ##     80        0.8665             nan     0.1000    0.0043
    ##    100        0.8051             nan     0.1000    0.0026
    ##    120        0.7577             nan     0.1000    0.0033
    ##    140        0.7161             nan     0.1000    0.0022
    ##    150        0.6982             nan     0.1000    0.0029
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1463
    ##      2        1.5180             nan     0.1000    0.1043
    ##      3        1.4523             nan     0.1000    0.0883
    ##      4        1.3970             nan     0.1000    0.0826
    ##      5        1.3462             nan     0.1000    0.0636
    ##      6        1.3054             nan     0.1000    0.0566
    ##      7        1.2702             nan     0.1000    0.0444
    ##      8        1.2401             nan     0.1000    0.0425
    ##      9        1.2122             nan     0.1000    0.0376
    ##     10        1.1880             nan     0.1000    0.0396
    ##     20        1.0077             nan     0.1000    0.0179
    ##     40        0.8074             nan     0.1000    0.0132
    ##     60        0.6840             nan     0.1000    0.0081
    ##     80        0.6008             nan     0.1000    0.0041
    ##    100        0.5357             nan     0.1000    0.0045
    ##    120        0.4829             nan     0.1000    0.0027
    ##    140        0.4398             nan     0.1000    0.0022
    ##    150        0.4215             nan     0.1000    0.0015
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1860
    ##      2        1.4925             nan     0.1000    0.1306
    ##      3        1.4103             nan     0.1000    0.1094
    ##      4        1.3423             nan     0.1000    0.0885
    ##      5        1.2871             nan     0.1000    0.0852
    ##      6        1.2351             nan     0.1000    0.0624
    ##      7        1.1954             nan     0.1000    0.0609
    ##      8        1.1562             nan     0.1000    0.0533
    ##      9        1.1231             nan     0.1000    0.0544
    ##     10        1.0891             nan     0.1000    0.0423
    ##     20        0.8772             nan     0.1000    0.0258
    ##     40        0.6577             nan     0.1000    0.0101
    ##     60        0.5395             nan     0.1000    0.0064
    ##     80        0.4578             nan     0.1000    0.0042
    ##    100        0.3964             nan     0.1000    0.0031
    ##    120        0.3493             nan     0.1000    0.0031
    ##    140        0.3127             nan     0.1000    0.0016
    ##    150        0.2947             nan     0.1000    0.0018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0941
    ##      2        1.5497             nan     0.1000    0.0665
    ##      3        1.5081             nan     0.1000    0.0543
    ##      4        1.4754             nan     0.1000    0.0474
    ##      5        1.4449             nan     0.1000    0.0403
    ##      6        1.4185             nan     0.1000    0.0371
    ##      7        1.3945             nan     0.1000    0.0335
    ##      8        1.3738             nan     0.1000    0.0332
    ##      9        1.3520             nan     0.1000    0.0255
    ##     10        1.3353             nan     0.1000    0.0251
    ##     20        1.2016             nan     0.1000    0.0164
    ##     40        1.0423             nan     0.1000    0.0089
    ##     60        0.9424             nan     0.1000    0.0059
    ##     80        0.8707             nan     0.1000    0.0045
    ##    100        0.8126             nan     0.1000    0.0034
    ##    120        0.7655             nan     0.1000    0.0021
    ##    140        0.7267             nan     0.1000    0.0022
    ##    150        0.7079             nan     0.1000    0.0025
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1419
    ##      2        1.5166             nan     0.1000    0.1001
    ##      3        1.4512             nan     0.1000    0.0860
    ##      4        1.3970             nan     0.1000    0.0818
    ##      5        1.3467             nan     0.1000    0.0615
    ##      6        1.3067             nan     0.1000    0.0579
    ##      7        1.2701             nan     0.1000    0.0498
    ##      8        1.2389             nan     0.1000    0.0469
    ##      9        1.2102             nan     0.1000    0.0389
    ##     10        1.1857             nan     0.1000    0.0358
    ##     20        1.0047             nan     0.1000    0.0243
    ##     40        0.8098             nan     0.1000    0.0097
    ##     60        0.6946             nan     0.1000    0.0052
    ##     80        0.6129             nan     0.1000    0.0047
    ##    100        0.5488             nan     0.1000    0.0034
    ##    120        0.4984             nan     0.1000    0.0026
    ##    140        0.4577             nan     0.1000    0.0021
    ##    150        0.4386             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1870
    ##      2        1.4911             nan     0.1000    0.1350
    ##      3        1.4077             nan     0.1000    0.1048
    ##      4        1.3434             nan     0.1000    0.0970
    ##      5        1.2824             nan     0.1000    0.0848
    ##      6        1.2308             nan     0.1000    0.0640
    ##      7        1.1906             nan     0.1000    0.0628
    ##      8        1.1518             nan     0.1000    0.0493
    ##      9        1.1199             nan     0.1000    0.0497
    ##     10        1.0886             nan     0.1000    0.0392
    ##     20        0.8826             nan     0.1000    0.0184
    ##     40        0.6709             nan     0.1000    0.0124
    ##     60        0.5509             nan     0.1000    0.0064
    ##     80        0.4677             nan     0.1000    0.0036
    ##    100        0.4097             nan     0.1000    0.0025
    ##    120        0.3649             nan     0.1000    0.0022
    ##    140        0.3273             nan     0.1000    0.0019
    ##    150        0.3107             nan     0.1000    0.0018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0927
    ##      2        1.5502             nan     0.1000    0.0668
    ##      3        1.5082             nan     0.1000    0.0541
    ##      4        1.4726             nan     0.1000    0.0442
    ##      5        1.4440             nan     0.1000    0.0403
    ##      6        1.4167             nan     0.1000    0.0393
    ##      7        1.3911             nan     0.1000    0.0362
    ##      8        1.3687             nan     0.1000    0.0309
    ##      9        1.3490             nan     0.1000    0.0243
    ##     10        1.3325             nan     0.1000    0.0274
    ##     20        1.1985             nan     0.1000    0.0141
    ##     40        1.0433             nan     0.1000    0.0079
    ##     60        0.9409             nan     0.1000    0.0049
    ##     80        0.8679             nan     0.1000    0.0034
    ##    100        0.8103             nan     0.1000    0.0044
    ##    120        0.7600             nan     0.1000    0.0034
    ##    140        0.7190             nan     0.1000    0.0026
    ##    150        0.7012             nan     0.1000    0.0016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1399
    ##      2        1.5193             nan     0.1000    0.1063
    ##      3        1.4534             nan     0.1000    0.0857
    ##      4        1.3980             nan     0.1000    0.0696
    ##      5        1.3525             nan     0.1000    0.0669
    ##      6        1.3110             nan     0.1000    0.0602
    ##      7        1.2742             nan     0.1000    0.0558
    ##      8        1.2396             nan     0.1000    0.0438
    ##      9        1.2118             nan     0.1000    0.0349
    ##     10        1.1889             nan     0.1000    0.0360
    ##     20        1.0090             nan     0.1000    0.0215
    ##     40        0.8136             nan     0.1000    0.0141
    ##     60        0.6941             nan     0.1000    0.0056
    ##     80        0.6118             nan     0.1000    0.0064
    ##    100        0.5479             nan     0.1000    0.0030
    ##    120        0.4950             nan     0.1000    0.0021
    ##    140        0.4539             nan     0.1000    0.0023
    ##    150        0.4355             nan     0.1000    0.0016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1873
    ##      2        1.4928             nan     0.1000    0.1298
    ##      3        1.4107             nan     0.1000    0.1083
    ##      4        1.3431             nan     0.1000    0.0854
    ##      5        1.2887             nan     0.1000    0.0748
    ##      6        1.2414             nan     0.1000    0.0798
    ##      7        1.1936             nan     0.1000    0.0668
    ##      8        1.1527             nan     0.1000    0.0514
    ##      9        1.1188             nan     0.1000    0.0428
    ##     10        1.0902             nan     0.1000    0.0412
    ##     20        0.8801             nan     0.1000    0.0216
    ##     40        0.6706             nan     0.1000    0.0107
    ##     60        0.5517             nan     0.1000    0.0068
    ##     80        0.4692             nan     0.1000    0.0052
    ##    100        0.4115             nan     0.1000    0.0036
    ##    120        0.3640             nan     0.1000    0.0041
    ##    140        0.3240             nan     0.1000    0.0018
    ##    150        0.3060             nan     0.1000    0.0019
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0924
    ##      2        1.5478             nan     0.1000    0.0710
    ##      3        1.5028             nan     0.1000    0.0565
    ##      4        1.4675             nan     0.1000    0.0426
    ##      5        1.4377             nan     0.1000    0.0421
    ##      6        1.4096             nan     0.1000    0.0361
    ##      7        1.3868             nan     0.1000    0.0341
    ##      8        1.3645             nan     0.1000    0.0298
    ##      9        1.3447             nan     0.1000    0.0289
    ##     10        1.3265             nan     0.1000    0.0268
    ##     20        1.1923             nan     0.1000    0.0150
    ##     40        1.0370             nan     0.1000    0.0085
    ##     60        0.9382             nan     0.1000    0.0048
    ##     80        0.8637             nan     0.1000    0.0047
    ##    100        0.8046             nan     0.1000    0.0031
    ##    120        0.7574             nan     0.1000    0.0024
    ##    140        0.7185             nan     0.1000    0.0017
    ##    150        0.7007             nan     0.1000    0.0018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1399
    ##      2        1.5183             nan     0.1000    0.1137
    ##      3        1.4480             nan     0.1000    0.0891
    ##      4        1.3911             nan     0.1000    0.0701
    ##      5        1.3465             nan     0.1000    0.0626
    ##      6        1.3056             nan     0.1000    0.0579
    ##      7        1.2681             nan     0.1000    0.0560
    ##      8        1.2338             nan     0.1000    0.0430
    ##      9        1.2068             nan     0.1000    0.0380
    ##     10        1.1818             nan     0.1000    0.0388
    ##     20        1.0031             nan     0.1000    0.0186
    ##     40        0.8087             nan     0.1000    0.0137
    ##     60        0.6875             nan     0.1000    0.0067
    ##     80        0.6034             nan     0.1000    0.0042
    ##    100        0.5402             nan     0.1000    0.0033
    ##    120        0.4865             nan     0.1000    0.0026
    ##    140        0.4439             nan     0.1000    0.0031
    ##    150        0.4258             nan     0.1000    0.0015
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1785
    ##      2        1.4934             nan     0.1000    0.1379
    ##      3        1.4073             nan     0.1000    0.1064
    ##      4        1.3406             nan     0.1000    0.0885
    ##      5        1.2856             nan     0.1000    0.0738
    ##      6        1.2390             nan     0.1000    0.0752
    ##      7        1.1918             nan     0.1000    0.0660
    ##      8        1.1508             nan     0.1000    0.0627
    ##      9        1.1114             nan     0.1000    0.0397
    ##     10        1.0852             nan     0.1000    0.0427
    ##     20        0.8790             nan     0.1000    0.0249
    ##     40        0.6635             nan     0.1000    0.0116
    ##     60        0.5472             nan     0.1000    0.0044
    ##     80        0.4652             nan     0.1000    0.0051
    ##    100        0.4067             nan     0.1000    0.0031
    ##    120        0.3597             nan     0.1000    0.0024
    ##    140        0.3169             nan     0.1000    0.0018
    ##    150        0.2988             nan     0.1000    0.0014
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0903
    ##      2        1.5490             nan     0.1000    0.0684
    ##      3        1.5058             nan     0.1000    0.0556
    ##      4        1.4713             nan     0.1000    0.0487
    ##      5        1.4407             nan     0.1000    0.0372
    ##      6        1.4167             nan     0.1000    0.0393
    ##      7        1.3909             nan     0.1000    0.0323
    ##      8        1.3701             nan     0.1000    0.0323
    ##      9        1.3494             nan     0.1000    0.0281
    ##     10        1.3301             nan     0.1000    0.0265
    ##     20        1.1972             nan     0.1000    0.0151
    ##     40        1.0391             nan     0.1000    0.0075
    ##     60        0.9383             nan     0.1000    0.0070
    ##     80        0.8659             nan     0.1000    0.0051
    ##    100        0.8071             nan     0.1000    0.0030
    ##    120        0.7596             nan     0.1000    0.0023
    ##    140        0.7191             nan     0.1000    0.0021
    ##    150        0.7013             nan     0.1000    0.0022
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1465
    ##      2        1.5179             nan     0.1000    0.1035
    ##      3        1.4518             nan     0.1000    0.0902
    ##      4        1.3948             nan     0.1000    0.0758
    ##      5        1.3468             nan     0.1000    0.0597
    ##      6        1.3078             nan     0.1000    0.0613
    ##      7        1.2708             nan     0.1000    0.0488
    ##      8        1.2400             nan     0.1000    0.0444
    ##      9        1.2118             nan     0.1000    0.0417
    ##     10        1.1855             nan     0.1000    0.0326
    ##     20        1.0084             nan     0.1000    0.0183
    ##     40        0.8062             nan     0.1000    0.0105
    ##     60        0.6871             nan     0.1000    0.0061
    ##     80        0.6067             nan     0.1000    0.0062
    ##    100        0.5420             nan     0.1000    0.0025
    ##    120        0.4923             nan     0.1000    0.0025
    ##    140        0.4479             nan     0.1000    0.0021
    ##    150        0.4294             nan     0.1000    0.0014
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1836
    ##      2        1.4936             nan     0.1000    0.1329
    ##      3        1.4111             nan     0.1000    0.1060
    ##      4        1.3452             nan     0.1000    0.0845
    ##      5        1.2912             nan     0.1000    0.0754
    ##      6        1.2434             nan     0.1000    0.0745
    ##      7        1.1977             nan     0.1000    0.0554
    ##      8        1.1632             nan     0.1000    0.0577
    ##      9        1.1270             nan     0.1000    0.0524
    ##     10        1.0933             nan     0.1000    0.0469
    ##     20        0.8819             nan     0.1000    0.0212
    ##     40        0.6666             nan     0.1000    0.0099
    ##     60        0.5493             nan     0.1000    0.0068
    ##     80        0.4675             nan     0.1000    0.0053
    ##    100        0.4065             nan     0.1000    0.0037
    ##    120        0.3581             nan     0.1000    0.0028
    ##    140        0.3182             nan     0.1000    0.0015
    ##    150        0.3032             nan     0.1000    0.0016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0954
    ##      2        1.5482             nan     0.1000    0.0709
    ##      3        1.5038             nan     0.1000    0.0536
    ##      4        1.4691             nan     0.1000    0.0468
    ##      5        1.4388             nan     0.1000    0.0423
    ##      6        1.4116             nan     0.1000    0.0375
    ##      7        1.3857             nan     0.1000    0.0335
    ##      8        1.3642             nan     0.1000    0.0318
    ##      9        1.3438             nan     0.1000    0.0284
    ##     10        1.3250             nan     0.1000    0.0242
    ##     20        1.1902             nan     0.1000    0.0135
    ##     40        1.0365             nan     0.1000    0.0091
    ##     60        0.9329             nan     0.1000    0.0064
    ##     80        0.8595             nan     0.1000    0.0034
    ##    100        0.8033             nan     0.1000    0.0033
    ##    120        0.7573             nan     0.1000    0.0022
    ##    140        0.7171             nan     0.1000    0.0015
    ##    150        0.6990             nan     0.1000    0.0028
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1494
    ##      2        1.5158             nan     0.1000    0.1091
    ##      3        1.4455             nan     0.1000    0.0820
    ##      4        1.3923             nan     0.1000    0.0763
    ##      5        1.3446             nan     0.1000    0.0652
    ##      6        1.3031             nan     0.1000    0.0608
    ##      7        1.2646             nan     0.1000    0.0570
    ##      8        1.2292             nan     0.1000    0.0472
    ##      9        1.1998             nan     0.1000    0.0393
    ##     10        1.1749             nan     0.1000    0.0390
    ##     20        0.9991             nan     0.1000    0.0216
    ##     40        0.8004             nan     0.1000    0.0124
    ##     60        0.6834             nan     0.1000    0.0072
    ##     80        0.6021             nan     0.1000    0.0054
    ##    100        0.5379             nan     0.1000    0.0035
    ##    120        0.4880             nan     0.1000    0.0035
    ##    140        0.4471             nan     0.1000    0.0030
    ##    150        0.4281             nan     0.1000    0.0030
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1848
    ##      2        1.4937             nan     0.1000    0.1413
    ##      3        1.4070             nan     0.1000    0.1061
    ##      4        1.3401             nan     0.1000    0.0933
    ##      5        1.2834             nan     0.1000    0.0762
    ##      6        1.2363             nan     0.1000    0.0753
    ##      7        1.1893             nan     0.1000    0.0542
    ##      8        1.1548             nan     0.1000    0.0617
    ##      9        1.1165             nan     0.1000    0.0523
    ##     10        1.0839             nan     0.1000    0.0395
    ##     20        0.8785             nan     0.1000    0.0204
    ##     40        0.6690             nan     0.1000    0.0107
    ##     60        0.5480             nan     0.1000    0.0059
    ##     80        0.4645             nan     0.1000    0.0028
    ##    100        0.4054             nan     0.1000    0.0036
    ##    120        0.3567             nan     0.1000    0.0023
    ##    140        0.3176             nan     0.1000    0.0019
    ##    150        0.3017             nan     0.1000    0.0023
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0907
    ##      2        1.5506             nan     0.1000    0.0732
    ##      3        1.5058             nan     0.1000    0.0528
    ##      4        1.4718             nan     0.1000    0.0442
    ##      5        1.4423             nan     0.1000    0.0424
    ##      6        1.4150             nan     0.1000    0.0388
    ##      7        1.3893             nan     0.1000    0.0333
    ##      8        1.3677             nan     0.1000    0.0295
    ##      9        1.3484             nan     0.1000    0.0239
    ##     10        1.3322             nan     0.1000    0.0292
    ##     20        1.1945             nan     0.1000    0.0159
    ##     40        1.0349             nan     0.1000    0.0087
    ##     60        0.9322             nan     0.1000    0.0055
    ##     80        0.8575             nan     0.1000    0.0036
    ##    100        0.7988             nan     0.1000    0.0030
    ##    120        0.7494             nan     0.1000    0.0030
    ##    140        0.7067             nan     0.1000    0.0017
    ##    150        0.6885             nan     0.1000    0.0025
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1419
    ##      2        1.5180             nan     0.1000    0.1088
    ##      3        1.4494             nan     0.1000    0.0851
    ##      4        1.3947             nan     0.1000    0.0762
    ##      5        1.3473             nan     0.1000    0.0668
    ##      6        1.3048             nan     0.1000    0.0558
    ##      7        1.2697             nan     0.1000    0.0503
    ##      8        1.2376             nan     0.1000    0.0466
    ##      9        1.2075             nan     0.1000    0.0416
    ##     10        1.1815             nan     0.1000    0.0329
    ##     20        0.9990             nan     0.1000    0.0198
    ##     40        0.8002             nan     0.1000    0.0078
    ##     60        0.6830             nan     0.1000    0.0060
    ##     80        0.5986             nan     0.1000    0.0054
    ##    100        0.5362             nan     0.1000    0.0038
    ##    120        0.4841             nan     0.1000    0.0021
    ##    140        0.4402             nan     0.1000    0.0029
    ##    150        0.4220             nan     0.1000    0.0019
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1879
    ##      2        1.4878             nan     0.1000    0.1355
    ##      3        1.4022             nan     0.1000    0.1065
    ##      4        1.3354             nan     0.1000    0.0865
    ##      5        1.2816             nan     0.1000    0.0799
    ##      6        1.2306             nan     0.1000    0.0744
    ##      7        1.1849             nan     0.1000    0.0670
    ##      8        1.1431             nan     0.1000    0.0523
    ##      9        1.1092             nan     0.1000    0.0462
    ##     10        1.0796             nan     0.1000    0.0468
    ##     20        0.8679             nan     0.1000    0.0223
    ##     40        0.6520             nan     0.1000    0.0109
    ##     60        0.5347             nan     0.1000    0.0052
    ##     80        0.4568             nan     0.1000    0.0045
    ##    100        0.3994             nan     0.1000    0.0025
    ##    120        0.3512             nan     0.1000    0.0036
    ##    140        0.3142             nan     0.1000    0.0020
    ##    150        0.2981             nan     0.1000    0.0009
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0907
    ##      2        1.5496             nan     0.1000    0.0640
    ##      3        1.5075             nan     0.1000    0.0537
    ##      4        1.4734             nan     0.1000    0.0463
    ##      5        1.4426             nan     0.1000    0.0410
    ##      6        1.4163             nan     0.1000    0.0387
    ##      7        1.3904             nan     0.1000    0.0311
    ##      8        1.3701             nan     0.1000    0.0267
    ##      9        1.3522             nan     0.1000    0.0266
    ##     10        1.3339             nan     0.1000    0.0276
    ##     20        1.1975             nan     0.1000    0.0166
    ##     40        1.0372             nan     0.1000    0.0081
    ##     60        0.9357             nan     0.1000    0.0066
    ##     80        0.8619             nan     0.1000    0.0041
    ##    100        0.8034             nan     0.1000    0.0029
    ##    120        0.7571             nan     0.1000    0.0029
    ##    140        0.7167             nan     0.1000    0.0017
    ##    150        0.6973             nan     0.1000    0.0020
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1444
    ##      2        1.5156             nan     0.1000    0.1020
    ##      3        1.4508             nan     0.1000    0.0939
    ##      4        1.3922             nan     0.1000    0.0702
    ##      5        1.3465             nan     0.1000    0.0665
    ##      6        1.3038             nan     0.1000    0.0555
    ##      7        1.2684             nan     0.1000    0.0475
    ##      8        1.2376             nan     0.1000    0.0423
    ##      9        1.2104             nan     0.1000    0.0401
    ##     10        1.1855             nan     0.1000    0.0361
    ##     20        1.0047             nan     0.1000    0.0174
    ##     40        0.8082             nan     0.1000    0.0092
    ##     60        0.6899             nan     0.1000    0.0051
    ##     80        0.6048             nan     0.1000    0.0040
    ##    100        0.5408             nan     0.1000    0.0047
    ##    120        0.4898             nan     0.1000    0.0025
    ##    140        0.4470             nan     0.1000    0.0018
    ##    150        0.4286             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1892
    ##      2        1.4904             nan     0.1000    0.1364
    ##      3        1.4058             nan     0.1000    0.1049
    ##      4        1.3395             nan     0.1000    0.0857
    ##      5        1.2854             nan     0.1000    0.0780
    ##      6        1.2360             nan     0.1000    0.0715
    ##      7        1.1904             nan     0.1000    0.0656
    ##      8        1.1498             nan     0.1000    0.0503
    ##      9        1.1176             nan     0.1000    0.0550
    ##     10        1.0837             nan     0.1000    0.0441
    ##     20        0.8756             nan     0.1000    0.0201
    ##     40        0.6617             nan     0.1000    0.0078
    ##     60        0.5458             nan     0.1000    0.0069
    ##     80        0.4648             nan     0.1000    0.0058
    ##    100        0.4032             nan     0.1000    0.0033
    ##    120        0.3552             nan     0.1000    0.0031
    ##    140        0.3158             nan     0.1000    0.0020
    ##    150        0.2979             nan     0.1000    0.0012
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0959
    ##      2        1.5487             nan     0.1000    0.0699
    ##      3        1.5058             nan     0.1000    0.0532
    ##      4        1.4716             nan     0.1000    0.0467
    ##      5        1.4418             nan     0.1000    0.0435
    ##      6        1.4137             nan     0.1000    0.0358
    ##      7        1.3906             nan     0.1000    0.0301
    ##      8        1.3703             nan     0.1000    0.0321
    ##      9        1.3506             nan     0.1000    0.0305
    ##     10        1.3309             nan     0.1000    0.0225
    ##     20        1.1970             nan     0.1000    0.0156
    ##     40        1.0361             nan     0.1000    0.0090
    ##     60        0.9352             nan     0.1000    0.0051
    ##     80        0.8654             nan     0.1000    0.0038
    ##    100        0.8055             nan     0.1000    0.0030
    ##    120        0.7581             nan     0.1000    0.0033
    ##    140        0.7180             nan     0.1000    0.0021
    ##    150        0.6988             nan     0.1000    0.0019
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1436
    ##      2        1.5183             nan     0.1000    0.1052
    ##      3        1.4516             nan     0.1000    0.0882
    ##      4        1.3940             nan     0.1000    0.0708
    ##      5        1.3492             nan     0.1000    0.0705
    ##      6        1.3058             nan     0.1000    0.0611
    ##      7        1.2681             nan     0.1000    0.0508
    ##      8        1.2360             nan     0.1000    0.0457
    ##      9        1.2076             nan     0.1000    0.0388
    ##     10        1.1825             nan     0.1000    0.0334
    ##     20        1.0069             nan     0.1000    0.0160
    ##     40        0.8087             nan     0.1000    0.0092
    ##     60        0.6901             nan     0.1000    0.0070
    ##     80        0.6079             nan     0.1000    0.0055
    ##    100        0.5456             nan     0.1000    0.0042
    ##    120        0.4918             nan     0.1000    0.0016
    ##    140        0.4502             nan     0.1000    0.0022
    ##    150        0.4307             nan     0.1000    0.0010
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1863
    ##      2        1.4925             nan     0.1000    0.1379
    ##      3        1.4076             nan     0.1000    0.0999
    ##      4        1.3446             nan     0.1000    0.0898
    ##      5        1.2866             nan     0.1000    0.0853
    ##      6        1.2349             nan     0.1000    0.0755
    ##      7        1.1881             nan     0.1000    0.0567
    ##      8        1.1510             nan     0.1000    0.0576
    ##      9        1.1162             nan     0.1000    0.0503
    ##     10        1.0848             nan     0.1000    0.0413
    ##     20        0.8791             nan     0.1000    0.0205
    ##     40        0.6706             nan     0.1000    0.0105
    ##     60        0.5528             nan     0.1000    0.0068
    ##     80        0.4703             nan     0.1000    0.0042
    ##    100        0.4065             nan     0.1000    0.0035
    ##    120        0.3584             nan     0.1000    0.0026
    ##    140        0.3193             nan     0.1000    0.0014
    ##    150        0.3031             nan     0.1000    0.0022
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0982
    ##      2        1.5489             nan     0.1000    0.0730
    ##      3        1.5039             nan     0.1000    0.0534
    ##      4        1.4697             nan     0.1000    0.0479
    ##      5        1.4385             nan     0.1000    0.0380
    ##      6        1.4134             nan     0.1000    0.0404
    ##      7        1.3863             nan     0.1000    0.0315
    ##      8        1.3651             nan     0.1000    0.0309
    ##      9        1.3455             nan     0.1000    0.0269
    ##     10        1.3283             nan     0.1000    0.0252
    ##     20        1.1956             nan     0.1000    0.0149
    ##     40        1.0368             nan     0.1000    0.0082
    ##     60        0.9374             nan     0.1000    0.0079
    ##     80        0.8635             nan     0.1000    0.0046
    ##    100        0.8053             nan     0.1000    0.0033
    ##    120        0.7584             nan     0.1000    0.0031
    ##    140        0.7175             nan     0.1000    0.0019
    ##    150        0.7003             nan     0.1000    0.0016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1447
    ##      2        1.5161             nan     0.1000    0.1083
    ##      3        1.4462             nan     0.1000    0.0862
    ##      4        1.3930             nan     0.1000    0.0721
    ##      5        1.3472             nan     0.1000    0.0581
    ##      6        1.3104             nan     0.1000    0.0595
    ##      7        1.2738             nan     0.1000    0.0495
    ##      8        1.2422             nan     0.1000    0.0418
    ##      9        1.2154             nan     0.1000    0.0398
    ##     10        1.1896             nan     0.1000    0.0362
    ##     20        1.0037             nan     0.1000    0.0169
    ##     40        0.8112             nan     0.1000    0.0093
    ##     60        0.6944             nan     0.1000    0.0053
    ##     80        0.6099             nan     0.1000    0.0050
    ##    100        0.5442             nan     0.1000    0.0034
    ##    120        0.4910             nan     0.1000    0.0023
    ##    140        0.4495             nan     0.1000    0.0024
    ##    150        0.4307             nan     0.1000    0.0024
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1906
    ##      2        1.4898             nan     0.1000    0.1328
    ##      3        1.4064             nan     0.1000    0.1077
    ##      4        1.3384             nan     0.1000    0.0988
    ##      5        1.2762             nan     0.1000    0.0718
    ##      6        1.2306             nan     0.1000    0.0658
    ##      7        1.1888             nan     0.1000    0.0591
    ##      8        1.1516             nan     0.1000    0.0586
    ##      9        1.1154             nan     0.1000    0.0469
    ##     10        1.0857             nan     0.1000    0.0408
    ##     20        0.8805             nan     0.1000    0.0227
    ##     40        0.6624             nan     0.1000    0.0105
    ##     60        0.5465             nan     0.1000    0.0082
    ##     80        0.4629             nan     0.1000    0.0062
    ##    100        0.4043             nan     0.1000    0.0039
    ##    120        0.3560             nan     0.1000    0.0028
    ##    140        0.3187             nan     0.1000    0.0023
    ##    150        0.3021             nan     0.1000    0.0010
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0919
    ##      2        1.5503             nan     0.1000    0.0673
    ##      3        1.5074             nan     0.1000    0.0533
    ##      4        1.4722             nan     0.1000    0.0438
    ##      5        1.4445             nan     0.1000    0.0425
    ##      6        1.4187             nan     0.1000    0.0382
    ##      7        1.3925             nan     0.1000    0.0302
    ##      8        1.3724             nan     0.1000    0.0306
    ##      9        1.3528             nan     0.1000    0.0291
    ##     10        1.3333             nan     0.1000    0.0239
    ##     20        1.1996             nan     0.1000    0.0127
    ##     40        1.0421             nan     0.1000    0.0078
    ##     60        0.9415             nan     0.1000    0.0062
    ##     80        0.8675             nan     0.1000    0.0039
    ##    100        0.8108             nan     0.1000    0.0041
    ##    120        0.7610             nan     0.1000    0.0035
    ##    140        0.7203             nan     0.1000    0.0028
    ##    150        0.7019             nan     0.1000    0.0013
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1447
    ##      2        1.5179             nan     0.1000    0.1021
    ##      3        1.4529             nan     0.1000    0.0811
    ##      4        1.4005             nan     0.1000    0.0717
    ##      5        1.3540             nan     0.1000    0.0685
    ##      6        1.3118             nan     0.1000    0.0557
    ##      7        1.2759             nan     0.1000    0.0506
    ##      8        1.2440             nan     0.1000    0.0433
    ##      9        1.2162             nan     0.1000    0.0402
    ##     10        1.1907             nan     0.1000    0.0339
    ##     20        1.0104             nan     0.1000    0.0222
    ##     40        0.8132             nan     0.1000    0.0103
    ##     60        0.6942             nan     0.1000    0.0067
    ##     80        0.6086             nan     0.1000    0.0043
    ##    100        0.5460             nan     0.1000    0.0031
    ##    120        0.4914             nan     0.1000    0.0036
    ##    140        0.4504             nan     0.1000    0.0028
    ##    150        0.4299             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1849
    ##      2        1.4935             nan     0.1000    0.1316
    ##      3        1.4108             nan     0.1000    0.1025
    ##      4        1.3467             nan     0.1000    0.0873
    ##      5        1.2921             nan     0.1000    0.0826
    ##      6        1.2404             nan     0.1000    0.0736
    ##      7        1.1943             nan     0.1000    0.0563
    ##      8        1.1574             nan     0.1000    0.0521
    ##      9        1.1243             nan     0.1000    0.0397
    ##     10        1.0985             nan     0.1000    0.0496
    ##     20        0.8804             nan     0.1000    0.0246
    ##     40        0.6677             nan     0.1000    0.0125
    ##     60        0.5479             nan     0.1000    0.0071
    ##     80        0.4680             nan     0.1000    0.0045
    ##    100        0.4049             nan     0.1000    0.0038
    ##    120        0.3541             nan     0.1000    0.0030
    ##    140        0.3128             nan     0.1000    0.0020
    ##    150        0.2965             nan     0.1000    0.0014
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.0896
    ##      2        1.5510             nan     0.1000    0.0648
    ##      3        1.5090             nan     0.1000    0.0517
    ##      4        1.4758             nan     0.1000    0.0477
    ##      5        1.4446             nan     0.1000    0.0424
    ##      6        1.4178             nan     0.1000    0.0352
    ##      7        1.3949             nan     0.1000    0.0350
    ##      8        1.3724             nan     0.1000    0.0290
    ##      9        1.3534             nan     0.1000    0.0252
    ##     10        1.3366             nan     0.1000    0.0292
    ##     20        1.2028             nan     0.1000    0.0132
    ##     40        1.0478             nan     0.1000    0.0093
    ##     60        0.9444             nan     0.1000    0.0066
    ##     80        0.8726             nan     0.1000    0.0043
    ##    100        0.8137             nan     0.1000    0.0031
    ##    120        0.7644             nan     0.1000    0.0033
    ##    140        0.7233             nan     0.1000    0.0017
    ##    150        0.7061             nan     0.1000    0.0021
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1431
    ##      2        1.5200             nan     0.1000    0.1045
    ##      3        1.4533             nan     0.1000    0.0857
    ##      4        1.3990             nan     0.1000    0.0712
    ##      5        1.3534             nan     0.1000    0.0642
    ##      6        1.3134             nan     0.1000    0.0587
    ##      7        1.2758             nan     0.1000    0.0517
    ##      8        1.2430             nan     0.1000    0.0451
    ##      9        1.2149             nan     0.1000    0.0415
    ##     10        1.1879             nan     0.1000    0.0304
    ##     20        1.0109             nan     0.1000    0.0155
    ##     40        0.8222             nan     0.1000    0.0112
    ##     60        0.6996             nan     0.1000    0.0060
    ##     80        0.6152             nan     0.1000    0.0047
    ##    100        0.5489             nan     0.1000    0.0034
    ##    120        0.4977             nan     0.1000    0.0021
    ##    140        0.4558             nan     0.1000    0.0018
    ##    150        0.4384             nan     0.1000    0.0017
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1871
    ##      2        1.4941             nan     0.1000    0.1281
    ##      3        1.4138             nan     0.1000    0.1039
    ##      4        1.3494             nan     0.1000    0.0992
    ##      5        1.2885             nan     0.1000    0.0776
    ##      6        1.2399             nan     0.1000    0.0713
    ##      7        1.1961             nan     0.1000    0.0555
    ##      8        1.1611             nan     0.1000    0.0485
    ##      9        1.1295             nan     0.1000    0.0550
    ##     10        1.0952             nan     0.1000    0.0415
    ##     20        0.8880             nan     0.1000    0.0224
    ##     40        0.6719             nan     0.1000    0.0107
    ##     60        0.5542             nan     0.1000    0.0062
    ##     80        0.4697             nan     0.1000    0.0042
    ##    100        0.4072             nan     0.1000    0.0037
    ##    120        0.3588             nan     0.1000    0.0022
    ##    140        0.3196             nan     0.1000    0.0022
    ##    150        0.3021             nan     0.1000    0.0015
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1        1.6094             nan     0.1000    0.1773
    ##      2        1.4928             nan     0.1000    0.1321
    ##      3        1.4106             nan     0.1000    0.1043
    ##      4        1.3453             nan     0.1000    0.0862
    ##      5        1.2912             nan     0.1000    0.0736
    ##      6        1.2443             nan     0.1000    0.0692
    ##      7        1.2000             nan     0.1000    0.0603
    ##      8        1.1631             nan     0.1000    0.0602
    ##      9        1.1257             nan     0.1000    0.0452
    ##     10        1.0970             nan     0.1000    0.0372
    ##     20        0.8913             nan     0.1000    0.0240
    ##     40        0.6776             nan     0.1000    0.0097
    ##     60        0.5614             nan     0.1000    0.0062
    ##     80        0.4807             nan     0.1000    0.0039
    ##    100        0.4258             nan     0.1000    0.0025
    ##    120        0.3768             nan     0.1000    0.0021
    ##    140        0.3373             nan     0.1000    0.0017
    ##    150        0.3202             nan     0.1000    0.0013

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

Using this model for the data to answer the test in cursera:

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
