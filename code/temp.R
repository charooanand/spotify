# Install packages
packages_vector <- c("rjson", "jsonlite", "tidyverse", "tidylog")
#install.packages(packages_vector)
lapply(packages_vector, require, character.only = TRUE) 

file_path <- "/Users/charooanand/Dropbox/RESEARCH/Spotify/raw_data/001-118966813/StreamingHistory.json"

raw_df <- fromJSON(file_path, flatten =TRUE)
  
listen_count <- raw_df %>% 
                group_by(trackName, artistName) %>% 
                summarise(
                  listens = n()
                ) %>% 
                mutate(
                  track_and_artist = paste0(trackName, " // ", artistName)
                )

songs_about_London <- listen_count %>% 
                      filter(grepl("london", trackName, ignore.case = TRUE))

london_chart <- ggplot(data=songs_about_London, aes(x=factor(track_and_artist), y=listens)) +
                geom_bar(width = 1, stat="identity", colour = "white")
london_chart


songs_by_Taylor<- listen_count %>% 
  filter(artistName == "Taylor Swift",
         listens > 20,
         !(trackName == "You Need To Calm Down")) 

Taylor_chart <- ggplot(data=songs_by_Taylor, aes(x=trackName, y=listens)) +
  geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1))

Taylor_chart


songs_by_Lorde <- listen_count %>% 
                  filter(artistName == "Lorde")
  
lorde_chart <- ggplot(data=songs_by_Lorde, aes(x=trackName, y=listens)) +
                geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1))


artists_I_have_fallen_asleep_to <- c("Death Cab for Cutie", 
                                     "Anna of the North",
                                      "The Cinematic Orchestra",
                                      "The Fray",
                                      "Wet")


top_artists_data <- listen_count %>%
                group_by(artistName) %>% 
                 summarise(
                   listens = sum(listens)
                 ) %>%
                filter(!(artistName %in% artists_I_have_fallen_asleep_to)) %>% 
                filter(listens > 200)

top_artists_chart <- ggplot(data=top_artists_data, aes(x=artistName, y=listens)) +
                      geom_bar(stat="identity") + 
                      theme(axis.text.x = element_text(angle = 90, hjust = 1))


top_songs_data <- listen_count %>%
                  filter(!(artistName %in% artists_I_have_fallen_asleep_to)) %>%
                  filter(listens >= 90)

top_songs_chart <- ggplot(data=top_songs_data, aes(x=track_and_artist, y=listens)) +
                   geom_bar(stat="identity") + 
                   theme(axis.text.x = element_text(angle = 90, hjust = 1))