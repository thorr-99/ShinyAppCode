library(shiny)
library(plotly)

shinyUI(fluidPage(

    # Application title
    titlePanel(" "),

    sidebarLayout(
        sidebarPanel(
            h2("Retirement Asset: "),
            numericInput("Val0", h3("Current Retirement Savings:"), 
                         value = 20000, step = 1000),
            sliderInput("ageRange", h3("Starting Age and Retirement Age: "), 
                        min = 20, max = 75, value = c(40, 65)),
            sliderInput(inputId = "contribution",
                        h3("Monthly Contribution: "), min = 50, max = 2000, step = 50,
                        value = 100),
            radioButtons("sex", h3("Gender: "), choices=list('Male', 'Female')),
            submitButton("Refresh")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h1("How Much Will You Have at Retirement?", 
               style = 'color: blue'),
            htmlOutput('br'),
            fluidRow(
                plotlyOutput('assetplot'),
                
            ), 
            fluidRow(
                h3("Retirement Asset and Income at Retirement Age: "),
                #tableOutput("assettbl")
            ),
            fluidRow(
                column(width=5,
                       #h4("asset summary"),
                       plotlyOutput('retireplot')), 
                column(width = 5, 
                       #h4("income comparison"),
                       plotlyOutput('incomeplot'))
            )
            
        )
    )
))
