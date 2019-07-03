library(maps)
library(maptools)
library(data.table)
library(tidyverse)
library(RColorBrewer)
library(classInt)

ukroblast <- readShapePoly("ukraineGIS/gadm36_UKR_1.shp",
                        proj4string = CRS("+proj=longlat"))


reg_gdpraw <- 
  fread("grossregionalproduct.csv") %>%
  select(V1, V29)
reg_gdp <-
  reg_gdpraw[6:32]
colnames(reg_gdp) <-
  c("Oblast", "PerCapitaGDP")
reg_gdp <-
  reg_gdp %>%
  mutate(PerCapitaGDP = as.numeric(PerCapitaGDP),
         ukroblast.NAME_1 = ifelse(Oblast == "Autonomous Republic of Crimea", "Crimea", 
                  ifelse(Oblast == "Dnipropetrovsk", "Dnipropetrovs'k",
                  ifelse(Oblast == "Donetsk", "Donets'k",
                  ifelse(Oblast == "Ivano-Frankivsk", "Ivano-Frankivs'k",
                  ifelse(Oblast == "Khmelnytskiy", "Khmel'nyts'kyy",
                  ifelse(Oblast == "Kyiv" & PerCapitaGDP == 23130, "Kiev City",
                  ifelse(Oblast == "Kyiv" & PerCapitaGDP == 6652, "Kiev",
                  ifelse(Oblast == "Lviv", "L'viv",
                  ifelse(Oblast == "Luhansk", "Luhans'k",
                  ifelse(Oblast == "Odesa", "Odessa",
                  ifelse(Oblast == "Sevastopol", "Sevastopol'",
                  ifelse(Oblast == "Ternopil", "Ternopil'",
                  ifelse(Oblast == "Zakarpattya", "Transcarpathia", Oblast)))))))))))))) %>%
  select(ukroblast.NAME_1, PerCapitaGDP) %>%
  arrange(ukroblast.NAME_1)
ukroblast$percapGDP <-
  reg_gdp$PerCapitaGDP
brks <- c(0, 4750, 6250, 8000, 10000)
color.pallete <- rev(brewer.pal(4,"RdBu"))
class.fitted <- classIntervals(var = ukroblast$percapGDP, n = 4, style = "fixed",
                               fixedBreaks = brks, dataPrecision = 4)
color.code.fitted <- findColours(class.fitted, color.pallete)
plot(ukroblast, col = color.code.fitted, main = "Per Capita GDP By Oblast")
legend("bottomleft", legend = c("< 4750", "4750-6250", "6250-8000", "> 10000"), 
       fill = color.pallete, title = "Per Capita GDP")


