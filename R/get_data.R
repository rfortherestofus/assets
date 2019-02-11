library(tidyverse)
library(here)
library(haven)


# Faketucky ---------------------------------------------------------------



# Faketucky found here: https://github.com/OpenSDP/faketucky


download.file("https://github.com/OpenSDP/faketucky/raw/master/faketucky.rda",
              destfile = here("data", "faketucky.rda"))

load(here("data", "faketucky.rda"))

faketucky_20160923 <- faketucky_20160923 %>% 
  replace(is.na(.), NA) %>% 
  select(chrt_ninth,
         sid,
         first_hs_name,
         first_dist_name,
         first_hs_urbanicity,
         male,
         race_ethnicity,
         frpl_ever_in_hs,
         pct_absent_in_hs,
         avg_gpa_hs,
         dropout,
         hs_diploma,
         enroll_yr1_any) %>% 
  filter(chrt_ninth == 2009) %>% 
  select(-chrt_ninth) %>% 
  set_names(c("Student ID",
              "First High School Attended",
              "School District",
              "High School Urbanicity",
              "Male",
              "Race Ethnicity",
              "Free and Reduced Lunch",
              "Percent Absent",
              "GPA",
              "Dropout",
              "Received High School Diploma",
              "Enrolled in College"))

write_csv(faketucky_20160923, here("data", "faketucky.csv"),
          na = "999")


# Youth Risk Behavior Surveillance System ----------------------------------------

download.file("https://github.com/hadley/yrbss/blob/master/data/survey.rda?raw=true",
              destfile = here("data", "yrbss.rda"))

load(here("data", "yrbss.rda"))



# Civil Rights Data Collection --------------------------------------------

# See https://ocrdata.ed.gov/Home
# Data: https://www2.ed.gov/about/offices/list/ocr/docs/crdc-2015-16.html

crdc <- read_csv(here("data", "crdc-1516.csv"))


# Colleges ----------------------------------------------------------------

devtools::install_github('UrbanInstitute/education-data-package-r')
library(educationdata)

df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE)


# NHANES ------------------------------------------------------------------

# https://cran.r-project.org/web/packages/NHANES/NHANES.pdf

library(NHANES)
data(NHANES) 

str(NHANES)

library(skimr)
NHANES %>% 
  skim()

