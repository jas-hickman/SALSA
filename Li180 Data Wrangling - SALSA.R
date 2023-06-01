library(tidyverse)
library(plyr)

##Read files within a given date folder
filenames <- list.files(path="~/PhD/SALSA/licor180/") #add the date folder name                         pattern="*.txt")

##Create list of data frame names without the ".txt" part 
names <-substr(filenames,1,9)

#create an empty list for df to be loaded into
filelist<-list()

###Load all files
#need to match file path with the path in line 6
for(i in names){
  filepath <- file.path("~/PhD/SALSA/licor180/", 
                        paste(i, ".txt", sep=""))
  filelist[[i]]<-assign(i, read.delim(filepath, sep = "\t"))
}

#filter every df within the list to only include PPFD, PFD-R, PFD-FR, and R:FR
filter.list = lapply(filelist, filter, Model.Name %in% c("PPFD", "PFD-R", "PFD-FR", "R:FR"))

#pivot every df within the filtered list so that column names are PPFD, PFD-R, PFD-FR, and R:FR
pivot.list = lapply(filter.list, pivot_wider, names_from = "Model.Name", values_from = "LI.180")

#combine all df from the pivoted list into one df
dat = bind_rows(pivot.list, .id = "Observation")

#add new columns for date of observation, plot number, subplot, 
#and numbered measurement within a given plot 
dat = dat %>% 
  mutate(Date = "", #need to manually enter desired date
         Plot = substr(Observation, 6, 8),
         Measurement = substr(Observation, 9, 9)) %>% 
  mutate(Treatment = Plot,
         Location = Measurement)

dat$Treatment[dat$Treatment == 101] <- 60
dat$Treatment[dat$Treatment == 102] <- 120
dat$Treatment[dat$Treatment == 103] <- 15
dat$Treatment[dat$Treatment == 104] <- 30
dat$Treatment[dat$Treatment == 201] <- 60
dat$Treatment[dat$Treatment == 202] <- 30
dat$Treatment[dat$Treatment == 203] <- 120
dat$Treatment[dat$Treatment == 204] <- 15
dat$Treatment[dat$Treatment == 301] <- 60
dat$Treatment[dat$Treatment == 302] <- 15
dat$Treatment[dat$Treatment == 303] <- 30
dat$Treatment[dat$Treatment == 304] <- 120
dat$Treatment[dat$Treatment == 401] <- 30
dat$Treatment[dat$Treatment == 402] <- 15
dat$Treatment[dat$Treatment == 403] <- 120
dat$Treatment[dat$Treatment == 404] <- 60
dat$Treatment[dat$Treatment == 501] <- 120
dat$Treatment[dat$Treatment == 502] <- 15
dat$Treatment[dat$Treatment == 503] <- 60
dat$Treatment[dat$Treatment == 504] <- 30
dat$Treatment[dat$Treatment == 601] <- 15
dat$Treatment[dat$Treatment == 602] <- 120
dat$Treatment[dat$Treatment == 603] <- 60
dat$Treatment[dat$Treatment == 604] <- 30

write.csv(dat, file = "~/PhD/SALSA/") #add in file name (date)
