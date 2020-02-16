source("code/00_packages.R")

# List each folder downloaded from Spotify. 
# Each folder contains the listening data for a 3-month window.
tables_folders_list <- list.dirs(path = "tables")[-1]

# List artists that I accidently fall asleep to so that we can filter them out
zzz <- c("Death Cab for Cutie", 
         "Anna of the North",
         "The Cinematic Orchestra",
         "The Fray",
         "Wet")


read_song_count_df <- function(tables_folder){
  
  song_count_df <- vroom(paste0(tables_folder, "/song_count.csv"),
                         delim = ",") %>%
                   filter(!(artistName %in% zzz))
  
  return(song_count_df)
  
}

wes_pal <- wes_palette("GrandBudapest2", 100, type = "continuous")

plot_top_songs_chart <- function(tables_folder){
  
  # TODO Maybe a percentile cut-off is better than an absolute number?
  top_songs <- read_song_count_df(tables_folder) %>%
               filter(listens >= 90)

  top_songs_chart <- ggplot(data = top_songs, aes(x=reorder(song, -listens), y=listens, fill=as.factor(listens))) +
                     scale_fill_manual(values = wes_pal) +
                     geom_bar(stat="identity", show.legend = FALSE) +
                     theme_minimal() +
                     theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
                     xlab("Song") + ylab("Number of Listens")
}


charoo <- plot_top_songs_chart(tables_folders_list[1])
charoo