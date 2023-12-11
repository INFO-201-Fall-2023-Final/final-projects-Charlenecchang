library(dplyr)
library(stringr)
library(shiny)

df <- read.csv("Data_Analysis_of_Diseases_by_State.csv")

get_number_disease_deaths <- function(state) {
  covid <- df$COVID.19.Deaths[df$State == state]
  septicemia <- df$Septicemia..A40.A41.[df$State == state]
  diabetes <- df$Diabetes.mellitus..E10.E14.[df$State == state]
  alzheimer <- df$Alzheimer.disease..G30.[df$State == state]
  pneumonia <- df$Influenza.and.pneumonia..J09.J18.[df$State == state]
  chronic_respiratory <- df$Chronic.lower.respiratory.diseases..J40.J47.[df$State == state]
  nephritis <- df$Nephritis..nephrotic.syndrome.and.nephrosis..N00.N07.N17.N19.N25.N27.[df$State == state]
  cerebrovascular <- df$Cerebrovascular.diseases..I60.I69.[df$State == state]
  
  Number_of_deaths <- c(covid, septicemia, diabetes, alzheimer, pneumonia, chronic_respiratory, nephritis, cerebrovascular)
  
  return(Number_of_deaths)
}

get_count_per_category <- function(df){
  count1 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "0 - 100",])
  count2 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "100 - 500",])
  count3 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "500 - 1000",])
  count4 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "1000 - 3000",])
  count5 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "3000 - 5000",])
  count6 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "5000 - 10000",])
  count7 <- nrow(df[df$Numerical_category_of_number_of_all_cause_deaths == "greater than 10000",])
  category_counts <- c(count1, count2, count3, count4, count5, count6, count7)
  return(category_counts)
}


