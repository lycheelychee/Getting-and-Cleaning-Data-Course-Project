# Initialize some initial values
targetFolder <- 'UCI HAR Dataset'
filename <- 'getdata_dataset.zip'
# Download the file
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',filename)
# Unzip the file
unzip('getdata_dataset.zip')

# Install the package needed
install.packages('reshape2')
library(reshape2)

#####Merges the training and the test sets to create one data set##### 
# Read in the data into the test sets
test.data <- read.table(file.path(targetFolder, 'test', 'X_test.txt'))
test.activities <- read.table(file.path(targetFolder, 'test', 'y_test.txt'))
test.subjects <- read.table(file.path(targetFolder, 'test', 'subject_test.txt'))
# Read in the data into the training sets
train.data <- read.table(file.path(targetFolder, 'train', 'X_train.txt'))
train.activities <- read.table(file.path(targetFolder, 'train', 'y_train.txt'))
train.subjects <- read.table(file.path(targetFolder, 'train', 'subject_train.txt'))
# Bind the rows for each of the data sets together
data.data <- rbind(train.data, test.data)
data.activities <- rbind(train.activities, test.activities)
data.subjects <- rbind(train.subjects, test.subjects)
# Now combine all of of the different columns together into one table
merge_data <- cbind(data.subjects, data.activities, data.data)
# content of merge_data 
merge_data

#####2.Extracts only the measurements on the mean and standard deviation for each measurement#####
# Grab the complete list of features
features <- read.table(file.path(targetFolder, 'features.txt'))
# Filter to the features
requiredFeatures <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
requiredFeatures

#####3.Uses descriptive activity names to name the activities in the data set#####
# Read in the activity labels
activities <- read.table(file.path(targetFolder, 'activity_labels.txt'))
# Update the activity name
merge_data[, 2] <- activities[merge_data[,2], 2]

#####4.Appropriately labels the data set with descriptive variable names#####
colnames(merge_data) <- c(
  'subject',
  'activity',
  # Remove the brackets from the features columns
  gsub('\\-|\\(|\\)', '', as.character(requiredFeatures))
)
# Coerce the data into strings
merge_data[, 2] <- as.character(merge_data[, 2])

######5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject#####
# Melt the data 
final.melted <- melt(merge_data, id = c('subject', 'activity'))
# Cast it getting the mean value
final.mean <- dcast(final.melted, subject + activity ~ variable, mean)
# Look the final.mean
final.mean
# Emit the data out to a file
write.table(final.mean, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)
