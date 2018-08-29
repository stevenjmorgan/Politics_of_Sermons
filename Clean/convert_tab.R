# This is code to read in ~80,000 sermons and play around with descriptives.
# Code developed by Steven Morgan.

rm(list=ls())

setwd("C:/Users/sum410/Dropbox/PoliticsOfSermons")

# update this file path to point toward appropriate folder on your computer
#folder <- "C:/Users/sum410/Dropbox/PoliticsOfSermons/MasterList"      
#file_list <- list.files(path=folder, pattern="*.txt")  



#Read in text files
#Convert to dataframe (file name, text)
#Gsub to get column for title, author, date, denom., text

library(readtext)
library(stringr)

# Directory contains 73,969 Files
folder <- "C:/Users/sum410/Dropbox/PoliticsOfSermons/MasterList"      

# Read in .txt files and save as 2 col. df
serms <- readtext(folder)

gc()

# Convert char. vector in 7 vectors
serms.df <- as.data.frame(str_split(serms$tex, "\\n", 7, simplify = TRUE))
serms.df[1:5, 1:3]

### Small set
dir <- 'C:/Users/sum410/Desktop/test'
test <- readtext(dir)

library(stringi)
x <- stri_split_fixed(str = test$text, pattern = "\n", n = 7)
df <- c(x[[1]])

library(stringr)
test$name <- str_split_fixed(test$tex, "\\n", 7, simply = TRUE)
e <- as.data.frame(str_split(test$tex, "\\n", 7, simplify = TRUE))


#months <- c(' Jan', ' Feb', ' Mar', ' Apr', ' May', ' Jun', ' Jul', 
#            ' Aug', ' Sep', ' Oct', ' Nov', ' Dec')
#test$author <- strsplit(test$text, '\\n', fixed = TRUE)[[1]]



new <- test$text[1]
#strsplit(new, '\n', fixed = TRUE)[1]

library(stringi)
new <- test$text[1]
x <- stri_split_fixed(str = new, pattern = "\n", n = 7)[[1]]
x[1:6]
