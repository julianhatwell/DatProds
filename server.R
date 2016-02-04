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
      x_null_reject <- x[x > st.err() * qnorm(1 - sig())]
      x_alt_accept <- x[x + input$delta > st.err() * qnorm(1 - input$power)] +input$delta
      plot(x
          , dnorm(x, sd = st.err())
          , type = "n"
          , ylab = ""
          , yaxt = "n")
      polygon(c(x_alt_accept[1],x_alt_accept)
              , c(0, dnorm(x_alt_accept, mean = input$delta, sd = st.err()))
              , col = "pink"
              , border = "transparent") 
      polygon(c(x_null_reject[1],x_null_reject)
              , c(0, dnorm(x_null_reject, sd = st.err()))
              , col = "light blue"
              , border = "transparent") 
      points(x
          , dnorm(x, sd = st.err())
          , type = "l"
          , col = "blue"
          , xlab = "sample means")
      points(x + input$delta
             , dnorm(x, sd = st.err())
             , type = "l"
             , col = "purple")
      abline(v = st.err() * qnorm(1 - sig())
             , lwd = 3
             , col = "magenta")
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