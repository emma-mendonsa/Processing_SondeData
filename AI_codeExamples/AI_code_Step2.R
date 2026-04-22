# ensure types
df[, DateTime := as.POSIXct(DateTime, tz = "UTC")]
spans[, `:=`(start = as.POSIXct(start, tz = "UTC"),
             stop  = as.POSIXct(stop,  tz = "UTC"))]

# create interval index using foverlaps
df_intervals <- df[, .(DateTime, .row = .I)]
df_intervals[, `:=`(start = DateTime, end = DateTime)]

setkey(spans, start, stop)
setkey(df_intervals, start, end)

# find rows that overlap any span
hits <- foverlaps(df_intervals, spans, nomatch = 0L)

# rows to remove
rows_to_remove <- unique(hits$.row)

# filtered result
df_filtered <- df[!rows_to_remove]


#Option 2 — dplyr + lubridate (clearer, simpler for smaller data)

library(dplyr)
library(lubridate)

df <- df %>%
  mutate(datetime = as.POSIXct(paste(`Date (MM/DD/YYYY)`, `Time (HH:mm:ss)`), format = "%Y-%m-%d %H:%M:%S"))

df <- df %>% mutate(datetime = as_datetime(datetime, tz = "UTC"))
spans <- spans %>% mutate(start = as_datetime(start, tz = "UTC"),
                          stop  = as_datetime(stop,  tz = "UTC"))

# for each row, test if datetime falls in any span
df_filtered <- df %>%
  rowwise() %>%
  mutate(in_span = any(datetime >= spans$start & datetime <= spans$stop)) %>%
  ungroup() %>%
  filter(!in_span) %>%
  select(-in_span)


# Notes:
# Use Option 1 for large datasets (data.table scales much better).
# Ensure `start <= stop` in `spans` and matching time zones.


#---
  
library(data.table)

# 1. Convert dataframes to data.tables
setDT(df_data)
setDT(df_spans)

# 2. Perform the non-equi join
# This looks for rows in df_data where 'time' is between 'start' and 'end'
result <- df_data[df_spans, 
                  on = .(DateTime <= start, DateTime >= stop), 
                  nomatch = NULL]


#---
# 2. Find indices of points that fall INSIDE any span
# We use which = TRUE to get row numbers instead of data
inside_indices <- df_data[df_spans, 
                          on = .(DateTime >= start, DateTime <= stop), 
                          which = TRUE, 
                          nomatch = NULL]

# 3. Filter the original data to keep only rows NOT in those indices
# unique() is used in case a point fell into multiple spans
result_outside <- df_data[-(inside_indices)]

#---
# 1. Perform an anti-join to keep rows that DO NOT match the intervals

df_filtered <- fuzzy_anti_join(
  SiteData, 
  spans,
  by = c("DateTime" = "start", "DateTime" = "stop"),
  match_fun = list('>=', '<='))

df_filtered <- SiteData %>%
  filter(!apply(sapply(1:nrow(spans), function(i) {
    DateTime >= spans$start[i] & DateTime <= spans$stop[i]
  }), 1, any))
