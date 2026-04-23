#Step 2: Evaluates the list created in Step 1. This removes rows affiliated with when
#         the sonde is out of water during deployment/retrieval.

#Create Function: Create new Time and Date columns & Create DateTime column in each monthly tibble

convertTime_addDateTime <- function(tbl) {
  tbl %>%
    mutate(
      time = hms::as_hms(`Time (HH:mm:ss)`), #creates column, converts time format
      date = `Date (MM/DD/YYYY)`, #creates new date column
      datetime = ymd_hms(paste(date, time), tz = "UTC") #creates new datetime column
    )
}


#Apply Function: Add datetime to every tibble in the list
data_list_datetime <- map(data_list, convertTime_addDateTime)


#Import Stop/Start excel file
filter_timeClips <- read_xlsx(path = "timeClips_perSite.xlsx", sheet = siteName)

#Clip each monthly dataset to "in water" time only, Filtering with the Stop/Start excel file
filtered_list <- pmap(list(data_list_datetime, filter_timeClips$start, filter_timeClips$end), #creates a new list (1=tibble_list, 2=StopStart$start, 3=StopStart$end)
                      ~ filter(..1, datetime >= ..2 & datetime <= ..3)) #filter the new list using numbers above. Filter keeps all rows between the Start and End of each monthly dataset
