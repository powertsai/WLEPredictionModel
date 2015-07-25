## Weight Lifting Exercise Prediction Assignment
In this assignment, I create two R scripts help me to run model with different parameters, and save the results to different directories for me to pickup the model with better accuracy
1. index.Rmd: R markdown shows codes training model to predict the 20 testing cases
1. [compiled html from R markdwon](http://powertsai.github.io/WLEPredictionModel/)
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
