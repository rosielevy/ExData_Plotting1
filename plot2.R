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


# join date and time
dt$posix <- as.POSIXct(strptime(paste(dt$Date, dt$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S"))


#reformat required field as numeric
dt$Global_active_power <- as.numeric(dt$Global_active_power)


#plot graph

png(file = "plot2.png", width = 480, height = 480, units = "px")
with(dt, plot(posix, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()  #close png device

