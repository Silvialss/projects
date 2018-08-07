setwd("/Users/lujian/Desktop/NYCDSA/Week5/Indeed/indeed/dataset")
alldata = read.csv("alldata.csv", header = T)

library(dplyr)
newdata <- alldata %>%
  filter(company!="NYU Langone Health")

write.csv(newdata,"alldata3.csv")

all = read.csv('final.csv',header = T)

tool_columns = names(all)[12:32]
all %>%
  group_by(title_category) %>%
  summarize(mean(machine.learning))

all %>%
  group_by(size,title_category) %>%
  summarize(n())

all %>%
  group_by(title_category) %>%
  summarize(n())

all %>%
  filter(title_category == 'other') %>%
  filter(size == "large") %>%
  select(position,company)

all %>%
  group_by(title_category) %>%
  select() 

all %>%
  filter(title_category=="data scientist") %>%
  filter(size == "large") %>%
  group_by(company) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


allfinal = read.csv("finalclean.csv",header = T)
allfinal = allfinal[,-2]
allfinal = allfinal[,-1]

allfinal %>%
  group_by(title_category) %>%
  summarize(mean(python),mean(excel),mean(sql),mean(java),mean(aws),
            mean(tableau),mean(linux),mean(spark))
