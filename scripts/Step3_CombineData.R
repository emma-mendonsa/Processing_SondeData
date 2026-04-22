#Step 3: Combine list data into a singular dataframe

#Run Loop: Combine list into one dataframe (use bind_rows to handle different columns)
if (length(filtered_list) > 0) {
  library(dplyr)
  combined_rawData_rbind <- bind_rows(filtered_list)
  message("Successfully imported ", nrow(combined_rawData_rbind), " rows from ", length(data_list), " files.")
} else {
  stop("No valid data imported.")
}

# -------- OUTPUT --------
#print(head(combined_data))



