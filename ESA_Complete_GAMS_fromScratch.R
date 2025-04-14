# packages
pkgs <- c("here", "readr", "janitor", "mgcv", "gratia", "dplyr", "ggplot2",
          "ggrepel", "lubridate", "countreg", "ggdist", "ggplot2")
vapply(pkgs, library, logical(1L),
       character.only = TRUE, logical.return = TRUE)


## Reading the Excel file (Exported from Access) and putting it in a 
## tibble called gtemp
library(readxl)
eSA_master_weather_sheet_sin_spaces <- read_excel("C:/Users/TEKOWNER/OneDrive/MCC_Internship/R_files/ESA_Master_Weather_sheet_sin_spaces.xlsx")
gtemp <- as_tibble(eSA_master_weather_sheet_sin_spaces)

theme_set(theme_minimal(base_family = "Arial"))


# ## Linear Plot for Pan Trap Abundance and the Date
# gtemp_plt <- ggplot(gtemp, aes(x = Date_zeroed_out, y = Pan_trap_abundance)) +
#   geom_line() + 
#   geom_point() +
#   labs(x = 'Date_zeroed_out', y = 'Pan Trap Abundance')
# gtemp_plt
# 
# 
# ## Linear Plot for Sweep Net Abundance and the Date
# gtemp_plt <- ggplot(gtemp, aes(x = Date_zeroed_out, y = Sweep_net_abunance)) +
#   geom_line() +
#   geom_point() +
#   labs(x = 'Date Zeroed Out', y = 'Sweep Net Abundance')
# gtemp_plt

# Quasi-Poisson GAM
m1 <- gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~ s(as.numeric(eSA_master_weather_sheet_sin_spaces$Season_Date_zeroed_out))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Year_only))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Air_temp))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Cloud_Cover))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out)),
          data = gtemp,
          method = "REML",
          family = quasipoisson(),
          control = gam.control(k = 20))

summary(m1) # model summary
draw(m1) # partial effect of one of the smooths while keep other's constant
appraise(m1, method = "simulate") # model diagnostics
k.check(m1) # check basis size
# Residual plot
acf(residuals(m1))

# rootogram
rootogram(m1, max_count = 300) %>%
  draw(warn_limits = FALSE, bar_fill = "black")


