#read in test and train data
testx=read.table("./UCI HAR Dataset/test/X_test.txt")
trainx=read.table("./UCI HAR Dataset/train/X_train.txt")
testy=read.table("./UCI HAR Dataset/test/y_test.txt")
trainy=read.table("./UCI HAR Dataset/train/y_train.txt")
subjtest=read.table("./UCI HAR Dataset/test/subject_test.txt")
subjtrain=read.table("./UCI HAR Dataset/train/subject_train.txt")

#read in variable names and labels and assign them
varnames=read.table("./UCI HAR Dataset/features.txt")[,2]
actnames=read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(testx)=varnames
colnames(trainx)=varnames
colnames(testy)="activity"
colnames(trainy)="activity"
colnames(subjtest)="subject"
colnames(subjtrain)="subject"

#create 1 dataset out of test and training datasets
test=cbind(subjtest,testx,testy)
train=cbind(subjtrain,trainx,trainy)
data=rbind(train,test)

#select only mean and std variables and activity and subject
data1=data[,(grepl("activity|subject|[Mm]ean|[Ss]td]", names(data)))]
#Assign acitvity labels to the codes
data2=merge(x=data1,y=actnames, by.x = "activity", by.y = "V1")
data2$activity=data2$V2
data2=subset(data2, select=-c(V2))

#Calculate mean per subject per activity
data_final=aggregate(data2[,3:length(data2)], list(data2$subject,data2$activity), mean)
colnames(data_final)=c("subject","activity",colnames(data_final[3:length(data_final)]))