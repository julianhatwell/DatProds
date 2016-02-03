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
    
    n <- reactive({ptt()$n})
    st.err <- reactive({input$delta / qt(1 - input$sig.level, n()-1)})
    
    output$n <- renderPrint({ceiling(n())})
    
    x <- seq(-1, 2, length.out = 1000)
    
    output$dens <- renderPlot({

      plot(x
          , dnorm(x, sd = st.err())
          , type = "l"
          , col = "light blue"
          , xlab = "sample means"
          , ylab = "density")
      abline(v = 0
             , lwd = 2
             , col = "light blue")
      abline(v = st.err() * qt(1 - input$sig.level, n()-1)
             , lwd = 2
             , col = "black")
      points(x + input$delta + st.err() * qt(input$power, n()-1)
              , dnorm(x, sd = st.err())
              , type = "l"
              , col = "pink")
      abline(v = input$delta + st.err() * qt(input$power, n()-1)
             , lwd = 2
             , col = "pink")
      })
    
    }
  )