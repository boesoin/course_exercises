## https://clanfear.github.io/Stata_R_Equivalency/docs/r_stata_commands.html


#
pacman::p_load(
  rio,         # import/export
  here,        # file locator
  usethis,
  gitcreds,
  tidyverse,  # collection of packages...
  medicaldata,
  cowplot,
  #Hmisc,
  #ggpmisc,
  renv, # --> lock file with info on environment
  riskCommunicator, # contains data of the Frammingham-Study
  quarto
)
getwd()
here()

db <- mtcars

### overview of data-set:
View(db)
summary(db)
str(db)
###
## rename:
db<- rename(db,weight = wt)
str(db)
###

###drop
db<-select(db,-gear)
###

### create data and using "create when":
mean_vec <- c("x" = 1.0, "y" = 2.0, "z" = 3.0)
cov_mat <- rbind(c(1.0, .75, 1.0),
                 c(.75, 1.5, 0.0),
                 c(1.0, 0.0, 2.0))
example_data <- data.frame(MASS::mvrnorm(300,
                                         mu = mean_vec,
                                         Sigma = cov_mat,
                                         empirical = TRUE))
#--> we now have a data-frame with x,y, and z


#### change data:
example_data <- example_data %>%
  mutate(x_z = x * z) %>%
  mutate(x_disc =
           case_when(
             x < .5 ~ 1,
             x > .5 & x < 1.5 ~ 2,
             x > 1.5 ~ 3
           ))
# case_when() does seuqential ifelse() statements but is much more readable.



