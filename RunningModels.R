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
(modFit <- runRFModel(data = pData,  modDir = "RPART70/", method="rpart", preProcess= "pca") )
testCase <- cleanData(data = testData)
testCase <- testCase[,c(1:52)]
testPred <- predict(modFit, testCase)
pml_write_files(testPred, modDir= "RPART70/")  

pData <- probeData(trainData, 0.7)
modFitXX <- runRFModel(data = pData,  modDir = "parRF70/", method = "parRF" ,prox=TRUE) 
saveRDS(modFitXX, "modFitXX.RData")

#Parallel Random Forest
print("run parRF");
cData <- cleanData(trainData);
pData <- probeData(cData, 0.7);
modDir = "parRF70/"
(modFit1 <- runRFModel(data = pData,  modDir = modDir, method = "parRF") );
testCase <- cleanData(data = testData);
testCase <- testCase[,-length(names(testCase))];
testPred <- predict(modFit1, testCase);
pml_write_files(testPred, modDir= modDir) ;

#Parallel Random Forest with custom train Control
print("run parRF with trainControl")
modDir <- "parRF70Ctrl/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.7)
(modFit2 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit2, testCase)
pml_write_files(testPred, modDir= modDir) 


print("run parRF prob=0.6 with trainControl Number = 8")
modDir <- "parRF60CtrlN8/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.6)
(modFit3 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 8)
                       ,importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit3, testCase)
pml_write_files(testPred, modDir= modDir) 

print("run RF prob=0.6 with trainControl Method=cv Number = 4")
modDir <- "RF60CtrlN4/"
cData <- cleanData(trainData)
pData <- probeData(cData, 0.6)
(modFit4 <- runRFModel(data = pData,  modDir = modDir , method = "rf"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit4, testCase)
pml_write_files(testPred, modDir= modDir) 




print("run RF prob=0.7")
modDir <- "RF70CV5/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.7)

(modFit5 <- runRFModel(data = pData,  modDir = modDir , method = "rf" ,
                       trControl = trainControl(method = "cv",  number = 4), 
                       importance = TRUE))
modResult <- readRDS("RF70CV5/modFit.RData")
modFit5 <- modResult$mod
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit5, testCase)
pml_write_files(testPred, modDir= modDir) 

testing <- pData$testing
require(randomForest)
require(caret)
importance(modFit5$finalModel)
print(modResult$cfMatrix)
pred <- predict(modFit5, testing)
predRight <- pred==testing$classe
table(pred, testing$classe)


head(importance(modFit5$finalModel))
p <- qplot(roll_belt , pitch_belt, col=classe, data=testing)
p + geom_point(aes(x=roll_belt,y= pitch_belt, col="Error"),size=6,shape=4,
               data=testing[which(!predRight), ])



