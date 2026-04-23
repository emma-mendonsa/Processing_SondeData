#Step 4: Format Dataframe for further processing, e.g. outlier removal

#Create new dataframe for updates
SiteData <- combined_rawData_rbind

#Review and adjust column formatting
u <- sort(unique(na.omit(SiteData$`Site Name`)))

if (length(u) > 1L) {
  stop(sprintf("Error: More than one site name found: %s", toString(u)))
}

#SiteData$`Site Name`<- siteName  #If more than one, review and adjust in excels. Possibly run this line

#Review column names. Determine which are repetitive, etc
colnames(SiteData)

#Combine columns that are repetitive. Typically chlorophyll and TAL
SiteData <- SiteData %>% 
  mutate(`Chlorophyll ug/L` = coalesce(`Chlorophyll ug/L`,`Chlorophyll µg/L`)) %>% #Create combined Chl ug/L column
  mutate(`TAL PC ug/L` = coalesce(`TAL PC ug/L`,`TAL PC µg/L`)) #Create combined TAL ug/L column
  #mutate(depthFt_m = `Depth ft`*0.3048) %>% #Convert depth from feet to meters, if needed
  #mutate(`Depth m` = coalesce(`Depth m`,depthFt_m)) #Create combined Depth m column


#Selects only necessary columns. Drops all columns not listed below.
SiteData_filtered <- SiteData %>% 
  select(any_of(c("date", "time", "datetime", 
          "Site Name",
         "Depth m",
         "Temp °C","SpCond µS/cm",
         "ODO % sat","ODO mg/L",
         "Turbidity FNU",
          "pH","pH mV",
         "Chlorophyll RFU","Chlorophyll ug/L",
         "TAL PC RFU","TAL PC ug/L",
         "fDOM QSU","fDOM RFU",
         "Battery V")))


#Rename columns. First create list of new names, then apply to dataframe
lookup_paramNames <- c(SiteName = "Site Name",
                       Depth_m = "Depth m",
                       Temp_C = "Temp °C",
                       SpCond_uScm = "SpCond µS/cm",
                       ODO_sat = "ODO % sat",
                       ODO_mgL = "ODO mg/L",
                       Turb_FNU = "Turbidity FNU",
                       pH_mV = "pH mV",
                       Chloro_RFU = "Chlorophyll RFU",
                       Chloro_ugL = "Chlorophyll ug/L",
                       TALPC_RFU = "TAL PC RFU",
                       TALPC_ugL = "TAL PC ug/L",
                       fDOM_QSU = "fDOM QSU",
                       fDOM_RFU = "fDOM RFU",
                       Battery_V = "Battery V")

SiteData_filtered <- SiteData_filtered %>% 
  rename(any_of(lookup_paramNames))


#Compare column names
colnames(combined_rawData_rbind)
colnames(SiteData_filtered)

