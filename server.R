server <- function(input, output, session) {
  
  # Re-actively filter data based on the selected country and year
  selected_data <- reactive({
    # Require country and year inputs
    req(input$country, input$year)
    
    filtered_data <- cereal_data %>%
      filter(
        entity == input$country,
        year >= input$year[1] & year <= input$year[2]
      )
    return(filtered_data)
  })
  
  output$plot <- renderEcharts4r({
    # Reactive data
    selected <- selected_data()
    
    # Checking if data for the initial year is available
    if (sum(selected$year == input$year[1]) == 0) {
      
      # if data for the initial year is not available for the selected country
      # then use the next available year's data for calculations
      initial_year_data <- selected %>% filter(year == min(selected$year))
    } else {
      initial_year_data <- selected %>% filter(year == input$year[1])
    }
    # Calculating %change in Area Harvested
    change_area_harvested <- selected %>%
      mutate(Area_Harvested = round(((area_harvested_hectares - initial_year_data$area_harvested_hectares) / initial_year_data$area_harvested_hectares) * 100, 1))
    # Calculating %change in Production
    change_production <- selected %>%
      mutate(Production = round(((production_tonnes - initial_year_data$production_tonnes) / initial_year_data$production_tonnes) * 100, 1))
    # Calculating %change in Yield
    change_yield <- selected %>%
      mutate(Yield = round(((yield_tonnes_per_hectare - initial_year_data$yield_tonnes_per_hectare) / initial_year_data$yield_tonnes_per_hectare) * 100, 1))
    
    # Change data type of Year columns
    change_area_harvested$year <- as.character(change_area_harvested$year)
    change_production$year <- as.character(change_production$year)
    change_yield$year <- as.character(change_yield$year)
    
    # Combined line plot for % change in (Yield, Production, and Area-Harvested)
    change_area_harvested |>  
      e_charts(year) |> 
      e_line(Area_Harvested) |> 
      e_data(change_production) |> 
      e_line(serie = Production) |> 
      e_data(change_yield) |> 
      e_line(serie = Yield) |> 
      e_axis_labels(y = "[Change in %]") |> 
      e_tooltip(trigger = "item") |> 
      e_legend(bottom = 0) |> 
      e_toolbox_feature(feature = "dataView")
  })
}

