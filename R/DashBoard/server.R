


shinyServer(function(input, output,session){
  
  # Genre Comparison Output
  selectcolumn <- reactive({
    a %>%
      select(prime_genre, yaxis = input$compvar) %>%
      arrange(desc(yaxis)) %>%
      head(input$slider1)
  })
  output$test <- renderPlotly({
    p <- ggplot(selectcolumn(),aes(x=reorder(prime_genre,-yaxis), y = yaxis)) + 
      geom_bar(aes(fill = prime_genre),stat="identity") +
      theme(axis.text.x=element_text(family="Palatino",angle=30,size=13),
            text=element_text(family="Palatino",size=18,face="bold"),
            legend.position = "none") +
            xlab("Genre") +
            ylab(input$compvar) +
      geom_hline(aes(yintercept = mean(yaxis))) + 
      ggtitle("Genre Comparison")
      ggplotly(p)
  })
  
  # Ranking Board Output
  
  app$prime_genre = as.factor(app$prime_genre)
  app$cont_rating = as.factor(app$cont_rating)
  app$free = as.factor(app$free)
    
  output$table <- DT::renderDataTable({
        datatable(app, rownames=F,
                  colnames = c("App Name",
                               "Size(MB)",
                               "Price",
                               "Total Reviews",
                               "Average Rating",
                               "Content Rating",
                               "Genre",
                               "# of Supported Devices",
                               "# of Supported Languages",
                               "Free/Paid"),
                  filter = "top",
                 options = list(
                 scrollX = T,
                 fixedColumns = T,
                 autoWidth = T,
                 columnDefs = list(list(width = "200px",targets = 0))))
    })
  
  # Correlations Output
  selectgenre <- reactive({
    if (input$type=="All" & input$free == "All") {
      app %>%
        select(x = input$variable1, y = input$variable2)
    } else if (input$type != "All" & input$free == "All"){
      app %>%
        filter(prime_genre == input$type) %>%
        select(x = input$variable1, y = input$variable2)
    } else if (input$type == "All" & input$free != "All"){
      app %>%
        filter(free == input$free) %>%
        select(x = input$variable1, y = input$variable2)
    }else {
      app %>%
        filter(prime_genre == input$type) %>%
        filter(free == input$free) %>%
        select(x = input$variable1, y = input$variable2)
    }
  })
  
  observe({
    restcolumns <- choices[!choices==input$variable1]
    updateSelectizeInput(
      session,"variable2",
      choices = restcolumns,
      selected = restcolumns[1]
    )
  })
  
  label1 <- reactive({
    if (input$variable1 == "price"){
      "App Price"
    } else if (input$variable1 == "size") {
      "Size(MB)"
    } else if (input$variable1 == "rating_count_tot") {
      "Number of Reviews"
    } else if (input$variable1 == "user_rating") {
      "Rating Score"
    } else if (input$variable1 == "sup_devices.num") {
      "Number of Supported Devices"
    } else {
      "Number of Supported Languages"
    }
  })
  
  label2 <- reactive({
    if (input$variable2 == "price"){
      "App Price"
    } else if (input$variable2 == "size") {
      "Size(MB)"
    } else if (input$variable2 == "rating_count_tot") {
      "Number of Reviews"
    } else if (input$variable2 == "user_rating") {
      "Rating Score"
    } else if (input$variable2 == "sup_devices.num") {
      "Number of Supported Devices"
    } else {
      "Number of Supported Languages"
    }
  })
  output$correlation <- renderPlotly({
    q <- ggplot(selectgenre(),aes(x,y)) +
      geom_point(position = "jitter",size = 3,color = "#3399CC") +
      geom_smooth(method='lm', formula = y~x, colour = "#66CC99") +
      theme(text=element_text(family="Palatino",size=18,face="bold")) +
      ggtitle("Scatterplot") +
      xlab(label1()) +
      ylab(label2())
    ggplotly(q)
  })
})
