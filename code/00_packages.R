####################
# install packages #
####################

packages_vector <- c("rjson", 
                     "jsonlite", 
                     "tidyverse", 
                     "tidylog",
                     "vroom",
                     "ggplot2",
                     "wesanderson",
                     "ggpubr",
                     "patchwork")

#install.packages(packages_vector)
lapply(packages_vector, require, character.only = TRUE)


#####################################
# get list of download folder codes #
#####################################

# List each folder downloaded from Spotify. 
# Each folder contains the listening data for a 3-month window.
download_folders_list <- list.dirs(path = "raw_data")[-1]

# Get the download folder code, without the full file path
get_code <- function(download_folder){
  
  code <- str_remove(download_folder, "raw_data/")
  
  return(code)
}

download_codes <- lapply(download_folders_list, get_code)


###################################################
# create a random wes anderson paletter generator #
###################################################

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
  interpolate <- wes_palette(pick_wes_pal, 30, type = "continuous")
  
  return(interpolate)
}

###############################################################
# create function that creates a directory if it doesnt exist #
###############################################################

create_if_nonexistent <- function(dir_path){
  
  if (dir.exists(dir_path)){
    print("the subfolder for this download already exists")
  } else {
    dir.create(dir_path)
  }
  
}