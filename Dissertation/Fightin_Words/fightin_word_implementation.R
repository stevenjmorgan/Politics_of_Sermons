### This script applies Monroe et al.'s Fightin Words algorithm to analyze
### differences in language (at the lexical level) in the sermon dataset.

rm(list=ls())
setwd("C:/Users/steve/Dropbox/Dissertation/Data")

library("tm")
library("devtools")
devtools::install_github("matthewjdenny/SpeedReader")
library(SpeedReader)
library(stargazer)
library(quanteda)

load('final_dissertation_dataset7-27.RData')
colnames(serms.merge)

#### Create function???

## Create dtm

## Create df for variable of interest

## Create contingency table

## Run FW algorithm

## Plot results



### Male vs. female, black versus non-black, hispanic vs. non-hispanic, asian vs. non-asian
### Baptist vs. non-Baptist, Non-denom vs. rest, Independent vs. non-Independent
