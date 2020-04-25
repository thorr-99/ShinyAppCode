library(shiny)

library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data <- reactive({
        if (input$distribution == "Uniform") {
            x <- runif(input$Size)
        } else if (input$distribution == "Normal") {
            x <- rnorm(input$Size)
        } else if (input$distribution == "Exponential") {
            x <- rexp(input$Size)
        } else {
            x <-rbinom(10, input$Size, prob = 0.1)
        }
    }) 
        
    output$plot1 <- renderPlot({
        plot(data(), main = paste("Scatter plot of", input$distribution), 
                ylab = "Simulated Data")
    })
    
    
    output$plot2 <- renderPlot({
        hist(data(), breaks = 20, freq = FALSE, 
             main = paste("Histogram of", input$distribution), 
             xlab = "Simulated Data")
        lines(density(data()), col=2)
        })
                    

    output$stats <- renderPrint({
        summary(data())
    })

    
})

