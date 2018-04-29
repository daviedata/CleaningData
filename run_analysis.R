#Download Data set

url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, 
              destfile='UCL.zip', 
                mode="wb")

unzip(zipfile = "UCL.zip")

x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sun_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
sun_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

feat <-read.table("./UCI HAR Dataset/features.txt")
feat_info <- read.table("./UCI HAR Dataset/features_info.txt")
act_lab <- read.table("./UCI HAR Dataset/activity_labels.txt")
README  <- read.table("./UCI HAR Dataset/README.txt")

#Understading what is in the tables
head(x_train)
head(act_lab)
head(x_test)
head(y_test)
head(sun_test)
head(y_train)
head(sun_train)
names(x_train)
names(act_lab)
names(x_test)
names(y_test)
names(sun_test)
names(y_train)
names(sun_train)

#Applying names

colnames(x_test) <- feat[,2] 
colnames(y_test) <- "actId"
colnames(sun_test) <- "subId"


colnames(x_train) <- feat[,2] 
colnames(y_train) <- "actId"
colnames(sun_train) <- "subId"

colnames(act_lab) <- c('actId','acttype')

jointrain <- cbind(y_train, sun_train, x_train)
jointest <- cbind(y_test, sun_test, x_test)
append <- rbind(jointrain, jointest)

coln <- colnames(append)


meanstd <- (grepl("actId" , coln) | 
                   grepl("subId" , coln) | 
                   grepl("mean.." , coln) | 
                   grepl("std.." , coln) 
)

subsetmeanstd <- append[,meanstd == TRUE]

descActnames <- merge(subsetmeanstd, act_lab, by = 'actId', all.x = TRUE)


# AFter step 4 
tiddata <- aggregate(. ~subId + actId, descActnames, mean)
tiddata <- tiddata[order(tiddata$subId,tiddata$actId),]

write.table(tiddata, "tidydataset.txt", row.names = FALSE)
