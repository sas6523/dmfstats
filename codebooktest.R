     

################Reshape experiment
library("reshape2")
library("dplyr")
library("Cairo")
library("ggplot2")
# Grid allows use of units in the plot. eg. margin adjust by cm
library("grid")
library("xtable")


dat <- read.table("coursera classes/atlanticbonito.txt", sep="", header=FALSE)

names(dat) <- c("Year", "Harvest_Number", "PSE_1", "Harvest_Pounds", "PSE_2", "Mean_Length", "Mean_Weight", "PSE_3", "Released_Number", "PSE")
dat$Year <- as.factor(dat$Year)

####EXPERIMENT
#dat$Harvest_Number <- as.numeric(dat$Harvest_Number)
#dat$Released_Number <- as.numeric(dat$Released_Number)
#dat$Harvest_Number <- dat$Harvest_Number / 10
#dat$Released_Number <- dat$Released_Number / 10
dat$Harvest_Pounds <- as.numeric(dat$Harvest_Pounds)
dat$Harvest_Pounds <- dat$Harvest_Pounds / 10^2
##############


# Select just the columns we plan on plotting
temptidy <- select(dat, Year, Harvest_Number, Harvest_Pounds, Released_Number)
# convert to long format (ggplot prefered)
tidyDat <- melt(temptidy, id="Year")
# reassign tidyDat$value as integer. First you must replace the comma e.g. 9,234 = 9234
tidyDat$value <- as.numeric(gsub(",","",tidyDat$value))



#png('AtlanticBonito2.png', height=480, width=700)
# The Cairo library produces nice, smooth graphics
Cairo(600, 300, file="./Dots.png", type="png", bg="transparent")


# group = variable must be included to connect points
# This will inform geom_line() that all your points belong to one level and they should be connected.
plot3 <- ggplot(data=tidyDat,aes(x=Year, y=value, colour=variable, group=variable)) +
        geom_line() +
        # This adds the points by variable
        geom_point(aes(x=Year, y=value, colour=variable, group=variable, shape=variable)) +         
        # this sets the points shape manually
        scale_shape_manual(values=c(18,17,15)) +
        # this sets the line colors manually
        scale_colour_manual(values=c("grey", "blue","black")) +
        # This removes the background 
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
             panel.background = element_blank(), axis.line = element_line(colour = "black")) +       
        # this sets the line types manually
        scale_linetype_manual(values=c("solid","dotted", "solid")) + # Change linetypes
        # This turns off the tittle in the legend
        theme(legend.title=element_blank()) +
        # Move the legend to the correct position
        theme(legend.justification=c(0,1), legend.position=c(0.1,1)) +
        
        # Adjust the axis labels to be farther away from the axes
        theme(axis.title.x=element_text(vjust=-2)) +
        theme(axis.title.y=element_text(angle=90, vjust=2)) +
        theme(plot.title=element_text(size=15, vjust=3)) +
        theme(plot.margin = unit(c(1,1,1,1), "cm")) +
                           
        # This turns the x-labels 45 degrees
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) +
        labs(x="Year", y="Harvest Number")         
print(plot3)
dev.off()

d.table <- xtable(dat[1:20,])
print(d.table,type="html")


#names(dat) <- c("Year", "HarvestNumber", "PSE", "HarvestPounds", "PSE", "MeanLength", "MeanWeight", "PSE", "ReleasedNumber", "PSE")
#d.table <- xtable(dat[1:20,])

#xtable(d.table, caption = "Table 37. Atlantic bonito recreational catch in North Carolina by year.", label = "tab:one",caption.placement = "top")
#print(d.table,type="html", scalebox='0.75',include.rownames=FALSE, caption.placement = getOption("xtable.caption.placement", "top"))
