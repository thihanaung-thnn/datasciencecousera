# download, unzip, read files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
unzip("data.zip")
file.remove("data.zip")

# Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset Baltimore City data 
pm_baltimore <- subset(NEI, fips == "24510")

# subset by year and source type 
library(ggplot2)
library(dplyr)
year_type <- pm_baltimore %>%
  group_by(year, type) %>%
  summarize(sum = sum(Emissions))

# plot and save file 
png("plot3.png", width=900, height = 600)
ggplot(year_type) +
  geom_line(aes(year, sum), color="blue") +
  labs(title = "PM Emission in Baltimore by Year according to Source types", x = "Year", y = "Total Emissions of PM2.5") +
  facet_wrap(~type) +
  theme(
    panel.background = element_rect(fill="white"),
    axis.line = element_line(color = "black"),
    plot.title = element_text(size = rel(2)),
    plot.background = element_rect(fill = "wheat"), 
    axis.text = element_text(color = "black")
  )
dev.off()
