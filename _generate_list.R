file_name <- "roster_f2024"

file.create("file_name.txt")
cat("\"roster_f2024\"", file = "file_name.txt")

rmarkdown::render("advisee_list.Rmd", clean = TRUE)

file.rename("advisee_list.pdf", "roster_f2024.pdf")
file.remove("file_name.txt")
