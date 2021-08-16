#number of simulations (can change this... 100 takes about 20 seconds):
simulated_seasons <- 1000

#home field advantage (multiplied by the home teams offense. default is 1.2)
home_field_advantage <- 1.20

#global variables (don't change)
teams_n <- 20
matchweeks_total <- 38

#packages
library(rvest)
library(stringi)
library(stringr)
library(formattable)
library(sparkline)

#Create Functions
source("create_table.R")
source("populate_wins_losses.R")
source("simulate_game.R")
source("simulate_season.R")
source("simulate_many_seasons.R")

#import SPI
source("import_SPI.R")

#import scores
source("import_scores_and_schedule.R")

#create final table
source("set_up_final_table.R")

#Display table
show(table_out)
