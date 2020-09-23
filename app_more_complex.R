
library(shiny) # you may need to install.packages() this
library(tidyverse)

library(shiny)
library(fec16)

state.names <- c("CA", "NY", "KS")

######################################################################################
######################################################################################
# 
# 1. Shiny Apps have two basic parts to them
# 
#   - The user interface (UI) defines how the app should look.
#
#     -- For example, the text on the page, the placement of the elements, etc.
#
#   - The server defines how the app should behave.
#
#     -- This is how live elements are updated - like selecting a state from a list.
#
#   - Those two pieces are combined by running shinyApp(ui, server) to create the app.
# 
#      -- You can also click the green "Run App" button on the top right or 
#         run runApp() in the console

ui <- fluidPage(
  
  # - In Shiny Apps, you can print text straight to the page like this:
  
  sidebarPanel("Hello, world!"),
  
  # - You can also make your UI more complicated with UI elements. 
  # 
  #   -- In general, these are defined by functions that you give arguments to (e.g. min and max values).
  # 
  # - These include:
  #   
  #   -- selectInput() to choose from multiple options.
  # 
  #   -- sliderInput() lets you choose a value from a slider of values you define.
  #
  #   -- Lots of other options, like entering a date. Look at the resources for other choices!
  #
  # - You then assign these inputs to a value and use those values in other places, like in plots!
  #
  # - All of these functions have their own arguments. For example:
  
  
  # - There are also "panel" functions, which specify areas of your page. 
  # 
  #   -- There is a "main panel," a "sidebar," a "title," etc.
  
  mainPanel(
    selectInput("selected_state",                  # a name for the value you choose here
                "Choose a state from this list!",  # the name to display on the slider
                state.names),                      # your list of choices to choose from
    textOutput("state_message"), # here, we load a text object called "state_message"
    plotOutput("state_plot")
  )
  
  
)

server <- function(input, output, session) {
  
  
  # Then, you use these named objects to update the data on your site via the input object.
  
  output$state_message <- renderText({
    paste0("This is the state you chose: ", input$selected_state, "!")
  })
  
  # This line makes our dataset reactive.
    # That is, we can update it based on the values of input that define above.
  
  results <- reactive({ results_house })
  
  # Just like renderText(), we can renderPlot()!
  
  output$state_plot <- renderPlot({
    
    # we need to use () here after the name of our dataset because it is reactive!
    results() %>%
      
      # notice we are using the selected_state variable defined above!
      
      filter(state == input$selected_state) %>%
      
      # this plot is just like normal!
      ggplot(aes(x = primary_percent, y = general_percent)) + 
      geom_point()
  })
  
  
}

shinyApp(ui, server)
