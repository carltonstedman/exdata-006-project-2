# plot4.R

# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999–2008?

library(ggplot2)

# read PM25 summary into data frame
df <- readRDS("summarySCC_PM25.rds")

# read in source classifcations
scs <- readRDS("Source_Classification_Code.rds")

# get SCC codes for all sources with a sector matching /Coal/ regex
coal <- scs[sapply(scs$EI.Sector, function(s) { grepl("Coal", s) }),]
codes <- unique(coal$SCC)

# sum emissions by year
agg <- aggregate(data$Emissions,
                 by=list(year = data$year, type = data$type),
                 FUN=sum,
                 na.rm=TRUE)

# plot
png(filename="plot4.png", height=480, width=480)
qplot(year,
      x,
      data=agg,
      geom="line",
      xlab="Year",
      ylab="Total PM2.5 Emissions",
      color=type)
dev.off()
