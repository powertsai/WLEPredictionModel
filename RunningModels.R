#source function created for this assignment
source("WLEWriteUp.R")

#load train data
trainData <- read.csv("pml-training.csv", header = TRUE, sep=",")

#load test data to validate the model for project assignment
testData <-  read.csv("pml-testing.csv", header = TRUE, sep=",")

#plot for the distribution of classe
barplot(table(trainData$classe), xlab="classe", ylab="quantity", 
        main="Quantity by classes - Weight Lifting Exercise training dataset", col=c(2:6))


#using rpart algorithm to train model
print("rpart ")
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.7)
(modFit <- runRFModel(data = pData,  modDir = "RPART70/", method="rpart", 
                      preProcess= "pca") )
testCase <- cleanData(data = testData)
testCase <- testCase[,c(1:52)]
testPred <- predict(modFit$mod, testCase)
pml_write_files(testPred, modDir= "RPART70/")  


#Parallel Random Forest
print("run parRF");
cData <- cleanData(trainData);
pData <- probeData(cData, 0.7);
modDir = "parRF70/"
(modFit1 <- runRFModel(data = pData,  modDir = modDir, method = "parRF", prox=TRUE) );
testCase <- cleanData(data = testData);
testCase <- testCase[,-length(names(testCase))];
testPred <- predict(modFit1$mod, testCase);
pml_write_files(testPred, modDir= modDir) ;

#Parallel Random Forest with custom train Control
print("run parRF with trainControl")
modDir <- "parRF70Ctrl/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.7)
(modFit2 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE, prox=TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit2$mod, testCase)
pml_write_files(testPred, modDir= modDir) 


print("run parRF prob=0.6 with trainControl Number = 8")
modDir <- "parRF60CtrlN8/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.6)
(modFit3 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 8)
                       ,importance = TRUE, prox=TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit3$mod, testCase)
pml_write_files(testPred, modDir= modDir) 

print("run RF prob=0.6 with trainControl Method=cv Number = 4")
modDir <- "RF60CtrlN4/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.6)
(modFit4 <- runRFModel(data = pData,  modDir = modDir , method = "rf"
                       ,preProcess= "pca"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE, prox=TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit4$mod, testCase)
pml_write_files(testPred, modDir= modDir) 




print("run RF prob=0.7")
modDir <- "RF70CV5/"
(modFit5 <- runRFModel(data = pData,  modDir = modDir , method = "rf" , 
                       trControl = trainControl(method = "cv",  number = 4), 
                       importance = TRUE, prox=TRUE))
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit5$mod, testCase)
pml_write_files(testPred, modDir= modDir) 


print("run RF All Columns nTree 250")
modDir <- "RF70ALL/"
(modFit6 <- runRFModel(data = pData,  modDir = modDir , method = "rf" , 
                       ntree=250 ,
                       trControl = trainControl(method = "cv",  number = 4), 
                       importance = TRUE, prox=TRUE))
testPred <- predict(modFit6$mod, testData)
pml_write_files(testPred, modDir= modDir) 


