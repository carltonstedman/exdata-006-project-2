# plot3.R

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999–2008
# for Baltimore City? Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)

# read PM25 summary into data frame
df <- readRDS("summarySCC_PM25.rds")

# just get data from Baltimore City, Maryland
data <- df[df$fips == "24510",]

# sum emissions by year
agg <- aggregate(data$Emissions,
                 by=list(year = data$year, type = data$type),
                 FUN=sum,
                 na.rm=TRUE)

# plot
png(filename="plot3.png", height=480, width=480)
qplot(year,
      x,
      data=agg,
      geom="line",
      xlab="Year",
      ylab="Total PM2.5 Emissions in Baltimore City, Maryland",
      color=type)
dev.off()
