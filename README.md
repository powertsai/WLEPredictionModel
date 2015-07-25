##Weight Lifting Exercise Prediction Assignment
<<<<<<< HEAD
In this assignment, I create two R scripts help me to run model with different parameters, and save the results to different directories for me to pickup the model with better accuracy

1. WLEWriteUp.R script used to to build the model for this assignment
  1. cleanData function(data) return cleanData
     1. keep measurement value and classe only
     2. romove column with missing values
     3. uses nearZeroVar to remove nzv, zeroVar columns
  2. probeData function(cleanData, prob) return pData
     1. creates train/test data set by Data Partition with p = 0.7
  3. runRFModel function(data = pData, modDir = "NZV", ...) return modFit
     1. train model modFit by data$training
     1. predict data$testing by modFit
     1. create confusionMatrix by testing$classe and predicted value
     1. save confusionMatrix$overall , confusionMatrix$byClass
     1. plot the frequency of predict v.s. actual and save image
  4. pml_write_files = function(x, modDir)
     1. write prediction of 20 new testing cases with assignment format
1. RunningModels.R script used to train model with different parameters, save confusionMatrix, and predict 20 new test cases and writes prediction result for this assignment
  1. cData <- cleanData(data = trainData)
  2. pData <- probeData(cData, 0.7)
  3. (modFit <- runRFModel(data = pData,  modDir = "RPART70/", method="rpart", preProcess= "pca") )
  4. testPred <- predict(modFit, testCase)
  5. pml_write_files(testPred, modDir= "RPART70/")  
1. index.Rmd: R markdown shows how I build the model to predict the 20 testing cases
2. index.html, index_files:  the compiled html from R markdwon
=======
1. steps to build the model for this assignment
  1. cleaning the data 
     1. keep measurement value and classe only
     2. romove column with missing values
     3. uses nearZeroVar to remove nzv, zeroVar columns
  2. creates train/test data set by Data Partition with p = 0.7
  3. Uses random forest algorithm to train model
  4. predict test case with the trainned model
  5. use confusionMatrix to check the accuracy of the model
  6. use the model to predict the classe for the twenty test cases

## Cross validation
1. create runRFModel (pData, modDir) , help to run model and save the overall accuracy
   2. train modelFit by pData$training
   3. predict pData$testing by modFit
   4. create confusionMatrix by predicted value v.s. pData$testing$classe
   5. save result overall & accuracy byClass to modDir
   6. plot confusion matrix by ggplot and save images to modDir
1. Parametes changes for cross validation
    1.  using different prob to create data partition for trainiing (0.5, 0.6, 0.7)
    1.  change trainControl number 

## what you think the expected out of sample error is
1. why you made the choices you did

## predict 20 different test cases. 
>>>>>>> 54fb9a009409165ab9359df2a9aefdead5782b0b
