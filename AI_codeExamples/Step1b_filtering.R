##Next steps: 1) complete span2.xslx with DateTime columns. 2) run this code.

library(tidyverse)
library(purrr)
my_list <- Arnold_list_monthlyData

#Function: Convert time column in each tibble, rename Time and Date columns, create DateTime column
convertTime_addDateTime <- function(tbl) {
  tbl %>%
    mutate(
      # Combine date and time into a POSIXct datetime
     # datetime = ymd_hms(paste(`Date (MM/DD/YYYY)`, `Time (HH:mm:ss)`), tz = "UTC")
      time = hms::as_hms(`Time (HH:mm:ss)`),
      date = `Date (MM/DD/YYYY)`,
      datetime = ymd_hms(paste(date, time), tz = "UTC")
          )
}


# Apply Function: Add datetime to every tibble in the list
tibble_list <- map(my_list, convertTime_addDateTime)



---- 
#Option 2

# Create a control table with your filter parameters
filter_params <- read_xlsx(path = "span2.xlsx")

# Apply filters using the control table rows
filtered_list <- pmap(list(tibble_list, filter_params$start, filter_params$end), 
                      ~ filter(..1, datetime >= ..2 & datetime <= ..3))
filtered_list <- pmap(list(tibble_list, filter_params$start, filter_params$end), 
                      ~ filter(..1, datetime >= ..2 & datetime <= ..3))
