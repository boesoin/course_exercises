
#### this r-script loads the data and does preprocessing.


#### download if necessary and load the libraries:
pacman::p_load(
  rio,         # import/export
  here,        # file locator
  usethis,
  gitcreds,
  tidyverse,  # collection of packages...
  medicaldata,
  cowplot,
  Hmisc,
  #ggpmisc,
  renv, # --> lock file with info on environment
  riskCommunicator # contains data of the Frammingham-Study
)
######

####################################################################################
##################### do some analysis and create graphs  ##########################
#### I have my database called db

# ### set all variables to lower script:
# https://www.codingprof.com/how-to-change-the-case-of-column-names-in-r-examples/
# my_df <- data.frame(NAME = c("Peter", "Ana", "John"),
#                     AGE = c(32, 41, 28),
#                     SALARY = c(35000, 50000, 31000))
# my_df
#
# names(my_df) <- tolower(names(my_df))
# my_df
###this is complicated...
names(db) <- tolower(names(db))
str(db)
#### set to lower-case

####### A) I want to create my table 1 for the registry-report ########################

## label the variable sex:



library(gtsummary)
db |>
  dplyr::select(sex, age, bmi, cursmoke, prevhyp, diabetes,) |>
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean} ({sd})",
                                     "{median} ({p25}, {p75})",
                                     "{min}, {max}")
  )
  kable()





