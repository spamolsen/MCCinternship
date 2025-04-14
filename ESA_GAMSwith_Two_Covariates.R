##install.packages(c("here", "readr", "janitor", "mgcv", "gratia", "dplyr", "ggplot2",
##                   "ggrepel", "lubridate", "countreg", "rootogram", "ggdist", "ggplot2"))

# packages
pkgs <- c("here", "readr", "janitor", "mgcv", "gratia", "dplyr", "ggplot2",
          "ggrepel", "lubridate", "countreg", "ggdist", "ggplot2")
vapply(pkgs, library, logical(1L),
       character.only = TRUE, logical.return = TRUE)

theme_set(theme_minimal(base_family = "Arial"))

library(readxl)
eSA_master_weather_sheet_sin_spaces <- read_excel("C:/Users/TEKOWNER/OneDrive/MCC_Internship/R_files/ESA_Master_Weather_sheet_sin_spaces.xlsx")

gtemp <- as_tibble(eSA_master_weather_sheet_sin_spaces)

# abundance
gtemp %>%
  ggplot(aes(x = Season_Date_zeroed_out, y = Pan_trap_abundance)) +
  geom_line(alpha = 0.5) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, k = 9)) +
  labs(y = "Pan Trap Abundance", x = NULL) + 
  theme(text = element_text(family = "Arial"))



# Quasi-Poisson GAM
m_site <- gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~ s(as.numeric(eSA_master_weather_sheet_sin_spaces$Season_Date_zeroed_out)), 
              data = gtemp,
              method = "REML", family = quasipoisson())

summary(m_site) # model summary

draw(m_site) # partial effect of smooth

appraise(m_site, method = "simulate") # model diagnostics

k.check(m_site) # check basis size

eSA_master_weather_sheet_sin_spaces$Sites %>%
  add_residuals(m_site) %>%
  ggplot(aes(x = as.numeric(eSA_master_weather_sheet_sin_spaces$Season_Date_zeroed_out), y = .residual)) +
  geom_line() +
  geom_point()

acf(residuals(m_site))

rootogram(m_site, max_count = 125) %>%
  draw(warn_limits = FALSE, bar_fill = "black")

# install.packages("countreg", repos="http://R-Forge.R-project.org") 
# autoplot(countreg::rootogram(m_site))

# use multiple threads for fitting
ctrl <- gam.control(nthreads = 4)

# fit to all data
m1 <- gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~ s(as.numeric(eSA_master_weather_sheet_sin_spaces$Season_Date_zeroed_out))
          + s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out)), # random effect of plot
          data = gtemp,
          method = "REML",
          family = quasipoisson(),
          control = ctrl)

summary(m1)
draw(m1)


# model diagnostics
appraise(m1, method = "simulate")

# basis size
k.check(m1)

# install.packages("topmodels", repos = "https://R-Forge.R-project.org")

# rootogram
rootogram(m1, max_count = 300) %>%
  draw()

# autoplot(gratia::rootogram(m1))
