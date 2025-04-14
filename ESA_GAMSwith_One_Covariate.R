# Reanalyse arthropod data from gtemp et al (2019) using some
# ideas from Daskalova, Phillimore & Meyers-Smith (2021)
#
# Refs
# Daskalova, G.N., Phillimore, A.B., Myers‐Smith, I.H., 2021. Accounting for
#   year effects and sampling error in temporal analyses of invertebrate
#   population and biodiversity change: a comment on gtemp et al. 2019.
#   *Insect Conserv. Divers.* 14, 149–154. https://doi.org/10.1111/icad.12468
# gtemp, S., Gossner, M.M., Simons, N.K., Blüthgen, N., Müller, J., Ambarlı,
#   D., Ammer, C., Bauhus, J., Fischer, M., Habel, J.C., Linsenmair, K.E.,
#   Nauss, T., Penone, C., Prati, D., Schall, P., Schulze, E.-D., Vogt, J.,
#   Wöllauer, S., Weisser, W.W., 2019. Arthropod decline in grasslands and
#   forests is associated with landscape-level drivers. Nature 574, 671–674.
#   https://doi.org/10.1038/s41586-019-1684-3
##install.packages(c("here", "readr", "janitor", "mgcv", "gratia", "dplyr", "ggplot2",
##                   "ggrepel", "lubridate", "countreg", "rootogram", "ggdist", "ggplot2"))

# packages
pkgs <- c("here", "readr", "janitor", "mgcv", "gratia", "dplyr", "ggplot2",
          "ggrepel", "lubridate", "countreg", "ggdist", "ggplot2")
vapply(pkgs, library, logical(1L),
       character.only = TRUE, logical.return = TRUE)

theme_set(theme_minimal(base_family = "Arial"))

library(readxl)
gtemp <- read_excel("C:/Users/TEKOWNER/OneDrive/MCC_Internship/R_files/ESA_Master_Weather_sheet_sin_spaces.xlsx")

eSA_master_weather_sheet_sin_spaces <- as_tibble(eSA_master_weather_sheet_sin_spaces)

gtemp <- as_tibble(eSA_master_weather_sheet_sin_spaces)

gtemp <- gtemp %>%
  mutate(Date_zeroed_out = factor(Date_zeroed_out))

# abundance
gtemp %>%
  ggplot(aes(x = Date_zeroed_out, y = Pan_trap_abundance)) +
  geom_line(alpha = 0.5) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, k = 40)) +
  labs(y = "Pan Trap Abundance", x = NULL) + 
  theme(text = element_text(family = "Arial"))


# Quasi-Poisson GAM
m_site <- gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~ s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out)), data = gtemp,
              method = "REML", family = quasipoisson())

summary(m_site) # model summary

draw(m_site) # partial effect of smooth

appraise(m_site, method = "simulate") # model diagnostics

k.check(m_site) # check basis size

eSA_master_weather_sheet_sin_spaces$Sites %>%
  add_residuals(m_site) %>%
  ggplot(aes(x = as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out), y = .residual)) +
  geom_line() +
  geom_point()

acf(residuals(m_site))



# autoplot(countreg::rootogram(m_site))

# use multiple threads for fitting
ctrl <- gam.control(nthreads = 4)

# fit to all data
m1 <- gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~
            s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out)), # random effect of plot
          data = gtemp,
          method = "REML",
          family = quasipoisson(),
          control = ctrl)

summary(m1)
draw(m1)

# fit to all data
m2 <- gam(eSA_master_weather_sheet_sin_spaces$Sweep_net_abunance ~
            s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out)), # random effect of plot
          data = gtemp,
          method = "REML",
          family = poisson(),
          control = ctrl)

summary(m2)
draw(m2)

# model diagnostics
appraise(m1, method = "simulate")

# basis size
k.check(m1)

# install.packages("topmodels", repos = "https://R-Forge.R-project.org")

# rootogram
rootogram(m1, max_count = 300) %>%
  draw()



# ## ----hadcrut-temp-penalty, echo = FALSE---------------------------------------
# K <- 40
# lambda <- c(10000, 1, 0.01, 0.00001)
# N <- 571
# newd <- with(gtemp, data.frame(Date_zeroed_out = seq(min(Date_zeroed_out), max(Date_zeroed_out), length = N)))
# fits <- lapply(lambda, function(lambda) gam(eSA_master_weather_sheet_sin_spaces$Pan_trap_abundance ~ s(as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out), k = K, sp = lambda), data = gtemp))
# pred <- vapply(fits, predict, numeric(N), newdata = newd)
# op <- options(scipen = 100)
# colnames(pred) <- lambda
# newd <- cbind(newd, pred)
# lambdaDat <- gather(newd, Lambda, Fitted, - as.numeric(eSA_master_weather_sheet_sin_spaces$Date_zeroed_out))
# lambdaDat <- transform(lambdaDat, Lambda = factor(paste("lambda ==", as.character(Lambda)),
#                                                   levels = paste("lambda ==", as.character(lambda))))
# 
# gtemp_plt + geom_line(data = lambdaDat, mapping = aes(x = eSA_master_weather_sheet_sin_spaces$Date_zeroed_out, y = Fitted, group = Lambda),
#                       size = 1, colour = "#e66101") +
#   facet_wrap( ~ Lambda, ncol = 2, labeller = label_parsed)
# options(op)


# autoplot(gratia::rootogram(m1))


# ## Alternatives with bam()
# ## not threaded unless you set up a cluster -- see ?bam
# ## DON'T RUN THIS IN WEBINAR!! - about 17 minutes
# system.time(
#   b5a <- bam(abundance_identified ~ region + # regional means fixef
#                s(year_f, bs = "re") + # year-to-year effects
#                s(year, by = region) + # region-specific smooths
#                s(year, plot_id, bs = "fs", k = 5), # plot-specific trends
#              data = gtemp,
#              method = "fREML", # <-- fast REML!
#              family = nb(),
#              control = ctrl)
# )
# 
# ## Discretise covariates -- algorithm uses `nthreads` threads
# system.time(
#   b5b <- bam(abundance_identified ~ region + # regional means fixef
#                s(year_f, bs = "re") + # year-to-year effects
#                s(year, by = region) + # region-specific smooths
#                s(year, plot_id, bs = "fs", k = 5), # plot-specific trends
#              data = gtemp,
#              method = "fREML", # <-- fast REML!
#              discrete = TRUE,  # <-- discretise covariates == smaller basis
#              family = nb(),
#              control = ctrl)
# )
# 
# ## Location scale models
# ## about 10 minutes!!
# system.time(
#   m_twlss <- gam(list(
#     abundance_identified ~ region + # regional means fixef
#       s(year_f, bs = "re") + # year-to-year effects
#       s(year, by = region) + # region-specific smooths
#       s(year, plot_id, bs = "fs", k = 5), # plot-specific trends
#     ~ s(plot_id, bs = "re"),
#     ~ s(plot_id, bs = "re")
#   ),
#   data = gtemp,
#   method = "REML",
#   optimizer = "efs",
#   family = twlss(),
#   control = ctrl)
# )
# 
# summary(m_twlss)
# 
# draw(m_twlss)
# 
# appraise(m_twlss)
# 
# ##
# smooths(m5)
# y2y <- smooth_estimates(m5, "s(year_f)")
# 
# y2y %>%
#   ggplot(aes(x = year_f, y = est)) +
#   geom_pointrange(aes(ymin = est - se,
#                       ymax = est + se)) +
#   labs(x = NULL)
# 
# ## other covariates
# gtemp <- gtemp %>%
#   mutate(year_s = scale(year),
#          landuse_intensity_s = scale(landuse_intensity)[,1],
#          mean_winter_temperature_s = scale(mean_winter_temperature)[,1],
#          precipitation_sum_growing_preriod_s =
#            scale(precipitation_sum_growing_preriod)[,1],
#          grassland_cover_1000_s = scale(grassland_cover_1000)[,1],
#          arable_cover_1000_s = scale(arable_cover_1000)[,1])
# 
# ## about 1.5 minutes
# system.time(
#   m_cov <- gam(abundance_identified ~
#                  s(year_s) + # overall trend
#                  s(landuse_intensity_s) +
#                  s(mean_winter_temperature_s) +
#                  s(precipitation_sum_growing_preriod_s) +
#                  s(grassland_cover_1000_s) +
#                  s(arable_cover_1000_s) +
#                  ti(mean_winter_temperature_s,
#                     precipitation_sum_growing_preriod_s) +
#                  ti(year_s, landuse_intensity_s) +
#                  ti(year_s, grassland_cover_1000_s) +
#                  ti(year_s, arable_cover_1000_s) +
#                  s(year_f, bs = "re") + # year-to-year effects
#                  s(plot_id, bs = "re"), # site specific mean abundance
#                family = nb(),
#                method = "REML",
#                control = ctrl,
#                data = gtemp,
#                select = TRUE)
# )
# 
# # plot the smooths
# sms <- smooths(m_cov)
# 
# # plot the univariate smooths
# draw(m_cov, select = sms[1:6])
# 
# # plot the tensor product interation smooths
# draw(m_cov, select = sms[7:10], rug = FALSE)
# 
# # plot the ranefs
# draw(m_cov, select = sms[11:12])
# 
# # plot the overall trend effect
# draw(m_cov, select = "s(year_s)")
# 
# # DON'T RUN IN WEBINAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # put in site specific trends
# # ~17 minutes 
# system.time(
#   m_cov2 <- gam(abundance_identified ~
#                   s(year_s) +
#                   s(landuse_intensity_s) +
#                   s(mean_winter_temperature_s) +
#                   s(precipitation_sum_growing_preriod_s) +
#                   s(grassland_cover_1000_s) +
#                   s(arable_cover_1000_s) +
#                   ti(mean_winter_temperature_s,
#                      precipitation_sum_growing_preriod_s) +
#                   ti(year_s, landuse_intensity_s) +
#                   ti(year_s, grassland_cover_1000_s) +
#                   ti(year_s, arable_cover_1000_s) +
#                   s(year_f, bs = "re") +
#                   s(year_s, plot_id, bs = "fs", k = 5), # <-- here
#                 family = nb(),
#                 method = "REML",
#                 control = ctrl,
#                 data = gtemp)
# )
# 
# AIC(m_cov, m_cov2)
# 
# ##
# smooths(m_cov2)
# y2y <- smooth_estimates(m_cov2, "s(year_f)")
# 
# y2y %>%
#   ggplot(aes(x = year_f, y = est)) +
#   geom_pointrange(aes(ymin = est - se,
#                       ymax = est + se)) +
#   labs(x = NULL)
# 
# draw(m_cov2, select = "s(year_s,plot_id)")

# year, day-of-year

# knots <- list(day_of_year = c(0.5, 366.5))
# gam(y ~ s(year) + s(day_of_year, bs = "cc"), knots = knots)

# knots <- list(month = c(0.5, 12.5))
# gam(y ~ s(year) + s(month, bs = "cc", k = 12), knots = knots)

# gam(y ~ te(year, month, bs = c("tp", "cc")), knots = knots)
# gam(y ~ s(year) + s(month, bs = "cc", k = 12) +
#       ti(year, month, bs = c("tp", "cc")), knots = knots)