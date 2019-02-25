library(shiny)
library(tidyverse)
library(sf)
library(shinythemes)
library(tmap)
library(leaflet)

ca_counties <- read_sf(dsn = ".", layer = "california_county_shape_file") # Read data
st_crs(ca_counties) = 4326 

ca_dams <- read_sf(dsn = ".", layer = "California_Jurisdictional_Dams") %>% # Read data
  rename(Condition = Condition_)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("slate"),
  # Application title
  titlePanel("California State Jurisdiction Dams"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("certification",
                  label = h3("Dam certification:"),
                  c("Poor" = "Poor", 
                    "Unsatisfactory" = "Unsatisfactory", 
                    "Satisfactory" = "Satisfactory", 
                    "Fair" = "Fair"),
                  selected = "Poor"
                  )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("map")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Creating the reactive output ('map')
  output$map <- renderLeaflet({
    
    dams_inc <- ca_dams %>% 
      filter(Condition %in% input$certification) # Filter based on input selection from height widget
    
    # Creating map
    leaflet() %>% 
      addTiles() %>% 
      addMarkers(data = dams_inc)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

