# Load required package
# 'readr' is preferred for better encoding handling
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
library(readr)

# Set the folder containing your UTF-16 CSV files
folder_path <- "C:/Users/emendons/OneDrive - California Department of Water Resources/Water Quality Lab - DWR - Fish Restoration Program/Data Downloads/Arnold"

# List all CSV files in the folder
xlsx_files <- list.files(
  path = folder_path,
  pattern = "\\.xlsx$",
  full.names = TRUE
)

# Check if any files found
if (length(xlsx_files) == 0) {
  stop("No xlsx files found in the specified folder.")
}

# Function to safely read UTF-16 CSV
read_utf16_xlsx <- function(file_path) {
  tryCatch({
    # readr::read_csv with encoding
    read_excel(
      file = file_path,
      #locale = locale(encoding = "UTF-16"),
      skip = 8,
      #show_col_types = FALSE
    )
  }, error = function(e) {
    warning(sprintf("Failed to read file: %s\nError: %s", file_path, e$message))
    return(NULL)
  })
}

# Read all CSV files into a list
data_list <- lapply(xlsx_files, read_utf16_xlsx)

# Remove failed reads (NULLs)
data_list <- Filter(Negate(is.null), data_list)

# Optionally combine into one data frame (if same structure)
if (length(data_list) > 0) {
  combined_data <- do.call(dplyr::bind_rows, data_list)
  print("Combined data preview:")
  print(head(combined_data))
} else {
  warning("No valid CSV files were imported.")
}
