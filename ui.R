#################################################
#              Likert Visualization           #
#################################################


library("shiny")
#library("foreign")

shinyUI(fluidPage(
  
  tags$head(includeScript("google_analytics.js")),
  # Header:
  titlePanel("Likert Visualization"),
  # Input in sidepanel:
  sidebarPanel(

    # Upload data:
    h5(p("Data Input")),
    fileInput("file", "Upload input data (csv file with header))"),
    
    h5(p("Data Selection (Optional)")),
    htmlOutput("varselect"),
        br()
  ),
  # Main:
  mainPanel(
    
    tabsetPanel(type = "tabs",
                #
                
                tabPanel("Overview",h4(p("How to Use this app"))),
                tabPanel("Likert Plot",plotOutput("plot", width = "100%",height = 700)),
#                 tabPanel("JSM Plot",plotOutput("plot", height = 800, width = 840)),
                tabPanel("Data",tableOutput("table"))
#     tableOutput("table"),  
#     tableOutput("table1"),
#     plotOutput("plot", width = "100%"),
#     plotOutput("plot1")
  )
))
)