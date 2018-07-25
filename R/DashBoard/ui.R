

shinyUI(dashboardPage(
    dashboardHeader(title = "Apple Store"),
    dashboardSidebar(
        
        sidebarUserPanel("Dashboard"),
        sidebarMenu(
            menuItem("Genre Comparison", tabName = "genre", icon = icon("apple")),
            menuItem("Ranking Board", tabName = "rank", icon = icon("fire")),
            menuItem("Correlations",tabName = "corr", icon = icon("signal"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "genre",
                    fluidRow(box(plotlyOutput("test"), width = 8),
                             box(selectizeInput("compvar",
                                                label = "Choosing a Comparing Variable",
                                                choices = temp,
                                                selected = "rating_count_tot"),
                                 sliderInput("slider1", label = "Number of Genres",
                                             min = 1,
                                             max = 23,
                                             value = 10),width = 4),
                             box(plotlyOutput("histogram"),width = 8)
                             )),
            tabItem(tabName = "rank",
                    fluidRow(
                      box(DT::dataTableOutput("table"), width = 15))),
            tabItem(tabName = "corr",
                    fluidRow(
                      box(plotlyOutput("correlation"),width = 8),
                      box(selectizeInput("type",
                                         label = "Select a Genre",
                                         choices = c("All",unique(app$prime_genre)),
                                         selected = "All"),
                          selectizeInput("free",
                                         label = "Free/Paid",
                                         choices = c("All","Free","Paid"),
                                         selected = "All"),
                          selectizeInput("variable1",
                                         label = "Select your x-axis",
                                         choices = choices,
                                         selected = "price"),
                          selectizeInput("variable2",
                                         label = "Select your y-axis",
                                         choices = choices,
                                         selected = "size"),
                          width = 4
                          )
                    ))
        )
    )
))