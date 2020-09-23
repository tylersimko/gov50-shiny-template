
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

  textOutput("state_message"), # here, we load a text object called "state_message"

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
  
}

shinyApp(ui, server)
