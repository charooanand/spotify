packages_vector <- c("rjson", 
                     "jsonlite", 
                     "tidyverse", 
                     "tidylog",
                     "vroom",
                     "ggplot2",
                     "wesanderson",
                     "RColorBrewer")

#install.packages(packages_vector)
lapply(packages_vector, require, character.only = TRUE)


# List each folder downloaded from Spotify. 
# Each folder contains the listening data for a 3-month window.
download_folders_list <- list.dirs(path = "raw_data")[-1]

# Get the download folder code, without the full file path
get_code <- function(download_folder){
  
  code <- str_remove(download_folder, "raw_data/")
  
  return(code)
}

download_codes <- lapply(download_folders_list, get_code)