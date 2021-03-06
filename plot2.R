# Exploratory Data Analysis
# Course Project 2
# plot1.R 
# coded by Bartosz Jabłoński
# file encoding Windows CP-1250

# read in data
# file is located in:
# "C:\R_WORK\Exploratory Data Analysis notes"
# where "C:\R_WORK" is R's working directory

# NOTE!!! data.table package is needed
library(data.table)

# get only dates:  2007-02-01 and 2007-02-02
mypattern <- "^(1|2).2.2007"

# subset only those lines which match pattern, save them in temporary file
cat(
  grep(as.character(mypattern)
       , readLines('./Exploratory Data Analysis notes/household_power_consumption.txt')
       , value = TRUE
  )
  , sep="\n"
  , file = "my.small.data"
)

# create data.table
data.set <- data.table(
  read.table( file = "my.small.data" 
              , na.strings = "?"
              , stringsAsFactors = F
              , header = FALSE
              , quote = ""
              , sep = ";"
              , dec = "."
              , colClasses = c("character", "character", rep("numeric",7))
  )
)
# drop temporary file
unlink("my.small.data")

setnames(data.set, c("Date"
                     , "Time"
                     , "Global_active_power"
                     , "Global_reactive_power"
                     , "Voltage"
                     , "Global_intensity"
                     , "Sub_metering_1"
                     , "Sub_metering_2"
                     , "Sub_metering_3")
)
# creating new timestamp from Date and Time columns
data.set[, c("time.stamp", "Date", "Time") := {
  tmp.time <- as.character(paste(as.Date(Date, "%d/%m/%Y"), Time, sep = ' '));
  tmp.time <- as.POSIXct(strptime(tmp.time, "%Y-%m-%d %H:%M:%S"));
  list(tmp.time,NULL,NULL)
}]

# look through summary
str(data.set)
summary(data.set)


# set international dates and time
lct <- Sys.getlocale("LC_TIME")
lct
Sys.setlocale("LC_TIME", "C")

# open device
png(filename = "plot2.png"
    , width = 480
    , height = 480
    , units = "px"
    , pointsize = 12
    , bg = "transparent"
)
# create plot
plot(data.set[, time.stamp]
     , data.set[, Global_active_power]
     , type = "l"
     , main = ""
     , xlab = ""
     , ylab = "Global Active Power (kilowatts)"
)
# close device
dev.off()
# get back to orycinal datetime settings
Sys.setlocale("LC_TIME", lct)  
