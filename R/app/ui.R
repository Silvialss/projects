library(shiny)
#setwd("~/Desktop/AppStore")
library(ggplot2)
library(dplyr)
library(xtable)
a = read.csv('a.csv', stringsAsFactors = F)
app <- read.csv('AppleStore.csv', stringsAsFactors = F)
navbarPage("App Store Application",
             tabPanel("Statistics",
                    navlistPanel("Compare by Genre",
                                 tabPanel("Total Number of Apps",
                                          plotOutput("Count")
                                          ),
                                 tabPanel("Number of Ratings Received",
                                          plotOutput("NumRat")),
                                 tabPanel("Average Rating",
                                          plotOutput("R")),
                                 tabPanel("Size",
                                          plotOutput("size")),
                                 tabPanel("Price",
                                          plotOutput("s")),
                                 tabPanel("Number of Supported Device",
                                          plotOutput("d")),
                                 tabPanel("Number of Supported Languages",
                                          plotOutput("l"))
                                 
                                 ),
                    style = "width:1200px;height:500px"
                        ),
           tabPanel("Ranking",
                    fluidPage(
                      sidebarLayout(
                        sidebarPanel(
                          selectizeInput("genre2",
                                         label = "Choose a Genre",
                                         choices = c("All",unique(app$prime_genre)),
                                         selected = "All"),
                          selectizeInput("compare",
                                         label = "Choose a Type",
                                         choices = c("Number of Ratings Received" = "rating_count_tot",
                                                     "App Size in M" = "size_bytes",
                                                     "App Price" = "price",
                                                     "Number of Supported Device" = "sup_devices.num",
                                                     "Number of Supported Languages" = "lang.num"),
                                         selected = "rating_count_tot"),
                          sliderInput("slider1", label = ("Top Apps"), min = 5, 
                                      max = 20, value = 10,animate = T)
                        ),
                        mainPanel(
                          fluidRow(
                            column(7,plotOutput("rank2")),
                            column(5,tableOutput("rank"))
                          
                          )
                        )
                      )
                    )
                    ),
           tabPanel("Correlations",
                    fluidPage(
                      sidebarLayout(
                        sidebarPanel(
                          selectizeInput("genre",
                                         label = "Choose a Genre",
                                         choices = c("All",unique(app$prime_genre)),
                                         selected = "All"),
                          selectizeInput("x",
                                         label="Select your x-axis",
                                         choices = c("Number of Ratings Received" = "rating_count_tot",
                                                     "Rating" = "user_rating",
                                                     "App Size in M" = "size_bytes",
                                                     "App Price" = "price",
                                                     "Number of Supported Device" = "sup_devices.num",
                                                     "Number of Supported Languages" = "lang.num"),
                                         selected = "price"),
                          selectizeInput("y",
                                         label="Select your y-axis",
                                         choices = c("Number of Ratings Received" = "rating_count_tot",
                                                     "Rating" = "user_rating",
                                                     "App Size in M" = "size_bytes",
                                                     "App Price" = "price",
                                                     "Number of Supported Device" = "sup_devices.num",
                                                     "Number of Supported Languages" = "lang.num"),
                                         selected = "size_bytes")
                        ),
                        mainPanel(
                          plotOutput("scatterplot")
                        )
                      ),
                      style = "width:1200px;height:500px"
                    ))
                      
           )
