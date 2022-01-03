#test if import is working:
#ensure that import is working properly:

library(htmltools)
library(rvest)
library(stringi)

import_test <- function() {
  #import the schedule with dates and teams from fbref.com
  schedule <- read_html("https://fbref.com/en/comps/9/schedule/Premier-League-schedule-and-Fixtures")
  #schedule_html <- html_nodes(schedule, 'th.right , .left:nth-child(3) a, .left:nth-child(9) a, .right a')
  #schedule_html <- html_nodes(schedule, '.left:nth-child(3) a , .left:nth-child(7) a, .right a, th.right')
  schedule_html <- html_nodes(schedule, 'th.right , .left:nth-child(9) a, .right a, .left:nth-child(3) a')
  schedule_text <- html_text(schedule_html)
  schedule_text <- stri_remove_empty(schedule_text)
  
  
  #set the number of imported columns
  imported_columns_n <- 4
  
  
  schedule_matrix <- matrix(schedule_text, ncol = imported_columns_n, byrow = T)
  schedule_df <- as.data.frame(schedule_matrix, stringsAsFactors = F)
  colnames(schedule_df) <- c("Matchday", "Date", "Home", "Away")
  schedule_df$Date <- as.Date(schedule_df$Date)
  print(head(schedule_df))
  
  scores_df <- schedule_df
  
  #add columns to score df
  scores_df$H_score <- NA
  scores_df$A_score <- NA
  scores_df$Winner <- NA
  scores_df$Loser <- NA
  scores_df$Draw <- NA
  
  
  
  #get scores
  score_import <- read_html("https://fbref.com/en/comps/9/schedule/Premier-League-schedule-and-Fixtures")
  score_import_html <- html_nodes(score_import, 'td.center')
  score_import_text <- html_text(score_import_html)
  
  score_import_text[c(11,22,33,44,55,66,77,88,99,110,
                      121,132,143,154,165,176, 187,195,206,
                      217,228,232,243,254,265,276,287,
                      298,309,320,331,342,353,364,375,386,
                      397,408)]
  
}

