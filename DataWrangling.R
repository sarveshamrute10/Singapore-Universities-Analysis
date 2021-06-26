library(dplyr)
library(tidyr)
library(tidyverse)
library(reshape)
library(reshape2)
library(purrr)

data_e <- read.csv("datasets\\employment_data.csv",stringsAsFactors = FALSE)

# Checking whether any column has different values from expected
unique(data_e[c("year")])
unique(data_e[c("university")])
unique(data_e[c("degree")])
unique(data_e[c("employment_rate_overall")])
unique(data_e[c("employment_rate_ft_perm")])
unique(data_e[c("basic_monthly_mean")])
unique(data_e[c("basic_monthly_median")])
unique(data_e[c("gross_monthly_mean")])
unique(data_e[c("gross_monthly_median")])
unique(data_e[c("gross_mthly_25_percentile")])
unique(data_e[c("gross_mthly_75_percentile")])

# converting na to NA (since NA in R)
data_e[data_e == "na"] <- NA

# checking number of na values in total and in each column
table(is.na(data_e))
sapply(data_e, function(x)
  sum(is.na(x)))

# converting NA schools with respective degree
SUTD <- data_e %>% filter(is.na(school)) %>% mutate(school = sub("\\).*", "", sub(".*\\(", "", .$degree))) %>%
  mutate(degree = gsub("\\s*\\([^\\)]+\\)", "", .$degree))
SUTD

# Remove the original rows, and update them with the cleaned ones
data_e[data_e$university == "Singapore University of Technology and Design", ] <-
  NA
data_e <- rbind(data_e, SUTD)
data_e <- drop_na(data_e)
data_e

# since all schools in SMU are labeled with (4 year program)
# we will remove them using regex
SMU <- data_e %>%
  filter(university == "Singapore Management University") %>%
  mutate(school = gsub("\\s*\\([^\\)]+\\)", "", .$school))
# Remove the original rows, and update them with the cleaned ones
data_e[data_e$university == "Singapore Management University", ] <-
  NA
data_e <- rbind(data_e, SMU)
data_e <- drop_na(data_e)

# Converting college name College of Business (Nanyang Business School)
# to Nanyang Business School only
NBS <- data_e %>%
  filter(school == "College of Business (Nanyang Business School)") %>%
  mutate(school = sub("\\).*", "", sub(".*\\(", "", .$school)))
# Remove the original rows, and update them with the cleaned ones
data_e[data_e$school == "College of Business (Nanyang Business School)", ] <-
  NA
data_e <- rbind(data_e, NBS)
data_e <- drop_na(data_e)

# drop unused levels
data_e <- droplevels(data_e)

#checking school names
uni <- unique(data_e$university)
sch_list <- list()
for (u in 1:length(uni)) {
  sch <- unique(data_e[data_e$university == uni[u],]$school)
  sch_list[[u]] <- sch
}
sch_list

# 1. NTU: Sports Science and Management & Sport Science and Management
data_e[data_e$school == "Sports Science and Management", "school"] <-
  "Sport Science and Management"

# 2. NUS:
data_e[data_e$school == "Faculty Of Dentistry", "school"] <-
  "Faculty of Dentistry"
data_e[data_e$school == "Faculty Of Engineering", "school"] <-
  "Faculty of Engineering"
data_e[data_e$school == "Multidisciplinary Programme", "school"] <-
  "Multidisciplinary Programmes"
data_e[data_e$school == "Multidisciplinary Program", "school"] <-
  "Multidisciplinary Programmes"
data_e[data_e$school == "Multi-Disciplinary Programme", "school"] <-
  "Multidisciplinary Programmes"
data_e[data_e$school == "YST Conservatory Of Music", "school"] <-
  "Yong Siew Toh Conservatory of Music"
data_e[data_e$school == "Yong Loo Lin School (Medicine)", "school"] <-
  "YLL School of Medicine"
data_e[data_e$school == "School of Design and Environment", "school"] <-
  "School of Design & Environment"

# 3. SIT

data_e[data_e$school == "Singapore Institute of Technology (SIT)", "school"] <-
  "Singapore Institute of Technology"
data_e[data_e$school == "Singapore Institute of Technology -Trinity College Dublin", "school"] <-
  "Trinity College Dublin"
data_e[data_e$school == "Singapore Institute of Technology -Trinity College Dublin / Trinity College Dublin", "school"] <-
  "Trinity College Dublin"
data_e[data_e$school == "SIT-Trinity College Dublin / Trinity College Dublin", "school"] <-
  "Trinity College Dublin"
data_e[data_e$school == "SIT-University of Glasgow", "school"] <-
  "University of Glasgow"
data_e[data_e$school == "Trinity College Dublin / Singapore Institute of Technology-Trinity College Dublin", "school"] <-
  "Trinity College Dublin"


# 4. SMU

data_e[data_e$university == "Singapore Management University",]$degree <-
  sub("[[:blank:]]\\([[:digit:]].*\\)", "", data_e[data_e$university == "Singapore Management University",]$degree)
data_e[data_e$university == "Singapore Management University",]$degree <-
  as.character(sub("\\)", "", sub("\\(", "", data_e[data_e$university == "Singapore Management University",]$degree)))

# update the levels again
data_e <- droplevels(data_e)

# check the na count again
sapply(data_e, function(x)
  sum(is.na(x)))

## Transform factor variables into numeric
data_e <- data_e %>% modify_at(c(5:12), as.numeric)

## Check data
str(data_e)

## Save as .rds extension for Shiny
saveRDS(data_e, file = "datasets\\employment_data.rds")

# write the output
write.csv(data_e, "employment_data1.csv", row.names = FALSE)

#########################################
#Wrangling of Graduates Dataset
data_g <- read.csv("datasets\\graduate_data.csv")
head(data_g)
str(data_g)


## Check NAs
table(is.na(data_g))
sapply(data_g, function(x)
  sum(is.na(x)))


## Transform value column from character into numeric variable
data_g <- transform(data_g, graduates=as.numeric(graduates))
data_g <- transform(data_g, enrolment=as.numeric(enrolment))
str(data_g)


## Save as .rds extension for Shiny
saveRDS(data_g, file = "datasets\\graduate_data.rds")
write.csv(data_g, file="datasets\\graduate_data1.csv")
