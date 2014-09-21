# plot6.R

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

library(ggplot2)

# read PM25 summary into data frame
df <- readRDS("summarySCC_PM25.rds")

# read in source classifcations
scs <- readRDS("Source_Classification_Code.rds")

# get SCC codes for all sources with a sector matching /Mobile*On-Road/ regex
# which will remove aircraft, boats, trains, and non-road equipment
road <- scs[sapply(scs$EI.Sector, function(s) { grepl("Mobile.*On-Road", s) }),]
codes <- as.character(unique(road$SCC))

# create lookup data frame, mapping SCC code to sector
lookup <- unique(subset(road[which(road$SCC %in% codes),],
                        select=c(SCC, EI.Sector)))

# just get data from Baltimore City, Maryland and Los Angeles County, California
# with SCC that maps to motor vehicle sources
data <- df[df$fips %in% c("24510", "06037") & df$SCC %in% codes,]

# add location
data$location <- sapply(data$fips,
                        function(fip) {
                            if(fip == "24510") {
                                "Baltimore City, MD"
                            } else if(fip == "06037") {
                                "Los Angeles County, CA"
                            } else NA })

# sum emissions by year and location
agg <- aggregate(data$Emissions,
                 by=list(year = data$year, location = data$location),
                 FUN=sum,
                 na.rm=TRUE)

# plot
png(filename="plot6.png", height=480, width=480)
p <- qplot(year,
           log(x, base=10),
           data=agg,
           geom="line",
           color=location,
           xlab="Year",
           ylab="Total PM2.5 Emissions, Motor Vehicles (log10)")
p+theme(legend.direction="vertical",
        legend.position="bottom")
dev.off()
