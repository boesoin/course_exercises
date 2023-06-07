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



### git-connection:

# usethis::use_git_config(user.name="boesoin", user.email="andreas.boss@unibe.ch")
# gitcreds::gitcreds_set()
# gitcreds_get() # see what you have
# credentials::set_github_pat()
#
# usethis::gh_token_help()
# usethis::git_sitrep()
# gh::gh_whoami()
#
# usethis::use_git()
# usethis::use_github()
#### https://happygitwithr.com/existing-github-last.html
# usethis::create_project("N:/r_projects/r_course_2023/course_exercises")
# usethis::use_git()
# usethis::use_github()
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
sum(x)
?sum # use the help-files

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
#haven::read_spss / stata --> read in from
cars <- data(mtcars)
str(mtcars)
?str # note: str stands for structure


##### exercise : read in data:
# 1) tidyverse

##### import data
library(readr)
library(here)
data <- read_csv(here("data", "raw", "insurance_with_date.csv")) # this works!

data2 <- read_csv(here("data", "raw", "insurance_with_date.csv"), fileEncoding = "UTF-8",
         locale = locale(encoding = "UTF-8"))
# does still not work...


## import stata-data
## does it import labels?
library(readr)
library(here)
cmh <- haven::
f04_spitex__interrai_community_health_interrai_cmh_v2__module_lbld_d_0801.dta

library(haven)
cmh <- read_dta(here("data", "raw","f04_spitex__interrai_community_health_interrai_cmh_v2__module_lbld_d_0801.dta"))
str(cmh)

tabulated_data <- table(cmh$ia2)
print(tabulated_data)

# Extract the variable of interest
ia2 <- labelled(cmh$ia2)

# Tabulate the variable with labels
tabulated_data <- table(attributes(ia2)$labels[as.character(ia2)])

# Print the tabulated results with labels
print(tabulated_data)
# --> this does not quite work yet, but it is a start..
# apparently, I can load labelled stata-data into r --> in principle, I can do data-wrangling using stata and
# then use r in a second step


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

########################### 4a/b #####################################################
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
data_ebola_cum_cases <- data_ebola %>% # note: this is the old "piping" symbol
  select(date = Date, country = Country, cum_conf_cases = Cum_conf_cases) %>%
  filter(date <= as.Date("2015-03-31") &
           (country == "Guinea" | country ==  "Liberia" | country == "Sierra Leone"))

# crete point plot
plot_ebola_point_v0 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases)) +
                            geom_point()
plot_ebola_point_v0 # display the plot!

# create line plot
plot_ebola_line_v0 <- ggplot(data = data_ebola_cum_cases,
                             mapping = aes(x = date, y = cum_conf_cases)) +
                              geom_line(aes(group = country))
plot_ebola_line_v0


# create column plot
plot_ebola_col_v0 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases)) +
                            geom_col(position = "stack")
plot_ebola_col_v0



##############################   4c-solution   ##############################
# create point plot
plot_ebola_point_v1 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases)) +
  geom_point(alpha = 0.7, colour = "blue", fill = "green",
             shape = 22, size = 1.5, stroke = 1.5)
plot_ebola_point_v1
#note: alpha = saturation



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

############################ 4D solution:  #############################################
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
plot_ebola_line_v3

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



########################## 4F solution: ###################################
#######
##
  # Red: #FF0000
  # Blue: #0000FF
  # Green: #00FF00
  # Yellow: #FFFF00
  # Cyan: #00FFFF
  # Magenta: #FF00FF
  # Orange: #FFA500
  # Purple: #800080
  # Brown: #A52A2A
  # Pink: #FFC0CB
  # Gray: #808080
##
########

plot_ebola_point_v4 <- ggplot(data = data_ebola_cum_cases,
                              mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_point(alpha = 0.7, shape = 22, size = 1.5, stroke = 1.5) +
  scale_fill_manual(name = "Country",
                    #breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c("#FF00FF", "#00BFFF", "#00FF00"),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c("#FF00FF", "#00BFFF", "#00FF00"),
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
                      values = c("#FF0000", "#00BFFF", "#FFDB58"),
                      labels = c("GIN", "LBR", "SLE")) +
  ggtitle(label = "Confirmed Ebola") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")
plot_ebola_line_v4

# create column plot
plot_ebola_col_v4 <- ggplot(data = data_ebola_cum_cases,
                            mapping = aes(x = date, y = cum_conf_cases, fill = country, colour = country)) +
  geom_col(alpha = 0.7, linetype = "solid",
           linewidth = 0.1, position = "stack", width = 0.7) +
  scale_fill_manual(name = "Country",
                    breaks = c("Guinea", "Liberia", "Sierra Leone"),
                    values = c("#FF0000", "#00BFFF", "#FFDB58"),
                    labels = c("GIN", "LBR", "SLE")) +
  scale_colour_manual(name = "Country",
                      breaks = c("Guinea", "Liberia", "Sierra Leone"),
                      values = c("#FF0000", "#00BFFF", "#FFDB58"),
                      labels = c("GIN", "LBR", "SLE")) +
  ggtitle(label = "Confirmed Ebola cases") +
  xlab(label = "Time") +
  ylab(label = "Cum. # of confirmed cases")
plot_ebola_col_v4
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
plot_ebola_line_v5

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

###############################  5a ##################################################
# density plots:
insurance <- read.csv("data/raw/insurance_with_date.csv")
insurance <- insurance %>% mutate(children = as.factor(children))

head(insurance)
### test: use chatgpt: --> actually, it is not a histogram!
# Create the histogram
# ggplot(insurance, aes(x = bmi, fill = sex)) +
#   geom_histogram(binwidth = 2, color = "black", alpha = 0.8) +
#   labs(x = "BMI", y = "Count") +
#   scale_fill_manual(values = c("blue", "pink")) +
#   theme_bw()

library(ggplot2)

ggplot(insurance, aes(x = bmi, colour = sex, fill = sex)) +
  geom_density(alpha = 0.4) +
  theme(text = element_text(size = 20), legend.position = "bottom") +
  xlab(expression(paste("BMI (kg/", m^2, ")"))) +
  scale_colour_manual(values = c("female" = "blue", "male" = "red"),
                      labels = c("Female", "Male")) +
  scale_fill_manual(values = c("female" = "blue", "male" = "red"),
                    labels = c("Female", "Male"))

library(ggplot2)

ggplot(insurance, aes(x = age, y = bmi, color = smoker)) +
  #geom_point() +
  geom_quantile() +
  theme(text = element_text(size = 20), legend.position = "top") +
  xlab("Age (years)") +
  ylab(expression(paste("BMI (kg/", m^2, ")"))) +
  scale_colour_manual(name = "", values = c("no" = "red", "yes" = "blue"), labels = c("No", "Yes"))

## what if I change "color" to fill
# it does not work, since I do not have "fills" I believe...

#gitcreds_get()


```{r}
#| label: car-cyl
#| echo: false
mtcars %>%
  distinct(cyl)
```





















