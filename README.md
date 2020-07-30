# NHL_Goal_Scorers
Shiny App to compare the top NHL goalscorers since 1979 with hypothetical goal/assist data for missing games within a season.

Created for UNC-Charlotte Master's in Data Science and Business Analytics course DSBA-5122 (Visual Analytics). 

Because of my experience in Python, I did the initial data wrangling and feature engineering in a Jupyter Notebook. The Shiny app was then created with the cleaned datasets in R. 

The final app is available here: https://suttonjp.shinyapps.io/NHL_Goal_Scorers/

## Hypothetical Games
For each player, each season is filled-in to 82 games with that season's goals-per-game, assists-per-game, and points-per-game averages.

Example: Mario Lemieux's 1994 season lasted only 22 games. The missing 60 games are filled-in with his 0.825 goals-per-game for a hypothetical season total of 63 goals.
