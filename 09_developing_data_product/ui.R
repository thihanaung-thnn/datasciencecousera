#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
    titlePanel("Central Limit Theorem"),
    tabsetPanel(
    tabPanel('Normal',
        sidebarLayout(
            sidebarPanel(
                "FOR ORIGINAL DISTRIBUTION",
                    numericInput('num_n', 'Number', value=1000, max=1000001),
                    numericInput('mean_n', 'Mean', value=0, max=1000001),
                    numericInput('sd_n', 'Standard Deviation', value=1, max=1000001),
                    "FOR SAMPLING",
                    numericInput('samples_n', 'Select Number of Samples', value=10, 
                                 max=1000001),
                    numericInput('frequency_n', 'How many times do you want to sample?', 
                                 value=100, max=1000001),
                
            ),
            mainPanel(
                plotOutput("distribution_hist_n", height=800),
            )
        )
    ), 
    tabPanel(
        "Binomial",
        sidebarLayout(
            sidebarPanel(
                "FOR ORIGINAL DISTRIBUTION",
                    
                    numericInput('num_b', 'Number', value=100, max=1000001),
                    numericInput('size_b', 'Size', value=10, max=1000001),
                    numericInput('prob_b', 'Probability', value=0.5, min=0, max=1, step = 0.05),
                    "FOR SAMPLING",
                    numericInput('samples_b', 'Select Number of Samples', value=10, 
                                 max=1000001),
                    numericInput('frequency_b', 'How many times do you want to sample?', 
                                 value=100, max=1000001),

            ),
            mainPanel(
                plotOutput("distribution_hist_b", height=800),
                
            )
        )
    ),
tabPanel(
    "Poisson",
    sidebarLayout(
        sidebarPanel(
            "FOR ORIGINAL DISTRIBUTION",
            
            numericInput('num_p', 'Number', value=100, max=1000001),
            numericInput('lambd', 'Lambda', value=1, max=10000),
            "FOR SAMPLING",
            numericInput('samples_p', 'Select Number of Samples', value=10, 
                         max=1000001),
            numericInput('frequency_p', 'How many times do you want to sample?', 
                         value=100, max=1000001),
            
        ),
        mainPanel(
            plotOutput("distribution_hist_p", height=800)
            
                )
            )
        ),
    tabPanel(
        "About",
        "This web application is for the week 4 assignment of the developing data products from Johns Hopkins (Coursera). In this application, you can stimulate to visualize the central limit theorem. 
        You can choose 3 distributions, normal, binomial and poisson. 
        You can also choose the parameters of each distribution such as mean, standard deviation for normal distribution, probability for binomial and lambda value for poisson and so on. 
        You can choose the number of sampling for each sample and number of sampling times as frequency. Note that it is written with for loop and please do not choose huge number for frequency. 
        Have fun. Thanks a lot. "
    )
    )
))
