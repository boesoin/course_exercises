#### download if necessary and load the libraries:
pacman::p_load(
  rio,         # import/export
  here,        # file locator
  usethis,
  gitcreds,
  tidyverse,
  medicaldata,
  cowplot
)


#### set the relative paths using the here-function:
#note: the here function is independent of platform; this is neat!
rd <- here("scripts")
dd <- here("data")
ld <- here("log")
org <-here("orig")
pre <-here("pre_output")
###


### git-connection:

usethis::use_git_config(user.name="boesoin", user.email="andreas.boss@unibe.ch")
gitcreds::gitcreds_set()
gitcreds_get() # see what you have
credentials::set_github_pat()

usethis::gh_token_help()
usethis::git_sitrep()
gh::gh_whoami()

usethis::use_git()
usethis::use_github()

####

###############################################################################



x <- c(1, 4, 6, 8)
x



# This script illustrates R as a calculator

6 / 2 * (1 + 2) # Comments can also be placed to the right of code.

#####

# data frames are tables --> way to store different vectors of same length
# lists are numbers of vectors..


# factor = categorical variables

# assigning values:
x <-2
x

x <- c(1, 4, 6, 8)
x

SUM(X)
sum(x)
?sum

# see cheat sheets!


###### part Alan

data.frame(code = c(0, 1),
           label = c("male", "female"))
#--> this is baser
# tidyverse:

tibble::tribble(
  ~code, ~label,
  0,     "male",
  1,     "female"
)

#### load in data
#haven::read_spss --> read in from
cars <- data(mtcars)


##### exercise : read in data:
# 1) tidyverse
library(readr)
data <- read_csv(here("data", "raw", "insurance_with_date.csv"), fileEncoding = "UTF-8")

# 2 ) base r
data_baser <- read.csv(here("data", "raw", "insurance_with_date.csv"), fileEncoding = "UTF-8")



# data wrangling:
str(data) # do we get what we expect to get?
str(data_baser)
summary(data)
summary(data_baser)
na_count <- sum(is.na(data))
###############

###
fct <- factor(sex, levels = c("male", "female", "non-binary"))
fct

### pipes: do multiple actions in a row
data |>
  mutate(new_var = rnorm(10)) |>
  rename(random = new_var) |>
  etc()


strep_tb |> select(patient_id, arm, gender)
strep_tb |> select(patient_id:gender, last_col())
strep_tb |> select(1:2, 13)
vars <- c("patient_id", "arm", "gender")
strep_tb |> select(all_of(vars))
######
?across

library(stringr)
txt <- "A siLLy exAmple "


#################### exercise 2, monday morningd
data_proc <- data
help(mutate)
str(data_proc)
temp<- mutate(date_6m = date + months(6))



fact<- factor(sex)




### from solution:
reformatted <- data |>  # pipe
  mutate(
    across(c(sex, region), factor),
    # sex = factor(sex),
    # region = factor(region),
    gt2_children = children > 2,
    smokes = smoker == "yes",
    date_6m = date + months(6)
    # date_6m = date + 30.4 * 6
  )
str(reformatted)

#### how do I collect the correct frame?

###############################################################################
############ Monday afternoon - plotting  #####################################

#base-r:
plot(mtcars$disp, mtcars$hp,
     xlab = "displacement (cu. in.)",
     ylab = "power (hp)",
     main = "Scatter plot in base plot")

library(ggplot2)

# tidyverse -->
ggplot(mtcars, aes(x = disp, y = hp)) +
  geom_point() +
  xlab("displacement (cu. in.)") +
  ylab("power (hp)") +
  ggtitle("Scatter plot in ggplot")

#### second part: afternoon, ggplot2

# Read Ebola data and sort it by date.
# Determine what variables you need to include in your dataframe to make the type of plot shown below.
# Create a dataframe with the required variables and all data for 3 countries before 31 March 2015.
# bulk uncomment: ctrl + shift + c

# data_ebola <- read_csv(here("data", "raw", "ebola.csv"))
# str(data_ebola)
#
# # format column
# data_ebola$Date <- as.Date(data_ebola$Date)
#
# data_ebola <- arrange(data_ebola, Date)
# head(data_ebola)
# dim(data_ebola)
#
#
# #ex4a <- ebola$Country ebola$Date ebola$Cum_conf_cases
# data_ebola_cum_cases <- data_ebola %>%
#   select(date = Date, country =Country, cum_conf_cases = Cum_conf_cases)
#   filter(date < as.Date("2015-04-01") &
#          (country = "Guinea" | country = "liberia" | country = "Sierra Leone"))
# --> goonhere
#
#
#
# data_ebola_cum_cases <- AS.dATE("data_ebola") %>%
#   select(date =Date, country =Country, cum_conf_cases = Cum_conf_cases) %>%
#   filter(date < as.Date("2015-04-01") &
#            (country = "Guinea" | country = "liberia" | country = "Sierra Leone"))

#### solutions:
# load library
library(dplyr)

# read Ebola data
data_ebola <- read.csv("data/raw/ebola.csv")

# format column datum of data_ebola as date
data_ebola$Date <- as.Date(data_ebola$Date)

# sort data_ebola by date
data_ebola <- arrange(data_ebola, Date)

head(data_ebola)

# filter data_ebola: cumulative number of confirmed cases in Guinea,
# Liberia and Sierra Leone before 31 March 2015
data_ebola_cum_cases <- data_ebola %>%
  select(date = Date, country = Country, cum_conf_cases = Cum_conf_cases) %>%
  filter(date <= as.Date("2015-03-31") &
           (country == "Guinea" | country ==  "Liberia" | country == "Sierra Leone"))

# crete point plot
plot_ebola_point_v0 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases)) +
  geom_point()
plot_ebola_point_v0 # display the plot!

# create line plot
plot_ebola_line_v1 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases)) +
  geom_line(aes(group = country))
plot_ebola_line_v1


# create column plot
plot_ebola_col_v02 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases)) +
                            geom_col(position = "stack")
plot_ebola_col_v02

###### 4c-solution
# create point plot
plot_ebola_point_v1 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases)) +
  geom_point(alpha = 0.7, colour = "blue", fill = "green",
             shape = 22, size = 1.5, stroke = 1.5)
plot_ebola_point_v1

# create line plot
plot_ebola_line_v1 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, colour = "blue", linetype = "dashed", linewidth = 1.5)
plot_ebola_line_v1

# create column plot
plot_ebola_col_v1 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases)) +
  geom_col(alpha = 0.7, colour = "blue", fill = "green",
           linetype = "solid", linewidth = 0.1, position = "stack", width = 0.7)
plot_ebola_col_v1

###### 4D solution:
# create point plot
plot_ebola_point_v2 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5)
plot_ebola_point_v2

# use a different colour palette:
plot_ebola_point_v2 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  scale_color_brewer(palette = "Set2")  # Specify the desired color palette

plot_ebola_point_v2

#### add labels:
# create point plot
plot_ebola_point_v3 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  scale_color_brewer(palette = "Set1")  # Specify the desired color palette
  plot_ebola_point_v3

# create line plot
plot_ebola_line_v3 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")

# create column plot
plot_ebola_col_v3 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  scale_color_brewer(palette = "Set2")

plot_ebola_col_v3

# create line plot
plot_ebola_line_v2 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5)

# create column plot
plot_ebola_col_v2 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7)


#### 4F solution:
# create point plot
# plot_ebola_point_v4 <- ggplot(data = data_ebola_cum_cases,
#                               mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
#   geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
#   scale_fill_manual(name = "Country",
#                     breaks = c("Guinea", "Liberia", "Sierra Leone"),
#                     values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
#                     labels = c("GIN", "LBR", "SLE")) +
#   scale_colour_manual(name = "Country",
#                       breaks = c("Guinea", "Liberia", "Sierra Leone"),
#                       values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
#                       labels = c("GIN", "LBR", "SLE")) +
#   ggtitle(label = "Confirmed Ebola") +
#   xlab(label = "Time") +
#   ylab(label = "Cum. # of confirmed cases")

plot_ebola_point_v4 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  scale_fill_manual(name = "Country",
                    #breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c("#FF0000", "#00BFFF", "#FFDB58"),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c("#FF0000", "#00BFFF", "#FFDB58"),
                      labels = c("GIN", "LBR", "SLE")) +
  ggtitle(label = "Confirmed Ebola") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")
plot_ebola_point_v4


# create line plot
plot_ebola_line_v4 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  ggtitle(label = "Confirmed Ebola") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")

# create column plot
plot_ebola_col_v4 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")

################# 4g solution:
# create point plot

plot_ebola_point_v5 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7,
             shape = 22, size = 1.5, stroke = 1.5) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c("#FF0000", "#00BFFF", "#FFDB58"),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c("#FF0000", "#00BFFF", "#FFDB58"),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")
plot_ebola_point_v5

# create line plot
plot_ebola_line_v5 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")

# create column plot
plot_ebola_col_v5 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 15000, by = 2500),
                     limits = c(0, 15000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")


# create point plot
plot_ebola_point_v6 <- ggplot(data = data_ebola_cum_cases,
  mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
    scale_colour_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

# create line plot
plot_ebola_line_v6 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

# create column plot
plot_ebola_col_v6 <- ggplot(data = data_ebola_cum_cases,
mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 15000, by = 2500),
                     limits = c(0, 15000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

########
# create point plot
plot_ebola_point_v6 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

# create line plot
plot_ebola_line_v6 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases, colour = country)) +
  geom_line(mapping = aes(group = country),
            alpha = 0.7, linetype = "dashed", linewidth = 1.5) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 2500),
                     limits = c(0, 10000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

# create column plot
plot_ebola_col_v6 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c(unibeRedS()[1], unibeOceanS()[1], unibeMustardS()[1]),
                      labels = c("GIN", "LBR", "SLE")) +
  scale_x_date(breaks = as.Date(c("2014-08-29", "2014-10-01", "2014-12-01", "2015-02-01", "2015-04-01")),
               labels = c("29 August", "1 October", "1 December", "1 February", "1 April"),
               limits = as.Date(c("2014-08-28", "2015-04-01"))) +
  scale_y_continuous(breaks = seq(from = 0, to = 15000, by = 2500),
                     limits = c(0, 15000)) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases") +
  theme_bw() + theme(legend.position="bottom")

















