# ensure types
df[, datetime := as.POSIXct(datetime, tz = "UTC")]
spans[, `:=`(start = as.POSIXct(start, tz = "UTC"),
             stop  = as.POSIXct(stop,  tz = "UTC"))]

# create interval index using foverlaps
df_intervals <- df[, .(datetime, .row = .I)]
df_intervals[, `:=`(start = datetime, end = datetime)]

setkey(spans, start, stop)
setkey(df_intervals, start, end)

# find rows that overlap any span
hits <- foverlaps(df_intervals, spans, nomatch = 0L)

# rows to remove
rows_to_remove <- unique(hits$.row)

# filtered result
df_filtered <- df[!rows_to_remove]
```

Option 2 — dplyr + lubridate (clearer, simpler for smaller data)
```r
library(dplyr)
library(lubridate)

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
```

Notes:
  - Use Option 1 for large datasets (data.table scales much better).
- Ensure `start <= stop` in `spans` and matching time zones.