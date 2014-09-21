# plot1.R

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from
# all sources for each of the years 1999, 2002, 2005, and 2008.

# NOTE: the only years in the PM25 dataset are from 1999, 2002, 2005, and 2008

# read PM25 summary into data frame
df <- readRDS("summarySCC_PM25.rds")

# read in source classification codes
scs <- readRDS("Source_Classification_Code.rds")

# sum emissions by year
agg <- aggregate(df$Emissions, by=list(year = df$year), FUN=sum, na.rm=TRUE)

png(filename="plot1.png", height=480, width=480)

plot(agg$year,
     agg$x,
     xlab="Year",
     ylab="Total PM2.5 Emissions",
     type="l")

dev.off()
