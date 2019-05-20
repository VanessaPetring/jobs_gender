library(shiny)
jobs_gender <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-05/jobs_gender.csv")
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Die Geschlechterverteilung in der Berufswelt"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "y",
                        "Y-axis:",
                        choices = c("Female workers" = "workers_female",
                                    "Male workers" = "workers_male"),
                        selected = "workers_female"),
            
            checkboxGroupInput(inputId = "selected_type",
                               label = "Major category:",
                               choices = c("Management, Business, and Financial", "Computer, Engineering, and Science", "Education, Legal, Community Service, Arts, and Media", "Healthcare Practitioners and Technical"),
                               selected = "Management, Business, and Financial")
       
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("lineplot")
        )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
    jobs_gender_subset <- reactive({
        req(input$selected_type)  
        filter(jobs_gender, major_category %in% input$selected_type)
    })

    output$lineplot <- renderPlot({
       ggplot(jobs_gender_subset(), aes_string(x ="year", y = input$y)) + 
            geom_col()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
