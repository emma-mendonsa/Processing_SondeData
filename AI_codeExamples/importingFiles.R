#setwd("/dataImport")

CSVfiles <- list.files(pattern = "\\.csv$", full.names = TRUE)
print(CSVfiles)

dataframe_names <- CSVfiles %>% 
  str_replace_all(c(".csv" = "", "./" = ""))
print(dataframe_names)

dat <- lapply(CSVfiles, 
              FUN = function(x)fread(x,skip = 8)) %>% 
  set_names(dataframe_names)

