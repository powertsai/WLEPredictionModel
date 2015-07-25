#cleanData function 
# 1. check is.na to remove columns with missing value
# 2. check NearZeroVar, remove zeroVar  or nzv 
cleanData <- function(data) {
  names(data)
  #remove identification column, keep measurement data only 
  trainData <- data[,-(1:7)]
  
  length(names(trainData))
  apply(trainData, 2, class)
  # convert to numeric for each column , except classe
  for(i in c(1:152)) {
    trainData[,i] <- as.numeric(trainData[,i])
  }

  # remove column with N/A
  naTrainIdx <-apply(trainData, 2, function(x) any(is.na(x)))
  cleanData <- trainData[, which(!naTrainIdx)]
  (names <- names(cleanData) )
  # check every element is not N/A
  sum(is.na(cleanData))
  
  #check NearZeroVar, remove zeroVar  or nzv  
  require(caret)
  (nsv <- nearZeroVar(cleanData, saveMetrics= TRUE) )
  (subset <- row.names(nsv) [which(!nsv$zeroVar & !nsv$nzv)])
  
  require(dplyr)
  cleanData = select(cleanData, which(names(cleanData) %in% subset) )
  (names(cleanData))
  
  return (cleanData)
}

#split the train data into train/test data set to validate model
probeData <- function(cleanData, prob) {
  require(caret)
  set.seed(1000)
  inTrain<-createDataPartition(cleanData$classe,p=prob ,list=FALSE)
  training <- cleanData[inTrain,]
  testing <- cleanData[-inTrain,]
  #head(training)
  return (list(training = training, testing = testing) )
}

#runRFModel function used to 
# train model modFit by data$training
# predict data$testing by modFit
# create confusionMatrix by testing$classe and predicted value
# save confusionMatrix$overall , confusionMatrix$byClass
# plot the frequency of predict v.s. actual and save image
runRFModel <- function(data = pData, modDir = "NZV", ...) {
  #install.packages("e1071")
  require(e1071)
  require(foreach)
  training <- pData$training
  testing <- pData$testing
  
  #train model with input, 
  modFit1 <- train(training$classe ~., data = training, ...)
  print(modFit1)

  #Predicting new values
  pred <- predict(modFit1, testing)
  testing$predRight <- pred==testing$classe
  table(pred, testing$classe)
  
  (cm <- confusionMatrix(testing$classe, pred))
  write.csv(data.frame(overall= cm$overall), file=paste0(modDir, "overall.txt"))
  write.csv(cm$byClass, file = paste0(modDir, "confusionByClass.csv"))
  
  # plot confusion matrix
  require(ggplot2)
  input.matrix <- data.matrix(cm)
  (confusion <- as.data.frame(as.table(input.matrix)))
  
  plot <- ggplot(confusion)
  plot <- plot + geom_tile(aes(x=Var1, y=Var2, fill=Freq)) + 
    scale_x_discrete(name="Actual Classe") + 
    scale_y_discrete(name="Predicted Classe") + 
    scale_fill_gradient(breaks=seq(from=3000, to=0, by=-500), low="pink", high = "red") +
    labs(fill="Frequency") +
    geom_text(aes(x = Var1, y = Var2, label = Freq), size = 3)
  print(plot)
  ggsave(filename=paste0(modDir, "Confusion.jpg"), plot=plot)
  
  return (modFit1)
}

#write prediction txt
pml_write_files = function(x, modDir){
  n = length(x)
  for(i in 1:n){
    filename = paste0(modDir, "problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
