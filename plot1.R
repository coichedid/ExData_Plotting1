load.data <- function(url, filename, from, to) {
    filepath <- paste("./data",filename,sep = "/") # set file path to ./data folder
    if(!file.exists("./data")) dir.create("./data") # create ./data if need
    download.file(url,filepath) # download file
    unzip(filepath,exdir = "./data") # unzip file
    
    unzippedfilename <- dir("./data",pattern = "*.txt")[1] # get unzipped file
    unzippedfilepath <- paste("./data",unzippedfilename,sep = "/")
    
    ## This file is so big, so read only necessary data
    awkcmd <- paste("awk 'BEGIN {FS=\";\"} {if (($1 == \"Date\") || ($1 == \"",
                    from,
                    "\") || ($1 == \"",
                    to,
                    "\")) print $0}' ",
                    unzippedfilepath,
                    sep = "")
    d <- read.csv(pipe(awkcmd),header = TRUE,sep = ";", stringsAsFactors = FALSE,
                  na.strings = "?")
    d$DateTime <- strptime(paste(d$Date,d$Time),format = "%d/%m/%Y %H:%M:%S")
    return(d)
} 

plot.study <- function(data, var ,main,color,xlab, ylab, savetofile) {
    if (!missing(savetofile) && savetofile) {
        png(filename = "./plot1.png")
    }
    hist(data[,c(var)], col = color, main = main,xlab = xlab)
    if (!missing(savetofile) && savetofile) {
        dev.off()
    }
}
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#data <- load.data(url,"household_power_consumption.zip","1/2/2007","2/2/2007")
plot.study(data,"Global_active_power",color = "red", 
           xlab = "Global Active Power (kilowatts)", 
           main = "Global Active Power",
           savetofile = TRUE)