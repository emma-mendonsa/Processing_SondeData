#setwd("C:/Users/emendons/OneDrive - California Department of Water Resources/Water Quality Lab - DWR - Fish Restoration Program/Data Downloads/Arnold")

xlsxfiles <- list.files(pattern = "\\.xlsx$", full.names = TRUE)
print(xlsxfiles)

dataframe_names <- xlsxfiles %>% 
  str_replace_all(c(".xlsx" = "", "./" = ""))
print(dataframe_names)

dat <- lapply(xlsxfiles, 
              FUN = function(x)fread(x, skip_to_line = 9)) %>% 
  set_names(dataframe_names)

## Next try
 dat <- list()
for (x in unique(xlsxfiles)) {
  dat[[x]] <- fread(x)
} 
 
 dat <- dat %>% 
   set_names(dataframe_names)
 
 
 ## Next try.. works but 
 library(readxl)
file.list <- list.files(pattern='*xlsx', recursive = TRUE) 
df.list <- lapply(file.list, read_excel) %>% 
  set_names(dataframe_names)

  
###
  