library(shiny)
library(plotly)
load("AML_cBioportal_ClinicalData.rda")
dat<-myclinicaldata[,-c(6,7,14,19,22)]
nms<-names(dat)
ui <- fluidPage(
  
  headerPanel("KYMha_pilotMock_AML_patient_cbioportal_Data"),
  sidebarPanel(
    sliderInput('sampleSize', 'Sample Size', min = 1, max = nrow(dat),
                value = 1000, step = 500, round = 0),
    selectInput('x', 'X', choices = nms, selected = "OS_STATUS"),
    selectInput('y', 'Y', choices = nms, selected = "OS_MONTHS"),
    selectInput('color', 'Color', choices = nms, selected = "RISK_MOLECULAR"),
    
    selectInput('facet_row', 'Facet Row', c(None = '.', nms), selected = "RISK_MOLECULAR"),
    selectInput('facet_col', 'Facet Column', c(None = '.', nms)),
    sliderInput('plotHeight', 'Height of plot (in pixels)', 
                min = 100, max = 2000, value = 1000)
  ),
  mainPanel(
    plotlyOutput('trendPlot', height = "900px")
  )
)

server <- function(input, output) {
  
  #add reactive data information. Dataset = built in diamonds data
  dataset <- reactive({
    dat[sample(nrow(dat), input$sampleSize),]
  })
  
  output$trendPlot <- renderPlotly({
    
    # build graph with ggplot syntax
    p <- ggplot(dataset(), aes_string(x = input$x, y = input$y, color = input$color)) + 
      geom_point()
    
    # if at least one facet column/row is specified, add it
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .') p <- p + facet_grid(facets)
    
    ggplotly(p) %>% 
      layout(height = input$plotHeight, autosize=TRUE)
    
  })
  
}

shinyApp(ui, server)
