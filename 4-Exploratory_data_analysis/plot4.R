# download, unzip, read files
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip")
unzip("data.zip")
file.remove("data.zip")

# Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)

# Let's find Coal 
coal <- subset(SCC, Short.Name %in% Short.Name[grep("[Cc]oal", Short.Name)])
coal_id_level1 <- coal[,c(1,7)]

# join coal_id column with NEI 
coal_nei <- NEI %>% inner_join(coal_id_level1, by="SCC") %>%
  select(Emissions, year, category = SCC.Level.One)

# calculate proportion of PM2.5 Emissions according to Sources and Years
coal_prop_by_year <- coal_nei %>% group_by(category) %>%
  mutate(prop = Emissions/sum(Emissions)) %>%
  ungroup() %>%
  group_by(year, category) %>%
  summarize(prop = sum(prop))


# plot and save file
png("plot4.png", width = 700, height = 500)

ggplot(coal_prop_by_year, aes(x = year, y = prop)) +
  geom_point(size = 3, col = "red") +
  geom_line(col = "blue", linetype="dashed") +
  facet_wrap(~category) +
  labs(title = "Proportion of PM2.5 Emissions According to Sources From 1999 to 2008") +
  scale_x_continuous(name = "YEAR", breaks = c(1999,2002,2005,2008), labels = c("1999", "2002", "2005", "2008")) + 
  scale_y_continuous(name = "Proportion of PM Emissions", labels=scales::percent, limits = c(0,1)) +
  theme_bw()

dev.off()



