simulation_table <- simulate_n_seasons(simulated_seasons)


played_games <- scores_df[!is.na(scores_df$H_score),]

if (nrow(played_games) == 0) {
  current_matchday <- 1
} else {
  current_matchday <- as.numeric(max(played_games$Matchday))
}

matchday_result_tables <- list()

positions <- data.frame(matrix(ncol = teams_n, nrow = matchweeks_total))
colnames(positions) <- team_list

if (current_matchday == 1){
  current_table$Prev <- NA
  current_table$Change <- 0
} else {
  for (i in 1:current_matchday) {
    matchday_result_tables[[i]] <- played_games[played_games$Matchday <= i,]
  }
  
  results_per_matchday <- list()
  for (i in 1:current_matchday) {
    results_per_matchday[[i]] <- create_table(matchday_result_tables[[i]])
  }
  
  for (i in 1:current_matchday) {
    for (j in 1:teams_n) {
      team_name <- team_list[[j]]
      matchday_table <- results_per_matchday[[i]]
      positions[[team_name]][i] <- matchday_table[matchday_table$Team == team_name,][["Pos"]]
    }
  }
  
  current_table$Prev <- NA
  previous_MD <- current_matchday - 1
  
  for (j in 1:teams_n) {
    current_team <- current_table$Team[j]
    current_table$Prev[j] <- positions[[current_team]][previous_MD]
  }
  
  current_table$Change <- current_table$Prev - current_table$Pos
}


current_table$UCL_pct <- NA
current_table$Prem_Title_pct <- NA
current_table$Relegated_pct <- NA
for (j in 1:teams_n) {
  current_team <- current_table$Team[j]
  current_table$UCL_pct[j] <- simulation_table[simulation_table$Team == current_team,][['UCL_pct']]
  current_table$Prem_Title_pct[j] <- simulation_table[simulation_table$Team == current_team,][['Prem_Title_pct']]
  current_table$Relegated_pct[j] <- simulation_table[simulation_table$Team == current_team,][['Relegated_pct']]
}

current_table$UCL_pct <- round(current_table$UCL_pct, 2)
current_table$Prem_Title_pct <- round(current_table$Prem_Title_pct, 2)
current_table$Relegated_pct <- round(current_table$Relegated_pct, 2)




inv_positions <- (teams_n+1) - positions
sparklines <- rep(NA, teams_n)

for (j in 1:teams_n) {
  current_team <- current_table$Team[j]
  sparklines[j] <- as.character(htmltools::as.tags(sparkline(inv_positions[[current_team]], type = "line",
                                                             chartRangeMin = 0.8, chartRangeMax = 20,
                                                             fillColor = FALSE,
                                                             minSpotColor = "",
                                                             maxSpotColor = "",
                                                             spotColor = "green",
                                                             lineWidth = 1,
                                                             normalRangeMin = 0.9,
                                                             normalRangeMax = 20.1,
                                                             disableInteraction = T,
                                                             disableTooltips = T,
                                                             disableHighlight = T,
                                                             normalRangeColor = "lightgrey")))
}

current_table$`Pos_trend` <- sparklines

current_table <- current_table[order(-current_table$Pts, -current_table$GD,
                                     -current_table$GF, -current_table$UCL_pct),]

current_table <- current_table[,c(1, 10, 11, 12, 16, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15)]

table_out <- as.htmlwidget(formattable(current_table, row.names = F,
                                       align = c("l", "c", "r", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c"),
                                       list(`Pts`= color_bar("lightblue"),
                                            `GD` = color_tile("pink", "lightgreen"),
                                            `GF` = color_bar("lightgreen"),
                                            `GA` = color_bar("pink"),
                                            `W` = color_bar("lightgreen"),
                                            `L` = color_bar("pink"),
                                            `D` = color_bar("khaki"),
                                            `UCL_pct` = color_bar("lightgreen"),
                                            `Prem_Title_pct` = color_bar("#36d160"),
                                            `Relegated_pct` = color_bar("pink"),
                                            `Prev` = FALSE,
                                            `Change`= formatter("span",
                                                                style = ~ style(color = ifelse(`Prev` == `Pos`, "black", ifelse(`Prev` > `Pos`, "green", "red"))),
                                                                ~ icontext(sapply(`Change`, function(x) if (x < 0) "arrow-down" else if (x > 0) "arrow-up" else ""), `Change`)))))

table_out$dependencies = c(table_out$dependencies, htmlwidgets:::widget_dependencies("sparkline", "sparkline"))
table_out

