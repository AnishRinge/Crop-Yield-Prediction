# Crop Yield Prediction

## Problem
Agricultural productivity is highly dependent on multiple factors such as rainfall, temperature, soil conditions, and regional variations. Farmers often lack data-driven insights to accurately estimate crop yield, which can lead to poor planning, financial losses, and inefficient resource utilization.

##  Solution
This project aims to build a data-driven system that predicts crop yield using historical agricultural and environmental data. By analyzing key factors like climate conditions and soil parameters, the model will help provide more accurate yield predictions, enabling better decision-making for farmers and stakeholders.

## Dataset Used

## Phase 1
### Data Merging Process

The initial phase of the project involved integrating multiple datasets into a single unified dataframe (`df`) to enable comprehensive analysis. The final merged dataset consists of **19,689 observations and 16 variables**, combining crop, soil, and weather information.

---

#### 1. Dataset Loading

All three datasets were loaded into R as separate dataframes:

```r
df1 <- read.csv("crop_data.csv")
df2 <- read.csv("soil_data.csv")
df3 <- read.csv("weather_data.csv")
```

* `df1`: Crop dataset
* `df2`: Soil dataset
* `df3`: Weather dataset

---

#### 2. Initial Structure Verification

Each dataset was inspected to ensure consistency in column names and data types using:

```r
str(df1)
str(df2)
str(df3)
colnames(df1)
colnames(df2)
colnames(df3)
```

Key observations:

* Common column across all datasets: `state`
* Weather dataset also contained `year`, aligning with crop dataset
* Column names were consistent and required no renaming

---

#### 3. Merging Crop and Soil Data

The crop dataset (`df1`) was merged with the soil dataset (`df2`) using the common column `state`:

```r
df_merged1 <- df1 %>%
  left_join(df2, by = "state")
```

* A **left join** was used to retain all crop records
* Soil features (`N`, `P`, `K`, `pH`) were appended to each state

---

#### 4. Merging Weather Data

The intermediate dataset (`df_merged1`) was further merged with the weather dataset (`df3`) using both `state` and `year`:

```r
df <- df_merged1 %>%
  left_join(df3, by = c("state", "year"))
```

* Ensured correct alignment of yearly weather data with crop records
* Added weather features:

  * `avg_temp_c`
  * `total_rainfall_mm`
  * `avg_humidity_percent`

---

#### 5. Post-Merge Validation

The merged dataset was validated using:

```r
dim(df)
head(df)
```

* Rows remained unchanged: **19,689** (no duplication)
* Columns increased to: **16**
* All expected features were successfully integrated

---

#### 6. Data Storage

The final merged dataset was saved for further processing:

```r
write.csv(df, "data/raw/crop_yield_merged.csv", row.names = FALSE)
```

---

### Final Outcome

The resulting dataset:

* Successfully integrates crop, soil, and weather data
* Maintains all original crop records without duplication
* Aligns state-wise and year-wise information correctly
* Is structured and ready for preprocessing and analysis

This dataset serves as the foundational input for subsequent data cleaning, EDA, and model development phases.

## Phase 2
### Data Cleaning Process

After merging the datasets into a single dataframe (`df`) consisting of 19,689 observations and 16 variables, a systematic data cleaning process was performed to ensure data quality and reliability before conducting Exploratory Data Analysis (EDA) and model building.

#### 1. Structure and Data Type Inspection

The structure of the dataset was examined using functions such as `str()`, `summary()`, and `colnames()`.

* Categorical variables identified: `crop`, `season`, `state`
* Numerical variables identified: `year`, `area`, `production`, `fertilizer`, `pesticide`, `yield`, `N`, `P`, `K`, `pH`, `avg_temp_c`, `total_rainfall_mm`, `avg_humidity_percent`

This step ensured that all variables were correctly interpreted and suitable for further processing.

---

#### 2. Missing Value Analysis

Missing values were checked using:

```r
colSums(is.na(df))
```

* Result: No missing values were found in any column.
* Conclusion: No imputation or removal was required.

---

#### 3. Removal of Invalid Records

Certain records contained logically inconsistent values:

* `area = 0`
* `production = 0`

Since yield depends on production and area, such entries were considered invalid and removed:

```r
df <- df %>% filter(area > 0, production > 0)
```

* Rows reduced from **19,689 to 19,577**
* A total of **112 invalid records** were removed

---

#### 4. Duplicate Record Check

Duplicate rows were checked using:

```r
sum(duplicated(df))
```

* Result: 0 duplicate records
* Conclusion: No duplicate removal was necessary

---

#### 5. Feature Variability Check

To identify constant or low-variance features, the number of unique values in each column was computed:

```r
sapply(df, function(x) length(unique(x)))
```

* All features showed sufficient variability
* No constant or redundant columns were found
* Soil parameters (`N`, `P`, `K`, `pH`) had moderate variation but were retained as meaningful agronomic features

---

#### 6. Data Type Conversion

Categorical variables were explicitly converted into factor type:

```r
df$crop <- as.factor(df$crop)
df$season <- as.factor(df$season)
df$state <- as.factor(df$state)
```

This ensures proper handling in statistical models and machine learning algorithms.

---

### Final Outcome

The dataset is now:

* Free from missing values
* Free from duplicates
* Cleansed of invalid records
* Verified for feature variability
* Properly formatted for further analysis

This cleaned dataset is now ready for Exploratory Data Analysis (EDA) and model development.

## Phase 3
