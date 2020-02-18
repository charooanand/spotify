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
                     "patchwork",
                     "extrafont",
                     "extrafontdb",
                     "testthat")

#install.packages(packages_vector)
lapply(packages_vector, library, character.only = TRUE)

####################
# set up vapoRwave #
####################

# Install vapoRwave
devtools::install_github("moldach/vapoRwave")
library("vapoRwave")

# Import fonts
#font_import()
loadfonts()

fonts <- c("SF Alien Encounters",
           "SF Alien Encounters Solid",
           "VCR OSD Mono",
           "OCR A Extended",
           "Windows Command Prompt",
           "Blade Runner Movie Font",
           "Streamster")

check_fonts_loaded <- function(font){
  testthat::test_that("fonts loaded",
  testthat::expect_equal(font %in% extrafont::fonts(), TRUE))
}

lapply(fonts, check_fonts_loaded)

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