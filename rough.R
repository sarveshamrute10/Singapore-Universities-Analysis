library(dplyr)
library(ggplot2)
#data_e = read.csv("datasets\\employment_data1.csv")
data_e <- readRDS("datasets/employment_data.rds")
head(data_e)
unique(data_e[2])
#data_g = read.csv("datasets\\graduate_data1.csv")
data_g <- readRDS("datasets/graduate_data.rds")
head(data_g)
count(unique(data_g[4]))  

library(ggplot2)
library(ggridges)

ggplot(data_e, 
       aes(x = employment_rate_overall, 
           y = university, 
           fill = university)) +
  geom_density_ridges() + 
  theme_ridges() +
  labs("Highway mileage by auto class") +
  theme(legend.position = "none")

data_e = read.csv("datasets\\employment_data1.csv")
head(data_e)
cleveland_data <- data_e %>%
  group_by(school) %>%
  summarise(employment = (employment_rate_overall))
head(cleveland_data)

ggplot(data_g, aes(x = year, y = intake)) +
  geom_point(aes(colour = graduates)) + # Points and color by group
  scale_color_discrete("Groups") +  # Change legend title
  xlab("Variable X") +              # X-axis label
  ylab("Variable Y")  +             # Y-axis label
  theme(axis.line = element_line(colour = "black", # Changes the default theme
                                 size = 0.24))
