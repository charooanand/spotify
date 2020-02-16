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