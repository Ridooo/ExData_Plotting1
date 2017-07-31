

library(reshape2)


download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "Fhousehold_power_consumption.zip")
unzip("Fhousehold_power_consumption.zip", overwrite = TRUE)
dataset_dir <- getwd()


dataset_file <- file.path(dataset_dir, "household_power_consumption.txt")
DF.row1 <- read.table(dataset_file , header = TRUE, nrow = 1,sep = ";")
nc <- ncol(DF.row1)
DF.Date <- read.table(dataset_file, header = TRUE, sep = ";", as.is= T, colClasses = c(NA, rep("NULL", nc-1)) )


format(object.size(x = DF.row1) * nrow(DF.Date) , units= "Mb")




DF.Date$Date <- as.Date(as.character(DF.Date$Date), "%d/%m/%Y")


skip1 <- which.min(DF.Date$Date < as.Date("2007-02-01", "%Y-%m-%d"))
nrows_20070201 <- sum(DF.Date$Date == as.Date("2007-02-01", "%Y-%m-%d"))
dataset01 <- read.table(dataset_file, header= TRUE, sep = ";",na.strings="?",  skip = skip1, nrows = nrows_20070201-1)
colnames(dataset01) <- colnames(DF.row1)


skip2 <- which.min(DF.Date$Date < as.Date("2007-02-02", "%Y-%m-%d"))
nrows_20070202 <- sum(DF.Date$Date == as.Date("2007-02-02", "%Y-%m-%d"))
dataset02 <- read.table(dataset_file, header= TRUE, sep = ";",na.strings="?",  skip = skip2, nrows = nrows_20070202-1)
colnames(dataset02) <- colnames(DF.row1)

dataset <- rbind(dataset01, dataset02)


dataset$DateTime <- paste(dataset$Date, dataset$Time)


dataset$DateTime <- strptime(dataset$DateTime , "%d/%m/%Y %H:%M:%S")
?par()

par(mfrow =c(2,2))
with(dataset, plot(DateTime, Global_active_power, 
                   type = "l",
                   lwd=1,
                   ylab = "Global Active Power (kilowatts)"))



with(dataset, plot(DateTime, Voltage, 
                   type = "l",
                   lwd=1,
                   xlab = "datetime",
                   ylab = "Voltage"))


with(dataset, plot(DateTime,Sub_metering_1,
                   type = "l",
                   col="black",
                   lwd=1,
                   ylab = "Energy sub metering"))
with(dataset, lines(DateTime, Sub_metering_2, type="l", col="red") )
with(dataset, lines(DateTime, Sub_metering_3, type="l", col="blue") )

legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=1, col=c("black", "red", "blue"),cex=.7)


with(dataset, plot(DateTime, Global_reactive_power, 
                   type = "l",
                   lwd=1,
                   xlab = "datetime",
                   ylab = "Global_reactive_power"))



dev.copy( device = png, file="plot4.png")
dev.off()
