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
#####

#### how to invoke other scripts from master-file:
# Main R script that sources all subsequent R scripts

# source(here("R/01_cleaning.R")) # source() reads R code from a file
# source(here("R/02_analysis.R"))
# source(here("R/03_plotting.R"))


---
  title: "ggplot2 demo"
author: "Norah Jones"
date: "5/22/2021"
format:
  html:
  fig-width: 8
fig-height: 4
code-fold: true
---

  ## Air Quality

  @fig-airquality further explores the impact of temperature
on ozone level.

```{r}
#| label: fig-airquality
#| fig-cap: Temperature and ozone level.
#| warning: false

library(ggplot2)
ggplot(airquality, aes(Temp, Ozone)) +
  geom_point() +
  geom_smooth(method = "loess")
```





