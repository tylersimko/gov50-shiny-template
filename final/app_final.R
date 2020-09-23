
library(shiny) # you may need to install.packages() this
library(tidyverse)

library(shiny)
library(fec16)

# this is just a normal object

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
  
  # - UIs are built from "panel" functions, which specify areas of your page. 
  # 
  #   -- There is a "main panel," a "sidebar," a "title," etc.
  
  # Here is a sidebar!
  
  sidebarPanel("Hello, world!"), 
  
  
  # And here is your "main panel" for the page.
  
  mainPanel(
    
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
    #   -- radioButtons() let you choose a button from a number of options
    #    
    #   -- textInput() lets you enter whatever text you want.
    #
    #   -- Lots of other options, like entering a date. Look at the resources for other choices!
    #
    # - You then assign these inputs to a value and use those values in other places, like in plots!
    #
    # - All of these functions have their own arguments. For example:
    
    selectInput(inputId = "selected_state",                  # a name for the value you choose here
                label = "Choose a state from this list!",    # the name to display on the slider
                choices = state.names),                      # your list of choices to choose from
    
    sliderInput(inputId = "selected_size",                   # a name for the value you choose here
                label = "Choose a number as a point size:",  # the label to display above the slider
                min = 0, max = 5, value = 2),                # the min, max, and initial values
    
    radioButtons(inputId = "selected_color",                 # a name for the value you choose here
                 label = "Choose a color!",                  # the label to display above the buttons
                 choices = c("red", "blue", "green")),       # the button values to choose from
    
    textInput(inputId = "entered_text",                      # a name for the value you choose here
              label = "Place your title text here:",         # a label above the text box
              value = "Example Title"),                      # an initial value for the box
    
    textOutput("state_message"), # here, we load a text object called "state_message"
    textOutput("size_message"),
    textOutput("color_message"),
    textOutput("text_message"),
    plotOutput("state_plot")
  )
  
  
)

server <- function(input, output, session) {
  
  
  # - Then, you use these named objects to update the data on your site via the input object.
  # 
  #   -- render() functions are what show content that will change live on your site.
  # 
  #   -- so here, renderText() is updating live text based on your choice.
  
  output$state_message <- renderText({
    paste0("This is the state you chose: ", # this is just a string, so it will never change
           input$selected_state, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$size_message <- renderText({
    paste0("This is the size you chose: ", # this is just a string, so it will never change
           input$selected_size, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$color_message <- renderText({
    paste0("This is the color you chose: ", # this is just a string, so it will never change
           input$selected_color, "!")       # this is based on your input, selected_state defined above.
  })
  
  output$text_message <- renderText({
    paste0("This is the label you typed: ", # this is just a string, so it will never change
           input$entered_text, "!")       # this is based on your input, selected_state defined above.
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
      geom_point(size = input$selected_size, color = input$selected_color) + 
      labs(title = input$entered_text) + theme_bw()
  })
  
}

shinyApp(ui, server)
