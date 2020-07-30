### NHL Goal App ###

library(shiny)
library(tidyverse)
library(gghighlight)
library(ggridges)
library(dplyr)

# Import data
goal_data <- read_csv('data/goal_data.csv')
hyp_data <- read_csv('data/hyp_goal_data.csv')

# Set Output Tables
goal_table <- goal_data %>% group_by(player) %>% summarise_at(c('cum_goals','cum_assists','cum_points'), max) %>% arrange(desc(cum_goals))
hyp_table <- hyp_data %>% group_by(player) %>% summarise_at(c('cum_goals','cum_assists','cum_points'), max) %>% arrange(desc(cum_goals))

# Create lists for inputs
player_list <- unique(goal_data$player)
line_choices <- goal_data[,c(2,20:ncol(goal_data))]

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("NHL Goal Scorers"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3('Highlight Players'),
            selectizeInput('search', label=NULL, choices=player_list, multiple=T, selected='Wayne Gretzky'),

            h3('Line Plot:'),
            varSelectInput('xvar', 'X-axis variable', line_choices, selected = 'cum_game_count'),
            varSelectInput('yvar', 'Y-axis variable', line_choices, selected = 'cum_goals'),
            checkboxInput('hypo', 'Add Hypothetical Games*', value=F),
            
            submitButton('Run'),
            
            hr(),
            h4('*Hypothetical Games'),
            p("For each player, each season is filled-in to 82 games with that season's goals-per-game, 
            assists-per-game, and points-per-game."),
            p("Example: Mario Lemieux's 1994 season lasted only 22 games. The missing 60 games are
            filled-in with his 0.825 goals-per-game for a hypothetical season total of 63 goals.")
        ),

        # Show a plot of the generated distribution
        mainPanel(tabsetPanel(
            tabPanel('Line Plot', plotOutput('line', height='600px')),
            tabPanel('Table', DT::dataTableOutput('table'))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$line <- renderPlot({
        if(input$hypo){
        ggplot() + 
            geom_line(hyp_data, mapping = aes(x=!!input$xvar, y=!!input$yvar, 
                                               color=player), size=2) +
            gghighlight(player == input$search, use_direct_label = F) +
            theme_minimal()
        }
        else {
        ggplot() + 
            geom_line(goal_data, mapping = aes(x=!!input$xvar, y=!!input$yvar, 
                                               color=player), size=2) +
            gghighlight(player == input$search, use_direct_label = F) +
            theme_minimal()
        }
    })
    
 
    output$table <- DT::renderDataTable({
        if(input$hypo == T){
            DT::datatable(hyp_table, options=list(dom='t', pageLength=42))
        }
        else if(input$hypo == F){
            DT::datatable(goal_table, options=list(dom='t', pageLength=42))
        } 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
