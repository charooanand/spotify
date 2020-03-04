#############################################################################
# create function to read in count data, at either the song or artist level #
#############################################################################

# List artists that I accidently fall asleep to so that we can filter them out
zzz <- c("Death Cab for Cutie", 
         "Anna of the North",
         "The Cinematic Orchestra",
         "The Fray",
         "Wet",
         "Dean Lewis")

read_count_df <- function(download_code, level){
  
  count_df <- vroom(paste0("tables/", download_code, "/", level, "_count.csv"),
                         delim = ",") %>%
                   filter(!(artist %in% zzz))
  
  return(count_df)
  
}

#######################################################################
# create function to read in plot top listen count, by song or artist #
#######################################################################

plot_chart <- function(download_code, level){
  
  top <- read_count_df(download_code, level) %>%
         head(8)

  chart <- ggplot(data = top, aes(x=reorder(get(level), -listens), y=listens, fill=get(level))) +
           geom_bar(stat="identity", show.legend = FALSE) +
           xlab(level) + ylab("listens") + 
           floral_shoppe() +
           scale_fill_floralShoppe() +
           theme(axis.text.x = element_text(angle=90, hjust=1)) +
           theme(axis.text.y = element_text(angle=90, hjust=1))
  
  return(chart)
}

###############
# save charts #
###############

save_separate_charts <- function(download_code, level){
  
 create_if_nonexistent(paste0("plots/", download_code))
  ggsave(filename = paste0(level, "_bar_chart.jpeg"),
       plot = plot_chart(download_code, level), 
       path = paste0("plots/", download_code), 
       device = "jpeg")

}


save_combined_charts <- function(download_code){
  
  combined_plot <- ggarrange(plot_chart(download_code, "song"),
                             plot_chart(download_code, "artist"))
  
  create_if_nonexistent(paste0("plots/", download_code))
  ggsave(filename = paste0("combined_bar_chart.jpeg"),
         plot = combined_plot, 
         path = paste0("plots/", download_code), 
         device = "jpeg")
  
}

# lapply(download_codes, function(x) save_separate_charts(x, "song"))
# lapply(download_codes, function(x) save_separate_charts(x, "artist"))
lapply(download_codes, save_combined_charts)