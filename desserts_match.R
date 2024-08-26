library(tidyverse)
library(here)
library(rvest)  # used to scrape website content
library(stringr)

desserts <- read_csv(here("favorite_desserts.csv"))

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of element of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as a proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv

iconic_desserts <- read_csv(here("data", "iconic_desserts.csv")) %>%
  mutate(across(1:2, tolower))

meds_desserts <- desserts %>%
  rename("first_name" = first_name, "last_name" = last_name, "dessert" = Favorite_dessert) %>%
  mutate(across(1:3, tolower))

matches <- meds_desserts %>%
  semi_join(iconic_desserts)
  
#str_detect(iconic_desserts$dessert, meds_desserts$dessert)

#matches <- filter(iconic_desserts, meds_desserts %in% meds_desserts$dessert)

#matches_vec <- iconic_desserts$dessert %in% meds_desserts$dessert



