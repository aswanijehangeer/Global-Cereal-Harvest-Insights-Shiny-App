ui <- page_sidebar(
  # Title of the App
  title = "Global Cereal Production [1961 - 2021]",
  theme = bs_theme(bootswatch = "minty"),
  
  # Side bar
  sidebar = sidebar(
    # Inputs Controls
    pickerInput("country", "Choose Country",unique(cereal_data$entity), 
                selected = "Afghanistan",
                options = pickerOptions(
                  actionsBox = TRUE,
                  title = "Please select a country",
                  liveSearch = TRUE)),
    sliderInput("year", "Choose Years",
                min = min(cereal_data$year),
                max = max(cereal_data$year),
                value = c(1961, 2021))
  ),
  # Value boxes layout
  layout_columns(
    fill = FALSE,
    value_box(
      title = textOutput("left_box_title"),
      value = textOutput("total_area_harvested")),
    value_box(
      title = textOutput("middle_box_title"),
      value = textOutput("total_production")),
    value_box(
      title = textOutput("right_box_title"),
      value = textOutput("total_yeild"))
  ),
  
  # Main panel plot card
  card(
    card_header(textOutput("plot_title")),
    echarts4rOutput("plot")
  )
)