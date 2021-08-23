library(tidyverse)
library(data.table)
pollutantmean <- function(directory, pollutant, id = 1:332) {
  # create path name 
  paths <- paste(directory,"/",formatC(id, width=3, flag="0"),".csv",sep = "" )
  
  # read data, only needed column and make a list
  lst <- lapply(paths, data.table::fread, select=c(pollutant))
  
  # combine lists
  df <- rbindlist(lst)
  
  # calculate mean
  mean(df[[1]], na.rm=TRUE)
  }


complete <- function(directory, id = 1:332) {
  # create directory full name
  paths <- paste(directory, "/", formatC(id, width=3, flag="0"), ".csv", sep="")
  
  # change into list of data frames
  df_list <- lapply(paths, data.table::fread)
  
  # calculate number of complete cases
  nobs <- sapply(df_list, function(x) sum(complete.cases(x)))
  
  # create data.frame
  data.frame(id = id, nobs = nobs)
}


corr <- function(directory = 'specdata', threshold = 0) {

  # filter files according to the number of threshold 
  complete_df <- complete(directory)
  
  if (threshold > max(complete_df$nobs)) {
    return ("No such limit")
  }
  
  complete_threshold <- subset(complete_df, nobs > threshold)
  
  # import files that are compatible with threshold 
  paths <- paste(directory, "/", formatC(complete_threshold$id, width=3, flag="0"),".csv", sep="")
  
  df_list <- lapply(paths, data.table::fread, select=c('sulfate','nitrate','ID'))
  df <- rbindlist(df_list)
  
  # calculate cor
  corr_df <- df %>%
    group_by(ID) %>%
    summarize(corr = cor(sulfate, nitrate, use="complete.obs"))
  corr_df$corr
}
  









