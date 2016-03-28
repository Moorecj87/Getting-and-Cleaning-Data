run_analysis<-function(){
        
        #load packages
        
        library(dplyr)
        
        # Pull files into R
        
        temp<-tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
        
        features<-read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
        activitylabels<-read.table(unzip(temp, "UCI HAR Dataset/activity_labels.txt"), colClasses="character")
        testinglabels<-read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
        testingset<-read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
        testingsubjects<-read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
        traininglabels<-read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
        trainingset<-read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
        trainingsubjects<-read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
        
        unlink(temp)
        
        # Update col names with feature name, labels
        
        featurenames<-features$V2   
        names(testingset)<-featurenames
        names(trainingset)<-featurenames
        names(testingsubjects)<-"subjectid"
        names(trainingsubjects)<-"subjectid"
        names(testinglabels)<-"activitytype"
        names(traininglabels)<-"activitytype"
        activitylabels<-c(activitylabels$V2)
        
        # Add label columns to datasets
        
        testingset<-cbind(testingset, testinglabels, testingsubjects)
        trainingset<-cbind(trainingset, traininglabels, trainingsubjects)
        
        # Remove duplicate columns (getting error warning)
        
        testingset<- testingset[, !duplicated(colnames(testingset))]
        trainingset<- trainingset[, !duplicated(colnames(trainingset))]
        
        # Merges the training and the test sets to create one data set.
        
        combineddat<-rbind(testingset, trainingset)
        combineddat<-arrange(combineddat, subjectid, activitytype)
        
        # Extracts only the measurements on the mean and standard deviation for each measurement.
        
        meanvalues<-select(combineddat, contains("mean()"))
        stdvalues<-select(combineddat, contains("std()"))
        metavalues<-select(combineddat, subjectid, activitytype)
        meanstd<-cbind(metavalues, meanvalues, stdvalues)
        
        # Uses descriptive activity names to name the activities in the data set - done below
        
        # Appropriately labels the data set with descriptive variable names.
        
        names(meanstd)<-gsub("-", " ", names(meanstd))
        names(meanstd)<-gsub("\\()", "", names(meanstd))
        names(meanstd)<-tolower(names(meanstd))
        names(meanstd)<-gsub("std","standard deviation",names(meanstd))
       
        # From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
        
        subjectsplit<-split(meanstd, meanstd$subjectid)
      
        summaryset<-data.frame()
        
        for(i in 1:30){
                
                temp<-subjectsplit[[i]]
                temp2<-(split(temp, temp$activitytype))
                
                for(g in 1:6){
                        
                        temp3<-temp2[[g]]
                        means<-sapply(temp3,mean)
                        summaryset<-rbind(summaryset, means)
                        
                }
                
        }
        
        names(summaryset)<-names(meanstd)
        
        summaryset$activitytype[summaryset$activitytype==1]<-activitylabels[1]
        summaryset$activitytype[summaryset$activitytype==2]<-activitylabels[2]
        summaryset$activitytype[summaryset$activitytype==3]<-activitylabels[3]
        summaryset$activitytype[summaryset$activitytype==4]<-activitylabels[4]
        summaryset$activitytype[summaryset$activitytype==5]<-activitylabels[5]
        summaryset$activitytype[summaryset$activitytype==6]<-activitylabels[6]
        
        write.table(summaryset, file = "Moorecj87_Gettingcleaningdata.txt", row.names=FALSE)
        
}