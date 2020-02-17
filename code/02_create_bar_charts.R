# List artists that I accidently fall asleep to so that we can filter them out
zzz <- c("Death Cab for Cutie", 
         "Anna of the North",
         "The Cinematic Orchestra",
         "The Fray",
         "Wet")

read_song_count_df <- function(download_code){
  
  song_count_df <- vroom(paste0("tables/", download_code, "/song_count.csv"),
                         delim = ",") %>%
                   filter(!(artistName %in% zzz))
  
  return(song_count_df)
  
}

plot_top_songs_chart <- function(download_code){
  
  # TODO Maybe a percentile cut-off is better than an absolute number?
  top_songs <- read_song_count_df(download_code) %>%
               filter(listens >= 90)

  top_songs_chart <- ggplot(data = top_songs, aes(x=reorder(song, -listens), y=listens, fill=song)) +
                     scale_fill_manual(values = random_wes_pal()) +
                     geom_bar(stat="identity", show.legend = FALSE) +
                     theme_minimal() +
                     theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
                     xlab("Song") + ylab("Number of Listens")
  
  # Save bar chart table to subfolder in plots/ folder.
  # We use Spotify's download code to name the subfolder so the file structure mirrors the raw_data/ and tables/ folder.
  create_if_nonexistent(paste0("plots/", download_code))
  
  ggsave(filename = "song_bar_chart.jpeg",
         plot = top_songs_chart, 
         path = paste0("plots/", download_code), 
         device = "jpeg")
}

lapply(download_codes, plot_top_songs_chart)

