library(shiny)
library(rcane)
library(tidyverse)
library(modelr)

ui <- fluidPage(
  titlePanel('Rcane method visualization'),
  
  fluidRow(column(6,sliderInput(inputId = 'alpha',
              label = 'Learning Rate (alpha)',
              value = 100, 
              min = 0,
              max = 1)),
  

  column(6, sidebarPanel(selectInput('method', 'Method', choices = list("Batch"="bgd",
                                                              "Stochastic"="sgd",
                                                              "Coordinate"="cd",
                                                              "Minibatch"="mini-bgd")))),
  fluidRow(column(12, mainPanel(tableOutput("compute")))),

  mainPanel(splitLayout(cellWidths = c("50%", "50%"), plotOutput("qqplot"),
  plotOutput("resid_vs_fit")))
))
server <- function(input, output) {
 
  output$compute <- renderTable({
    rlm.fit <- rlm(y~x, data=sim1, method=input$method, alpha = input$alpha)
    coeff <- coef(rlm.fit)
    df <- data.frame(name=input$method, mse=mean(residuals(rlm.fit)))
    df <- cbind(df,matrix(coeff,nrow=1))
    names(df) <- c("method", "mse", names(coeff))
    df
  })
  
  output$qqplot <- renderPlot({
    rlm.fit <- rlm(y~x, data=sim1, method=input$method, alpha = input$alpha)
    ggplot(aes(sample = resid), data = data.frame(resid=rlm.fit$residuals)) + geom_qq()
  })
  output$resid_vs_fit <- renderPlot({
    rlm.fit <- rlm(y~x, data=sim1, method=input$method, alpha = input$alpha)
    ggplot(aes(fitted, resid), data = data.frame(resid = rlm.fit$residuals, fitted = rlm.fit$fitted.values)) +
      geom_point()
  })
}

shinyApp(ui = ui, server = server)