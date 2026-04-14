# Load required package
# 'readr' is preferred for better encoding handling
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
library(readr)

# Set the folder containing your UTF-16 CSV files
folder_path <- "C:/Users/emendons/OneDrive - California Department of Water Resources/Water Quality Lab - DWR - Fish Restoration Program/Data Downloads/Arnold/CSV"

# List all CSV files in the folder
csv_files <- list.files(
  path = folder_path,
  pattern = "\\.csv$",
  full.names = TRUE
)

# Check if any files found
if (length(csv_files) == 0) {
  stop("No CSV files found in the specified folder.")
}

# Function to safely read UTF-16 CSV
read_utf16_csv <- function(file_path) {
  tryCatch({
    # readr::read_csv with encoding
    read_csv(
      file = file_path,
      locale = locale(encoding = "UTF-16"),
      show_col_types = FALSE
    )
  }, error = function(e) {
    warning(sprintf("Failed to read file: %s\nError: %s", file_path, e$message))
    return(NULL)
  })
}

# Read all CSV files into a list
data_list <- lapply(csv_files, read_utf16_csv)

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
