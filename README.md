# Crop Yield Prediction

## Problem
Agricultural productivity is highly dependent on multiple factors such as rainfall, temperature, soil conditions, and regional variations. Farmers often lack data-driven insights to accurately estimate crop yield, which can lead to poor planning, financial losses, and inefficient resource utilization.

##  Solution
This project aims to build a data-driven system that predicts crop yield using historical agricultural and environmental data. By analyzing key factors like climate conditions and soil parameters, the model will help provide more accurate yield predictions, enabling better decision-making for farmers and stakeholders.

## Dataset Used

# Phase 1
## Merging Process
-Loaded all three datasets into R.
-Merged the crop dataset with the soil dataset using the common column state.
-Merged the resulting dataset with the weather dataset using the common columns state and year.
-Used left joins to retain all records from the crop dataset.

## Final Dataset
-Total Rows: 19,689
-Total Columns: 16
-Combined features from crop, soil, and weather data into a single dataset.

## Output File
The merged dataset is saved at:
data/raw/crop_yield_merged.csv