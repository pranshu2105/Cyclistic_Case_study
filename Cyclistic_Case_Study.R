# 1. Download the libraries needed

library(tidyverse)
library(janitor)
library(lubridate)
library(skimr)

# 2. Remove any data from the environment

rm(list=ls())

# 3. Reading data sets

ds1 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202107-divvy-tripdata.csv")
colnames(ds1)
ds2 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202108-divvy-tripdata.csv")
colnames(ds2)
ds3 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202109-divvy-tripdata.csv")
colnames(ds3)
ds4 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202110-divvy-tripdata.csv")
colnames(ds4)
ds5 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202111-divvy-tripdata.csv")
colnames(ds5)
ds6 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202112-divvy-tripdata.csv")
colnames(ds6)
ds7 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202201-divvy-tripdata.csv")
colnames(ds7)
ds8 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202202-divvy-tripdata.csv")
colnames(ds8)
ds9 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202203-divvy-tripdata.csv")
colnames(ds9)
ds10 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202204-divvy-tripdata.csv")
colnames(ds10)
ds11 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202205-divvy-tripdata.csv")
colnames(ds11)
ds12 <- read.csv("C:/Users/Hp/Desktop/Case Study 1/CSV Files/202206-divvy-tripdata.csv")
colnames(ds12)

# 4. Making sure that the the columns have the same type

compare_df_cols(ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9,ds10,ds11,ds12,return = "mismatch")


# 5. Combining Data sets and removing empty rows and columns if any

bike_rides_global <- rbind(ds1,ds2,ds3,ds4, ds5, ds6,ds7,ds8,ds9,ds10,ds11,ds12)
bike_rides_global <- janitor::remove_empty(bike_rides_global,which = c("cols"))
bike_rides_global <- janitor::remove_empty(bike_rides_global,which = c("rows"))
dim(bike_rides_global)

# 6. Summary of the data frame

skim_without_charts(bike_rides_global)

# 7. Processing datetime

bike_rides_global$started_at <- lubridate::ymd_hms(bike_rides_global$started_at)
bike_rides_global$ended_at <- lubridate::ymd_hms(bike_rides_global$ended_at)

# 8. Creating start and end hour fields

bike_rides_global$start_hour <- lubridate::hour(bike_rides_global$started_at)
bike_rides_global$end_hour <- lubridate::hour(bike_rides_global$ended_at)

# 9. Creating ride_length field

bike_rides_global$ride_length_hours <- difftime(bike_rides_global$ended_at,bike_rides_global$started_at,units="hours")
bike_rides_global$ride_length_mins <- difftime(bike_rides_global$ended_at,bike_rides_global$started_at,units="mins")

# 10. Creating day_of_the_week fields

bike_rides_global$day_of_week_letter <- lubridate::wday(bike_rides_global$started_at,abbr = TRUE,label = TRUE)
bike_rides_global$day_of_week_number <- lubridate::wday(bike_rides_global$started_at)

# 11. summary of data

skim_without_charts(bike_rides_global)

# 12. Removing Na

bike_rides_global_no_na  <- drop_na(bike_rides_global)
rm(bike_rides_global)

# 13. Removing Duplicates

bike_rides_global_no_na <- distinct(bike_rides_global_no_na)

# 14. Removing negative ride length and quality check rows

bike_rides_global_no_na_length_correct <- bike_rides_global_no_na %>% filter(ride_length_mins>0)
rm(bike_rides_global_no_na)
rm(ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9,ds10,ds11,ds12)

## summary of data

skim_without_charts(bike_rides_global_no_na_length_correct)

## Saved the final data frame into csv file by using below command
## write_csv(bike_rides_global_no_na_length_correct,"divvy_dataset_cleaned.csv")
