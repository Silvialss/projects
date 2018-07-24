library(shiny)
library(dplyr)
library(ggplot2)
library(wesanderson)
library(xtable)
a = read.csv('a.csv', stringsAsFactors = F)
app <- read.csv('AppleStore.csv', stringsAsFactors = F)
temp = c("Number of Ratings Received" = "rating_count_tot",
  "Rating" = "user_rating",
  "App Size in M" = "size_bytes",
  "App Price" = "price",
  "Number of Supported Device" = "sup_devices.num",
  "Number of Supported Languages" = "lang.num")
function(input,output,session){
    output$Count <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-Number),Number)) +
               geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre")
    )
    output$NumRat <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-NR),NR)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Number of Ratings Received")
    )
    output$R <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-Rating),Rating)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Average Ratings")
    )
    output$size <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-Size/1e6),Size/1e6)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Average App Size in MB")
    )
    output$s <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-Price),Price)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Average Price in $")
    )
    output$d <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-ND),ND)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Number of Supported Device")
    )
    output$l <- renderPlot(
      ggplot(a,aes(x=reorder(prime_genre,-NL),NL)) +
        geom_bar(aes(fill=prime_genre),stat="identity") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none") +
        xlab("Genre") +
        ylab("Number of Supported Language")
    )
    selectcolumn <- reactive({
      if (input$genre=="All") {
        app %>% 
          mutate(size_bytes = size_bytes/1e6) %>%
          select(x = input$x,y = input$y,cont_rating)
      } else {
      app %>%
        filter(prime_genre == input$genre) %>%
        mutate(size_bytes = size_bytes/1e6) %>%
        select(x = input$x,y = input$y,cont_rating)}
    })
    output$scatterplot <- renderPlot(
    selectcolumn() %>%
      ggplot(aes(x,y)) + 
        geom_point(position = "jitter",size = 5,color = "#3399CC") +
        geom_smooth(method='lm', formula = y~x, colour = "#66CC99") +
        xlab(input$x) +
        ylab(input$y) +
        theme(text=element_text(family="Palatino",size=18,face="bold")
      ))
    
  
    selectcompare <- reactive({
      if (input$genre2 == "All") {
        app %>% 
          mutate(size_bytes=size_bytes/1e6) %>%
          select(track_name,CompVar=input$compare)
      } else {
      app %>%
        mutate(size_bytes=size_bytes/1e6) %>%
        filter(prime_genre == input$genre2) %>%
        select(track_name,CompVar=input$compare)}
    })
    output$rank <- renderTable(
      selectcompare() %>%
        arrange(desc(CompVar)) %>%
        select(Name = track_name,"Comparing Variable" = CompVar) %>%
        head(input$slider1) %>%
        xtable()
    )
    output$rank2 <- renderPlot(
      selectcompare() %>%
        arrange(desc(CompVar)) %>%
        select(track_name,CompVar) %>%
        head(input$slider1) %>%
        ggplot(aes(x=reorder(track_name,-CompVar),CompVar,fill=track_name)) + 
        geom_bar(stat='identity') +
        xlab("App Name") + 
        ylab("Comparing Variable") +
        theme(axis.text.x=element_text(family="Palatino",angle=30,size=12),
              text=element_text(family="Palatino",size=18,face="bold"),
              legend.position="none")
    )
    observe({
      restcolumns <- temp[!temp==input$x]
      updateSelectizeInput(
        session,"y",
        choices = restcolumns,
        selected = restcolumns[1]
      )
    })
  
}