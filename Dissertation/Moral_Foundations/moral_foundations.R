# This script runs the moral foundations dictionary on the sermons corpus.

rm(list=ls())
#setwd("C:/Users/steve/Dropbox/Dissertation/Data")
setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')

library(quanteda)
library(devtools)
devtools::install_github("kbenoit/quanteda.dictionaries") 
library(quanteda.dictionaries)

load('final_dissertation_dataset7-27.RData')

# Test set
output_mfd <- liwcalike(serms.merge$clean[1:4], tolower = TRUE,
                        dictionary = data_dictionary_MFD) # 3741

mfd.df <- as.data.frame(matrix(nrow = nrow(serms.merge), ncol = 28))
colnames(mfd.df) <- colnames(output_mfd)
mfd.scores <- output_mfd[1,]
mfd.scores[1,] <- NA
rm(output_mfd)

# Calculate mf scores on each sermon
for (i in 1:length(serms.merge$clean)) {
  
  mfd.scores[1,] <- NA
  
  try(
  # Calculate MFD score for sermon
  mfd.scores <- liwcalike(serms.merge$clean[i], tolower = TRUE,
                          dictionary = data_dictionary_MFD))

  # Append values to dataframe
  mfd.df[i,] <- mfd.scores[1,]
  
  # Change doc number and segment
  mfd.df$docname[i] <- paste('sermon', as.character(i), sep = ' ')
  mfd.df$Segment[i] <- i
}

summary(is.na(mfd.df$fairness.vice))
save(mfd.df, file = 'mfd_scores_7-30.RData')


# Combine w/ sermon dataset
serms.merge <- cbind(serms.merge, mfd.df)
colnames(serms.merge)
save(serms.merge, file = 'sermons_mfd_7-30.RData')

load('sermons_mfd_7-30.RData')

# Plot distributions
hist(mfd.df$fairness.vice)
hist(mfd.df$fairness.virtue)
hist(mfd.df$care.virtue)
hist(mfd.df$care.vice)
hist(mfd.df$loyalty.virtue)
hist(mfd.df$loyalty.vice)
hist(mfd.df$authority.virtue)
hist(mfd.df$authority.vice)
hist(mfd.df$sanctity.virtue)
hist(mfd.df$sanctity.vice)

unique(serms$denom)

hist(serms$care.virtue[which(serms$denom == 'Evangelical/Non-Denominational')],
     xlab = 'Care - Virture', main = 'Evangelicals/Non-Denominational')
hist(serms$care.virtue[which(serms$denom == 'Baptist')],
     xlab = 'Care - Virture', main = 'Baptist')

t.test(serms$care.virtue[which(serms$denom == 'Evangelical/Non-Denominational')], # sign.
       serms$care.virtue[which(serms$denom == 'Baptist')])
t.test(serms$care.vice[which(serms$denom == 'Evangelical/Non-Denominational')],
       serms$care.vice[which(serms$denom == 'Baptist')])
t.test(serms$fairness.virtue[which(serms$denom == 'Evangelical/Non-Denominational')], # sign.
       serms$fairness.virtue[which(serms$denom == 'Baptist')])
t.test(serms$fairness.vice[which(serms$denom == 'Evangelical/Non-Denominational')],
       serms$fairness.vice[which(serms$denom == 'Baptist')])


### Combine positive and negative appeals to MF's
colnames(serms.merge)
serms.merge <- serms.merge[which(serms.merge$WC > 75),]

serms.merge$care <- serms.merge$care.vice + serms.merge$care.virtue
summary(serms.merge$care)
serms.merge$fairness <- serms.merge$fairness.vice + serms.merge$fairness.virtue
summary(serms.merge$fairness)
serms.merge$loyalty <- serms.merge$loyalty.vice + serms.merge$loyalty.virtue
summary(serms.merge$loyalty)
serms.merge$authority <- serms.merge$authority.vice + serms.merge$authority.virtue
summary(serms.merge$authority)
serms.merge$sanctity <- serms.merge$sanctity.vice + serms.merge$sanctity.virtue
summary(serms.merge$sanctity)



aves <- rbind(mean(serms.merge$care), mean(serms.merge$fairness), mean(serms.merge$loyalty), 
              mean(serms.merge$authority), mean(serms.merge$sanctity))
sd.2above <- rbind(mean(serms.merge$care) + 2*sd(serms.merge$care), 
                   mean(serms.merge$fairness) + 2*sd(serms.merge$fairness),
                   mean(serms.merge$loyalty) + 2*sd(serms.merge$loyalty),
                   mean(serms.merge$authority) + 2*sd(serms.merge$authority),
                   mean(serms.merge$sanctity) + 2*sd(serms.merge$sanctity))
sd.2below <- rbind(mean(serms.merge$care) - 2*sd(serms.merge$care), 
                   mean(serms.merge$fairness) - 2*sd(serms.merge$fairness),
                   mean(serms.merge$loyalty) - 2*sd(serms.merge$loyalty),
                   mean(serms.merge$authority) - 2*sd(serms.merge$authority),
                   mean(serms.merge$sanctity) - 2*sd(serms.merge$sanctity))
plot.mf <- as.data.frame(cbind(aves, sd.2above, sd.2below))
#colnames(plot.mf) <- c('Care', 'Fair', 'Loyalty', 'Authority', 'Sanctity')
colnames(plot.mf) <- c('Mean','SD Above','SD Below')
plot.mf$foundation <- c('Care', 'Fair', 'Loyalty', 'Authority', 'Sanctity')


barCenters <- barplot(plot.mf$Mean)#, names.arg = plot.mf$foundation)
text(x = barCenters, y = par("usr")[3] - 1, srt = 45,
     adj = 1, labels = plot.mf$foundation, xpd = TRUE)

segments(barCenters, plot.mf$`SD Above`, barCenters,
         plot.mf$`SD Below`, lwd = 1.5)

arrows(barCenters, plot.mf$`SD Below`, barCenters,
       plot.mf$`SD Above`, lwd = 1.5, angle = 90,
       code = 3, length = 0.05)


t.test(serms.merge$care[which(serms.merge$denom.fixed == 'Evangelical/Non-Denominational')],
       serms.merge$care[which(serms.merge$denom.fixed == 'Baptist')])



plot.mf$sd <- c(sd(serms.merge$care), sd(serms.merge$fairness), sd(serms.merge$loyalty),
                sd(serms.merge$authority), sd(serms.merge$sanctity))
plot.mf$se <- plot.mf$sd / sqrt(nrow(serms.merge))

plotTop <- max(plot.mf$Mean) +
  plot.mf[plot.mf$Mean == max(plot.mf$Mean), 6] * 3

barCenters <- barplot(height = plot.mf$Mean,
                      names.arg = plot.mf$foundation,
                      beside = true, las = 2,
                      ylim = c(0, plotTop),
                      cex.names = 0.75, xaxt = "n",
                      main = "Mileage by No. Cylinders and No. Gears",
                      ylab = "Miles per Gallon",
                      border = "black", axes = TRUE)

# Specify the groupings. We use srt = 45 for a
# 45 degree string rotation
text(x = barCenters, y = par("usr")[3] - 1, srt = 45,
     adj = 1, labels = plot.mf$foundation, xpd = TRUE)

segments(barCenters, plot.mf$Mean - plot.mf$se * 2, barCenters,
         plot.mf$Mean + plot.mf$se * 2, lwd = 1.5)

arrows(barCenters, plot.mf$Mean - plot.mf$se * 2, barCenters,
       plot.mf$Mean + plot.mf$se * 2, lwd = 1.5, angle = 90,
       code = 3, length = 0.05)

library(ggplot2)
dodge <- position_dodge(width = 0.9)
limits <- aes(ymax = plot.mf$Mean + plot.mf$se,
              ymin = plot.mf$Mean - plot.mf$se)

colnames(plot.mf)[4] <- 'Foundation'
p <- ggplot(data = plot.mf, aes(x = Foundation, y = Mean, fill = Foundation))

p + geom_bar(stat = "identity", position = dodge) +
  geom_errorbar(limits, position = dodge, width = 0.25) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.x=element_blank())
ggsave('mf_dimensions.png')
