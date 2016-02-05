library(shiny)
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Sample Size Calculator"),
    
    sidebarPanel(
      numericInput('delta', 'Enter the effect size wish to detect:', 0.5, step = 0.01),
      numericInput('sig.level', 'Enter your chosen significance level', 0.05, step = 0.025),
      numericInput('power', 'Enter the required power of your test', 0.8, step = 0.1),
      radioButtons("alt", "Test type",
                   c("one sided" = "greater",
                     "two sided" = "two.sided"))
      ),
    mainPanel(
      h3('Suggested Sample Size of Experiment Group'),
      h4('The following sample size is needed in each group (rounded up):'),
      verbatimTextOutput("n"),
      h4('Z statistic'),
      verbatimTextOutput("crit"),
      
      plotOutput('dens')
    )
  )
)