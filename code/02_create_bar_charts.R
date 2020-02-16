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

# TODO work out how to get wesanderson to return a list of the NAMES of palettes
wes_palettes_list <- c("BottleRocket1",
                       "BottleRocket2",
                       "Rushmore1",
                       "Royal1",
                       "Royal2",
                       "Zissou1",
                       "Darjeeling1",
                       "Darjeeling2",
                       "Chevalier1",
                       "FantasticFox1",
                       "Moonrise1",
                       "Moonrise2",
                       "Moonrise3",
                       "Cavalcanti1",
                       "GrandBudapest1",
                       "GrandBudapest2",
                       "IsleofDogs1",
                       "IsleofDogs2")

# Pick a random Wes Anderson palette 
random_wes_pal <- function(){
  
  # wes_palettes is a list of all the palettes
  # Here we sample a random palette from the list
  pick_wes_pal <- wes_palettes_list[sample(1:length(wes_palettes_list), 1)]
  # And then we interpolate the discrete scale so we have enough colours
  continuous_wes_pal <- wes_palette(pick_wes_pal, 100, type = "continuous")
  
  return(continuous_wes_pal)
}

plot_top_songs_chart <- function(tables_folder){
  
  # TODO Maybe a percentile cut-off is better than an absolute number?
  top_songs <- read_song_count_df(tables_folder) %>%
               filter(listens >= 90)

  top_songs_chart <- ggplot(data = top_songs, aes(x=reorder(song, -listens), y=listens, fill=as.factor(listens))) +
                     scale_fill_manual(values = random_wes_pal()) +
                     geom_bar(stat="identity", show.legend = FALSE) +
                     theme_minimal() +
                     theme(axis.text.x = element_text(angle = 80, hjust = 1)) +
                     xlab("Song") + ylab("Number of Listens")
  
  # Get the download folder code, without the full file path
  table_folder_code <- str_remove(tables_folder, "tables/")
  
  
  # TODO this was copied from 01_. Find a way to avoid copying.
  # Save bar chart table to subfolder in plots/ folder.
  # We use Spotify's download code to name the subfolder so the file structure mirrors the raw_data/ and tables/ folder.
  # If subfolder doesn't yet exist, we create it here.
  if (dir.exists(paste0("plots/", table_folder_code))){
    print("the subfolder for this download already exists")
  } else {
    dir.create(paste0("plots/", table_folder_code))
  }
  
  ggsave(filename = "song_bar_chart",
         plot = top_songs_chart, 
         path = paste0("plots/", table_folder_code), 
         device = "jpeg")
}

lapply(tables_folders_list, plot_top_songs_chart)

