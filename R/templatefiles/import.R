### link to ep-tutorial:
#https://epirhandbook.com/en/

#### load the libraries

##load data of handbook:
pacman::p_install_gh("appliedepi/epirhandbook")
pacman::p_load(epirhandbook)
get_data("all")

# more data:

# import the file directly from Github
cleaning_dict <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/case_linelists/cleaning_dict.csv")
#Likert:
# import the file directly from Github
likert_data <- import("https://raw.githubusercontent.com/appliedepi/epirhandbook_eng/master/data/likert_data.csv")
# you may need more data at some point:
#https://epirhandbook.com/en/download-handbook-and-data.html

####

#### set the relative paths using the here-function:
#note: the here function is independent of platform; this is neat!
rd <- here("scripts")
dd <- here("data")
ld <- here("log")
org <-here("orig")
pre <-here("pre_output")
###


############
# #### import using "rio"
# setwd(org)
# ## could this be done w/o setwd???
# legend <- import("Swiss_Cardiology_Registry_SwissCaRe__Form_V1_2023-01-10T19H33M33S__module_legend.txt", fill=TRUE)
# #to lowercase:
# names(legend) <- tolower(names(legend))
# # drop V6 if it exists --> use one_of:
# # the "minus" sign means NOT:
# legend <- legend %>% 
#   select(-one_of("v6"))
# 
# View(legend)
# data <- import("Swiss_Cardiology_Registry_SwissCaRe__Form_V1_2023-01-10T19H33M33S__module.txt")
# #to lowercase:
# names(data) <- tolower(names(data))
# View(data)
####


##### use loop to import all files in directory:
#setwd(here("orig"))
#getwd()
setwd(org)
getwd()
files <- list.files(pattern = "\\.txt$")
View(files)
### this works!!!


#### Loop through the files and import them into R
counter = 0 
for (file in files) {
  counter = counter + 1
  if (grepl("\\legend.txt$",file)) {
    file_type <- "legend"
    legend <- import(file,fill=TRUE)
    
  } else if (grepl("\\module.txt$", file)) {
    file_type <- "data"
    data <- import(file) 
  }  
  
  # names(data) <- tolower(names(data))
  # 
  # data <- data %>% 
  #   select(-one_of("v6"))
  # if (grepl("\\legend.txt$",file)) {
  #   legend <- data
  # }
  
}
#### this works and is a start!



################################################################################
########### I am now following the script
linelist <- import(here("orig", "linelist_cleaned.xlsx"))
# Demonstration: importing a specific Excel sheet when using relative pathways with the 'here' package
linelist_raw <- import(here("orig", "linelist_raw.xlsx"), which = "Sheet 1")  
#note: there is a merged header in the last column --> will be dealt with later

#how to deal with missings:
#linelist <- import(here("data", "my_linelist.xlsx"), na = "99")
#linelist <- import(here("data", "my_linelist.csv"), na = c("Missing", "", " "))

#skipping rows:
linelist_raw2 <- import(here("orig", "linelist_raw.xlsx"), skip = 1)  # does not import header row



#### missing values:
linelist <- import(here("orig", "my_linelist.xlsx"), na = "99")
#--> the value 99 will obtain NA
this file does not exist
go on in handbook, page 
skip rows and create dictionary




