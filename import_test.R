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
  head(schedule_df)
  
}

