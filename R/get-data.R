library(tidyverse)
library(here)
library(haven)
library(janitor)

# Faketucky ---------------------------------------------------------------

# Faketucky found here: https://github.com/OpenSDP/faketucky

download.file("https://github.com/OpenSDP/faketucky/raw/master/faketucky.rda",
              destfile = here("data", "faketucky.rda"))

load(here("data", "faketucky.rda"))



# Messy Names

faketucky_messy_names <- faketucky_20160923 %>% 
  replace(is.na(.), NA) %>% 
  select(chrt_ninth,
         sid,
         first_hs_name,
         first_dist_name,
         male,
         race_ethnicity,
         frpl_ever_in_hs,
         pct_absent_in_hs,
         avg_gpa_hs,
         scale_score_11_read,
         scale_score_11_math,
         hs_diploma,
         enroll_yr1_any) %>% 
  filter(chrt_ninth == 2009) %>% 
  select(-chrt_ninth) %>% 
  set_names(c("Student ID",
              "First High School Attended",
              "School District",
              "Male",
              "Race Ethnicity",
              "Free and Reduced Lunch",
              "Percent Absent",
              "GPA",
              "ACT Reading Score",
              "ACT Math Score",
              "Received High School Diploma",
              "Enrolled in College"))

write_csv(faketucky_messy_names, here("data", "faketucky-messy-names.csv"),
          na = "999")

# Clean Names

faketucky_clean_names <- faketucky_messy_names %>% 
  clean_names()

write_csv(faketucky_clean_names, here("data", "faketucky-clean-names.csv"),
          na = "999")


# Youth Risk Behavior Surveillance System ----------------------------------------

# download.file("https://github.com/hadley/yrbss/blob/master/data/survey.rda?raw=true",
#               destfile = here("data", "yrbss.rda"))
# 
# load(here("data", "yrbss.rda"))



# Civil Rights Data Collection --------------------------------------------

# See https://ocrdata.ed.gov/Home
# Data: https://www2.ed.gov/about/offices/list/ocr/docs/crdc-2015-16.html

# crdc <- read_csv(here("data", "crdc-1516.csv"))


# Colleges ----------------------------------------------------------------

# devtools::install_github('UrbanInstitute/education-data-package-r')
# library(educationdata)
# 
# df <- get_education_data(level = 'schools', 
#                          source = 'ccd', 
#                          topic = 'enrollment', 
#                          by = list('race', 'sex'),
#                          filters = list(year = 2008,
#                                         grade = 9:12,
#                                         ncessch = '340606000122'),
#                          add_labels = TRUE)


# NHANES ------------------------------------------------------------------

# https://cran.r-project.org/web/packages/NHANES/NHANES.pdf

library(NHANES)
library(xlsx)

data(NHANES)

nhanes_selected_vars <- NHANES %>% 
  select(ID:Height, 
         BMI, 
         HealthGen, 
         DaysPhysHlthBad, 
         DaysMentHlthBad,
         SleepHrsNight,
         PhysActive,
         PhysActiveDays,
         TVHrsDay,
         SmokeNow) %>% 
  select(-c(HHIncomeMid, AgeMonths, Poverty, HomeRooms, Length, HeadCirc, Race3))

write_csv(nhanes_selected_vars, here("data", "nhanes.csv"))

# Make codebook

nhanes_vars <- nhanes_selected_vars %>% 
  names()

nhanes_vars_clean_names <- nhanes_selected_vars %>% 
  clean_names() %>% 
  names()

nhanes_codebook <- 
  tibble(variable_name = nhanes_vars,
         variable_name_clean = nhanes_vars_clean_names) %>% 
  mutate(description = c(
    "Participant identifier.",
    "Which survey the participant participated in.",
    "Gender (sex) of study participant coded as male or female",
    "Age in years at screening of study participant. Note: Subjects 80 years or older were recorded
as 80.",
    "Categorical variable derived from age with levels 0-9, 10-19, . . . 70+",
    "Reported race of study participant: Mexican, Hispanic, White, Black, or Other",
    "Educational level of study participant Reported for participants aged 20 years or older.
One of 8thGrade, 9-11thGrade, HighSchool, SomeCollege, or CollegeGrad.",
    "Marital status of study participant. Reported for participants aged 20 years or older.
One of Married, Widowed, Divorced, Separated, NeverMarried, or LivePartner (living
with partner).",
    "Total annual gross income for the household in US dollars. One of 0 - 4999,
5000 - 9,999, 10000 - 14999, 15000 - 19999, 20000 - 24,999, 25000 - 34999,
    35000 - 44999, 45000 - 54999, 55000 - 64999, 65000 - 74999, 75000 - 99999, or
    100000 or More.",
    "One of Home, Rent, or Other indicating whether the home of study participant or someone in their family is owned, rented or occupied by some other arrangement.",
    "Self-reported work status for participants aged 16 years or older. One of Working, NotWorking or Looking.",
    "Weight in kg",
    "Standing height in cm. Reported for participants aged 2 years or older",
    "Body mass index (weight/height2 in kg/m2). Reported for participants aged 2 years or older",
    "Self-reported rating of participant’s health in general Reported for participants aged 12
years or older. One of Excellent, Vgood, Good, Fair, or Poor.",
    "Self-reported number of days participant’s physical health was not good out of
the past 30 days. Reported for participants aged 12 years or older.",
    "Self-reported number of days participant’s mental health was not good out of
the past 30 days. Reported for participants aged 12 years or older",
    "Self-reported number of hours study participant usually gets at night on weekdays
or workdays. Reported for participants aged 16 years and older",
    "Participant does moderate or vigorous-intensity sports, fitness or recreational activities
(Yes or No). Reported for participants 12 years or older.",
    "Number of days in a typical week that participant does moderate or vigorousintensity activity. Reported for participants 12 years or older.",
    "Number of hours per day on average participant watched TV over the past 30 days. Reported for participants 2 years or older. One of 0_to_1hr, 1_hr, 2_hr, 3_hr, 4_hr, More_4_hr.
Not available 2009-2010.",
    "Study participant currently smokes cigarettes regularly. Reported for participants aged
20 years or older as Yes or No, provided they answered Yes to having somked 100 or more
cigarettes in their life time. All subjects who have not smoked 100 or more cigarettes are listed
as NA here."
  ))


write_csv(nhanes_codebook, here("data", "nhanes-codebook.csv"))
