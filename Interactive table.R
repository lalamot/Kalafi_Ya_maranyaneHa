library(shiny)
library(ggplot2)  # for the diamonds dataset
load("AML_cBioportal_ClinicalData.rda")
ui <- fluidPage(
  title = "KYMha_Mock:cBioportal Leukemia clinical_Dataset",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "myclinicaldata"',
        checkboxGroupInput("show_vars", "Columns in mined_data to show:",
                           names(myclinicaldata), selected = names(myclinicaldata)))
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("myclinicaldata", DT::dataTableOutput("mytable1"))
        
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display
  myclinicaldata2 =myclinicaldata[sample(nrow(myclinicaldata), 166), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(myclinicaldata2[, input$show_vars, drop = FALSE])
  })
  
  
  
}

shinyApp(ui, server)