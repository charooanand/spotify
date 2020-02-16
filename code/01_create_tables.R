# List each folder downloaded from Spotify. 
# Each folder contains the listening data for a 3-month window.
download_folders_list <- list.dirs(path = "raw_data")[-1]

## Define function that tabulates and saves the listen count by song
save_song_count <- function(download_folder){
  
    sh_path <- paste0(download_folder, "/StreamingHistory.json")
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
    
    # Get the download folder code, without the full file path
    download_folder_code <- str_remove(download_folder, "raw_data/")
    
    # Save song_count table to subfolder in tables/ folder.
    # We use Spotify's download code to name the subfolder so the file structure mirrors the raw_data/ folder.
    # If subfolder doesn't yet exist, we create it here.
    if (dir.exists(paste0("tables/", download_folder_code))){
      print("the subfolder for this download already exists")
    } else {
      dir.create(paste0("tables/", download_folder_code))
    }
    
    write.csv(song_count, paste0("tables/", download_folder_code, "/song_count.csv"))
}

lapply(download_folders_list, save_song_count)