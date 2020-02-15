packages_vector <- c("rjson", 
                     "jsonlite", 
                     "tidyverse", 
                     "tidylog",
                     "ggplot2",
                     "wesanderson")

#install.packages(packages_vector)
lapply(packages_vector, require, character.only = TRUE) 