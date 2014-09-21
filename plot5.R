# plot5.R

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

# just get data from Baltimore City, Maryland
# with SCC that maps to motor vehicle sources
data <- df[df$fips == "24510" & df$SCC %in% codes,]

# add sector from lookup
data$EI.Sector <- sapply(data$SCC,
                         function(scc) {
                             lookup[lookup$SCC == scc,]$EI.Sector })

# sum emissions by year and sector
agg <- aggregate(data$Emissions,
                 by=list(year = data$year, EI.Sector = data$EI.Sector),
                 FUN=sum,
                 na.rm=TRUE)

total <- aggregate(agg$x,
                   by=list(year = agg$year),
                   FUN=sum,
                   na.rm=TRUE)

total$EI.Sector <- "All Motor Vehicle Sources"

full <- rbind(agg, total)

# plot
png(filename="plot5.png", height=480, width=480)
p <- qplot(year,
           log(x, base=10),
           data=full,
           geom="line",
           color=EI.Sector,
           xlab="Year",
           ylab="Total PM2.5 Emissions, Motor Vehicles, Baltimore City, MD (log10)")
p+theme(legend.direction="vertical",
        legend.position="bottom")
dev.off()
