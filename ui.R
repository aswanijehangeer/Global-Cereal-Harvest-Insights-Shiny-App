ui <- page_sidebar(
  # Welcome pop-up modal
  modalDialog(
    h5("This app provides an overview of global cereal production from 1961 to 2021."),
    br(),
    h5("The values shown in the boxes are static and are calculated based on data for all countries available in the dataset."),
    br(),
    h5("NOTE: In future updates, interactive features will be added for the value boxes."),
    title = "Welcome to Global Cereal Production App",
    size = "l",
    easyClose = FALSE,
  ),
  # Title of the App
  title = "Global Cereal Production [1961 - 2021]",
  theme = bs_theme(bootswatch = "minty"),
  
  # Side bar
  sidebar = sidebar(
    # Inputs Controls
    selectInput("country", "Choose Country",unique(cereal_data$entity),
                selected = "Africa"),
    sliderInput("year", "Choose Years",
                min = min(cereal_data$year),
                max = max(cereal_data$year),
                value = c(1961, 2021))
  ),
  # Value boxes layout
  layout_columns(
    fill = FALSE,
    value_box(
      # style = 'background-color: #5C7BD9!important;',
      title = "Total Area Harvested across all Countries (Hectares)",
      value = paste0(round(sum(cereal_data$area_harvested_hectares, na.rm = TRUE) / 1e9, 1), " Bn")),
    value_box(
      # style = 'background-color: #FFDC60!important;',
      title = "Total Cereal Production across all Countries (Tonnes)",
      value = paste0(round(sum(cereal_data$production_tonnes, na.rm = TRUE) / 1e9, 1), " Bn")),
    value_box(
      # style = 'background-color: #A0E081!important;',
      title = "Total Cereal Yeild across all Countries (Tonnes)",
      value = round(sum(cereal_data$yield_tonnes_per_hectare, na.rm = TRUE),1))
  ),
  
  # Main panel plot card
  card(
    card_header("% Change of Cereal Production in the Countries since 1961"),
    echarts4rOutput("plot")
  )
)