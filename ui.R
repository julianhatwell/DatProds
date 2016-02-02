shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Diabetes prediction"),
    
    sidebarPanel(
      numericInput('glucose', 'Glucose mg/dl', 90, min = 50, max = 200, step = 5),
      checkboxGroupInput("id2", "Checkbox",
                         c("Value 1" = "1",
                           "Value 2" = "2",
                           "Value 3" = "3")),
      dateInput("date", "Date:"),
      sliderInput('mu', 'Guess at the mean',value = 70, min = 62, max = 74, step = 0.05)
    ),
    mainPanel(
      h3('Results of prediction'),
      h4('You entered'),
      verbatimTextOutput("inputValue"),
      h4('You entered'),
      verbatimTextOutput("oid2"),
      h4('You entered'),
      verbatimTextOutput("odate"),
      h4('Which resulted in a prediction of '),
      verbatimTextOutput("prediction"),
      plotOutput('newHist')
    )
  )
)