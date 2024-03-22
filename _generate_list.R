# Be sure to remove grad students from html roster. 
# See readme.md file for details.

file_name <- "roster_f2024"

file.create("file_name.txt")
#cat("\"roster_f2024\"", file = "file_name.txt")
cat(file_name, file = "file_name.txt")

rmarkdown::render("advisee_list.Rmd", clean = TRUE)

#file.rename("advisee_list.pdf", "roster_f2024.pdf")
file.rename("advisee_list.pdf", paste0(file_name, ".pdf"))

file.remove("file_name.txt")
