library(shiny)
library(pwr)


library(UsingR)
shinyServer(
  function(input, output) {
    output$delta <- renderPrint({input$delta})
    output$sig.level <- renderPrint({input$sig.level})
    output$power <- renderPrint({input$power})
    output$alt <- renderPrint({ifelse(input$alt == "greater"
                                      , "one.sided"
                                      , input$alt)})
    
    ptt <- reactive({pwr.t.test(d = input$delta
                      , sig.level = input$sig.level
                      , power = input$power
                      , alternative = input$alt)
      })
    output$n <- renderPrint({ceiling(ptt()$n)})
    output$note <- renderPrint({ptt()$note})
    
    rng0 <- c(-5, 5)
    x0 <- seq(rng0[1], rng0[2], 0.1)
    y0 <- dnorm(x0)
    rngA <- reactive({rng0 + input$delta})
    
    output$dens <- renderPlot({
      plot(x0, y0, xlab='sample', type = "l", col='lightblue',main='density')
    })
    
    }
)