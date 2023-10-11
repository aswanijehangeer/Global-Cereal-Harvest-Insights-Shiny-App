ui <- page_sidebar(
  title = "Global Cereal Production [1961 - 2021]",
  
  sidebar = sidebar(
    selectInput("country", "Choose Country",unique(cereal_data$entity),
                selected = "Africa"),
    sliderInput("year", "Choose Years",
                min = min(cereal_data$year),
                max = max(cereal_data$year),
                value = c(1961, 2021))
  ),
  
  layout_columns(
    fill = FALSE,
    value_box(
      title = "Total Area Harvested across all Countries (Hectares)",
      value = paste0(round(sum(cereal_data$area_harvested_hectares, na.rm = TRUE) / 1e9, 1), " Bn")),
    value_box(
      title = "Total Production across all Countries (Tonnes)",
      value = paste0(round(sum(cereal_data$production_tonnes, na.rm = TRUE) / 1e9, 1), " Bn")),
    value_box(
      title = "Total Yeild across all Countries (Hectares)",
      value = paste0(round(sum(cereal_data$yield_tonnes_per_hectare, na.rm = TRUE),1)), " Bn")
  ),
  
  card(
    card_header("Cereal and the Green Revolution: Change in production vs. 1961"),
    echarts4rOutput("plot")
  )
)