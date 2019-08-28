# First day of tidyR
# Demetra Panos
# 8/27/19


## load library ##

library("tidyverse")

## read data ##
simpsons <- readr::read_delim("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-27/simpsons-guests.csv", delim = "|", quote = "")

