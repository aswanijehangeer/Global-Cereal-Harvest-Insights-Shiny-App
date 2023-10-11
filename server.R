server <- function(input, output, session) {
  
  # Re-actively filter data based on the selected country and year
  selected_data <- reactive({
    req(input$country, input$year)
    
    filtered_data <- cereal_data %>%
      filter(
        entity == input$country,
        year >= input$year[1] & year <= input$year[2]
      )
    
    return(filtered_data)
  })
  
  output$plot <- renderEcharts4r({
    
    selected <- selected_data()
    
    # Checking if data for the initial year is available
    if (sum(selected$year == input$year[1]) == 0) {
      
      # if data for the initial year is not available for the selected country
      # then use the next available year's data for calculations
      
      initial_year_data <- selected %>% filter(year == min(selected$year))
    } else {
      initial_year_data <- selected %>% filter(year == input$year[1])
    }
    
    change_area_harvested <- selected %>%
      mutate(area_harvested_change = round(((area_harvested_hectares - initial_year_data$area_harvested_hectares) / initial_year_data$area_harvested_hectares) * 100, 2))
    
    change_production <- selected %>%
      mutate(production_change = round(((production_tonnes - initial_year_data$production_tonnes) / initial_year_data$production_tonnes) * 100, 2))
    
    change_yield <- selected %>%
      mutate(yield_change = round(((yield_tonnes_per_hectare - initial_year_data$yield_tonnes_per_hectare) / initial_year_data$yield_tonnes_per_hectare) * 100, 2))
    
    change_population <- selected %>%
      mutate(population_change = round(((population_historical_estimates - initial_year_data$population_historical_estimates) / initial_year_data$population_historical_estimates) * 100, 2))
    
    change_area_harvested$year <- as.character(change_area_harvested$year)
    change_production$year <- as.character(change_production$year)
    change_yield$year <- as.character(change_yield$year)
    change_population$year <- as.character(change_population$year)
    
    change_area_harvested |>  
      e_charts(year) |> 
      e_line(area_harvested_change) |> 
      e_data(change_production) |> 
      e_line(serie = production_change) |> 
      e_data(change_yield) |> 
      e_line(serie = yield_change) |> 
      e_data(change_population) |>
      e_line(serie = population_change) |>
      e_axis_labels(y = "Change in %") |> 
      e_tooltip(trigger = "item",
                formatter = e_tooltip_item_formatter("percent", digits = "0")) |> 
      e_legend(bottom = 0) |> 
      e_toolbox_feature(feature = "dataView")
  })
}

