#Got it — if you want to skip the first 8 rows when importing each .xlsx file in R, you can use the skip argument in read_excel() from the readxl package.
#Here’s the updated batch import script with that change applied:
  
  R# Install required package if not already installed
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}

library(readxl)

# -------- CONFIGURATION --------
folder_path <- "C:/Users/emendons/OneDrive - California Department of Water Resources/Water Quality Lab - DWR - Fish Restoration Program/Data Downloads/Arnold"  # Change to your folder path

# -------- VALIDATION --------
if (!dir.exists(folder_path)) {
  stop("The specified folder does not exist: ", folder_path)
}

# List all .xlsx files (excluding temporary Excel files starting with ~)
xlsx_files <- list.files(
  path = folder_path,
  pattern = "\\.xlsx$",
  full.names = TRUE
)
xlsx_files <- xlsx_files[!grepl("^~\\$", basename(xlsx_files))]

if (length(xlsx_files) == 0) {
  stop("No .xlsx files found in the folder: ", folder_path)
}

# -------- IMPORT FUNCTION --------
read_excel_safe <- function(file) {
  tryCatch({
    message("Reading: ", basename(file))
    # Skip first 8 rows
    read_excel(file, skip = 8)
  }, error = function(e) {
    warning("Failed to read file: ", file, " — ", e$message)
    NULL
  })
}

# -------- BATCH IMPORT --------
data_list <- lapply(xlsx_files, read_excel_safe)

# Remove NULLs from failed reads
data_list_2 <- Filter(Negate(is.null), data_list)

# Combine into one data frame (use bind_rows to handle different columns)
if (length(data_list) > 0) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr")
  }
  library(dplyr)
  combined_data <- bind_rows(data_list)
  message("Successfully imported ", nrow(combined_data), " rows from ", length(data_list), " files.")
} else {
  stop("No valid data imported.")
}

# -------- OUTPUT --------
print(head(combined_data))


##Emma add as double check. Should match "combined_data" ##
AllSites <- data_list %>% 
  reduce(full_join) 