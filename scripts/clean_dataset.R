library(dplyr)

df <- read.csv("E:/Projects/Crop-Yield-Prediction/data/raw/crop_yield_merged.csv")

dim(df)
str(df)
summary(df)
colnames(df)

colSums(is.na(df))

df <- df %>%
  filter(area > 0, production > 0)
dim(df)

sum(duplicated(df))

sapply(df, function(x) length(unique(x)))

df$crop <- as.factor(df$crop)
df$season <- as.factor(df$season)
df$state <- as.factor(df$state)

write.csv(df, "E:/Projects/Crop-Yield-Prediction/data/processed/cleaned_crop_yield.csv", row.names = FALSE)