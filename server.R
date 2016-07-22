#################################################
#              Likert Visualization             #
#################################################


library("shiny")
#library("foreign")
require(grid)
require(lattice)
require(latticeExtra)
require(HH)

shinyServer(function(input, output) {
  ### Data import:
  Dataset <- reactive({
    if (is.null(input$file)) {
      # User has not uploaded a file yet
      return(data.frame())
    }
    Dataset <- as.data.frame(read.csv(input$file$datapath ,header=TRUE))
    rownames(Dataset) = Dataset[,1]
    Dataset1 = Dataset[,2:ncol(Dataset)]
    return(Dataset1)
  })
  
  # Select variables:
  output$varselect <- renderUI({
    if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
    # Variable selection:
    
    checkboxGroupInput("Attr", "Choose Attributes (At least 2 attributes must be selected)",
                       colnames(Dataset()), colnames(Dataset()))
    
      })
 
  output$table <- renderTable({
    if (is.null(input$Attr) || length(input$Attr)==0) return(NULL)
    return((Dataset()[,input$Attr]))
  })
  
  output$plot = renderPlot({  
  if (is.null(input$file))
  return(NULL)
  mydata = Dataset()
  mydata = mydata[,input$Attr]
  raw <- NULL
  for(i in 1:ncol(mydata)){
    raw <- rbind(raw, cbind(i,mydata[,i]))
  }
  
  r <- data.frame( cbind(
    as.numeric( row.names( tapply(raw[,2], raw[,1], mean) ) ),
    tapply(raw[,2], raw[,1], mean),
    tapply(raw[,2], raw[,1], mean) + sqrt( tapply(raw[,2], raw[,1], var)/tapply(raw[,2], raw[,1], length) ) * qnorm(1-.05/2,0,1),
    tapply(raw[,2], raw[,1], mean) - sqrt( tapply(raw[,2], raw[,1], var)/tapply(raw[,2], raw[,1], length) ) * qnorm(1-.05/2,0,1)
  ))
  names(r) <- c("group","mean","ll","ul")
  
  gbar <- tapply(raw[,2], list(raw[,2], raw[,1]), length)
  
  sgbar <- data.frame( cbind(c(1:max(unique(raw[,1]))),t(gbar)) )
  
  sgbar.likert<- sgbar[,2:ncol(sgbar)]
  sgbar.likert[is.na(sgbar.likert)] = 0
  
  if (ncol(sgbar.likert) == 3) {colnames(sgbar.likert) = c("Disagree","Neutral","Agree")}
  else if (ncol(sgbar.likert) == 5) {colnames(sgbar.likert) = c("Strongly Disagree","Disagree","Neutral","Agree","Strongly Agree")}
  else if (ncol(sgbar.likert) == 7) {colnames(sgbar.likert) = c("Strongly Disagree","Disagree","Slightly Disagree","Neutral","Slightly Agree","Agree","Strongly Agree")}
  else {cat("IDK")}
  
  rownames(sgbar.likert) = colnames(mydata)
  
  likert(sgbar.likert,
         main='Distribution of responses over Likert Scale',
         sub="Likert Scale"
         # BrewerPaletteName="RdBu"
         )
  
  })
  
  
})