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
codes <- as.character(unique(coal$SCC))

# create lookup data frame, mapping SCC code to sector
lookup <- unique(subset(coal[which(coal$SCC %in% codes),],
                        select=c(SCC, EI.Sector)))

# get data with SCC that maps to a Coal code
data <- df[df$SCC %in% codes,]

# add sector from lookup
data$EI.Sector <- sapply(data$SCC,
                         function(scc) {
                             lookup[lookup$SCC == scc,]$EI.Sector })

# sum emissions by year and sector
agg <- aggregate(data$Emissions,
                 by=list(year = data$year, EI.Sector = data$EI.Sector),
                 FUN=sum,
                 na.rm=TRUE)

# plot
png(filename="plot5.png", height=480, width=480)
p <- qplot(year,
           log(x, base=10),
           data=agg,
           geom="line",
           color=EI.Sector,
           xlab="Year",
           ylab="Total PM2.5 Emissions from Coal (log)")
p+theme(legend.direction="vertical",
        legend.position="bottom")
dev.off()
