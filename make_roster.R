library(rvest)
library(dplyr)
library(janitor)
library(stringr)
library(kableExtra)


semester <- "Spring 2024"
advisor <- "Michael S. Taylor"

html_dat <- read_html("./roster_s2024.html")

roster <- html_dat %>% 
  html_elements(css = ".datadisplaytable") %>% 
  html_table()

roster <- roster[[1]] %>% 
  janitor::clean_names() %>% 
  filter(!grepl("Email", student_name)) %>% 
  filter(!is.na(id)) %>% 
  select(student_name, id, pin = alternate_pin)

email <- 
  html_dat %>% 
  html_elements(xpath = "//a[starts-with(@href,'mailto:')]") %>% 
  html_attr("href")

email <- 
  email[length(email)] %>% 
  stringr::str_remove("mailto:\\?Bcc=") %>% stringr::str_split(pattern = ";") %>% unlist()

roster <- bind_cols(roster, tibble(email = email)) %>% 
  select(`Student Name` = student_name, ID = id, Email = email, PIN = pin)

num_advisees <- dim(roster)[1]

knitr::kable(roster)
