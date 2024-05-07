library(ggplot2)
library(RColorBrewer)
library(patchwork)
library(tidyr)
library(dplyr)
library(tidyverse)

setwd("~/Ologies_Analysis")

# What's in an Ology: A Breakdown of Ologies Episodes by Category

## Data wrangling

#The dataframe read in here was generated using a python script which can be 
#found in the github. This script was used to parse ologies episodes and 
#extract meaningful information - duration of the episode, type of ology, 
#and date.

df <- read.csv("Ologies_Data.csv")
View(df)

#df <- df[-c(12:14)] #trimming out extraneous columns

ologies <- df[!is.na(df$ology),] #selecting just the episodes with ologies
ologies <- ologies[!is.na(ologies$branch),] #excluding any NAs for branch - this also excludes smologies
View(ologies)

#we want to exclude encores so they aren't counted twice

ologies <- subset(ologies, encore == 0)

#same with part 2 episodes
ologies <- subset(ologies, part_2 == 0)

#final dataframe

dim(ologies)
write.csv(ologies, file = "trimmed_ologies.csv")

ologies <- read.csv(file = "trimmed_ologies.csv")

## What is the most common primary topic of Ologies?

primary2 <- ggplot(data = ologies, aes(primary, fill = primary)) +
  geom_bar(stat = "count", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ggtitle("Ologies episode by primary topic")


primary2

# Transform frequency into a count variable using dplyr

ologies_count <- ologies %>%
  group_by(primary) %>%
  count(primary)

#re order

ologies_count <- as.data.frame(ologies_count)
colnames(ologies_count) <- c("Primary", "Count")

ologies_order <- ologies_count[order(ologies_count$Count),]
ologies_order$Primary <- factor(ologies_order$Primary, levels = ologies_order$Primary)

primary <- ggplot(ologies_order, aes(x = Primary, y = Count, fill = Primary)) + 
  geom_bar(stat = "identity", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  ylab("Number of episodes")+
  xlab("Primary scientific category") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(hjust = 1, vjust = 0.5)) +
  ggtitle("Ologies episodes by primary scientific category")+
  coord_flip()

#Boxplot of episode duration
head(ologies)

ologies_min_order <- ologies[order(ologies$duration_min),]
ologies_min_order$duration_min <- factor(ologies_min_order$duration_min, levels = ologies_min_order$duration_min)

anyDuplicated(ologies_min_order["duration_min"])

#there are duplicates, checking
ologies_min_order %>%
  add_count(duration_min) %>%
  filter(n>1) %>%
  distinct()

#there are 10 duplicates in the min column

ologies_ms_order <- ologies[order(ologies$duration_ms),]
ologies_ms_order$duration_ms <- factor(ologies_ms_order$duration_ms, levels = ologies_ms_order$duration_ms)

ologies_ms_order <- subset(ologies_ms_order, X != 158)
ologies_ms_order <- subset(ologies_ms_order, X != 323)

durationplot <- ggplot(data = ologies_ms_order, aes(x = reorder(primary, -duration_min), y = duration_min, fill = primary)) +
  geom_boxplot(col = "#d397fa", alpha = 0.2) +
  geom_point(col = "#d397fa", alpha = 0.6)+
  theme_minimal() +
  xlab("Primary category") +
  ylab("Episode duration (minutes)") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  theme(legend.position = "none") +
  ggtitle("Duration of Ologies episodes")

durationplot

# Duration with error

ggplot(ologies_ms_order, aes(x = reorder(primary, -duration_min), y = duration_min, fill = primary)) + 
  geom_bar(stat="summary", fun.y="mean", col = "#d397fa", alpha = 0.2) + 
  geom_errorbar(stat="summary", colour = "#d397fa", width = 0.2,
                fun.ymin=function(x) {mean(x)-sd(x)/sqrt(length(x))}, 
                fun.ymax=function(x) {mean(x)+sd(x)/sqrt(length(x))}) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ggtitle("Mean duration of ologies episodes (with error)")

# Types of episodes over the years

ologies[c('Month', 'Day', 'Year')] <- str_split_fixed(ologies$release_date, '/*/', 3)


year <- ggplot(data = ologies, aes(Year, fill = Year)) +
  geom_bar(stat = "count", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ggtitle("How many episodes released per year?")

year

# Are some months more popular?

ologies_countMonth <- ologies %>%
  group_by(Month) %>%
  count(Month)
ologies_countMonth <- as.data.frame(ologies_countMonth)
colnames(ologies_countMonth) <- c("Month", "Count")

ologies_orderMonth <- ologies_countMonth[order(ologies_countMonth$Count),]
ologies_orderMonth$Month <- factor(ologies_countMonth$Count, levels = ologies_countMonth$Count)

month2 <- ggplot(data = ologies_countMonth, aes(Month, Count, fill = Month)) +
  geom_bar(stat = "identity", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ggtitle("Frequency by month")

month2

#rename the months to be actual names

#create month labels

monthNames <- c("July", "August", "December", "April", "June","March", "September", "November", "May", "October")

month <- ggplot(data = ologies, aes(Month, fill = Month)) +
  geom_bar(stat = "count", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  theme(legend.position = "none")+
  scale_x_discrete(limits = c('7','8','12','4','6','3','9','11','5','10'), labels = monthNames)+
  ggtitle("Frequency by month (cumulative)")

month

#split by year

monthNames2 <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

monthyear <- ggplot(data = ologies, aes(Month, fill = Month)) +
  geom_bar(stat = "count", col = "#d397fa", alpha = 0.2)  +
  theme_minimal() +
  facet_wrap(~Year) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  theme(legend.position = "none")+
  scale_x_discrete(limits = c('1', '2', '3','4','5','6','7','8','9','10','11','12'), labels = monthNames2)+
  ggtitle("Frequency by month and year")

monthyear
