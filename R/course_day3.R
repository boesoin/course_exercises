

##### Thursday morning, Ben

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
################
# library(tidyverse)
# data <- read_csv("data/raw/perulung_ems.csv")
# str(data)

data<-mtcars

str(data)
summary(data)


#########
library(gtsummary)
tabl_summary <- data |>
  select(where(is.double)) |>
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean} ({sd})",
                                     "{median} ({p25}, {p75})",
                                     "{min}, {max}")
  )
tabl_summary
###this is soo cool! --> I can easily export it to html /
### I would need hundreds of lines to do this in stata...

#count if(data$am = 1)
qnorm(0.975) # this gives you the exact value, not 1.96!, but 1.959964
qt(,500)
