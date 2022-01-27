#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$distribution_hist_n <- renderPlot({
        x_n    <- rnorm(input$num_n, input$mean_n, input$sd_n)
        results <- NA
        for (i in c(1:input$frequency_n)){
            s_n <- sample(x_n, input$samples_n, replace=TRUE)
            results[i] <- mean(s_n)
        }
        par(mfrow=c(2,1))
        hist(x_n, col = 'darkgray', border = 'white', main="ORIGINAL NORMAL DISTRIBUTION", xlim = c(min(x_n), max(x_n)))
        hist(results, col = 'darkgray', border = 'white', main="SAMPLING DISTIBUTION", xlim = c(min(x_n), max(x_n)))
    }) 
    output$distribution_hist_b <- renderPlot({
        x_b <- rbinom(input$num_b, input$size_b, input$prob_b)
        results_b <- NA
        for (i in c(1:input$frequency_b)){
            s_b <- sample(x_b, input$samples_b, replace=TRUE)
            results_b[i] <- mean(s_b)
        }
        par(mfrow=c(2,1))
        hist(x_b, col = 'darkgray', border = 'white', main="ORIGINAL BINOMIAL DISTRIBUTION", xlim = c(min(x_b), max(x_b)))
        hist(results_b, col = 'darkgray', border = 'white', main="SAMPLING DISTIBUTION", xlim = c(min(x_b), max(x_b)))
    })
    output$distribution_hist_p <- renderPlot({
        x_p <- rpois(input$num_p, input$lambd)
        results_p <- NA
        for (i in c(1:input$frequency_p)){
            s_p <- sample(x_p, input$samples_p, replace=TRUE)
            results_p[i] <- mean(s_p)
        }
        par(mfrow=c(2,1))
        hist(x_p, col = 'darkgray', border = 'white', main="ORIGINAL POISSON DISTRIBUTION", xlim = c(min(x_p), max(x_p)))
        hist(results_p, col = 'darkgray', border = 'white', main="SAMPLING DISTIBUTION", xlim = c(min(x_p), max(x_p)))
    })
})
