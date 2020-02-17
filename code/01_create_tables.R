## Define function that tabulates and saves the listen count by song
save_song_count <- function(download_code){
  
    sh_path <- paste0("raw_data/", download_code, "/StreamingHistory.json")
    sh_df <- fromJSON(sh_path, flatten =TRUE)
    
    song_count <- sh_df %>% 
                  group_by(trackName, artistName) %>% 
                  summarise(
                    listens = n()
                  ) %>% 
                  mutate(
                    song = paste0(trackName, " // ", artistName)
                  ) %>% 
                  arrange(-listens) %>% 
                  select(song, trackName, artistName, listens)
    
    # Save song_count table to subfolder in tables/ folder.
    # We use Spotify's download code to name the subfolder so the file structure mirrors the raw_data/ folder.
    # If subfolder doesn't yet exist, we create it here.
    if (dir.exists(paste0("tables/", download_code))){
      print("the subfolder for this download already exists")
    } else {
      dir.create(paste0("tables/", download_code))
    }
    
    write.csv(song_count, paste0("tables/", download_code, "/song_count.csv"))
}

lapply(download_codes, save_song_count)