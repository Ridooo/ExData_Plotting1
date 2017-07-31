



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



with(dataset, hist(x = Global_active_power, 
          col = "red",
          main= "Global Active Power",
          xlab = "Global Active Power (kilowatts)",
          ylab = "Frequency"))


dev.copy( device = png, file="plot1.png")
dev.off()
