library(dplyr)

df <- read.csv("E:/Projects/Crop-Yield-Prediction/data/processed/cleaned_crop_yield.csv")

str(df)
summary(df)

eda_path <- "E:/Projects/Crop-Yield-Prediction/EDA/"

#Histogram
png(paste0(eda_path, "yield_hist.png"), width=800, height=600)
hist(df$yield, breaks=50, main="Yield Distribution", col="lightblue")
dev.off()

df$log_yield <- log1p(df$yield)
png(paste0(eda_path, "log_yield_hist.png"), width=800, height=600)
hist(df$log_yield, breaks=50, main="Log Yield Distribution", col="lightgreen")
dev.off()

#Boxplot
png(paste0(eda_path, "log_yield_boxplot.png"), width=800, height=600)
boxplot(df$log_yield, main="Log Yield Boxplot")
dev.off()

#yield by crop
library(ggplot2)

png(paste0(eda_path, "yield_by_crop.png"), width=1200, height=600)
ggplot(df, aes(x=crop, y=log_yield)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle=90))
dev.off()

#yield by season
png(paste0(eda_path, "yield_by_season.png"), width=800, height=600)
ggplot(df, aes(x=season, y=log_yield)) +
  geom_boxplot()
dev.off()

#correlation between factors and yield
num_df <- df %>% select(where(is.numeric))

cor_matrix <- cor(num_df)

png(paste0(eda_path, "correlation_heatmap.png"))
heatmap(cor_matrix)
dev.off()

#Removing data leakage columns
df <- df %>% select(-production, -yield)
colnames(df)

#Temperature vs yield scatter plot
png(paste0(eda_path, "temp_vs_yield.png"))
plot(df$avg_temp_c, df$log_yield,
     main="Temperature vs Log Yield",
     xlab="Temperature",
     ylab="Log Yield")
dev.off()

#Rainfall vs yield scatter plot
png(paste0(eda_path, "rainfall_vs_yield.png"))
plot(df$total_rainfall_mm, df$log_yield,
     main="Rainfall vs Log Yield",
     xlab="Rainfall",
     ylab="Log Yield")
dev.off()

#Fertilizer vs yield scatter plot
png(paste0(eda_path, "fertilizer_vs_yield.png"))
plot(df$fertilizer, df$log_yield,
     main="Fertilizer vs Log Yield",
     xlab="Fertilizer",
     ylab="Log Yield")
dev.off()