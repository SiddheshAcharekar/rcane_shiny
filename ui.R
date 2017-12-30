library(shiny)

shinyUI(fluidPage(
                  titlePanel('Rcane method visualization'),
                  
                  fluidRow(column(6,sliderInput(inputId = 'alpha',
                                                label = 'Learning Rate (alpha)',
                                                value = 0.03, 
                                                min = 0,
                                                max = 1)),
                           
                           
                           column(6, offset = 8, sidebarPanel(width =8, selectInput('method', 'Method', choices = list("Batch"="bgd",
                                                                                                 "Stochastic"="sgd",
                                                                                                 "Coordinate"="cd",
                                                                                                 "Minibatch"="mini-bgd")))),
                           fluidRow(column(12, mainPanel(tableOutput("compute")))),
                           
                           mainPanel(splitLayout( plotOutput("qqplot"),
                                                 plotOutput("resid_vs_fit"), plotOutput("costFunction_vs_iter")))
                  )))