library(readxl)
library(dplyr)
install.packages("readr")
library(readr)
df1 <- read_csv("E:/Projects/Crop-Yield-Prediction/Crop-Yield/crop_yield.csv")
df2 <- read_csv("E:/Projects/Crop-Yield-Prediction/Crop-Yield/state_soil_data.csv")
df3 <- read_csv("E:/Projects/Crop-Yield-Prediction/Crop-Yield/state_weather_data_1997_2020.csv")

df_merged1 <- df1 %>%
  left_join(df2, by = "state")
dim(df_merged1)
head(df_merged1)

df_final <- df_merged1 %>%
  left_join(df3, by = c("state", "year"))
dim(df_final)
head(df_final)

write.csv(df_final,
          "E:/Projects/Crop-Yield-Prediction/data/raw/crop_yield_merged.csv",
          row.names = FALSE)

str(df_final)
summary(df_final)

colSums(is.na(df_final))
colSums(df_final == 0)

