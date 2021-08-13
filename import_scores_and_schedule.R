#packages
library(rvest)
library(stringi)
library(stringr)


#import the schedule with dates and teams from fbref.com
schedule <- read_html("https://fbref.com/en/comps/9/schedule/Premier-League-schedule-and-Fixtures")
schedule_html <- html_nodes(schedule, 'th.right , .left:nth-child(3) a, .left:nth-child(9) a, .right a')
schedule_text <- html_text(schedule_html)
schedule_text <- stri_remove_empty(schedule_text)

#set the number of imported columns
imported_columns_n <- 4

#create a dataframe to hold the schedule
schedule_df <- data.frame(matrix(ncol = imported_columns_n))

#take text string and parse into dataframe for the schedule
for (i in 1:(length(schedule_text))) {
  if (i%%imported_columns_n == 1) {
    schedule_df[(i%/%imported_columns_n) + 1 ,1] <- schedule_text[i]
  } else if (i%%imported_columns_n == 2) {
    schedule_df[(i%/%imported_columns_n) + 1 ,2] <- schedule_text[i]
  } else if (i%%imported_columns_n == 3){
    schedule_df[(i%/%imported_columns_n) + 1 ,3] <- schedule_text[i]
  } else if (i%%imported_columns_n == 0) {
    schedule_df[(i%/%imported_columns_n), 4] <- schedule_text[i]
  }
}

#rename columns
colnames(schedule_df) <- c("Matchday", "Date", "Home", "Away")
schedule_df$Date <- as.Date(schedule_df$Date)

#create_scores_df
scores_df <- schedule_df

#add columns to score df
scores_df$H_score <- NA
scores_df$A_score <- NA
scores_df$Winner <- NA
scores_df$Loser <- NA
scores_df$Draw <- NA

#populate wins and losses
scores_df <- populate_wins_losses(scores_df)

#get team list
team_list <- sort(unique(scores_df$Home))

#real time table
current_table <- create_table()

