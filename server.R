library(shiny)
library(tidyverse)
library(rcane)
library(modelr)

shinyServer(function(input, output) {
  
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
    y <- quantile(rlm.fit$residuals[!is.na(rlm.fit$residuals)], c(0.25, 0.75))
    x <- qnorm(c(0.25, 0.75))
    slope <- diff(y)/diff(x)
    int <- y[1L] - slope * x[1L]
    ggplot(aes(sample = resid), data = data.frame(resid=rlm.fit$residuals)) + 
      geom_qq() +
      geom_abline(slope = slope, intercept = int)
    
  })
  output$resid_vs_fit <- renderPlot({
    rlm.fit <- rlm(y~x, data=sim1, method=input$method, alpha = input$alpha)
    ggplot(aes(fitted, resid), data = data.frame(resid = rlm.fit$residuals, fitted = rlm.fit$fitted.values)) +
      geom_point() +
      geom_hline(yintercept = 0.0)
  })
  
  output$costFunction_vs_iter <- renderPlot({
    rlm.fit <- rlm(y~x, data=sim1, method=input$method, alpha = input$alpha)
    ggplot(aes(iter, loss), data = as.tibble(rlm.fit$loss_iter)) + geom_smooth(se = FALSE)
  })
})