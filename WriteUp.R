setwd("/Users/powertsai/Dropbox/R/MachineLearning")
loadLibrary("caret")
loadLibrary("dplyr")
#loadLibrary("tidyr")
#loadLibrary("reshape2")

?read.csv
trainData <- read.csv("pml-training.csv", header = TRUE, sep=",")
barplot(table(training$classe), xlab="classe", ylab="quantity", 
        main="Quantity by classes - Weight Lifting Exercise training dataset", col=c(2:6))

names(trainData)
#remove identification column, keep measurement data only 
trainData <- trainData[,-(1:7)]

length(names(trainData))
apply(trainData, 2, class)
# convert to numeric for each column , except classe
for(i in c(1:152)) {
        trainData[,i] <- as.numeric(trainData[,i])
}

head(trainData)

# remove column with N/A
naTrainIdx <-apply(trainData, 2, function(x) any(is.na(x)))
cleanData <- trainData[, which(!naTrainIdx)]
(names <- names(cleanData) )

# check every element is not N/A
sum(is.na(cleanData))

#check NearZeroVar, remove zeroVar  or nzv
(nsv <- nearZeroVar(cleanData, saveMetrics= TRUE) )
(subset <- row.names(nsv) [which(!nsv$zeroVar & !nsv$nzv)])

subCleanData = select(cleanData, which(names(cleanData) %in% subset) )
(names(subCleanData))
table(subCleanData$classe)

#get train/test data set to check Model
set.seed(1000)
inTrain<-createDataPartition(subCleanData$classe,p=0.5,list=FALSE)
training <- subCleanData[inTrain,]
testing <- subCleanData[-inTrain,]
names(testing)
testingWindows <- trainData[-inTrain, 7] 
head(training)

#install.packages("foreach")
require(foreach)
modFit2 <- train(training$classe ~., method = "rf", data = training, prox=TRUE,
                 importance = TRUE, preProcess="pca")
#                 ,trControl = trainControl(method = "cv",  number = 4)
                 

## Loading required package: randomForest
## randomForest 4.6-10
modFit
## Type rfNews() to see new features/changes/bug fixes.

head(training)
head(testing)
#Predicting new values
pred <- predict(modFit1, testing)
testing$predRight <- pred==testing$classe
table(pred, testing$classe)

qplot(testing$classe, pred ,colour=predRight, data=testing,  main="Testing Data Predictions")
?qplot
cm <- confusionMatrix(testing$classe, pred)
cm
# plot confusion matrix
require(ggplot2)
input.matrix <- data.matrix(cm)
colnames(input.matrix) = c("A", "B", "C", "D", "E")
rownames(input.matrix) = c("A", "B", "C", "D", "E")
as.table(input.matrix)
(confusion <- as.data.frame(as.table(input.matrix)))

plot <- ggplot(confusion)
plot + geom_tile(aes(x=Var1, y=Var2, fill=Freq)) + 
        scale_x_discrete(name="Actual Classe") + 
        scale_y_discrete(name="Predicted Classe") + 
        scale_fill_gradient(breaks=seq(from=3000, to=0, by=-500), low="pink", high = "red") +
        labs(fill="Frequency") +
        geom_text(aes(x = Var1, y = Var2, label = Freq), size = 3)



?ggplot
# apply fitted model to pml-testng.csv
testData <- read.csv("pml-testing.csv")
testPred <- predict(modFit1, testData)
testPred
#write prediction txt
pml_write_files = function(x){
        n = length(x)
        for(i in 1:n){
                filename = paste0("problem_id_",i,".txt")
                write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
        }
}
pml_write_files(testPred)