#Local Data Dir
data.dir="./data/UCI HAR Dataset"
tidy.file <- './tidy-dataset.csv'
tidy.avgs.file <- './tidy-average-dataset.csv'

#Reading Subject Datasets
subjectTest <- read.table(paste(data.dir,'test/subject_test.txt', sep = '/'))
subjectTraining <- read.table(paste(data.dir,'train/subject_train.txt', sep = '/'))

#Reading X Datasets
dataXtrain <- read.table(paste(data.dir,'train/X_train.txt',sep = '/'))
dataXtest <- read.table(paste(data.dir,'test/X_test.txt' ,sep = '/'))

#Reading Y Datasets
dataYTrain <- read.table(paste(data.dir,'train/Y_train.txt',sep = '/'))
dataYTest <- read.table(paste(data.dir,'test/Y_test.txt' ,sep = '/'))

# Read feature 
features <- read.table(paste(data.dir, 'features.txt', sep = '/'),
                       header = FALSE)

# Read acts
acts <- read.table(paste(data.dir, 'activity_labels.txt', sep = '/'),
                   header = FALSE)

#names
names(acts) <- c('id', 'name')
names(features) <- c('id', 'name')

names(dataXtrain) <- features$name
names(dataXtest) <- features$name

names(dataYTrain) <- c('activity')
names(dataYTest) <- c('activity')

names(subjectTraining) <- c('subject')
names(subjectTest) <- c('subject')

#merge Datasets
subject <- rbind(subjectTest, subjectTraining)
X <- rbind(dataXtrain, dataXtest)
Y <- rbind(dataYTrain, dataYTest)


#extract mean and sd
X <- X[, grep('mean|std', features$name)]

# Convert activity labels to meaningful names
Y$activity <- acts[Y$activity,]$name

# Merge partial data sets together
tidy.dataset <- cbind(subject, Y, X)

write.csv(tidy.dataset, tidy.file)

tidy.avgs.dataset <- aggregate(tidy.dataset[, 3:dim(tidy.dataset)[2]],
                                list(tidy.dataset$subject,
                                     tidy.dataset$activity),
                                mean)
names(tidy.avgs.dataset)[1:2] <- c('subject', 'activity')

# Dump the second data set
write.csv(tidy.avgs.dataset, tidy.avgs.file)
