library(dplyr)

run_analysis <- function(){
  
# Read Test data set
##Define filenames
Test_data_fn <- "UCI HAR Dataset/test/X_test.txt"
Test_activity_fn <- "UCI HAR Dataset/test/y_test.txt"
Test_subject_fn <- "UCI HAR Dataset/test/subject_test.txt"


##Read dataset
Test_data <- read.table(Test_data_fn)
Test_activity <- read.table(Test_activity_fn)
Test_subject <- read.table(Test_subject_fn)


##Create one test dataset
Test <- cbind(Test_subject,Test_activity,Test_data)
##Adjust column labels
names(Test) <- c("Subject", "Activity", as.character(read.table("UCI HAR Dataset/features.txt")[,2]))

#Read Train data set
## Define filenames
Train_data_fn <- "UCI HAR Dataset/train/X_train.txt"
Train_activity_fn <- "UCI HAR Dataset/train/y_train.txt"
Train_subject_fn <- "UCI HAR Dataset/train/subject_train.txt"

##Read Train data set
Train_data <- read.table(Train_data_fn)
Train_activity <- read.table(Train_activity_fn)
Train_subject <- read.table(Train_subject_fn)

##Create one train dataset
Train <- cbind(Train_subject,Train_activity,Train_data)

##Adjust column labels
names(Train) <- c("Subject", "Activity", as.character(read.table("UCI HAR Dataset/features.txt")[,2]))

#Merge the two datasets - Use rbind, no need for merge as rows are unique
Full_data <- rbind(Train, Test)

#find variables with mean or std in name
x <- grep("*mean*|*std*",names(Full_data))

#adjsut index for acitvity and subject columns
New_data <- Full_data[c(1,2,x)]

#rename activity labels
##read activity labels
activity_labels_fn <- "UCI HAR Dataset/activity_labels.txt"
activity_labels <- read.table(activity_labels_fn)[,2]
New_data$Activity <- factor(New_data$Activity, levels = c(1:6), labels = activity_labels)


#Create second dataset
##group variables by Subject and Activity
grouped <- group_by(New_data,Subject, Activity)

##Calculate averages using summarize_each from dplyr
Secondset <- summarize_each(grouped, funs(mean))

if(!dir.exists("/Cleaned Set")){dir.create("/Cleaned Set")}
#write the new file
write.csv(New_data,"/Cleaned Set/Train_Test_Mean_Std_data.csv")
#write the second dataset
write.csv(Secondset,"/Cleaned Set/Train_Test_Mean_Std_data_summary.csv")


}

