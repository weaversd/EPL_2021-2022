library(png)
library(grid)

setwd(paste0(working_directory, "weekly_analysis/weekly_team_plots/"))
plots <- lapply(ll <- list.files(),function(x){
  img <- as.raster(readPNG(x))
  rasterGrob(img, interpolate = FALSE)
})

setwd(working_directory)
library(gridExtra)
ggsave("weekly_analysis/all_team_weekly_stats.pdf", marrangeGrob(grobs=plots, nrow=5, ncol=5))
