library(data.table)     #required for fread - faster processing on large data sets

filename <- "household_power_consumption.txt"
url       <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile  <- "data.zip"

#check for presence of dataset and downloaded if needed
if (!file.exists("./household_power_consumption.txt")) {
      download.file(url, destfile = zipfile)
      unzip(zipfile)
      file.remove(zipfile)
}

#read in data
dt <- fread(filename, sep = ";", header = TRUE, colClasses = rep("character",9), na.strings = "?")


#format date and subset to required data
dt$Date <- as.Date(dt$Date, format = "%d/%m/%Y")
dt <- dt[dt$Date == as.Date("2007-02-01") | dt$Date == as.Date("2007-02-02"),]


#reformat required field as numeric
dt$Global_active_power <- as.numeric(dt$Global_active_power)


#plot histogram
png(file = "plot1.png", width = 480, height = 480, units = "px")
hist(dt$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()  #close png device