# List artists that I accidently fall asleep to so that we can filter them out
zzz <- c("Death Cab for Cutie", 
         "Anna of the North",
         "The Cinematic Orchestra",
         "The Fray",
         "Wet")

read_count_df <- function(download_code, level){
  
  count_df <- vroom(paste0("tables/", download_code, "/", level, "_count.csv"),
                         delim = ",") %>%
                   filter(!(artist %in% zzz))
  
  return(count_df)
  
}

plot_chart <- function(download_code, level){
  
  top <- read_count_df(download_code, level) %>%
               filter(listens>quantile(listens, probs = 0.99))

  chart <- ggplot(data = top, aes(x=reorder(get(level), -listens), y=listens, fill=get(level))) +
           scale_fill_manual(values = random_wes_pal()) +
           geom_bar(stat="identity", show.legend = FALSE) +
           theme_minimal() +
           theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
           xlab(level) + ylab("number of listens")
  
  # Save bar chart table to subfolder in plots/ folder.
  # We use Spotify's download code to name the subfolder so the file structure mirrors the raw_data/ and tables/ folder.
  create_if_nonexistent(paste0("plots/", download_code))
  
  ggsave(filename = paste0(level, "_bar_chart.jpeg"),
         plot = chart, 
         path = paste0("plots/", download_code), 
         device = "jpeg")
}

lapply(download_codes, function(x) plot_chart(x, "song"))
lapply(download_codes, function(x) plot_chart(x, "artist"))