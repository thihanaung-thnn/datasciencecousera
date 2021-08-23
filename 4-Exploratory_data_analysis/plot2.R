# download, unzip, read files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
unzip("data.zip")
file.remove("data.zip")

# Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset Baltimore City data and calculate sum by year
pm_baltimore <- subset(NEI, fips == "24510")
total_pm_baltimore_year <- with(pm_baltimore, tapply(Emissions, year, sum))

# save as png file
png("plot2.png")
barplot(total_pm_baltimore_year, col = "royalblue", xlab = "Year", ylab = "Total PM2.5 Emission (tons)", main = "Total PM2.5 Emission in Baltimore City by Year")
dev.off()
