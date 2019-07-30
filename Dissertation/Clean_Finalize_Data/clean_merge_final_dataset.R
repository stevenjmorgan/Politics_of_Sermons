# This script merges the sermon dataset with the pastors dataset and plots
# descriptives.

rm(list=ls())
#setwd("C:/Users/sum410/Dropbox/Dissertation/Data")
#setwd('C:/Users/steve/Desktop/sermon_dataset')
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

library(tidyr)
library(tidyverse)
library(lubridate)
library(stargazer)

# Read in sermons dataset
serms <- read.csv('sermon_dataset7-24_final.csv', stringsAsFactors = FALSE)
colnames(serms)

# Remove duplicate sermons
dim(serms) #173,367 x 7
serms <- serms[!duplicated(serms[,c('sermon')]),]
dim(serms) # 172,603 x 7

# Add year variable
serms$year <- sapply(strsplit(serms$date, split=', ', 
                              fixed=TRUE), `[`, 2)

# Read in pastors dataset
pastors <- read.csv('pastors/pastor_meta7-8.csv', stringsAsFactors = FALSE)
#pastors <- read.csv('pastor_meta7-8_final.csv', stringsAsFactors = FALSE)
#write.csv(pastors, 'pastor_meta7-8.csv', row.names = F)

# Convert NA to 0
pastors[is.na(pastors)] <- 0
colnames(pastors)
summary(is.na(pastors$contributor_link))

# Convert incorrect scraping to NA
for (i in 1:nrow(pastors)) {
  
  if (nchar(pastors$address[i]) < 3) {
    pastors$address[i] <- NA
  }
  
  if (nchar(pastors$church[i]) < 3) {
    pastors$church[i] <- NA
  }
  
  if (nchar(pastors$job[i]) < 3) {
    pastors$job[i] <- NA
  }  

  if (nchar(pastors$denom[i]) < 3) {
    pastors$denom[i] <- NA
  }
  
  if (nchar(pastors$location[i]) < 3) {
    pastors$location[i] <- NA
  }
  
  if (nchar(pastors$Education[i]) < 3) {
    pastors$Education[i] <- NA
  }
  
  if (nchar(pastors$Experience[i]) < 3) {
    pastors$Experience[i] <- NA
  }
  
  pastors$contributor_link[i] <- strsplit(pastors$contributor_link[i], '\\?ref')[[1]][1]
}

for (i in 1:nrow(serms)) {
  serms$contributor_link[i] <- strsplit(serms$contributor_link[i], '\\?ref')[[1]][1]
}


# Merge datasets
dim(serms)   # 172603 x 8
dim(pastors) # 7616 x 10
pastors <- pastors[!duplicated(pastors[,c('contributor_link')]),]
dim(pastors) # 7616 x 10
serms.merge <- merge(serms, pastors, by.x = c('contributor_link'),#c('author', 'denom')
                     by.y = c('contributor_link'), all.x = TRUE, all.y = FALSE)
dim(serms.merge) # 172603 x 17
colnames(serms.merge)

summary(is.na(serms.merge$address))
summary(is.na(serms.merge$location))


# Remove non-US sermons
serms.merge <- serms.merge[which(!is.na(serms.merge$address)),]

# Subset data w/ geolocators outside the U.S.
serms.merge <- serms.merge[which(!grepl('*Province', serms.merge$address)),]

# Split out State location and Zip code
serms.merge <- separate(data = serms.merge, col = address, 
                        into = c("town", "state"), sep = "\\,", remove = FALSE)
serms.merge$state <- trimws(serms.merge$state)
serms.merge <- separate(data = serms.merge, col = state, 
                        into = c('state_parse', 'zip'), sep = "(?<=[a-zA-Z])\\s*(?=[0-9])", remove = FALSE)

# Remove obs. w/o zip codes
serms.merge <- serms.merge[!nchar(as.character(serms.merge$zip)) < 5,]
serms.merge <- serms.merge[which(!is.na(serms.merge$zip)),]

# Remove obs. w/ incorrect state names
serms.merge <- serms.merge[!nchar(as.character(serms.merge$state_parse)) < 3,]
serms.merge <- within(serms.merge, rm(state))

dim(serms.merge) # 128893 x 20
#x <- subset(serms.merge, select = -c(sermon))
rm(serms, pastors)
colnames(serms.merge)
serms.merge$denon.conflicts <- ifelse(serms.merge$denom.x != serms.merge$denom.y, 1, 0)
summary(is.na(serms.merge$denom.x))
summary(is.na(serms.merge$denom.y))
# No conflicts, some pastors just left denom. blank on sermon uploads
summary(serms.merge$denon.conflicts==1)

# Split out first name
serms.merge$author <- trimws(serms.merge$author)
serms.merge$author.edit <- gsub('^Dr\\. ', '', serms.merge$author)
serms.merge$author.edit <- gsub('^Dr\\.', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Pastor ', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Pastor/Revivalist', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Evangelist', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Reverend', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Rev\\.dr.', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Rev\\.', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Rev', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Sir', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('Dr\\.', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub(' Dr ', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('(Dr\\.)', '', serms.merge$author.edit)
serms.merge$author.edit <- gsub('^Dr ', '', serms.merge$author.edit)
serms.merge$author.edit <- trimws(serms.merge$author.edit)
serms.merge$first.name <- ''
for (i in 1:nrow(serms.merge)) {
  serms.merge$first.name[i] <- strsplit(serms.merge$author.edit[i], ' ')[[1]][1]
}
write.csv(unique(serms.merge$first.name), file = 'unique_pastor_1st_names.csv')


# Clean text -> save in separate column
serms.merge$clean <- iconv(serms.merge$sermon, "latin1", "ASCII", sub="")
serms.merge$clean <- gsub("\\.", "\\. ", serms.merge$clean)
serms.merge$clean <- gsub(";", "; ", serms.merge$clean)
serms.merge$clean <- gsub("\\?", "\\? ", serms.merge$clean)
serms.merge$clean <- gsub("\\!", "\\! ", serms.merge$clean)
serms.merge$clean <- gsub('\"', " ", serms.merge$clean, fixed = T)
serms.merge$clean <- gsub(',', ", ", serms.merge$clean)
serms.merge$clean <- gsub("([0-9])([a-zA-Z])", "\\1 \\2", serms.merge$clean)
serms.merge$clean <- gsub("\\s+", " ", serms.merge$clean)
serms.merge$clean <- gsub("([[:punct:]])([[:blank:]])([[:punct:]])", "\\1\\3", 
                          serms.merge$clean)

save(serms.merge, file = 'data_serms_7-24-19.RData')
write.csv(serms.merge, 'sermons_pastor_names_7-24-19.csv')


############ Merge in pastor specific data (ethnicity and race)
#load('data_serms_7-24-19.RData')
### Contains Census predicted ethnicity
serms.merge <- read.csv('pastor_ethnicity_census_7-26.csv', stringsAsFactor = F)
colnames(serms.merge)

# Remove index column(s)

## Read in name file w/ gender and ethnicity
name.gender <- read.csv('first_name_gender_7-24.csv', stringsAsFactor = FALSE)
name.gender <- name.gender[which(!is.na(name.gender$Probability)),]
name.gender <- name.gender[,c(1,2,3)]
colnames(name.gender) <- c('first.name', 'first.name.gender', 
                           'first.name.gender.prob')

# Merge
dim(serms.merge) # 128893 x 33
serms.merge <- merge(serms.merge, name.gender, by = 'first.name', all.x = TRUE)
dim(serms.merge) # 128893 x 35
colnames(serms.merge)
serms.merge <- serms.merge[,-c(2,3,5)]
dim(serms.merge) # 128893 x 32
colnames(serms.merge)

unique(serms.merge$first.name.gender)
summary(serms.merge$first.name.gender == 'female') #& serms.merge$first.name.gender.prob > 0.80)

# Convert "None" to NA
for (i in 1:nrow(serms.merge)) {
  
  if (!is.na(serms.merge$first.name.gender[i])) {
    if (serms.merge$first.name.gender[i] == 'None') {
      serms.merge$first.name.gender[i] <- NA
    }
  }
  
}

summary(serms.merge$first.name.gender == 'female') #& serms.merge$first.name.gender.prob > 0.80)
rm(name.gender)


# Clean & merge in image recognition results
image <- read.csv('pastor_image_age_gender7-26.csv', stringsAsFactors = F,
                  na.strings=c('','NA'))
image <- image[,-c(1,2,3)]
image <- image[!is.na(image$gender),]
image$pastor_id <- gsub(' \\(1\\)','', image$pastor_id)



cleaned.images <- as.data.frame(matrix(nrow = length(unique(image$pastor_id)),
                                       ncol = 3))
colnames(cleaned.images) <- c('image.gender', 'image.gender.conf', 'pastor_id')
cleaned.images$pastor_id <- unique(image$pastor_id)


data <- image %>%
              group_by(pastor_id) %>%
              mutate(all_genders = paste0(gender, collapse = ', '))
data <- data[!duplicated(data$pastor_id),]
#write.csv(data, 'hand_label_image.csv')
rm(data,image,cleaned.images)

### Read in edited image results, merge in
image.results <- read.csv('hand_label_image7-27.csv', stringsAsFactors = FALSE)
image.results <- image.results[,-c(1)]
colnames(image.results) <- c('image.gender.conf', 'pastor_id', 'image.gender')
for (i in 1:nrow(image.results)) {
  image.results$pastor_id[i] <- strsplit(strsplit(image.results$pastor_id[i], 'pastor')[[1]][2],'_')[[1]][1]
}
# Drop "Revivalist" observation
image.results <- image.results[!is.na(image.results$pastor_id),]

colnames(serms.merge)

dim(serms.merge) # 128893 32
serms.merge <- merge(serms.merge, image.results, by.x = 'counter', by.y = 'pastor_id',
           all.x = TRUE)
dim(serms.merge) # 128893 34

# Check agreement between first name and image approach to gender
serms.merge$image.gender <- tolower(serms.merge$image.gender)
unique(serms.merge$first.name.gender)
unique(serms.merge$image.gender)

summary(serms.merge$first.name.gender == serms.merge$image.gender) # F = 1498   T = 64908   NA = 62487

# Aggregated gender measure
serms.merge$gender.final <- ifelse(serms.merge$image.gender != serms.merge$first.name.gender, serms.merge$image.gender, serms.merge$image.gender)
serms.merge$gender.final <- ifelse(is.na(serms.merge$gender.final), serms.merge$first.name.gender, serms.merge$gender.final)
summary(is.na(serms.merge$gender.final)) # F = 128727    T = 166
dim(serms.merge) # 128893 35

rm(image.results)

# Word count
serms.merge$word.count <- sapply(strsplit(serms.merge$clean, " "), length)
#save(serms.merge, file = 'final_dissertation_dataset7-27.RData')
library(stringr)
#serms.merge$word.count2 <- str_count(serms.merge$clean)
serms.merge$word.count3 <- sapply(strsplit(serms.merge$sermon, " "), length)

summary(serms.merge$word.count)
summary(serms.merge$word.count2)
summary(serms.merge$word.count3)

#load('final_dissertation_dataset7-27.RData')

### Remove spanish words
pat <- paste(c('dios', 'Dios', 'bien', 'bueno'), collapse='|')
serms.merge$spanish.count <- str_count(serms.merge$clean, pat)
summary(serms.merge$spanish.count > 5)

#serms.merge <- serms.merge[which(serms.merge$spanish.count < 5),] # 127451 x 38
rm(pat)

### Remove final non-US churches
unique(serms.merge$state_parse)

serms.merge <- serms.merge[which(!(serms.merge$state_parse %in% c('Lagos', 'Karnataka', 'yucatan', 
                                                           'CROYDON CR', 'Kerala', 'Hessen',
                                                           'Andhra pradesh'))),]
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Florida CA', 'Florida', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Alabama nb', 'Alabama', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Alabama TN', 'Alabama', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Grand Cayman KY', 'Kentucky', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Norfolk NR', 'Virginia', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Florida CA', 'Florida', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Florida CA', 'Florida', serms.merge$state_parse)
serms.merge$state_parse <- ifelse(serms.merge$state_parse == 'Florida CA', 'Florida', serms.merge$state_parse)

unique(serms.merge$state_parse) # Length = 51


#################################
##### Save FINAL dataset ########
save(serms.merge, file = 'final_dissertation_dataset7-27.RData')

#################################
