##Step1: Create List, Imports all Monthly Data for specified site

# -------- CONFIGURATION --------
folder_path <- monthlyData_path # Change to your folder path

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

# Remove NULLs from failed reads. Ideally, the 'data_list' and 'data_list_2' should match in size.
data_list_2 <- Filter(Negate(is.null), data_list)

