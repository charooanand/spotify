# Define function that reads in raw Spotify streaming history data
read_sh_df <- function(sh_path){
  
  sh_df <- fromJSON(sh_path, flatten =TRUE) %>%
           rename("song" = "trackName",
                  "artist" = "artistName") %>% 
           mutate(
             song = paste0(song, " // ", artist)
           )
  
  return(sh_df)
}

combine_sh_df <- function(download_code){
  
  sh_paths <- list.files(paste0("raw_data/", download_code), "StreamingHistory", full.names = TRUE)
  
  combined_sh_df <- lapply(sh_paths, read_sh_df) %>% 
                    reduce(rbind)
  
  return(combined_sh_df)
}


#################################
# tabulate listen count by song #
#################################

save_song_count <- function(download_code){

    song_count <- combine_sh_df(download_code) %>% 
                  group_by(song, artist) %>% 
                  summarise(
                    listens = n()
                  ) %>% 
                  arrange(-listens) %>% 
                  select(song, artist, listens)
    
    create_if_nonexistent(paste0("tables/", download_code))
    write.csv(song_count, paste0("tables/", download_code, "/song_count.csv"))
}

lapply(download_codes, save_song_count)

###################################
# tabulate listen count by artist #
###################################

save_artist_count <- function(download_code){
  
  artist_count <- combine_sh_df(download_code) %>% 
    group_by(artist) %>% 
    summarise(
      listens = n()
    ) %>% 
    arrange(-listens) %>% 
    select(artist, listens)
  
  create_if_nonexistent(paste0("tables/", download_code))
  write.csv(artist_count, paste0("tables/", download_code, "/artist_count.csv"))
}

lapply(download_codes, save_artist_count)