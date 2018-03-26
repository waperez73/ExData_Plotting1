#!/usr/bin/env Rscript

#######################################################################################
#Author: Wellintton Perez 2018

#This script creates plot1 for coursera.org course4 Week 1
#Dataset - Electric power consumption
#This plot is only base on dates between 2007-02-01 and 2007-02-02

url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename<-"household_power_consumption.txt"

data_location<-file.path(getwd(),"ucidata") # creates a repository to keep the raw data

data_file<-file.path(data_location,filename) #concat path and file name

#if the directory data does not existing down fresh data
if(!file.exists(data_file)){
  message("downloading data set Electric power consumption.")
  rawdata<-tempfile()
  rawdata<-paste(rawdata,".zip")
  download.file(url,rawdata) #download data from the URL
  unzip(rawdata,exdir=data_location)
}else{
  message("data directory found.")
}


getLine <- function(pattern){
conn<-file(data_file,"r")
ln=0
exit<-TRUE
while(exit){
  line<-readLines(conn,n=1)
  buff<-strsplit(line,";")[[1]][1];
  if(buff==pattern)
  { 
    exit=FALSE
  }
  ln<-ln+1  
}
close(conn)
return(ln)
}


start<-getLine("1/2/2007") # get the first row 
end<-getLine("3/2/2007")-1 #get the last row (3/2) - 1 

headers<-read.csv2(data_file,sep=";",nrow=1,stringsAsFactors = FALSE,header = TRUE)
data<-read.csv2(data_file,sep=";",skip=start,nrows=(end-start),stringsAsFactors = FALSE,header = FALSE)
names(data)<-names(headers)

data$Time=strptime(paste(data$Date,data$Time),"%d/%m/%Y %H:%M:%S")
data$Date=as.Date(data$Date,"%d/%m/%Y")

data$Global_active_power=as.numeric(data$Global_active_power)
data$Global_reactive_power=as.numeric(data$Global_reactive_power)
data$Voltage=as.numeric(data$Voltage)
data$Global_intensity=as.numeric(data$Global_intensity)
data$Sub_metering_1=as.numeric(data$Sub_metering_1)
data$Sub_metering_2=as.numeric(data$Sub_metering_2)
data$Sub_metering_3=as.numeric(data$Sub_metering_3)

par(mfrow=c(1,1))

plot(data$Time,data$Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")

points(data$Time,data$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering")

points(data$Time,data$Sub_metering_2,type="l",xlab="",col="red",ylab="Energy sub metering")
points(data$Time,data$Sub_metering_3,type="l",xlab="",col="blue",ylab="Energy sub metering")

legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1, cex=0.8)

dev.copy(png,"plot3.png")
dev.off()







