
setwd("C:/Users/SF515-51T/Desktop/Dissertation")

library(stringr)

df <- read.csv('sermon_final.csv', stringsAsFactors = F)

terms <- paste(c('republican', 'democrat', 'congress', 'senate', 'gop', 'dem', 
                 'mcconel', 'schumer', 'trumpcar', 'lawmak', 'senat', 'legisl', 
                 'obama', 'racist', 'constitut', 'immigr', 'dreamer', 'daca', 
                 'deport', 'muslim', 'racism', 'lgbtq', 'transgend', 'activist',
                 'freedom', 'constitut', 'antilgbtq', 'liberti', 'civil', 
                 'anticivil','bigotri', 'judici', 'nomine', 'gorusch', 'clinton', 
                 'kennedi', 'feder','protest', 'pelosi','policymak', 'bipartisan',
                 'bipartisanship','congress', 'legisl', 'medicaid', 'medicar', 
                 'aca', 'democraci', 'lgbt', 'lgbtq', 'filibust', 'capitol',
                 'antiimigr','obamacar','migrant', 'refuge','asylum',
                 'salvadoran', 'elsalvador', 'detent', 'deport', 'incarcer',
                 'detain','border', 'discriminatori', 'antiabort', 'welfar', 
                 'grassley','politician', 'aclu', 'partisan', 'delegitim',
                 'transgend', 'unborn', 'abort', 'kamala', 'vote', 'ballot', 
                 'voter','abort', 'prolif', 'environ','ideolog', 
                 'kavanaugh','unconstitut', 'ideologu', 'proabort','antiabort',
                 'legislatur', 'homosexual', 'president', 'court'), collapse='|')
df$pol_count <- str_count(df$clean, terms)

summary(df$pol_count > 5)

df$pol.ground <- ifelse(df$pol_count > 5, 1, 0)

pol <- df[which(df$pol.ground == 1),]
nonpol <- df[which(df$pol.ground == 0),]

seed <- 24519
set.seed(seed)gc()

pol.smp <- pol[sample(nrow(pol), 150), ]
nonpol.smp <- nonpol[sample(nrow(nonpol), 350), ]

smp <- rbind(pol.smp, nonpol.smp)
smp <- subset(smp, select= c(pol.ground, clean))
write.csv(smp, file = 'political_active_1st_round.csv', row.names = F)
