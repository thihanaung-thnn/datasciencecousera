# download, unzip, read files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
unzip("data.zip")
file.remove("data.zip")

# Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)

# I think it should contain vehicles and so I made pattern only with [Vv]ehicle .
motor_vehicles <- subset(SCC, Short.Name %in% Short.Name[grep("[Vv]ehicle", Short.Name)])
motor_vehicle_id <- motor_vehicles[, "SCC"]

# filter the motor id and baltimore city, group by year and calculate total
motor_baltimore <- NEI %>% 
  filter(SCC %in% motor_vehicle_id & fips == "24510") %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))

# plot the graph
png("plot5.png", width = 900, height = 600)
par(mar = c(5,5,4,5))
with(motor_baltimore, 
     barplot(total, col = "royalblue",
             xlab = "Year", ylab = "Total PM2.5 Emissions", 
             main = "Total PM2.5 Emissions by Motor Vehicles in Baltimore City", names.arg=year, cex.lab = 1.5, cex.axis = 1.5, cex.main = 1.5))
dev.off()

     