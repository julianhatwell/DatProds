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
    
    n <- reactive({ptt()$n/2})
    dfs <- reactive({ptt()$n - 1})
    st.err <- reactive({1/sqrt(n())})
    
    output$n <- renderPrint({ceiling(n())})
    output$crit <- renderPrint({round(st.err() * qt(1 - input$sig.level, dfs()), 4)})
    
    x <- seq(-1, 1, length.out = 1000)
    
    output$dens <- renderPlot({

      plot(x
          , dnorm(x, sd = st.err())
          , type = "l"
          , col = "light blue"
          , xlab = "sample means"
          , ylab = "density")
      abline(v = st.err() * qt(1 - input$sig.level, dfs())
             , lwd = 2
             , col = "light blue")
      points(x + input$delta
             , dnorm(x, sd = st.err())
             , type = "l"
             , col = "pink")      
      abline(v = input$delta - st.err() * qt(1 - input$power, dfs()
                                                  , lower.tail = FALSE)
             , lwd = 3
             , col = "pink")
      })
    })