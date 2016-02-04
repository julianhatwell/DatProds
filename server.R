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
    dfs <- reactive({n()}-2)
    st.err <- reactive({1/sqrt(n())})
    sig <- reactive({ifelse(input$alt == "greater"
                            , input$sig.level
                            , input$sig.level/2)})
    
    output$n <- renderPrint({ceiling(n())})
    output$crit <- renderPrint({trimws(paste("Reject the Null hypothesis and accept alternative for values >"
                                      , round(st.err() * qt(1 - sig(), dfs()), 4)
                                      , if (input$alt == "two.sided") {
                                          paste("or <", round( - st.err() * qt(1 - sig(), dfs()), 4), "for a two sided test")
                                        }
                                      ))})
    
    x <- seq(-1, 1, length.out = 1000)
    
    output$dens <- renderPlot({

      plot(x
          , dnorm(x, sd = st.err())
          , type = "l"
          , col = "blue"
          , xlab = "sample means"
          , ylab = ""
          , yaxt = "n")
      abline(v = st.err() * qnorm(1 - sig())
             , lwd = 3
             , col = "magenta")
      points(x + input$delta
             , dnorm(x, sd = st.err())
             , type = "l"
             , col = "purple")      
      if (input$alt == "two.sided") {
        points(x - input$delta
               , dnorm(x, sd = st.err())
               , type = "l"
               , col = "purple")
        abline(v = - st.err() * qnorm(1 - sig())
               , lwd = 3
               , col = "magenta")
      }
      })
    })