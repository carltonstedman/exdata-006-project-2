# plot2.R

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
# from 1999 to 2008?
# Use the base plotting system to make a plot answering this question.

# read PM25 summary into data frame
df <- readRDS("summarySCC_PM25.rds")

# just get data from Baltimore City, Maryland
data <- df[df$fips == "24510",]

# sum emissions by year
agg <- aggregate(data$Emissions, by=list(year = data$year), FUN=sum, na.rm=TRUE)

# construct a png plot showing total PM2.5 emissions in Baltimore City, Maryland vs year
png(filename="plot2.png", height=480, width=480)
plot(agg$year,
     agg$x,
     xlab="Year",
     ylab="Total PM2.5 Emissions in Baltimore City, Maryland",
     type="l")
dev.off()
