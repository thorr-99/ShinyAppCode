library(shiny)
library(quantmod)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #1f77b4 or rgb(31, 119, 180)  // muted blue
    #ff7f0e or rgb(255, 127, 14)  // safety orange
    #2ca02c or rgb(44, 160, 44)   // cooked asparagus green
    #d62728 or rgb(214, 39, 40)   // brick red
    #9467bd or rgb(148, 103, 189) // muted purple
    #8c564b or rgb(140, 86, 75)   // chestnut brown
    
    mycolors = c('1f77b4', 'ff7f0e', '2ca02c', 'd62728')
    
    balwint <- function(v0, anncont, int, term) {
        bal <- numeric()
        beg = v0
        for (i in seq(1:term)) {
            end <-  (beg + anncont) * (1 + int)
            bal <- c(bal, end)
            beg <- end
        }
        return(bal)
    }
    
    #Annuity Factor for age 65 to 75 based on 2% interest rate:
    #calculated in worksheet 
    ax <- data.frame('age' = c(65:75), 
                     'M' = c( 16.72, 16.18, 15.64, 15.10, 14.56, 14.01,  
                              13.47, 12.93, 12.39, 11.86, 11.34),  
                     'F' = c( 17.84, 17.29, 16.75, 16.21, 15.66, 15.12,
                              14.57, 14.03, 13.49, 12.95, 12.41)) 

    asset <- reactive({
        v0 <- input$Val0 
        age <- seq(
            input$ageRange[1], 
            input$ageRange[2]
        )
        term <- length(age)
        anncont <- input$contribution * 12
    
        zeroint <- balwint(v0, anncont, 0, term)
        twopct <- balwint(v0, anncont, 0.02, term)
        fourpct <- balwint(v0, anncont, 0.04, term)
        sixpct <- balwint(v0, anncont, 0.06, term)
        
        data.frame(age, zeroint, twopct, fourpct, sixpct)
    
    })

    output$assetplot <- renderPlotly({
        fig <- plot_ly(asset(), x = ~age, y = ~zeroint, type = 'scatter', mode = 'lines', 
                    name = '0%', fill='tozeroy', color = mycolors[1]) 
        fig <- fig %>% add_trace(y = ~twopct, type = 'scatter', mode = 'lines', 
                                  name = '2%', fill='tonexty', color = mycolors[2])
        fig <- fig %>% add_trace(y = ~fourpct, type = 'scatter', mode = 'lines', 
                                  name = '4%', fill='tonexty', color = mycolors[3])
        fig <- fig %>% add_trace(y = ~sixpct, type = 'scatter', mode = 'lines', 
                                  name = '6%', fill='tonexty', color = mycolors[4])
        fig <- fig %>% layout(title = "Retirement Asset Growth under Interest Scenarios",
            yaxis = list (title = 'Asset Growth'))

    })
    
    output$assettbl <- renderTable({
        
        tail(asset(),1)
    })
    

    output$retireplot <- renderPlotly({
        #base plot
        #ret.asset = as.matrix(tail(asset(), 1))
        #barplot(ret.asset[1, -1], col=rainbow(10), names.arg = c('0%', '2%', '4%', '6%'), 
        #        main = "Projected Retirement Assets")
        ret.asset = tail(asset(), 1)
        plot_ly(x = c('0%', '2%', '4%', '6%'), 
                y = as.numeric(ret.asset[1,-1]), 
                type = 'bar', color = mycolors, 
                text = paste0('$', round(ret.asset[1, -1]/1000,0), 'K')) %>%
            add_text(textfont = list(color='black'), 
                     textposition = 'bottom') %>% 
            layout(title = "Projected Retirement Assets", 
                   xaxis = list(title = "Earned Interest Rate"),
                   showlegend = FALSE
            )
 
    })
    
    output$incomeplot <- renderPlotly({
        ret.asset <- tail(asset(), 1)
        annfactor <- ax[ax$age == input$ageRange[2], ifelse(input$sex== "Male", 2, 3)] 
        retIncome <- as.numeric(ret.asset[1, -1]) / annfactor / 12
        
        plot_ly(y = factor(c('6%', '4%', '2%', '0%'), levels = c('6%', '4%', '2%', '0%')),
                x = rev(retIncome), 
                type = 'bar',
                orientation = 'h', 
                color = rev(mycolors), 
                text = paste0('$', round(rev(retIncome),0))) %>%
            add_text(textfont = list(color = 'black'), 
                     textposition = 'left') %>%
            layout(title = "Monthly Retirement Income", 
                   yaxis = list(title = "Earned Rate Scenario"),
                   showlegend = FALSE
            )
        
    })
})
