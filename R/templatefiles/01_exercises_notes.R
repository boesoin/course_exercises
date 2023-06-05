#### download if necessary and load the libraries:
pacman::p_load(
  #rio,         # import/export (note, there is also readr)
  here,        # file locator
  usethis,
  gitcreds,    # a set of packages, uses consistent syntax
  tidyverse,
  medicaldata,
  cowplot      # create publication-ready images
)


#### set the relative paths using the here-function:
#note: the here function is independent of platform; this is neat!
rd <- here("scripts")
dd <- here("data")
ld <- here("log")
org <-here("orig")
pre <-here("pre_output")
###

### git 


#################### exercise 2, monday morning

### make factors




###
reformatted <- data |> 
  mutate(
    across(c(sex, region), factor),
    # sex = factor(sex),
    # region = factor(region),
    gt2_children = children > 2,
    smokes = smoker == "yes",
    date_6m = date + months(6)
    # date_6m = date + 30.4 * 6
  )



