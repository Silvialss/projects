#libraries collection
library(ggplot2)
library(plotly)
library(shiny)
library(dplyr)
library(xtable)
library(shinydashboard)
library(DT)
library(ggcorrplot)

# Data Clearning 
app <- read.csv('AppleStore.csv', stringsAsFactors = F)

# Only select data we wanna use
app <- app %>%
  mutate(size = round(size_bytes/1e6,2)) %>%
  select(track_name, size, price, rating_count_tot,user_rating,cont_rating,
         prime_genre,sup_devices.num,lang.num) 

# Add a new column to categorize free and paid apps.
free = app %>%
  filter(app$price==0) %>%
  mutate(free = "Free")
paid = app %>%
  filter(app$price!=0) %>%
  mutate(free = "Paid")
app <- rbind(free,paid)

a <- app %>%
  group_by(prime_genre) %>%
  summarise("Number" = n(),
            "Number of Reviews" = round(mean(rating_count_tot),2),
            "Rating Score" = round(mean(user_rating),2),
            "Size(MB)" = round(mean(size),2),
            "Price" = round(mean(price),2),
            "Number of Supported Device" = round(mean(sup_devices.num),2),
            "Number of Supported Languages" = round(mean(lang.num),2))

temp = c("Number","Number of Reviews",
         "Rating Score",
         "Size(MB)",
         "Price",
         "Number of Supported Device",
         "Number of Supported Languages")

choices = c("Number of Reviews"= "rating_count_tot",
            "Rating Score" = "user_rating",
            "Size(MB)" = "size",
            "Price" = "price",
            "Number of Supported Device" = "sup_devices.num",
            "Number of Supported Languages" = "lang.num")

# description = read.csv('appleStore_description.csv', stringsAsFactors = F)
# full = merge(x=app,y=description,by = "track_name",all.x = T)
# drops <- c("id","size_bytes.y")
# newfull = full[,!(names(full) %in% drops)]