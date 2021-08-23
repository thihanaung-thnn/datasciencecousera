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

# Subset Baltimore and Los Angeles with motor vehicle ID
motor_cities <- NEI %>% filter(SCC %in% motor_vehicle_id & (fips == "24510" | fips == "06037"))
motor_cities_total_year <- motor_cities %>% group_by(year, fips) %>%
  summarize(total = sum(Emissions))

# let's plot and save png 
png("plot6.png", height = 600, width = 900)
ggplot(motor_cities_total_year, aes(x = year, y = total, fill = fips)) +
  geom_col(position = "dodge") +
  labs(fill = "City Names", x = "YEAR", y = "Total PM2.5 Emissions", title = "Total PM2.5 Emissions by Vehicles in Baltimore and Los Angeles") +
  scale_fill_discrete(labels = c("Los Angeles", "Baltimore")) +
  scale_x_continuous(name = "YEAR", breaks = c(1999,2002,2005,2008), labels = c("1999", "2002", "2005", "2008")) +
  theme_bw() +
  theme(
    legend.position=c(0.9,0.9)
  )
dev.off()  

file.remove(c("Source_Classification_Code.rds", "summarySCC_PM25.rds"))
  
  
  
  
  
  
  
  



