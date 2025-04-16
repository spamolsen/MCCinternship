# a <- 3
# b <- 2
# c <- -1
# 
# # solution_1 <- (-b + sqrt(b^2 - 4*a*c) )/ ( 2*a )
# # solution_2 <- (-b - sqrt(b^2 - 4*a*c) )/ ( 2*a )
# 
# # log(exp(1))
# 
# # help("log")
# # args(log)
# 
# # log(8, 2)
# # 2^3
# 
# # CO2
# # pi
# # Inf
# 
# library(dslabs)
# data(murders)
# sort(murders$total)
# 
# x <- c(31, 4, 15, 92, 65)
# x
# sort(x)    # puts elements in order
# 
# index <- order(x)    # returns index that will put x in order
# x[index]    # rearranging by this index puts elements in order
# order(x)
# 
# murders$state[1:10]
# murders$abb[1:10]
# 
# index <- order(murders$total)
# murders$abb[index]    # order abbreviations by total murders
# 
# max(murders$total)    # highest number of total murders
# i_max <- which.max(murders$total)    # index with highest number of murders
# murders$state[i_max]    # state name with highest number of total murders
# 
# x <- c(31, 4, 15, 92, 65)
# x
# rank(x)    # returns ranks (smallest to largest)
# 
# library(dslabs)
# data(murders)
# 
# # how to obtain the murder rate
# murder_rate <- murders$total / murders$population * 100000
# 
# # index <- murder_rate < 0.71
# # index <- murder_rate <= 0.71
# # murders$state[index]
# # 
# # sum(index)
# 
# west <- murders$region == "West"
# safe <- murder_rate <= 1
# index <- safe & west
# murders$state[index]

# x <- c(FALSE,TRUE,FALSE,TRUE,TRUE,FALSE)
# which(x)

# index <- which(murders$state == "Massachusetts")
# murder_rate[index]

# index <- match(c("New York", "Florida", "Texas"),murders$state)
# index
# murders$state[index]
# murder_rate[index]


# c("Boston", "Dakota", "Washington") %in% murders$state

# library(dplyr)
# library(dslabs)
# data("murders")
# 
# pop_in_millions <- murders$population/10^6
# total_gun_murders <- murders$total
# plot(pop_in_millions, total_gun_murders)
# 
# murders <- mutate(murders, rate = total / population * 100000)
# hist(murders$rate)
# 
# boxplot(rate~region, data = murders)
# 
# class(murders$region)

# quadraticRoots <- function(a, b, c) {
#   
#   print(paste0("You have chosen the quadratic equation ", a, "x^2 + ", b, "x + ", c, "."))
#   
#   discriminant <- (b^2) - (4*a*c)
#   
#   if(discriminant < 0) {
#     return(paste0("This quadratic equation has no real numbered roots."))
#   }
#   else if(discriminant > 0) {
#     x_int_plus <- (-b + sqrt(discriminant)) / (2*a)
#     x_int_neg <- (-b - sqrt(discriminant)) / (2*a)
#     
#     return(paste0("The two x-intercepts for the quadratic equation are ",
#                   format(round(x_int_plus, 5), nsmall = 5), " and ",
#                   format(round(x_int_neg, 5), nsmall = 5), "."))
#   }
#   else #discriminant = 0  case
#     x_int <- (-b) / (2*a)
#   return(paste0("The quadratic equation has only one root. This root is ",
#                 x_int))
# }
# 
# 
# quadraticRoots(2, -1, -4)
# 

# 
# library(dslabs)
# data(movielens)
# nrow(movielens)
# nlevels(movielens$genres)

# library(dslabs)
# data(olive)
# head(olive)
# 
# boxplot(palmitic~region, data = olive)
# 
# help("boxplot")

# library(dplyr)
# library(dslabs)
# data("murders")
# 
# murders <- mutate(murders, rate = total / population * 100000)
# 
# # subsetting with filter
# filter(murders, rate <= 0.71)
# 
# # selecting columns with select
# new_table <- select(murders, state, region, rate)
# 
# # using the pipe
# murders %>% select(state, region, rate) %>% filter(rate <= 0.71)


# creating a data frame with stringAsFactors = FALSE
# grades <- data.frame(names = c("John", "Juan", "Jean", "Yao"), 
#                      exam_1 = c(95, 80, 90, 85), 
#                      exam_2 = c(90, 85, 85, 90),
#                      stringsAsFactors = TRUE)
# 
# class(grades$names)

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # minimum, median, and maximum murder rate for the states in the West region
# s <- murders %>% 
#   filter(region == "West") %>%
#   summarize(minimum = min(rate), 
#             median = median(rate), 
#             maximum = max(rate))
# s
# 
# # accessing the components with the accessor $
# s$median
# s$maximum
# 
# # average rate unadjusted by population size
# mean(murders$rate)
# 
# # average rate adjusted by population size
# us_murder_rate <- murders %>% 
#   summarize(rate = sum(total) / sum(population) * 10^5)
# us_murder_rate

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # minimum, median, and maximum murder rate for the states in the West region using quantile
# # note that this returns a vector
# murders %>%
#   filter(region == "West") %>%
#   summarize(range = quantile(rate, c(0, 0.5, 1)))
# 
# # returning minimum, median, and maximum as a data frame
# my_quantile <- function(x){
#   r <-  quantile(x, c(0, 0.5, 1))
#   data.frame(minimum = r[1], median = r[2], maximum = r[3]) 
# }
# murders %>% 
#   filter(region == "West") %>%
#   summarize(my_quantile(rate))

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # average rate adjusted by population size
# us_murder_rate <- murders %>% 
#   summarize(rate = sum(total) / sum(population) * 10^5)
# us_murder_rate
# 
# # us_murder_rate is stored as a data frame
# class(us_murder_rate)
# 
# # the pull function can return it as a numeric value
# us_murder_rate %>% pull(rate)
# 
# # using pull to save the number directly
# us_murder_rate <- murders %>% 
#   summarize(rate = sum(total) / sum(population) * 10^5) %>%
#   pull(rate)
# us_murder_rate
# 
# # us_murder_rate is now stored as a number
# class(us_murder_rate)
# 
# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # average rate adjusted by population size
# us_murder_rate <- murders %>% 
#   summarize(rate = sum(total) / sum(population) * 10^5)
# us_murder_rate
# 
# # using the dot to access the rate
# us_murder_rate <- murders %>% 
#   summarize(rate = sum(total) / sum(population) * 10^5) %>%
#   .$rate
# us_murder_rate
# class(us_murder_rate)

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # group by region
# murders %>% group_by(region)
# 
# # summarize after grouping
# murders %>%
#   group_by(region) %>%
#   summarize(median = median(rate))

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # order the states by population size
# murders %>% arrange(population) %>% head()
# 
# # order the states by murder rate - the default is ascending order
# murders %>% arrange(rate) %>% head()
# 
# # order the states by murder rate in descending order
# murders %>% arrange(desc(rate)) %>% head()
# 
# # order the states by region and then by murder rate within region
# murders %>% arrange(region, rate) %>% head()
# 
# # return the top 10 states by murder rate
# murders %>% top_n(10, rate)

# load data.table package
# load other packages and datasets
# library(tidyverse)
# library(data.table)
# library(dplyr)
# library(dslabs)
# data(murders)
# 
# # convert the data frame into a data.table object
# murders <- setDT(murders)
# 
# # selecting in dplyr
# select(murders, state, region)
# # 
# # selecting in data.table - 2 methods
# murders[, c("state", "region")] |> head()
# murders[, .(state, region)] |> head()
# # 
# # adding or changing a column in dplyr
# murders <- mutate(murders, rate = total / population * 10^5)
# # 
# # adding or changing a column in data.table
# murders[, rate := total / population * 100000]
# head(murders)
# murders[, ":="(rate = total / population * 100000, rank = rank(population))]
# 
# # y is referring to x and := changes by reference
# x <- data.table(a = 1)
# y <- x
# 
# x[,a := 2]
# y
# 
# y[,a := 1]
# x
# 
# # use copy to make an actual copy
# x <- data.table(a = 1)
# y <- copy(x)
# x[,a := 2]
# y

# load packages and prepare the data
# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# library(data.table)
# murders <- setDT(murders)
# murders <- mutate(murders, rate = total / population * 10^5)
# murders[, rate := total / population * 100000]
# 
# # subsetting in dplyr
# filter(murders, rate <= 0.7)
# 
# # subsetting in data.table
# murders[rate <= 0.7]
# 
# # combining filter and select in data.table
# murders[rate <= 0.7, .(state, rate)]
# 
# # combining filter and select in dplyr
# murders %>% filter(rate <= 0.7) %>% select(state, rate)

# # load packages and prepare the data - heights dataset
# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(heights)
# heights <- setDT(heights)
# 
# # summarizing in dplyr
# s <- heights %>% 
#   summarize(average = mean(height), standard_deviation = sd(height))
# 
# # summarizing in data.table
# s <- heights[, .(average = mean(height), standard_deviation = sd(height))]
# 
# # subsetting and then summarizing in dplyr
# s <- heights %>% 
#   filter(sex == "Female") %>%
#   summarize(average = mean(height), standard_deviation = sd(height))
# 
# # subsetting and then summarizing in data.table
# s <- heights[sex == "Female", .(average = mean(height), standard_deviation = sd(height))]
# 
# # previously defined function
# median_min_max <- function(x){
#   qs <- quantile(x, c(0.5, 0, 1))
#   data.frame(median = qs[1], minimum = qs[2], maximum = qs[3])
# }
# 
# # multiple summaries in data.table
# heights[, .(median_min_max(height))]
# 
# # grouping then summarizing in data.table
# heights[, .(average = mean(height), standard_deviation = sd(height)), by = sex]

# # load packages and datasets and prepare the data
# library(tidyverse)
# library(dplyr)
# library(data.table)
# library(dslabs)
# data(murders)
# murders <- setDT(murders)
# murders[, rate := total / population * 100000]
# 
# # order by population
# murders[order(population)] |> head()
# 
# # order by population in descending order
# murders[order(population, decreasing = TRUE)] 
# 
# # order by region and then murder rate
# murders[order(region, rate)]


# # view the dataset
# murders %>% group_by(region)
# 
# # see the class
# murders %>% group_by(region) %>% class()
# 
# # compare the print output of a regular data frame to a tibble
# gapminder
# as_tibble(gapminder)
# 
# # compare subsetting a regular data frame and a tibble
# class(murders[,1])
# class(as_tibble(murders)[,1])
# 
# # access a column vector not as a tibble using $
# class(as_tibble(murders)$state)
# 
# # compare what happens when accessing a column that doesn't exist in a regular data frame to in a tibble
# murders$State
# as_tibble(murders)$State
# 
# # create a tibble
# tibble(id = c(1, 2, 3), func = c(mean, median, sd))
# 

# library(tidyverse)
# library(dplyr)
# library(dslabs)
# data(murders)
# # murders <- mutate(murders, rate = total / population * 10^5)
# # 
# murders <- mutate(murders, rate = total / population * 10^5)
# 
# # # minimum, median, and maximum murder rate for the states in the West region
# # s <- murders %>% 
# #   filter(region == "West") %>%
# #   summarize(minimum = min(rate), 
# #             median = median(rate), 
# #             maximum = max(rate))
# # s
# 
# s <- murders %>%
#   filter(region == "West") %>%
#   summarize(minimum = min(rate),
#             median = median(rate),
#             maximum = max(rate))
# 
# 
# # # accessing the components with the accessor $
# # s$median
# # s$maximum
# 
# s$median
# s$maximum
# s$minimum
# 
# # # average rate unadjusted by population size
# # mean(murders$rate)
# 
# mean(murders$rate)
# 
# # # average rate adjusted by population size
# # us_murder_rate <- murders %>% 
# #   summarize(rate = sum(total) / sum(population) * 10^5)
# # us_murder_rate
# 
# us_murder_rate <- murders %>%
#   summarize(rate = sum(total) / sum(population) * 10^5)
# us_murder_rate

# library(dslabs)
# data(heights)
# options(digits = 3)    # report 3 significant digits for all answers


# average_height <- mean(heights$height)
# 
# total_females <- heights %>%
#   filter(sex == "Female")
# 
# proportion_of_females <- nrow(total_females) / nrow(heights)
# 
# proportion_of_females

# s <- heights %>% 
#   summarize(minimum = min(height),
#             maximum = max(height))
# s
# # accessing the components with the accessor $
# min_height <- s$minimum
# max_height <- s$maximum
# 
# min_height %in% heights$height
# 
# shorty_index <- match(min_height, heights$height)
# 
# 
# subset(heights, height == 50)
# 
# x <- c(seq.int(min_height, max_height))
# x
# 
# sum(!x %in% heights$height)

# library(dslabs)
# library(dplyr)
# data(heights)
# options(digits = 3)    # report 3 significant digits for all answers
# 
# 
# 
# # # adding or changing a column in dplyr
# heights <- mutate(heights, ht_cm = heights$height * 2.54)
# 
# heights
# 
# s <- heights %>%
#   summarize(mean_in_cm = mean(ht_cm))
# s
# # accessing the components with the accessor $
# mean_in_centimeters <- s$mean_in_cm
# mean_in_centimeters
# 
# 
# s <- heights %>%
#   filter(sex == "Female") %>%
#   summarize(mean_in_cm = mean(ht_cm))
# s
# 
# filter(murders, region == "Northeast")
# murders %>% filter(region == "Northeast")


# # an example showing the general structure of an if-else statement
# a <- 0
# if(a!=0){
#   print(1/a)
# } else{
#   print("No reciprocal for 0.")
# }

# a <- 0
# if(a!=0){
#   print(1/a)
# } else{
#   print("no reciprocal for 0")
# }

# # an example that tells us which states, if any, have a murder rate less than 0.5
# library(dslabs)
# data(murders)
# murder_rate <- murders$total / murders$population*100000
# ind <- which.min(murder_rate)
# if(murder_rate[ind] < 0.5){
#   print(murders$state[ind]) 
# } else{
#   print("No state has murder rate that low")
# }
# library(dslabs)
# data(murders)
# 
# murder_rate <- murders$total / murders$population*100000
# ind <- which.min(murder_rate)
# if(murder_rate[ind] < 0.5){
#   print(murders$state[ind])
# } else{
#   print("No state has murder rate that low")
# }
# 
# 
# # # changing the condition to < 0.25 changes the result
# # if(murder_rate[ind] < 0.25){
# #   print(murders$state[ind]) 
# # } else{
# #   print("No state has a murder rate that low.")
# # }
# 
# if(murder_rate[ind] < 0.25){
#   print(murders$state[ind])
# } else{
#   print("No state has a murder rate that low.")
# }
# 
# # # the ifelse() function works similarly to an if-else conditional
# # a <- 0
# # ifelse(a > 0, 1/a, NA)
# 
# a <- 0
# ifelse(a > 0, 1/a, "My granny called she said travy u work too hard")
# 
# # # the ifelse() function is particularly useful on vectors
# # a <- c(0,1,2,-4,5)
# # result <- ifelse(a > 0, 1/a, NA)
# 
# a <- c(0,1,2,-4,5)
# result <- ifelse(a > 0, 1/a, "One Two Buckle My Shoeeee")
# result
# # # the ifelse() function is also helpful for replacing missing values
# # data(na_example)
# # no_nas <- ifelse(is.na(na_example), 0, na_example) 
# # sum(is.na(no_nas))
# 
# data(na_example)
# sum(is.na(na_example))
# no_nas <- ifelse(is.na(na_example), 0, na_example)
# sum(is.na(no_nas))
# 
# # # the any() and all() functions evaluate logical vectors
# # z <- c(TRUE, TRUE, FALSE)
# # any(z)
# # all(z)
# 
# z <- c(TRUE, TRUE, FALSE)
# any(c(TRUE, TRUE, FALSE))
# all(c(TRUE, TRUE, FALSE))
# 
# any(z)
# any(z)

# # example of defining a function to compute the average of a vector x
# avg <- function(x){
#   n <- length(x)
#   s <- sum(x)
#   s/n
# }
# 
# # we see that the above function and the pre-built R mean() function are identical
# x <- 1:100
# identical(mean(x), avg(x))
# 
# # variables inside a function are not defined in the workspace
# s <- 3
# avg(1:10)
# s
# 
# # # the general form of a function
# # my_function <- function(VARIABLE_NAME){
# #   perform operations on VARIABLE_NAME and calculate VALUE
# #   VALUE   # return VALUE
# # }
# 
# # functions can have multiple arguments as well as default values
# avg <- function(x, arithmetic = TRUE){
#   n <- length(x)
#   ifelse(arithmetic, sum(x)/n, prod(x)^(1/n))
# }

# # creating a function that computes the sum of integers 1 through n
# compute_s_n <- function(n){
#   x <- 1:n
#   sum(x)
# }
# 
# # # a very simple for-loop
# # for(i in 1:5){
# #   print(i)
# # }
#  
# for(i in 1:5){
#   print(i)
# }
# 
# # # a for-loop for our summation
# # m <- 25
# # s_n <- vector(length = m) # create an empty vector
# # for(n in 1:m){
# #   s_n[n] <- compute_s_n(n)
# # }
# 
# m <- 25
# s_n <- vector(length = m)
# for(n in 1:m){
#   s_n[n] <- compute_s_n(n)
# }
# 
# # # creating a plot for our summation function
# # n <- 1:m
# # plot(n, s_n)
# 
# n <- 1:m
# plot(n, s_n)
# 
# # a table of values comparing our function to the summation formula
# head(data.frame(s_n = s_n, formula = n*(n+1)/2))
# 
# # overlaying our function with the summation formula
# plot(n, s_n)
# lines(n, n*(n+1)/2)
# 
# 
# library(dslabs)
# data(heights)
# 
# 
# # mean(ifelse(heights$height > 72, heights$height, 0))
# 
# inches_to_ft <- function(n){
#   n / 12
# }
#  inches_to_ft(144)
# 
# sum(ifelse(inches_to_ft(heights$height) < 5, 1, 0))



# Copy the spreadsheet containing the US murders data (included as part of the dslabs package) 
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs") 
fullpath <- file.path(dir, filename)
file.copy(fullpath, "murders.csv")

# Once the file is copied, import the data with a line of code. Use the read_csv function from the readr package (included in the tidyverse)
library(tidyverse)
dat <- read_csv(filename)

# See an example of a full path on your system 
system.file(package = "dslabs")

# Use the function list.files to see examples of relative paths
dir <- system.file(package = "dslabs")
list.files(path = dir)

# Get the full path of your working directory by using the getwd function
wd <- getwd()

# Obtain a full path without writing out explicitly 
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs") 
fullpath <- file.path(dir, filename)

# By exploring the directories in dir we find that the extdata contains the file we want
dir <- system.file(package = "dslabs") 
filename %in% list.files(file.path(dir, "extdata"))

# See an example of a full path on your system 
system.file(package = "dslabs")

# Use the function list.files to see examples of relative paths
dir <- system.file(package = "dslabs")
list.files(path = dir)

# Get the full path of your working directory by using the getwd function
wd <- getwd()

# Obtain a full path without writing out explicitly 
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs") 
fullpath <- file.path(dir, filename)

# By exploring the directories in dir we find that the extdata contains the file we want
dir <- system.file(package = "dslabs") 
filename %in% list.files(file.path(dir, "extdata"))

# Copy the file to our working directory 
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs") 
fullpath <- file.path(dir, filename)
file.copy(fullpath, "murders.csv")

# Load it directly
library(readr)

# Open the file to take a look or use the function read_lines to look at a few lines
read_lines("murders.csv", n_max = 3)

# Read-in the data into R from the .csv suffix 
dat <- read_csv(filename)

# Confirm that the data has in fact been read-in 
View(dat)

# Use the full path for the file
dat <- read_csv(fullpath)

# Load the readxl package using
library(readxl)

# Our dslabs package is on GitHub and the file we downloaded with the package has a url
url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"

# Use read_csv file to read these files directly
dat <- read_csv(url)

# Use the download.file function in order to have a local copy of the file
download.file(url, "murders.csv")

# Run a command like this which erases the temporary file once it imports the data
tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename)

# Use scan to read-in each cell of a file
path <- system.file("extdata", package = "dslabs")
filename <- "murders.csv"
x <- scan(file.path(path, filename), sep = ",", what = "c")
x[1:10]

