library(rvest)
library(dplyr)
library(stringr)
library(kableExtra)


semester <- "Fall 2024"
advisor <- "Michael S. Taylor"

html_dat <- read_html("./roster_f2024.html")

roster <- html_dat %>% 
  html_elements(css = ".datadisplaytable") %>% 
  html_table() %>% 
  purrr::pluck(1) %>% 
  janitor::clean_names() %>% 
  filter(!grepl("Email", student_name)) %>% 
  filter(!is.na(id)) %>% 
  select(student_name, id, pin = alternate_pin)

email <- 
  html_dat %>% 
  html_elements(xpath = "//a[starts-with(@href,'mailto:')]") %>% 
  html_attr("href") %>% 
  last() %>% 
  str_remove("mailto:\\?Bcc=") %>% 
  str_split(pattern = ";") %>% 
  unlist()

roster <- 
  bind_cols(
    roster, 
    tibble(Email = email)
  ) %>% 
  select(`Student Name` = student_name, ID = id, Email, PIN = pin) %>% 
  mutate(ID = str_to_lower(ID),
         PIN = str_replace_na(PIN, ""))

num_advisees <- dim(roster)[1]

knitr::kable(roster, booktabs = TRUE)
