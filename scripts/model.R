#Load libraries
library(dplyr)
library(caret)

#Load cleaned dataset
df <- read.csv("E:/Projects/Crop-Yield-Prediction/data/processed/cleaned_crop_yield.csv")

#Convert categorical variables
df$crop <- as.factor(df$crop)
df$season <- as.factor(df$season)
df$state <- as.factor(df$state)

#Create target variable
df$log_yield <- log1p(df$yield)

#Remove leakage columns
df <- df %>% select(-production, -yield)

#Reduce crop categories
top_crops <- names(sort(table(df$crop), decreasing = TRUE))[1:50]

df$crop <- ifelse(df$crop %in% top_crops, df$crop, "Other")
df$crop <- as.factor(df$crop)

#Train-test split
set.seed(42)
trainIndex <- createDataPartition(df$log_yield, p = 0.8, list = FALSE)

train <- df[trainIndex, ]
test <- df[-trainIndex, ]

#Check dimensions
dim(train)
dim(test)

#Train Random Forest
library(randomForest)

model_rf <- randomForest(log_yield ~ ., data = train)
model_rf

#Predict on test data
pred_rf <- predict(model_rf, test)

#Calculate RMSE
rmse_rf <- sqrt(mean((pred_rf - test$log_yield)^2))
rmse_rf

#Feature Importance
png("E:/Projects/Crop-Yield-Prediction/EDA/feature_importance.png")
varImpPlot(model_rf)
dev.off()


library(xgboost)
#Convert data to matrix for XGBoost
train_matrix <- model.matrix(log_yield ~ . -1, data = train)
test_matrix  <- model.matrix(log_yield ~ . -1, data = test)

#Target variable
train_label <- train$log_yield
test_label  <- test$log_yield

#Train XGBoost
model_xgb <- xgboost(
  x = train_matrix,
  y = train_label,
  nrounds = 100,
  objective = "reg:squarederror"
)

pred_xgb <- predict(model_xgb, test_matrix)
rmse_xgb <- sqrt(mean((pred_xgb - test_label)^2))
rmse_xgb

install.packages("gbm")
library(gbm)

#Train GBM model
model_gbm <- gbm(
  formula = log_yield ~ .,
  data = train,
  distribution = "gaussian",
  n.trees = 100,
  interaction.depth = 4,
  shrinkage = 0.1,
  n.minobsinnode = 10,
  verbose = FALSE
)

pred_gbm <- predict(model_gbm, test, n.trees = 100)
rmse_gbm <- sqrt(mean((pred_gbm - test$log_yield)^2))
rmse_gbm

#Convert predictions back to actual yield
pred_yield <- exp(pred_rf) - 1

#Convert actual test values too
actual_yield <- exp(test$log_yield) - 1

#Create comparison dataframe
results <- data.frame(
  Actual = actual_yield,
  Predicted = pred_yield
)

head(results)

#Plot actual vs predicted
png("E:/Projects/Crop-Yield-Prediction/EDA/actual_vs_predicted.png")

plot(actual_yield, pred_yield,
     xlab="Actual Yield",
     ylab="Predicted Yield",
     main="Actual vs Predicted Yield")

abline(0,1,col="red")  #perfect prediction line

dev.off()