# Loaded dplyr package
library(dplyr)
library(stringr)
library(tidyr)
# import data frame
outcome <- read.csv("2-Rprogramming/hospital_data/outcome-of-care-measures.csv", colClasses = "character")
# select the columns that will be used 
selected_table <- outcome %>% 
  select("Hospital.Name",
         "State",
         heart_attack_death = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
         heart_failure_death = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
         pneumonia_death = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
         )

best <- function(state, outcome) {
  # Check that state and outcome are valid
  if (!state %in% selected_table$State | !tolower(outcome) %in% c("heart attack","heart failure","pneumonia")) 
  { stop("invalid outcome")}
  
  else{
    # String manipulation to match with colnames 
    outcome <- str_c(str_replace(outcome," ","_"), "_death")
    
    # filter state 
    states_hospital <- selected_table %>%
      filter(State == state, .data[[outcome]] != "Not Available")
    
    states_hospital[[outcome]] <- as.numeric(states_hospital[[outcome]])
    
    # Select the best hospital 
    best_hospital <- states_hospital %>% arrange(.data[[outcome]], Hospital.Name) %>% head(1)
    return(best_hospital$Hospital.Name)
  }
}


rankhospital <- function(state, outcome, n) {
  # Check that state and outcome are valid
  if (!state %in% selected_table$State | !tolower(outcome) %in% c("heart attack","heart failure","pneumonia")) 
  {stop("invalid outcome")}
  
  
  else{
    # String manipulation to match with colnames 
    outcome <- str_c(str_replace(outcome," ","_"), "_death")
    
    # filter state 
    states_hospital <- selected_table %>%
      filter(State == state, .data[[outcome]] != "Not Available")
    
    states_hospital[[outcome]] <- as.numeric(states_hospital[[outcome]])
    
    # Select the best hospital 
    best_hospitals <- states_hospital %>% arrange(.data[[outcome]], Hospital.Name) %>% mutate(rank = 1:nrow(states_hospital))
    # if (n > nrow(best_hospitals)) { return(NA)}
    return(best_hospitals %>% select("Hospital.Name", rate = outcome, "rank") %>% head(n))
  }
}


rankall <- function(outcome, num = "best") {
  if (!tolower(outcome) %in% c("heart attack","heart failure","pneumonia")) 
  {stop("invalid outcome")}
  
  else{
    # String manipulation to match with colnames 
    outcome <- str_c(str_replace(outcome," ","_"), "_death")
    selected_table[[outcome]] <- as.numeric(selected_table[[outcome]])
    if (num == "best" | is.numeric(num))
    {
      sorted_hospital <- selected_table %>% 
        arrange(.data[[outcome]],.data[["Hospital.Name"]]) %>% 
        mutate(rank = 1:nrow(selected_table))
      
    if (is.numeric(num)) {return (head(sorted_hospital[,1:2], num))}
    else {return (sorted_hospital[,1:2])}
    } 
    
  }
}


selected_table[["heart_attack_death"]] <- as.numeric(selected_table$heart_attack_death)
a <- selected_table %>%
  arrange(heart_attack_death) %>%
  mutate(rank = 1:nrow(selected_table))
head(a)





