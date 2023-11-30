library(dplyr)
library(stringr)
library(ggplot2)
library(testthat)

conditions_covid <- read.csv("Conditions_Contributing_to_COVID-19_Deaths__by_State_and_Age__Provisional_2020-2023 (2).csv")
death_counts <- read.csv("Weekly_Provisional_Counts_of_Deaths_by_State_and_Select_Causes__2020-2023 (1).csv")

conditions_covid <- conditions_covid[!duplicated(conditions_covid$State), ]
death_counts <- death_counts[!duplicated(death_counts$Jurisdiction.of.Occurrence), ]

df <- left_join(conditions_covid, death_counts, by = c("State" = "Jurisdiction.of.Occurrence"))
                
df <- df[, -c(1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 14, 15, 16, 17, 18, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48)]

df$Difference_of_death_and_covid_deaths <- c(df$All.Cause - df$COVID.19.Deaths)

df$Numerical_category_of_number_of_all_cause_deaths <- as.factor(ifelse(df$All.Cause < 100, '0 - 100',
                                                     ifelse(df$All.Cause < 500, '100 - 500', 
                                                     ifelse(df$All.Cause < 1000, '500 - 1000', 
                                                     ifelse(df$All.Cause < 3000, '1000 - 3000',
                                                     ifelse(df$All.Cause < 5000, '3000 - 5000',
                                                     ifelse(df$All.Cause < 10000, '5000 - 10000', 'greater than 10000')))))))
  


print(df)
write.csv(df, "C:\\Users\\Ron\\Desktop\\Test\\Final_Project_Data.csv", row.names=FALSE)
