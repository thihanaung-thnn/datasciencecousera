# download, unzip, read files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
unzip("data.zip")
file.remove("data.zip")

# Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# sum of the Emission in tons by years 
total_emission_by_year <- with(NEI, tapply(Emissions, year, sum))

# Plot and save as png file
png("plot1.png")
barplot(total_emission_by_year, col = "blue", main = "Total Emission of PM2.5 in tons by year", xlab = "Year", ylab = "Total Emission of PM2.5 (tons)")
dev.off()
