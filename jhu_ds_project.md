# Background

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
<http://groupware.les.inf.puc-rio.br/har> (see the section on the Weight
Lifting Exercise Dataset).

# Data

The training data for this project are available here:

<https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv>

The test data are available here:

<https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv>

The data for this project come from this source:
<http://groupware.les.inf.puc-rio.br/har>. If you use the document you
create for this class for any purpose please cite them as they have been
very generous in allowing their data to be used for this kind of
assignment.

# Import Libraries and Read the data

    library(caret)

    ## Warning: package 'caret' was built under R version 4.1.2

    ## Loading required package: ggplot2

    ## Loading required package: lattice

    trainUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
    testUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
    training <- read.csv(url(trainUrl), na.strings=c("NA","#DIV/0!",""))
    submit <- read.csv(url(testUrl), na.strings=c("NA","#DIV/0!",""))

# preprocess training data

This dataset contains many NA values and so, I removed the columns where
NA’s values are filled more than 90% of the column. From 1st to 7th
column, I thought that they do not need to contain.

    empty_cols <- which(colSums(is.na(training) |training=="")>0.9*dim(training)[1]) 
    training_clean <- training[, -empty_cols]
    training_clean <- training_clean[, -c(1:7)]
    dim(training_clean)

    ## [1] 19622    53

The same data preprocessing for submitting data.

    # preprocess test data same as training 
    submit_clean <- submit[, -empty_cols]
    submit_clean <- submit_clean[, -c(1:7)]
    dim(submit_clean)

    ## [1] 20 53

# Train-test-split data from training data

For model evaluation, we need to split the data into training and
testing. Here, I used 80% of the data for training and the rest for
testing.

    set.seed(123)
    inTrain <- createDataPartition(training_clean$classe, p=.8, list=FALSE)
    X_train <- training_clean[inTrain, ]
    X_test <- training_clean[-inTrain, ]

# Model Training

I used two models, random forest, and generalized boosted model and used
cross validation with 5 times. As I do not want the computer to run the
model many times, I saved it.

## Random Forest Model

    # random forest model
    trainControl <- trainControl(method='cv', number=5)
    # rf_model <- train(classe ~., data = X_train, method='ranger', trControl=trainControl)
    # saveRDS(rf_model, './rf_model.rds')
    rf_model <- readRDS('~/rf_model.rds')
    rf_predict <- predict(rf_model, X_test)
    confusionMatrix(as.factor(X_test$classe), rf_predict)

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1116    0    0    0    0
    ##          B    1  758    0    0    0
    ##          C    0    0  684    0    0
    ##          D    0    0    2  641    0
    ##          E    0    0    0    0  721
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9992          
    ##                  95% CI : (0.9978, 0.9998)
    ##     No Information Rate : 0.2847          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.999           
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.9991   1.0000   0.9971   1.0000   1.0000
    ## Specificity            1.0000   0.9997   1.0000   0.9994   1.0000
    ## Pos Pred Value         1.0000   0.9987   1.0000   0.9969   1.0000
    ## Neg Pred Value         0.9996   1.0000   0.9994   1.0000   1.0000
    ## Prevalence             0.2847   0.1932   0.1749   0.1634   0.1838
    ## Detection Rate         0.2845   0.1932   0.1744   0.1634   0.1838
    ## Detection Prevalence   0.2845   0.1935   0.1744   0.1639   0.1838
    ## Balanced Accuracy      0.9996   0.9998   0.9985   0.9997   1.0000

Random Forest is a good predictor with accuracy 99.69% and error rate
only about 0.31%. Both sensitivity and specificity for all classes are
also good. Next, I will try with generalized boosted model.

# Generalized Boosted Model

    # gbm_model <- train(classe ~., data = X_train, method='gbm', trControl=trainControl)
    # saveRDS(gbm_model, './gbm_model.rds')
    gbm_model <- readRDS("~/gbm_model.rds")
    gbm_predict <- predict(gbm_model, X_test)
    confusionMatrix(as.factor(X_test$classe), gbm_predict)

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1106    8    2    0    0
    ##          B   13  727   17    2    0
    ##          C    0   16  661    5    2
    ##          D    1    0   16  622    4
    ##          E    1    6    6   10  698
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9722          
    ##                  95% CI : (0.9666, 0.9771)
    ##     No Information Rate : 0.2858          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.9649          
    ##                                           
    ##  Mcnemar's Test P-Value : 0.008876        
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.9866   0.9604   0.9416   0.9734   0.9915
    ## Specificity            0.9964   0.9899   0.9929   0.9936   0.9929
    ## Pos Pred Value         0.9910   0.9578   0.9664   0.9673   0.9681
    ## Neg Pred Value         0.9947   0.9905   0.9873   0.9948   0.9981
    ## Prevalence             0.2858   0.1930   0.1789   0.1629   0.1795
    ## Detection Rate         0.2819   0.1853   0.1685   0.1586   0.1779
    ## Detection Prevalence   0.2845   0.1935   0.1744   0.1639   0.1838
    ## Balanced Accuracy      0.9915   0.9751   0.9672   0.9835   0.9922

It is also a good model, but not good as random forest. Its accuracy is
about 96.05% and sensitivity and specificity are also good. But from
these two models, I will use random forest model for submitting data.

# Applying random forest to validation data

    prediction <- predict(rf_model, submit_clean)
    prediction

    ##  [1] B A B A A E D B A A B C B A E E A B B B
    ## Levels: A B C D E
