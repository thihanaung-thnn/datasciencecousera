library(data.table)
library(dplyr)
library(stringr)
library(readr)

get_col_name_and_index <- function(){
        # I wrote a function to make things clear. 
        # first read and extract features that contain mean() and std()
        feature_names <- data.table::fread("UCIHAR/features.txt")
        mean_name_table <- feature_names[str_detect(feature_names$V2, "mean\\(\\)"), ]
        std_name_table <- feature_names[str_detect(feature_names$V2, "std\\(\\)"), ]
        name_table <- rbind(mean_name_table, std_name_table)
        
        # divide into names and number index 
        names <- unlist(name_table[,2])
        col_index <- unlist(name_table[,1])
        
        # I don't know why data.table::fread can't read data if names are present in 
        # col_index. So, I removed them.
        names(names) <- NULL
        names(col_index) <- NULL
        names <- str_remove(names, "\\(\\)") 
        # return into a list of two. 1 for naming the columns, and 2 for indexing. 
        return (list(names, col_index))
}

col_name <- get_col_name_and_index()

# combine subject_train, X_train (selected columns), y_train by columns 
train_x <- data.table::fread("UCIHAR/train/X_train.txt", col.names = col_name[[1]], select = col_name[[2]])
train_y <- data.table::fread("UCIHAR/train/y_train.txt", col.names="Activities")
train_subject <- data.table::fread("UCIHAR/train/subject_train.txt", col.names="Person")
train <- cbind(train_subject, train_y, train_x)

# combine subject_test, X_test(selected columns), y_test by columns 
test_x <- data.table::fread("UCIHAR/test/X_test.txt", col.names = col_name[[1]], select = col_name[[2]])
test_y <- data.table::fread("UCIHAR/test/y_test.txt", col.names="Activities")
test_subject <- data.table::fread("UCIHAR/test/subject_test.txt", col.names="Person")
test <- cbind(test_subject, test_y, test_x)

# check columns names of train and test are equal before combining 
sum(colnames(test) != colnames(train))

# combine train and test by rows 
data_total <- rbind(train, test)

# check na 
all(!is.na(data_total))


# write csv
if (!file.exists("HARUSD.csv")) {write.csv(data_total, "HARUSD.csv")}

rm(list = ls()[ls() != "data_total"])

# average of each variable for each activity and each subject
average_by_activity_and_subject <- data_total %>% group_by(Person, Activities) %>% summarize_all(mean)

# create data set 
if (!file.exists("summary_average.csv")) {write.csv(average_by_activity_and_subject, "summary_average.csv")}
