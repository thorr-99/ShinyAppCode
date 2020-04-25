library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Common Statistical Distributions"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("distribution", "Select a Distribution", 
                        list("Uniform", "Normal", "Exponential", "Binomial")),
            sliderInput("Size",
                        "Sample Size:",
                        min = 100,
                        max = 5000,
                        value = 400),
            submitButton("submit")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(width = 5, 
                    plotOutput("plot1", click = "plot_click")
                ),
                
                column(width = 5, 
                    plotOutput("plot2")
                )
            ),
            h4("Summary Statistics: "),
            verbatimTextOutput("stats"),
        

        )
    )
))
