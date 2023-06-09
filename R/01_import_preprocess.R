
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
##################### use data and do some data-wrangling ##########################
#### move this part out of quarto eventually!


###
# Framingham heart study data
fram <- riskCommunicator::framingham

# We keep only the baseline examination data
db <- subset(fram, TIME == 0)

###################### inspect the file
str(db)
head(db)
colnames(db)
tail(db)
summary(db)
######################

################## create a variable clinic 1 2, label "my clinic" and "all other clinics"

### stable sorting of data:
db <- arrange_all(db)
### the code works, I think it produces the same ordering each time. should be tested


# generate variable clinic:
db$clinic <- 2
db$clinic

# Count the number of rows in the data frame
row_count <- nrow(db)
print(paste("Number of rows in db:", row_count))
## thank you ChatGTP!
# Identify the indices of every 13th row
indices <- seq(13, row_count, by = 13)


# Replace the corresponding values in the 'clinic' variable with 2
db$clinic[indices] <- 1
db$clinic
table(db$clinic)

# Label the 'clinic' variable
db <- db %>%
  mutate(clinic = case_when(
    clinic == 1 ~ "my clinic",
    clinic == 2 ~ "all other clinics",
    TRUE ~ as.character(clinic)  # Retain other values as is
  ))
# the code above is from ChatGPT --> there must be easier ways!!?
table(db$clinic)
############################################################################






