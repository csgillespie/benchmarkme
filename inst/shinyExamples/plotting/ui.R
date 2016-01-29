library("shiny")
opts = c("None", "Byte", "R Version", "OS")
ui = fluidPage(
  titlePanel("A comparison of histogram rules"),
  br(),
  fluidRow(
    column(2, 
           wellPanel(selectInput("facet_x", "Facet x", opts)
           )),
    column(2, 
           wellPanel(selectInput("facet_y", "Facet y", opts)
           )),
    column(2, 
           wellPanel(selectInput("test", "Test", c("Std", unique(past_results$test_group)))
           )),
    
    column(9, plotOutput("Sturges")))
)
