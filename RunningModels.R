#load train data
trainData <- read.csv("pml-training.csv", header = TRUE, sep=",")

#load test data to validate the model for project assignment
testData <-  read.csv("pml-testing.csv", header = TRUE, sep=",")

#plot for the distribution of classe
barplot(table(trainData$classe), xlab="classe", ylab="quantity", 
        main="Quantity by classes - Weight Lifting Exercise training dataset", col=c(2:6))

#source function created for this assignment
source("WLEWriteUp.R")

#using rpart algorithm to train model
print("rpart ")
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.7)
(modFit <- runRFModel(data = pData,  modDir = "RPART70/", method="rpart", preProcess= "pca") )
testCase <- cleanData(data = testData)
testCase <- testCase[,c(1:52)]
testPred <- predict(modFit, testCase)
pml_write_files(testPred, modDir= "RPART70/")  


# apply fitted model to pml-testng.csv
print("run parRF")
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.7)
(modFit1 <- runRFModel(data = pData,  modDir = "parRF70/", method = "parRF") )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit1, testCase)
pml_write_files(testPred, modDir= "parRF70/") 
saveRDS(modFit1,file = "parRF70/modFit.RData")
#load("irisrf.RData")



print("run parRF with trainControl")
modDir <- "parRF70Ctrl/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.7)
(modFit2 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE) )
modFit2 <- load(file = "parRF70Ctrl/modFit.RData")

testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit2, testCase)
pml_write_files(testPred, modDir= modDir) 
saveRDS(modFit2, file = paste0(modDir,"modFit.RData"))
?read
print("run parRF prob=0.6 with trainControl Number = 8")
modDir <- "parRF60CtrlN8/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.6)
(modFit3 <- runRFModel(data = pData,  modDir = modDir , method = "parRF"
                       ,trControl = trainControl(method = "cv",  number = 8)
                       ,importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit3, testCase)
pml_write_files(testPred, modDir= modDir) 

saveRDS(modFit3, file = paste0(modDir,"modFit.RData"))



print("run RF prob=0.6 with trainControl Method=cv Number = 4")
modDir <- "RF60CtrlN4/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.6)
(modFit4 <- runRFModel(data = pData,  modDir = modDir , method = "rf"
                       ,trControl = trainControl(method = "cv",  number = 4)
                       ,importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit4, testCase)
pml_write_files(testPred, modDir= modDir) 
saveRDS(modFit4, file = paste0(modDir,"modFit.RData"))


print("run RF prob=0.8")
modDir <- "RF80/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.8)
(modFit5 <- runRFModel(data = pData,  modDir = modDir , method = "rf", importance = TRUE))
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit5, testCase)
pml_write_files(testPred, modDir= modDir) 
saveRDS(modFit5, file = paste0(modDir,"modFit.RData"))   

# 
print("run RF prob=0.5 with trainControl Method=cv Number = 4")
modDir <- "RF50NACtrlN4/"
cData <- cleanData(data = trainData)
pData <- probeData(cData, 0.5)
(modFit6 <- runRFModel(data = pData,  modDir = modDir , 
                       method = "rf",
                       trControl = trainControl(method = "cv",  number = 4),
                       importance = TRUE) )
testCase <- cleanData(data = testData)
testCase <- testCase[,-length(names(testCase))]
testPred <- predict(modFit6, testCase)
pml_write_files(testPred, modDir= modDir) 
saveRDS(modFit6, file = paste0(modDir,"modFit.RData")) 

str(modFit6)
